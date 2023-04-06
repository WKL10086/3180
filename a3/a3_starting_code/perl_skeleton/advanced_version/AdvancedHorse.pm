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
  my ($self, $coins) = shift;
  $self->{_coins} += $coins;
}

sub buy_prop_upgrade {
  # [x] Your Implementation Here
  my $self = shift;
  while ($self->{_coins} >= 50) {
    print "Do you want to upgrade properties for Horse ", $self->{_horse_index} ,"? S for speed. E for experience. R for rank. N for nothing.\n";

    my $user_input = <>;
    chomp $user_input;

    if ($user_input eq "N") {
      last;
    } 

    $self->{_coins} -= 50;
    if ($user_input eq "S") {
      $self->{_speed} += 1;
    } elsif ($user_input eq "E") {
      $self->{_experience} += 1;
    } elsif ($user_input eq "R") {
      $self->{_rank} += 1;
    } 
  }
}

sub record_race {
  # [x] Your Implementation Here
  my ($self, $race_result) = shift;
  if (scalar @{$self->{_history_record}} < 3) {
    push @{$self->{_history_record}}, $race_result;
  } else {
    shift @{$self->{_history_record}};
    push @{$self->{_history_record}}, $race_result;
  }
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