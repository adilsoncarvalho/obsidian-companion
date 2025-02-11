package constants

import "fmt"

const (
	AppName        = "obsidian-companion"
	AppVersion     = "0.1.0"
	AppVersionName = "padawan"
)

func VersionString() string {
	return fmt.Sprintf("%s %s (%s)", AppName, AppVersion, AppVersionName)
}
