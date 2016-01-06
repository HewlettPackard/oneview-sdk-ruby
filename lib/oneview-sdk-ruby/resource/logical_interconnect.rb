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
    def create_interconnect(bay_number, enclosure_number)
      entry = 'locationEntries' => [
        { 'relativeValue' => bay, 'type' => 'Bay' },
        { 'relativeValue' => enclosure, 'type' => 'Enclosure' }
      ]
      ensure_client
      response = @client.rest_post(self.class::BASE_URI+'/locations/interconnects', { 'body' => entry }, @api_version)
      body = @client.response_handler(response)
      self
    end

    def delete_interconnect(bay_number, enclosure)
      ensure_client
      query_uri = self.class::BASE_URI+"/locations/interconnects?location=Enclosure:#{enclosure['uri']},Bay:#{bay_number}"
      response = @client.rest_delete(query_uri, {}, @api_version)
      body = @client.response_handler(response)
      self
    end

  end
end
