# Podman Lab on AWS EC2

## Development on local machine

Pre-requisites: Libvirt on Fedora

```sh
cd cloud-init
./install-libvirt.sh
```

## Installation on AWS EC2

Pre-requisites:

- Terraform
- OpenSSL
- Bash
- mkpasswd
- gzip

```sh
cd cloud-init
./generate-users.sh
cd ..
terraform init
terraform apply
```

User accounts are in **cloud-init/users.csv**.
