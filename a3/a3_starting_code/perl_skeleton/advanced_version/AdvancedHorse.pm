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
  # [x] Your Implementation Here
  my $className = shift;
	my $classInfo = {
		"_horse_index" => shift,
		"_morale" => shift,
		"_speed" => shift,
		"_experience" => shift,
		"_rank" => shift,
		"_defeated" => 0,
    "_coins" => 0,
    "_history_record" => [],
	};
	bless $classInfo, $className;
	return $classInfo;
}

sub obtain_coins {
  # [ ] Your Implementation Here
  my $self = shift;
  $self->{_coins} += $coins_to_obtain;
}

sub buy_prop_upgrade {
  # [ ] Your Implementation Here
  my $self = shift;
}

sub record_race {
  # [ ] Your Implementation Here
  my ($self, $race_result) = shift;
}


sub update_properties {
  # [ ] Your Implementation Here
  my $self = shift;
}

sub recover_morale {
  # [ ] Your Implementation Here
  my ($self, $recover) = shift;
}

1;