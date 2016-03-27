require "rails_helper"

RSpec.describe Publisher, :type => :model do
  it "is valid" do
    pub = build :publisher
    expect(pub).to be_valid
  end
  it "is invalid without a name" do
    pub = Publisher.new
    expect(pub).to be_invalid
    expect(pub.errors[:name]).to include("can't be blank")
  end
  it "has unique name" do
    Publisher.create(name: "Sextante")
    pub = Publisher.new(name: "Sextante")
    expect(pub).to be_invalid
  end
end
