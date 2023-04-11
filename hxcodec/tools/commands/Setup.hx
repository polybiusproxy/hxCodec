package hxcodec.tools.commands;

import haxe.io.Bytes;
import sys.FileSystem;
import sys.io.File;

class Setup implements ICommand
{
  static final WINDOWS_NIGHTLIES_URL = "https://artifacts.videolan.org/vlc/nightly-win64/20230223-0428/vlc-4.0.0-dev-win64-0801b577.zip";

  var verbose:Bool = false;

  public function new(verbose:Bool)
  {
    this.verbose = verbose;
  }

  public function perform(args:Array<String>):Void
  {
    if (!FileSystem.exists("./thirdparty/winDebug.zip")) Sys.command("powershell", ["thirdparty/win64.ps1"]);
    FileSystem.createDirectory("./temp");
    Zip.unzip("./thirdparty/winDebug.zip", "./temp");

    copyPasteShit("./temp/vlc-4.0.0-dev/plugins", "./thirdparty");
    copyPasteShit("./temp/vlc-4.0.0-dev/libvlc.dll", "./thirdparty/libvlc.dll");
    copyPasteShit("./temp/vlc-4.0.0-dev/libvlccore.dll", "./thirdparty/libvlccore.dll");

    // cleanup stuff

    deleteDirRecursively("./temp");

    FileSystem.deleteDirectory("./temp");
  }

  private function copyPasteShit(path:String, dest:String)
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
        trace(sourcePath);
        trace(sourceFile);
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

  function downloadFileToTemp(url:String, name:String)
  {
    /*
      var tempDir = File.systemTempDirectory;
      var tempFile = tempDir.resolvePath(name);
      var request = new URLRequest(url);
      var stream = new FileStream();
      stream.open(tempFile, FileMode.WRITE);
      var loader = new URLLoader();
      loader.dataFormat = URLLoaderDataFormat.BINARY;
      loader.addEventListener(Event.COMPLETE, function(e:Event) {
          stream.writeBytes(loader.data);
          stream.close();
          trace("Downloaded " + name + " to " + tempFile.nativePath);
      });
      loader.load(request);
     */
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
