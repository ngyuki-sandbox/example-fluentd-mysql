Vagrant.configure(2) do |config|

  config.vm.box = "bento/centos-7.2"
  config.ssh.insert_key = false

  config.vm.define "ap01" do |config|
    config.vm.hostname = "ap01"
    config.vm.network :private_network, ip: "192.168.33.11", virtualbox__intnet: "fluentd-mysql"
  end

  config.vm.define "logdb" do |config|
    config.vm.hostname = "logdb"
    config.vm.network :private_network, ip: "192.168.33.20", virtualbox__intnet: "fluentd-mysql"
  end

  config.vm.provider :virtualbox do |v|
    v.linked_clone = true
  end

  config.vm.provision "shell", inline: <<-SHELL
    sudo yum -y install vim-enhanced nc rsync tcpdump bash-completion epel-release
    sudo cp -f /vagrant/hosts /etc/hosts
  SHELL

end
