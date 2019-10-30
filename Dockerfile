FROM centos:6
LABEL maintainer="Jeff Geerling"

# Install Ansible and other requirements.
RUN yum makecache fast \
 && yum -y install deltarpm epel-release \
 && yum -y update \
 && yum -y install \
      ansible \
      sudo \
      which \
      initscripts \
      python-urllib3 \
      pyOpenSSL \
      python2-ndg_httpsclient \
      python-pyasn1 \
 && yum clean all

# Disable requiretty.
RUN sed -i -e 's/^\(Defaults\s*requiretty\)/#--- \1/'  /etc/sudoers

# Install Ansible inventory file.
RUN mkdir -p /etc/ansible
RUN echo -e '[local]\nlocalhost ansible_connection=local' > /etc/ansible/hosts

# Remove unnecessary getty and udev services that can result in high CPU usage when using
# multiple containers with Molecule (https://github.com/ansible/molecule/issues/1104)
RUN sed -i '/start_udev/s/^/#/g' /etc/rc.d/rc.sysinit \
  && rm -f /etc/init/tty.conf

CMD ["/sbin/init"]
