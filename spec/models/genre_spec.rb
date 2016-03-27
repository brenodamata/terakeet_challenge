require "rails_helper"

RSpec.describe Genre, :type => :model do
  it "is valid" do
    gen = build :genre
    expect(gen).to be_valid
  end
  it "is invalid without a name" do
    gen = Genre.new
    expect(gen).to be_invalid
    expect(gen.errors[:name]).to include("can't be blank")
  end
  it "has unique name" do
    Genre.create(name: "Novel")
    gen = Genre.new(name: "Novel")
    expect(gen).to be_invalid
  end
end
