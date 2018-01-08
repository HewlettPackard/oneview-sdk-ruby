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
  module API500
    module C7000
      # Volume Template resource implementation for API500 C7000
      class VolumeTemplate < Resource
        BASE_URI = '/rest/storage-volume-templates'.freeze

        # Delete resource from OneView
        # @param [Hash] header The header options for the request (key-value pairs)
        # @return [true] if resource was deleted successfully
        def delete(header = {})
          super(DEFAULT_REQUEST_HEADER.merge(header).merge('If-Match' => @data['eTag']))
        end

        # Sets the root template
        # @param [VolumeTemplate] root_template The Volume Template resource
        def set_root_template(root_template)
          self['properties'] = root_template['properties'].clone
          self['rootTemplateUri'] = root_template['uri']
        end

        # Sets the "locked" property of property passed to true or false
        # @param [String] property The property for change value
        # @param [Boolean] locked The value to set to "locked" property. Default: true.
        # @raise [OneviewSDK::IncompleteResource] if the rootTemplateUri or properties are not set
        def lock(property, locked = true)
          verify_if_root_template_is_set!
          self['properties'][property.to_s]['meta']['locked'] = locked
        end

        # Sets the "locked" property of property passed to false
        # @param [String] property The property for change value
        # @raise [OneviewSDK::IncompleteResource] if the rootTemplateUri or properties are not set
        def unlock(property)
          lock(property, false)
        end

        # Verify if property is locked
        # @param [String] property The property
        # @raise [OneviewSDK::IncompleteResource] if the rootTemplateUri or properties are not set
        # @return [Boolean] true if property is locked or false if not
        def locked?(property)
          verify_if_root_template_is_set!
          self['properties'][property.to_s]['meta']['locked']
        end

        # Sets the value of property
        # @param [String] property The property for change value
        # @param [Object] value The new value of property
        # @raise [OneviewSDK::IncompleteResource] if the rootTemplateUri or properties are not set
        def set_default_value(property, value)
          verify_if_root_template_is_set!
          value = value['uri'] if value.is_a?(Resource)
          self['properties'][property.to_s]['default'] = value
        end

        # Gets the value of property
        # @param [String] property The property to get value
        # @raise [OneviewSDK::IncompleteResource] if the rootTemplateUri or properties are not set
        # @return [Object] the default value of property
        def get_default_value(property)
          verify_if_root_template_is_set!
          self['properties'][property.to_s]['default']
        end

        # Retrieves a collection of all storage systems that is applicable to this storage volume template
        # @raise [OneviewSDK::IncompleteResource] if the client or the URI is not set
        # @return [Array] collection of Storage Systems
        def get_compatible_systems
          ensure_client && ensure_uri
          self.class.find_with_pagination(@client, self['compatibleStorageSystemsUri'])
        end

        # Gets the storage templates that are connected on the specified networks based on the storage system port's expected network connectivity.
        # @param [OneviewSDK::Client] client The client object for the OneView appliance
        # @param [Array] networks Set of networks to filter the storage templates connected
        # @param [Hash] attributes Hash containing the attributes name and value to filter storage templates
        # @return [Array] the collection of volume templates
        def self.get_reachable_volume_templates(client, networks = [], attributes = {})
          uri = self::BASE_URI + '/reachable-volume-templates'
          unless networks.empty?
            network_uris = networks.map { |item| item['uri'] }
            uri += "?networks='#{network_uris.join(',')}'"
          end
          find_by(client, attributes, uri)
        end

        private

        # Verify if rootTemplateUri or properties are set
        # @raise [OneviewSDK::IncompleteResource] if the rootTemplateUri or properties were set set before
        def verify_if_root_template_is_set!
          raise IncompleteResource, 'Must set a valid root template' if self['rootTemplateUri'].nil? || self['properties'].nil?
        end
      end
    end
  end
end
