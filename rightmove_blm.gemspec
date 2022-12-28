# frozen_string_literal: true

require_relative 'lib/rightmove_blm/version'

Gem::Specification.new do |spec|
  spec.name = 'rightmove_blm'
  spec.version = RightmoveBLM::VERSION
  spec.authors = ['Robert Farrell']
  spec.email = 'git@bob.frl'

  spec.summary
  spec.description = 'Parse and generate Rightmove BLM files'
  spec.required_ruby_version = '~> 3.1.3'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.homepage = 'http://github.com/robertmay/blm'
  spec.licenses = ['MIT']
  spec.require_paths = ['lib']
  spec.rubygems_version = '1.3.7'
  spec.summary = 'A parser for the Rightmove .blm format'
  spec.test_files = [
    'spec/blm_spec.rb',
    'spec/spec_helper.rb'
  ]
end
