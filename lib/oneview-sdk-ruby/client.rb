require_relative 'rest'
Dir[File.dirname(__FILE__) + '/client/*.rb'].each { |file| require file }

module OneviewSDK
  class Client
    include Rest

    # Tell OneView to create the resource using the current attribute data
    def create(resource)
      fail "Cannot create! Must be a subclass of OneviewSDK::Resource but got #{resource.class}" unless resource.class < Resource
      resource.client = self
      resource.create
    end

    # Save current attribute data to OneView
    def save(resource)
      fail "Cannot save! Must be a subclass of OneviewSDK::Resource but got #{resource.class}" unless resource.class < Resource
      resource.client = self
      resource.save
    end

    # Set attribute data and save to OneView
    def update(resource, attributes = {})
      fail "Cannot update! Must be a subclass of OneviewSDK::Resource but got #{resource.class}" unless resource.class < Resource
      resource.client = self
      resource.update(attributes)
    end

    # Updates this object using the data that exists on OneView
    def refresh(resource)
      fail "Cannot refresh! Must be a subclass of OneviewSDK::Resource but got #{resource.class}" unless resource.class < Resource
      resource.client = self
      resource.refresh
    end

    def delete(resource)
      fail "Cannot delete! Must be a subclass of OneviewSDK::Resource but got #{resource.class}" unless resource.class < Resource
      resource.client = self
      resource.delete
    end

  end
end
