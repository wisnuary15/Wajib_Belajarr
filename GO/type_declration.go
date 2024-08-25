package main

import "fmt"

func main(){
	type NoKTP string

	var ktpWisnu = "12345"

	var contoh string = "222222"
	var contohKtp NoKTP = NoKTP(contoh)

	fmt.Println(ktpWisnu)
	fmt.Println(contohKtp)
}