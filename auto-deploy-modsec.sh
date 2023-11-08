#!/bin/bash
# Deploy:      Nginx reverse proxy + Modsecurity + OWASP Core Rules
# Author:      ThaoPT - thaopt@nextsec.vn
# Last update: 06/11/2019

mkdir -p /data/nginx/conf.d/ssl
mkdir -p /data/nginx/log
mkdir -p /data/modsec/log

touch /data/nginx/conf.d/default.conf

cat > /data/nginx/conf.d/demo.conf << EOL

# App cluster
upstream clusterapp {
            # round-robin is default setting
            #  sticky;
            server 192.168.11.76:8081 max_fails=1  fail_timeout=3s;
            server 192.168.11.76:8082 max_fails=1  fail_timeout=3s;
        }



#HTTP redirect
server {
        listen  80;
        server_name sub.domain.com;
        return 301 https://sub.domain.com$request_uri;
       }


##### Enable for Root domain only - Chỉ dùng khi cấu hình doamin chính với WWW.domain.com
#server {
#	listen 443 ssl;

#	server_name www.domain.com;
	
#	# SSL
#	ssl_certificate /etc/nginx/ssl/www.doamin.com/www.domain.com.crt;
#	ssl_certificate_key /etc/nginx/ssl/www.doamin.com/www.doamin.com.pri.key;

#	return 301 https://doamin.com$request_uri;

#	include /etc/nginx/general.conf;
#}


server {
#       listen 443 ssl;  # khi enable dùng cert
	listen 8080;	 # khi khong dung cert;
        server_name     sub.domain.com;

        access_log      /var/log/nginx/sub.domain.com_access.log main;
        error_log       /var/log/nginx/sub.domain.com_error.log;

        sub_filter http://sub.domain.com https://sub.domain.com;
	sub_filter http://www.domain.com https://www.domain.com;
        sub_filter_once off;
        include /etc/nginx/general.conf;

 #   	ssl_certificate /etc/nginx/ssl/www.doamin.com/www.domain.com.crt;
 #	ssl_certificate_key /etc/nginx/ssl/www.doamin.com/www.doamin.com.pri.key;

        #Reverse proxy
        location / {
             proxy_pass         http://clusterapp;
             include /etc/nginx/proxy.conf;
             }
		#Browser cache
	location ~*  \.(jpg|jpeg|png|gif|ico|css|js|pdf)$ {
             proxy_pass       http://clusterapp;
             include /etc/nginx/proxy.conf;
             expires 30d;
        }

}


EOL

cat > /data/nginx/conf.d/restrictdomain.conf << EOL
server {
    listen 80;
    server_name _;
    return       301 https://nextsec.vn;
}

EOL


cat > docker-compose.yml << EOL

version: '3'

services:
   modsec:
     # v1.25.0 some error   
     image: "wisoez/nginx-sticky-alpine:v1.19.0-sticky-modsec"
     volumes:
       - "/data/nginx/conf.d:/etc/nginx/conf.d"
       - "/data/nginx/nginx.conf:/etc/nginx/nginx.conf"
       - "/data/nginx/proxy.conf:/etc/nginx/proxy.conf"
       - "/data/nginx/general.conf:/etc/nginx/general.conf"
       - "/data/nginx/log:/var/log/nginx"
       - "/data/modsec/log:/var/log/modsec"
     restart: "always"
     ports:
       - "80:80"
       - "443:443"
EOL

/bin/docker-compose up -d
