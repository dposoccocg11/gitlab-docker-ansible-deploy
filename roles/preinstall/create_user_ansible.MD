sudo -i
# on ajoute le user ansible sur la cible et on set le password
useradd -m -s /bin/bash ansible
passwd ansible
# on ajoute le fichier ansible dans le sudoers.d/
echo -e 'ansible\tALL=(ALL)\tNOPASSWD:\tALL' > /etc/sudoers.d/ansible
#        Encrypt your password
        sudo apt install whois -y
        mkpasswd — method=SHA-512
        TYPE THE PASSWORD ‘ansible’

#        Generate a new SSH-key
ssh-keygen -t rsa

Now we have to add this public key to all the remote hosts.

#Create Ansible playbook “add-user-ssh.yml”
#Add a ansible user
#Now we want to disable the Password Authentication on all the remote hosts.This means no user/root user can login to the system by using password. They have to use the SSH keys only.
---
 - hosts: all
   vars:
     - ansible_password: 'abcddefsfdfdfdfdfdfdfdfdfdfd'
   gather_facts: no
   remote_user: ubuntu
   become: true
tasks:
- name: Add a new user named ansible
     user:
          name: ansible
          shell: /bin/bash
          password: "{{ ansible_password }}"
- name: Add ansible user to the sudoers
     copy:
          dest: "/etc/sudoers.d/ansible"
          content: "ansible  ALL=(ALL)  NOPASSWD: ALL"
- name: Deploy SSH Key
     authorized_key: user=ansible
                     key="{{ lookup('file', '/home/ansible/.ssh/id_rsa.pub') }}"
                     state=present
- name: Disable Password Authentication
     lineinfile:
           dest=/etc/ssh/sshd_config
           regexp='^PasswordAuthentication'
           line="PasswordAuthentication no"
           state=present
           backup=yes
- name: Disable Root Login
     lineinfile:
           dest=/etc/ssh/sshd_config
           regexp='^PermitRootLogin'
           line="PermitRootLogin no"
           state=present
           backup=yes
     notify:
       - restart ssh
handlers:
   - name: restart ssh
     service:
       name=sshd
       state=restarted


# Run the playbook
ansible-playbook add-user-ssh.yml -i hosts

#Validate Disable Password Authentication
$ ssh servername -o PubkeyAuthentication=no
#You will get the “Permission Denied(public key)
