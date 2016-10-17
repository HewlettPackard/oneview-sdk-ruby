require 'spec_helper'

klass = OneviewSDK::API300::Thunderbird::SASLogicalInterconnect
RSpec.describe klass, integration: true, type: UPDATE do
  include_context 'integration api300 context'

  # let(:enclosure) { OneviewSDK::Enclosure.new($client_300, name: ENCL_NAME) }
  let(:sas_log_int) { klass.new($client_300, name: SAS_LOG_INT1_NAME) }
  let(:firmware_path) { 'spec/support/Service Pack for ProLiant' }

  describe '#retrieve!' do
    it 'retrieves the already created necessary objects' do
      expect { sas_log_int.retrieve! }.to_not raise_error
      expect(sas_log_int[:type]).to eq('sas-logical-interconnect')
    end
  end

  describe '#compliance' do
    it 'defines the position of the SAS Logical Interconnect' do
      sas_log_int.retrieve!
      expect { sas_log_int.compliance }.to_not raise_error
    end
  end

  describe '#find_by' do
    it 'returns all resources when the hash is empty' do
      names = klass.find_by($client_300, {}).map { |item| item[:name] }
      expect(names).to include(sas_log_int[:name])
    end
  end

  describe '#configuration' do
    it 'reapplies configuration to all managed interconnects' do
      sas_log_int.retrieve!
      expect { sas_log_int.configuration }.to_not raise_error
    end
  end

  describe '#get_firmware' do
    it 'retrieves the sas interconnects firmware information' do
      sas_log_int.retrieve!
      expect(sas_log_int.get_firmware).to_not be_empty
    end
  end

  # NOTE: This action requires an unused drive enclosure to be swapped in with the one in use
  # describe '#replace_drive_enclosure' do
  #   it 'updates the drive enclosure to the correct one after it was physically changed' do
  #     sas_log_int.retrieve!
  #     expect { sas_log_int.replace_drive_enclosure(DRIVE_ENCL1_SERIAL, DRIVE_ENCL1_SERIAL_UPDATED) }.to_not raise_error
  #   end
  # end

  # NOTE: This action requires a firmware image to be specified
  # describe 'Firmware Updates' do
  #   it 'will assure the firmware is present' do
  #     firmware_name = firmware_path.split('/').last
  #     firmware = OneviewSDK::FirmwareDriver.new($client_300, name: firmware_name)
  #     firmware.retrieve!
  #   end
  #
  #   it 'will retrieve the firmware options' do
  #     firmware_name = firmware_path.split('/').last
  #     firmware = OneviewSDK::FirmwareDriver.new($client_300, name: firmware_name)
  #     firmware.retrieve!
  #     sas_log_int.retrieve!
  #     firmware_opt = sas_log_int.get_firmware
  #     expect(firmware_opt).to be
  #     expect(firmware_opt['ethernetActivationDelay']).to be
  #     expect(firmware_opt['ethernetActivationType']).to be
  #     expect(firmware_opt['fcActivationDelay']).to be
  #     expect(firmware_opt['fcActivationType']).to be
  #   end
  #
  #   context 'perform the actions' do
  #     it 'Stage' do
  #       sas_log_int.retrieve!
  #       firmware_name = firmware_path.split('/').last
  #       firmware = OneviewSDK::FirmwareDriver.new($client_300, name: firmware_name)
  #       firmware.retrieve!
  #       firmware_opt = sas_log_int.get_firmware
  #       firmware_opt['force'] = true
  #       expect { sas_log_int.firmware_update('Stage', firmware, firmware_opt) }.to_not raise_error
  #     end
  #   end
  # end
end
