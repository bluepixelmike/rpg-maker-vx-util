require 'rpg_maker_rgss3'
require_relative 'collection'

module RPGMakerVX
  module Resources
    module Collections

      # Set of item information.
      class ItemCollection < Collection

        # Creates an empty collection of items.
        def initialize
          super(::RPG::Item)
        end

        # Loads a set of items from a file.
        # @param filename [String] Path to the items file.
        # @return [ItemCollection]
        def self.load(filename)
          items = load_items(filename, ::RPG::Item)
          collection = ItemCollection.new
          items.each do |item|
            collection << item
          end
          collection
        end

      end

    end
  end
end
