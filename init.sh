sudo -s ln -sf /home/box/web/etc/nginx.conf  /etc/nginx/sites-enabled/django.conf
sudo -s rm /etc/nginx/sites-enabled/default

sudo -s /etc/init.d/nginx restart

sudo -s /etc/init.d/mysql start && \
    mysql -uroot -e "create database django"
    
    cd /home/box/web && \
    virtualenv venv && \
    source venv/bin/activate && \
    pip install -r requirements/production.txt && \
    export PYTHONPATH=$(pwd):$PYTHONPATH && \
    cd /home/box/web/ask && \
    python manage.py migrate && \
    exec gunicorn --bind=0.0.0.0:8000 --workers=4 ask.wsgi:application
