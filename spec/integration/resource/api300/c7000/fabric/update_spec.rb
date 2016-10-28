require 'spec_helper'

klass = OneviewSDK::API300::C7000::Fabric
RSpec.describe klass, integration: true, type: UPDATE do
  include_context 'integration api300 context'

  describe 'GET' do
    it 'by #find_by' do
      item = klass.find_by($client_300, {}).first
      expect(item).to be
    end

    it 'by #retrieve!' do
      item = klass.new($client_300, 'name' => DEFAULT_FABRIC_NAME)
      expect { item.retrieve! }.to_not raise_error
      expect(item['uri']).to be
    end
  end
end
