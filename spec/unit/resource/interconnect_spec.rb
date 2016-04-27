require 'spec_helper'

RSpec.describe OneviewSDK::Interconnect do
  include_context 'shared context'

  describe 'undefined methods' do
    before :each do
      @item = OneviewSDK::Interconnect.new(@client, {})
    end

    it 'does not allow the create action' do
      expect { @item.create }.to raise_error(/not available for this resource/)
    end

    it 'does not allow the update action' do
      expect { @item.update }.to raise_error(/not available for this resource/)
    end

    it 'does not allow the delete action' do
      expect { @item.delete }.to raise_error(/not available for this resource/)
    end
  end
end
