#!/bin/bash

# Define variables
INIT_SCRIPT="/root/init.sh"
SERVICE_FILE="/etc/systemd/system/iniminer.service"

# Step 1: Create the init.sh script
echo "Creating $INIT_SCRIPT..."
cat << 'EOF' > $INIT_SCRIPT
#!/bin/bash
# This script runs the mining application
./iniminer-linux-x64 --pool stratum+tcp://0x81860e8fec3115e6809be409cf5059a91b7be83e.nano001@pool-core-testnet.inichain.com:32672 --cpu-devices 0 1
EOF

# Make the script executable
chmod +x $INIT_SCRIPT
echo "$INIT_SCRIPT created and made executable."

# Step 2: Create the iniminer.service file
echo "Creating $SERVICE_FILE..."
cat << EOF > $SERVICE_FILE
[Unit]
Description=IniMiner Service
After=network.target

[Service]
ExecStart=/bin/bash $INIT_SCRIPT
Restart=always
RestartSec=5
User=root
WorkingDirectory=/root/
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

[Install]
WantedBy=multi-user.target
EOF

echo "$SERVICE_FILE created."

# Step 3: Reload systemd to recognize the new service
echo "Reloading systemd daemon..."
systemctl daemon-reload

# Step 4: Enable and start the service
echo "Enabling and starting the iniminer.service..."
systemctl enable iniminer.service
systemctl start iniminer.service

# Step 5: Verify the service status
echo "Checking the status of iniminer.service..."
systemctl status iniminer.service

echo "Setup complete. Your mining service is running!"
