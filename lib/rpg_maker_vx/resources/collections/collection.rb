module RPGMakerVX
  module Resources
    module Collections

      # Stores a set of one type of item with an ID.
      class Collection
        include Enumerable

        # Create the base collection.
        # @param type [Class] Expected type of each item.
        def initialize(type)
          @items = []
          @type  = type
        end

        # Adds an item to the collection.
        # @param item New item to add.
        # @return [self]
        # @raise [TypeError] The item being added isn't the same type as the others.
        # @note The new item's ID will be updated to be unique so that it doesn't overwrite an existing item.
        def <<(item)
          fail TypeError unless item.kind_of?(@type)
          if exist?(item.id)
            # ID is already taken, get another one.
            item.id = next_free_id
          end
          @items[item.id] = item
          self
        end

        # Iterates over each item in the collection.
        # @yieldparam item Each item in the collection.
        # @return [self]
        def each(&block)
          @items.each do |item|
            yield item unless item.nil?
          end
          self
        end

        # Retrieve the number of items in the collection.
        # @return [Fixnum]
        def length
          @items.count do |item|
            !item.nil?
          end
        end

        alias_method :size, :length

        # Retrieves an item by ID.
        # @param id [Fixnum] ID of the item to retrieve.
        # @return Item with the specified ID.
        def [](id)
          @items[id]
        end

        # Adds an item to the collection.
        # @param item New item to add.
        # @return [self]
        # @raise [TypeError] The item being added isn't the same type as the others.
        # @note If an existing item shares the same ID, it will be overwritten.
        def add(item)
          fail TypeError unless item.kind_of?(@type)
          @items[item.id] = item
        end

        # Removes an existing item from the collection.
        # @param item Item to remove.
        # @return [Boolean] +true+ if the item was found and removed, or +false+ if it didn't exist in the collection.
        def delete(item)
          if @items.include?(item)
            @items.delete_at(item.id)
            true
          else
            false
          end
        end

        # Removes an existing item from the collection by its ID.
        # @param id [Fixnum] ID of the item to remove.
        # @return [Boolean] +true+ if the item was found and removed, or +false+ if it didn't exist in the collection.
        def delete_id(id)
          existed = exist?(id)
          @items[id] = nil
          existed
        end

        # Removes all items from the collection.
        # @return [void]
        def clear
          @items = []
        end

        # Checks if an item with the specified ID exists.
        # @param id [Fixnum] ID of the item to look for.
        # @return [Boolean] +true+ if an item with the given ID exists in the collection, +false+ otherwise.
        def exist?(id)
          !@items[id].nil?
        end

        # Retrieves the next free ID.
        # This is an ID that isn't taken in the collection.
        # @return [Fixnum] Free ID.
        def next_free_id
          found = (1...@items.length).find do |i|
            @items[i].nil?
          end
          if found
            # There's an empty slot.
            found
          else
            # No empty slots, next ID is at the end.
            @items.length
          end
        end

        # Loads a collection of items from an RPG Maker VX data file.
        # @param filename [String] Path to the file to load.
        # @param type [Class] Expected type of each item.
        # @return [Collection] Set of items loaded from the file.
        def self.load(filename, type)
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
