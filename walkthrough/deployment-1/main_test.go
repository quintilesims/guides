package main

import (
	"net/http"
	"os"
	"testing"

	"github.com/quintilesims/tftest"
)

func TestWalkthroughOne(t *testing.T) {
	vars := map[string]string{}

	if endpoint := os.Getenv("LAYER0_API_ENDPOINT"); endpoint != "" {
		vars["endpoint"] = endpoint
	}

	if token := os.Getenv("LAYER0_AUTH_TOKEN"); token != "" {
		vars["token"] = token
	}
	context := tftest.NewTestContext(t,
		tftest.Vars(vars))

	context.Apply()
	defer context.Destroy()

	endpoint := context.Output("guestbook_url")
	resp, err := http.Get(endpoint)
	if err != nil {
		t.Fatal(err)
	}

	// TODO: Need some sort of wait here before checking the status code
	if resp.StatusCode != 200 {
		t.Fatalf("Response code not 200")
	}
}
