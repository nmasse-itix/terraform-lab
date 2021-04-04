# Lab of CoreOS Machines

Fetch the latest CoreOS cloud image.

```sh
curl -Lo fedora-coreos-33.qcow2.xz https://builds.coreos.fedoraproject.org/prod/streams/stable/builds/33.20210217.3.0/x86_64/fedora-coreos-33.20210217.3.0-qemu.x86_64.qcow2.xz
xz -d fedora-coreos-33.qcow2.xz
sudo cp fedora-coreos-33.qcow2 /var/lib/libvirt/images/
```

Then, deploy the lab.

```sh
terraform init
terraform apply
```
