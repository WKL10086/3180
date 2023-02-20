import time
import random

class Food(): # define the class for food
    def __init__(self, x_max_val = 0, y_max_val = 0, shape_val = '$', name_val = "None", base_score_val = 100):
        self._x = 0   # This is the position for the food.
        self._y = 0
        self._x_max = x_max_val # initialize the maximum range
        self._y_max = y_max_val
        self._base_score = base_score_val
        self._shape = shape_val
        self._name = name_val
        self._actual_score = self._base_score

    # TODO: add Property Decorator for attributes self._x, self._y, self._x_max, self._y_max, self._shape and self._actual_score here, including setter.
    
    def generate(self, board): # generate food inside a box
        while True:
            self.x = random.randint(0, self.x_max - 3) + 1
            self.y = random.randint(0, self.y_max - 3) + 1
            if board[self.x][self.y] == ' ':
                break
        board[self.x][self.y] = self.shape
    
    def display_info(self):
        out = "Name: " + self._name + "\t"
        out = out + "Position: ({}, {})".format(self.x, self.y)
        print(out)
    
class Apple(Food):
    def __init__(self, x_max_val = 0, y_max_val = 0, maturity_val = False, name_val = "None"):
        super().__init__(x_max_val, y_max_val, 'o', "Apple")
        self._maturity = maturity_val # whether the apple is mature
        if self._maturity:
            self.actual_score = self._base_score
        else:
            self.actual_score = 0

    # TODO: add Property Decorator for self._maturity here, including the setter.
    
    
    def generate(self, board):
        super().generate(board)
        index2 = random.randint(0, 1)
        # TODO: Implement generation here
        # if index2 equals 0, set self._maturity as False; Otherwise, set it as True. self.actual_score should also be updated.
        
        
    
    def display_info(self):
        super().display_info()
        if self.maturity:
            out = "Maturity: " + "True" + "\t"
        else:
            out = "Maturity: " + "False" + "\t"
        out = out + "Score: {}".format(self.actual_score)
        print(out)

class Water(Food):
    def __init__(self, x_max_val = 0, y_max_val = 0, volume_val = 1, name_val = "None"):
        super().__init__(x_max_val, y_max_val, '!', "Water")
        self._volume = volume_val
        self._actual_score = self._base_score * self.volume
        
    # TODO: add Property Decorator for self._volume here, including the setter.

    
    def generate(self, board):
        super().generate(board)
        
        volume_val = random.randint(1, 5)
        
        # TODO: Implement generation here
        
    
    def display_info(self):
        super().display_info()
        out = "Volume: {}".format(self.volume) + "\t"
        out = out + "Score: {}".format(self.actual_score)
        print(out)

class SnakeCatcher():
    def __init__(self, x_max_val = 0, y_max_val = 0, width_val = 2):
        self.x = 0
        self.y = 0  # position, coordinates of the top-left corner
        self.x_max = x_max_val
        self.y_max = y_max_val
        self.width = width_val   # width of the active area
        self.symbol = 'x'
        self.score = -100
        self.is_clear = False    # this is a flip value, can be False or True. It is true when the SnakeCatcher is not on the board.
    
    def check_can_generate(self, board):
        # TODO: Implement the checking here

    
    def generate(self, board):
        while True:
            self.x = random.randint(0, self.x_max - self.width - 2) + 1
            self.y = random.randint(0, self.y_max - self.width - 2) + 1
            if (self.check_can_generate(board)):
                break
        
        # TODO: implement the updating of board and self.is_clear here
        
    
    def clear(self, board):
        # TODO: implement the clearing here
        
    
    def display_info(self):
        out = "Here is the snake catcher!\t"
        out = out + "Position: ({}, {})".format(self.x, self.y)
        print(out)

