module Mongoid
  module Denormalize
    class Metadata < Hash

      def initialize(properties = {})
        merge!(properties)
      end

      def fields
        return self[:fields] unless self[:fields].empty?

        klass.fields.keys.reject{|key| key == "_id"}
      end

      def denormalized_hash(instance)
        hash = {}
        fields.each do |field|
          hash[field] = instance.send(field)
        end
        hash
      end

      def klass
        self[:klass]
      end

    end
  end
end
