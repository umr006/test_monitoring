#!/bin/bash

#install Prometheus
#a. Download the latest Prometheus release:
wget https://github.com/prometheus/prometheus/releases/download/v2.48.0-rc.2/prometheus-2.48.0-rc.2.linux-arm64.tar.gz
#b. Extract the archive:
tar xvfz prometheus-*.tar.gz
cd prometheus-2.32.0.linux-amd64/
#c. Move the Prometheus binary files to /usr/local/bin:
sudo mv prometheus promtool /usr/local/bin/
#d. Create the Prometheus configuration directory and copy the configuration file:
sudo mkdir /etc/prometheus
sudo mv prometheus.yml /etc/prometheus/
#e. Create a Prometheus system user and set directory permissions:
sudo useradd --no-create-home --shell /bin/false prometheus
sudo chown -R prometheus:prometheus /etc/prometheus
#f. Create the Prometheus data directory and set permissions:
sudo mkdir /var/lib/prometheus
sudo chown prometheus:prometheus /var/lib/prometheus
#Create a Prometheus systemd service file:
sudo vim /etc/systemd/system/prometheus.service

#Add the following content to the file:
cat <<EOF >vim /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
--config.file /etc/prometheus/prometheus.yml \
--storage.tsdb.path /var/lib/prometheus/ \
--web.console.templates=/etc/prometheus/consoles \
--web.console.libraries=/etc/prometheus/console_libraries

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl start prometheus
sudo systemctl enable prometheus
sudo systemctl status prometheus
