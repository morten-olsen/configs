FROM fedora
RUN dnf update -y && dnf install -y \
  ansible
RUN useradd -m -s /bin/bash -d /home/alice alice
COPY . /opt/setup
RUN ansible-playbook /opt/setup/playbooks/image.yml
RUN mkdir /workspace && chown alice:alice /workspace
USER dev
WORKDIR /workspace
