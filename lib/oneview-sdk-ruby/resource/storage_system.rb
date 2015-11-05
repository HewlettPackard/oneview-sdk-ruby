module OneviewSDK
  # Resource for storage system
  # Common Data Attributes:
  #   allocatedCapacity
  #   category
  #   created
  #   credentials
  #   description
  #   eTag
  #   firmware
  #   freeCapacity
  #   managedDomain
  #   managedPools
  #   managedPorts
  #   model
  #   modified
  #   name
  #   refreshState
  #   serialNumber
  #   state
  #   stateReason
  #   status
  #   totalCapacity
  #   type
  #   unmanagedDomains
  #   unmanagedPools
  #   unmanagedPorts
  #   uri
  #   wwn
  class StorageSystem < Resource
    BASE_URI = '/rest/storage-systems'

    def initialize(client, params = {}, api_ver = nil)
      super
      # Default values:
      @data['type'] ||= 'StorageSystemV3'
    end
   
    def create
      ensure_client
      @client.rest_post(self.class::BASE_URI, { 'body' => @data['credentials'] }, @api_version)
      temp = @data.clone
      sleep 10
      self.retrieve!
      temp.delete('credentials')
      self.update(temp)
      self
    end

    def retrieve!(name = @data['name'], credentials = @data['credentials'])
      if name.nil?
        results = self.class.find_by(@client, credentials: {ip_hostname: credentials[:ip_hostname]})
        return false unless results.size == 1 # FALSE OR SOMETHING ELSE ?
        set_all(results[0].data)
      else
        super.retrieve!
      end
    end

    def validate_refreshState(value)
      fail 'Invalid refresh state' unless %w(NotRefreshing RefreshFailed RefreshPending Refreshing).include?(value)
    end

    def validate_status(value)
      fail 'Invalid status' unless %w(OK Disabled Warning Critical Unknown).include?(value)
    end

  end
end
