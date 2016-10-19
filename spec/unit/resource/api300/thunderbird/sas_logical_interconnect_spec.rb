require 'spec_helper'

klass = OneviewSDK::API300::Thunderbird::SASLogicalInterconnect

RSpec.describe klass do
  include_context 'shared context'

  options = {
    name: 'Oneview SAS Logical Interconnect Unit Test',
    uri: '/rest/fake'
  }

  let(:fixture_path) { 'spec/support/fixtures/unit/resource/logical_interconnect_default.json' }
  let(:sas_log_int) { klass.new(@client_300, options) }

  describe '#create' do
    it 'raises MethodUnavailable error' do
      expect { sas_log_int.create }.to raise_error(OneviewSDK::MethodUnavailable)
    end
  end

  describe '#delete' do
    it 'raises MethodUnavailable error' do
      expect { sas_log_int.delete }.to raise_error(OneviewSDK::MethodUnavailable)
    end
  end

  describe '#compliance' do
    it 'requires the uri to be set' do
      expect { klass.new(@client_300).compliance }.to raise_error(OneviewSDK::IncompleteResource, /Please set uri/)
    end

    it 'does a PUT to uri/compliance & updates @data' do
      item = sas_log_int
      @data ||= {}
      update_options = {
        'If-Match' =>  @data['eTag'],
        'body' => { 'type' => 'sas-logical-interconnect' }
      }
      expect(@client_300).to receive(:rest_put).with(item['uri'] + '/compliance', update_options, item.api_version)
        .and_return(FakeResponse.new(key: 'val'))
      item.compliance
      expect(item['key']).to eq('val')
    end
  end

  describe '#configuration' do
    it 'requires the uri to be set' do
      expect { klass.new(@client_300).configuration }.to raise_error(OneviewSDK::IncompleteResource, /Please set uri/)
    end

    it 'does a PUT to uri/configuration & updates @data' do
      item = sas_log_int
      expect(@client_300).to receive(:rest_put).with(item['uri'] + '/configuration', {}, item.api_version)
        .and_return(FakeResponse.new(key: 'val'))
      item.configuration
      expect(item['key']).to eq('val')
    end
  end

  describe '#get_firmware' do
    it 'requires the uri to be set' do
      expect { klass.new(@client_300).get_firmware }.to raise_error(OneviewSDK::IncompleteResource, /Please set uri/)
    end

    it 'gets uri/firmware & returns the result' do
      expect(@client_300).to receive(:rest_get).with(sas_log_int['uri'] + '/firmware').and_return(FakeResponse.new(key: 'val'))
      expect(sas_log_int.get_firmware).to eq('key' => 'val')
    end
  end

  describe '#firmware_update' do
    it 'requires the uri to be set' do
      expect { klass.new(@client_300).firmware_update(:cmd, nil, {}) }
        .to raise_error(OneviewSDK::IncompleteResource, /Please set uri/)
    end

    it 'does a PUT to uri/firmware & returns the result' do
      expect(@client_300).to receive(:rest_put).with(sas_log_int['uri'] + '/firmware', Hash).and_return(FakeResponse.new(key: 'val'))
      driver = OneviewSDK::FirmwareDriver.new(@client_300, name: 'FW', uri: '/rest/fake')
      expect(sas_log_int.firmware_update('cmd', driver, {})).to eq('key' => 'val')
    end
  end

  describe '#replace_drive_enclosure' do
    update_json = {
      'If-Match' => '*',
      'body' => {
        'oldSerialNumber' => 'SNFAKE1',
        'newSerialNumber' => 'SNFAKE2'
      }
    }

    it 'enables the new drive enclosure to take over as a replacement after physically swapping the drive enclosures' do
      expect(@client_300).to receive(:rest_post).with(sas_log_int['uri'] + '/replaceDriveEnclosure', update_json)
        .and_return(FakeResponse.new(['/rest/fake2']))
      updated_sas_log_int = sas_log_int.replace_drive_enclosure('SNFAKE1', 'SNFAKE2')
      expect(updated_sas_log_int).to eq(['/rest/fake2'])
    end
  end
end
