# based on https://github.com/kartoza/docker-qgis-server

#--------- Generic stuff all our Dockerfiles should start with so we get caching ------------
FROM debian:stable
MAINTAINER Marco Bernasocchi<marco@opengis.ch>
RUN  export DEBIAN_FRONTEND=noninteractive
ENV  DEBIAN_FRONTEND noninteractive
RUN  dpkg-divert --local --rename --add /sbin/initctl

RUN echo "deb     http://qgis.org/debian wheezy main" >> /etc/apt/sources.list
RUN gpg --keyserver keyserver.ubuntu.com --recv DD45F6C3
RUN gpg --export --armor DD45F6C3 | apt-key add -

# Use local cached debs from host (saves your bandwidth!)
# Change ip below to that of your apt-cacher-ng host
# Or comment this line out if you do not with to use caching
ADD 71-apt-cacher-ng /etc/apt/apt.conf.d/71-apt-cacher-ng

RUN apt-get -y update

#-------------Application Specific Stuff ----------------------------------------------------

RUN apt-get install -y qgis qgis-server apache2 libapache2-mod-fcgid libapache2-mod-php5 git locate

EXPOSE 80
ADD fcgid.conf /etc/apache2/mods-available/fcgid.conf

# Set up the postgis services file
# On the client side when referencing postgis
# layers, simply refer to the database using
# Service: gis
# instead of filling in all the host etc details.
# In the container this service will connect 
# with no encryption for optimal performance
# on the client (i.e. your desktop) you should
# connect using a similar service file but with
# connection ssl option set to require

ADD pg_service.conf /etc/pg_service.conf
#USER www-data

# This is so the qgis mapserver uses the correct
# pg service file
ENV PGSERVICEFILE /etc/pg_service.conf

# Install the client
#ADD web-client /QGIS-Web-Client
RUN git clone https://github.com/opengis-ch/QGIS-Web-Client.git #force clear git cache
WORKDIR QGIS-Web-Client
RUN git checkout master
RUN git reset --hard && git pull #force clear git cache

#setup the web client using
# /web as QGISPROJECTSDIR default vhost
# on localhost with mod_rewrite
# and without (re)starting apache
RUN ./install.sh /web localhost true true false true

WORKDIR /
# Now launch apache in the foreground
CMD apachectl -D FOREGROUND
