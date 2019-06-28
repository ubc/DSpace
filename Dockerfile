#
# DSpace image
#

FROM openjdk:8-jdk
MAINTAINER Pan Luo <pan.luo@ubc.ca>

# Environment variables
ENV DSPACE_VERSION=5.4 TOMCAT_MAJOR=8 TOMCAT_VERSION=8.5.42
ENV TOMCAT_TGZ_URL=https://archive.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz
ENV CATALINA_HOME=/usr/local/tomcat DSPACE_HOME=/dspace
ENV PATH=$CATALINA_HOME/bin:$DSPACE_HOME/bin:$PATH

WORKDIR /tmp

# Install runtime and dependencies
RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y vim ant postgresql-client netcat imagemagick ghostscript maven \
    && mkdir -p dspace "$CATALINA_HOME" \
    && curl -fSL "$TOMCAT_TGZ_URL" -o tomcat.tar.gz \
    && tar -xvf tomcat.tar.gz --strip-components=1 -C "$CATALINA_HOME" \
    && rm -fr "$CATALINA_HOME/webapps/*"

ADD . /dspace-src

WORKDIR /dspace-src

RUN mvn package -Dmaven.test.skip=false -P '!dspace-xmlui,!dspace-lni,!dspace-sword,!dspace-swordv2,!dspace-xmlui-mirage2,!dspace-rdf,!dspace-rest' \
    && cd dspace/target/dspace-installer \
    && ant init_installation init_configs install_code copy_webapps \
    #&& sed -i s/CONFIDENTIAL/NONE/ $CATALINA_HOME/webapps/rest/WEB-INF/web.xml
    && rm -fr ~/.m2 && rm -fr /tmp/* /dspace-src && rm -rf /var/lib/apt/lists/* && apt-get clean

# Install root filesystem
ADD ./docker/rootfs /

WORKDIR /dspace

# Build info
RUN echo "Debian GNU/Linux 9 (stretch) image. (`uname -rsv`)" >> /root/.built && \
    echo "- with `java -version 2>&1 | awk 'NR == 2'`" >> /root/.built && \
    echo "- with DSpace $DSPACE_VERSION on Tomcat $TOMCAT_VERSION"  >> /root/.built

# Download IP geolocation database
RUN wget https://geolite.maxmind.com/download/geoip/database/GeoLite2-City.tar.gz -O /tmp/GeoLite2-City.tar.gz && \
    mkdir /tmp/geolite2 && \
    tar xzvf /tmp/GeoLite2-City.tar.gz -C /tmp/geolite2 --strip-components 1 && \
    cp /tmp/geolite2/GeoLite2-City.mmdb $DSPACE_HOME/config && \
    rm -f /tmp/GeoLite2-City.tar.gz && rm -fr /tmp/geolite2

VOLUME ["$DSPACE_HOME/assetstore"]
VOLUME ["$DSPACE_HOME/solr/statistics/data"]

EXPOSE 8080
CMD ["start-dspace"]
