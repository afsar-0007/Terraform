
#!/bin/bash


apt-get update -y


apt-get install nginx -y



cat > /var/www/html/index.html <<'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>My Terraform Website</title>
</head>
<body>

    <h1>Hello, this is Afsar Sohail!</h1>

    <h2>Welcome to my Nginx Web Server.</h2>

    <p>This EC2 instance was created using Terraform.</p>

    <p>Nginx was installed automatically using user_data.</p>

</body>
</html>
EOF



systemctl enable nginx
systemctl start nginx

echo "Nginx installation completed!"