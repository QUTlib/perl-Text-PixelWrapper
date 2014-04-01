####################################################################
#
# Copyright 2013 Queensland University of Technology. All Rights
# Reserved.
#
# This file is part of perl-Text-PixelWrapper.
#
# perl-MIME-Base64-ChunkedEncoder is free software: you can
# redistribute it and/or modify it under the terms of the GNU General
# Public License as published by the Free Software Foundation, either
# version 3 of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see
# <http://www.gnu.org/licenses/>.
#
####################################################################

use strict;
use warnings;

use Test::More tests => 31;

BEGIN
{
    use File::Basename qw(dirname);
    use lib dirname( __FILE__ ) . '/../lib/';
}

BEGIN { use_ok( 'Text::PixelWrapper' ); }

my $width = 175;
my @strings = (
    [
	"A short string.",
	"A short string.",
	"A short string.",
	"A short string.",
	82,
	(82, Text::PixelWrapper::lineheight())
    ],
    [
	"A long string that is a bit longer than the short string.",
	"A long string that is a bit\nlonger than the short string.",
	"A long string that is a bit\nlonger than the short string.",
	"A long string that is a bit\nlonger than the short string.",
	305,
	(159, Text::PixelWrapper::lineheight()*2)
    ],
    [
	"A very long string that is even longer than the long string, \n"
	    ." which even contains line-wrapping  and random \t  spacing\n"
	    ."   characters and whatnot.  \n",

	"A very long string that is even\n"
	    ."longer than the long string, \n"
	    ." which even contains\n"
	    ."line-wrapping  and random\n"
	    ."\t  spacing\n"
	    ."   characters and whatnot.  \n",

	"A very long string that is even\n"
	    ."longer than the long string,\n"
	    ."which even contains\n"
	    ."line-wrapping and random\n"
	    ."spacing characters and\n"
	    ."whatnot.",

	"A very long string that is even\n"
	    ."longer than the long string,\n"
	    ."which even contains\n"
	    ."line-wrapping and random\n"
	    ."spacing\n"
	    ."characters and whatnot.\n",

	852,
	(170, Text::PixelWrapper::lineheight()*6)
    ],
    [
	"A-string-that-is-likely-to-wrap,-but-doesn't-have-any-useful-spaces.",
	"A-string-that-is-likely-to-\nwrap,-but-doesn't-have-any-\nuseful-spaces.",
	"A-string-that-is-likely-to-\nwrap,-but-doesn't-have-any-\nuseful-spaces.",
	"A-string-that-is-likely-to-\nwrap,-but-doesn't-have-any-\nuseful-spaces.",
	379,
	(157, Text::PixelWrapper::lineheight()*3)
    ],
    [
	"Astringthatislikelytowrapbutdoesn'thaveanyspacesatall.",
	"Astringthatislikelytowrapbutdo\nesn'thaveanyspacesatall.",
	"Astringthatislikelytowrapbutdo\nesn'thaveanyspacesatall.",
	"Astringthatislikelytowrapbutdo\nesn'thaveanyspacesatall.",
	317,
	(173, Text::PixelWrapper::lineheight()*2)
    ],
);

my $n = 0;
for my $s ( @strings )
{
    $n += 1;

    my( $in, $ex, $eh, $en, $xl, @xd ) = @{$s};
    my $out = Text::PixelWrapper::wrap( $in, $width );
    is( $out, $ex, "wrap [$n]" );

    my $html = Text::PixelWrapper::wrap( $in, $width, html=>1 );
    is( $html, $eh, "wrap(html) [$n]" );

    my $htmlnl = Text::PixelWrapper::wrap( $in, $width, html=>1, preservenl=>1 );
    is( $htmlnl, $en, "wrap(htmlnl) [$n]" );

    my $pl = Text::PixelWrapper::pixlength( $in );
    is( $pl, $xl, "pixlength [$n]" );

    my( $w,$h ) = Text::PixelWrapper::dimensions( $eh );
    is( $w, $xd[0], "dimensions{0} [$n]" );
    is( $h, $xd[1], "dimensions{1} [$n]" );
}

1;

