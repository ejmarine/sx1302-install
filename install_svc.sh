#!/bin/bash

echo "Installing as a service..."

sudo touch /etc/systemd/system/lora-pkt-fwd.service
sudo cat > /etc/systemd/system/lora-pkt-fwd.service <<EOF
[Unit]
Description=LoRa Packet Forwarder
After=network.target

[Service]
User=$USER
Group=www-data
WorkingDirectory=$(pwd)/packet_forwarder
ExecStart=$(pwd)/packet_forwarder/lora_pkt_fwd -c /home/pi/Documents/sx1302_hal/packet_forwarder/global_conf.json
ExecReload=/bin/kill -s HUP $MAINPID
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable lora-pkt-fwd
sudo systemctl start lora-pkt-fwd

sudo systemctl status lora-pkt-fwd

echo "Done!"