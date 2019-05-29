// App engine app
package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
)

// indexHandler responds to requests with our greeting.
// http.Request - incoming HTTP request
// http.ResponseWriter - assembles the HTTP server response - send data to webbrowser
func indexHandler(w http.ResponseWriter, r *http.Request) {
	if r.URL.Path != "/" {
			http.NotFound(w, r)
			return
	}
	fmt.Fprint(w, "Hello, World!")
}

// entry point of your executable program
func main() {
	http.HandleFunc("/", indexHandler)

	port := os.Getenv("PORT")
	if port == "" {
			port = "8080"
			log.Printf("Defaulting to port %s", port)
	}

	log.Printf("Listening on port %s", port)
	log.Fatal(http.ListenAndServe(fmt.Sprintf(":%s", port), nil))
}