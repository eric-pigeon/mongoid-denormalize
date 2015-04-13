class Post
  include Mongoid::Document
  include Mongoid::Denormalize

  belongs_to :author
  embeds_many :comments

  field :title, type: String
  denormalize_from :author

end
