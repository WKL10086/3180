use strict;
use warnings;

package Team;

sub new {
  # [x] Your Implementation Here
	my $className = shift;
	my $classInfo = {
		"_team_index" => shift,
		"_horse_list" => undef,
		"_order" => undef,
		"_race_cnt" => 0,
	};
	bless $classInfo, $className;
	return $classInfo;
};

sub set_horse_list {
	# [x] Your Implementation Here
	my ($self, $horse_list) = @_;

	$self->{_horse_list} = $horse_list;
}

sub get_horse_list {
  # [x] Your Implementation Here
	my $self = shift;

	return $self->{_horse_list};
}

sub set_order {
	# [x] Your Implementation Here
	my ($self, $order_ref) = @_;

	$self->{_order} = [];
	for my $a_order (@$order_ref) {
		push @{$self->{_order}}, $a_order;
	}
	$self->{_race_cnt} = 0;
}

sub get_next_horse {
	# [x] Your Implementation Here
	my $self = shift;

	if ($self->{_race_cnt} >= scalar @{$self->{_order}}) {
		return undef;
	}
	my $prev_horse_idx = $self->{_order}[$self->{_race_cnt}];
	my $horse = undef;
	for my $_horse (@{$self->{_horse_list}}) {
		if ($_horse->properties()->{horse_index} == $prev_horse_idx) {
			$horse = $_horse;
			last;
		}
	}
	$self->{_race_cnt} += 1;
	return $horse;
}

1;