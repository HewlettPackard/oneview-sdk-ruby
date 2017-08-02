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

require_relative '../c7000/server_profile_template'

module OneviewSDK
  module API500
    module Synergy
      # Server Profile Template resource implementation for API500 Synergy
      class ServerProfileTemplate < OneviewSDK::API500::C7000::ServerProfileTemplate

        # Sets the OS deployment settings applicable when deployment is invoked through server profile template
        # @param [OneviewSDK::API500::Synergy::OSDeploymentPlan] os_deployment_plan the OSDeploymentPlan resource with valid URI.
        # @param [Array(Hash<String, String>)] custom_attributes The custom attributes to be configured on the OS deployment plan.
        #   The internal hashes may contain:
        #   - 'name' [String] name of the attribute
        #   - 'value' [String] value of the attribute
        # @raise [OneviewSDK::IncompleteResource] if OS Deployment not found.
        def set_os_deployment_settings(os_deployment_plan, custom_attributes = [])
          raise IncompleteResource, 'OS Deployment Plan not found!' unless os_deployment_plan.retrieve!
          self['osDeploymentSettings'] ||= {}
          self['osDeploymentSettings']['osDeploymentPlanUri'] = os_deployment_plan['uri']
          self['osDeploymentSettings']['osCustomAttributes'] = custom_attributes
        end
      end
    end
  end
end
