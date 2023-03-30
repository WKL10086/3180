"""
* CSCI3180 Principles of Programming Languages
*
* --- Declaration ---
* For all submitted files, including the source code files and the written
* report, for this assignment:
*
* I declare that the assignment here submitted is original except for source
* materials explicitly acknowledged. I also acknowledge that I am aware of
* University policy and regulations on honesty in academic work, and of the
* disciplinary guidelines and procedures applicable to breaches of such policy
* and regulations, as contained in the website
* http://www.cuhk.edu.hk/policy/academichonesty/
*
* Name: Wong Kai Lok
* Student ID: 1155125720
* Email Address: 1155125720@link.cuhk.edu.hk
*
* Source material acknowledgements (if any):
*
* Students whom I have discussed with (if any):
"""

from .Team import Team
from .Horse import Horse


class Court:
    def __init__(self):
        self.team1 = None
        self.team2 = None
        self.round_cnt = 1

    def input_horses(self, team_index):
        print("Please input properties for horses in Team {}".format(team_index))
        horse_list_team = []
        for horse_idx in range(4 * (team_index - 1) + 1, 4 * (team_index - 1) + 5):
            while True:
                properties = input().split(" ")
                properties = [int(prop) for prop in properties]
                morale, speed, experience, rank = properties
                if morale + 5 * (speed + experience + rank) <= 300:
                    horse = Horse(horse_idx, morale, speed, experience, rank)
                    horse_list_team.append(horse)
                    break
                print("Properties violate the constraint")
        return horse_list_team

    def set_teams(self, team1, team2):
        self.team1 = team1
        self.team2 = team2

    def play_one_round(self):
        race_cnt = 1
        print("Round {}:".format(self.round_cnt))

        while True:
            # Get the horses for the next race
            team1_horse = self.team1.get_next_horse()
            team2_horse = self.team2.get_next_horse()

            if team1_horse is None or team2_horse is None:
                break

            upper_horse = team1_horse
            lower_horse = team2_horse
            if team1_horse.properties["rank"] < team2_horse.properties["rank"]:
                upper_horse = team2_horse
                lower_horse = team1_horse

            properties_upper = upper_horse.properties
            properties_lower = lower_horse.properties

            # calcualte the lower horse sink and activate
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
            else:
                if actual_speed_upper > actual_speed_lower:
                    winner_info = "horse {} wins".format(
                        upper_horse.properties["horse_index"]
                    )
                elif actual_speed_lower > actual_speed_upper:
                    winner_info = "horse {} wins".format(
                        lower_horse.properties["horse_index"]
                    )

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
            race_cnt += 1

        print("Horses at rest:")
        for team in [self.team1, self.team2]:
            if team is self.team1:
                team_horse = team1_horse
            else:
                team_horse = team2_horse
            while True:
                if team_horse is not None:
                    team_horse.print_info()
                else:
                    break
                team_horse = team.get_next_horse()

        self.round_cnt += 1

    def check_winner(self):
        team1_defeated = True
        team2_defeated = True

        horse_list1 = self.team1.horse_list
        horse_list2 = self.team2.horse_list

        for i in range(len(horse_list1)):
            if not horse_list1[i].check_defeated():
                team1_defeated = False
                break

        for i in range(len(horse_list2)):
            if not horse_list2[i].check_defeated():
                team2_defeated = False
                break

        stop = False
        winner = 0
        if team1_defeated:
            stop = True
            winner = 2
            stop = True

        elif team2_defeated:
            winner = 1
            stop = True

        return stop, winner

    def play_game(self):
        horse_list_team1 = self.input_horses(1)
        horse_list_team2 = self.input_horses(2)

        team1 = Team(1)
        team2 = Team(2)
        team1.horse_list = horse_list_team1
        team2.horse_list = horse_list_team2

        self.set_teams(team1, team2)

        print("===========")
        print("Game Begins")
        print("===========\n")

        while True:
            print("\n===== Begin New Round =====")
            print("Team 1: please input order")
            while True:
                order1 = input().split(" ")
                order1 = [int(order) for order in order1]
                flag_valid = True
                undefeated_number = 0
                for order in order1:
                    if order not in range(1, 5):
                        flag_valid = False
                    elif self.team1.horse_list[order - 1].check_defeated():
                        flag_valid = False
                if len(order1) != len(set(order1)):
                    flag_valid = False
                for i in range(4):
                    if not self.team1.horse_list[i].check_defeated():
                        undefeated_number += 1
                if undefeated_number != len(order1):
                    flag_valid = False
                if flag_valid:
                    break
                else:
                    print("Invalid input order")

            print("Team 2: please input order")
            while True:
                order2 = input().split(" ")
                order2 = [int(order) for order in order2]
                flag_valid = True
                undefeated_number = 0
                for order in order2:
                    if order not in range(5, 9):
                        flag_valid = False
                    elif self.team2.horse_list[order - 1 - 4].check_defeated():
                        flag_valid = False
                if len(order2) != len(set(order2)):
                    flag_valid = False
                for i in range(4):
                    if not self.team2.horse_list[i].check_defeated():
                        undefeated_number += 1
                if undefeated_number != len(order2):
                    flag_valid = False
                if flag_valid:
                    break
                else:
                    print("Invalid input order")
            # TODO: remember pass order_ref instead of order in perl
            self.team1.set_order(order1)
            self.team2.set_order(order2)

            self.play_one_round()
            stop, winner = self.check_winner()
            if stop:
                break

        print("Team {} wins".format(winner))
