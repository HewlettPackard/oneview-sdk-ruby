require 'spec_helper'

klass = OneviewSDK::API300::Thunderbird::LogicalSwitchGroup
RSpec.describe klass do
  include_context 'shared context'

  it 'inherits from API200' do
    expect(described_class).to be < OneviewSDK::API200::LogicalSwitchGroup
  end

  describe 'Unavaible methods' do
    before :each do
      @item = klass.new(@client_300)
    end

    it '#create' do
      expect { @item.create }.to raise_error(OneviewSDK::MethodUnavailable, /unavailable for this resource/)
    end

    it '#update' do
      expect { @item.update }.to raise_error(OneviewSDK::MethodUnavailable, /unavailable for this resource/)
    end

    it '#delete' do
      expect { @item.delete }.to raise_error(OneviewSDK::MethodUnavailable, /unavailable for this resource/)
    end

    it '#set_grouping_parameters' do
      expect { @item.set_grouping_parameters }.to raise_error(OneviewSDK::MethodUnavailable, /unavailable for this resource/)
    end
  end
end
