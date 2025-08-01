#!/bin/bash

echo "Installing as a service..."

cd ~/Documents/sx1302_hal/

cat > /etc/systemd/system/lora-pkt-fwd.service <<EOF
[Unit]
Description=LoRa Packet Forwarder
After=network.target

[Service]
User=$USER
Group=www-data
WorkingDirectory=$(pwd)
ExecStart=$(pwd)/packet_forwarder/lora_pkt_fwd
ExecReload=/bin/kill -s HUP $MAINPID
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable lora-pkt-fwd
sudo systemctl start lora-pkt-fwd

echo "Done!"