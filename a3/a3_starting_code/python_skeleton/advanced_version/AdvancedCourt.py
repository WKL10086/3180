from base_version.Team import Team
from base_version.Court import Court
from .AdvancedHorse import AdvancedHorse
import advanced_version.AdvancedHorse as AdvancedHorseFile


class AdvancedCourt(Court):
    def __init__(self):
        # [x] Your Implementation Starts Here
        self.team1 = None
        self.team2 = None
        self.round_cnt = 1
        self.recover_horses = []

    def play_one_round(self):
        # [x] Your Implementation Starts Here
        race_cnt = 1
        print("Round {}:".format(self.round_cnt))

        while True:
            # Get the horses for the next race
            team1_horse = self.team1.get_next_horse()
            team2_horse = self.team2.get_next_horse()

            if team1_horse is None or team2_horse is None:
                break

            team1_horse.buy_prop_upgrade()
            team2_horse.buy_prop_upgrade()

            upper_horse = team1_horse
            lower_horse = team2_horse
            if team1_horse.properties["rank"] < team2_horse.properties["rank"]:
                upper_horse = team2_horse
                lower_horse = team1_horse

            properties_upper = upper_horse.properties
            properties_lower = lower_horse.properties

            # calculate the lower horse sink and activate
            actual_speed_upper = (
                properties_upper["speed"] * properties_upper["experience"]
            )
            moral_sink_lower = int(
                (actual_speed_upper - 10 * properties_lower["speed"]) / 10
            )
            if moral_sink_lower < 1:
                moral_sink_lower = 1
            lower_horse.reduce_morale(moral_sink_lower)

            # Calculate the upper horse sink only if the lower horse remains undefeated
            actual_speed_lower = None
            moral_sink_upper = None
            if not lower_horse.check_defeated():
                actual_speed_lower = (
                    properties_lower["speed"] * properties_lower["experience"]
                )
                moral_sink_upper = int(
                    (actual_speed_lower - 10 * properties_upper["speed"]) / 10
                )
                if moral_sink_upper < 1:
                    moral_sink_upper = 1
                upper_horse.reduce_morale(moral_sink_upper)

            # Label the winning information: higher actual_speed
            winner_info = "tie"
            if actual_speed_lower is None:
                winner_info = "horse {} wins".format(
                    upper_horse.properties["horse_index"]
                )

                upper_horse.record_race("win")

                lower_horse.record_race("lose")

                self.clear_recover_horses(lower_horse)
            else:
                if actual_speed_upper > actual_speed_lower:
                    winner_info = "horse {} wins".format(
                        upper_horse.properties["horse_index"]
                    )

                    upper_horse.record_race("win")

                    self.call_recover_morale(upper_horse, moral_sink_upper)

                    lower_horse.record_race("lose")

                    self.clear_recover_horses(lower_horse)
                elif actual_speed_lower > actual_speed_upper:
                    winner_info = "horse {} wins".format(
                        lower_horse.properties["horse_index"]
                    )

                    lower_horse.record_race("win")

                    self.call_recover_morale(lower_horse, moral_sink_lower)

                    upper_horse.record_race("lose")

                    self.clear_recover_horses(upper_horse)

            print(
                "Race {}: horse {} VS horse {}, {}".format(
                    race_cnt,
                    team1_horse.properties["horse_index"],
                    team2_horse.properties["horse_index"],
                    winner_info,
                )
            )
            team1_horse.print_info()
            team2_horse.print_info()

            if lower_horse.check_defeated():
                self.update_horse_properties_and_award_coins(upper_horse, True, False)
                self.update_horse_properties_and_award_coins(lower_horse)
            elif upper_horse.check_defeated():
                self.update_horse_properties_and_award_coins(upper_horse)
                self.update_horse_properties_and_award_coins(lower_horse, True, False)
            else:
                self.update_horse_properties_and_award_coins(upper_horse)
                self.update_horse_properties_and_award_coins(lower_horse)

            race_cnt += 1

        print("Horses at rest:")
        for team in [self.team1, self.team2]:
            if team is self.team1:
                team_horse = team1_horse
            else:
                team_horse = team2_horse
            while True:
                if team_horse is not None:
                    team_horse.record_race("rest")

                    self.clear_recover_horses(team_horse)

                    team_horse.print_info()

                    self.update_horse_properties_and_award_coins(
                        team_horse, False, True
                    )
                else:
                    break
                team_horse = team.get_next_horse()

        self.round_cnt += 1

    def update_horse_properties_and_award_coins(
        self, horse, flag_defeat=False, flag_rest=False
    ):
        # [x] Your Implementation Starts Here
        if flag_rest:
            horse.update_properties(delta_speed=1, delta_experience=1, delta_rank=1)

            horse.obtain_coins(coins_to_obtain=10)
        elif flag_defeat:
            if horse.check_consecutive_winner():
                horse.update_properties(delta_speed=4, delta_experience=3, delta_rank=3)

                horse.obtain_coins(coins_to_obtain=44)
            else:
                horse.update_properties(delta_speed=4)

                horse.obtain_coins(coins_to_obtain=40)
        else:
            if horse.check_consecutive_winner():
                horse.update_properties(delta_experience=3, delta_rank=3)

                horse.obtain_coins(coins_to_obtain=22)
            elif horse.check_consecutive_loser():
                self.recover_horses.append(horse.properties["horse_index"])

                horse.update_properties(delta_experience=-2)

                horse.obtain_coins(coins_to_obtain=22)
            else:
                horse.update_properties()

                horse.obtain_coins()

    def input_horses(self, team_index):
        # [x] Your Implementation Starts Here
        print("Please input properties for horses in Team {}".format(team_index))
        horse_list_team = []
        for horse_idx in range(4 * (team_index - 1) + 1, 4 * (team_index - 1) + 5):
            while True:
                properties = input().split(" ")
                properties = [int(prop) for prop in properties]
                morale, speed, experience, rank = properties
                if morale + 5 * (speed + experience + rank) <= 300:
                    horse = AdvancedHorse(horse_idx, morale, speed, experience, rank)
                    horse_list_team.append(horse)
                    break
                print("Properties violate the constraint")
        return horse_list_team

    def call_recover_morale(self, horse, recover):
        # [x] Your Implementation Starts Here
        target = horse.properties["horse_index"]
        if target in self.recover_horses:
            horse.recover_morale(recover)
            self.recover_horses.remove(target)

    def clear_recover_horses(self, horse):
        # [x] Your Implementation Starts Here
        target = horse.properties["horse_index"]
        if target in self.recover_horses:
            self.recover_horses.remove(target)
