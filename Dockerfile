FROM fedora
RUN dnf update -y && dnf install -y \
  ansible
WORKDIR /opt/setuo
COPY ./requirements.yml /opt/setup
RUN ansible-galaxy collection install -r requirements.yml
COPY . /opt/setup
RUN ansible-playbook /opt/setup/playbooks/image.yml
RUN mkdir /workspace && chown alice:alice /workspace
USER alice
VOLUME /home/alice/workspace
WORKDIR /home/alice/Projects
