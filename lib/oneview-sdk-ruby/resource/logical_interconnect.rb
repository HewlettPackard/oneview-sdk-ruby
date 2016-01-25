module OneviewSDK
  # Resource for logical interconnect groups
  # Common Data Attributes:
  #   category
  #   created
  #   description
  #   enclosureType (Required)
  #   eTag
  #   interconnectMapTemplate (Required)
  #   modified
  #   name (Required)
  #   state
  #   status
  #   uplinkSets (Required) (default = [])
  #   uri
  class LogicalInterconnect < Resource
    BASE_URI = '/rest/logical-interconnects'
    LOCATION_URI = '/rest/logical-interconnects/locations/interconnects'

    # Creates a logical interconnect in the desired Bay in a specified enclosure
    # WARN: It does not creates the interconnect itself.
    # It will fail if no interconnect is already present on the specified position
    # @param [Fixnum] Number of the bay to put the interconnect
    # @param [OneviewSDK::Resource] Enclosure to insert the interconnect
    def create(bay_number, enclosure)
      entry =
      {
        'locationEntries' => [
          { 'value' => bay_number, 'type' => 'Bay' },
          { 'value' => enclosure['uri'], 'type' => 'Enclosure' }
        ]
      }
      # ensure_client
      response = @client.rest_post(self.class::LOCATION_URI, { 'body' => entry }, @api_version)
      body = @client.response_handler(response)
      set_all(body)
      self
    end

    # Deletes a logical interconnect
    # WARN: This won't delete the interconnect itself
    # @param [Fixnum] Number of the bay to locate the logical interconnect
    # @param [OneviewSDK::Resource] Enclosure to remove the logical interconnect
    def delete
      # ensure_client
      int_location = @data['interconnectLocation']['locationEntries']
      enclosure_uri = nil
      bay_number = 0
      int_location.each do |entry|
        enclosure_uri = entry['value'] if entry['type'] == 'Enclosure'
        bay_number = entry['value'] if entry['type'] == 'Bay'
      end
      query_uri = self.class::LOCATION_URI + "?location=Enclosure:#{enclosure_uri},Bay:#{bay_number}"
      response = @client.rest_delete(query_uri, {}, @api_version)
      @client.response_handler(response)
      self
    end

    # Updates internal networks on the logical interconnect
    # @param [OneviewSDK::EthernetNetworks] List of networks to update the Logical Interconnect
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
      self
    end

    # Lists internal networks on the logical interconnect
    # @return [OneviewSDK::Resource] List of networks
    def list_vlan_networks
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
      fail 'Please retrieve the Logical Interconnect before trying to update' unless @data['ethernetSettings']
      update_options = {
        'If-Match' =>  @data['ethernetSettings'].delete('eTag'),
        'Body' => @data['ethernetSettings']
      }
      response = @client.rest_put(@data['uri'] + '/ethernetSettings', update_options, @api_version)
      body = @client.response_handler(response)
      set_all(body)
      self
    end

    # Updates settings of the Logical Interconnect
    # @param Options to update the Logical Interconnect
    # @return Updated instance of the Logical Interconnect
    def update_settings(options = {})
      fail 'Please retrieve the Logical Interconnect before trying to update' unless @data['uri']
      options['type'] ||= 'InterconnectSettingsV3'
      options['ethernetSettings'] ||= {}
      options['ethernetSettings']['type'] ||= 'EthernetInterconnectSettingsV3'
      update_options = {
        'If-Match' =>  @data['eTag'],
        'Body' => options
      }
      response = @client.rest_put(@data['uri'] + '/settings', update_options, @api_version)
      body = @client.response_handler(response)
      set_all(body)
      self
    end

    # Returns logical interconnects to a consistent state.
    # The current logical interconnect state is compared to the associated logical interconnect group.
    # @return returns the updated object
    def compliance
      fail 'Please retrieve the Logical Interconnect before trying to update' unless @data['uri']
      response = @client.rest_put(@data['uri'] + '/compliance', {}, @api_version)
      body = client.response_handler(response)
      set_all(body)
      self
    end

    # Asynchronously applies or re-applies the logical interconnect configuration to all managed interconnects
    # @return returns the updated object
    def configure
      fail 'Please retrieve the Logical Interconnect before trying to update' unless @data['uri']
      response = @client.rest_put(@data['uri'] + '/configure', {}, @api_version)
      body = client.response_handler(response)
      set_all(body)
      self
    end

    # Updates port monitor settings of the Logical Interconnect
    # @note The attribute is defined inside the instance of the Logical Interconnect
    # @return Updated instance of the Logical Interconnect
    def update_port_monitor
      fail 'Please retrieve the Logical Interconnect before trying to update' unless @data['portMonitor']
      update_options = {
        'If-Match' =>  @data['portMonitor'].delete('eTag'),
        'Body' => @data['portMonitor']
      }
      response = @client.rest_put(@data['portMonitor']['uri'], update_options, @api_version)
      body = @client.response_handler(response)
      set_all(body)
      self
    end

    # Updates QoS aggregated configuration of the Logical Interconnect
    # @note The attribute is defined inside the instance of the Logical Interconnect
    # @return Updated instance of the Logical Interconnect
    def update_qos_configuration
      fail 'Please retrieve the Logical Interconnect before trying to update' unless @data['qosConfiguration']
      update_options = {
        'If-Match' =>  @data['qosConfiguration'].delete('eTag'),
        'Body' => @data['qosConfiguration']
      }
      response = @client.rest_put(@data['uri'] + '/qos-aggregated-configuration', update_options, @api_version)
      body = @client.response_handler(response)
      set_all(body)
      self
    end

    # Updates telemetry configuration of the Logical Interconnect
    # @note The attribute is defined inside the instance of the Logical Interconnect
    # @return Updated instance of the Logical Interconnect
    def update_telemetry_configuration
      fail 'Please retrieve the Logical Interconnect before trying to update' unless @data['telemetryConfiguration']
      update_options = {
        'If-Match' =>  @data['telemetryConfiguration'].delete('eTag'),
        'Body' => @data['telemetryConfiguration']
      }
      response = @client.rest_put(@data['telemetryConfiguration']['uri'], update_options, @api_version)
      body = @client.response_handler(response)
      set_all(body)
      self
    end

  end
end
