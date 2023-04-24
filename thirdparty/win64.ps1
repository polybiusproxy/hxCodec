$url = "https://artifacts.videolan.org/vlc/nightly-win64/20230403-0430/vlc-4.0.0-dev-win64-e8b6a932.zip"
$haxelibpath = $args[0]
write-host "Downloading $url"
write-host "hxcodec location: $haxelibpath"
$output = "$haxelibpath/thirdparty/winDebug.zip"
Invoke-WebRequest -Uri $url -OutFile $output