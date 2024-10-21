#! /bin/bash
function InstallationEssensials {
    if [[ -n "$UserExisting" ]]
    then
      echo "That user already exists, please choose another one"
    else
      sudo apt-get update
      sudo apt install tmux
      sudo apt install default-jre-headless
      sudo useradd -r -U -d /usr/local/games/minecraft_server/ -s /usr/sbin/nologin "$NameServer"
      sudo mkdir -p /usr/local/games/minecraft_server/Java/
      sudo chown -R "$NameServer": /usr/local/games/minecraft_server/
      chmod +x StartServer.sh
      SettingTheServer
    fi
}

function InitialConfirmations {
   read -r -p "Do you wish to install this program with root privileges? If not, the script will end :Yes or No" Validation
   case $Validation in
        [Yy]* ) echo "Ok, we will proceed";;
        [Nn]* ) echo "exiting...";;
        * ) echo "Please answer yes or no.";;
   esac
   read -r -p "Please insert the name of your Users servers: " NameServer
   UserExisting=$(sudo cat /etc/group | cut -d ":" -f 1 | grep "$NameServer")
   InstallationEssensials
}

function SettingTheServer {
 #Isolating this installation to playgg
  cd tmp/
  curl -SsL https://playit-cloud.github.io/ppa/key.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/playit.gpg >/dev/null
  echo "deb [signed-by=/etc/apt/trusted.gpg.d/playit.gpg] https://playit-cloud.github.io/ppa/data ./" | sudo tee /etc/apt/sources.list.d/playit-cloud.list
  sudo apt update sudo apt install playit
  wget https://github.com/playit-cloud/playit-agent/releases/download/v0.15.0/playit-linux-amd64
  chmod +x playit-linux-amd64
 #Isolating now for the Server installation
  wget https://piston-data.mojang.com/v1/objects/59353fb40c36d304f2035d51e7d6e6baa98dc05c/server.jar
  sudo cp * /usr/local/games/minecraft_server/Java
  sudo cp ../StartServer.sh /usr/local/games/minecraft_server
  sudo su - minecraft -s /bin/bash
}
InitialConfirmations

