lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'puppetdb/model/version'

Gem::Specification.new do |spec|
  spec.name        = 'puppetdb-model'
  spec.version     =  PuppetDB::Model::VERSION
  spec.summary     = 'Provides objects for PuppetDB'
  spec.description = 'Provides objects for PuppetDB'
  spec.authors     = ['Moritz Kraus']
  spec.email       = 'moritz.kraus@makandra.de'
  spec.homepage = 'https://makandra.com'
  spec.license = 'MIT'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").select {|f| f.match(/md$|^lib/) }
  end

  spec.require_paths = ['lib']
  spec.metadata['rubygems_mfa_required'] = 'true'
end
