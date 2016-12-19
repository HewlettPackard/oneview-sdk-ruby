require 'spec_helper'

RSpec.describe OneviewSDK::Fabric, integration: true, type: UPDATE do
  include_context 'integration context'

  describe 'GET' do
    it 'by #find_by' do
      item = OneviewSDK::Fabric.find_by($client, {}).first
      expect(item).to be
    end

    it 'by #retrieve!' do
      item = OneviewSDK::Fabric.new($client, 'name' => DEFAULT_FABRIC_NAME)
      expect { item.retrieve! }.to_not raise_error
      expect(item['uri']).to be
    end
  end
end
