require 'spec_helper'

RSpec.describe OneviewSDK::API300::Thunderbird::Fabric do
  include_context 'shared context'

  it 'inherits from API200' do
    expect(described_class).to be < OneviewSDK::API200::Fabric
  end

  describe 'Unavaible methods' do
    it '#create' do
      item = OneviewSDK::API300::Thunderbird::Fabric.new(@client_300, 'name' => 'unit_fabric')
      expect { item.create }.to raise_error(OneviewSDK::MethodUnavailable, /unavailable for this resource/)
    end

    it '#update' do
      item = OneviewSDK::API300::Thunderbird::Fabric.new(@client_300, 'name' => 'unit_fabric')
      expect { item.update }.to raise_error(OneviewSDK::MethodUnavailable, /unavailable for this resource/)
    end

    it '#delete' do
      item = OneviewSDK::API300::Thunderbird::Fabric.new(@client_300, 'name' => 'unit_fabric')
      expect { item.delete }.to raise_error(OneviewSDK::MethodUnavailable, /unavailable for this resource/)
    end

    it '#refresh' do
      item = OneviewSDK::API300::Thunderbird::Fabric.new(@client_300, 'name' => 'unit_fabric')
      expect { item.refresh }.to raise_error(OneviewSDK::MethodUnavailable, /unavailable for this resource/)
    end
  end
end
