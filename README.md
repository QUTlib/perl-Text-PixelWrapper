# Text::PixelWrapper

Line wrapping to form simple paragraphs, using an approximation
for proportional-width fonts.

The standard measure is a typical 10pt (13.33px) sans-serif font.

[![Build Status](https://secure.travis-ci.org/QUTlib/perl-Text-PixelWrapper.png)](http://travis-ci.org/QUTlib/perl-Text-PixelWrapper)

- - - - -

Copyright 2013,2014 Queensland University of Technology.
All Rights Reserved.

perl-Text-PixelWrapper is free software: you can
redistribute it and/or modify it under the terms of the GNU General
Public License as published by the Free Software Foundation, either
version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see
<http://www.gnu.org/licenses/>.

- - - - -

### $length = Text::PixelWrapper::pixlength( $string, %opts )

Get the length of a string in pixels.

This does not account for line-breaks.

**Parameters:**

* **$string** the string to measure
* **%opts**
    * *tab* => number of space characters that matches one tab-stop

**Returns:** the length of `$string`, in pixels

### ($width, $height) = Text::PixelWrapper::dimensions( $string, %opts )

**Parameters:**

* `$string` the string to measure
* `%opts`
    * *html* => 1/0 whether to compress whitespace HTML-style
    * *preservenl* => 1/0 whether to keep newlines (in html mode only)
    * *tab*  => number of space characters that matches one tab-stop
    * *line* => height of a line, in ems (default = `1.2`)

**Returns:** `($width, $height)`


### $wrapped = Text::PixelWrapper::wrap( $string, $width=936, %opts )

Wrap a string at certain pixel-widths.

Some arbitrary widths:
* 936 = 72 'W's (widest ASCII character)
* 1008 = 72 per-milles (widest character)
* 960 = 72 em

**Parameters:**

* `$string` the string to chop
* `$width`  how wide to chop it (default = 936, which is 72 'W's)
* `%opts`
    * *br* => what to put between the wrapped lines (default = `"\n"`)
    * *html* => 1/0 whether to compress whitespace HTML-style
    * *preservenl* => 1/0 whether to keep newlines (in html mode only)
    * *tab*  => number of space characters that matches one tab-stop

**Returns:** a string which is line-wrapped

- - - - -

## Known Issues

* does not support string encodings (all measurements and wrapping are
  based on [Windows-1252](https://en.wikipedia.org/wiki/Windows-1252))

