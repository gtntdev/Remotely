FROM ubuntu:focal-20220531
CMD ["bash"]
EXPOSE 5000
ENV ASPNETCORE_ENVIRONMENT=Production
ENV ASPNETCORE_URLS=http://*:5000

RUN /bin/sh -c apt-get -y update
RUN /bin/sh -c apt-get -y install apt-utils
RUN /bin/sh -c apt-get -y install wget
RUN /bin/sh -c apt-get -y install apt-transport-https
RUN /bin/sh -c apt-get -y install unzip
RUN /bin/sh -c apt-get -y install acl
RUN /bin/sh -c apt-get -y install libssl1.0
RUN /bin/sh -c wget -q https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb
RUN /bin/sh -c dpkg -i packages-microsoft-prod.deb
RUN /bin/sh -c apt-get -y update
RUN /bin/sh -c apt-get -y install aspnetcore-runtime-5.0
RUN /bin/sh -c mkdir -p /var/www/remotely
RUN /bin/sh -c mkdir /config
RUN /bin/sh -c wget -q https://github.com/gtntdev/Remotely/releases/download/v2022.07.06.2131/Remotely_Server_Linux-x64.zip
RUN /bin/sh -c unzip -o Remotely_Server_Linux-x64.zip -d /var/www/remotely
RUN /bin/sh -c rm Remotely_Server_Linux-x64.zip
RUN /bin/sh -c mkdir -p /remotely-data
RUN /bin/sh -c sed -i 's/DataSource=Remotely.db/DataSource=\/remotely-data\/Remotely.db/' /var/www/remotely/appsettings.json

VOLUME [/remotely-data]
WORKDIR /var/www/remotely
COPY ./DockerMain.sh /
RUN /bin/sh -c chmod 755 /DockerMain.sh
ENTRYPOINT ["/DockerMain.sh"]

#LABEL com.azure.dev.image.build.buildnumber=20220716.4
#LABEL com.azure.dev.image.build.builduri=vstfs:///Build/Build/1293
#LABEL com.azure.dev.image.build.definitionname=Publish Docker
#LABEL com.azure.dev.image.build.repository.name=Remotely
#LABEL com.azure.dev.image.build.repository.uri=https://translucency@dev.azure.com/translucency/Remotely/_git/Remotely
#LABEL com.azure.dev.image.build.sourcebranchname=master
#LABEL com.azure.dev.image.build.sourceversion=65e4cebc532fe0742c03560caba970245d02fd5f
#LABEL com.azure.dev.image.system.teamfoundationcollectionuri=https://dev.azure.com/translucency/
#LABEL com.azure.dev.image.system.teamproject=Remotely
#LABEL image.base.digest=sha256:fd92c36d3cb9b1d027c4d2a72c6bf0125da82425fc2ca37c414d4f010180dc19
#LABEL image.base.ref.name=ubuntu:focal
#test ci - try 4
