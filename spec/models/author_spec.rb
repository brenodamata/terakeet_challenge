require "rails_helper"

RSpec.describe Author, :type => :model do
  it "is valid" do
    author = build :author
    expect(author).to be_valid
  end
  it "is invalid without a first name" do
    author = build :author, :no_first_name
    expect(author).to be_invalid
    expect(author.errors[:first_name]).to include("can't be blank")
  end
  it "is invalid without a last name" do
    author = build :author, :no_last_name
    expect(author).to be_invalid
    expect(author.errors[:last_name]).to include("can't be blank")
  end
  it "has full name" do
    author = build :author
    full_name = "#{author.first_name} #{author.last_name}"
    expect(full_name).to eq(author.name)
  end
  it "has last name first" do
    author = build :author
    full_name = "#{author.last_name}, #{author.first_name}"
    expect(full_name).to eq(author.last_name_first)
  end
end
