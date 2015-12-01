module OneviewSDK
  # Resource for interconnect types
  class InterconnectType < Resource
    BASE_URI = '/rest/interconnect-types'

    def initialize(client, params = {}, api_ver = nil)
      super
    end

    def model_link(model)
      link = InterconnectType.find_by(@client, name: model)
      unless link
        interconnect_list = InterconnectType.find_by(@client, {})
        model_list = ''
        interconnect_list.each do |interconnect|
          model_list += "\n#{interconnect["name"]}"
        end
        fail "It wasn't possible to find the interconnect type #{model}. Supported types:#{model_list}"
      end
      link.first['uri']
    end

  end
end
