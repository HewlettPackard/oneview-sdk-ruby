source 'https://rubygems.org'
ruby RUBY_VERSION
gemspec

begin
  if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('2.3.1')
    group :development do
      gem 'guard-rspec'
      gem 'guard-rubocop'
    end
  end
rescue StandardError
  "no big deal; just don't use guard"
end
