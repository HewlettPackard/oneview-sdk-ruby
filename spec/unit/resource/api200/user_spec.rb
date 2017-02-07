require 'spec_helper'

klass = OneviewSDK::API200::User
RSpec.describe klass do
  include_context 'shared context'

  describe '#initialize' do
    it 'sets the defaults correctly' do
      res = klass.new(@client)
      expect(res[:type]).to eq('UserAndRoles')
      expect(res[:enabled]).to eq(true)
      expect(res[:roles]).to eq(['Read only'])
    end
  end

  describe '#create' do
    before :each do
      @data = { userName: 'test', password: 'secret123' }
      @res = klass.new(@client, @data)
      fake_response = FakeResponse.new(uri: '/rest/fake')
      allow(@client).to receive(:rest_post).and_return(fake_response)
    end

    it 'sets the data returned in the reponse' do
      @res.create
      expect(@res['uri']).to eq('/rest/fake')
    end

    it 'removes the password after creation' do
      @res.create
      expect(@res['password']).to be nil
    end
  end

  describe '#update' do
    before :each do
      @data = { 'userName' => 'test', 'uri' => '/rest/fake', 'roles' => ['Read only'] }
      @res = klass.new(@client, @data)
    end

    it 'requires the client to be set' do
      @res.client = nil
      expect { @res.update }.to raise_error(OneviewSDK::IncompleteResource, /Please set client attribute/)
    end

    it 'requires the uri to be set' do
      @res['uri'] = nil
      expect { @res.update }.to raise_error(OneviewSDK::IncompleteResource, /Please set uri attribute/)
    end

    it 'removes the roles attribute from the PUT request' do
      fake_response = FakeResponse.new(roles: ['Read only'])
      data2 = { 'body' => @res.data.delete_if { |k, _v| k.to_s == 'roles' } }
      expect(@client).to receive(:rest_put).with(klass::BASE_URI, data2, 200).and_return(fake_response)
      @res.update
    end

    it 'sets the roles if they do not match the response' do
      fake_response = FakeResponse.new(roles: ['Network administrator'])
      data2 = { 'body' => @res.data.select { |k, _v| k.to_s != 'roles' } }
      expect(@client).to receive(:rest_put).with(klass::BASE_URI, data2, 200).and_return(fake_response)
      expect(@res).to receive(:set_roles).with(@res['roles']).and_return(fake_response)
      @res.update
    end
  end

  describe '#update' do
    before :each do
      @data = { 'userName' => 'test', 'uri' => '/rest/fake', 'roles' => ['Read only'] }
      @res = klass.new(@client, @data)
    end

    it 'requires a roles parameter' do
      @res.client = nil
      expect { @res.set_roles }.to raise_error(ArgumentError)
    end

    it 'requires the client to be set' do
      @res.client = nil
      expect { @res.set_roles([]) }.to raise_error(OneviewSDK::IncompleteResource, /Please set client attribute/)
    end

    it 'requires the uri to be set' do
      @res['uri'] = nil
      expect { @res.set_roles([]) }.to raise_error(OneviewSDK::IncompleteResource, /Please set uri attribute/)
    end

    it 'makes a PUT call with the role data and sets the data attribute' do
      fake_response = FakeResponse.new([{ 'roleName' => 'Network administrator' }])
      data = { 'body' => [{ roleName: 'Network administrator', type: 'RoleNameDtoV2' }] }
      expect(@client).to receive(:rest_put).with("#{@data['uri']}/roles?multiResource=true", data, 200)
        .and_return(fake_response)
      expect(@res['roles']).to eq(['Read only']) # Before
      @res.set_roles(['Network administrator'])
      expect(@res['roles']).to eq(['Network administrator']) # After
    end
  end
end
