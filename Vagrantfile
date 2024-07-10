Vagrant.configure("2") do |config|
    # ---
    # Business Managed Network
    # --
    config.vm.define "vm1" do |vm1|
      vm1.vm.box = "generic/ubuntu1804"
      vm1.vm.network "private_network", ip: "192.168.56.11"
      vm1.vm.provision "ansible" do |ansible|
        ansible.playbook = "vm1.yml"
      end
    end

    # ---
    # Security Services Network
    # --
    config.vm.define "vm2" do |vm2|
      vm2.vm.box = "generic/ubuntu1804"
      vm2.vm.network "private_network", ip: "192.168.56.12"
      vm2.vm.provider "virtualbox" do |vb|
        vb.memory = 4096
      end
      vm2.vm.provision "ansible" do |ansible|
        ansible.playbook = "vm2.yml"
      end
    end
  end
  