from std/os import createDir, joinPath, pcFile, walkDir

import std/strformat
import std/terminal
from common import getFileNames, getSavePath


proc printFileContent(folderPath: string, fileName: string) =
    let f = open(joinPath(folderPath, fileName), fmRead)

    defer: f.close()

    stdout.write(f.readAll())


proc command*() =
    let folderPath = getSavePath()

    createDir(folderPath)

    let files = getFileNames(folderPath)

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
        var previousText = (if notFirstPage: "; 'b' to go to back" else: "")

        let notLastPage = fileIndex + 1 < files.len()
        var nextText = (if notLastPage: "; 'n' to go to next" else: "")

        stdout.styledWriteLine(fgYellow,
                &"\nViewing snippet {fileIndex + 1} of {files.len()}; 'q' to quit{nextText}{previousText}: ")

        while true:

            let k = getch()

            case k
                of 'q':
                    stdout.write("\n")
                    quit(0)
                of 'n':
                    if notLastPage:
                        fileIndex += 1
                of 'b':
                    if notFirstPage:
                        fileIndex -= 1
                else:
                    break
            break

