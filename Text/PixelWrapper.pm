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

my $fontsize = 10*(96/72);
my @widths = (
     0, 0, 0, 0, 0, 0, 0, 0, 0,00,00, 0, 0,00, 0, 0, # note: 9,10,13 are specially handled in code
     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
     4, 3, 5, 7, 7,12, 9, 2, 4, 4, 5, 8, 4, 4, 4, 4,
     7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 4, 4, 8, 8, 8, 7,
    13, 9, 9, 9, 9, 9, 8,10, 9, 3, 6, 9, 7,11, 9,10,
     9,10, 9, 9, 7, 9, 9,13, 7, 9, 7, 4, 4, 4, 5, 7,
     4, 7, 7, 7, 7, 7, 3, 7, 7, 3, 3, 7, 3,11, 7, 7,
     7, 7, 4, 7, 4, 7, 5, 9, 7, 7, 7, 4, 3, 4, 8, 0,
     7, 0, 3, 7, 4,13, 7, 7, 4,14, 9, 4,13, 0, 7, 0,
     0, 3, 3, 4, 4, 5, 7,13, 4,13, 7, 4,12, 0, 7, 9,
     4, 3, 7, 7, 7, 7, 3, 7, 4,10, 4, 7, 8, 0,10, 7,
     5, 7, 4, 4, 4, 7, 7, 4, 4, 4, 5, 7,11,11,11, 8,
     9, 9, 9, 9, 9, 9,13, 9, 9, 9, 9, 9, 3, 3, 3, 3,
     9, 9,10,10,10,10,10, 8,10, 9, 9, 9, 9, 9, 9, 9,
     7, 7, 7, 7, 7, 7,12, 7, 7, 7, 7, 7, 3, 3, 3, 3,
     7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7,
);
my $tabstop = $widths[32] * 8;
my $lineheight = 16; # FIXME: should really be 1.5em, but this is what Chrome said

sub fontsize
{
    return $fontsize;
}

sub lineheight
{
    my( $ems ) = @_;
    if( defined $ems ) {
	return $fontsize*$ems;
    } else {
        return $lineheight;
    }
}

#
# Get the length of a string in pixels.
#
# This does not account for line-breaks.
#
# @param $string the string to measure
# @param %opts
#          tab  => number of space characters that matches one tab-stop
# @return the length of $string, in pixels
#
sub pixlength
{
    my( $string, %opts ) = @_;
    my $ts = ($opts{tabs} ? $opts{tabs} * $widths[32] : $tabstop);
    my $len = 0;
    for my $ord ( unpack("C*",$string) ) {
	if ($ord == 9) {
	    $len = $len + $ts - ($len % $ts);
	} else {
	    $len += ($widths[$ord] || 0);
	}
    }
    return $len;
}

#
# Get the dimensions of a string, in pixels.
#
# @param $string the string to measure
# @param %opts
#          html => 1/0 whether to compress whitespace HTML-style
#          preservenl => 1/0 whether to keep newlines (in html mode only)
#          tab  => number of space characters that matches one tab-stop
#          line => height of a line, in ems (default = 1.2)
# @return ($width, $height)
#
sub dimensions
{
    my( $string, %opts ) = @_;

    # How wide is a tab?
    my $ts = ($opts{tabs} ? $opts{tabs} * $widths[32] : $tabstop);

    # How high is a line?
    my $lf = (defined $opts{line} ? $opts{line} * $fontsize : $lineheight);

    # sanitise linebreaks
    $string =~ s/\r\n?/\n/g;

    if ($opts{html}) {
	# collapse whitespace, HTML-style
	# - contiguous spaces => 0x20
	# - leading/trailing spaces trimmed
	if( $opts{preservenl} ) {
	    $string =~ s/[ \t]+/ /g;
        } else {
	    $string =~ s/\s+/ /g;
        }
	$string =~ s/^ +| +$//mg;
    }

    my @ords = unpack("C*", $string);

    my $width = 0;
    my $height = $lf;
    my $linewidth = 0;
    for my $ord ( @ords ) {
	if( $ord == 9 ) {
	    $linewidth = $linewidth + $ts - ($linewidth % $ts);
	} elsif( $ord == 10 && (!$opts{html} || $opts{preservenl}) ) {
	    $height += $lf;
	    $width = $linewidth if( $linewidth > $width );
	    $linewidth = 0;
	} else {
	    $linewidth += ($widths[$ord] || 0);
	}
    }
    $width = $linewidth if ($linewidth > $width);
    return ($width, $height);
}

#
# Wrap a string at certain pixel-widths.
#
# Some arbitrary widths:
# * 936 = 72 'W's (widest ASCII character)
# * 1008 = 72 per-milles (widest character)
# * 960 = 72 em
#
# @param $string the string to chop
# @param $width how wide to chop it (default = 936, which is 72 'W's)
# @param %opts
#          br => what to put between the wrapped lines (default = "\n")
#          html => 1/0 whether to compress whitespace HTML-style
#          preservenl => 1/0 whether to keep newlines (in html mode only)
#          tab  => number of space characters that matches one tab-stop
# @return a string which is line-wrapped
#
sub wrap
{
    my( $string, $width, %opts ) = @_;
    $width = 936 unless $width;

    my $br = ($opts{br} || "\n");
    my $ts = ($opts{tabs} ? $opts{tabs} * $widths[32] : $tabstop);

    # sanitise linebreaks
    $string =~ s/\r\n?/\n/g;

    if ($opts{html}) {
	# collapse whitespace, HTML-style
	# - contiguous spaces => 0x20
	# - leading/trailing spaces trimmed
	if( $opts{preservenl} ) {
	    $string =~ s/[ \t]+/ /g;
        } else {
	    $string =~ s/\s+/ /g;
        }
	$string =~ s/^ +| +$//mg;
    }

    my @ords = unpack("C*", $string);

    my $wrapped = '';
    my $length = 0;
    my $accum = '';
    for my $ord ( @ords ) {
	if( $ord == 10 && (!$opts{html} || $opts{preservenl}) ) {
	    $wrapped .= ($wrapped ? $br : '') . $accum;
	    $accum = '';
	    $length = 0;
	    next;
	}
	my $char = chr($ord);
	my $cl = ($widths[$ord] || 0);
	if( $ord == 9 ) {
	    # special handling for tab characters
	    $cl = $ts - ($length % $ts);
	}
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
		if ($opts{hyphen} && $accum =~ /(.*[A-Z])([A-Z])$/i) {
		    $wrapped .= ($wrapped ? $br : '') . $1 . '-';
		    $accum = $2;
		    $length = pixlength($accum);
		} else {
		    $wrapped .= ($wrapped ? $br : '') . $accum;
		    $accum = '';
		    $length = 0;
		}
	    }
	}
	$accum .= $char;
	$length += $cl;
    }
    return $wrapped . ($wrapped ? $br : '') . $accum;
}

