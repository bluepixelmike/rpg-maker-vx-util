module RPGMakerVX
  module Resources
    module Collections

      # Base class for database items that are sets of resources.
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
        def <<(value)
          fail TypeError unless value.is_a?(@type)
          @items << value
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

        # Retrieves an item by index.
        # @param index [Fixnum] Index of the item.
        # @return Item at the specified index.
        def [](index)
          @items[index]
        end

        # Updates an item at an index.
        # @param index [Fixnum] Index of the item.
        # @param value New item to put in place.
        # @return [void]
        def []=(index, value)
          fail TypeError unless value.is_a?(@type)
          @items[index] = value
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
          # This also removes nil-values, especially the leading one.
          obj.select do |item|
            item.is_a?(type)
          end
        end

        # Saves the collection of items to an RPG Maker VX data file.
        # @param filename [String] Path to the file to save to.
        # @return [void]
        def save(filename)
          # Create the list to marshal.
          # The first item is always nil.
          list = [nil]
          list.concat(@items)

          # Dump the data to the file.
          File.open(filename, 'wb') do |f|
            f.write Marshal.dump(list)
          end

          nil
        end

      end

    end
  end
end
