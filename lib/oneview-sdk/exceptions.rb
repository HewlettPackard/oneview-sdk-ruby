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

# Contains all the custom Exception classes
module OneviewSDK
  class ConnectionError < StandardError # Cannot connect to client/resource
  end

  class InvalidURL < StandardError # URL is invalid
  end

  class InvalidClient < StandardError # Client configuration is invalid
  end

  class InvalidResource < StandardError # Failed resource validations
  end

  class IncompleteResource < StandardError # Missing required resource data to complete action
  end

  class MethodUnavailable < StandardError # Resource does not support this method
  end

  class UnsupportedVersion < StandardError # Resource not supported on this API version
  end

  class InvalidRequest < StandardError # Could not make request
  end

  class BadRequest < StandardError # 400
  end

  class Unauthorized < StandardError # 401
  end

  class NotFound < StandardError # 404
  end

  class RequestError < StandardError # Other bad response codes
  end

  class TaskError < StandardError # Task ended in a bad state
  end

  class InvalidFormat < StandardError # File format is invalid
  end
end
