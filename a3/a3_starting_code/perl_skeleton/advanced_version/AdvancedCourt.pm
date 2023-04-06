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
  # [x] Your Implementation Here
  my $className = shift;
	my $classInfo = {
    "_team_1" => undef,
    "_team_2" => undef,
    "_round_cnt" => 1,
    "_recover_horses" => [],
	};
	bless $classInfo, $className;
	return $classInfo;
}

sub play_one_round {
  # [ ] Your Implementation Here
  my $self = shift;
  
  my $race_cnt = 1;
  print "Round ", $self->{_round_cnt}, ":\n";

  my $team1_horse = undef;
  my $team2_horse = undef;
  while (1) {
    # Get the horses for the next race
    $team1_horse = $self->{_team1}->get_next_horse();
    $team2_horse = $self->{_team2}->get_next_horse();

    if (! defined $team1_horse || ! defined $team2_horse) {
      last;
    }

    # [x] ask upgrade for horse
    $team1_horse->buy_prop_upgrade();
    $team2_horse->buy_prop_upgrade();

    my $upper_horse = $team1_horse;
    my $lower_horse = $team2_horse;
    if ($team1_horse->get_properties()->{rank} < $team2_horse->get_properties()->{rank}) {
      $upper_horse = $team2_horse;
      $lower_horse = $team1_horse;
    }

    my $properties_upper = $upper_horse->get_properties();
    my $properties_lower = $lower_horse->get_properties();

    # calculate the lower horse sink and activate
    my $actual_speed_upper = $properties_upper->{speed} * $properties_upper->{experience};
    my $moral_sink_lower = int(($actual_speed_upper - 10 * $properties_lower->{speed}) / 10);
    if ($moral_sink_lower < 1) {
      $moral_sink_lower = 1;
    }
    $lower_horse->reduce_morale($moral_sink_lower);

    # Calculate the upper horse sink only if the lower horse remains undefeated
    my $actual_speed_lower = undef;
    if (! $lower_horse->check_defeated()) {
      $actual_speed_lower = $properties_lower->{speed} * $properties_lower->{experience};
      my $moral_sink_upper = int(($actual_speed_lower - 10 * $properties_upper->{speed}) / 10);
      if ($moral_sink_upper < 1) {
        $moral_sink_upper = 1;
      }
      $upper_horse->reduce_morale($moral_sink_upper);
    }

    # Label the winning information: higher actual_speed
    my $winner_info = "tie";
    if (! defined $actual_speed_lower) {
      $winner_info = "horse ".$upper_horse->get_properties()->{horse_index}." wins";

      $upper_horse->record_race("rest");
      $self->update_horse_properties_and_award_coins($upper_horse, 1, 0);

      $lower_horse->record_race("defeated");
      $self->update_horse_properties_and_award_coins($lower_horse);
    } else {
      if ($actual_speed_upper > $actual_speed_lower) {
        $winner_info = "horse ".$upper_horse->get_properties()->{horse_index}." wins";

        $upper_horse->record_race("win");
        $self->update_horse_properties_and_award_coins($upper_horse);

        $lower_horse->record_race("lose");
        $self->update_horse_properties_and_award_coins($lower_horse);
      } elsif ($actual_speed_lower > $actual_speed_upper) {
        $winner_info = "horse ".$lower_horse->get_properties()->{horse_index}." wins";

        $lower_horse->record_race("win");
        $self->update_horse_properties_and_award_coins($lower_horse);

        $upper_horse->record_race("lose");
        $self->update_horse_properties_and_award_coins($upper_horse);
      }
    }

    print "Race ", $race_cnt, ": horse ", $team1_horse->get_properties()->{horse_index}, " VS horse ", $team2_horse->get_properties()->{horse_index}, ", ", $winner_info, "\n";
    $team1_horse->print_info();
    $team2_horse->print_info();
    $race_cnt += 1;
  }

  print "Horses at rest:\n";
  for my $team (($self->{_team1}, $self->{_team2})) {
    my $team_horse = undef;
    if ($team == $self->{_team1}) {
      $team_horse = $team1_horse;
    } else {
      $team_horse = $team2_horse;
    }
    while (1) {
      if (defined $team_horse) {
        $team_horse->record_race("rest");
        $self->update_horse_properties_and_award_coins($team_horse, 0, 1);

        $team_horse->print_info();
      } else {
        last;
      }
      $team_horse = $team->get_next_horse();
    }
  }

  $self->{_round_cnt} += 1;
}

sub update_horse_properties_and_award_coins {
  # [x] Your Implementation Here
  my ($self, $horse, $flag_defeat, $flag_rest) = @_;
  $flag_defeat //= 0;
  $flag_rest //= 0;

  if ($flag_rest) {
    local $AdvancedHorse::delta_speed = 1;
    local $AdvancedHorse::delta_experience = 1;
    local $AdvancedHorse::delta_rank = 1;
    $horse->update_properties();

    local $AdvancedHorse::coins_to_obtain = 10;
    $horse->obtain_coins();
  } elsif ($flag_defeat) {
    local $AdvancedHorse::delta_speed = 4;

    if ($horse->check_consecutive_winner()) {
      local $AdvancedHorse::delta_experience = 3;
      local $AdvancedHorse::delta_rank = 3;
      $horse->update_properties();

      local $AdvancedHorse::coins_to_obtain = 44;
      $horse->obtain_coins();
    } else {
      $horse->update_properties();

      local $AdvancedHorse::coins_to_obtain = 40;
      $horse->obtain_coins();
    }
  } else {
    if ($horse->check_consecutive_winner()) {
      local $AdvancedHorse::delta_experience = 3;
      local $AdvancedHorse::delta_rank = 3;
      $horse->update_properties();

      local $AdvancedHorse::coins_to_obtain = 22;
      $horse->obtain_coins();
    } elsif ($horse->check_consecutive_loser()) {
      push @{$self->{_recover_horses}}, $horse->get_properties()->{horse_index};

      local $AdvancedHorse::delta_experience = -2;
      $horse->update_properties();

      local $AdvancedHorse::coins_to_obtain = 22;
      $horse->obtain_coins();
    } else {
      $horse->update_properties();
      $horse->obtain_coins();
    }
  }
}

sub input_horses {
  # [x] Your Implementation Here
  my ($self , $team_index) = @_;

  print "Please input properties for horses in Team ", $team_index, "\n";
  my $horse_list_team = [];
  for my $horse_idx (4 * ($team_index - 1) + 1 .. 4 * ($team_index - 1) + 5 - 1) {
    while (1) {
      my $user_input = <>;
      chomp $user_input;
      my @properties = split / /, $user_input;
      my ($morale, $speed, $experience, $rank) = @properties;
      if ($morale + 5 * ($speed + $experience + $rank) <= 300) {
        my $horse = Horse->new($horse_idx, $morale, $speed, $experience, $rank);
        push @$horse_list_team, $horse;
        last;
      }
      print "Properties violate the constraint\n";
    }
  }
  return $horse_list_team;
}

1;