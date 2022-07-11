#! /bin/sh

echo "Welcome! Let's start setting up your system. It could take more than 10 minutes, be patient"

sh -c "$(wget -O - https://teejeetech.com/scripts/jammy/install_nala | bash)"

echo "Upgrading built-in applications"
sudo nala update && sudo nala upgrade

echo "What name do you want to use in GIT user.name?"
echo "For example, mine will be \"Danillo Ilggner\""
read git_config_user_name

echo "What email do you want to use in GIT user.email?"
echo "For example, mine will be \"danilloilggner@gmail.com\""
read git_config_user_email

echo "What is your github username?"
echo "For example, mine will be \"danilloism\""
read username

cd ~

echo 'Installing neofetch' 
sudo nala install neofetch -y

echo 'Installing git' 
sudo nala install git -y

echo "Setting up your git global user name and email"
git config --global user.name "$git_config_user_name"
git config --global user.email $git_config_user_email

echo 'Generating a SSH Key'
ssh-keygen -t rsa -b 4096 -C $git_config_user_email
ssh-add ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub | xclip -selection clipboard

echo 'Installing FiraCode'
sudo nala install fonts-firacode -y

echo 'Installing private codecs'
sudo nala install ubuntu-restricted-extras -y

echo 'Installing Rust'
sh -c "$(curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh)"

echo 'Installing NVM' 
sh -c "$(curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash)"

source ~/.bashrc
clear

echo 'Installing NodeJS LTS'
nvm --version
nvm install --lts
nvm current

echo 'Installing NodeJS latest version'
nvm install node

echo 'Setting NodeJS latest version as default'
nvm alias default node

echo 'Installing pnpm'
npm i --location=global pnpm
pnpm setup

source ~/.bashrc

echo 'Installing Yarn, Typescript, NestJS CLI and AdonisJS CLI'
pnpm add -g yarn typescript @nestjs/cli @adonisjs/cli

echo 'Installing VSCode'
wget -O vscode.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
sudo dpkg -i vscode.deb
sudo nala install -f -y && rm vscode.deb

echo 'Android Studio'
sudo snap install android-studio --classic

echo 'Installing Flutter'
sudo snap install flutter --classic
source ~/.bashrc
# flutter doctor --android-licenses
flutter doctor -v

echo 'Launching Vivaldi on Github so you can paste your keys'
vivaldi https://github.com/settings/keys </dev/null >/dev/null 2>&1 & disown

echo 'Installing Docker'
sudo nala purge docker docker-engine docker.io docker-compose containerd runc -y
sudo -- sh -c "$(curl -fsSL https://get.docker.com -o get-docker.sh | ebash)"
sudo systemctl start docker
sudo systemctl enable docker
docker --version
sudo groupadd docker
sudo usermod -aG docker $USER
sudo chmod 777 /var/run/docker.sock

echo 'Installing docker-compose'
sudo nala install docker-compose
docker-compose --version

echo 'Installing Postman' 
sudo snap install postman

echo 'Installing VLC'
sudo nala install vlc -y

echo 'Installing Discord'
wget -O discord.deb "https://discordapp.com/api/download?platform=linux&format=deb"
sudo dpkg -i discord.deb
sudo nala install -f -y && rm discord.deb

echo 'Installing Spotify' 
curl -sS https://download.spotify.com/debian/pubkey_5E3C45D7B312C643.gpg | sudo apt-key add - 
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo nala update && sudo nala install spotify-client -y

echo 'Installing OBS Studio'
sudo nala install ffmpeg -y && sudo snap install obs-studio

echo 'Enabling KVM for Android Studio'
sudo nala install qemu-kvm libvirt-clients libvirt-daemon-system bridge-utils virt-manager -y
sudo adduser $USER libvirt
sudo adduser $USER libvirt-qemu

echo 'Updating and Cleaning Unnecessary Packages'
sudo -- sh -c 'nala update; nala upgrade -y; apt full-upgrade -y; nala autoremove -y; apt autoclean -y; nala clean; apt clean'
clear

echo 'Installing postgis container'
docker run --name postgis -e POSTGRES_PASSWORD=docker -p 5432:5432 -d kartoza/postgis

echo 'Installing mongodb container'
docker run --name mongodb -p 27017:27017 -d -t mongo

echo 'Installing redis container'
docker run --name redis_skylab -p 6379:6379 -d -t redis:alpine
clear

echo 'Bumping the max file watchers'
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p

echo 'Generating GPG key'
gpg --full-generate-key
gpg --list-secret-keys --keyid-format LONG

echo 'Paste the GPG key ID to export and add to your global .gitconfig'
read gpg_key_id
git config --global user.signingkey $gpg_key_id
gpg --armor --export $gpg_key_id

echo 'All setup, enjoy!'
