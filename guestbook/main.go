package main

import (
	"github.com/zpatrick/fireball"
	"log"
	"net/http"
)

var entries []string

func listEntries(c *fireball.Context) (fireball.Response, error) {
	return c.HTML(200, "index.html", entries)
}

func addEntry(c *fireball.Context) (fireball.Response, error) {
	entry := c.Request.FormValue("entry")
	entries = append(entries, entry)
	return fireball.Redirect(301, "/"), nil
}

func clearEntries(c *fireball.Context) (fireball.Response, error) {
	entries = []string{}
	return fireball.Redirect(301, "/"), nil
}

func main() {
	entries = []string{}

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
