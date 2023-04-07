from base_version.Horse import Horse

coins_to_obtain = 20
delta_speed = -1
delta_experience = 0
delta_rank = -1


class AdvancedHorse(Horse):
    def __init__(self, horse_index, morale, speed, experience, rank):
        # [x] Your Implementation Starts Here
        self.horse_index = int(horse_index)
        self.morale = int(morale)
        self.speed = int(speed)
        self.experience = int(experience)
        self.rank = int(rank)
        self.defeated = False
        self.coins = 0
        self.history_record = []

    def obtain_coins(self, coins_to_obtain=coins_to_obtain):
        # [x] Your Implementation Starts Here
        self.coins += coins_to_obtain

    def buy_prop_upgrade(self):
        # [x] Your Implementation Starts Here
        while self.coins >= 50:
            print(
                "Do you want to upgrade properties for Horse {}? S for speed. E for experience. R for rank. N for nothing.".format(
                    self.horse_index
                )
            )

            user_input = input()

            if user_input == "N":
                break

            self.coins -= 50
            if user_input == "S":
                self.speed += 1
            elif user_input == "E":
                self.experience += 1
            elif user_input == "R":
                self.rank += 1

    def record_race(self, race_result):
        # [x] Your Implementation Starts Here
        if len(self.history_record) < 3:
            self.history_record.append(race_result)
        else:
            self.history_record.pop(0)
            self.history_record.append(race_result)

    def update_properties(
        self,
        delta_speed=delta_speed,
        delta_experience=delta_experience,
        delta_rank=delta_rank,
    ):
        # [x] Your Implementation Starts Here
        self.speed = max(delta_speed + self.speed, 1)
        self.experience = max(delta_experience + self.experience, 1)
        self.rank = max(delta_rank + self.rank, 1)

    def recover_morale(self, recover):
        # [x] Your Implementation Starts Here
        self.morale += recover

    def check_consecutive_winner(self):
        # [x] Your Implementation Starts Here
        consecutive_winner = False
        if len(self.history_record) == 3:
            if (
                self.history_record[0] == "win"
                and self.history_record[1] == "win"
                and self.history_record[2] == "win"
            ):
                consecutive_winner = True
                self.history_record = []
        return consecutive_winner

    def check_consecutive_loser(self):
        # [x] Your Implementation Starts Here
        consecutive_loser = False
        if len(self.history_record) == 3:
            if (
                self.history_record[0] == "lose"
                and self.history_record[1] == "lose"
                and self.history_record[2] == "lose"
            ):
                consecutive_loser = True
                self.history_record = []
        return consecutive_loser
