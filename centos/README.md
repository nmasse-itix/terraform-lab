# Lab of Centos Machines

Fetch the latest CentOS Stream 8 cloud image.

```sh
sudo curl -Lo /var/lib/libvirt/images/centos-stream-8.qcow2 http://cloud.centos.org/centos/8-stream/x86_64/images/CentOS-Stream-GenericCloud-8-20201217.0.x86_64.qcow2
```

Then, deploy the lab.

```sh
terraform init
terraform apply
```
