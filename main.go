package main

import (
	"fmt"
	"net/http"
	"time"
)

func main() {
	http.HandleFunc("/", tellTheTime)
	http.ListenAndServe(":3000", nil)
}

func tellTheTime(w http.ResponseWriter, req *http.Request) {
	fmt.Fprintf(w, "⏰\tIt is now exactly: %v\n", time.Now().Format(time.RFC3339))
}
