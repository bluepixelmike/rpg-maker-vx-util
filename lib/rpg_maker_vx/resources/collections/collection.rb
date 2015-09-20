module RPGMakerVX
  module Resources
    module Collections

      # Base class for sets of identifiable database resources.
      # @abstract
      class Collection
        include Enumerable

        # Create the base collection.
        # @param type [Class] Expected type of each item.
        def initialize(type)
          @items = []
          @type  = type
        end

        # Adds an item to the collection.
        # @param value New item to add.
        # @return [self]
        # @raise [TypeError] The item being added isn't the same type as the others.
        # @note If an item already exists with the same ID, it will be overwritten.
        def <<(value)
          fail TypeError unless value.kind_of?(@type)
          @items[value.id] = value
          self
        end

        # Iterates over each item in the collection.
        # @yieldparam item Each item in the collection.
        # @return [self]
        def each(&block)
          @items.each(&block)
          self
        end

        # Retrieve the number of items in the collection.
        # @return [Fixnum]
        def length
          @items.length
        end

        alias_method :size, :length

        # Retrieves an item by ID.
        # @param id [Fixnum] ID of the item to retrieve.
        # @return Item with the specified ID.
        def [](id)
          @items[id]
        end

        # Loads a collection of items from an RPG Maker VX data file.
        # @param filename [String] Path to the file to load.
        # @param type [Class] Expected type of each item.
        # @return [Array] List of items from the file.
        def self.load_items(filename, type)
          # Load the contents of the file.
          obj = File.open(filename, 'rb') do |f|
            Marshal.load(f)
          end

          # The contents of the file must be an array.
          fail TypeError unless obj.is_a?(Array)

          # Only select the objects of the expected type.
          items = obj.select do |item|
            item.kind_of?(type)
          end

          # Add items to collection.
          collection = Collection.new(type)
          items.each do |item|
            collection << item
          end

          collection
        end

        # Saves the collection of items to an RPG Maker VX data file.
        # @param filename [String] Path to the file to save to.
        # @return [void]
        def save(filename)
          # Dump the data to the file.
          File.open(filename, 'wb') do |f|
            f.write Marshal.dump(@items)
          end
          nil
        end

      end

    end
  end
end
