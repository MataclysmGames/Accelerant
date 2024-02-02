# Play Online
https://mataclysm.itch.io/accelerant

# Build
## Install dotnet serve
`dotnet tool install --global dotnet-serve`

## Run HTML5 Godot project locally (Optional --open-browser)
`cd C:\Users\matte\Documents\Games`

`dotnet serve --directory .\Accelerant\Web\ -h "Cross-Origin-Opener-Policy: same-origin" -h "Cross-Origin-Embedder-Policy: require-corp" -h "Access-Control-Allow-Origin: *" --open-browser`

# Publish
## Install Butler
https://itch.io/docs/butler/installing.html

## Upload Windows game
`cd C:\Users\matte\Documents\Games`

`butler push .\Accelerant\Windows\ mataclysm/Accelerant:windows`

## Upload Web game
`cd C:\Users\matte\Documents\Games`

`butler push .\Accelerant\Web\ mataclysm/Accelerant:html`

# Other
## Save file location
`C:\Users\[username]\AppData\Roaming\Accelerant\save.tres`
