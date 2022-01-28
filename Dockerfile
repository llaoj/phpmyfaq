FROM ubuntu:20.04

WORKDIR /faq
COPY . .
RUN chmod +x /faq/bootstrap.sh

CMD ["/faq/bootstrap.sh"]
