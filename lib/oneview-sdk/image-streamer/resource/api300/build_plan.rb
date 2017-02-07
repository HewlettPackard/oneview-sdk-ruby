# (C) Copyright 2017 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

require_relative 'resource'

module OneviewSDK
  module ImageStreamer
    module API300
      # Build Plan resource implementation for Image Streamer
      class BuildPlan < Resource
        BASE_URI = '/rest/build-plans'.freeze

        # Create a resource object, associate it with a client, and set its properties.
        # @param [OneviewSDK::ImageStreamer::Client] client The client object for the Image Streamer appliance
        # @param [Hash] params The options for this resource (key-value pairs)
        # @param [Integer] api_ver The api version to use when interracting with this resource.
        def initialize(client, params = {}, api_ver = nil)
          super
          # Default values:
          @data['type'] ||= 'OeBuildPlan'
          @data['customAttributes'] ||= []
        end

        # Build step of the build plan.
        # @param build_step [Array]  The Build step array of the build plan
        def set_build_steps(build_step = [])
          set('buildStep', build_step)
          @data['buildStep'].each do |step|
            step = Hash[step.map { |k, v| [k.to_s, v] }]
            raise IncompleteResource, 'Please set the planScriptUri attribute!' unless step['planScriptUri']
            set_custom_attributes(step['planScriptUri'])
          end
        end

        private

        # Sets the custom attributes.
        # @param [String]  plan_script_uri uri of the plan script
        def set_custom_attributes(plan_script_uri)
          plan_script = OneviewSDK::ImageStreamer::API300::PlanScripts.find_by(@client, uri: plan_script_uri).first
          raise IncompleteResource, "The plan script with uri #{plan_script_uri} could not be found!" unless plan_script['uri']
          @data['customAttributes'].merge(plan_script['customAttributes']) unless plan_script['customAttributes'].empty?
        end
      end
    end
  end
end
