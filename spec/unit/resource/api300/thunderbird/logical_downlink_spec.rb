require 'spec_helper'

klass = OneviewSDK::API300::Thunderbird::LogicalDownlink
RSpec.describe klass do
  include_context 'shared context'

  it 'inherits from API200' do
    expect(described_class).to be < OneviewSDK::API200::LogicalDownlink
  end

  describe '#create' do
    it 'is unavailable' do
      logical_downlink = klass.new(@client_300)
      expect { logical_downlink.create }.to raise_error(OneviewSDK::MethodUnavailable, /The method #create is unavailable for this resource/)
    end
  end

  describe '#delete' do
    it 'is unavailable' do
      logical_downlink = klass.new(@client_300)
      expect { logical_downlink.delete }.to raise_error(OneviewSDK::MethodUnavailable, /The method #delete is unavailable for this resource/)
    end
  end

  describe '#update' do
    it 'is unavailable' do
      logical_downlink = klass.new(@client_300)
      expect { logical_downlink.update }.to raise_error(OneviewSDK::MethodUnavailable, /The method #update is unavailable for this resource/)
    end
  end

  describe '#get_without_ethernet' do
    it 'is unavailable' do
      logical_downlink = klass.new(@client_300)
      expect { logical_downlink.get_without_ethernet }
        .to raise_error(OneviewSDK::MethodUnavailable, /The method #get_without_ethernet is unavailable for this resource/)
    end
  end

  describe '#self.get_without_ethernet' do
    it 'is unavailable' do
      expect { klass.get_without_ethernet }
        .to raise_error(OneviewSDK::MethodUnavailable, /The method #self.get_without_ethernet is unavailable for this resource/)
    end
  end
end
