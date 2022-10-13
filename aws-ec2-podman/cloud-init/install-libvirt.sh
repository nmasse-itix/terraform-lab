#!/bin/bash

set -Eeuo pipefail

virsh destroy lab-podman || true
virsh undefine lab-podman || true
rm -rf /var/lib/libvirt/images/lab-podman

mkdir -p /var/lib/libvirt/images/base-images /var/lib/libvirt/images/lab-podman

if [ ! -f /var/lib/libvirt/images/base-images/Fedora-Cloud-Base-36-1.5.x86_64.qcow2 ]; then
  curl -Lo /var/lib/libvirt/images/base-images/Fedora-Cloud-Base-36-1.5.x86_64.qcow2 https://download.fedoraproject.org/pub/fedora/linux/releases/36/Cloud/x86_64/images/Fedora-Cloud-Base-36-1.5.x86_64.qcow2
fi

# dnf install -y cloud-utils genisoimage
cloud-localds /var/lib/libvirt/images/lab-podman/cloud-init.iso user-data.yaml

virt-install --name lab-podman --autostart --noautoconsole --cpu host-passthrough \
             --vcpus 2 --ram 4096 --os-variant fedora36 \
             --disk path=/var/lib/libvirt/images/lab-podman/lab-podman.qcow2,backing_store=/var/lib/libvirt/images/base-images/Fedora-Cloud-Base-36-1.5.x86_64.qcow2,size=20 \
             --network network=default \
             --console pty,target.type=virtio --serial pty --import \
             --disk path=/var/lib/libvirt/images/lab-podman/cloud-init.iso,readonly=on \
             --sysinfo system.serial=ds=nocloud

virsh console lab-podman
