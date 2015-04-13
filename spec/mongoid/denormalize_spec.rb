require "spec_helper"

describe Mongoid::Denormalize do

  context "when using setter" do

    let(:author) do
      Author.new(name:"John Smith")
    end

    let(:post) do
      Post.new(title:"Learn you some ruby",author:author)
    end

    it "sets fields in hash" do
      expect(post.author_fields["name"]).to eq("John Smith")
    end
  end

  context "when using builder" do

    let(:post) do
      Post.new(title:"Learn you some ruby")
    end

    before do
      post.build_author({name: "John Smith"})
    end

    it "sets fields in hash" do
      expect(post.author_fields["name"]).to eq("John Smith")
    end
  end

  context "when using create" do

    let(:post) do
      Post.new(title:"Learn you some ruby")
    end

    before do
      post.create_author({name: "John Smith"})
    end

    it "sets fields in hash" do
      expect(post.author_fields["name"]).to eq("John Smith")
    end
  end

  context "when saving a denormalizing document" do

    let(:author) do
      Author.create(name:"John Smith")
    end

    let(:post) do
      Post.where(title:"Learn you some ruby").first
    end

    before do
      Post.create!(title:"Learn you some ruby",author:author)
      author.name = "Greg Smith"
      author.save!
    end

    it "should push updates to denormalize documents" do
      expect(post.author_fields["name"]).to eq("Greg Smith")
    end
  end
end
