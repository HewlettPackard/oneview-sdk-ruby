require 'spec_helper'

klass = OneviewSDK::ManagedSAN
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_context 'integration context'

  let(:fc_options) do
    {
      connectionTemplateUri: nil,
      autoLoginRedistribution: true,
      fabricType: 'FabricAttach'
    }
  end

  describe 'Import SANs' do
    it 'create fc networks' do
      OneviewSDK::ManagedSAN.find_by($client, deviceManagerName: $secrets['san_manager_ip']).each do |san|
        options = fc_options
        options[:name] = "FC_#{san['name']}"
        options[:managedSanUri] = san['uri']
        fc = OneviewSDK::FCNetwork.new($client, options)
        fc.create
        expect(fc['uri']).to be
      end
    end
  end
end
