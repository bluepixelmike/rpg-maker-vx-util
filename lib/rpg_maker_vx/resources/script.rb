module RPGMakerVX
  module Resources

    # Single entry in the collection of scripts.
    class Script

      # Visible name of the script.
      # @return [String]
      attr_accessor :name

      # Ruby code as a raw string.
      # @return [String]
      attr_accessor :contents

      # Creates a script.
      # @param name [String] Visible name of the script.
      # @param contents [String] Ruby code as a raw string.
      def initialize(name = '', contents = '')
        @name     = name
        @contents = contents
      end

    end

  end
end
