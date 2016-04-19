require 'spec_helper'

RSpec.describe OneviewSDK::Interconnect do
  include_context 'shared context'

  describe 'undefined methods' do
    before :each do
      @item = OneviewSDK::Interconnect.new(@client, {})
    end

    it 'does not allow the create action' do
      expect { @item.create }.to raise_error(/The method #create is unavailable for this resource/)
    end

    it 'does not allow the update action' do
      expect { @item.update }.to raise_error(/The method #update is unavailable for this resource/)
    end

    it 'does not allow the save action' do
      expect { @item.save }.to raise_error(/The method #save is unavailable for this resource/)
    end
  end
end
