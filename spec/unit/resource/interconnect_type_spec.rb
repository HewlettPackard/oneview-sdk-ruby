require 'spec_helper'

RSpec.describe OneviewSDK::InterconnectType do
  include_context 'shared context'

  describe 'undefined methods' do
    before :each do
      @item = OneviewSDK::InterconnectType.new(@client, {})
    end

    it 'does not allow the create action' do
      expect { @item.create }.to raise_error(/not available for this resource/)
    end

    it 'does not allow the update action' do
      expect { @item.update }.to raise_error(/not available for this resource/)
    end

    it 'does not allow the save action' do
      expect { @item.save }.to raise_error(/not available for this resource/)
    end

    it 'does not allow the delete action' do
      expect { @item.delete }.to raise_error(/not available for this resource/)
    end
  end
end
