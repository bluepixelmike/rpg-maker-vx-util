require 'rpg_maker_rgss3'
require_relative 'collection'

module RPGMakerVX
  module Resources
    module Collections

      # Set of common event information.
      class CommonEventCollection < Collection

        # Creates an empty collection of common events.
        def initialize
          super(::RPG::CommonEvent)
        end

        # Loads a set of common events from a file.
        # @param filename [String] Path to the common events file.
        # @return [CommonEventCollection]
        def self.load(filename)
          items = load_items(filename, ::RPG::CommonEvent)
          collection = CommonEventCollection.new
          items.each do |item|
            collection << item
          end
          collection
        end

      end

    end
  end
end
