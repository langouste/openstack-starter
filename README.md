Minimal code to start deploy machines on the **OVH Public Cloud** (OpenStack) with **Terraform** and **Ansible**.

Usage without docker
--------------------

Instructions for use directly on your system. For use with docker see below.

### 1. Install requirements


Install terraform :

- Download binary [v0.14.9](https://releases.hashicorp.com/terraform/0.14.9/) 
- Unzipping it and moving it to a directory included in your system's PATH.

Install ansible :

- [See instructions for specific operating systems.](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-ansible-on-specific-operating-systems)

If you want to use OpenStack CLI, install python requirements (optional):
 
```bash
$ pip install -r requirements.txt
```

### 2. Set OpenStack configuration and keypair

```bash
$ cp .env.example .env
```

Edit `.env` with sensitive values and load them in the shell

```bash
$ vim .env
$ source openrc.sh
```

Geerate a RSA keypair

```bash
$ ssh-keygen -t rsa -b 4096 -f ~/.ssh/ovhcloud
```

### 3. Apply Terraform and Ansible config

Install terraform plugins

```bash
$ terraform init
```

```bash
$ terraform apply
$ ansible-playbook site.yml
```

### 4. Destroy the test server

```bash
$ terraform destroy
```

Usage with docker
-----------------

### 1. Set OpenStack configuration and keypair

```bash
$ cp .env.example .env
```

Edit `.env` with sensitive values and load them in the shell

```bash
$ vim .env
```

### 2. Use tools on docker via make

```bash
$ make shell
(...)
bash-5.1# ./create-server.sh
bash-5.1# source openrc.sh
bash-5.1# openstack server list
+--------------------------------------+-------------+--------+----------------------------------------------+-------+--------+
| ID                                   | Name        | Status | Networks                                     | Image | Flavor |
+--------------------------------------+-------------+--------+----------------------------------------------+-------+--------+
| e624c727-13ab-4cce-b797-3cb56d50591c | ubuntu-test | ACTIVE | Ext-Net=2001:41d0:801:1000::2138, 54.37.5.51 |       | s1-2   |
+--------------------------------------+-------------+--------+----------------------------------------------+-------+--------+

bash-5.1# wget -q -O - 54.37.5.51; echo
Hello world !
bash-5.1# terraform destroy
bash-5.1# exit
$ make clean
```

If you edit some files re-copy then in the container

```bash
$ make
Copy this files in the container : .env openrc.sh main.tf .terraform.lock.hcl ansible.cfg site.yml
```

Usage with nixpkgs
------------------

Only __nixpkgs__ and __pip__ required.

### 1. Install python requirements in a virtual env (optional)

```bash
$ python -m venv .venv
$ pip install -r requirements.txt
```

### 2. Get a working environment


```bash
$ nix-shell
```

This command :

- Install system dependencies (terraform, ansible)
- Load environment variables on openrc.sh
- Activate the virtual python environment .venv

Next you can use terraform and ansible commands to perform actions described below.
