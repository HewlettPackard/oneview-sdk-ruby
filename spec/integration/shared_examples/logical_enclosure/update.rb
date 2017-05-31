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

RSpec.shared_examples 'LogicalEnclosureUpdateExample' do |context_name, version, variant|
  include_context context_name

  subject(:item) { described_class.find_by(current_client, name: encl_name).first }

  describe '#update' do
    it 'Updating the name' do
      sleep(10)
      item['name'] = "#{encl_name}_Updated"
      expect { item.update }.to_not raise_error
      expect(item['name']).to eq("#{encl_name}_Updated")
      item['name'] = encl_name
      expect { item.update }.to_not raise_error
      expect(item['name']).to eq(encl_name)
    end
  end

  describe '#reconfigure' do
    it 'Reconfigure logical enclosure' do
      expect { item.reconfigure }.to_not raise_error
    end
  end

  describe '#update_from_group' do
    it 'Update logical enclosure from group' do
      expect { item.update_from_group }.to_not raise_error
    end
  end

  describe '#set_script' do
    describe '#set_script', if: variant == 'C7000' do
      it 'Change script and validate' do
        expect { item.set_script('#TEST') }.to_not raise_error
        expect(item.get_script.tr('"', '')).to eq('#TEST')
      end
    end

    it 'Raises method unavailable', if: variant == 'Synergy' do
      expect { item.set_script }.to raise_error(/The method #set_script is unavailable for this resource/)
    end
  end

  describe '#get_script' do
    it 'Gets a script', if: version < 500 do
      script = item.get_script
      expect(script).to be_a(String)
    end

    it 'Raises method unavailable', if: variant == 'Synergy' && version >= 500 do
      expect { item.get_script }.to raise_error(/The method #get_script is unavailable for this resource/)
    end
  end

  describe '#support_dump' do
    it 'Support dump' do
      expect { item.support_dump(errorCode: 'teste') }.to_not raise_error
    end
  end

  describe '#update_firmware', if: version >= 300 do
    it 'Updating the firmware of a given logical enclosure' do
      firmware_attributes = {
        firmwareUpdateOn: 'EnclosureOnly',
        forceInstallFirmware: false,
        updateFirmwareOnUnmanagedInterconnect: true
      }

      expect { item.update_firmware(firmware_attributes) }.to_not raise_error
      sleep(10)
    end
  end
end
