#!/bin/bash

sudo yum update -y
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd

# Ensure the directory exists
sudo mkdir -p /var/www/html

# Create index.html file
echo '<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Secondary EC2 Instance</title>
    <style>
        body { font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif; text-align: center; margin-top: 50px; background-color: #e6f2ff; }
        h1 { color: #1a5276; text-shadow: 1px 1px 2px #aaa; }
        .container { max-width: 800px; margin: 0 auto; padding: 20px; background-color: white; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        .footer { margin-top: 30px; color: #7f8c8d; font-size: 0.9em; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Secondary Application Server</h1>
        <p>This is the <strong>second EC2 instance</strong> in our infrastructure.</p>
        <p>Current server time: <span id="datetime"></span></p>
        <p>Hostname: <span id="hostname"></span></p>
        <div class="footer">
            <p>Automatically deployed with Terraform User Data</p>
        </div>
    </div>

    <script>
        function updateDateTime() {
            const now = new Date();
            document.getElementById("datetime").textContent = now.toLocaleString();
        }
        updateDateTime();
        setInterval(updateDateTime, 1000);

        // Display hostname
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
echo "Apache installation and secondary webpage deployment complete!" | sudo tee /var/log/userdata.log
