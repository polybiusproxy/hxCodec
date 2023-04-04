import haxe.io.Bytes;
import sys.FileSystem;
import sys.io.File;

class Run
{
  static function main()
  {
    if (!FileSystem.exists("./thirdparty/winDebug.zip")) Sys.command("powershell", ["thirdparty/win64.ps1"]);
    FileSystem.createDirectory("./temp");
    Zip.unzip("./thirdparty/winDebug.zip", "./temp");

    Run.copyPasteShit("./temp/vlc-4.0.0-dev/plugins", "./thirdparty");
    Run.copyPasteShit("./temp/vlc-4.0.0-dev/libvlc.dll", "./thirdparty/libvlc.dll");
    Run.copyPasteShit("./temp/vlc-4.0.0-dev/libvlccore.dll", "./thirdparty/libvlccore.dll");

    // cleanup stuff

    Run.deleteDirRecursively("./temp");

    FileSystem.deleteDirectory("./temp");

    hxcodec.tools.Main.main();
  }

  private static function copyPasteShit(path:String, dest:String)
  {
    if (!FileSystem.exists(path))
    {
      trace("file " + path + " dont exist!");
      return;
    }

    if (FileSystem.isDirectory(path))
    {
      copyFolder(path, "./thirdparty");
      return;
    }

    var input:Bytes = File.getBytes(path);
    File.saveBytes(dest, input);
  }

  private static function copyFolder(sourcePath:String, destinationPath:String):Void
  {
    var sourceFiles:Array<String> = FileSystem.readDirectory(sourcePath);
    for (sourceFile in sourceFiles)
    {
      var fileName:String = sourceFile;
      var destinationFile:String = destinationPath + "/" + fileName;
      if (FileSystem.isDirectory(sourceFile))
      {
        FileSystem.createDirectory(destinationFile);
        copyFolder(sourceFile, destinationFile);
      }
      else
      {
        // FileSystem.copyFile(sourceFile, destinationFile);
      }
    }
  }

  private static function deleteDirRecursively(path:String):Void
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
            if (path != "") trace("created " + path);
            continue; // was just a directory
          }
          path += file;
          trace("unzip " + path);

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
