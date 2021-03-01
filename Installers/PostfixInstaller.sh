#!/bin/bash
echo "

#Relay
fallback_relay = $(cat /etc/mailname)

#Auth
smtp_sasl_auth_enable = yes
smtp_sasl_security_options = noanonymous
smtp_sasl_password_maps=hash:/etc/postfix/sasl_passwd

#TLS
smtpd_tls_cert_file = /etc/ssl/certs/ssl-cert-snakeoil.pem
smtpd_tls_key_file = /etc/ssl/private/ssl-cert-snakeoil.key
smtp_tls_security_level=may
smtpd_use_tls=yes
smtpd_tls_session_cache_database = btree:${data_directory}/smtpd_scache
smtp_tls_session_cache_database = btree:${data_directory}/smtp_scache

#Headers
mime_header_checks = regexp:/etc/postfix/header_checks
header_checks = regexp:/etc/postfix/header_checks

#Send Delay
smtp_destination_concurrency_limit = 1
smtp_destination_rate_delay = 1s
smtp_extra_recipient_limit = 5


inet_protocols = ipv4
myhostname = $(cat /etc/hostname)
smtpd_banner = \$myhostname ESMTP $mail_name
mynetworks = 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128 10.0.0.0/8 172.16.0.0/12 192.168.0.0/16
biff = no
append_dot_mydomain = no
myorigin = /etc/mailname

compatibility_level = 2
soft_bounce = yes
bounce_queue_lifetime = 0
message_size_limit = 26214400

virtual_alias_maps = hash:/etc/postfix/virtual
transport_maps = hash:/etc/postfix/transport


" > /etc/postfix/main.cf

echo "
/^Received:/    IGNORE
/^User-Agent:/  IGNORE
/^X-Mailer:/    IGNORE
/^X-MimeOLE:/   IGNORE
/^X-MSMail-Priority:/   IGNORE
/^X-Spam-Status:/       IGNORE
/^X-Spam-Level:/        IGNORE
/^X-Sanitizer:/ IGNORE
/^X-Originating-IP:/    IGNORE
/^X-*:/ IGNORE

" > /etc/postfix/header_checks


postmap /etc/postfix/header_checks

touch /etc/postfix/sasl_passwd
postmap /etc/postfix/sasl_passwd

touch /etc/postfix/virtual
postmap /etc/postfix/virtual

touch /etc/postfix/transport
postmap /etc/postfix/transport

/etc/init.d/postfix reload
