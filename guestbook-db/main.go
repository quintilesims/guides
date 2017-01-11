package main

import (
	"os"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/guregu/dynamo"
	"github.com/zpatrick/fireball"
	"log"
	"net/http"
	"time"
)

var table dynamo.Table

type Entry struct {
	ID      string `dynamo:"id"`
	Message string `dynamo:"message"`
}

func getEntries() ([]Entry, error) {
	var entries []Entry
	if err := table.Scan().All(&entries); err != nil {
		return nil, err
	}

	return entries, nil
}

func listEntries(c *fireball.Context) (fireball.Response, error) {
	entries, err := getEntries()
	if err != nil {
		return nil, err
	}

	return c.HTML(200, "index.html", entries)
}

func addEntry(c *fireball.Context) (fireball.Response, error) {
	entry := Entry{
		ID:      time.Now().Format(time.UnixDate),
		Message: c.Request.FormValue("entry"),
	}

	if err := table.Put(entry).Run(); err != nil {
		return nil, err
	}

	return fireball.Redirect(301, "/"), nil
}

func clearEntries(c *fireball.Context) (fireball.Response, error) {
	entries, err := getEntries()
	if err != nil {
		return nil, err
	}

	for _, e := range entries {
		if err := table.Delete("id", e.ID).Run(); err != nil {
			return nil, err
		}
	}

	return fireball.Redirect(301, "/"), nil
}

func main() {
	name := os.Getenv("DYNAMO_TABLE")
	if name == ""{
		log.Fatal("DYNAMO_TABLE not set!")
	}

	db := dynamo.New(session.New(), nil)
	table = db.Table(name)

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

	log.Println("Listening on :9090")
	log.Fatal(http.ListenAndServe(":9090", app))
}
