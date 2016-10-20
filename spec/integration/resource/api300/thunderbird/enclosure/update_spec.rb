require 'spec_helper'

klass = OneviewSDK::API300::Thunderbird::Enclosure
RSpec.describe klass, integration: true, type: UPDATE do
  include_context 'integration api300 context'

  before :each do
    @item = klass.find_by($client_300, name: ENCL_NAME).first
  end

  # describe '#update' do
  #   it 'Changes name' do
  #     @item.update(name: ENCL_NAME_UPDATED)
  #     expect(@item[:name]).to eq(ENCL_NAME_UPDATED)
  #     @item.update(name: ENCL_NAME) # Put it back to normal
  #     expect(@item[:name]).to eq(ENCL_NAME)
  #   end
  # end
  #
  # describe '#configuration' do
  #   it 'update OneViewSDK_Int_Ethernet_Network name' do
  #     expect { @item.configuration }.not_to raise_error
  #   end
  # end
  #
  # describe '#refreshState' do
  #   it 'returns all resources when the hash is empty' do
  #     expect { @item.set_refresh_state('RefreshPending') }.not_to raise_error
  #   end
  # end

  describe '#patch' do
    it 'replaces the enclosure name and sets it back to the original' do
      expect { @item.patch('replace', '/name', ENCL_NAME_UPDATED) }.not_to raise_error
      @item.retrieve!
      expect(@item['name']).to eq(ENCL_NAME_UPDATED)
      expect { @item.patch('replace', '/name', ENCL_NAME) }.not_to raise_error
      @item.retrieve!
      expect(@item['name']).to eq(ENCL_NAME)
    end
  end
end
