require 'spec_helper'

describe Material do

  id = "WNP/SWCL001/010"
  let(:material) { described_class.new(id) }

  it "should have its id publically accessible" do
    expect(material.id).to eq("WNP/SWCL001/010")
  end

  it "should not allow its id to be overwritten once initialized" do
    expect{ material.id = "ZDW/EOWW005/010" }.to raise_error(NoMethodError)
  end

end
