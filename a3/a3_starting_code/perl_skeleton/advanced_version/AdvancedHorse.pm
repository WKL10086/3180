use strict;
use warnings;

package AdvancedHorse;

use FindBin qw($Bin);
use lib "$Bin/base_version";
use Horse;
use List::Util qw(sum);

our @ISA = qw(Horse); 

our $coins_to_obtain = 20;
our $delta_speed = -1;
our $delta_experience = 0;
our $delta_rank = -1;


sub new {
  # [ ] Your Implementation Here
}

sub obtain_coins {
  # [ ] Your Implementation Here
}

sub buy_prop_upgrade {
  # [ ] Your Implementation Here
}

sub record_race {
  # [ ] Your Implementation Here
}


sub update_properties {
  # [ ] Your Implementation Here
}

1;