use strict;
use warnings;

package Court;

use FindBin qw($Bin);
use lib "$Bin/base_version";

use Team;
use Horse;

use List::Util qw( min max ); 

sub new {
  # [ ] Your Implementation Here
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
  # [ ] Your Implementation Here
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
    # TODO
  }
}

sub check_winner {
  # [ ] Your Implementation Here
}

sub input_horses {
  # [ ] Your Implementation Here
}

sub play_game {
  # [ ] Your Implementation Here
}

1;
