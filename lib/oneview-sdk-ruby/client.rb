require_relative 'rest'
Dir[File.dirname(__FILE__) + '/client/*.rb'].each { |file| require file }

module OneviewSDK
  # The client defines the connection to the OneView server and handles the communication with it.
  class Client
    DEFAULT_API_VERSION = 200

    attr_reader :url, :user, :max_api_version
    attr_accessor :use_ssl, :api_version, :logger, :log_level

    include Rest

    def initialize(params)
      # TODO: fail unless all required params are present
      @url = params[:url]
      @user = params[:user] || 'Administrator'
      @password = params[:password]
      @api_version = params[:api_version] || DEFAULT_API_VERSION
      # TODO: login & set @max_api_version
    end

    # Tell OneView to create the resource using the current attribute data
    def create(resource)
      resource.client = self
      resource.create
    end

    # Save current attribute data to OneView
    def save(resource)
      resource.client = self
      resource.save
    end

    # Set attribute data and save to OneView
    def update(resource, attributes = {})
      resource.client = self
      resource.update(attributes)
    end

    # Updates this object using the data that exists on OneView
    def refresh(resource)
      resource.client = self
      resource.refresh
    end

    def delete(resource)
      resource.client = self
      resource.delete
    end

  end
end
