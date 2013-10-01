#!/bin/bash

image_name=centos
net_name=net1
vm_name=testvm1

required_nova_options=(force_config_drive flat_injected)

unset_options=""
for required_option in ${required_nova_options[*]}; do
    if [[ $(egrep "\<^\s*$required_option\>\s*=\s*True" /etc/nova/nova.conf | wc -l)  -eq 0 ]]; then
        unset_options="$unset_options $required_option"
    fi
done

if [[ $unset_options != "" ]]; then
    echo "Required option[s]: \"$unset_options\" is/are not set properly in nova.conf" 1>&2
    exit 1
else
    echo 'All nova options are set correctly'
fi

scp rverchikov@172.18.194.123:/home/rverchikov/Downloads/iso/centos-kvm/centos-6.4.qcow2 $HOME

image_exists=$(glance image-list | grep $image_name | wc -l)
if [[ $image_exists -ne 0 ]]; then
    glance image-delete $image_name
fi
glance image-create --name $image_name --disk-format qcow2 --container-format ovf --file $HOME/centos-6.4.qcow2

net_exists=$(neutron net-list | grep $net_name | wc -l)

if [[ $net_exists -ne 0 ]]; then
    neutron net-delete $net_name
fi

net_create=$(neutron net-create $net_name)
net_id=$(echo "$net_create" | egrep '\w{8}-\w{4}-\w{4}-\w{4}-\w{12}' | awk '{print $4;}')
neutron subnet-create --disable-dhcp $net_name 192.168.0.0/24

if [[ $(nova list | grep $vm_name | wc -l) -ne 0 ]]; then
    nova delete $vm_name
    sleep 5
fi
nova boot --image $image_name --flavor 2 --nic net-id=$net_id $vm_name

