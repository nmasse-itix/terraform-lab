# Lab of Centos Machines

Fetch the latest CentOS Stream 8 cloud image.

```sh
sudo curl -Lo /var/lib/libvirt/images/centos-stream-8.qcow2 http://cloud.centos.org/centos/8-stream/x86_64/images/CentOS-Stream-GenericCloud-8-20201217.0.x86_64.qcow2
```

Define a new network with VLANs.

```xml
<network>
    <name>lab</name>
    <forward mode="bridge" />
    <bridge name="lab" />
    <virtualport type='openvswitch'>
    </virtualport>
    <portgroup name='lab7' default='yes'>
    </portgroup>
    <portgroup name='lab8'>
        <vlan>
        <tag id='8'/>
        </vlan>
    </portgroup>
    <portgroup name='lab16'>
        <vlan>
        <tag id='16'/>
        </vlan>
    </portgroup>
</network>
```

Then, deploy the lab.

```sh
export LIBVIRT_DEFAULT_URI=qemu:///system
terraform init
terraform apply
```

Destroy the lab.

```sh
terraform destroy
```

Edit patch.xml and change the target portgroup to "lab8".

```sh
terraform apply -var centos_mac_format=02:01:08:00:08:%02x
```
