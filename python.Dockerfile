# Get image for just Ubuntu: https://hub.docker.com/_/ubuntu
# FROM ubuntu:22.04
# Get image for GPU: https://hub.docker.com/r/nvidia/cuda
FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04

# Different between ARG and ENV
# https://vsupalov.com/docker-arg-env-variable-guide/
# What is DEBIAN_FRONTEND=noninteractive?
# https://bobcares.com/blog/debian_frontendnoninteractive-docker/
ARG DEBIAN_FRONTEND=noninteractive
# Timezone
ENV TZ="Asia/Bangkok"

# https://github.com/pyenv/pyenv/wiki#suggested-build-environment
RUN apt update && apt upgrade -y
RUN apt install -y build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev curl \
    libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
# Set timezone
RUN apt install -y tzdata
RUN ln -snf /usr/share/zoneinfo/$CONTAINER_TIMEZONE /etc/localtime && echo $CONTAINER_TIMEZONE > /etc/timezone

# Set locales
# https://leimao.github.io/blog/Docker-Locale/
RUN apt-get install -y locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LC_ALL en_US.UTF-8 
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  

# Below can be modify as you want
# Use -y in `apt install` so it won't wait for your confirmation
# Package I normally use
RUN apt install -y vim
RUN apt install -y htop
RUN apt install -y python3 python3-pip

# X410
ENV DISPLAY host.docker.internal:0.0

# Python
RUN pip install ipykernel
RUN pip install ipywidgets
RUN pip install numpy
RUN pip install pandas
RUN pip install matplotlib
RUN pip install scikit-learn

# Like CD. Note that this is the mapped folder we specify in the docker-compose.yml
WORKDIR /root/projects
# CMD vs Entrypoint
# https://www.atatus.com/blog/docker-cmd-vs-entrypoints/#:~:text=CMD%20%2D%20The%20CMD%20describes%20the,use%20the%20%2D%2Dentrypoint%20flag.
CMD tail -f /dev/null