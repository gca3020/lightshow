package main

import (
	"fmt"
	"image/color"
	"os"
	"time"

	"github.com/gca3020/adalight"
	"github.com/gca3020/adalight/effects"
	"github.com/godbus/dbus/v5"
)

func main() {
	monitor()
}

func monitor() {
	conn, err := dbus.SessionBus()
	if err != nil {
		fmt.Println("Failed to connect to session bus:", err)
		os.Exit(1)
	}
	defer conn.Close()

	light := adalight.New("/dev/ttyUSB0", 115200, 106)

	var rules = []string{
		"type='method_call',member='Notify',path='/org/freedesktop/Notifications',destination='org.freedesktop.Notifications'",
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
		if v.Headers[dbus.FieldMember].Value().(string) == "Notify" {
			fmt.Println("Notification received")
			light.Run(effects.NewRamp(color.NRGBA{R: 0xFF, A: 0xFF}, time.Second))
		}
	}
}
