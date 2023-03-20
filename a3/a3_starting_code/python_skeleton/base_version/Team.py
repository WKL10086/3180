class Team:

    def __init__(self, team_index):
        self.team_index = team_index
        self.horse_list = None
        self.order = None
        # previous index of the order
        self.race_cnt = 0

    @property
    def horse_list(self):
        return self._horse_list

    @horse_list.setter
    def horse_list(self, horse_list):
        self._horse_list = horse_list

    def set_order(self, order):
        self.order = []
        for a_order in order:
            self.order.append(int(a_order))
        self.race_cnt = 0

    def get_next_horse(self):
        if self.race_cnt >= len(self.order):
            return None
        prev_horse_idx = self.order[self.race_cnt]
        horse = None
        for _horse in self.horse_list:
            if _horse.properties["horse_index"] == prev_horse_idx:
                horse = _horse
                break
        self.race_cnt += 1
        return horse
