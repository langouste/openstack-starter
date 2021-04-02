terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "1.40.0"
    }
  }
}

provider "openstack" {
  auth_url    = "https://auth.cloud.ovh.net/v3"
  domain_name = "default"
}

resource "openstack_compute_keypair_v2" "ansible-keypair" {
  name       = "ansible"
  public_key = file("~/.ssh/ovhcloud.pub")
}

resource "openstack_compute_instance_v2" "test-server" {
  name        = "ubuntu-test"
  image_id    = "6c86b11d-b5f9-43b6-9eb0-4eed28532f4c" # Ubuntu 20.04 LTS
  flavor_name = "s1-2"                                 # Sandbox 2Go RAM / 10Go SSD
  key_pair    = openstack_compute_keypair_v2.ansible-keypair.name
}

# Generate ansible inventory file
resource "local_file" "inventory" {
  filename = "hosts"
  content  = <<EOF
[sandbox]
${openstack_compute_instance_v2.test-server.name} ansible_host=${openstack_compute_instance_v2.test-server.access_ip_v4} ansible_user=ubuntu

EOF
}
