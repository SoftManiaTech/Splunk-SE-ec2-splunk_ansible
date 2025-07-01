#!/bin/bash

# Install Required Packages
yum install -y wget tar

# Create Splunk User and Directory (if not exists)
id -u splunk &>/dev/null || useradd splunk
mkdir -p /opt/splunk
chown -R splunk:splunk /opt/splunk

# Disable Transparent Huge Pages (THP) - Create systemd service
cat << 'EOF' > /etc/systemd/system/disable-thp.service
[Unit]
Description=Disable Transparent Huge Pages and defrag
After=network.target

[Service]
Type=oneshot
ExecStart=/bin/bash -c 'echo never > /sys/kernel/mm/transparent_hugepage/enabled; echo never > /sys/kernel/mm/transparent_hugepage/defrag'

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd and enable THP service
systemctl daemon-reexec
systemctl daemon-reload
systemctl enable disable-thp

# Setup Splunk as splunk user
su - splunk <<'EOF'
# Navigate to home directory
cd /home/splunk

# Download and Extract Splunk
wget -O splunk-9.4.1-linux-amd64.tgz "https://download.splunk.com/products/splunk/releases/9.4.1/linux/splunk-9.4.1-e3bdab203ac8-linux-amd64.tgz"
tar -xvf splunk-9.4.1-linux-amd64.tgz -C /opt/

# Start Splunk (initial setup)
 /opt/splunk/bin/splunk start --accept-license --answer-yes --no-prompt --seed-passwd 'admin123'
EOF

# Stop Splunk before systemd service setup
/opt/splunk/bin/splunk stop

# Create Splunk systemd service
cat << 'EOF' > /etc/systemd/system/splunk.service
[Unit]
Description=Splunk Enterprise
After=network.target

[Service]
Type=simple
User=splunk
Group=splunk
ExecStart=/opt/splunk/bin/splunk start --no-prompt --accept-license
ExecStop=/opt/splunk/bin/splunk stop
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd and enable Splunk service
systemctl daemon-reexec
systemctl daemon-reload
systemctl enable splunk

/opt/splunk/bin/splunk enable boot-start -user splunk

# Start the Splunk service
/opt/splunk/bin/splunk start

echo "Splunk setup completed successfully. Transparent Huge Pages (THP) disabled and Splunk is running as a systemd service."
echo "Reboot the system to fully apply THP settings."
