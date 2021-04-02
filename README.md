Minimal code to start deploy machines on the **OVH Public Cloud** (OpenStack) with **Terraform** and **Ansible**.

Usage
-----

### 1. Install requirements


Install terraform :

- Download binary [v0.14.9](https://releases.hashicorp.com/terraform/0.14.9/) 
- Unzipping it and moving it to a directory included in your system's PATH.

If you want to use OpenStack CLI install python requirements (optional):
 
```bash
$ pip install -r requirements.txt
```

### 2. Set OpenStack variables

```bash
$ cp .env.example .env
```

Edit `.env` with sensitive values and load them in the shell

```bash
$ vim .env
$ source openrc.sh
```

### 3. Apply Terraform and Ansible config

```bash
$ terraform apply && ansible-playbook site.yml
```

### 4. Destroy the test server

```bash
$ terraform destroy
```
