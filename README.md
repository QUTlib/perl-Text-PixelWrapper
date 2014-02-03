# Text::PixelWrapper

Line wrapped to form simple paragraphs, using an approximation
for proportional-width fonts.

The standard measure is a typical 10pt (13.33px) sans-serif font.

- - - - -

Copyright 2013 Queensland University of Technology.
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

### Text::PixelWrapper::pixlength( $string )

Get the length of a string in pixels.

This does not account for line-breaks or tab characters.

### Text::PixelWrapper::wrap( $string, $width=962, $br="\n" )

Wrap a string at certain pixel-widths.

* @param $string the string to chop
* @param $width how wide to chop it (default = 962, which is 74 'W's)
* @param $br what to put between the wrapped lines (default = "\n")
* @return a string which is line-wrapped

- - - - -

## Known Issues

* does not support string encodings (all measurements and wrapping are
  based on single-byte Windows-1252 encoding)
* does not support continuation characters (newline, horizontal tab)

