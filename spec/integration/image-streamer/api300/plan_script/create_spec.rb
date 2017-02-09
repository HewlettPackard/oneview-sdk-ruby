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

require 'spec_helper'

klass = OneviewSDK::ImageStreamer::API300::PlanScript
RSpec.describe klass, integration_i3s: true, type: CREATE, sequence: i3s_seq(klass) do
  include_context 'integration i3s api300 context'

  describe '#create' do
    it 'creates a plan script' do
      options = {
        description: 'Description of this plan script',
        name: PLAN_SCRIPT1_NAME,
        hpProvided: false,
        planType: 'deploy',
        content: 'f'
      }

      item = klass.new($client_i3s_300, options)
      expect { item.create! }.not_to raise_error
      item.retrieve!
      expect(item['uri']).to be
      expect(item['name']).to eq(options[:name])
      expect(item['description']).to eq(options[:description])
      expect(item['hpProvided']).to be options[:hpProvided]
      expect(item['planType']).to eq(options[:planType])
      expect(item['content']).to eq(options[:content])
    end

    it 'creates a plan script with custom attributes' do
      options = {
        description: 'Description of this plan script',
        name: PLAN_SCRIPT2_NAME,
        hpProvided: false,
        planType: 'deploy',
        content: 'esxcli system hostname set --domain "@DomainName@"'
      }

      item = klass.new($client_i3s_300, options)
      expect { item.create! }.not_to raise_error
      item.retrieve!
      expect(item['uri']).to be
      expect(item['name']).to eq(options[:name])
      expect(item['description']).to eq(options[:description])
      expect(item['hpProvided']).to be options[:hpProvided]
      expect(item['planType']).to eq(options[:planType])
      expect(item['content']).to eq(options[:content])
      expect(item['customAttributes']).to eq('[{"name":"DomainName","value":""}]')
    end
  end

  describe '#retrieve_differences' do
    it 'raises exception when uri is empty' do
      item = klass.new($client_i3s_300)
      expect { item.retrieve_differences }.to raise_error(OneviewSDK::IncompleteResource, /Please set uri attribute/)
    end

    it 'retrieves the modified contents' do
      item = klass.find_by($client_i3s_300, name: PLAN_SCRIPT1_NAME).first
      expect(item['uri']).to be
      expect { item.retrieve_differences }.not_to raise_error
    end
  end
end
