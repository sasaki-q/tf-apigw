package main

import "time"

func currentTimestamp() string {
	tz, _ := time.LoadLocation("Asia/Tokyo")
	return time.Now().In(tz).Format(time.RFC3339)
}
