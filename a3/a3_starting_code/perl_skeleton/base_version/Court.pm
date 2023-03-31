use strict;
use warnings;

package Court;

use FindBin qw($Bin);
use lib "$Bin/base_version";

use Team;
use Horse;

use List::Util qw( min max ); 

sub new {
  # [x] Your Implementation Here
  my $className = shift;
	my $classInfo = {
    "_team_1" => undef,
    "_team_2" => undef,
    "_round_cnt" => 1,
	};
	bless $classInfo, $className;
	return $classInfo;
}

sub set_teams {
  # [x] Your Implementation Here
  my ($self, $team_1, $team_2) = @_;

  $self->{_team1} = $team_1;
  $self->{_team2} = $team_2;
}

sub play_one_round {
  # [x] Your Implementation Here
  my $self = shift;

  my $race_cnt = 1;
  print "Round ", $self->{_round_cnt}, ":\n";

  while (1) {
    # Get the horses for the next race
    my $team1_horse = $self->{_team1}->get_next_horse();
    my $team2_horse = $self->{_team2}->get_next_horse();

    if (! defined $team1_horse || ! defined $team2_horse) {
      last;
    }

    my $upper_horse = $team1_horse;
    my $lower_horse = $team2_horse;
    if ($team1_horse->properties()->{rank} < $team2_horse->properties()->{rank}) {
      $upper_horse = $team2_horse;
      $lower_horse = $team1_horse;
    }

    my $properties_upper = $upper_horse->properties();
    my $properties_lower = $lower_horse->properties();

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
      $winner_info = "horse ", $upper_horse->properties()->{horse_index}, " wins";
    } else {
      if ($actual_speed_upper > $actual_speed_lower) {
        $winner_info = "horse ", $upper_horse->properties()->{horse_index}, " wins";
      } elsif ($actual_speed_lower > $actual_speed_upper) {
        $winner_info = "horse ", $lower_horse->properties()->{horse_index}, " wins";
      }
    }

    print "Race ", $race_cnt, ": horse ", $team1_horse->properties()->{horse_index}, " VS horse ", $team2_horse->properties()->{horse_index}, ", ", $winner_info, "\n";
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
        $team_horse->print_info();
      } else {
        last;
      }
      $team_horse = $team->get_next_horse();
    }
  }

  $self->{_round_cnt} += 1;
}

sub check_winner {
  # [x] Your Implementation Here
  my $self = shift;

  my $team1_defeated = 1;
  my $team2_defeated = 1;

  my $horse_list1 = $self->{_team1}->get_horse_list();
  my $horse_list2 = $self->{_team2}->get_horse_list();

  for my $i (0..scalar @$horse_list1 - 1) {
    if (! @$horse_list1[$i]->check_defeated()) {
      $team1_defeated = 0;
      last;
    }
  }

  for my $i (0..scalar @$horse_list2 - 1) {
    if (! @$horse_list2[$i]->check_defeated()) {
      $team2_defeated = 0;
      last;
    }
  }

  my $stop = 0;
  my $winner = 0;
  if ($team1_defeated) {
    $winner = 2;
    $stop = 1;
  } elsif ($team2_defeated) {
    $winner = 1;
    $stop = 1;
  }

  return ($stop, $winner);
}

sub input_horses {
  # [x] Your Implementation Here
  my ($self , $team_index) = @_;

  print "Please input properties for horses in Team ", $team_index, "\n";
  my $horse_list_team = [];
  for my $horse_idx (4 * ($team_index - 1) + 1, 4 * ($team_index - 1) + 5 - 1) {
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

sub play_game {
  # [x] Your Implementation Here
  my $self = shift;

  my $horse_list_team1 = $self->input_horses(1);
  my $horse_list_team2 = $self->input_horses(2);

  my $team1 = Team->new(1);
  my $team2 = Team->new(2);
  my $team1->set_horse_list($horse_list_team1);
  my $team2->set_horse_list($horse_list_team2);

  $self->set_teams($team1, $team2);

  print "===========\n";
  print "Game Begins\n";
  print "===========\n\n";

  my $stop = 0;
  my $winner = undef;
  while (1) {
    print "\n===== Begin New Round =====\n";
    print "Team 1: please input order\n";
    while (1) {
      my $user_input = <>;
      chomp $user_input;
      my @order1 = split / /, $user_input;
      my $flag_valid = 1;
      my $undefeated_number = 0;
      for my $order (@order1) {
        if ($order < 1 || $order > 4) {
          $flag_valid = 0;
        } elsif ($self->{_team1}->get_horse_list()->[$order - 1]->check_defeated()) {
          $flag_valid = 0;
        }
      }
      # Check if there are duplicated
      my %seen = map { $_ => 1 } @order1;
      if (scalar @order1 != scalar keys %seen) {
        $flag_valid = 0;
      }
      for my $i (0..3) {
        if (! $self->{_team1}->get_horse_list()->[$i]->check_defeated()) {
          $undefeated_number += 1;
        }
      }
      if ($undefeated_number != scalar @order1) {
        $flag_valid = 0;
      }
      if ($flag_valid) {
        last;
      } else {
        print "Invalid input order\n";
      }
    }

    print "Team 2: please input order\n";
    while (1) {
      my $user_input = <>;
      chomp $user_input;
      my @order2 = split / /, $user_input;
      my $flag_valid = 1;
      my $undefeated_number = 0;
      for my $order (@order2) {
        if ($order < 5 || $order > 8) {
          $flag_valid = 0;
        } elsif ($self->{_team2}->get_horse_list()->[$order - 1 - 4]->check_defeated()) {
          $flag_valid = 0;
        }
      }
      # Check if there are duplicated
      my %seen = map { $_ => 1 } @order2;
      if (scalar @order2 != scalar keys %seen) {
        $flag_valid = 0;
      }
      for my $i (0..3) {
        if (! $self->{_team2}->get_horse_list()->[$i]->check_defeated()) {
          $undefeated_number += 1;
        }
      }
      if ($undefeated_number != scalar @order2) {
        $flag_valid = 0;
      }
      if ($flag_valid) {
        last;
      } else {
        print "Invalid input order\n";
      }
    }

    # Pass the order to the team
    $self->{_team1}->set_order(\@order1);
    $self->{_team2}->set_order(\@order2);

    $self->play_round();
    ($stop, $winner) = $self->check_winner();
    if ($stop) {
      last;
    }
  }

  print "Team ", $winner, " wins";
}

1;
