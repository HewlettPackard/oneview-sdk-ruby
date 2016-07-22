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
  # Logical interconnect resource implementation
  class LogicalInterconnect < Resource
    BASE_URI = '/rest/logical-interconnects'.freeze
    LOCATION_URI = '/rest/logical-interconnects/locations/interconnects'.freeze

    # Create an Interconnect in the desired Bay in a specified enclosure
    # WARN: It does not create the LOGICAL INTERCONNECT itself.
    # It will fail if no interconnect is already present on the specified position
    # @param [Fixnum] bay_number Number of the bay to put the interconnect
    # @param [OneviewSDK::Resource] enclosure Enclosure to insert the interconnect
    def create(bay_number, enclosure)
      enclosure.ensure_uri
      entry = {
        'locationEntries' => [
          { 'value' => bay_number, 'type' => 'Bay' },
          { 'value' => enclosure['uri'], 'type' => 'Enclosure' }
        ]
      }
      response = @client.rest_post(self.class::LOCATION_URI, { 'body' => entry }, @api_version)
      @client.response_handler(response)
    end

    # Deletes an INTERCONNECT
    # WARN: This won't delete the LOGICAL INTERCONNECT itself, and may cause inconsistency between the enclosure and LIG
    # @param [Fixnum] bay_number Number of the bay to locate the logical interconnect
    # @param [OneviewSDK::Enclosure] enclosure Enclosure to remove the logical interconnect
    # @return [OneviewSDK::LogicalInterconnect] self
    def delete(bay_number, enclosure)
      enclosure.ensure_uri
      delete_uri = self.class::LOCATION_URI + "?location=Enclosure:#{enclosure['uri']},Bay:#{bay_number}"
      response = @client.rest_delete(delete_uri, {}, @api_version)
      @client.response_handler(response)
      self
    end

    # Updates internal networks on the logical interconnect
    # @param [OneviewSDK::EthernetNetworks] networks List of networks to update the Logical Interconnect
    def update_internal_networks(*networks)
      uris = []
      return @client.response_handler(@client.rest_put(@data['uri'] + '/internalNetworks', 'body' => [])) unless networks
      networks.each do |net|
        net.retrieve! unless net['uri']
        uris.push(net['uri'])
      end
      response = @client.rest_put(@data['uri'] + '/internalNetworks', 'body' => uris)
      body = @client.response_handler(response)
      set_all(body)
    end

    # Lists internal networks on the logical interconnect
    # @return [OneviewSDK::Resource] List of networks
    def list_vlan_networks
      ensure_client && ensure_uri
      results = OneviewSDK::Resource.find_by(@client, {}, @data['uri'] + '/internalVlans')
      internal_networks = []
      results.each do |vlan|
        net = if vlan['generalNetworkUri'].include? 'ethernet-network'
                OneviewSDK::EthernetNetwork.new(@client, uri: vlan['generalNetworkUri'])
              elsif vlan['generalNetworkUri'].include? 'fc-network'
                OneviewSDK::FCNetwork.new(@client, uri: vlan['generalNetworkUri'])
              else
                OneviewSDK::FCoENetwork.new(@client, uri: vlan['generalNetworkUri'])
              end
        net.retrieve!
        internal_networks.push(net)
      end
      internal_networks
    end

    # Updates ethernet settings of the Logical Interconnect
    # @note The attribute is defined inside the instance of the Logical Interconnect
    # @return Updated instance of the Logical Interconnect
    def update_ethernet_settings
      ensure_client && ensure_uri
      fail IncompleteResource, 'Please retrieve the Logical Interconnect before trying to update' unless @data['ethernetSettings']
      update_options = {
        'If-Match' =>  @data['ethernetSettings'].delete('eTag'),
        'body' => @data['ethernetSettings']
      }
      response = @client.rest_put(@data['uri'] + '/ethernetSettings', update_options, @api_version)
      body = @client.response_handler(response)
      set_all(body)
    end

    # Updates settings of the Logical Interconnect
    # @param options Options to update the Logical Interconnect
    # @return Updated instance of the Logical Interconnect
    def update_settings(options = {})
      ensure_client && ensure_uri
      options['type'] ||= 'InterconnectSettingsV3'
      options['ethernetSettings'] ||= {}
      options['ethernetSettings']['type'] ||= 'EthernetInterconnectSettingsV3'
      update_options = {
        'If-Match' =>  @data['eTag'],
        'body' => options
      }
      response = @client.rest_put(@data['uri'] + '/settings', update_options, @api_version)
      body = @client.response_handler(response)
      set_all(body)
    end

    # Returns logical interconnects to a consistent state.
    # The current logical interconnect state is compared to the associated logical interconnect group.
    # @return returns the updated object
    def compliance
      ensure_client && ensure_uri
      response = @client.rest_put(@data['uri'] + '/compliance', {}, @api_version)
      body = client.response_handler(response)
      set_all(body)
    end

    # Asynchronously applies or re-applies the logical interconnect configuration to all managed interconnects
    # @return returns the updated object
    def configuration
      ensure_client && ensure_uri
      response = @client.rest_put(@data['uri'] + '/configuration', {}, @api_version)
      body = client.response_handler(response)
      set_all(body)
    end

    # Updates port monitor settings of the Logical Interconnect
    # @note The attribute is defined inside the instance of the Logical Interconnect
    # @return Updated instance of the Logical Interconnect
    def update_port_monitor
      fail IncompleteResource, 'Please retrieve the Logical Interconnect before trying to update' unless @data['portMonitor']
      update_options = {
        'If-Match' =>  @data['portMonitor'].delete('eTag'),
        'body' => @data['portMonitor']
      }
      response = @client.rest_put(@data['portMonitor']['uri'], update_options, @api_version)
      body = @client.response_handler(response)
      set_all(body)
    end

    # Updates QoS aggregated configuration of the Logical Interconnect
    # @note The attribute is defined inside the instance of the Logical Interconnect
    # @return Updated instance of the Logical Interconnect
    def update_qos_configuration
      fail IncompleteResource, 'Please retrieve the Logical Interconnect before trying to update' unless @data['qosConfiguration']
      update_options = {
        'If-Match' =>  @data['qosConfiguration'].delete('eTag'),
        'body' => @data['qosConfiguration']
      }
      response = @client.rest_put(@data['uri'] + '/qos-aggregated-configuration', update_options, @api_version)
      body = @client.response_handler(response)
      set_all(body)
    end

    # Updates telemetry configuration of the Logical Interconnect
    # @note The attribute is defined inside the instance of the Logical Interconnect
    # @return Updated instance of the Logical Interconnect
    def update_telemetry_configuration
      fail IncompleteResource, 'Please retrieve the Logical Interconnect before trying to update' unless @data['telemetryConfiguration']
      update_options = {
        'If-Match' =>  @data['telemetryConfiguration'].delete('eTag'),
        'body' => @data['telemetryConfiguration']
      }
      response = @client.rest_put(@data['telemetryConfiguration']['uri'], update_options, @api_version)
      body = @client.response_handler(response)
      set_all(body)
    end

    # Updates snmp configuration of the Logical Interconnect
    # @note The attribute is defined inside the instance of the Logical Interconnect.
    #   Use helper methods to add the trap destination values: #add_snmp_trap_destination and #generate_trap_options
    # @return Updated instance of the Logical Interconnect
    def update_snmp_configuration
      fail IncompleteResource, 'Please retrieve the Logical Interconnect before trying to update' unless @data['snmpConfiguration']
      update_options = {
        'If-Match' =>  @data['snmpConfiguration'].delete('eTag'),
        'body' => @data['snmpConfiguration']
      }
      response = @client.rest_put(@data['uri'] + '/snmp-configuration', update_options, @api_version)
      body = @client.response_handler(response)
      set_all(body)
    end

    # It will add one trap destination to the Logical Interconnect SNMP configuration
    # @param trap_format [String] SNMP version for this trap destination, `'SNMPv1'` or `'SNMPv2'` or `'SNMPv3'`
    # @param trap_destination [String] The trap destination IP address or host name
    # @param community_string [String] Authentication string for the trap destination
    # @param trap_options [Hash] Hash with the options of the trap. Create it using generate_trap_options method
    def add_snmp_trap_destination(trap_destination, trap_format = 'SNMPv1', community_string = 'public', trap_options = {})
      trap_options['communityString'] = community_string
      trap_options['trapDestination'] = trap_destination
      trap_options['trapFormat'] = trap_format
      @data['snmpConfiguration']['trapDestinations'].push(trap_options)
    end

    # Generates trap options to be used in add_snmp_trap_destination method
    # @param enet_trap_categories [Array]  Filter the traps for this trap destination by the list of configured Ethernet traps
    #   can contain, `'Other'` or `'PortStatus'` or `'PortThresholds'`
    # @param fc_trap_categories [Array]  Filter the traps for this trap destination by the list of configured Fibre Channel traps
    #   can contain, `'Other'` or `'PortStatus'`
    # @param vcm_trap_categories [Array]  Filter the traps for this trap destination by the list of configured VCM trap, `'Legacy'`
    # @param trap_severities [Array]  Filter the traps for this trap destination by the list of configured severities
    #   can contain, `'Critical'` or `'Info'` or `'Major'` or `'Minor'` or `'Normal'` or `'Unknown'` or `'Warning'`
    # @return [Hash] Contains all trap options for one SNMP destination
    def generate_trap_options(enet_trap_categories = [], fc_trap_categories = [], vcm_trap_categories = [], trap_severities = [])
      options = {
        'enetTrapCategories' => enet_trap_categories,
        'vcmTrapCategories' => vcm_trap_categories,
        'fcTrapCategories' => fc_trap_categories,
        'trapSeverities' => trap_severities
      }
      options
    end

    # Gets the installed firmware for a logical interconnect.
    # @return [Hash] Contains all firmware information
    def get_firmware
      ensure_client && ensure_uri
      response = @client.rest_get(@data['uri'] + '/firmware')
      @client.response_handler(response)
    end

    # Update firmware
    # @param [String] command
    # @param [OneviewSDK::FirmwareDriver] firmware_driver
    # @param [Hash] firmware_options
    # @raise [OneviewSDK::IncompleteResource] if the client or uri is not set
    def firmware_update(command, firmware_driver, firmware_options)
      ensure_client && ensure_uri
      firmware_options['command'] = command
      firmware_options['sppUri'] =  firmware_driver['uri']
      firmware_options['sppName'] = firmware_driver['name']
      update_json = {
        'If-Match' => '*',
        'body' => firmware_options
      }
      response = @client.rest_put(@data['uri'] + '/firmware', update_json)
      @client.response_handler(response)
    end
  end
end
