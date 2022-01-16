Vagrant.configure("2") do |config|
  config.vm.box = "debian/buster64"
  config.vm.provision :shell, path: "bootstrap.sh", :args => ""
  config.vm.synced_folder ".", "/raspberry-pi-ansible-bootstrap", type: "rsync", automount: true
  config.vm.network "private_network", type: "dhcp"
end
