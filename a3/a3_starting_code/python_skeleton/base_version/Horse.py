class Horse:

    def __init__(self, horse_index, morale, speed, experience, rank):
        self.horse_index = int(horse_index)
        self.morale = int(morale)
        self.speed = int(speed)
        self.experience = int(experience)
        self.rank = int(rank)
        self.defeated = False

    @property
    def properties(self):
        return {
            "horse_index": self.horse_index,
            "morale": self.morale,
            "speed": self.speed,
            "experience": self.experience,
            "rank": self.rank,
            "defeated": self.defeated
        }

    def reduce_morale(self, damage):
        self.morale = self.morale - damage
        if self.morale <= 0:
            self.morale = 0
            self.defeated = True
        return

    def print_info(self):
        defeated_info = "defeated" if self.defeated else "undefeated"
        print("Horse {}: morale: {} speed: {} experience: {} rank: {} {}".format(self.horse_index, self.morale, self.speed, self.experience, self.rank, defeated_info))

    def check_defeated(self):
        return self.defeated



