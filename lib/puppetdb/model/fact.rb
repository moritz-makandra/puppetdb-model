module PuppetDB
  module Model
    # Parses fact_contents from PuppetDB
    #
    # All attributes retreived from the puppetdb be added as getter to the object
    class Fact < Base
      attr_reader :name

      def initialize(attributes)
        super(**attributes)
        self.name = attributes[:name]
      end

      # set the name of the fact
      #
      # @param name [String] accepts fact name where subfacts can be separated by period(.)
      def name=(name)
        @path ||= name.split('.')
        @name = name
      end

      # gets the value for the fact and certname combination
      #
      # The value of value is lazy loaded on call and saved in the object
      def value
        pql = "fact_contents[value] { certname = '#{certname}' and path = #{@path}}"
        @value ||= self.class.request(pql).first.values
      end

      def to_s
        value
      end
    end
  end
end
