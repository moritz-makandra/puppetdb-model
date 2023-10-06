module PuppetDB
  module Model
    class Inventory < Base

      # Get object from Puppet DB
      #
      # Pass a list of key: val arguments as filters for the query.
      #
      # @param regexp [Boolean] Set this to true for regular expression matching
      #
      # @example Get by certname
      #   PuppetDB::Model::Resource.get(certname: 'daho.im')
      # @example Regexp search in title
      #   PuppetDB::Model::Resource.get(title: '^foo.*bar', regexp: true)
      def self.get(**arguments)
        super object: 'inventory', **arguments
      end
    end
  end
end
