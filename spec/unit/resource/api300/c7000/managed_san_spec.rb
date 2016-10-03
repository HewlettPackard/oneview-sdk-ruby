require 'spec_helper'

RSpec.describe OneviewSDK::API300::C7000::ManagedSAN do
  include_context 'shared context'

  it 'inherits from API200' do
    expect(described_class).to be < OneviewSDK::API200::ManagedSAN
  end

  describe '#create' do
    it 'is unavailable' do
      san = OneviewSDK::API300::C7000::ManagedSAN.new(@client_300)
      expect { san.create }.to raise_error(/The method #create is unavailable for this resource/)
    end
  end

  describe '#delete' do
    it 'is unavailable' do
      san = OneviewSDK::API300::C7000::ManagedSAN.new(@client_300)
      expect { san.delete }.to raise_error(/The method #delete is unavailable for this resource/)
    end
  end

  describe '#update' do
    it 'is unavailable' do
      san = OneviewSDK::API300::C7000::ManagedSAN.new(@client_300)
      expect { san.update }.to raise_error(/The method #update is unavailable for this resource/)
    end
  end

  describe '#get_endpoints' do
    it 'List endpoints' do
      san = OneviewSDK::API300::C7000::ManagedSAN.new(@client_300, uri: '/rest/fc-sans/managed-sans/100')
      expect(@client_300).to receive(:rest_get).with('/rest/fc-sans/managed-sans/100/endpoints').and_return(FakeResponse.new({}))
      expect { san.get_endpoints }.not_to raise_error
    end
  end

  describe '#set_refresh_state' do
    it 'Refresh managed SAN' do
      san = OneviewSDK::API300::C7000::ManagedSAN.new(@client_300, uri: '/rest/fc-sans/managed-sans/100')
      expect(@client_300).to receive(:rest_put).with(
        '/rest/fc-sans/managed-sans/100',
        'body' => { refreshState: 'RefreshPending' }
      ).and_return(FakeResponse.new({}))
      san.set_refresh_state('RefreshPending')
    end
  end

  describe '#set_public_attributes' do
    it 'Update public attributes' do
      attributes = [
        {
          name: 'MetaSan',
          value: 'Neon SAN',
          valueType: 'String',
          valueFormat: 'None'
        }
      ]
      san = OneviewSDK::API300::C7000::ManagedSAN.new(@client_300, uri: '/rest/fc-sans/managed-sans/100')
      expect(@client_300).to receive(:rest_put).with(
        '/rest/fc-sans/managed-sans/100',
        'body' => { publicAttributes: attributes }
      ).and_return(FakeResponse.new({}))
      san.set_public_attributes(attributes)
    end
  end

  describe '#set_san_policy' do
    it 'Update san policy' do
      policy = {
        zoningPolicy: 'SingleInitiatorAllTargets',
        zoneNameFormat: '{hostName}_{initiatorWwn}',
        enableAliasing: true,
        initiatorNameFormat: '{hostName}_{initiatorWwn}',
        targetNameFormat: '{storageSystemName}_{targetName}',
        targetGroupNameFormat: '{storageSystemName}_{targetGroupName}'
      }
      san = OneviewSDK::API300::C7000::ManagedSAN.new(@client_300, uri: '/rest/fc-sans/managed-sans/100')
      expect(@client_300).to receive(:rest_put).with(
        '/rest/fc-sans/managed-sans/100',
        'body' => { sanPolicy: policy }
      ).and_return(FakeResponse.new({}))
      san.set_san_policy(policy)
    end
  end

  describe '#get_zoning_report' do
    it 'Retrieve zoning report' do
      san = OneviewSDK::API300::C7000::ManagedSAN.new(@client_300, uri: '/rest/fc-sans/managed-sans/100')
      expect(@client_300).to receive(:rest_post).with(
        '/rest/fc-sans/managed-sans/100/issues',
        'body' => {}
      ).and_return(FakeResponse.new({}))
      san.get_zoning_report
    end
  end
end
