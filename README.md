## Play Online
https://mataclysm.itch.io/accelerant

### Feature Requests
Initial development is complete.
Comment on the itch page above to report any game-breaking bugs.

## Requirements
- Install [Godot Engine 4.2.1](https://godotengine.org/download/windows/)
- Install [Butler](https://itch.io/docs/butler/installing.html)

## Build
```
godot_console.exe --headless --export-release "Windows Desktop" --quiet 2>$null
godot_console.exe --headless --export-release "Web" --quiet 2>$null
```

## Publish
```
butler push C:\Users\matte\Documents\Games\Accelerant\Windows\ mataclysm/Accelerant:windows
butler push C:\Users\matte\Documents\Games\Accelerant\Web\ mataclysm/Accelerant:html
```

## Host Web Build Locally
```
dotnet tool install --global dotnet-serve
dotnet serve --directory C:\Users\matte\Documents\Games\Accelerant\Web\ -h "Cross-Origin-Opener-Policy: same-origin" -h "Cross-Origin-Embedder-Policy: require-corp" -h "Access-Control-Allow-Origin: *" --open-browser
```

## Other
### Save file location
`C:\Users\matte\AppData\Roaming\Accelerant\save.tres`
