godot_console.exe --headless --export-release "Windows Desktop" --quiet 2>$null
godot_console.exe --headless --export-release "Web" --quiet 2>$null

butler push C:\Users\matte\Documents\Games\Accelerant\Windows\ mataclysm/Accelerant:windows
butler push C:\Users\matte\Documents\Games\Accelerant\Web\ mataclysm/Accelerant:html
