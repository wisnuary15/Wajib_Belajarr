package main

import "fmt"

func main() {
	var a = 10
	var b = 10
	var d = 5 
	var e = 2
	var c = a + b - d * e
	fmt.Println(c) // Output: 0

	var i = 10
	i += 10
	fmt.Println(i) // Output: 20

	i += 5
	fmt.Println(i) // Output: 25

	var j = 1
	j++
	fmt.Println(j) // Output: 2
	j++
	fmt.Println(j) // Output: 3
}
