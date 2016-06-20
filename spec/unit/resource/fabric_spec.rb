require 'spec_helper'

RSpec.describe OneviewSDK::Fabric do
  include_context 'shared context'


  describe 'Unavaible methods' do
    it '#create' do
      item = OneviewSDK::Fabric.new(@client, 'name' => 'unit_fabric')
      expect { item.create }.to raise_error(/unavailable for this resource/)
    end

    it '#update' do
      item = OneviewSDK::Fabric.new(@client, 'name' => 'unit_fabric')
      expect { item.update }.to raise_error(/unavailable for this resource/)
    end

    it '#delete' do
      item = OneviewSDK::Fabric.new(@client, 'name' => 'unit_fabric')
      expect { item.delete }.to raise_error(/unavailable for this resource/)
    end

    it '#refresh' do
      item = OneviewSDK::Fabric.new(@client, 'name' => 'unit_fabric')
      expect { item.refresh }.to raise_error(/unavailable for this resource/)
    end
  end
end
