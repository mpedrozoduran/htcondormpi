#!/bin/bash

# Disable SELinux - this is a manual step

set_initial_config() {
	echo "Setting up initial configuration on host $2..."
	# Install VIM and WGET
	sudo yum install vim wget -y 
	# Setup hostname
	sudo hostnamectl set-hostname $2

	# Add entries to /etc/hosts
	echo "Adding entries to /etc/hosts file"
	sudo sh -c "echo '#### Start CAD Cluster Hosts ####' >> /etc/hosts"
	sudo sh -c "echo '172.16.0.105 cad01-head01.company.edu.co cad01-head01' >> /etc/hosts"
	sudo sh -c "echo '172.16.0.101 cad01-submit01.company.edu.co cad01-submit01' >> /etc/hosts"
	sudo sh -c "echo '172.16.0.109 cad01-nfs01.company.edu.co cad01-nfs01' >> /etc/hosts"
	sudo sh -c "echo '172.16.0.108 cad01-w000.company.edu.co cad01-w000' >> /etc/hosts"
	sudo sh -c "echo '172.16.0.111 cad01-w001.company.edu.co cad01-w001' >> /etc/hosts"
	sudo sh -c "echo '172.16.0.100 cad01-w002.company.edu.co cad01-w002' >> /etc/hosts"
	sudo sh -c "echo '172.16.0.104 cad01-w003.company.edu.co cad01-w003' >> /etc/hosts"
	sudo sh -c "echo '172.16.0.112 cad01-w004.company.edu.co cad01-w004' >> /etc/hosts"
	sudo sh -c "echo '172.16.0.116 cad01-w005.company.edu.co cad01-w005' >> /etc/hosts"
	sudo sh -c "echo '172.16.0.114 cad01-w006.company.edu.co cad01-w006' >> /etc/hosts"
	sudo sh -c "echo '#### End of CAD Cluster Hosts ####' >> /etc/hosts"

	# Disable Firewall
	echo "Disable firewall"
	sudo systemctl stop firewalld
	sudo systemctl disable firewalld
	# Install and configure ntpd
	echo "Configure NTPD"
	sudo yum install ntpdate -y
	sudo chkconfig --level 35 ntpdate on
	sudo systemctl start ntpdate
	sudo ntpdate -u 0.rhel.pool.ntp.org
	sudo systemctl enable ntpdate
}

# Install and configure NFS server
install_nfs_server() {
	echo "Installing NFS Server on this host..."
	sudo yum install nfs-utils -y 
	echo "Finished!"	
	sudo sh -c "echo 'Domain = company.edu.co' >> /etc/idmapd.conf"
}
configure_nfs_server() {
	echo "Configuring NFS Server on this host..."
	
	echo "Creating directories in /exports"
	sudo mkdir -p /exports/condor
	sudo mkdir -p /exports/data

	echo "Adding entries to /etc/exports"
	sudo sh -c "echo '/exports/condor 172.16.0.0/24(rw,no_root_squash)' >> /etc/exports"
	sudo sh -c "echo '/exports/data 172.16.0.0/24(rw,no_root_squash)' >> /etc/exports"

	echo "Enabling nfs-server service"
	sudo systemctl start rpcbind nfs-server
	sudo systemctl enable rpcbind nfs-server
	echo "Finished!"	
}
# Install and configure NFS client
install_nfs_client() {
	echo "Installing NFS Client on this host..."
	sudo yum install nfs-utils -y
	sudo sh -c "echo 'Domain = company.edu.co' >> /etc/idmapd.conf"
	echo "Finished!"	

}
configure_nfs_client() {
	echo "Configuring NFS Client on this host..."
	
	echo "Creating directories in /nfs..."
	sudo mkdir -p /nfs/condor
	sudo mkdir -p /nfs/data
	
	echo "Starting rpcbind service..."
	sudo systemctl start rpcbind
	sudo systemctl enable rpcbind
	
	echo "Mounting directories..."
	sudo mount -t nfs cad01-nfs01.company.edu.co:/exports/condor /nfs/condor
	sudo mount -t nfs cad01-nfs01.company.edu.co:/exports/data /nfs/data
	
	echo "Adding entries to /etc/fstab"
	sudo sh -c "echo 'cad01-nfs01.company.edu.co:/exports/condor  /nfs/condor                   nfs     defaults        0 0' >> /etc/fstab"
	sudo sh -c "echo 'cad01-nfs01.company.edu.co:/exports/data  /nfs/data                   nfs     defaults        0 0' >> /etc/fstab"

	echo "Configuring autofs..."
	sudo yum install autofs -y
	sudo sh -c "echo '/-    /etc/auto.mount' >> /etc/auto.master"
	sudo sh -c "echo '/nfs/condor -fstype=nfs,rw cad01-nfs01.company.edu.co:/exports/condor' >> /etc/auto.mount"
	sudo sh -c "echo '/nfs/data -fstype=nfs,rw cad01-nfs01.company.edu.co:/exports/data' >> /etc/auto.mount"
	sudo systemctl start autofs
	sudo systemctl enable autofs
	cat /proc/mounts | grep "/nfs"
	echo "Finished!"
}
# Install Condor
install_htcondor() {
	echo "Installing HTCondor on this host..."

	echo "Changing to /etc/yum.repos.d directory"
	cd /etc/yum.repos.d

	echo "Downloading repo file..."
	sudo wget -c http://research.cs.wisc.edu/htcondor/yum/repo.d/htcondor-stable-rhel7.repo
	
	echo "Importing repo key..."
	sudo wget -c http://research.cs.wisc.edu/htcondor/yum/RPM-GPG-KEY-HTCondor
	sudo rpm --import RPM-GPG-KEY-HTCondor
	
	echo "Installing HTCondor..."
	sudo yum install condor-all -y
	
	echo "Enabling HTCondor... "
	sudo systemctl enable condor 
	sudo systemctl start condor 
	sudo systemctl status condor

	#echo "Changing owner to dir /nfs for user condor"
	#sudo chown -R condor:condor /nfs/condor
	#sudo chown -R condor:condor /nfs/data
	echo "Finished!"
}
# Usage
usage() {
	echo "Bad argument!"
		echo "Usage: $0 <OPTION> "
		echo "Where OPTION is one of the following:"
		echo "	init_config [HOSTNAME]"
		echo "	install_nfs_server"
		echo "	install_nfs_client"
		echo "	config_nfs_server"
		echo "	config_nfs_client"
		echo "	install_htcondor"
}

OPT=$1

## Start ##
case $OPT in
	"init_config" )
		if [ $# -eq 2 ] 
		then
			set_initial_config
		else
			usage
		fi
		;;
	"install_nfs_server" )
		install_nfs_server
		;;
	"config_nfs_server" )
		configure_nfs_server
		;;
	"install_nfs_client" )
		install_nfs_client
		;;
	"config_nfs_client" )
		configure_nfs_client
		;;
	"install_htcondor" )
		install_htcondor
		;;
	*)
		usage
		;;
esac

