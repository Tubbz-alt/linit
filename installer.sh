# This will make a few changes to a newly installed GNU/Linux system
# This has been tested on a Debian based distro(Ubuntu 18.04.3)
# It uses (the) bash
# Most commands are written line by line to enable easy commenting out of
# whatever a user doesn't need
# Feel free to edit and add whatever you like
#!/bin/bash

# Get updates
update_system () {
sudo apt update -y && sudo apt upgrade -y
sudo dpkg --configure -a
sudo apt install -y -f

}
add_ppas () {
# add a few useful repositories
# Boot-repair, things will go wrong and you'll need this at some point
sudo add-apt-repository -y ppa:yannubuntu/boot-repair && yes | sudo apt update
sudo add-apt-repository -y ppa:noobslab/macbuntu && yes | sudo apt update
sudo add-apt-repository -y ppa:linrunner/tlp
sudo add-apt-repository -y  'deb https://dl.winehq.org/wine-builds/ubuntu/ bionic main' && yes | sudo apt update
}
install_tweakers () {

sudo apt install -y  boot-repair ubuntu-restricted-extras unity-tweak-tool gnome-tweak-tool gnome-shell vlc tlp tlp-rdw caffeine plank macbuntu-os-icons-v1804 macbuntu-os-ithemes-v1804 macbuntu-os-plank-theme-v1804 vim
# choose themes with tweak tool.
}
install_browsers (){
# sudo apt install -y firefox; Just update
# Add Chrome
pushd ~/Downloads
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
rm *.deb
sudo dpkg --configure -a
popd
}
start_programs () {
sudo tlp start
sudo ufw enable
}

install_rpy () {
sudo apt install -y snapd
yes | sudo snap install pycharm-community --classic
# install R 4.0 and RStudio(1.2.1335)
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
sudo add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran40/'
sudo apt install -y r-base
# install rstudio 1.2.5042
sudo apt  install -y libx11-dev libxt-dev libclang-dev -f
wget https://download1.rstudio.org/desktop/trusty/amd64/rstudio-1.2.5042-amd64.deb
yes | sudo dpkg -i rstudio-1.2.5042-amd64.deb
# Fix issues with dependencies
sudo apt install -y -f
rm rstudio*.deb
# install pip3 and popular libraries(for ML enthusiasts)
#sudo apt install -y python3-pip
sudo python -m pip install --upgrade pip
sudo python -m pip install jupyter pandas matplotlib sklearn scipy numpy requests seaborn opencv-python scikit-image
sudo dpkg --configure -a
}
install_pdf_related () {
# Not related to pdf but put here
sudo apt install -y openssh-server openssh-client
sudo apt install -y mupdf evince gimp okular texlive-latex-recommended
# install pandoc
# 2.7.3 at the time of writing
wget https://github.com/jgm/pandoc/releases/download/2.7.3/pandoc-2.7.3-1-amd64.deb
# automate download
#wget https://github.com/jgm/pandoc/releases/download/latest/pandoc-2.7.3-1-amd64.deb

yes | sudo dpkg -i pandoc*
rm pandoc*.deb
}
misc_install () {
sudo apt -y install --install-recommends winehq-stable
sudo apt install -y screenfetch neofetch rsync
sudo dpkg --configure -a
}
# Removes any old versions of docker
remove_old_docker() {

if  [ -x "$(command -v docker)" ]; then
       yes | sudo apt --remove docker.engine docker.io
fi

}
# This installs  bluetooth related stuff
configure_bluetooth () {

    sudo apt install -y bluetooth bluez bluez-tools rfkill
    sudo modprobe btusb
    sudo systemctl enable bluetooth.service
}

install_docker () {
    sudo apt install -y docker.io
    # start and run docker
    yes | sudo systemctl start docker
    yes | sudo systemctl enable docker
}
install_missing () {
sudo apt install -y -f && sudo apt update -y && sudo apt update -y

}
echo -e "\e[1;43m This may take a while :) \e[0m"
echo -e "\e[5;97m Updating System \e[0m"
update_system
echo -e "\e[5;97m Adding a few useful PPAs \e[0m"
add_ppas
echo -e "\e[5;97m Installing Appearance Tweakers \e[0m"
install_tweakers
echo -e "\e[5;97m Still Working, this will not take long. \e[0m"
install_browsers
install_rpy
install_missing
install_pdf_related
misc_install
remove_old_docker
install_docker
install_missing
configure_bluetooth
start_programs

# Fancy exit
echo -e "\e[1;43m Thank you for using the installer \e[0m"

exit







