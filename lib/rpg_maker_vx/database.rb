require_relative 'resources/collections'

module RPGMakerVX

  # Collects all of the data-driven objects into a single interface.
  class Database

    # File extension for all data types.
    DATA_FILE_EXTENSION = '.rvdata2'

    # Name of the actors file.
    ACTORS_FILE = 'Actors' + DATA_FILE_EXTENSION

    # Name of the classes file.
    CLASSES_FILE = 'Classes' + DATA_FILE_EXTENSION

    # Name of the skills file.
    SKILLS_FILE = 'Skills' + DATA_FILE_EXTENSION

    # Name of the items file.
    ITEMS_FILE = 'Items' + DATA_FILE_EXTENSION

    # Name of the weapons file.
    WEAPONS_FILE = 'Weapons' + DATA_FILE_EXTENSION

    # Name of the armors file.
    ARMORS_FILE = 'Armors' + DATA_FILE_EXTENSION

    # Name of the enemies file.
    ENEMIES_FILE = 'Enemies' + DATA_FILE_EXTENSION

    # Name of the troops file.
    TROOPS_FILE = 'Troops' + DATA_FILE_EXTENSION

    # Name of the states file.
    STATES_FILE = 'States' + DATA_FILE_EXTENSION

    # Name of the animations file.
    ANIMATIONS_FILE = 'Animations' + DATA_FILE_EXTENSION

    # Name of the tilsets file.
    TILESETS_FILE = 'Tilesets' + DATA_FILE_EXTENSION

    # Name of the common events file.
    COMMON_EVENTS_FILE = 'CommonEvents' + DATA_FILE_EXTENSION

    # Provides access to actor information.
    # @return [Resources::Collections::ActorCollection]
    attr_reader :actors

    # Provides access to class information.
    # @return [Resources::Collections::ClassCollection]
    attr_reader :classes

    # Provides access to skill information.
    # @return [Resources::Collections::SkillCollection]
    attr_reader :skills

    # Provides access to item information.
    # @return [Resources::Collections::ItemCollection]
    attr_reader :items

    # Provides access to weapon information.
    # @return [Resources::Collections::WeaponCollection]
    attr_reader :weapons

    # Provides access to armor information.
    # @return [Resources::Collections::ArmorCollection]
    attr_reader :armors

    # Provides access to enemy information.
    # @return [Resources::Collections::EnemyCollection]
    attr_reader :enemies

    # Provides access to troop information.
    # @return [Resources::Collections::TroopCollection]
    attr_reader :troops

    # Provides access to state information.
    # @return [Resources::Collections::StateCollection]
    attr_reader :states

    # Provides access to animation information.
    # @return [Resources::Collections::AnimationCollection]
    attr_reader :animations

    # Provides access to tileset information.
    # @return [Resources::Collections::TilesetCollection]
    attr_reader :tilesets

    # Provides access to common event information.
    # @return [Resources::Collections::CommonEventCollection]
    attr_reader :common_events

    attr_reader :system

    attr_reader :terms

    # Creates an database with pre-populated resources.
    # @param resources [Hash<Symbol => Resources::Collections::Collection>]
    def initialize(resources)
      @actors        = resources[:actors]        || Resources::Collections::ActorCollection.new
      @classes       = resources[:classes]       || Resources::Collections::ClassCollection.new
      @skills        = resources[:skills]        || Resources::Collections::SkillCollection.new
      @items         = resources[:items]         || Resources::Collections::ItemCollection.new
      @weapons       = resources[:weapons]       || Resources::Collections::WeaponCollection.new
      @armors        = resources[:armors]        || Resources::Collections::ArmorCollection.new
      @enemies       = resources[:enemies]       || Resources::Collections::EnemyCollection.new
      @troops        = resources[:troops]        || Resources::Collections::TroopCollection.new
      @states        = resources[:states]        || Resources::Collections::StateCollection.new
      @animations    = resources[:animations]    || Resources::Collections::AnimationCollection.new
      @tilesets      = resources[:tilesets]      || Resources::Collections::TilesetCollection.new
      @common_events = resources[:common_events] || Resources::Collections::CommonEventCollection.new
    end

    # Loads the database components of a project.
    # @param path [String] Path to the 'Data' directory in the project.
    # @return [Database]
    def self.load(path)
      # Generate filepaths for each resource.
      resource_paths = {
          :actors        => File.join(path, ACTORS_FILE),
          :classes       => File.join(path, CLASSES_FILE),
          :skills        => File.join(path, SKILLS_FILE),
          :items         => File.join(path, ITEMS_FILE),
          :weapons       => File.join(path, WEAPONS_FILE),
          :armors        => File.join(path, ARMORS_FILE),
          :enemies       => File.join(path, ENEMIES_FILE),
          :troops        => File.join(path, TROOPS_FILE),
          :states        => File.join(path, STATES_FILE),
          :animations    => File.join(path, ANIMATIONS_FILE),
          :tilesets      => File.join(path, TILESETS_FILE),
          :common_events => File.join(path, COMMON_EVENTS_FILE)
      }

      # Load each resource.
      resources = {
          :actors        => Resources::Collections::ActorCollection.load(resource_paths[:actors]),
          :classes       => Resources::Collections::ClassCollection.load(resource_paths[:classes]),
          :skills        => Resources::Collections::SkillCollection.load(resource_paths[:skills]),
          :items         => Resources::Collections::ItemCollection.load(resource_paths[:items]),
          :weapons       => Resources::Collections::WeaponCollection.load(resource_paths[:weapons]),
          :armors        => Resources::Collections::ArmorCollection.load(resource_paths[:armors]),
          :enemies       => Resources::Collections::EnemyCollection.load(resource_paths[:enemies]),
          :troops        => Resources::Collections::TroopCollection.load(resource_paths[:troops]),
          :states        => Resources::Collections::StateCollection.load(resource_paths[:states]),
          :animations    => Resources::Collections::AnimationCollection.load(resource_paths[:animations]),
          :tilesets      => Resources::Collections::TilesetCollection.load(resource_paths[:tilesets]),
          :common_events => Resources::Collections::CommonEventCollection.load(resource_paths[:common_events])
      }

      Database.new(resources)
    end

    # Saves all contents of the database to a project.
    # @param path [String] Path to the 'Data' directory in the project.
    # @return [void]
    def save(path)
      {
          File.join(path, ACTORS_FILE)        => @actors,
          File.join(path, CLASSES_FILE)       => @classes,
          File.join(path, SKILLS_FILE)        => @skills,
          File.join(path, ITEMS_FILE)         => @items,
          File.join(path, WEAPONS_FILE)       => @weapons,
          File.join(path, ARMORS_FILE)        => @armors,
          File.join(path, ENEMIES_FILE)       => @enemies,
          File.join(path, TROOPS_FILE)        => @troops,
          File.join(path, STATES_FILE)        => @states,
          File.join(path, ANIMATIONS_FILE)    => @animations,
          File.join(path, TILESETS_FILE)      => @tilesets,
          File.join(path, COMMON_EVENTS_FILE) => @common_events
      }.each do |filepath, resource|
        resource.save(filepath)
      end
    end

  end

end
