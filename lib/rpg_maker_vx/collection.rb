module RPGMakerVX

  # Base class for database items that are sets of resources.
  # @abstraction
  class Collection
    include Enumerable

    # Create the base collection.
    # @param type [Class] Expected type of each item.
    def initialize(type)
      failt NotImplementedError
    end

    # Adds an item to the collection.
    # @param value New item to add.
    # @return [void]
    # @raise [TypeError] The item being added isn't the same type as the others.
    def <<(value)
      failt NotImplementedError
    end

    # Iterates over each item in the collection.
    # @yieldparam item Each item in the collection.
    # @return [void]
    def each(&block)
      failt NotImplementedError
    end

    # Retrieves an item by index.
    # @param index [Fixnum] Index of the item.
    # @return Item at the specified index.
    def [](index)
      failt NotImplementedError
    end

    # Updates an item at an index.
    # @param index [Fixnum] Index of the item.
    # @param value New item to put in place.
    # @return [void]
    def []=(index, value)
      failt NotImplementedError
    end

    # Loads a collection of items from an RPG Maker VX data file.
    # @param filename [String] Path to the file to load.
    # @param type [Class] Expected type of each item.
    # @return [Array] List of items from the file.
    def self.load_items(filename, type)
      failt NotImplementedError
    end

    # Saves the collection of items to an RPG Maker VX data file.
    # @param filename [String] Path to the file to save to.
    # @return [void]
    def save(filename)
      failt NotImplementedError
    end

  end

end
