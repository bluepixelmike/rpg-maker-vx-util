require 'rpg_maker_rgss3'
require_relative 'collection'

module RPGMakerVX
  module Resources
    module Collections

      # Set of class information.
      class ClassCollection < Collection

        # Creates an empty collection of classes.
        def initialize
          super(::RPG::Class)
        end

        # Loads a set of classes from a file.
        # @param filename [String] Path to the classes file.
        # @return [ClassCollection]
        def self.load(filename)
          items = load_items(filename, ::RPG::Class)
          collection = ClassCollection.new
          items.each do |item|
            collection << item
          end
          collection
        end

      end

    end
  end
end
