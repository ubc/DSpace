#
# DSpace image
#

FROM openjdk:7-jdk
MAINTAINER Pan Luo <pan.luo@ubc.ca>

# Environment variables
ENV DSPACE_VERSION=5.4 TOMCAT_MAJOR=8 TOMCAT_VERSION=8.0.42
ENV TOMCAT_TGZ_URL=https://archive.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz \
    MAVEN_TGZ_URL=http://apache.mirror.iweb.ca/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz
ENV CATALINA_HOME=/usr/local/tomcat DSPACE_HOME=/dspace
ENV PATH=$CATALINA_HOME/bin:$DSPACE_HOME/bin:$PATH

WORKDIR /tmp

# Install runtime and dependencies
RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y vim ant postgresql-client netcat \
    && mkdir -p maven dspace "$CATALINA_HOME" \
    && curl -fSL "$TOMCAT_TGZ_URL" -o tomcat.tar.gz \
    && curl -fSL "$MAVEN_TGZ_URL" -o maven.tar.gz \
    && tar -xvf tomcat.tar.gz --strip-components=1 -C "$CATALINA_HOME" \
    && tar -xvf maven.tar.gz --strip-components=1  -C maven \
    && rm -fr "$CATALINA_HOME/webapps/*"

ADD . /dspace-src

WORKDIR /dspace-src

RUN /tmp/maven/bin/mvn package -P '!dspace-xmlui,!dspace-lni,!dspace-oai,!dspace-sword,!dspace-swordv2' \
    && cd dspace/target/dspace-installer \
    && ant init_installation init_configs install_code copy_webapps \
    #&& sed -i s/CONFIDENTIAL/NONE/ $CATALINA_HOME/webapps/rest/WEB-INF/web.xml
    && rm -fr ~/.m2 && rm -fr /tmp/* /dspace-src && rm -rf /var/lib/apt/lists/* && apt-get clean

# Install root filesystem
ADD ./docker/rootfs /

WORKDIR /dspace

# Build info
RUN echo "Debian GNU/Linux 8 (jessie) image. (`uname -rsv`)" >> /root/.built && \
    echo "- with `java -version 2>&1 | awk 'NR == 2'`" >> /root/.built && \
    echo "- with DSpace $DSPACE_VERSION on Tomcat $TOMCAT_VERSION"  >> /root/.built

VOLUME ["$DSPACE_HOME/assetstore"]

EXPOSE 8080
CMD ["start-dspace"]
