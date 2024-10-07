FROM fedora
WORKDIR /app
RUN yum update -y && yum install -y \
  ansible
COPY . /app
RUN ansible-playbook /app/playbooks/image.yml
