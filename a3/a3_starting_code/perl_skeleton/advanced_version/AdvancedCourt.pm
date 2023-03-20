use strict;
use warnings;

package AdvancedCourt;

use FindBin qw($Bin);
use lib "$Bin/base_version";
use lib "$Bin/advanced_version";
use Team;
use Court;
use AdvancedHorse;
use List::Util qw(sum);

our @ISA = qw(Court); 

sub new {
  # Your Implementation Here
}

sub play_one_round {
  # Your Implementation Here
}

sub update_horse_properties_and_award_coins {
  # Your Implementation Here
}

sub input_horses {
  # Your Implementation Here
}


1;