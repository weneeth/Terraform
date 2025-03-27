#!/bin/bash

# Update system packages
sudo yum update -y

# Install Apache (httpd)
sudo yum install -y httpd

# Start and enable Apache
sudo systemctl start httpd
sudo systemctl enable httpd

# Ensure the directory exists
sudo mkdir -p /var/www/html

# Create the HTML file
echo '<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Terraform-Deployed Website</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; margin-top: 50px; background-color: #f0f8ff; }
        h1 { color: #2e8b57; }
    </style>
</head>
<body>
    <h1>Welcome to My EC2 Instance!</h1>
    <p>This webpage was deployed automatically using Terraform User Data.</p>
    <p>Hostname: <span id="hostname"></span></p>
    <script>
        document.getElementById("hostname").textContent = window.location.hostname;
    </script>
</body>
</html>' | sudo tee /var/www/html/index.html > /dev/null

# Set proper permissions
sudo chown root:root /var/www/html/index.html
sudo chmod 644 /var/www/html/index.html

# Restart Apache to load new content
sudo systemctl restart httpd

# Log completion
echo "Apache installation and webpage deployment complete!" | sudo tee /var/log/userdata.log
