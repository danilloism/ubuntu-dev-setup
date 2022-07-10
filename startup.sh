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
nvm alias default 18

echo 'Installing pnpm'
npm i -g pnpm

# echo 'Installing Yarn'


# echo 'Installing Typescript, AdonisJS CLI and Lerna'
# yarn global add typescript @adonisjs/cli lerna
# clear

echo 'Installing VSCode'
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt-get install apt-transport-https -y
sudo apt-get update && sudo apt-get install code -y

echo 'Launching Vivaldi on Github so you can paste your keys'
vivaldi https://github.com/settings/keys </dev/null >/dev/null 2>&1 & disown

echo 'Installing Docker'
sudo apt-get purge docker docker-engine docker.io
sudo apt-get install docker.io -y
sudo systemctl start docker
sudo systemctl enable docker
docker --version

sudo groupadd docker
sudo usermod -aG docker $USER
sudo chmod 777 /var/run/docker.sock

echo 'Installing docker-compose'
sudo curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version

echo 'Installing Heroku CLI'
curl https://cli-assets.heroku.com/install-ubuntu.sh | sh
heroku --version

echo 'Installing PostBird'
wget -c https://github.com/Paxa/postbird/releases/download/0.8.4/Postbird_0.8.4_amd64.deb
sudo dpkg -i Postbird_0.8.4_amd64.deb
sudo apt-get install -f -y && rm Postbird_0.8.4_amd64.deb

echo 'Installing Insomnia Core and Omni Theme' 
echo "deb https://dl.bintray.com/getinsomnia/Insomnia /" \
  | sudo tee -a /etc/apt/sources.list.d/insomnia.list
wget --quiet -O - https://insomnia.rest/keys/debian-public.key.asc \
  | sudo apt-key add -
sudo apt-get update && sudo apt-get install insomnia -y
mkdir ~/.config/Insomnia/plugins && cd ~/.config/Insomnia/plugins
git clone https://github.com/Rocketseat/insomnia-omni.git omni-theme && cd ~

echo 'Installing Android Studio'
sudo add-apt-repository ppa:maarten-fonville/android-studio -y
sudo apt-get update && sudo apt-get install android-studio -y

echo 'Installing VLC'
sudo apt-get install vlc -y
sudo apt-get install vlc-plugin-access-extra libbluray-bdj libdvdcss2 -y

echo 'Installing Discord'
wget -O discord.deb "https://discordapp.com/api/download?platform=linux&format=deb"
sudo dpkg -i discord.deb
sudo apt-get install -f -y && rm discord.deb

echo 'Installing Zoom'
wget -c https://zoom.us/client/latest/zoom_amd64.deb
sudo dpkg -i zoom_amd64.deb
sudo apt-get install -f -y && rm zoom_amd64.deb

echo 'Installing Spotify' 
curl -sS https://download.spotify.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt-get update && sudo apt-get install spotify-client -y

echo 'Installing Peek' 
sudo add-apt-repository ppa:peek-developers/stable -y
sudo apt-get update && sudo apt-get install peek -y

echo 'Installing OBS Studio'
sudo apt-get install ffmpeg && sudo snap install obs-studio

echo 'Enabling KVM for Android Studio'
sudo apt-get install qemu-kvm libvirt-clients libvirt-daemon-system bridge-utils virt-manager -y
sudo adduser $USER libvirt
sudo adduser $USER libvirt-qemu

echo 'Installing Robo3t'
sudo snap install robo3t-snap

echo 'Installing Lotion'
sudo git clone https://github.com/puneetsl/lotion.git /usr/local/lotion
cd /usr/local/lotion && sudo ./install.sh

echo 'Updating and Cleaning Unnecessary Packages'
sudo -- sh -c 'apt-get update; apt-get upgrade -y; apt-get full-upgrade -y; apt-get autoremove -y; apt-get autoclean -y'
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
