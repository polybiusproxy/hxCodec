$url = "https://artifacts.videolan.org/vlc/nightly-win64/20230403-0430/vlc-4.0.0-dev-win64-e8b6a932.zip"
$output = "./thirdparty/winDebug.zip"
Invoke-WebRequest -Uri $url -OutFile $output