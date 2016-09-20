require_relative './../spec_helper'

# Tests for custom exception classes

classes = [
  OneviewSDK::ConnectionError,
  OneviewSDK::InvalidURL,
  OneviewSDK::InvalidClient,
  OneviewSDK::InvalidResource,
  OneviewSDK::IncompleteResource,
  OneviewSDK::MethodUnavailable,
  OneviewSDK::UnsupportedVersion,
  OneviewSDK::InvalidRequest,
  OneviewSDK::BadRequest,
  OneviewSDK::Unauthorized,
  OneviewSDK::NotFound,
  OneviewSDK::RequestError,
  OneviewSDK::TaskError,
  OneviewSDK::InvalidFormat
]
classes.each do |klass|
  RSpec.describe klass do
    it 'exists and supports a message parameter' do
      expect { raise described_class, 'Msg' }.to raise_error(described_class, /Msg/)
    end
  end
end
