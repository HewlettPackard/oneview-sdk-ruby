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
      {'locationEntries' => [
        { 'value' => bay_number, 'type' => 'Bay' },
        { 'value' => enclosure['uri'], 'type' => 'Enclosure' }
      ]}
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
      query_uri = self.class::LOCATION_URI+"?location=Enclosure:#{enclosure_uri},Bay:#{bay_number}"
      response = @client.rest_delete(query_uri, {}, @api_version)
      body = @client.response_handler(response)
      self
    end

    # Updates internal networks on the logical interconnect
    # @param [OneviewSDK::EthernetNetworks] List of networks to update the Logical Interconnect
    def update_internal_networks(*networks)
      uris = []
      networks.each do |net|
        net.retrieve! unless net['uri']
        uris.push(net['uri'])
      end
      puts uris
      response = @client.rest_put(@data['uri']+"/internalNetworks", uris, @api_version)
      body = @client.response_handler(response)
    end

    # Lists internal networks on the logical interconnect
    # @return [OneviewSDK::EthernetNetwork] List of networks
    def list_vlan_networks
      results = OneviewSDK::Resource.find_by(@client, {}, @data['uri']+'/internalVlans')
      internal_networks = []
      results.each do |vlan|
        net = if vlan['generalNetworkUri'].include? "ethernet-network"
          OneviewSDK::EthernetNetwork.new(@client, {uri: vlan['generalNetworkUri']})
        elsif vlan['generalNetworkUri'].include? "fc-network"
          OneviewSDK::FCNetwork.new(@client, {uri: vlan['generalNetworkUri']})
        else
          OneviewSDK::FCoENetwork.new(@client, {uri: vlan['generalNetworkUri']})
        end
        net.retrieve!
        internal_networks.push(net)
      end
      internal_networks
    end

  end
end
