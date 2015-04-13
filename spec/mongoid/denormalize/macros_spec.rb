require "spec_helper"

describe Mongoid::Denormalize::Macros do

  class TestClass
    include Mongoid::Document
    include Mongoid::Denormalize
    belongs_to :author
  end

  let(:klass) do
    TestClass
  end

  describe ".denormalize_from" do

    it "defines the macro" do
      expect(klass).to respond_to(:denormalize_from)
    end

    context "when defining denormalization" do
      before do
        klass.denormalize_from(:author, :name)
      end

      after do
        klass.fields.delete("author_fields")
        klass.denormalized_fields.delete("author")
      end

      it "adds the metadata to the klass" do
        expect(klass.denormalized_fields["author"]).to_not be_nil
      end

      it "defines the field" do
        expect(klass.fields["author_fields"]).to_not be_nil
      end

    end
  end

  describe ".denormalize_to" do

    it "defines the macro" do
      expect(klass).to respond_to(:denormalize_to)
    end

    context "when defining denormalization" do
      before do
        klass.denormalize_to(:post, :name)
      end

      it "adds the metadata to the klass" do
        expect(klass.denormalizing_fields["post"]).to_not be_nil
      end
    end
  end
end
