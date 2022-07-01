#! /bin/bash

# Step #1 - Installing lxd(if not installed)
if  [ -f /snap/bin/lxd ]; then
    echo 'You have already installed lxd'
else
    echo 'Installing lxd...' && sudo snap install lxd
fi

# Step #2 - Configure lxd if no lxdbr0 interface exists
if ip a | grep lxdbr0 &> /dev/null; then 
    echo "Found lxdbr0 interface..."
else
    echo "Adding lxdbr0..."; 
    sudo lxd init --auto; 
fi

# Step #3 - Launch container (only if it doesnt exist)
if sudo lxc list | grep -w COMP2101-S22 &> /dev/null; then
    echo "Container has been launched already."
else
    sudo lxc launch images:ubuntu/20.04/amd64 COMP2101-S22; 
fi

# Step #4 - Add container name and IP to /etc/hosts file
entry=`sudo lxc list -c n4 | grep COMP2101-S22 | awk '{print $4}'`
[ -n "$entry" ] && echo "$entry COMP2101-S22" | sudo tee /etc/hosts

# Step #5 - Install Apache2
sudo lxc exec COMP2101-S22 -- apt list --installed apache2 | grep installed &> /dev/null
if [ $? -ne 0 ]; then
    echo "Installing apache2 on COMP2101-S22"
    # Step #5.2 - Update the repository
    sudo lxc exec COMP2101-S22 -- apt-get update &> /dev/null
    # Step #5.3 - Install Apache2
    sudo lxc exec COMP2101-S22 -- apt-get -y install apache2 &> /dev/null && echo "Apache2 has been installed..."
else
    echo "You have already installed Apache2"
fi

# Step #6 - Retrieve COMP2101-S22 homepage
if curl http://COMP2101-S22 &> /dev/null; then
    echo "Success fetching homepage"
else
    echo "Failure when fetching homepage"
fi
