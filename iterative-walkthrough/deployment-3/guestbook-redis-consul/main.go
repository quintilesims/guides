package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"

	"github.com/garyburd/redigo/redis"
	"github.com/zpatrick/fireball"
)

type ConsulService struct {
	ID                       string
	Node                     string
	Address                  string
	Datacenter               string
	TaggedAddresses          map[string]string
	NodeMeta                 map[string]string
	ServiceID                string
	ServiceName              string
	ServiceTags              []string
	ServiceAddress           string
	ServicePort              int
	ServiceEnableTagOverride bool
	CreateIndex              int
	ModifyIndex              int
}

var (
	redisProtocol = "tcp"
	serviceName   = os.Getenv("SERVICE_TO_QUERY")
)

func getServiceAddress(serviceName string) (string, error) {
	c := http.Client{}
	resp, err := c.Get("http://localhost:8500/v1/catalog/service/" + serviceName)
	if err != nil {
		return "", err
	}

	body, err := ioutil.ReadAll(resp.Body)
	resp.Body.Close()
	if err != nil {
		return "", err
	}

	var services []ConsulService
	err = json.Unmarshal(body, &services)
	if err != nil {
		return "", err
	}

	var serviceAddress string
	for _, service := range services {
		if service.ServiceName == serviceName {
			serviceAddress = fmt.Sprintf("%s:%d", service.ServiceAddress, service.ServicePort)
		}
	}

	if serviceAddress == "" {
		return "", fmt.Errorf("Unable to resolve address for service '%s'", serviceName)
	}

	return serviceAddress, nil
}

func listEntries(c *fireball.Context) (fireball.Response, error) {
	redisAddress, err := getServiceAddress(serviceName)
	if err != nil {
		log.Fatal(err)
	}

	conn, err := redis.Dial(redisProtocol, redisAddress)
	if err != nil {
		log.Fatal(err)
	}
	defer conn.Close()

	entries, _ := redis.Strings(conn.Do("LRANGE", "entries", 0, -1))
	return c.HTML(200, "index.html", entries)
}

func addEntry(c *fireball.Context) (fireball.Response, error) {
	redisAddress, err := getServiceAddress(serviceName)
	if err != nil {
		log.Fatal(err)
	}

	conn, err := redis.Dial(redisProtocol, redisAddress)
	if err != nil {
		log.Fatal(err)
	}
	defer conn.Close()

	entry := c.Request.FormValue("entry")
	conn.Do("LPUSH", "entries", entry)
	return fireball.Redirect(301, "/"), nil
}

func clearEntries(c *fireball.Context) (fireball.Response, error) {
	redisAddress, err := getServiceAddress(serviceName)
	if err != nil {
		log.Fatal(err)
	}

	conn, err := redis.Dial(redisProtocol, redisAddress)
	if err != nil {
		log.Fatal(err)
	}
	defer conn.Close()

	conn.Do("DEL", "entries")
	return fireball.Redirect(301, "/"), nil
}

func main() {

	routes := []*fireball.Route{
		{
			Path: "/",
			Handlers: fireball.Handlers{
				"GET":  listEntries,
				"POST": addEntry,
			},
		},
		{
			Path: "/clear",
			Handlers: fireball.Handlers{
				"POST": clearEntries,
			},
		},
	}

	routes = fireball.Decorate(routes, fireball.LogDecorator())
	app := fireball.NewApp(routes)

	log.Println("Listening on :80")
	log.Fatal(http.ListenAndServe(":80", app))
}
