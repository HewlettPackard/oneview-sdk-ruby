module OneviewSDK
  # Resource for interconnect types
  class InterconnectType < Resource
    BASE_URI = '/rest/interconnect-types'.freeze

    def initialize(client, params = {}, api_ver = nil)
      super
    end

    def create
      fail 'Method not available for this resource!'
    end

    def update
      create
    end

    def save
      create
    end

    def delete
      create
    end

  end
end
