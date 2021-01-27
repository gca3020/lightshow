package main

import (
	"fmt"
	"os"

	"github.com/godbus/dbus/v5"
)

func main() {
	fmt.Println("Hello, world")

	conn, err := dbus.SessionBus()
	if err != nil {
		fmt.Println("Failed to connect to session bus:", err)
		os.Exit(1)
	}
	defer conn.Close()

	var rules = []string{
		"type='signal',member='Notify',path='/org/freedesktop/Notifications',destination='org.freedesktop.Notifications'",
		"type='method_call',member='Notify',path='/org/freedesktop/Notifications',destination='org.freedesktop.Notifications'",
		"type='method_return',member='Notify',path='/org/freedesktop/Notifications',destination='org.freedesktop.Notifications'",
		"type='error',member='Notify',path='/org/freedesktop/Notifications',destination='org.freedesktop.Notifications'",
	}
	var flag uint = 0

	call := conn.BusObject().Call("org.freedesktop.DBus.Monitoring.BecomeMonitor", 0, rules, flag)
	if call.Err != nil {
		fmt.Println("Failed to become monitor:", call.Err)
		os.Exit(1)
	}

	c := make(chan *dbus.Message, 10)
	conn.Eavesdrop(c)
	fmt.Println("Monitoring notifications")
	for v := range c {
		fmt.Println(v)
	}
}
