# Code Examples From The 'Making Games With NES' book

Me just going through [Steven Hugg's book][4], sans the need to use the [8bitworkshop web IDE][5].  The book makes use of [Shiru's NESlib][6] and the examples here use [Steven Hugg's fork of a modified version by clbr][7].

## Building the Examples

I use the assembler/linker provided by the [cc65 compiler][1].  Before compiling on Debian-based distros (or, on Windows via WSL), ensure you have the below packages installed:

```bash
sudo apt install cc65 build-essential
```

Each example will have to be compiled individually.  Just execute `make` within the directory of the example's corresponding make file.  You can execute `make run` to launch your compiled NES rom using FCEUX. If on Debian-based system, download the latest version from the [FCEUX website][8] instead of using the very old version provided by your package manager.  With that said, the examples should run on any emulator, including [Mesen][9].

## Editing

Not a requirement, but the code editor I use is [Visual Studio Code][2] with the Cole Campbell's [language support extension][3].  To install Visual Studio Code on Debian-based distros, execute:

```bash
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt update -y && sudo apt upgrade -y
sudo apt install apt-transport-https
sudo apt update -y
sudo apt install code
echo -e "export DOTNET_CLI_TELEMETRY_OPTOUT=1" >> ~/.bashrc
source ~/.bashrc
```

[1]: https://cc65.github.io/index.html
[2]: https://code.visualstudio.com
[3]: https://github.com/tlgkccampbell/code-ca65
[4]: https://www.amazon.com/gp/product/1075952727/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=1075952727&linkCode=as2&tag=pzp-20&linkId=633176e8b36fea7f927020e2c322d80a
[5]: https://8bitworkshop.com/
[6]: https://shiru.untergrund.net/
[7]: https://github.com/sehugg/neslib
[8]: https://ci.appveyor.com/api/projects/zeromus/fceux/artifacts/fceux-2.4.0-amd64.deb?branch=master&job=Ubuntu
[9]: https://mesen.ca/
