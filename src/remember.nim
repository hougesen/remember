from std/os import paramCount, paramStr

from history import nil
from save import nil


when isMainModule:
    if paramCount() == 0:
        quit(0)

    case paramStr(1)
        of "save":
            save.command()

        of "history":
            history.command()

        else:
            echo("Unknown command: ", paramStr(1))
            quit(1)
