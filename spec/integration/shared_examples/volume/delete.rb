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

RSpec.shared_examples 'VolumeDeleteExample' do |context_name|
  include_context context_name

  let(:item) { described_class.find_by(current_client, name: VOLUME_NAME).first }
  let(:item2) { described_class.find_by(current_client, name: VOLUME2_NAME).first }
  let(:item3) { described_class.find_by(current_client, name: VOLUME3_NAME).first }
  let(:item4) { described_class.find_by(current_client, name: VOLUME4_NAME).first }
  let(:item5) { described_class.find_by(current_client, name: VOLUME5_NAME).first }

  describe '#delete_snapshot' do
    it 'removes the snapshot' do
      expect { item3.delete_snapshot(VOL_SNAPSHOT2_NAME) }.to_not raise_error
      expect(item3.get_snapshot(VOL_SNAPSHOT2_NAME)).to be_nil
    end
  end

  describe '#repair' do
    it 'Remove extra presentations' do
      expect { item5.repair }.to_not raise_error
    end
  end

  describe '#delete' do
    it 'raises an exception when is passed an invalid flag' do
      expect { item.delete(:any) }.to raise_error(/Invalid flag value, use :oneview or :all/)
    end

    it 'removes the volumes - store serv' do
      expect { item.delete }.to_not raise_error
      expect(item.retrieve!).to eq(false)
      expect { item2.delete }.to_not raise_error
      expect(item2.retrieve!).to eq(false)
      expect { item3.delete }.to_not raise_error
      expect(item3.retrieve!).to eq(false)
      expect { item4.delete }.to_not raise_error
      expect(item4.retrieve!).to eq(false)
      expect { item5.delete }.to_not raise_error
      expect(item5.retrieve!).to eq(false)
    end
  end
end
