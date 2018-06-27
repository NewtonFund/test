FROM ubuntu:18.04

# Update docker image
RUN apt-get update && apt-get upgrade -y

# Install toolchain
RUN apt-get install -y build-essential

# Copy source directory inside
ADD . /workspace
WORKDIR /workspace

