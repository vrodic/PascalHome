In current iteration I'm serving HTTPS with Apache2

Here's the configuration to put in Debian 12 /etc/apache2/sites-enabled/vedranrodic.com.conf file

```
<VirtualHost *:80>
    ServerName vedranrodic.com
    ServerAlias www.vedranrodic.com

    # Redirect all HTTP traffic to HTTPS
    Redirect permanent / https://vedranrodic.com/
</VirtualHost>

<VirtualHost *:443>
    ServerName vedranrodic.com
    ServerAlias www.vedranrodic.com

    # Enable SSL
    SSLEngine on

    # Certificates issued by Certbot
    SSLCertificateFile /etc/letsencrypt/live/vedranrodic.com/fullchain.pem
    SSLCertificateKeyFile /etc/letsencrypt/live/vedranrodic.com/privkey.pem

    # Strong SSL settings
    SSLProtocol all -SSLv3 -TLSv1 -TLSv1.1
    SSLCipherSuite HIGH:!aNULL:!MD5:!3DES
    SSLHonorCipherOrder on

    # Reverse Proxy to PascalHome
    ProxyPreserveHost On
    ProxyPass / http://localhost:8080/
    ProxyPassReverse / http://localhost:8080/

    # Security headers
    Header always set Strict-Transport-Security "max-age=31536000; includeSubDomains"
    Header always set X-Content-Type-Options "nosniff"
    Header always set X-Frame-Options "DENY"

    # Logging
    ErrorLog ${APACHE_LOG_DIR}/vedranrodic.com_error.log
    CustomLog ${APACHE_LOG_DIR}/vedranrodic.com_access.log combined
</VirtualHost>
```
