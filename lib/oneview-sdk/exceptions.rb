# (c) Copyright 2016-2017 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

# Contains all the custom Exception classes
module OneviewSDK
  # Error class allowing storage of a data attribute
  class OneViewError < ::StandardError
    attr_accessor :data
    MESSAGE = '(No message)'.freeze

    def initialize(msg = self.class::MESSAGE, data = nil)
      @data = data
      super(msg)
    end

    # Shorthand method to raise an error.
    # @example
    #   OneviewSDK::OneViewError.raise! 'Message', { data: 'stuff' }
    def self.raise!(msg = self::MESSAGE, data = nil)
      raise new(msg, data)
    end
  end

  class ConnectionError < OneViewError # Cannot connect to client/resource
    MESSAGE = 'Cannot connect to client/resource'.freeze
  end

  class InvalidURL < OneViewError # URL is invalid
    MESSAGE = 'URL is invalid'.freeze
  end

  class InvalidClient < OneViewError # Client configuration is invalid
    MESSAGE = 'Client configuration is invalid'.freeze
  end

  class InvalidResource < OneViewError # Failed resource validations
    MESSAGE = 'Failed resource validations'.freeze
  end

  class IncompleteResource < OneViewError # Missing required resource data to complete action
    MESSAGE = 'Missing required resource data to complete action'.freeze
  end

  class MethodUnavailable < OneViewError # Resource does not support this method
    MESSAGE = 'Resource does not support this method'.freeze
  end

  class UnsupportedVariant < OneViewError # Variant is not supported
    MESSAGE = 'Variant is not supported'.freeze
  end

  class UnsupportedVersion < OneViewError # Resource not supported on this API version
    MESSAGE = 'Resource not supported on this API version'.freeze
  end

  class InvalidRequest < OneViewError # Could not make request
    MESSAGE = 'Could not make request'.freeze
  end

  class BadRequest < OneViewError # 400
    MESSAGE = '400'.freeze
  end

  class Unauthorized < OneViewError # 401
    MESSAGE = '401'.freeze
  end

  class NotFound < OneViewError # 404
    MESSAGE = '404'.freeze
  end

  class RequestError < OneViewError # Other bad response codes
    MESSAGE = 'Bad response code'.freeze
  end

  class TaskError < OneViewError # Task ended in a bad state
    MESSAGE = 'Task ended in a bad state'.freeze
  end

  class InvalidFormat < OneViewError # File format is invalid
    MESSAGE = 'File format is invalid'.freeze
  end
end
