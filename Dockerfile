FROM ubuntu:latest
LABEL maintainer="roseline124 <guseod24@gmail.com>"

ENV LANG=C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends tzdata g++ curl wget \
    build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev \
    libsqlite3-dev libncursesw5-dev xz-utils tk-dev libxml2-dev \
    libxmlsec1-dev libffi-dev liblzma-dev openjdk-8-jdk && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set JAVA_HOME
ENV JAVA_HOME="/usr/lib/jvm/java-1.8-openjdk"

# Install Python
RUN wget https://www.python.org/ftp/python/3.11.6/Python-3.11.6.tgz && \
    tar xvf Python-3.11.6.tgz && \
    cd Python-3.11.6 && \
    ./configure && \
    make && \
    make install && \
    cd .. && \
    rm -rf Python-3.11.6.tgz Python-3.11.6 && \
    ln -s /usr/local/bin/python3.11 /usr/bin/python && \
    ln -s /usr/local/bin/pip3 /usr/bin/pip && \
    pip install --upgrade pip

# Set working directory
WORKDIR /app

# Copy files
COPY . /app

# Install Python packages
RUN pip install -r requirements.txt

# Expose port
EXPOSE 80

# Command to run the application
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80"]