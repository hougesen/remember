from std/os import createDir, joinPath, pcFile, walkDir
from std/algorithm import sorted, SortOrder

import std/strformat
import std/terminal

from common import getFileNames, getSavePath, sortStringsByNumber

var
    files: seq[string] = @[]


proc printFileContent(folderPath: string, fileName: string) =
    let f = open(joinPath(folderPath, fileName), fmRead)

    defer: f.close()

    stdout.write(f.readAll())


proc refreshSnippets(folderPath: string) =
    createDir(folderPath)

    files = sorted(getFileNames(folderPath), sortStringsByNumber,
            SortOrder.Ascending)

    if files.len() == 0:
        echo "History is empty; nothing to show."
        quit(0)


proc command*() =
    let folderPath = getSavePath()

    refreshSnippets(folderPath)

    if files.len() == 0:
        echo "History is empty; nothing to show."
        quit(0)

    if terminal.isTrueColorSupported():
        terminal.enableTrueColors()

    terminal.eraseScreen()

    var fileIndex = 0

    while true:
        stdout.write("\n")

        terminal.eraseScreen(stdout)

        printFileContent(folderPath, files[fileIndex])

        let notFirstPage = fileIndex > 0
        let previousText = (if notFirstPage: "; 'b' to go to back" else: "")

        let notLastPage = fileIndex + 1 < files.len()
        let nextText = (if notLastPage: "; 'n' to go to next" else: "")

        stdout.styledWriteLine(fgYellow,
                &"\nViewing snippet {fileIndex + 1} of {files.len()}; 'q' to quit{nextText}{previousText}; 'r' to refresh: ")

        while true:
            let k = getch()

            if k == 'q':
                stdout.write("\n")
                quit(0)

            elif k == 'n':
                if notLastPage:
                    fileIndex += 1

            elif k == 'b':
                if notFirstPage:
                    fileIndex -= 1

            elif k == 'r':
                refreshSnippets(folderPath)

                if files.len() - 1 < fileIndex:
                    fileIndex = files.len() - 1

            break

