require 'spec_helper'

RSpec.describe OneviewSDK::API600::C7000::VolumeTemplate do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API500::C7000::VolumeTemplate' do
    expect(described_class).to be < OneviewSDK::API500::C7000::VolumeTemplate
  end

  describe '::get_reachable_volume_templates' do
    it 'should call the api correct' do
      expect(described_class).to receive(:find_by).with(@client_600, {}, '/rest/storage-volume-templates/reachable-volume-templates')
      described_class.get_reachable_volume_templates(@client_600)
    end

    context 'when pass networks to paramaters list' do
      it 'should call the api correct' do
        expect(described_class).to receive(:find_by)
          .with(@client_600, {}, "/rest/storage-volume-templates/reachable-volume-templates?networks='/rest/fc-networks/1,/rest/fc-networks/2'")
        network_1 = OneviewSDK::API600::C7000::FCNetwork.new(@client_600, uri: '/rest/fc-networks/1')
        network_2 = OneviewSDK::API600::C7000::FCNetwork.new(@client_600, uri: '/rest/fc-networks/2')
        described_class.get_reachable_volume_templates(@client_600, {}, 'networks' => [network_1['uri'], network_2['uri']])
      end
    end

    context 'when pass attributes to paramaters list' do
      it 'should call the api correct' do
        expect(described_class).to receive(:find_by)
          .with(@client_600, { some_attribute: 'some value' }, '/rest/storage-volume-templates/reachable-volume-templates')
        described_class.get_reachable_volume_templates(@client_600, some_attribute: 'some value')
      end
    end
  end
end
