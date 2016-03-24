
require_relative '../../spec_helper'
require_relative 'resource'

RSpec.describe 'Reset resource pool' do
  include_context 'system test'

  it 'Change context' do
    puts "Aqui #{RSpec::Resource.ethernet_network}"
  end
=begin
  eth1 = OneviewSDK::EthernetNetwork.new(@client, name: 'OneviewSDK System Test')
  eth1.retrieve!
  fc1 = OneviewSDK::FCNetwork.new(@client, name: 'OneViewSDK FC System test')
  fc1.retrieve!
  fcoe1 = OneviewSDK::FCoENetwork.new(@client, name: 'OneviewSDK Fcoe System test')
  fcoe1.retrieve!
  eg1 = OneviewSDK::EnclosureGroup.new(@client, name: 'OneViewSDK system test')
  eg1.retrieve!
=end
end
