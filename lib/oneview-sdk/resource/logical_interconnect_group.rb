module OneviewSDK
  # Logical enclosure group resource implementation
  class LogicalInterconnectGroup < Resource
    BASE_URI = '/rest/logical-interconnect-groups'.freeze
    attr_reader :bay_count

    def initialize(client, params = {}, api_ver = nil)
      super
      # Default values:
      @data['enclosureType'] ||= 'C7000'
      @data['state'] ||= 'Active'
      @data['uplinkSets'] ||= []
      @data['type'] ||= 'logical-interconnect-groupV3'
      @data['interconnectMapTemplate'] ||= {}
      @data['interconnectMapTemplate']['interconnectMapEntryTemplates'] ||= []

      # User friendly values:
      @bay_count = 8

      # Create all entries if empty
      parse_interconnect_map_template if @data['interconnectMapTemplate']['interconnectMapEntryTemplates'] == []
    end

    # Add an interconnect
    # @param [Fixnum] bay Bay number
    # @param [String] type Interconnect type
    def add_interconnect(bay, type)
      @data['interconnectMapTemplate']['interconnectMapEntryTemplates'].each do |entry|
        entry['logicalLocation']['locationEntries'].each do |location|
          if location['type'] == 'Bay' && location['relativeValue'] == bay
            entry['permittedInterconnectTypeUri'] = OneviewSDK::Interconnect.get_type(@client, type)['uri']
          end
        end
      end
    rescue StandardError
      list = OneviewSDK::Interconnect.get_types(@client).map { |t| t['name'] }
      raise "Interconnect type #{type} not found! Supported types: #{list}"
    end

    # Add an uplink set
    # @param [OneviewSDK::LIGUplinkSet] uplink_set
    def add_uplink_set(uplink_set)
      @data['uplinkSets'] << uplink_set.data
    end

    # Get the default settings
    def get_default_settings
      get_uri = self.class::BASE_URI + '/defaultSettings'
      response = @client.rest_get(get_uri, @api_version)
      @client.response_handler(response)
    end

    # Get settings
    def get_settings
      get_uri = @data['uri'] + '/settings'
      response = @client.rest_get(get_uri, @api_version)
      @client.response_handler(response)
    end

    # Saves the current data attributes to the Logical Interconnect Group
    # @return Updated instance of the Logical Interconnect Group
    def update(attributes = {})
      set_all(attributes)
      update_options = {
        'If-Match' =>  @data.delete('eTag'),
        'Body' => @data
      }
      response = @client.rest_put(@data['uri'], update_options, @api_version)
      body = @client.response_handler(response)
      set_all(body)
    end

    private

    def parse_interconnect_map_template
      1.upto(@bay_count) do |bay_number|
        entry = {
          'logicalDownlinkUri' => nil,
          'logicalLocation' => {
            'locationEntries' => [
              { 'relativeValue' => bay_number, 'type' => 'Bay' },
              { 'relativeValue' => 1, 'type' => 'Enclosure' }
            ]
          },
          'permittedInterconnectTypeUri' => nil
        }
        @data['interconnectMapTemplate']['interconnectMapEntryTemplates'] << entry
      end
    end

  end
end
