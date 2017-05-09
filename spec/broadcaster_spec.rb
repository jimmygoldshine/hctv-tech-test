require 'spec_helper'

describe Broadcaster do

  name = :Disney
  let(:broadcaster) { described_class.new(name) }

  it "should have its name publically accessible" do
    expect(broadcaster.name).to eq(:Disney)
  end

  it "should allow its name to be changed after initializaition" do
    broadcaster.name = :Nickelodean
    expect(broadcaster.name).to eq(:Nickelodean)
  end

end
