from std/os import createDir, joinPath, pcFile, walkDir
from std/algorithm import sorted, SortOrder

import std/strformat
import std/terminal

import nimclipboard/libclipboard

from common import clearScreen, getFileNames, getSavePath, sortStringsByNumber


var
    files: seq[string] = @[]


proc readSnippet(folderPath: string, fileName: string): string =
    let f = open(joinPath(folderPath, fileName), fmRead)

    defer: f.close()

    return f.readAll()


proc printContent(content: string): void =
    stdout.write(content)


proc refreshSnippets(folderPath: string): void =
    createDir(folderPath)

    files = sorted(getFileNames(folderPath), sortStringsByNumber,
            SortOrder.Ascending)

    if files.len() == 0:
        echo "History is empty; nothing to show."
        quit(0)


proc copyText(cb: ptr clipboard_c, text: string): bool =
    return cb.clipboard_set_text(text)


proc command*(): void =
    let folderPath = getSavePath()

    refreshSnippets(folderPath)

    if files.len() == 0:
        echo "History is empty; nothing to show."
        quit(0)

    if terminal.isTrueColorSupported():
        terminal.enableTrueColors()

    terminal.eraseScreen()

    var fileIndex = 0

    var cb = clipboard_new(nil)

    while true:
        clearScreen()

        let content = readSnippet(folderPath, files[fileIndex])
        printContent(content)

        let notFirstPage = fileIndex > 0
        let previousText = (if notFirstPage: "; 'b' to go to back" else: "")

        let notLastPage = fileIndex + 1 < files.len()
        let nextText = (if notLastPage: "; 'n' to go to next" else: "")

        stdout.styledWriteLine(fgYellow,
                &"\nViewing {fileIndex + 1} of {files.len()}; 'q' to quit; 'c' to copy; 'r' to refresh{nextText}{previousText}: ")

        while true:
            let k = getch()

            if k == 'q':
                stdout.write("\n")
                quit(0)

            elif k == 'n':
                if notLastPage:
                    fileIndex += 1
                    break

            elif k == 'b':
                if notFirstPage:
                    fileIndex -= 1
                    break

            elif k == 'r':
                refreshSnippets(folderPath)

                if files.len() - 1 < fileIndex:
                    fileIndex = files.len() - 1
                break

            elif k == 'c':
                discard copyText(cb, content)

