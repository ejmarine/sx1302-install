#!/bin/bash


if [ "$EUID" -eq 0 ]; then
    echo "NOTE: don't run me as root"
    exit
fi

sudo apt update
sudo apt install git

git clone https://github.com/Lora-net/sx1302_hal.git ~/Documents/sx1302_hal

cp install_svc.sh ~/Documents/sx1302_hal/

read -p "Apply fix for Pi3B? (y/n)" fix

if [ "$fix" == "y" ]; then
    cp reset_lgw.sh ~/Documents/sx1302_hal/tools/reset_lgw.sh
fi

read -p "Add global_conf.json (this only exists because I was having issues with the default one and the frequencies it uses. This one runs on FSB1 rather than FSB2)? (y/n)" add_conf

if [ "$add_conf" == "y" ]; then
    cp global_conf.json ~/Documents/sx1302_hal/packet_forwarder/
fi

cd ~/Documents/sx1302_hal/

make clean all
make all

cp tools/reset_lgw.sh util_chip_id/
cp tools/reset_lgw.sh packet_forwarder/

echo "Run 'chip_id' in util_chip_id/ to get concentrator EUI and add it to Chirpstack"
echo "Then, add that EUI and your Chirpstack server address to global_conf.json"
echo "After that, run 'lora_pkt_fwd' in packet_forwarder/ to make sure it works."
echo "Finally, run 'sudo bash install_svc.sh' located in ~/Documents/sx1302_hal/ to run it as a service."
