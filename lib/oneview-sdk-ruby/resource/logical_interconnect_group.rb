module OneviewSDK
  # Resource for logical interconnect groups
  # Common Data Attributes:
  #   category
  #   created
  #   description
  #   eTag
  #   Uplink sets (default [])
  #   modified
  #   name (Required)
  #   state
  #   status
  #   enclosureType (Required)
  #   uri
  #   interconnectMapTemplate (Required)
  class LogicalInterconnectGroup < Resource
    BASE_URI = '/rest/logical-interconnect-groups'
    attr_reader :bay_count, :interconnect_provider

    def initialize(client, params = {}, api_ver = nil)
      super
      # Default values:
      @data['enclosureType'] = "C7000"
      @data['state'] = "Active"
      @data['uplinkSets'] = []
      @data['type'] = "logical-interconnect-groupV3"
      @data['interconnectMapTemplate'] = {}
      # User friendly values:
      @data['interconnectBayMap'] = {}
      @bay_count = 8
      @interconnect_provider = OneviewSDK::InterconnectType.new(@client, {})
    end

    def add_interconnect(bay, model)
      @data['interconnectBayMap'].store(bay, @interconnect_provider.model_link(model))
    end

    def add_connection( )

    def create
      interconnect_map_template_parse
      puts "My Map template #{@data["interconnectMapTemplate"]}"
      @data.delete('interconnectBayMap')
      super
    end

    # # Validate X
    # # @param [X] value X..Y
    # def validate_X(value)
    #   fail 'X out of range X..Y' unless value.between?(X, Y)
    # end

    private

    # Relative values:
    #   Downlink Ports: D1 is 1, D2 is 2, ....,D15 is 15, D16 is 16;
    #   Uplink Ports: X1 is 17, X2 is 18, ....,X9 is 25, X10 is 26.
    def relative_value_of (port)
      identifier = port.slice!(0)
      case identifier
      when "D"
        offset = 0
      when "X"
        offset = 16
      else
        fail"Port not supported: #{identifier} type not found"
      end
      port.to_i+offset
    end

    def interconnect_map_template_parse
      if @data['interconnectMapTemplate'] == {}
        @data['interconnectMapTemplate']['interconnectMapEntryTemplates'] = []
        1.upto(@bay_count) do |bay_number|
          entry = {
            "logicalDownlinkUri" => nil,
            "logicalLocation" => {
              "locationEntries" => [
                {"relativeValue" => bay_number, "type" => "Bay" },
                {"relativeValue" => 1, "type" => "Enclosure" }
              ]
            },
            "permittedInterconnectTypeUri" => @data["interconnectBayMap"][bay_number]
          }
          @data['interconnectMapTemplate']['interconnectMapEntryTemplates'] << entry
        end
      end
    end

  end
end
