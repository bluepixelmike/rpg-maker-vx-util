require 'rpg_maker_rgss3'
require_relative 'collection'

module RPGMakerVX

  # Set of actor information.
  class ActorCollection < Collection

    # Creates an empty collection of actors.
    def initialize
      super(RPG::Actor)
    end

    # Loads a set of actors from a file.
    # @param filename [String] Path to the actors file.
    # @return [ActorsCollection]
    def self.load(filename)
      items = load_items(filename, RPG::Actor)
      collection = ActorCollection.new
      items.each do |item|
        collection << item
      end
      collection
    end

  end

end
