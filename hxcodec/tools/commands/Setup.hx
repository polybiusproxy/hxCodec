package hxcodec.tools.commands;

class Setup implements ICommand {
    static final WINDOWS_NIGHTLIES_URL = "https://artifacts.videolan.org/vlc/nightly-win64/20230223-0428/vlc-4.0.0-dev-win64-0801b577.zip";

    var verbose:Bool = false;

    public function new(verbose:Bool) {
        this.verbose = verbose;
    }

    public function perform(args:Array<String>):Void {

    }

    function downloadFileToTemp(url:String, name:String) {
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