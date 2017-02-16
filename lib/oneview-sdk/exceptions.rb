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
  class OVError < ::StandardError
    attr_accessor :data

    def initialize(msg = nil, data = nil)
      @data = data
      super(msg)
    end

    # Shorthand method to raise an error.
    # @example
    #   OneviewSDK::OVError.raise! 'Message', { data: 'stuff' }
    def self.raise!(msg = nil, data = nil)
      raise new(msg, data)
    end
  end

  class ConnectionError < OVError # Cannot connect to client/resource
  end

  class InvalidURL < OVError # URL is invalid
  end

  class InvalidClient < OVError # Client configuration is invalid
  end

  class InvalidResource < OVError # Failed resource validations
  end

  class IncompleteResource < OVError # Missing required resource data to complete action
  end

  class MethodUnavailable < OVError # Resource does not support this method
  end

  class UnsupportedVariant < OVError # Variant is not supported
  end

  class UnsupportedVersion < OVError # Resource not supported on this API version
  end

  class InvalidRequest < OVError # Could not make request
  end

  class BadRequest < OVError # 400
  end

  class Unauthorized < OVError # 401
  end

  class NotFound < OVError # 404
  end

  class RequestError < OVError # Other bad response codes
  end

  class TaskError < OVError # Task ended in a bad state
  end

  class InvalidFormat < OVError # File format is invalid
  end
end
