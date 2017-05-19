# (C) Copyright 2017 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.

RSpec.shared_examples 'SASLogicalInterconnectUpdateExample' do |context_name|
  include_context context_name

  let(:item) { described_class.new(current_client, name: SAS_LOG_INT1_NAME) }
  let(:firmware_path) { 'spec/support/Service Pack for ProLiant' }

  describe '#retrieve!' do
    it 'retrieves the already created necessary objects' do
      expect { item.retrieve! }.to_not raise_error
      expect(item[:type]).to eq('sas-logical-interconnect')
    end
  end

  describe '#compliance' do
    it 'defines the position of the SAS Logical Interconnect' do
      item.retrieve!
      expect { item.compliance }.to_not raise_error
    end
  end

  describe '#find_by' do
    it 'returns all resources when the hash is empty' do
      names = described_class.find_by(current_client, {}).map { |item| item[:name] }
      expect(names).to include(item[:name])
    end
  end

  describe '#configuration' do
    it 'reapplies configuration to all managed interconnects' do
      item.retrieve!
      expect { item.configuration }.to_not raise_error
    end
  end

  describe '#get_firmware' do
    it 'retrieves the sas interconnects firmware information' do
      item.retrieve!
      expect(item.get_firmware).to_not be_empty
    end
  end

  # NOTE: This action requires an unused drive enclosure to be swapped in with the one in use
  describe '#replace_drive_enclosure' do
    xit 'updates the drive enclosure to the correct one after it was physically changed' do
      item.retrieve!
      expect { item.replace_drive_enclosure(DRIVE_ENCL1_SERIAL, DRIVE_ENCL1_SERIAL_UPDATED) }.to_not raise_error
    end
  end

  # NOTE: This action requires a firmware image to be specified
  describe 'Firmware Updates' do
    xit 'will assure the firmware is present' do
      firmware_name = firmware_path.split('/').last
      firmware = firmware_driver_class.new(current_client, name: firmware_name)
      firmware.retrieve!
    end

    xit 'will retrieve the firmware options' do
      firmware_name = firmware_path.split('/').last
      firmware = firmware_driver_class.new(current_client, name: firmware_name)
      firmware.retrieve!
      item.retrieve!
      firmware_opt = item.get_firmware
      expect(firmware_opt).to be
      expect(firmware_opt['ethernetActivationDelay']).to be
      expect(firmware_opt['ethernetActivationType']).to be
      expect(firmware_opt['fcActivationDelay']).to be
      expect(firmware_opt['fcActivationType']).to be
    end

    context 'perform the actions' do
      xit 'Stage' do
        item.retrieve!
        firmware_name = firmware_path.split('/').last
        firmware = firmware_driver_class.new(current_client, name: firmware_name)
        firmware.retrieve!
        firmware_opt = item.get_firmware
        firmware_opt['force'] = true
        expect { item.firmware_update('Stage', firmware, firmware_opt) }.to_not raise_error
      end
    end
  end
end
