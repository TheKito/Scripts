#!/bin/bash

mkdir -p /var/www/default

echo "
<Directory /var/www/*/public>
        Options -Indexes
        AllowOverride All
        <IfModule mod_rewrite.c>
                RewriteEngine On
                RewriteBase /

                RewriteCond %{REQUEST_FILENAME} !-d
                RewriteCond %{REQUEST_URI} (.+)/$
                RewriteRule ^ %1 [L,R=301]

                RewriteCond %{REQUEST_FILENAME} !-f
                RewriteCond %{REQUEST_FILENAME} !-d
                RewriteRule . /index.php [L,NC,QSA]
        </IfModule>
        <IfModule mod_headers.c>
                <FilesMatch \"\.(ttf|ttc|otf|eot|woff|woff2|font.css|css|js)$\">
                        Header set Access-Control-Allow-Origin "*"
                </FilesMatch>
        </IfModule>
</Directory>
" > /tmp/$$.vhost

for dn in $(ls /var/www)
do
        d=/var/www/$dn
        if [[ -d $d ]]; then

                find $d -depth -type f -empty -delete
                find $d -depth -type d -empty -exec rmdir "{}" \;

                mkdir -p "$d/log"
                LOG=$d/log/$(hostname)_
                LOGE=$LOG\error.log
                LOGA=$LOG\access.log
                LOGP=$LOG\php.log
                touch "$LOGE" "$LOGA" "$LOGP"
                mkdir -p "$d/public"

                mkdir -p "$d/tmp"
                find "$d/tmp" -depth -type f -mtime +1 -delete

                echo "
<VirtualHost 0.0.0.0:80>
        DocumentRoot "$d/public"
        ServerAlias "$dn"
        ServerAlias "www.$dn"
        ErrorLog "$d/log/$(hostname)_error.log"
        CustomLog "$d/log/$(hostname)_access.log" combined

        php_admin_value open_basedir "$d"
        php_admin_value upload_tmp_dir "$d/tmp"
        php_admin_value sys_temp_dir "$d/tmp"
        php_admin_value session.save_handler "files"
        php_admin_value session.save_path "$d/tmp"
        php_value max_execution_time 30
        php_flag log_errors on
        php_value error_log "$d/log/$(hostname)_php.log"
</VirtualHost>
                " >> /tmp/$$.vhost

                tail -n 1000 "$LOGE" > /tmp/$$ && cat /tmp/$$ > "$LOGE"
                tail -n 1000 "$LOGA" > /tmp/$$ && cat /tmp/$$ > "$LOGA"
                tail -n 1000 "$LOGP" > /tmp/$$ && cat /tmp/$$ > "$LOGP"
                rm  /tmp/$$

        fi
done

d=/var/www/default
echo "
<VirtualHost *:80>
        DocumentRoot "$d/public"
        ErrorLog "$d/log/$(hostname)_error.log"
        CustomLog "$d/log/$(hostname)_access.log" combined

        php_admin_value open_basedir "$d"
        php_admin_value upload_tmp_dir "$d/tmp"
        php_admin_value sys_temp_dir "$d/tmp"
        php_admin_value session.save_handler "files"		
        php_admin_value session.save_path "$d/tmp"
        php_value max_execution_time 30
        php_flag log_errors on
        php_value error_log "$d/log/$(hostname)_php.log"
</VirtualHost>
" >> /tmp/$$.vhost


mv /tmp/$$.vhost /etc/apache2/sites-available/001-vhost.conf
service apache2 reload
chown -R www-data:www-data /var/www/