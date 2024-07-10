## Background
 
POC to set up and foward logs to a Core Central Server. The assumption in this POC is that there is unfettered bi-directional traffic between our 2 networks. 

## Pre-requisite

Before proceeding, ensure you have the necessary tools installed on your host machine. We will use Vagrant to provision our virtual machines with virtual box as our provider. We will also utilize Ansible and Puppet for configuration setup in our guest machines. 

1. Vagrant: Open-source tool we can use to build and manage our virtual machines environments. This allows us to configure portable and consistent work environments. Vagrant streamlines the creation and management of virtual development environments using providers such as VirtualBox. Download link: https://releases.hashicorp.com/vagrant/

2. Virtual Box: Open-source virtualization software to create and run our Virtual Machines. This allows us to install and run multiple guest operating systems simultaneously, each isolated within its own environment. Download link: https://www.virtualbox.org/wiki/Downloads

3. Ansible: Used to automate deployment of configuration in our Ubuntu environment. Refer to official documentation for more information: https://docs.ansible.com/

For someone new to the tools above, these are some of the challenges and constraints that you might (or will) encounter when trying to set up your environment. 

1.	Ansible control node is not supported on windows. We can only use any UNIX-like machine with Python installed. This includes Red Hat, Debian, Ubuntu, macOS, BSDs, and Windows under a Windows Subsystem for Linux (WSL) distribution. I learned this the hard way. Do not attempt to use Cygwin with windows as a workaround as you will still encounter blockers when deploying the runbook. Reference: https://blog.rolpdog.com/2020/03/why-no-ansible-controller-for-windows.html

2.	The latest VirtualBox version does not provide support for running virtual machines with x86 architecture on ARM-based Macs. As of this writing, only version 7.0.8 has the developer preview for macOS/Arm64 hosts. 

 
## Deployment Steps

1. Using Vagrant and VirtualBox, provision 1 Ubuntu VM for the BMN hosts (hostname: bmn-host)

2. Using Vagrant and VirtualBox, provision 1 Ubuntu VM for the Security Services host (hostname: core-central-server)

3. Using Ansible, setup the Puppet Primary Server in the Core Central Server

4. Using Ansible, install the Puppet Agent in the BMN host and configure it to point to the Puppet Primary Server in the Core Central Server

5. Using Puppet, have rsyslog installed in the Core Central Server

6. Using Puppet, have nginx installed in the BMN host

7. Using Puppet, configure the BMN host to forward the nginx logs to the rsyslog server in theCore Central Server

## Verification

Verify our configuration. We can ssh into our machines and verify the configuration, tools and logs are in place. For example:

- `Vagrant ssh <<hostname>>`

Verify that the following service is running in BMN host: VM1  
- `systemctl status nginx.service` 
- `systemctl status puppet.service`

Verify that Nginx access logs from VM1 are being successfully forwarded to the rsyslog server in VM2. We can have 2 terminals open for this:
- In VM2, execute the following tail command to monitor and display the last few lines, so keep the terminal open: `tail -f /var/log/nginx.log`

- In VM1 (or any other host), we can try to access the server by using the curl command:
`curl http://192.168.56.11` to show access logs for `status code 200` OR `curl http://192.168.56.11/error` to stream error logs with `status code 404`

While step 6b is being executed, we can observe that the sample logs will be streamed and available on VM2.
