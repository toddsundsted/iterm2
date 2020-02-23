require "./spec_helper"

Spectator.describe Iterm2 do
  describe "::VERSION" do
    it "should return the version" do
      version = YAML.parse(File.read(File.join(__DIR__, "..", "shard.yml")))["version"].as_s
      expect(Iterm2::VERSION).to eq(version)
    end
  end

  let(:output) { IO::Memory.new(10) }
  subject { described_class.new(output: output) }

  context "in ITerm2" do
    CMD_RE = /^\e]1337;File=([^=]+=[^;:]+(;[^=]+=[^;:]+)*)?:([a-zA-Z0-9+\=]*)\a$/

    describe "#display" do
      it "wraps the image in the protocol envelop" do
        subject.display(IO::Memory.new("123"))
        expect(output.rewind.read_line).to match(CMD_RE)
      end

      it "base64-encodes the image data" do
        subject.display(IO::Memory.new("123"))
        match = output.rewind.read_line.match(CMD_RE).not_nil!
        expect(match[match.size - 1]).to eq("MTIz")
      end

      it "specifies the name" do
        subject.display(IO::Memory.new("123"), name: "test")
        match = output.rewind.read_line.match(CMD_RE).not_nil!
        expect(match[1].split(";")).to have("name=dGVzdA==")
      end

      it "specifies the size" do
        subject.display(IO::Memory.new("123"), size: 3)
        match = output.rewind.read_line.match(CMD_RE).not_nil!
        expect(match[1].split(";")).to have("size=3")
      end

      it "specifies the width to render" do
        subject.display(IO::Memory.new("123"), width: 100)
        match = output.rewind.read_line.match(CMD_RE).not_nil!
        expect(match[1].split(";")).to have("width=100")
      end

      it "specifies the height to render" do
        subject.display(IO::Memory.new("123"), height: "100%")
        match = output.rewind.read_line.match(CMD_RE).not_nil!
        expect(match[1].split(";")).to have("height=100%")
      end

      it "toggles preserve aspect ratio off" do
        subject.display(IO::Memory.new("123"), preserve_aspect_ratio: false)
        match = output.rewind.read_line.match(CMD_RE).not_nil!
        expect(match[1].split(";")).to have("preserveAspectRatio=0")
      end

      it "toggles inline display off" do
        subject.display(IO::Memory.new("123"), name: "-", inline: false)
        match = output.rewind.read_line.match(CMD_RE).not_nil!
        expect(match[1].split(";")).not_to have("inline=1")
      end

      it "accepts a block, yields an IO" do
        subject.display do |io|
          expect(io).to be_a(IO)
        end
      end
    end
  end
end
