module PuppetDB
  module Model
    class Resource < Base
      # Get object from Puppet DB
      #
      # Pass a list of key: val arguments as filters for the query.
      #
      # @param regexp [Boolean] Set this to true for regular expression matching
      #
      # @example Get exported Resources
      #   PuppetDB::Model::Resource.get(exported: true)
      #
      # @example Regexp search in title
      #   PuppetDB::Model::Resource.get(title: '^foo.*bar', regexp: true)
      def self.get(**arguments)
        super object: 'resources', **arguments
      end
    end
  end
end
