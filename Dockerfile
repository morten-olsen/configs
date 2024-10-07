FROM fedora
WORKDIR /app
RUN yum update -y && yum install -y \
  ansible
COPY requirements.yml /app
RUN ansible-galaxy collection install -r requirements.yml
COPY . /app
RUN ansible-playbook /app/playbooks/image.yml
