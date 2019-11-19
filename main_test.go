package main

import (
	"net/http"
	"net/http/httptest"
	"regexp"
	"testing"
)

func TestTellTheTime(t *testing.T) {
	req, err := http.NewRequest("GET", "/", nil)
	if err != nil {
		t.Fatal(err)
	}

	rr := httptest.NewRecorder()
	handler := http.HandlerFunc(tellTheTime)
	handler.ServeHTTP(rr, req)

	if status := rr.Code; status != http.StatusOK {
		t.Errorf("handler returned wrong status code: got %v want %v",
			status, http.StatusOK)
	}

	// Check the response body is what we expect.
	rx := "[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z"
	m, err := regexp.MatchString(rx, rr.Body.String())
	if err != nil {
		t.Fatal(err)
	}
	if !m {
		t.Errorf("handler returned unexpected body: %v does not match %v",
			rr.Body.String(), rx)
	}
}
