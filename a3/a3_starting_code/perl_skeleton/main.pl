use strict;
use warnings;

# Switch version here
# Please don't add new lines in this file.
# When you submit, please switch to base version.

package main;

# To test base version, uncomment the following three lines
require "./base_version/Court.pm";
my $Court = new Court();
$Court -> play_game();

# To test advanced version, uncomment the following three lines
# require "./advanced_version/AdvancedCourt.pm";
# my $AdvCourt = new AdvancedCourt();
# $AdvCourt -> play_game();
