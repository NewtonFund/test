FROM centos:7.5.1804

# Update docker image
RUN yum check-update && yum update

# Install toolchain
RUN yum -y install gcc

# Copy source directory inside
ADD . /workspace
WORKDIR /workspace

