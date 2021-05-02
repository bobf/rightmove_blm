# frozen_string_literal: true

require 'bundler/setup'
require 'devpack'
require 'rightmove_blm'

require 'rspec/file_fixtures'
require 'rspec/its'

RSpec.configure do |config|
  config.example_status_persistence_file_path = '.rspec_status'
  config.disable_monkey_patching!
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
