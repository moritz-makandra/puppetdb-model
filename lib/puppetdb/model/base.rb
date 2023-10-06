module PuppetDB
  module Model
    class Base

      # Parses objects from PuppetDB
      #
      # The parser expects an array of hashes where each item in the array is parsed into a separate object.
      # The keys of the hashes are turned into getters of the resulting object returning the associated values.
      def initialize(attributes)
        attributes.each do |attribute_name, attribute_value|
          # this will create an `attr_reader` for each attribute passed
          self.class.send(:define_method, attribute_name.to_sym) do
            instance_variable_get("@#{attribute_name}")
          end

          # set an instance variable for each attribute like `@certname`
          instance_variable_set("@#{attribute_name}", attribute_value)
        end
      end

      # Saves the PuppetDB client into a class variable which is shared among all object created from this class
      #
      # @param client [PuppetDB::Client]
      def self.client=(client)
        # rubocop:disable Style/ClassVars
        @@client = client
        # rubocop:enable Style/ClassVars
      end

      # Return the PuppetDB Client
      #
      # @return [PuppetDB::Client] instance
      def self.client
        @@client
      end

      # Query the Puppet DB an build new Objects from the result
      #
      # @param query [String] The PQL query to execute
      def self.query(query)
        request(query).map { |object| new(object) }
      end

      def self.request(query)
        client.request('', query).data
      end

      # Get object from Puppet DB
      #
      # Pass a list of key: val arguments as filters for the query.
      #
      # @param regexp [Boolean] Set this to true for regular expression matching
      # @param object [String] The name of the object from The PuppetDB
      #
      # @example Get exported Resources
      #   PuppetDB::Model::Base.get(object: 'resources', exported: true)
      # @example Regexp search Resources by title
      #   PuppetDB::Model::Resource.get(object: 'resources', title: '^foo.*bar', regexp: true)
      def self.get(object:, regexp: false, **filters)
        # use strict comparator by default, because this is less performance intensive
        comparator = regexp ? '~' : '='

        filters = filters.map do |key, value|
          # Boolean values doesn't support regexp operator(~) and must not be escaped
          if [TrueClass, FalseClass].include?(value.class)
            "#{key} = #{value}"
          else
            "#{key} #{comparator} #{value.to_s.dump}"
          end
        end

        query("#{object} {#{filters.join(' and ')}}")
      end
    end
  end
end
