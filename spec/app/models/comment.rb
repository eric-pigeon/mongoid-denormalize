class Comment
  include Mongoid::Document
  include Mongoid::Denormalize

  field :body, type: String
  belongs_to :author
  embedded_in :post

end
