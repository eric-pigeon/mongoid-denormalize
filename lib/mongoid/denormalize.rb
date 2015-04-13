require "mongoid/denormalize/version"
require "mongoid/denormalize/macros"

module Mongoid
  module Denormalize
    extend ActiveSupport::Concern

    include Macros
  end
end
