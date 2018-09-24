FROM centos:centos6.9

RUN yum update -y
RUN yum groupinstall -y 'Development Tools'
RUN yum install -y epel-release
RUN yum install -y nginx
RUN yum install -y fcgi-devel

WORKDIR /usr/local/src
RUN git clone git://github.com/gnosek/fcgiwrap.git
WORKDIR /usr/local/src/fcgiwrap
RUN autoreconf -i
RUN ./configure
RUN make
RUN make install

WORKDIR /var/www
COPY www /var/www

RUN yum install -y spawn-fcgi
COPY resources/spawn-fcgi /etc/sysconfig/spawn-fcgi
RUN chkconfig --levels 235 spawn-fcgi on

COPY resources/nginx-perl.conf /etc/nginx/nginx.conf

RUN chmod -R 755 /var/www
RUN chown -R nginx:nginx /var/www

WORKDIR /scripts
COPY scripts/container-start.sh /scripts/container-start.sh
RUN echo "source /scripts/container-start.sh" >> ~/.bashrc 

EXPOSE 8080

CMD ["/bin/bash"]
