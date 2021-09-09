# frozen_string_literal: true

RSpec.describe Quince do
  it "has a version number" do
    expect(Quince::VERSION).not_to be nil
  end

  it "defines a component" do
    expect(Quince::Component)
  end
end
