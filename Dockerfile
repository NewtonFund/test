FROM ubuntu:18.04

# Update docker image
RUN apt-get update && apt-get upgrade -y

# Install toolchain
RUN apt-get install -y build-essential

# Add time-zone data
ENV DEBIAN_FRONTEND noninteractive

# Install ntp to sync time
RUN apt-get install -y ntp

# Copy source directory inside
ADD . /workspace
WORKDIR /workspace

