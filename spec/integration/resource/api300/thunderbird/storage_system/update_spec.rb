require 'spec_helper'

klass = OneviewSDK::API300::Thunderbird::StorageSystem
RSpec.describe klass, integration: true, type: UPDATE do
  include_context 'integration api300 context'

  before :all do
    @item = klass.get_all($client_300).first
    @fc_network = OneviewSDK::API300::Thunderbird::FCNetwork.find_by($client_300, {}).first
  end

  it "#updating fc_network unmanaged ports" do
    @item.data["unmanagedPorts"].at(2)["expectedNetworkUri"] = @fc_network.data['uri']
    @item.update
    new_item = klass.get_all($client_300).first
    expect(new_item['unmanagedPorts'].at(2)["expectedNetworkUri"]).to eq @fc_network.data['uri']
  end
end
