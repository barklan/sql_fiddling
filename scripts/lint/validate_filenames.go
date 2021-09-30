package main

import (
	"flag"
	"fmt"
	"os"
	"path/filepath"
	"regexp"
	"strings"
)

type fullFileInfo struct {
	path string
	name string
}

func getFilenamesToCheck() []fullFileInfo {
	fileList := []fullFileInfo{}

	reExclude := regexp.MustCompile(`vendor|\.git|\.cache`)
	reInclude := regexp.MustCompile(`.*\.py$|.*\.go$|.*\.sql$`)

	err := filepath.Walk(".", func(path string, f os.FileInfo, err error) error {
		if !reExclude.MatchString(path) && reInclude.MatchString(path) {
			file := fullFileInfo{path, f.Name()}
			fileList = append(fileList, file)
		}

		return nil
	})
	if err != nil {
		panic(err)
	}

	return fileList
}

func checkFilename(file fullFileInfo) error {
	if file.name != strings.ToLower(file.name) ||
		strings.Contains(file.name, " ") ||
		strings.Contains(file.name, "-") {
		return fmt.Errorf("filename %v is invalid (full path: %v)"+
			"\nit contains either uppercase characters, spaces or hyphens",
			file.name, file.path)
	}

	return nil
}

func main() {
	var reExclude, reInclude string

	flag.StringVar(&reExclude, "e", "", "regex to exclude")
	flag.StringVar(&reInclude, "i", "", "regex to include")

	flag.Parse()

	if reExclude == "" || reInclude == "" {
		panic("Please specify both matching and excluding regex.")
	}

	filesToCheck := getFilenamesToCheck()
	for _, file := range filesToCheck {
		err := checkFilename(file)
		if err != nil {
			panic(err)
		}
	}
}
