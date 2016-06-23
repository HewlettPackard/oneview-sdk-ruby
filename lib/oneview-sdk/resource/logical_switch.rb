# (C) Copyright 2016 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

module OneviewSDK
  # Logical switch resource implementation
  class LogicalSwitch < Resource
    BASE_URI = '/rest/logical-switches'.freeze

    attr_accessor :logical_switch_credentials

    def initialize(client, params = {}, api_ver = nil)
      super
      # Default values
      @data['type'] ||= 'logical-switch'
      @logical_switch_credentials = {}
    end

    # Create method
    # @raise [OneviewSDK::IncompleteResource] if the client is not set
    # @raise [StandardError] if the resource creation fails
    # @return [Resource] self
    def create
      ensure_client
      request_body = {}
      request_body['logicalSwitchCredentials'] = generate_logical_switch_credentials
      request_body['logicalSwitch'] = @data.clone
      request_body['logicalSwitch']['switchCredentialConfiguration'] = generate_logical_switch_credential_configuration
      response = @client.rest_post(self.class::BASE_URI, { 'body' => request_body }, @api_version)
      body = @client.response_handler(response)
      set_all(body)
      self
    end

    # Updates this object using the data that exists on OneView
    # @note Will overwrite any data that differs from OneView
    # @return [Resource] self
    def refresh
      response = @client.rest_put(@data['uri'] + '/refresh')
      @client.response_handler(response)
    end


    # @!group Credentials
    CredentialsSSH = Struct.new(:user, :password)

    CredentialsSNMPV1 = Struct.new(:port, :community_string, :version) do
      # @return [String] Returns SNMPv1
      def version
        'SNMPv1'
      end
    end

    CredentialsSNMPV3 = Struct.new(:port, :user, :auth_protocol, :auth_password, :privacy_protocol, :privacy_password, :version) do
      # @return [String] Returns SNMPv3
      def version
        'SNMPv3'
      end
    end

    # Set switch credentials
    # @param [String] host IP address or host name
    # @param [CredentialsSSH] ssh_credentials SSH credentials
    # @param [CredentialsSNMP] snmp_credentials SNMP credentials
    # @return [Array] Array containing SSH and SNMP credentials
    def set_switch_credentials(host, ssh_credentials, snmp_credentials)
      fail TypeError, 'Use struct<OneviewSDK::LogicalSwitch::CredentialsSSH>' if ssh_credentials.class != OneviewSDK::LogicalSwitch::CredentialsSSH
      fail TypeError, 'Use struct<OneviewSDK::LogicalSwitch::CredentialsSNMP>' unless snmp_credentials.respond_to?('version')
      fail TypeError, 'Use struct<OneviewSDK::LogicalSwitch::CredentialsSNMP>' if snmp_credentials.version != 'SNMPv1' &&
        snmp_credentials.version != 'SNMPv3'
      @logical_switch_credentials[host] = [ssh_credentials.clone, snmp_credentials.clone]
      @logical_switch_credentials[host]
    end

    # @!endgroup


    # Set logical switch group
    # @param [OneviewSDK::logicalSwitchGroup] logical_switch_group Logical switch group
    def set_logical_switch_group(logical_switch_group)
      @data['logicalSwitchGroupUri'] = logical_switch_group['uri']
    end

    private

    # Generate logical switch credentials for POST and PUT requests
    # @return [Array] List of connection properties for each logical switch
    def generate_logical_switch_credentials
      credentials = []
      @logical_switch_credentials.each do |_, switch|
        switch_credentials = []
        switch_credentials << {
          'valueFormat' => 'Unknown',
          'propertyName' => 'SshBasicAuthCredentialUser',
          'valueType' => 'String',
          'value' => switch[0].user
        }

        switch_credentials << {
          'valueFormat' => 'SecuritySensitive',
          'propertyName' => 'SshBasicAuthCredentialPassword',
          'valueType' => 'String',
          'value' => switch[0].password
        }

        if switch[1].version == 'SNMPv3'
          switch_credentials << {
            'valueFormat' => 'SecuritySensitive',
            'propertyName' => 'SnmpV3AuthorizationPassword',
            'valueType' => 'String',
            'value' => switch[1].auth_password
          }

          switch_credentials << {
            'valueFormat' => 'Unknown',
            'propertyName' => 'SnmpV3User',
            'valueType' => 'String',
            'value' => switch[1].user
          }

          if switch[1].privacy_password
            switch_credentials << {
              'valueFormat' => 'SecuritySensitive',
              'propertyName' => 'SnmpV3PrivacyPassword',
              'valueType' => 'String',
              'value' => switch[1].privacy_password
            }
          end
        end

        credentials << { 'connectionProperties' => switch_credentials }
      end
      credentials
    end

    # Generate logical switch credential configuration for POST and PUT requests
    # @return [Array] List of logical switch credential configuration for each switch
    def generate_logical_switch_credential_configuration
      configuration = []
      @logical_switch_credentials.each do |host, switch|
        switch_configuration = {
          'snmpPort' => switch[1].port,
          'snmpV3Configuration' => nil,
          'snmpV1Configuration' => nil,
          'logicalSwitchManagementHost' => host,
          'snmpVersion' => switch[1].version
        }

        if switch[1].version == 'SNMPv3'
          switch_configuration['snmpV1Configuration'] = nil
          switch_configuration['snmpV3Configuration'] = {
            'authorizationProtocol' => switch[1].auth_protocol
          }

          if switch[1].privacy_protocol
            switch_configuration['snmpV3Configuration']['securityLevel'] = 'AuthPrivacy'
            switch_configuration['snmpV3Configuration']['privacyProtocol'] = switch[1].privacy_protocol
          else
            switch_configuration['snmpV3Configuration']['securityLevel'] = 'Auth'
          end

        elsif switch[1].version == 'SNMPv1'
          switch_configuration['snmpV3Configuration'] = nil
          switch_configuration['snmpV1Configuration'] = {
            'communityString' => switch[1].community_string
          }
        end
        configuration << switch_configuration
      end
      configuration
    end

  end
end
