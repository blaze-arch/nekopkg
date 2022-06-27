import parsecfg
import os
import zippy/ziparchives

const install_directory = "$HOME/installed_pkgs/"

proc install_pkg(pkgname: string) =
    if (not dirExists(install_directory)):
        createDir(install_directory)

    if (fileExists(install_directory & pkgname)):
        echo "Package already installed (^ω^)"
        echo "Do you wanna reinstall this package?? [Y/N]"
        let command = stdin.readLine()
        if (command == "Y" or command == "y"):
            echo "Reinstalling package..."
        else:
            quit(QuitSuccess)

    try:
        extractAll(pkgname, "./tmp/")
        #echo "Extracting package, please wait..."
    except:
        echo "Error! Can't extract package! :("
        quit(QuitFailure)

    try:
        removeFile("./tmp/package.ini")
        copyDir("./tmp/", install_directory)
        removeDir("./tmp/")
        copyFile("./" & pkgname, install_directory & pkgname)
    except:
        echo "Error! Can't install package! :("
        quit(QuitFailure)

    echo "Package Installed! (￣▽￣)"
    quit(QuitSuccess)

proc info_pkg(pkgname: string) =
    try:
        extractAll(pkgname, "./tmp/")
        echo "Extracting package, please wait..."
    except:
        echo "Error! Can't extract package! :("
        quit(QuitFailure)

    try:
        copyDir("./tmp/", install_directory)
    except:
        echo "Error! Can't read package! :("
        quit(QuitFailure)

    try:
        discard loadConfig("./tmp/package.ini")
    except:
        echo "Can't load package.ini :("
        removeDir("./tmp/")
        quit(QuitFailure)

    let dict = loadConfig("./tmp/package.ini")
    let pname = dict.getSectionValue("Package", "name")
    let pdesc = dict.getSectionValue("Package", "description")
    let pver = dict.getSectionValue("Package", "version")

    echo "Package Name: " & pname
    echo "Package Description: " & pdesc
    echo "Package Version: " & pver

    removeDir("./tmp/")

    quit(QuitSuccess)

proc find_pkgs(search_string: string) = echo "In development, sorry :("
proc update_pkg_base() = echo "In development, sorry :("
proc update_all_pkgs() = echo "In development, sorry :("

if paramCount() != 2:
    echo "USAGE:"
    echo "  nekopkg [command] [package]"
    echo ""
    echo "  -S      install package"
    echo "  -I      info about package"
    echo "  -Ss     search package"
    echo "  -Sy     update package base (and install package)"
    echo "  -Su     update all packages (and install package)"
    echo "  -Syu    update all (and install package)"
    quit(QuitSuccess)
else:
    let command = paramStr(1)

    let package = paramStr(2)

    case command:
        of "-S":
            if package != "":
                install_pkg(package)
            else:
                echo "what package u want???"
        of "-I":
            if package != "":
                info_pkg(package)
            else:
                echo "what package u want???"
        of "-Su":
            if package != "":
                update_all_pkgs()
                install_pkg(package)
            else:
                update_all_pkgs()
        of "-Sy":
            if package != "":
                update_pkg_base()
                install_pkg(package)
            else:
                update_pkg_base()
        of "-Syu":
            if package != "":
                update_pkg_base()
                update_all_pkgs()
                install_pkg(package)
        of "-Ss":
            find_pkgs(package)
        else:
            echo "Unknown command! :("
