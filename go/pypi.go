package main

import (
	"os"
	"fmt"
	"github.com/PuerkitoBio/goquery"
)

func main() {

	url := os.Args[1]

	doc, _ := goquery.NewDocument(url)

	// nth-child(5) because 0.193 is the 5th child of #breadcrumb, no matter the type "a"
	version := doc.Find("#breadcrumb a:nth-child(5)").Text()

	fmt.Println(version)

}

