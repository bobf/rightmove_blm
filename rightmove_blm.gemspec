# frozen_string_literal: true

require_relative 'lib/rightmove_blm/version'

Gem::Specification.new do |spec|
  spec.name = 'rightmove_blm'
  spec.version = RightmoveBLM::VERSION
  spec.authors = ['Bob Farrell']
  spec.email = 'git@bob.frl'

  spec.summary
  spec.description = 'Parse and generate Rightmove BLM files'
  spec.required_ruby_version = '>= 2.7'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.homepage = 'http://github.com/robertmay/blm'
  spec.licenses = ['MIT']
  spec.require_paths = ['lib']
  spec.summary = 'A parser for the Rightmove .blm format'
  spec.metadata['rubygems_mfa_required'] = 'true'
end
