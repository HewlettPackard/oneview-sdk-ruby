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

RSpec.shared_examples 'VolumeTemplateUpdateExample API500' do
  describe '#update' do
    let(:item) { described_class.new(current_client, name: VOL_TEMP_NAME) }
    before { expect(item.retrieve!).to eq(true) }

    context '#set_default_value for "name"' do
      it 'should change the default value of "name"' do
        old_value = item.get_default_value(:name)
        new_value = 'Default value changed'
        item.set_default_value(:name, new_value)
        expect { item.update }.not_to raise_error
        item.refresh
        expect(item.get_default_value(:name)).to eq(new_value)

        # back to the old value
        item.set_default_value(:name, old_value)
        expect { item.update }.not_to raise_error
        item.refresh
        expect(item.get_default_value(:name)).to eq(old_value)
      end
    end

    context '#set_default_value for "isShareable"' do
      it 'should change the default value of "isShareable"' do
        item.set_default_value(:isShareable, true)
        expect { item.update }.not_to raise_error
        item.refresh
        expect(item.get_default_value(:isShareable)).to eq(true)
      end
    end

    context '#lock "isShareable" property' do
      it 'should be unable to change "isShareable" property' do
        expect(item.locked?(:isShareable)).to eq(false)
        item.lock(:isShareable)
        expect { item.update }.not_to raise_error
        item.refresh
        expect(item.locked?(:isShareable)).to eq(true)

        # item['properties']['isShareable']['title'] = 'New title is Shareable'
        # expect { item.update }.to raise_error
      end
    end

    context '#unlock' do
      it 'should be able to change "isShareable" property' do
        expect(item.locked?(:isShareable)).to eq(true)
        item.unlock(:isShareable)
        expect { item.update }.not_to raise_error
        item.refresh
        expect(item.locked?(:isShareable)).to eq(false)

        # item['properties']['isShareable']['title'] = 'Is Shareable?'
        # expect { item.update }.not_to raise_error
        # item.refresh
        # expect(item['properties']['isShareable']['title']).to eq('Is Shareable?')
      end
    end
  end
end