class Snake():
    def __init__(self, max_len_val=15):
        self.max_len = max_len_val # max length of the snake
        self.head = 3
        self.tail = 0
        self.score = 0
        self.length = 4
        
        self.position  = [[1] * self.max_len for i in range(2)]
    
    def display_info(self):
        out = "Current Score: {}".format(self.score) + "\t"
        out = out + "Current Length: {}\t".format(self.length)
        print(out)
    
    def move(self, board, x_max, y_max, food, catcher, direction):
        game_over = False
        
        # TODO: implement moving according to the direction and the judgement of whether the game is over here
        # (x, y) is the position of the head after one movement


        if x == 0 or x == (x_max - 1) or y == 0 or y == (y_max - 1): # move to the boundary -> die
            # TODO: implement the judgement of whether the game is over 
            

        if board[x][y] == '*': # come into itself
            # TODO: implement the judgement of whether the game is over 
            

        if x==food.x and y == food.y: # get the food
            # TODO: implement the preprocessing details here
            
                
        elif board[x][y] == catcher.symbol: # be caught by the snake catcher
            # TODO: Implement the processing here
                    
            
        else: # regular move
            # TODO: implement the regular move here
            

        return game_over

    def generate(self, board):
        # TODO: initialize the snake position here
        

class Environment():
    def __init__(self, x_max_val = 0, y_max_val = 0):
        self.x_max = x_max_val  # the range of the board
        self.y_max = y_max_val
        
        self.board = [[' '] * y_max_val for i in range(x_max_val)]
        for i in range(0, self.y_max):
            self.board[0][i] = '#'
            self.board[self.x_max-1][i] = '#'
        for i in range(1, self.x_max-1):
            self.board[i][0] = '#'
            self.board[i][self.y_max-1] = '#'

        self.apple = Apple()
        self.water = Water()
        
        self.apple.x_max = x_max_val
        self.apple.y_max = y_max_val
        
        self.water.x_max = x_max_val
        self.water.y_max = y_max_val
        
        self.food = None
        
        self.catcher = SnakeCatcher()
        self.catcher.x_max = x_max_val
        self.catcher.y_max = y_max_val
        
        self.snake = Snake()
        self.generate(self.snake)
        self.count = 0 # count how many steps the snake has moved
        
        # counting down
        print("\n\n\t\tThe game is about to begin!")
        for i in range(3,-1,-1):
            start = time.time()
            while (time.time()-start)<=1:
                nothing = 0
            if (i > 0):
                print("\n\n\t\tCountdown:",i) 
            
    def display_forall(self, obj):
        obj.display_info()
        
    def display(self):
        print("\n")
        for i in range(0, self.x_max):
            out = "\t"
            for j in range(0, self.y_max):
                out = out + self.board[i][j] + " "
            print(out)
        
        # display other information
        # food
        self.display_forall(self.food)
        print("\n")
        
        # catcher
        self.display_forall(self.catcher)
        print("\n")
        
        # snake
        self.display_forall(self.snake)

    def generate(self, obj):
        obj.generate(self.board)
    
    def run(self):
        
        index = random.randint(0, 1)
        # TODO: implement the food generation here using self.generate
        # if index equals 0, generate apple; Otherwise, generate water

        if index == 0:   # generate apple
            self.food = 
        else:   # generate water
            self.food = 

        self.generate(self.food) # generate food
        
        self.generate(self.catcher) # generate catcher

        self.display()
        while True:
            # choose a direction
            print("\n\nPlease select the moving direction! (w : up, s : down, a: left, d: right)")
            direction = input()
            game_over = self.snake.move(self.board, self.x_max, self.y_max, self.food, self.catcher, direction)
            self.count += 1
            # check whether the food is eaten
            if self.check_eaten():
                index = random.randint(0, 1)
                # TODO: implement the food generation here using self.generate
                # if index equals 0, generate apple; Otherwise, generate water

                if index == 0:  # generate apple
                    self.food = 
                else:  # generate water
                    self.food = 
                self.generate(self.food)
            
            if self.count == 20: # re-generate the catcher every 20 steps
                self.count = 0
                self.catcher.clear(self.board)
                # generate catcher
                self.generate(self.catcher)
            
            if (self.check_caught()): # or if the snake is caught
                self.generate(self.catcher)
                self.count = 0
            
            self.display()
            
            if game_over:
                print("Game over!")
                print("Your final score is: ", self.snake.score)
                if self.snake.length >= self.snake.max_len:
                    print("Congratulations! You successfully grow up.")
                else:
                    print("Sad! You die before growing up.")
                break
        
    def check_eaten(self): # check whether the food has been eaten
        # TODO: implement the checking process here
        
    
    def check_caught(self,):
        # TODO: Implement the checking here
        

if __name__ == "__main__":
    random.seed(1337)
    env = Environment(22, 22)
    env.run()