oneview_ethernet_network 'Create network from template' do
  template 'ov_1/Network/vlan01.json'
end

oneview_instance 'Deploy on instance 192.168.1.1' do
  template_path 'ov_instance_2'
  action :deploy
end

oneview_instance 'Delete all elements of 192.168.1.1' do
  action :erase_all
end
