# Terraform Lab

## Prerequisites

* CentOS Stream 8

## Installation

Install terraform.

```sh
cat > hashicorp.repo <<"EOF"
[hashicorp]
name=Hashicorp Stable - $basearch
baseurl=https://rpm.releases.hashicorp.com/RHEL/8/$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://rpm.releases.hashicorp.com/gpg
EOF
sudo dnf config-manager --add-repo hashicorp.repo
sudo dnf -y install packer
```

Install the terraform provider for libvirt.

```sh
curl -Lo /tmp/libvirt-provider.tgz https://github.com/dmacvicar/terraform-provider-libvirt/releases/download/v0.6.3/terraform-provider-libvirt-0.6.3+git.1604843676.67f4f2aa.Fedora_32.x86_64.tar.gz
mkdir -p ~/.terraform.d/plugins/registry.terraform.io/dmacvicar/libvirt/0.6.3/linux_amd64
tar xvf /tmp/libvirt-provider.tgz -C ~/.terraform.d/plugins/registry.terraform.io/dmacvicar/libvirt/0.6.3/linux_amd64
```

Install libvirt.

```sh
sudo dnf -y install libvirt libvirt-daemon-kvm virt-top nmap-ncat libguestfs-tools
sudo usermod -aG kvm $(whoami)
```

Create the libvirt default pool.

```sh
sudo virsh pool-define --file /dev/fd/0 <<EOF
<pool type='dir'>
  <name>default</name>
  <target>
    <path>/var/lib/libvirt/images/</path>
  </target>
</pool>
EOF
sudo virsh pool-autostart default
sudo virsh pool-start default
```

Install ansible.

```sh
sudo dnf -y install ansible
sudo pip3 install pywinrm
```

