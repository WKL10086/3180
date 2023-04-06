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
  # [x] Your Implementation Here
  my $self = shift;
  $self->{_coins} += $coins_to_obtain;
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
  my ($self, $race_result) = @_;
  if (scalar @{$self->{_history_record}} < 3) {
    push @{$self->{_history_record}}, $race_result;
  } else {
    shift @{$self->{_history_record}};
    push @{$self->{_history_record}}, $race_result;
  }
}

sub update_properties {
  # [x] Your Implementation Here
  my $self = shift;
  
  $self->{_speed} = $delta_speed + $self->{_speed} > 1 ? $delta_speed + $self->{_speed} : 1;
  $self->{_experience} = $delta_experience + $self->{_experience} > 1 ? $delta_experience + $self->{_experience} : 1;
  $self->{_rank} = $delta_rank + $self->{_rank} > 1 ? $delta_rank + $self->{_rank} : 1;
}

sub recover_morale {
  # [x] Your Implementation Here
  my ($self, $recover) = @_;
  $self->{_morale} += $recover;
}

sub check_consecutive_winner {
  # [x] Your Implementation Here
  my $self = shift;
  my $consecutive_winner = 0;
  if (scalar @{$self->{_history_record}} == 3) {
    if ($self->{_history_record}[0] eq "win" && $self->{_history_record}[1] eq "win" && $self->{_history_record}[2] eq "win") {
      $consecutive_winner = 1;
      $self->{_history_record} = [];
    }
  }
  return $consecutive_winner;
}

sub check_consecutive_loser {
    # [x] Your Implementation Here
  my $self = shift;
  my $consecutive_loser = 0;
  if (scalar @{$self->{_history_record}} == 3) {
    if ($self->{_history_record}[0] eq "lose" && $self->{_history_record}[1] eq "lose" && $self->{_history_record}[2] eq "lose") {
      $consecutive_loser = 1;
      $self->{_history_record} = [];
    }
  }
  return $consecutive_loser;
}

1;