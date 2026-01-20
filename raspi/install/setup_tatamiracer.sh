#!/bin/sh -x
#Setup TatamiRacer
. env/bin/activate
printf "Setup TatamiRacer\n"

#Install pigpio
yes | sudo apt install pigpio python3-pigpio
sudo systemctl enable pigpiod.service
sudo systemctl start pigpiod

#Install lxshortcut
#Create TatamiRacer Shortcut
yes | sudo apt-get install lxshortcut

#install imgaug for onboard training
#install imgaug for onboard training
pip install imgaug

# Fix picamera2 path for venv
VENV_SITE_PACKAGES=$(python3 -c "import site; print(site.getsitepackages()[0])" 2>/dev/null)
SYSTEM_PICAM2=$(/usr/bin/python3 -c "import picamera2; import os; print(os.path.dirname(picamera2.__file__))" 2>/dev/null)
if [ -n "$SYSTEM_PICAM2" ] && [ -d "$SYSTEM_PICAM2" ] && [ -n "$VENV_SITE_PACKAGES" ]; then
    if [ ! -L "$VENV_SITE_PACKAGES/picamera2" ]; then
        ln -s "$SYSTEM_PICAM2" "$VENV_SITE_PACKAGES/picamera2"
        echo "Symlinked picamera2 to venv."
    fi
else
    echo "Warning: System picamera2 not found or venv issue."
fi

#Download TatamiRacer files
cd ~/mycar

# Backup original file
sudo mv manage.py manage_bak.py
sudo mv manage.py mayconfig_bak.py

wget "https://raw.githubusercontent.com/he-be/TatamiRacer/master/raspi/mycar/manage.py"  -O "manage.py"
wget "https://raw.githubusercontent.com/he-be/TatamiRacer/master/raspi/mycar/myconfig.py"  -O "myconfig.py"
wget "https://raw.githubusercontent.com/he-be/TatamiRacer/master/raspi/mycar/picamera2_part.py"  -O "picamera2_part.py"
wget "https://raw.githubusercontent.com/he-be/TatamiRacer/master/raspi/mycar/tatamiracer_test.py" -O "tatamiracer_test.py"
wget "https://raw.githubusercontent.com/he-be/TatamiRacer/master/raspi/mycar/tatamiracer_icon.png" -O "tatamiracer_icon.png"

#Download TatamiRacer ShortCut
mkdir ~/mycar/shortcut
cd ~/mycar/shortcut
wget "https://raw.githubusercontent.com/he-be/TatamiRacer/master/raspi/mycar/shortcut/donkey_clean_data"  -O "donkey_clean_data"
wget "https://raw.githubusercontent.com/he-be/TatamiRacer/master/raspi/mycar/shortcut/donkey_drive"  -O "donkey_drive"
wget "https://raw.githubusercontent.com/he-be/TatamiRacer/master/raspi/mycar/shortcut/donkey_drive_with_model"  -O "donkey_drive_with_model"
wget "https://raw.githubusercontent.com/he-be/TatamiRacer/master/raspi/mycar/shortcut/donkey_training_on_board"  -O "donkey_training_on_board"
wget "https://raw.githubusercontent.com/he-be/TatamiRacer/master/raspi/mycar/shortcut/tatamiracer_test"  -O "tatamiracer_test"
wget "https://raw.githubusercontent.com/he-be/TatamiRacer/master/raspi/mycar/shortcut/tatamiracer_shortcut"  -O "tatamiracer_shortcut"

#Copy TatamiRacer shortcut in Desktop
cp ~/mycar/shortcut/tatamiracer_shortcut ~/Desktop

#Open shortcut folder
xdg-open ~/mycar/shortcut

