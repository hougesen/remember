from std/os import createDir, joinPath

import std/times
from common import getSavePath

import nimclipboard/libclipboard


proc command*() =
    let content = clipboard_new(nil).clipboard_text()

    if content.len() == 0:
        echo "Clipboard is empty; nothing to save."
        quit(0)

    let timestamp = times.now().utc.toTime().toUnix()

    let folderPath = getSavePath()

    createDir(folderPath)

    let f = open(joinPath(folderPath, $timestamp), fmWrite)

    defer: f.close()

    f.writeLine(content)
