FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
    build-essential \
    pkg-config \
    wget tar \
    less vim

RUN mkdir -p /usr/src/jdk && \
    wget -O jdk.tar.gz https://download.oracle.com/java/25/latest/jdk-25_linux-x64_bin.tar.gz && \
    tar -xf jdk.tar.gz -C /usr/src/jdk --strip-components=1 && \
    rm jdk.tar.gz 

RUN mkdir -p /usr/src/tomcat && \
    wget -O tomcat.tar.gz https://dlcdn.apache.org/tomcat/tomcat-11/v11.0.15/bin/apache-tomcat-11.0.15.tar.gz && \
    tar -xf tomcat.tar.gz -C /usr/src/tomcat --strip-components=1 && \
    rm tomcat.tar.gz

RUN update-alternatives --install "/usr/bin/java" "java" "/usr/src/jdk/bin/java" 1
RUN update-alternatives --install "/usr/bin/javac" "javac" "/usr/src/jdk/bin/javac" 1
RUN export JAVA_HOME="/usr/src/jdk"
RUN export PATH=$PATH:$JAVA_HOME/bin

COPY ./startup.sh /usr/local/startup.sh
RUN chmod +x /usr/local/startup.sh
WORKDIR /usr/local/

CMD ["/usr/local/startup.sh"]

#ENTRYPOINT ["tail", "-f", "/dev/null"]