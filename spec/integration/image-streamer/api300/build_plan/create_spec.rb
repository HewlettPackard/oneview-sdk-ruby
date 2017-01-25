# (C) Copyright 2016 Hewlett Packard Enterprise Development LP
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

klass = OneviewSDK::ImageStreamer::API300::BuildPlan
RSpec.describe klass, integration_i3s: true, type: CREATE do
  include_context 'integration i3s api300 context'

  describe '#create' do
    it 'creates a build plan' do
      options = {
        name: BUILD_PLAN1_NAME,
        oeBuildPlanType: 'Deploy'
      }

      item = klass.new($client_i3s_300, options)
      expect { item.create! }.not_to raise_error
      item.retrieve!
      expect(item['uri']).not_to be_empty
      expect(item['name']).to eq(options[:name])
      expect(item['oeBuildPlanType']).to eq(options[:oeBuildPlanType])
    end

    it 'creates a build plan with build step' do
      plan_script = OneviewSDK::ImageStreamer::API300::PlanScripts.find_by($client_i3s_300, name: PLAN_SCRIPT1_NAME).first

      build_step = [
        {
          serialNumber: '1',
          parameters: 'anystring',
          planScriptName: PLAN_SCRIPT1_NAME,
          planScriptUri: plan_script['uri']
        }
      ]

      options = {
        name: BUILD_PLAN2_NAME,
        oeBuildPlanType: 'deploy'
      }

      item = klass.new($client_i3s_300, options)
      item.set_build_step(build_step)
      item.expect(item['build_step']).to eq(build_step)

      expect { item.create! }.not_to raise_error
      item.retrieve!
      expect(item['uri']).not_to be_empty
      expect(item['name']).to eq(options[:name])
      expect(item['oeBuildPlanType']).to eq(options[:oeBuildPlanType])
    end
  end
end
