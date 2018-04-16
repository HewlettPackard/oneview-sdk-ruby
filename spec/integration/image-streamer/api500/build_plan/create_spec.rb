# (C) Copyright 2018 Hewlett Packard Enterprise Development LP
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

klass = OneviewSDK::ImageStreamer::API500::BuildPlan
RSpec.describe klass, integration_i3s: true, type: CREATE, sequence: i3s_seq(klass) do
  include_context 'integration i3s api500 context'

  describe '#create' do
    it 'creates a build plan' do
      options = {
        name: BUILD_PLAN1_NAME,
        oeBuildPlanType: 'deploy'
      }

      item = klass.new($client_i3s_500, options)
      expect { item.create! }.not_to raise_error
      item.retrieve!
      expect(item['uri']).to be
      expect(item['name']).to eq(options[:name])
      expect(item['oeBuildPlanType']).to eq(options[:oeBuildPlanType])
    end

    it 'creates a build plan with capture type' do
      options = {
        name: BUILD_PLAN2_NAME,
        oeBuildPlanType: 'capture'
      }

      item = klass.new($client_i3s_500, options)
      expect { item.create! }.not_to raise_error
      item.retrieve!
      expect(item['uri']).to be
      expect(item['name']).to eq(options[:name])
      expect(item['oeBuildPlanType']).to eq(options[:oeBuildPlanType])
    end

    it 'creates a build plan with build step' do
      plan_script = OneviewSDK::ImageStreamer::API500::PlanScript.find_by($client_i3s_500, name: PLAN_SCRIPT1_NAME).first

      build_step = [
        {
          serialNumber: '1',
          parameters: 'anystring',
          planScriptName: PLAN_SCRIPT1_NAME,
          planScriptUri: plan_script['uri']
        }
      ]

      options = {
        name: BUILD_PLAN3_NAME,
        oeBuildPlanType: 'deploy',
        buildStep: build_step
      }

      item = klass.new($client_i3s_500, options)
      expect(item['buildStep']).to eq(build_step)

      expect { item.create! }.not_to raise_error
      item.retrieve!
      expect(item['uri']).to be
      expect(item['name']).to eq(options[:name])
      expect(item['oeBuildPlanType']).to eq(options[:oeBuildPlanType])
    end

    it 'creates a build plan with build step and custom attributes' do
      plan_script = OneviewSDK::ImageStreamer::API500::PlanScript.find_by($client_i3s_500, name: PLAN_SCRIPT2_NAME).first

      custom_attributes = JSON.parse(plan_script['customAttributes'])
      custom_attributes.replace([custom_attributes[0].merge('type' => 'String')])

      build_step = [
        {
          serialNumber: '1',
          parameters: 'anystring',
          planScriptName: PLAN_SCRIPT2_NAME,
          planScriptUri: plan_script['uri']
        }
      ]

      options = {
        name: BUILD_PLAN4_NAME,
        oeBuildPlanType: 'deploy',
        buildStep: build_step,
        customAttributes: custom_attributes
      }

      item = klass.new($client_i3s_500, options)
      expect { item.create! }.not_to raise_error
      item.retrieve!
      expect(item['uri']).to be
      expect(item['name']).to eq(options[:name])
      expect(item['oeBuildPlanType']).to eq(options[:oeBuildPlanType])
      expect(item['customAttributes']).not_to be_empty
    end
  end
end
