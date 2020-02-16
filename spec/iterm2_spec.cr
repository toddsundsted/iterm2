require "./spec_helper"

Spectator.describe Iterm2 do
  describe "::VERSION" do
    it "should return the version" do
      version = YAML.parse(File.read(File.join(__DIR__, "..", "shard.yml")))["version"].as_s
      expect(Iterm2::VERSION).to eq(version)
    end
  end
end
