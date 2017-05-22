package main

import (
    "log"
    "net/http"
    "os"
    "github.com/zpatrick/fireball"
    "github.com/garyburd/redigo/redis"
)

var (
    redisProtocol = "tcp"
    redisAddress = os.Getenv("REDIS_ADDRESS_AND_PORT")
)

func listEntries(c *fireball.Context) (fireball.Response, error) {
    conn, err := redis.Dial(redisProtocol, redisAddress)
    if err != nil {
        log.Fatal(err)
    }
    defer conn.Close()

    entries, _ := redis.Strings(conn.Do("LRANGE", "entries", 0, -1))
    return c.HTML(200, "index.html", entries)
}

func addEntry(c *fireball.Context) (fireball.Response, error) {
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
                "GET": listEntries,
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

