# Play Online
https://mataclysm.itch.io/accelerant

# Build
## Local Windows Build
Open the project in Godot Engine and Run

## Local Web Build
### Install dotnet serve
```
dotnet tool install --global dotnet-serve
```

### Run HTML5 Godot project locally (Optional --open-browser)
```
cd C:\Users\matte\Documents\Games\Accelerant\
dotnet serve --directory .\Web\ -h "Cross-Origin-Opener-Policy: same-origin" -h "Cross-Origin-Embedder-Policy: require-corp" -h "Access-Control-Allow-Origin: *" --open-browser
```

# Publish
## Install Butler
https://itch.io/docs/butler/installing.html

## Export Windows and Web build from Godot Engine
Project -> Export -> Export All

## Upload Windows game
```
cd C:\Users\matte\Documents\Games\Accelerant\
butler push .\Windows\ mataclysm/Accelerant:windows
```

## Upload Web game
```
cd C:\Users\matte\Documents\Games\Accelerant\
butler push .\Web\ mataclysm/Accelerant:html
```

# Other
## Save file location
C:\Users\[username]\AppData\Roaming\Accelerant\save.tres
