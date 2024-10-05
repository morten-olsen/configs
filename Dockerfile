FROM debian:bookworm
WORKDIR /app
RUN apt-get update && apt-get install -y \
  python3 \
  python3-pip \
  && rm -rf /var/lib/apt/lists/*
COPY requirements.txt /app
RUN pip3 install -r requirements.txt
COPY . /app
