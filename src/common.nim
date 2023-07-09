from std/os import pcFile, walkDir, getHomeDir, joinPath
from std/strutils import parseInt


proc getFileNames*(folderPath: string): seq[string] =
    var files: seq[string] = @[]

    for (kind, n) in walkDir(folderPath, true, true):
        if pcFile == kind:
            files.add(n)

    return files


func getSavePath*(): string =
    return joinPath(getHomeDir(), ".remember")


func sortStringsByNumber*(a: string, b: string): int =
    let aInt: int64 = parseInt(a)
    let bInt: int64 = parseInt(b)

    if aInt > bInt:
        return 1

    return -1
