require 'rpg_maker_rgss3'
require_relative 'resources/collection'

module RPGMakerVX

  # Collects all of the data-driven objects into a single interface.
  class Database

    # File extension for all data types.
    DATA_FILE_EXTENSION = '.rvdata2'.freeze

    # Names of each collection file.
    COLLECTION_FILE_NAMES = {
        :actors        => ('Actors'       + DATA_FILE_EXTENSION).freeze,
        :classes       => ('Classes'      + DATA_FILE_EXTENSION).freeze,
        :skills        => ('Skills'       + DATA_FILE_EXTENSION).freeze,
        :items         => ('Items'        + DATA_FILE_EXTENSION).freeze,
        :weapons       => ('Weapons'      + DATA_FILE_EXTENSION).freeze,
        :armors        => ('Armors'       + DATA_FILE_EXTENSION).freeze,
        :enemies       => ('Enemies'      + DATA_FILE_EXTENSION).freeze,
        :troops        => ('Troops'       + DATA_FILE_EXTENSION).freeze,
        :states        => ('States'       + DATA_FILE_EXTENSION).freeze,
        :animations    => ('Animations'   + DATA_FILE_EXTENSION).freeze,
        :tilesets      => ('Tilesets'     + DATA_FILE_EXTENSION).freeze,
        :common_events => ('CommonEvents' + DATA_FILE_EXTENSION).freeze
    }.freeze

    COLLECTION_TYPE_MAP = {
        :actors        => ::RPG::Actor,
        :classes       => ::RPG::Class,
        :skills        => ::RPG::Skill,
        :items         => ::RPG::Item,
        :weapons       => ::RPG::Weapon,
        :armors        => ::RPG::Armor,
        :enemies       => ::RPG::Enemy,
        :troops        => ::RPG::Troop,
        :states        => ::RPG::State,
        :animations    => ::RPG::Animation,
        :tilesets      => ::RPG::Tileset,
        :common_events => ::RPG::CommonEvent
    }.freeze

    # Name of the system file.
    SYSTEM_FILE_NAME = ('System' + DATA_FILE_EXTENSION).freeze

    # @!attribute [r] actors
    # Provides access to actor information.
    # @return [Resources::Collection<::RPG::Actor>]
    def actors
      @collections[:actors]
    end

    # @!attribute [r] classes
    # Provides access to class information.
    # @return [Resources::Collection<::RPG::Class>]
    def classes
      @collections[:classes]
    end

    # @!attribute [r] skills
    # Provides access to skill information.
    # @return [Resources::Collection<::RPG::Skill>]
    def skills
      @collections[:skills]
    end

    # @!attribute [r] items
    # Provides access to item information.
    # @return [Resources::Collection<::RPG::Item>]
    def items
      @collections[:items]
    end

    # @!attribute [r] weapons
    # Provides access to weapon information.
    # @return [Resources::Collection<::RPG::Weapon>]
    def weapons
      @collections[:weapons]
    end

    # @!attribute [r] armors
    # Provides access to armor information.
    # @return [Resources::Collection<::RPG::Armor>]
    def armors
      @collections[:armors]
    end

    # @!attribute [r] enemies
    # Provides access to enemy information.
    # @return [Resources::Collection<::RPG::Enemy>]
    def enemies
      @collections[:enemies]
    end

    # @!attribute [r] troops
    # Provides access to troop information.
    # @return [Resources::Collection<::RPG::Troop>]
    def troops
      @collections[:troops]
    end

    # @!attribute [r] states
    # Provides access to state information.
    # @return [Resources::Collection<::RPG::State>]
    def states
      @collections[:states]
    end

    # @!attribute [r] animations
    # Provides access to animation information.
    # @return [Resources::Collection<::RPG::Animation>]
    def animations
      @collections[:animations]
    end

    # @!attribute [r] tilesets
    # Provides access to tileset information.
    # @return [Resources::Collection<::RPG::Tileset>]
    def tilesets
      @collections[:tilesets]
    end

    # @!attribute [r] common_events
    # Provides access to common event information.
    # @return [Resources::Collection<::RPG::CommonEvent>]
    def common_events
      @collections[:common_events]
    end

    # Provides access to system and term information.
    # @return [::RPG::System]
    attr_reader :system

    # Creates an database with pre-populated resources.
    # @param resources [Hash<Symbol => [Resources::Collection, ::RPG::System]>]
    def initialize(resources = {})
      @collections = Hash[COLLECTION_TYPE_MAP.map do |key, item_type|
                            collection = resources[key] || Resources::Collection.new(item_type)
                            [key, collection]
                          end]
      @system = resources[:system]
    end

    # Loads the database components of a project.
    # @param path [String] Path to the 'Data' directory in the project.
    # @return [Database]
    def self.load(path)
      # Generate file paths for each collection.
      resource_paths = Hash[COLLECTION_FILE_NAMES.map do |key, file_name|
                              file_path = File.join(path, file_name)
                              [key, file_path]
                            end]

      # Load the collections.
      resources = Hash[resource_paths.map do |key, file_path|
                         item_type  = COLLECTION_TYPE_MAP[key]
                         collection = Resources::Collection.load(file_path, item_type)
                         [key, collection]
                       end]

      # Load the system data.
      sys_path = File.join(path, SYSTEM_FILE_NAME)
      sys = File.open(sys_path, 'rb') do |f|
        Marshal.load(f)
      end
      fail TypeError unless sys.kind_of?(::RPG::System)
      resources[:system] = sys

      # Create the database.
      Database.new(resources)
    end

    # Saves all contents of the database to a project.
    # @param path [String] Path to the 'Data' directory in the project.
    # @return [void]
    def save(path)
      # Gather up the collections and map their content to a file.
      save_map = Hash[@collections.map do |key, collection|
                        file_name = COLLECTION_FILE_NAMES[key]
                        file_path = File.join(path, file_name)
                        [file_path, collection]
                      end]

      # Add system data.
      sys_path = File.join(path, SYSTEM_FILE_NAME)
      save_map[sys_path] = @system

      # Save each resource to its file.
      save_map.each do |file_path, resource|
        resource.save(file_path)
      end
    end

  end

end
