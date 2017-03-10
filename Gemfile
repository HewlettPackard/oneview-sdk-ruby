source 'https://rubygems.org'
gemspec

begin
  if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('2.2.5')
    group :development do
      gem 'guard-rake'
      gem 'guard-rspec'
      gem 'guard-rubocop'
    end
  end
rescue StandardError
  "no big deal; just don't use guard"
end
