# Step 1: Specify CentOS 8 as the base image
FROM centos:8

RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-Linux-*
RUN sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-Linux-*

# Step 2: Update the system and install necessary packages
RUN dnf -y update && dnf -y install gcc make wget tar

RUN yum install -y dnf-plugins-core && yum config-manager -y --set-enabled powertools && yum install -y glibc-static libstdc++-static

# Step 3: Set the working directory
WORKDIR /usr/src

# Step 4: Download the iperf3 source code
RUN wget https://downloads.es.net/pub/iperf/iperf-3.15.tar.gz

# Step 5: Extract the tarball and navigate into the extracted directory
RUN tar -xzf iperf-3.15.tar.gz && cd iperf-3.15 && ./configure --enable-static --enable-static-bin --disable-shared && make && make install

# Step 8: Clean up unnecessary files
RUN dnf -y remove gcc make wget tar && dnf clean all && rm -rf /usr/src/iperf-3.15.tar.gz

# Step 9: Define the volume
VOLUME /data-output

# Step 7: Define the entrypoint
ENTRYPOINT ["cp", "/usr/local/bin/iperf3", "/data-output"]

