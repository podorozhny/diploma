FROM nginx:1.10

MAINTAINER Ivan Podorozhny <ivan@podorozhny.ru>

COPY ./docker/front/config/ /etc/nginx/
COPY ./docker/front/start.sh /start.sh

CMD ["/bin/bash", "/start.sh"]
