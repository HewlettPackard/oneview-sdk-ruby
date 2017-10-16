require 'spec_helper'

klass = OneviewSDK::API200::User
RSpec.describe klass do
  include_context 'shared context'

  describe '#initialize' do
    it 'sets the defaults correctly' do
      res = klass.new(@client_200)
      expect(res[:type]).to eq('UserAndRoles')
      expect(res[:enabled]).to eq(true)
      expect(res[:roles]).to eq(['Read only'])
    end
  end

  describe '#create' do
    before :each do
      @data = { userName: 'test', password: 'secret123' }
      @res = klass.new(@client_200, @data)
      fake_response = FakeResponse.new(uri: '/rest/fake')
      allow(@client_200).to receive(:rest_post).and_return(fake_response)
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
      @res = klass.new(@client_200, @data)
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
      expect(@client_200).to receive(:rest_put).with(klass::BASE_URI, data2, 200).and_return(fake_response)
      @res.update
    end

    it 'sets the roles if they do not match the response' do
      fake_response = FakeResponse.new(roles: ['Network administrator'])
      data2 = { 'body' => @res.data.reject { |k, _v| k.to_s == 'roles' } }
      expect(@client_200).to receive(:rest_put).with(klass::BASE_URI, data2, 200).and_return(fake_response)
      expect(@res).to receive(:set_roles).with(@res['roles']).and_return(fake_response)
      @res.update
    end
  end

  describe '#update' do
    before :each do
      @data = { 'userName' => 'test', 'uri' => '/rest/fake', 'roles' => ['Read only'] }
      @res = klass.new(@client_200, @data)
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
      expect(@client_200).to receive(:rest_put).with("#{@data['uri']}/roles?multiResource=true", data, 200)
                                               .and_return(fake_response)
      expect(@res['roles']).to eq(['Read only']) # Before
      @res.set_roles(['Network administrator'])
      expect(@res['roles']).to eq(['Network administrator']) # After
    end
  end

  describe '#validate_user_name' do
    it 'validates an user by user name' do
      user_name = 'userName'
      fake_response = FakeResponse.new
      expect(@client_200).to receive(:rest_post).with("#{klass::BASE_URI}/validateLoginName/#{user_name}")
                                                .and_return(fake_response)
      expect(@client_200).to receive(:response_handler).with(fake_response).and_return(true)
      expect(klass.validate_user_name(@client_200, user_name)).to eq(true)
    end
  end

  describe '#validate_full_name' do
    it 'validates an user by full name' do
      full_name = 'fullName'
      fake_response = FakeResponse.new
      expect(@client_200).to receive(:rest_post).with("#{klass::BASE_URI}/validateUserName/#{full_name}")
                                                .and_return(fake_response)
      expect(@client_200).to receive(:response_handler).with(fake_response).and_return(true)
      expect(klass.validate_full_name(@client_200, full_name)).to eq(true)
    end
  end
end
