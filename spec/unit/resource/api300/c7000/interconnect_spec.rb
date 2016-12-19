require 'spec_helper'

RSpec.describe OneviewSDK::API300::C7000::Interconnect do
  include_context 'shared context'

  it 'inherits from API200' do
    expect(described_class).to be < OneviewSDK::API200::Interconnect
  end

  describe 'undefined methods' do
    before :each do
      @item = OneviewSDK::API300::C7000::Interconnect.new(@client_300, {})
    end

    it 'does not allow the create action' do
      expect { @item.create }.to raise_error(/The method #create is unavailable for this resource/)
    end

    it 'does not allow the update action' do
      expect { @item.update }.to raise_error(/The method #update is unavailable for this resource/)
    end

    it 'does not allow the delete action' do
      expect { @item.delete }.to raise_error(/The method #delete is unavailable for this resource/)
    end
  end

  describe 'statistics' do
    before :each do
      @item = OneviewSDK::API300::C7000::Interconnect.new(@client_300, {})
    end

    it 'port' do
      expect(@client_300).to receive(:rest_get).with('/statistics/p1').and_return(FakeResponse.new)
      @item.statistics('p1')
    end

    it 'port and subport' do
      expect(@client_300).to receive(:rest_get).with('/statistics/p1/subport/sp1').and_return(FakeResponse.new)
      @item.statistics('p1', 'sp1')
    end

  end
end
