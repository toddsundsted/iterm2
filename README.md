# iterm2

[![GitHub Release](https://img.shields.io/github/release/toddsundsted/iterm2.svg)](https://github.com/toddsundsted/iterm2/releases)
[![Build Status](https://travis-ci.org/toddsundsted/iterm2.svg?branch=master)](https://travis-ci.org/toddsundsted/iterm2)
[![Documentation](https://img.shields.io/badge/docs-available-brightgreen.svg)](https://toddsundsted.github.io/iterm2/)

Displays images within the terminal using the ITerm2 [Inline Images
 Protocol](https://iterm2.com/documentation-images.html).

Requires [ITerm2](https://iterm2.com/).

## Installation

1. Add the dependency to your `shard.yml`:

```yaml
dependencies:
  iterm2:
    github: toddsundsted/iterm2
```

2. Run `shards install`

## Usage

```crystal
require "iterm2"

File.open("unicorn.png") do |file|
  Iterm2.new.display(file)
end
```

The `#display` method also accepts a block and yields an instance of
`IO` that may be written to. See the documentation for the full API.

## Contributors

- [Todd Sundsted](https://github.com/toddsundsted) - creator and maintainer
