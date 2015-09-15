require_relative 'database'

module RPGMakerVX

  # Contains methods for accessing all information in an RPG Maker VX project.
  class Project

    # Provides access to all of the data-driven objects.
    # Practically everything is located here except for the maps and resource files.
    # @return [Database]
    attr_reader :database

    # Creates a new, empty RPG Maker VX project.
    # @param name [String] Name of the project.
    # @note The project will not be created on disk until +#save+ is called.
    def initialize(name)
      fail NotImplementedError
    end

    # Saves the entire project to a directory.
    # @param path [String] Path to the directory to save the project files to.
    # @return [void]
    def save(path)
      fail NotImplementedError
    end

    # Loads an RPG Maker VX project from disk.
    # @param path [String] Path to the directory containing the project files.
    # @return [Project]
    def self.load(path)
      fail NotImplementedError
    end

  end

end
