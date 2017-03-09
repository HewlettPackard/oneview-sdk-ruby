require 'spec_helper'

RSpec.describe OneviewSDK::LogicalDownlink do
  include_context 'shared context'

  describe '#create' do
    it 'is unavailable' do
      logical_downlink = OneviewSDK::LogicalDownlink.new(@client_200)
      expect { logical_downlink.create }.to raise_error(OneviewSDK::MethodUnavailable, /The method #create is unavailable for this resource/)
    end
  end

  describe '#delete' do
    it 'is unavailable' do
      logical_downlink = OneviewSDK::LogicalDownlink.new(@client_200)
      expect { logical_downlink.delete }.to raise_error(OneviewSDK::MethodUnavailable, /The method #delete is unavailable for this resource/)
    end
  end

  describe '#update' do
    it 'is unavailable' do
      logical_downlink = OneviewSDK::LogicalDownlink.new(@client_200)
      expect { logical_downlink.update }.to raise_error(OneviewSDK::MethodUnavailable, /The method #update is unavailable for this resource/)
    end
  end

  describe '#get_without_ethernet' do
    it 'retrieve logical downlinks without ethernet' do
      expect(@client_200).to receive(:rest_get).with('/rest/logical-downlinks/ld1/withoutEthernet').and_return(FakeResponse.new({}))
      logical_downlink = OneviewSDK::LogicalDownlink.new(@client_200, uri: '/rest/logical-downlinks/ld1')
      logical_downlink.get_without_ethernet
      expect(logical_downlink.class).to eq(described_class)
    end
  end

  describe '#self.get_without_ethernet' do
    it 'retrieve logical downlinks without ethernet' do
      expect(@client_200).to receive(:rest_get).with('/rest/logical-downlinks/withoutEthernet').and_return(FakeResponse.new('members' => [{}]))
      logical_downlinks = OneviewSDK::LogicalDownlink.get_without_ethernet(@client_200)
      expect(logical_downlinks.first.class).to eq(described_class)
    end
  end

end
