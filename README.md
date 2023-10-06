# Model for PuppetDB queries

This library provides classes for retreiving objects from the puppet DB

## Example usage

```ruby
require 'puppetdb/model'

PuppetDB::Model::Base.client = PuppetDB::Client.new(server: 'puppetserver.daho.im')

# get nodes reporting to production environment
PuppetDB::Model::Nodes.get(report_environment: 'production').each { |node| puts node.certname }

# get Resources exported by a node
PuppetDB::Model::Resource.get(exported: true, certname: 'dbserver.daho.im').each { |r| puts r.title }

# get Resources from node with regular expressions
PuppetDB::Model::Resource.get(certname: 'db.*daho.im', regexp: true).each { |r| puts r.title }

# get all exporte Resources
PuppetDB::Model::Resource.get(exported: true)

```
