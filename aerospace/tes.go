package main

import (
	"fmt"
	"time"
)

func main() {
	ch1 := make(chan string)
	ch2 := make(chan string)
	// 1. Select über receive - blockiert bis Nachricht eintrifft
	go func() {
		time.Sleep(100 * time.Millisecond)
		ch1 <- "Nachricht von ch1"
	}()

	select {
	case msg := <-ch1:
		fmt.Println("Empfangen:", msg)
	case msg := <-ch2:
		fmt.Println("Empfangen:", msg)
	}

	// 2. Select mit Timeout über receive
	select {
	case msg := <-ch2:
		fmt.Println("Empfangen:", msg)
	case <-time.After(50 * time.Millisecond):
		fmt.Println("Timeout beim Empfangen")
	}

	// 3. Select mit default über receive - non-blocking
	select {
	case msg := <-ch2:
		fmt.Println("Empfangen:", msg)
	default:
		fmt.Println("Kein Empfang möglich")
	}

	// 4. Select über send - wartet bis senden möglich
	ch3 := make(chan string, 1) // buffered channel
	select {
	case ch3 <- "Nachricht 1":
		fmt.Println("Gesendet an ch3")
	case ch2 <- "Nachricht 2":
		fmt.Println("Gesendet an ch2")
	}

	// 5. Select mit Timeout über send
	ch4 := make(chan string) // unbuffered channel
	select {
	case ch4 <- "Nachricht":
		fmt.Println("Gesendet")
	case <-time.After(50 * time.Millisecond):
		fmt.Println("Timeout beim Senden")
	}

	// 6. Select mit default über send - non-blocking
	select {
	case ch4 <- "Nachricht":
		fmt.Println("Gesendet")
	default:
		fmt.Println("Senden nicht möglich")
	}
}
	my_channel := make(chan string, 2)
	my_channel <- "Erste Nachricht"
	my_channel <- "Zweite Nachricht"
	close(my_channel)
	for msg := range my_channel {
		fmt.Println(msg)
	}
