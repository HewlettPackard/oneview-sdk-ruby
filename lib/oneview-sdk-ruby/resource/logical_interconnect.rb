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

    # Creates an interconnect in the desired Bay in a specified enclosure
    # @param [Fixnum] Number of the bay to put the interconnect
    # @param [Fixnum] Number of the enclosure to insert the interconnect
    def create(bay_number, enclosure)
      entry =
      {'locationEntries' => [
        { 'value' => bay_number, 'type' => 'Bay' },
        { 'value' => enclosure['uri'], 'type' => 'Enclosure' }
      ]}
      # ensure_client
      response = @client.rest_post(self.class::BASE_URI+'/locations/interconnects', { 'body' => entry }, @api_version)
      body = @client.response_handler(response)
      set_all(body)
      self
    end

    def delete
      # ensure_client
      int_location = @data['interconnectLocation']['locationEntries']
      enclosure_uri = nil
      bay_number = 0
      int_location.each do |entry|
        enclosure_uri = entry['value'] if entry['type'] == 'Enclosure'
        bay_number = entry['value'] if entry['type'] == 'Bay'
      end
      query_uri = self.class::BASE_URI+"/locations/interconnects?location=Enclosure:#{enclosure_uri},Bay:#{bay_number}"
      response = @client.rest_delete(query_uri, {}, @api_version)
      body = @client.response_handler(response)
      self
    end

  end
end
