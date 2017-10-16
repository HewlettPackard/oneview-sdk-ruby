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

RSpec.shared_examples 'EnclosureCreateExample' do |context_name, variant|
  include_context context_name

  let(:enclosure_options) do
    {
      'hostname' => $secrets['enclosure1_ip'],
      'username' => $secrets['enclosure1_user'],
      'password' => $secrets['enclosure1_password'],
      'licensingIntent' => 'OneView',
      'name' => ENCL_NAME
    }
  end

  describe '#create' do
    it 'raises MethodUnavailable' do
      item = described_class.new(current_client)
      expect { item.create }.to raise_error(OneviewSDK::MethodUnavailable, /The method #create is unavailable for this resource/)
    end
  end

  describe '#add' do
    it 'can add an enclosure', if: variant == 'C7000' do
      item = described_class.new(current_client, enclosure_options)
      item.set_enclosure_group(encl_group_class.new(current_client, 'name' => ENC_GROUP2_NAME))
      item.add
      expect(item['uri']).not_to be_empty
    end

    it 'can add an enclosure', if: variant == 'Synergy' do
      item = described_class.new(current_client, hostname: ENCL_HOSTNAME, name: ENCL_NAME)
      encl1 = item.add[0]
      expect(encl1).to be
      expect(encl1['uri']).not_to be_empty
      expect(encl1['name']).to eq("#{ENCL_NAME}3")
    end
  end

  describe '#environmentalConfiguration' do
    it 'Gets the environmental configuration' do
      item = described_class.get_all(current_client).first
      item.environmental_configuration
      expect { item.environmental_configuration }.not_to raise_error
    end

    it 'set_environmental_configuration raises MethodUnavailable', if: variant == 'Synergy' do
      item = described_class.get_all(current_client).first
      expect { item.set_environmental_configuration('') }.to raise_error(/The method #set_environmental_configuration is unavailable/)
    end
  end

  describe '#set_enclosure_group', if: variant == 'Synergy' do
    it 'raises MethodUnavailable' do
      item = described_class.get_all(current_client).first
      expect { item.set_enclosure_group('') }.to raise_error(/The method #set_enclosure_group is unavailable for this resource/)
    end
  end

  describe '#utilization' do
    it 'Gets utilization data' do
      item = described_class.get_all(current_client).first
      res = nil
      expect { res = item.utilization }.not_to raise_error
      expect(res['metricList']).not_to be_empty
    end

    it 'Gets utilization data by day' do
      item = described_class.get_all(current_client).first
      res = nil
      expect { res = item.utilization(view: 'day') }.not_to raise_error
      expect(res['metricList']).not_to be_empty
    end

    it 'Gets utilization data by fields' do
      item = described_class.get_all(current_client).first
      res = nil
      expect { res = item.utilization(fields: %w[AmbientTemperature]) }.not_to raise_error
      expect(res['metricList']).not_to be_empty
    end

    it 'Gets utilization data by filters' do
      item = described_class.get_all(current_client).first
      res = nil
      t = Time.now
      expect { res = item.utilization(startDate: t) }.not_to raise_error
      expect(res['metricList']).not_to be_empty
    end
  end

  describe '#script' do
    it 'can retrieve the script (it will fail if operation is not supported for enclosure)' do
      item = described_class.get_all(current_client).first
      script = item.script
      expect(script).to be_a(String)
    end
  end
end
