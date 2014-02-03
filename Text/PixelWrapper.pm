package Text::PixelWrapper;

####################################################################
#
# Text::PixelWrapper
#
# Line wrapped to form simple paragraphs, using an approximation
# for proportional-width fonts.
#
# The standard measure is a typical 10pt (13.33px) sans-serif font.
#
####################################################################
#
# Copyright 2013 Queensland University of Technology.
# All Rights Reserved.
#
# This file is part of perl-Text-PixelWrapper.
#
# perl-Text-PixelWrapper is free software: you can
# redistribute it and/or modify it under the terms of the GNU General
# Public License as published by the Free Software Foundation, either
# version 3 of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see
# <http://www.gnu.org/licenses/>.
#
####################################################################

use strict;
use warnings;

my %widths = (
    32 => 4,
    33 => 3,
    34 => 5,
    35 => 7,
    36 => 7,
    37 => 12,
    38 => 9,
    39 => 2,
    40 => 4,
    41 => 4,
    42 => 5,
    43 => 8,
    44 => 4,
    45 => 4,
    46 => 4,
    47 => 4,
    48 => 7,
    49 => 7,
    50 => 7,
    51 => 7,
    52 => 7,
    53 => 7,
    54 => 7,
    55 => 7,
    56 => 7,
    57 => 7,
    58 => 4,
    59 => 4,
    60 => 8,
    61 => 8,
    62 => 8,
    63 => 7,
    64 => 13,
    65 => 9,
    66 => 9,
    67 => 9,
    68 => 9,
    69 => 9,
    70 => 8,
    71 => 10,
    72 => 9,
    73 => 3,
    74 => 6,
    75 => 9,
    76 => 7,
    77 => 11,
    78 => 9,
    79 => 10,
    80 => 9,
    81 => 10,
    82 => 9,
    83 => 9,
    84 => 7,
    85 => 9,
    86 => 9,
    87 => 13,
    88 => 7,
    89 => 9,
    90 => 7,
    91 => 4,
    92 => 4,
    93 => 4,
    94 => 5,
    95 => 7,
    96 => 4,
    97 => 7,
    98 => 7,
    99 => 7,
    100 => 7,
    101 => 7,
    102 => 3,
    103 => 7,
    104 => 7,
    105 => 3,
    106 => 3,
    107 => 7,
    108 => 3,
    109 => 11,
    110 => 7,
    111 => 7,
    112 => 7,
    113 => 7,
    114 => 4,
    115 => 7,
    116 => 4,
    117 => 7,
    118 => 5,
    119 => 9,
    120 => 7,
    121 => 7,
    122 => 7,
    123 => 4,
    124 => 3,
    125 => 4,
    126 => 8,
    127 => 0,
    128 => 7,
    129 => 0,
    130 => 3,
    131 => 7,
    132 => 4,
    133 => 13,
    134 => 7,
    135 => 7,
    136 => 4,
    137 => 10.22,
    138 => 9,
    139 => 4,
    140 => 13,
    141 => 0,
    142 => 7,
    143 => 0,
    144 => 0,
    145 => 3,
    146 => 3,
    147 => 4,
    148 => 4,
    149 => 5,
    150 => 7,
    151 => 13,
    152 => 4,
    153 => 13,
    154 => 7,
    155 => 4,
    156 => 12,
    157 => 0,
    158 => 7,
    159 => 9,
    160 => 4,
    161 => 3,
    162 => 7,
    163 => 7,
    164 => 7,
    165 => 7,
    166 => 3,
    167 => 7,
    168 => 4,
    169 => 10,
    170 => 4,
    171 => 7,
    172 => 8,
    173 => 0,
    174 => 10,
    175 => 7,
    176 => 5,
    177 => 7,
    178 => 4,
    179 => 4,
    180 => 4,
    181 => 7,
    182 => 7,
    183 => 4,
    184 => 4,
    185 => 4,
    186 => 5,
    187 => 7,
    188 => 11,
    189 => 11,
    190 => 11,
    191 => 8,
    192 => 9,
    193 => 9,
    194 => 9,
    195 => 9,
    196 => 9,
    197 => 9,
    198 => 13,
    199 => 9,
    200 => 9,
    201 => 9,
    202 => 9,
    203 => 9,
    204 => 3,
    205 => 3,
    206 => 3,
    207 => 3,
    208 => 9,
    209 => 9,
    210 => 10,
    211 => 10,
    212 => 10,
    213 => 10,
    214 => 10,
    215 => 8,
    216 => 10,
    217 => 9,
    218 => 9,
    219 => 9,
    220 => 9,
    221 => 9,
    222 => 9,
    223 => 9,
    224 => 7,
    225 => 7,
    226 => 7,
    227 => 7,
    228 => 7,
    229 => 7,
    230 => 12,
    231 => 7,
    232 => 7,
    233 => 7,
    234 => 7,
    235 => 7,
    236 => 3,
    237 => 3,
    238 => 3,
    239 => 3,
    240 => 7,
    241 => 7,
    242 => 7,
    243 => 7,
    244 => 7,
    245 => 7,
    246 => 7,
    247 => 7,
    248 => 7,
    249 => 7,
    250 => 7,
    251 => 7,
    252 => 7,
    253 => 7,
    254 => 7,
    255 => 7,
);

#
# Get the length of a string in pixels.
#
# This does not account for line-breaks or tab characters.
#
sub pixlength
{
    my( $string ) = @_;
    my $len = 0;
    for my $ord ( unpack("C*",$string) ) {
	$len += ($widths{$ord} || 0);
    }
    return $len;
}

#
# Wrap a string at certain pixel-widths.
#
# Some arbitrary widths:
# o 936 = 72 'W's (widest character)
# o 960 = 72 em
#
# @param $string the string to chop
# @param $width how wide to chop it (default = 936, which is 72 'W's)
# @param $br what to put between the wrapped lines (default = "\n")
# @return a string which is line-wrapped
#
sub wrap
{
    my( $string, $width, $br ) = @_;
    $string =~ s/\s+/ /g;
    $string =~ s/^\s|\s$//g;
    $width = 936 unless $width;
    $br = "\n" unless $br;

    my @ords = unpack("C*", $string);

    my $wrapped = '';
    my $length = 0;
    my $accum = '';
    for my $ord ( @ords ) {
	my $char = chr($ord);
	next if(($length == 0) && ($char =~ /\s/));
	my $cl = ($widths{$ord} || 0);
	if( $length + $cl > $width ) {
	    # chop it off
	    if( $char =~ /\s/ ) {
		# Next character is a space; add accum as-is.
		$wrapped .= ($wrapped ? $br : '') . $accum;
		$accum = '';
		$length = 0;
		next;
	    } elsif( $accum =~ /^(.+\S)\s(.*)/ ) {
		# There's a space somewhere earlier in the line;
		# let's wrap it back there.
		$wrapped .= ($wrapped ? $br : '') . $1;
		$accum = $2;
		$length = pixlength($accum);
	    } elsif( $accum =~ /^(.+[^A-Z0-9']\b)(.*)/i ) {
		# There's some sort of punctuation.  Use that.
		$wrapped .= ($wrapped ? $br : '') . $1;
		$accum = $2;
		$length = pixlength($accum);
	    } else {
		# The last line was a single word.  Just chop it
		# off somewhat arbitrarily.
		$wrapped .= ($wrapped ? $br : '') . $accum;
		$accum = '';
		$length = 0;
	    }
	}
	$accum .= $char;
	$length += $cl;
    }
    return $wrapped . ($wrapped ? $br : '') . $accum;
}

