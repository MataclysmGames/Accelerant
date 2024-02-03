```
#   _____  _____ ___  ___    ______  _   _  _      _____  _____ 
#  |_   _||  _  ||  \/  |    | ___ \| | | || |    |  ___|/  ___|
#    | |  | | | || .  . |    | |_/ /| | | || |    | |__  \ `--. 
#    | |  | | | || |\/| |    |    / | | | || |    |  __|  `--. \
#    | |  \ \_/ /| |  | |    | |\ \ | |_| || |____| |___ /\__/ /
#    \_/   \___/ \_|  |_/    \_| \_| \___/ \_____/\____/ \____/ 
#
```
# Play Online
https://mataclysm.itch.io/accelerant

# Requirements
## Install Godot Engine
This project was created using Godot Engine 4.2.1

## Install Butler
https://itch.io/docs/butler/installing.html

# Build
## Windows Desktop
```
godot.exe --headless --export-release "Windows Desktop" -q
```

## Web
```
godot.exe --headless --export-release "Web" -q
```

# Test
## Windows
Run the project

## Web
### Install dotnet serve
```
dotnet tool install --global dotnet-serve
```

### Run HTML5 Godot project locally (Optional --open-browser)
```
dotnet serve --directory C:\Users\matte\Documents\Games\Accelerant\Web\ -h "Cross-Origin-Opener-Policy: same-origin" -h "Cross-Origin-Embedder-Policy: require-corp" -h "Access-Control-Allow-Origin: *" --open-browser
```

# Publish
## Upload Windows game
```
butler push C:\Users\matte\Documents\Games\Accelerant\Windows\ mataclysm/Accelerant:windows
```

## Upload Web game
```
butler push C:\Users\matte\Documents\Games\Accelerant\Web\ mataclysm/Accelerant:html`
```

# Other
## Save file location
`C:\Users\[username]\AppData\Roaming\Accelerant\save.tres`
