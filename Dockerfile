FROM fedora
RUN dnf update -y && dnf install -y \
  ansible
COPY . /opt/setup
RUN ansible-playbook /opt/setup/playbooks/image.yml
RUN mkdir /workspace && chown alice:alice /workspace
USER alice
VOLUME /home/alice/workspace
WORKDIR /home/alice/Projects
