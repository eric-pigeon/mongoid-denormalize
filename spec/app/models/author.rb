class Author
  include Mongoid::Document
  include Mongoid::Denormalize

  field :name, type: String

  has_many :posts

  denormalize_to :posts
end
