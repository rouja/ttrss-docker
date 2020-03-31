FROM alpine:3.9
EXPOSE 9000/tcp

RUN apk add --no-cache php7 php7-fpm \
	php7-pdo php7-gd php7-pgsql php7-pdo_pgsql php7-mbstring \
	php7-intl php7-xml php7-curl php7-session \
	php7-dom php7-fileinfo php7-json \
	php7-pcntl php7-posix php7-zip php7-iconv\
	git postgresql-client sudo

RUN sed -i.bak 's/^listen = 127.0.0.1:9000/listen = 9000/' /etc/php7/php-fpm.d/www.conf; \
    sed -i.bak 's/group = nobody/group = nginx/g' /etc/php7/php-fpm.d/www.conf; \
    addgroup -S nginx -g 101; \
    sed -i 's/root ALL=(ALL) ALL/root ALL=(ALL:ALL) ALL/g' /etc/sudoers; \
    ln -sf /dev/stderr /var/log/php7/error.log;

RUN mkdir -p /var/www/html

RUN git clone https://git.tt-rss.org/fox/tt-rss.git /var/www/html/tt-rss

CMD [ "/usr/sbin/php-fpm7", "-F" ]
