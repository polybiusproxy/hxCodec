package hxcodec.tools.commands;

import sys.io.Process;
import haxe.Rest;
import haxe.io.Bytes;
import sys.FileSystem;
import sys.io.File;

class Setup
{
  static final WINDOWS_NIGHTLIES_URL = "https://artifacts.videolan.org/vlc/nightly-win64/20230223-0428/vlc-4.0.0-dev-win64-0801b577.zip";

  public function new() {}

  @:defaultCommand
  public function perform(args:Rest<String>):Void
  {
    // Main.print(args);

    if (args.length == 0)
    {
      Main.print("no arguments given for setup command");
      return;
    }

    switch (args[0])
    {
      case "windows":
        setupWindows();
      default:
        Main.print("unknown command");
    }
  }

  private function setupWindows()
  {
    var libpath:Process = new Process("haxelib", ["libpath", "hxcodec"]);
    var libString:String = libpath.stdout.readLine();

    if (!FileSystem.exists(libString + "thirdparty/winDebug.zip")) Sys.command("powershell", ["thirdparty/win64.ps1", libString]);
    FileSystem.createDirectory(libString + "temp");
    Zip.unzip(libString + "thirdparty/winDebug.zip", libString + "temp");

    copyPasteShit(libString + "temp/vlc-4.0.0-dev/plugins", libString + "thirdparty/dll/vlc/Windows");
    copyPasteShit(libString + "temp/vlc-4.0.0-dev/libvlc.dll", libString + "thirdparty/dll/vlc/Windows/libvlc.dll");
    copyPasteShit(libString + "temp/vlc-4.0.0-dev/libvlccore.dll", libString + "thirdparty/dll/vlc/Windows/libvlccore.dll");

    // cleanup stuff

    deleteDirRecursively(libString + "temp");

    FileSystem.deleteDirectory(libString + "temp");
  }

  private function copyPasteShit(path:String, dest:String)
  {
    var libpath:Process = new Process("haxelib", ["libpath", "hxcodec"]);
    var libString:String = libpath.stdout.readLine();

    if (!FileSystem.exists(path))
    {
      Main.print("file " + path + " dont exist!");
      return;
    }

    if (FileSystem.isDirectory(path))
    {
      copyFolder(path, dest);
      return;
    }

    var input:Bytes = File.getBytes(path);
    File.saveBytes(dest, input);
  }

  private function copyFolder(sourcePath:String, destinationPath:String):Void
  {
    var sourceFiles:Array<String> = FileSystem.readDirectory(sourcePath);
    for (sourceFile in sourceFiles)
    {
      var fileName:String = sourceFile;
      var destinationFile:String = destinationPath + "/" + fileName;

      if (FileSystem.isDirectory(sourcePath + "/" + sourceFile))
      {
        FileSystem.createDirectory(destinationFile);
        copyFolder(sourcePath + "/" + sourceFile, destinationFile);
      }
      else
      {
        Main.print(sourcePath);
        Main.print(sourceFile);
        var input:Bytes = File.getBytes(sourcePath + "/" + sourceFile);
        File.saveBytes(destinationPath + "/" + sourceFile, input);
        // FileSystem.copyFile(sourceFile, destinationFile);
      }
    }
  }

  private function deleteDirRecursively(path:String):Void
  {
    if (!sys.FileSystem.exists(path) || !sys.FileSystem.isDirectory(path)) return;

    var entries = sys.FileSystem.readDirectory(path);
    for (entry in entries)
    {
      if (sys.FileSystem.isDirectory(path + '/' + entry))
      {
        deleteDirRecursively(path + '/' + entry);
        sys.FileSystem.deleteDirectory(path + '/' + entry);
      }
      else
      {
        sys.FileSystem.deleteFile(path + '/' + entry);
      }
    }
  }
}

class Zip
{
  public static function unzip(_path:String, _dest:String, ignoreRootFolder:String = "")
  {
    var _in_file = sys.io.File.read(_path);
    var _entries = haxe.zip.Reader.readZip(_in_file);

    _in_file.close();

    for (_entry in _entries)
    {
      var fileName = _entry.fileName;
      if (fileName.charAt(0) != "/" && fileName.charAt(0) != "\\" && fileName.split("..").length <= 1)
      {
        var dirs = ~/[\/\\]/g.split(fileName);
        if ((ignoreRootFolder != "" && dirs.length > 1) || ignoreRootFolder == "")
        {
          if (ignoreRootFolder != "")
          {
            dirs.shift();
          }

          var path = "";
          var file = dirs.pop();
          for (d in dirs)
          {
            path += d;
            sys.FileSystem.createDirectory(_dest + "/" + path);
            path += "/";
          }

          if (file == "")
          {
            if (path != "") Main.print("created " + path);
            continue; // was just a directory
          }
          path += file;
          Main.print("unzip " + path);

          var data = haxe.zip.Reader.unzip(_entry);
          var f = File.write(_dest + "/" + path, true);
          f.write(data);
          f.close();
        }
      }
    } // _entry

    Sys.println('');
    Sys.println('unzipped successfully to ${_dest}');
  } // unzip
}
