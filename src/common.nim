from std/os import pcFile, walkDir, getHomeDir, joinPath

proc getFileNames*(folderPath: string): seq[string] =
    var files: seq[string] = @[]

    for (kind, n) in walkDir(folderPath, true, true):
        if pcFile == kind:
            files.add(n)

    return files


proc getSavePath*(): string =
    return joinPath(getHomeDir(), ".remember")
