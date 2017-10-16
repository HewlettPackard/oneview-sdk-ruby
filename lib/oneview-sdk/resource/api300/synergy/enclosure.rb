# (c) Copyright 2016 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

require_relative '../c7000/enclosure'

module OneviewSDK
  module API300
    module Synergy
      # Enclosure resource implementation for API300 Synergy
      class Enclosure < OneviewSDK::API300::C7000::Enclosure

        # Claim/configure the enclosure and its components to the appliance
        # @note Calls the update_enclosure_names method to set the enclosure names
        # @return [Array<OneviewSDK:API300:Synergy::Enclosure>] containing the added enclosures
        def add
          ensure_client
          required_attributes = %w[hostname]
          required_attributes.each { |k| raise IncompleteResource, "Missing required attribute: '#{k}'" unless @data.key?(k) }

          temp_data = @data.select { |k, _v| required_attributes.include?(k) }
          response = @client.rest_post(self.class::BASE_URI, { 'body' => temp_data }, @api_version)
          @client.response_handler(response)

          # Renames the enclosures if the @data['name'] is not nil, otherwise only returns the enclosures
          @data['name'] ||= ''
          self.class.update_enclosure_names(@client, @data['hostname'], @data['name'])
        end

        # Method is not available
        # @raise [OneviewSDK::MethodUnavailable] method is not available
        def set_environmental_configuration(*)
          unavailable_method
        end

        # Method is not available
        # @raise [OneviewSDK::MethodUnavailable] method is not available
        def set_enclosure_group(*)
          unavailable_method
        end

        # Method for renaming all enclosures that share the same frameLinkModuleDomain.
        # The naming pattern for the enclosures is <name><1..number of enclosures>.
        # @param [OneviewSDK::Client] client The client object for the OneView appliance
        # @param [String] hostname The ipv6 of the enclosure to be added
        # @param [String] name The name to be used for renaming the enclosures
        # @return [Array<OneviewSDK:API300:Synergy::Enclosure>] which had their name changed
        # @raise [OneviewSDK::IncompleteResource] if a client and hostname are nil
        def self.update_enclosure_names(client, hostname, name = '')
          raise IncompleteResource, 'Missing parameters for update_enclosure_names' unless client && hostname
          frame_link = ''

          # Retrieve the frameLinkModuleDomain of the specified enclosure, then use it to find all enclosures
          # that share that frameLinkModuleDomain.
          all_enclosures = find_by(client, {})
          all_enclosures.each do |encl|
            frame_link = encl['frameLinkModuleDomain'] if encl['managerBays'].first['ipAddress'] == hostname
          end
          enclosures = all_enclosures.select { |encl| encl['frameLinkModuleDomain'] == frame_link }

          # Return enclosures without modifying them if a name has not been specified
          return enclosures if name == ''

          # Updates the enclosure names and return the array containing the enclosures
          number_of_enclosures = enclosures.count
          enclosures.each do |encl|
            encl['name'] = "#{name}#{number_of_enclosures}"
            encl.update
            number_of_enclosures -= 1
          end
          enclosures
        end
      end
    end
  end
end
