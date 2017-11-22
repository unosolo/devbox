#!/usr/bin/env bash

host_name=$1

vagrant up

# Move private key to local dir where can be modified by vagrant
if [[ -f "~/vagrantsshkeys/devbox-private_key" ]]
then
	echo "all fine!"  > /dev/null 2>&1
else
	mkdir ~/vagrantsshkeys > /dev/null 2>&1
fi

mv .vagrant/machines/devbox/virtualbox/private_key ~/vagrantsshkeys/$host_name-private_key
ln -s ~/vagrantsshkeys/$host_name-private_key .vagrant/machines/devbox/virtualbox/private_key

# Run vagrant up again
vagrant up
