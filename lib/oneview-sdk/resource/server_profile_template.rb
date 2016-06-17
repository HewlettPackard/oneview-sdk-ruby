# (C) Copyright 2016 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

module OneviewSDK
  # Server profile template resource implementation
  class ServerProfileTemplate < Resource
    BASE_URI = '/rest/server-profile-templates'.freeze

    def initialize(client, params = {}, api_ver = nil)
      super
      # Default values
      @data['type'] ||= 'ServerProfileTemplateV1'
    end

    # Create ServerProfile using this template
    # @param [String] name Name of new server profile
    # @return [ServerProfile] New server profile from template.
    #   Temporary object only; call .create to actually create resource on OneView.
    def new_profile(name = nil)
      ensure_client && ensure_uri
      options = @client.rest_get("#{@data['uri']}/new-profile")
      profile = OneviewSDK::ServerProfile.new(@client, options)
      profile[:name] = name if name && name.size > 0
      profile
    end
  end
end
