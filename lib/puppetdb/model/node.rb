module PuppetDB
  module Model
    # Parses Nodes from Puppetdb
    #
    # All attributes returned by for the node from the puppetdb will be added as getter to the object
    #
    # @example print uptime for hardware
    #   servers =  PuppetDB::Model::Node.all_hardware_servers.each do |server|
    #     puts server.certname
    #     puts server.uptime
    #   end
    #
    # @example get nodes by fact
    #   PuppetDB::Model::Node.by_fact({'custom_fact' => 'FooBar'}).each do |server|
    #     puts server.certname
    #   end
    class Node < Base

      # parses the data returned by a puppetdb query of 'node' objects and parses it
      # @param attributes The data returned by a PuppetDB query
      def initialize(attributes)
        @facts = {}
        attributes[:environment] = attributes[:catalog_environment]
        super(attributes)
      end

      # Get object from Puppet DB
      #
      # Pass a list of key: val arguments as filters for the query.
      #
      # @param regexp [Boolean] Set this to true for regular expression matching
      #
      # @example Get nodes in environment
      #   PuppetDB::Model::Nodes.get(report_environment: production)
      #
      # @example Regexp search in title
      #   PuppetDB::Model::Node.get(title: '^foo.*bar', regexp: true)
      def self.get(**arguments)
        super object: 'nodes', **arguments
      end

      # get nodes by name
      #
      # @param fqdn [String] FQDN to search
      # @param regexp [Boolean] Defines if the matching is done with regexp. Default : False
      def by_name(fqdn, regexp: false)
        # use strict comparator by default, because this is less performance intensive
        comparator = regexp ? '~' : '='

        query("node { certname #{comparator} #{fqdn.dump}}")
      end

      # get nodes with a specific class
      #
      # @param classname [String] The name of the Class to search the Nodes
      # @example Nodes with 'Environment' class loaded
      #   PuppetDB::Model::Node.by_class('Environment').each do |server|
      #     puts server.uptime
      #   end
      def self.by_class(classname)
        query("nodes { resources { type = 'Class' and title = #{classname.dump} }}")
      end

      # get nodes by matching facts
      #
      # @param facts [Hash] name value pair for matching facts. Subfacts can be separated by period(.)
      # @param regexp [Boolean] Defines if the matching is done with regexp. Default : False
      def self.by_fact(facts, regexp: false)
        # use strict comparator by default, because this is less performance intensive
        comparator = regexp ? '~' : '='

        filters = facts.map do |key, value|
          # Boolean values doesn't support regexp operator(~) and must not be escaped
          if [TrueClass, FalseClass].include?(value.class)
            "facts.#{key} = #{value}"
          else
            "facts.#{key} #{comparator} #{value.to_s.dump}"
          end
        end

        query("nodes { inventory { #{filters.join(' and ')} }}")
      end

      # get all hardware servers
      def self.all_hardware_servers
        query("nodes { inventory { facts.virtual = 'physical'  and facts.dmi.chassis.type != 'Desktop' }}")
      end

      # get all nodes
      def self.all
        query('nodes {}')
      end

      # get a fact associated with this node
      #
      # @example get dmi info from host
      #   Bios = PuppetDB::Model::Node.by_name.fact('dmi.bios.).value
      def fact(name)
        @facts[name] ||= Fact.new(certname: certname, name: name)
      end

      # get the bios version
      def bios_version
        fact('dmi.bios.version').value
      end

      # get the uptime
      def uptime
        fact('system_uptime.uptime').value
      end
    end
  end
end
