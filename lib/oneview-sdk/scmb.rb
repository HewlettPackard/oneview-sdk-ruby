# (c) Copyright 2017 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

require_relative 'client'
require 'bunny'

module OneviewSDK
  # State Schange Message Bus (SCMB) helper
  module SCMB
    DEFAULT_ROUTING_KEY = 'scmb.#'.freeze

    # Create a new connection to the message bus
    # @param [OneviewSDK::Client] client The client object for the OneView appliance
    # @param [Hash] opts Connection options (passed to Bunny.new). Defaults:
    #     port: 5671
    #     auth_mechanism: 'EXTERNAL'
    #     tls: true
    #     verify_peer: client.ssl_enabled
    #     tls_cert: (retrieved automatically from OneView)
    #     tls_key: (retrieved automatically from OneView)
    #     tls_ca_certificates: System default CA (unless verify_peer is false)
    #   See http://rubybunny.info/articles/connecting.html for more details & options
    # @return [Bunny::Session] Connection to the message bus
    def self.new_connection(client, opts = {})
      con_opts = {
        port: 5671,
        auth_mechanism: 'EXTERNAL',
        tls: true,
        verify_peer: client.ssl_enabled
      }
      con_opts.merge!(opts)
      con_opts[:host] = URI.parse(client.url).host
      unless con_opts[:tls_cert] && con_opts[:tls_key]
        kp = get_or_create_keypair(client)
        con_opts[:tls_cert] = kp['base64SSLCertData']
        con_opts[:tls_key] = kp['base64SSLKeyData']
      end
      Bunny.new(con_opts).start
    end

    # Retrieve or create the default RabbitMQ keypair
    # @param [OneviewSDK::Client] client The client object for the OneView appliance
    # @return [Hash] Keypair details
    def self.get_or_create_keypair(client)
      client.response_handler(client.rest_get('/rest/certificates/client/rabbitmq/keypair/default'))
    rescue OneviewSDK::NotFound # Create the keypair if it doesn't exist
      client.logger.info('RabbitMQ default keypair not found. Creating it now.')
      opts = { commonName: 'default', type: 'RabbitMqClientCertV2' }
      client.response_handler(client.rest_post('/rest/certificates/client/rabbitmq', body: opts))
      # Retrieve the created key
      client.response_handler(client.rest_get('/rest/certificates/client/rabbitmq/keypair/default'))
    end

    # @param [Bunny::Session] Connection to the message bus. See ::new_connection
    # @return [Bunny::Queue] Queue listening to the specified routing key
    def self.new_queue(connection, routing_key = DEFAULT_ROUTING_KEY)
      ch = connection.create_channel
      q = ch.queue('')
      q.bind('scmb', routing_key: routing_key)
    end
  end
end
