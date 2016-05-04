module OneviewSDK
  # Logical Switch Group resource implementation
  class LogicalSwitchGroup < Resource
    BASE_URI = '/rest/logical-switch-group'.freeze

    def initialize(client, params = {}, api_ver = nil)
      super
      # Default values:
      @data['category'] ||= 'logical-switch-groups'
      @data['state'] ||= 'Active'
      @data['type'] ||= 'logical-switch-group'
      @data['switchMapTemplate'] ||= {}
      @data['switchMapTemplate']['switchMapEntryTemplates'] ||= []
      @bay_count = 2

      # Create all entries if empty
      parse_switch_map_template if @data['switchMapTemplate']['switchMapEntryTemplates'] == []
    end

    # Add a switch
    # @param [Fixnum] stacking_member_id Number of the switch inside the group [1,2]
    # @param [String] type Interconnect type
    def add_switch(stacking_member_id, type)
      @data['switchMapTemplate']['switchMapEntryTemplates'].each do |entry|
        entry['logicalLocation']['locationEntries'].each do |location|
          if location['type'] == 'StackingMemberId' && location['relativeValue'] == stacking_member_id
            entry['permittedSwitchTypeUri'] = OneviewSDK::Switch.get_type(@client, type)['uri']
          end
        end
      end
    rescue StandardError
      list = OneviewSDK::Switch.get_types(@client).map { |t| t['name'] }
      raise "Switch type #{type} not found! Supported types: #{list}"
    end

    private

    def parse_switch_map_template
      1.upto(@bay_count) do |bay_number|
        entry = {
          'logicalLocation' => {
            'locationEntries' => [
              { 'relativeValue' => bay_number, 'type' => 'StackingMemberId' },
            ]
          },
          'permittedSwitchTypeUri' => nil
        }
        @data['switchMapTemplate']['switchMapEntryTemplates'] << entry
      end
    end

  end
end
