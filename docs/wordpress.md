# wordpress

## wp cli

wp-cli core download

wp core config --dbhost=host.db --dbname=prefix_db --dbuser=username --dbpass=password

wp-cli core install --url=bhaaie --title=BHAA --admin_user=supervisor --admin_password=strongpassword --admin_email=info@example.com

## bedrock

https://roots.io/bedrock/docs/bedrock-server-configuration/

## apache

<VirtualHost *:80>
        ServerAdmin webmaster@localhost
        ServerName bhaaie
        # D:/projects/bedrock/web
        DocumentRoot "D:/projects/bedrock/web"

        DirectoryIndex index.php index.html index.htm

        # D:/projects/bedrock/web
        <Directory "D:/projects/bedrock/web">
            Options Indexes FollowSymLinks Includes ExecCGI
            AllowOverride All
            Require all granted

            # .htaccess isn't required if you include this
            <IfModule mod_rewrite.c>
                RewriteEngine On
                RewriteBase /
                RewriteRule ^index.php$ - [L]
                RewriteCond %{REQUEST_FILENAME} !-f
                RewriteCond %{REQUEST_FILENAME} !-d
                RewriteRule . /index.php [L]
            </IfModule>
        </Directory>
</VirtualHost>

## php

dc-user@ech-0A9D9570 MINGW64 ~
$ php --ini
Configuration File (php.ini) Path: C:\windows
Loaded Configuration File:         C:\tools\php73\php.ini


## wordpress

    GRANT ALL PRIVILEGES ON *.* TO 'bhaaie_wp'@'localhost' IDENTIFIED BY 'bhaaie_wp' WITH GRANT OPTION;

## DB import

    wp-cli db import ./../db/bhaaie_wp.sql

Run in CMD as admin

    mklink /D bhaa_wordpress_plugin D:\projects\bhaa_wordpress_plugin


## Composer

Use http proxy via to avoid issue

    export HTTP_PROXY="http://username:password@webproxy.com:port"
    
