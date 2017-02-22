require_relative './../spec_helper'

# Tests for custom exception classes

classes = [
  OneviewSDK::OneViewError,
  OneviewSDK::ConnectionError,
  OneviewSDK::InvalidURL,
  OneviewSDK::InvalidClient,
  OneviewSDK::InvalidResource,
  OneviewSDK::IncompleteResource,
  OneviewSDK::MethodUnavailable,
  OneviewSDK::UnsupportedVariant,
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
    it 'behaves like the StandardError class' do
      expect { raise described_class, 'Msg' }.to raise_error(described_class, /Msg/)
    end

    it 'supports a message and data parameter' do
      e = klass.new('Msg', key: :val)
      expect(e.message).to eq('Msg')
      expect(e.data).to eq(key: :val)
    end

    it 'has a default message' do
      e = klass.new
      expect(e.message).to be_a(String)
      expect(e.message.empty?).to be false
      if klass == OneviewSDK::OneViewError
        expect(e.message).to eq('(No message)')
      else
        expect(e.message).to_not eq('(No message)')
      end
    end

    it 'has a shorthand raise! method' do
      expect { described_class.raise! 'Msg', :data }.to raise_error(described_class, /Msg/)
    end
  end
end
