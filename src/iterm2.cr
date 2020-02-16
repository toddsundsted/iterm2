# Display images within the terminal using the ITerm2 [Inline Images
# Protocol](https://iterm2.com/documentation-images.html).
#
class Iterm2
  VERSION = {{ `shards version "#{__DIR__}"`.chomp.stringify }}

  # Creates a new instance.
  #
  def initialize(@output : IO = STDOUT)
  end

  # Wraps the input in the protocol envelop and writes the result to
  # the output.
  #
  # By default, ITerm2 will display supported image formats within the
  # terminal. It will download unsupported image formats and non-image
  # inputs.
  #
  # If downloading, `name` is the filename of the downloaded file (it
  # defaults to "Unnamed file") and "size" is the file size in bytes
  # (it is optional and only used by the ITerm2 progress indicator).
  #
  # `width` and `height` are the width and height with which to
  # display the image. `width` and `height` are specified by a number
  # followed by an optional unit, or the word "auto". Units are pixels
  # ("px") or the percent ("%") of the session's width or height. A
  # number without a unit specifies character cells.
  #
  # If `preserve_aspect_ratio` is false, then the image's inherent
  # aspect ratio will not be respected; otherwise, it will fill the
  # specified width and height as much as possible without stretching.
  # It defaults to `true`.
  #
  # If `inline` is false, the input will be downloaded with no visual
  # representation in the terminal session. Otherwise, it will be
  # displayed inline. It defaults to `true`.
  #
  def display(input : IO, name = nil, size = nil, width = nil, height = nil,
              preserve_aspect_ratio : Bool = true, inline : Bool = true)
    unless input.responds_to?(:to_slice)
      temp =
        input.responds_to?(:size) ?
          IO::Memory.new(input.size) :
          IO::Memory.new
        IO.copy(input, temp)
        input = temp
    end
    options = [] of String
    options << "name=#{Base64.strict_encode(name)}" if name
    options << "size=#{size}" if size
    options << "width=#{width}" if width
    options << "height=#{height}" if height
    options << "preserveAspectRatio=0" unless preserve_aspect_ratio
    options << "inline=1" if inline
    @output << "\e]1337;File="
    @output << options.join(";") unless options.empty?
    @output << ":"
    Base64.strict_encode(input, @output)
    @output << "\a"
    @output << "\n"
    self
  end
end
