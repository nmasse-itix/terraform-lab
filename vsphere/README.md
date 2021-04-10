# Lab of vSphere Machines

Fetch the latest vSphere 7.0 installation iso and customize it for automated install.

```sh
sudo mount VMware-VMvisor-Installer-7.0U1c-17325551.x86_64.iso /mnt -o loop,ro
sudo mkdir /tmp/vsphere-custom
sudo cp -rv /mnt/* /tmp/vsphere-custom
sudo umount /mnt
sudo sed -i -r 's|^(kernelopt=.*)|\1 ks=https://raw.githubusercontent.com/nmasse-itix/terraform-lab/main/vsphere/itix-ks.cfg|' /tmp/vsphere-custom/boot.cfg
sudo sed -i -r 's|^(kernelopt=.*)|\1 ks=https://raw.githubusercontent.com/nmasse-itix/terraform-lab/main/vsphere/itix-ks.cfg|' /tmp/vsphere-custom/efi/boot/boot.cfg
sudo dnf install genisoimage
sudo genisoimage -relaxed-filenames -J -R -o /tmp/vsphere-custom.iso -b isolinux.bin -c boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -eltorito-alt-boot -e efiboot.img -no-emul-boot /tmp/vsphere-custom
sudo cp /tmp/vsphere-custom.iso /var/lib/libvirt/images/
```

Then, deploy the lab.

```sh
terraform init
terraform apply
```

## References

* https://www.grottedubarbu.fr/nested-virtualization-esxi-kvm/
* https://itsjustbytes.com/2020/12/14/kvm-esxi-7-as-a-nested-cluster/
* https://fabianlee.org/2018/09/19/kvm-deploying-a-nested-version-of-vmware-esxi-6-7-inside-kvm/
* http://vnews.fr/construire-un-custom-iso-de-vmware-vsphere-esxi-6/
