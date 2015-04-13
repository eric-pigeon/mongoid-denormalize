require "mongoid/denormalize/metadata"

module Mongoid
  module Denormalize
    module Macros
      extend ActiveSupport::Concern

      included do
        cattr_accessor :denormalized_fields
        cattr_accessor :denormalizing_fields
        self.denormalized_fields  = {}
        self.denormalizing_fields = {}
      end

      module ClassMethods
        def denormalize_from(name, *args)
          fields, *options = args
          fields = Array(fields)

          meta = Metadata.new({
            klass: relations[name.to_s].klass,
            fields: fields,
            options: options
          })
          self.denormalized_fields.merge!(name.to_s => meta)
          field_suffix = "_fields"
          field :"#{name}#{field_suffix}", type: Hash, default: {}

          alias_method :"mongoid_#{name}=", :"#{name}="

          re_define_method(:"#{name}=") do |attrs|
            meta = denormalized_fields[name.to_s]
            denormalized_attributes = meta.denormalized_hash attrs

            send(:"#{name}#{field_suffix}=", denormalized_attributes)
            send(:"mongoid_#{name}=", attrs)
          end

        end

        def denormalize_to(name, *args)
          fields, *options = args
          fields = Array(fields)
          meta = Metadata.new({
            klass: self,
            fields: fields,
            options: options
          })
          self.denormalizing_fields.merge!(name.to_s => meta)
          after_save  :propagate_fields
        end

      end

      private

      def propagate_fields
        denormalizing_fields.each do |relation, meta|
          denormalized_hash = meta.denormalized_hash(self)
          self.send(relation).set(author_fields: denormalized_hash)
        end
      end

    end
  end
end
