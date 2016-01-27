#!/usr/bin/env bash
echo " http://jmaclabs.net >>> VAGRANT UBUNTU GIT FLASK GUNICORN SUPERVISOR PROVISIONING <<< "
echo "...fire in the hole!!!"

# install dependencies
echo "INSTALLING DEPENDENCIES..."
IFS=';' read updates security_updates < <(/usr/lib/update-notifier/apt-check 2>&1)
TOTAL_UPDATES=$(($updates + $security_updates))

if [ $TOTAL_UPDATES -gt 0 ]; then
    echo " >>> $TOTAL_UPDATES UPDATES FOUND, RUNNING APT-GET..."
    apt-get update
fi
apt-get install -y python python-pip python-virtualenv nginx gunicorn supervisor git

#setup git
echo "SETTING UP GIT....."
if [ ! -d "/home/git" ]; then
    echo " >>> /home/git not found, making dir..."
    sudo mkdir /home/git && cd /home/git
fi

if [ ! -d "/home/git/flask_app.git" ]; then
    echo " >>> flask_app.git not found, making dir..."
    sudo mkdir flask_app.git && cd flask_app.git
    sudo git init --bare
fi

if [ ! -e /home/git/flask_app.git/hooks/post-receive ]; then
    echo " >>> hooks/post-receive not found, making dir..."
    sudo touch /home/git/flask_app.git/hooks/post-receive
    cat /home/vagrant/post-receive.txt > /home/git/flask_app.git/hooks/post-receive
    sudo chmod +x /home/git/flask_app.git/hooks/post-receive
fi

# setup flask project
echo "SETTING UP WWW DIR..."
if [ ! -d "/home/www" ]; then
    echo " >>> /home/www NOT found, making..."
    sudo mkdir /home/www && cd /home/www
fi

if [ -d "/home/www" ]; then
    echo " >>> /home/www found, replacing..."
    sudo rm -rf /home/www
    sudo mkdir /home/www && cd /home/www
fi

# setup venv
echo "SETTING UP VENV..."
sudo virtualenv env
source env/bin/activate

# setup flask 
echo "SETTING UP FLASK..."
sudo pip install Flask==0.10.0

if [ -d "/home/www/flask_app" ]; then
    echo " >>> /home/www/flask_app found, removing..."
    sudo rm -rf /home/www/flask_app
fi

if [ ! -d "/home/www/flask_app" ]; then
    echo ">>> /home/www/flask_app NOT found, making..."
    sudo mkdir /home/www/flask_app
fi

cd /home/www/flask_app
sudo cp /home/vagrant/app.py .
sudo mkdir /home/www/flask_app/static
sudo touch /home/www/flask_app/static/index.html
sudo echo '<h1>Test!</h1' > /home/www/flask_app/static/index.html

# config nginx
echo "SETTING UP NGINX...."
sudo /etc/init.d/nginx start

if [ -e /etc/nginx/sites-enabled/default ]; then
    sudo rm /etc/nginx/sites-enabled/default
fi

if [ -e /etc/nginx/sites-available/flask_app ]; then
    sudo rm /etc/nginx/sites-enabled/flask_app
    sudo rm /etc/nginx/sites-available/flask_app
    sudo touch /etc/nginx/sites-available/flask_app
fi

sudo ln -s /etc/nginx/sites-available/flask_app /etc/nginx/sites-enabled/flask_app
sudo cat /home/vagrant/nginx_config.txt > /etc/nginx/sites-available/flask_app

#restart nginx
sudo /etc/init.d/nginx restart

# profit
cd /home/www/flask_app/

# install supervisor
echo "SETTING UP SUPERVISOR...."
if id -u "digger" >/dev/null 2>&1; then
    echo " >>> supervisor user 'digger' already exists"
else
    sudo adduser digger --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password
    echo "digger:digdigdig" | sudo chpasswd
fi

if [ ! -e /etc/supervisor/conf.d/flask_app.conf ]; then
    sudo touch /etc/supervisor/conf.d/flask_app.conf
fi
sudo cat /home/vagrant/supervisor_flask_app.conf > /etc/supervisor/conf.d/flask_app.conf

echo "RESTARTING SUPERVISOR..."
sudo supervisorctl reread
sudo supervisorctl update
sudo supervisorctl start flask_app

echo "VAGRANT PROVISIONING - COMPLETE!"

echo "Point a browser at http://127.0.0.1:8080 to confirm you see 'Flask is running!'"
