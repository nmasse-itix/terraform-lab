# Windows 10 unattended install with packer

## Prerequisites

* CentOS Stream 8

## Installation

Install packer.

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

Install Qemu / KVM.

```sh
sudo dnf install qemu-kvm
```

## Build

Fetch the Qemu Guest tools.

```sh
curl -Lo virtio-win.iso https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso
```

Build the Windows image using Packer.

```sh
sudo /usr/bin/packer build windows_10.json
```

Store the built image in the libvirt default pool.

```sh
sudo cp windows_10-qemu/windows_10 /var/lib/libvirt/images/windows-10.qcow2
```
