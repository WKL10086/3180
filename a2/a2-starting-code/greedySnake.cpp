
#include <iostream>
#include <ctime>

using std::cin;
using std::cout;
using std::endl;
using std::string;

class Food // define the class for food
{
	// position for the food
	int x;
	int y;
	// maximum range for the position
	int x_max;
	int y_max;
	char shape;
	string name;
	int actual_score;

protected:
	int base_score;

public:
	Food(int x_max_val = 0, int y_max_val = 0, char shape_val = '$', string name_val = "None", int base_score_val = 100)
	{
		// initialize the maximum range
		x = 0;
		y = 0;
		x_max = x_max_val;
		y_max = y_max_val;
		base_score = base_score_val;
		shape = shape_val;
		name = name_val;
		actual_score = base_score;
	}
	// get and set attributes
	int get_x()
	{
		return x;
	}
	void set_x(int x_val)
	{
		x = x_val;
	}

	int get_y()
	{
		return y;
	}
	void set_y(int y_val)
	{
		y = y_val;
	}

	int get_xmax()
	{
		return x_max;
	}
	void set_xmax(int x_max_val)
	{
		x_max = x_max_val;
	}

	int get_ymax()
	{
		return y_max;
	}
	void set_ymax(int y_max_val)
	{
		y_max = y_max_val;
	}

	int get_actual_score()
	{
		return actual_score;
	}
	void set_actual_score(int actual_score_val)
	{
		actual_score = actual_score_val;
	}

	virtual void generate(char **board)
	{
		do
		{
			x = rand() % (x_max - 2) + 1; // generate food inside a box
			y = rand() % (y_max - 2) + 1;
		} while (board[x][y] != ' ');
		board[x][y] = shape;
	}
};

class Apple : public Food
{
	bool maturity; // whether the apple is mature

public:
	Apple(int x_max_val = 0, int y_max_val = 0, bool maturity_val = false, string name_val = "None") : Food(x_max_val, y_max_val, 'o', "Apple")
	{
		maturity = maturity_val;
		if (maturity)
			set_actual_score(base_score);
		else
			set_actual_score(0);
	}
	// get and set attributes
	bool get_maturity()
	{
		return maturity;
	}
	void set_maturity(bool maturity_val)
	{
		maturity = maturity_val;
	}

	void generate(char **board)
	{
		Food::generate(board);
		int index2 = rand() % 2;
		if (index2 == 0)
		{
			maturity = false;
		}
		else
		{
			maturity = true;
		}

		if (maturity)
		{
			set_actual_score(base_score);
		}
		else
		{
			set_actual_score(0);
		}
	}
};

class Water : public Food
{
	int volume;

public:
	Water(int x_max_val = 0, int y_max_val = 0, int volume_val = 1, string name_val = "None") : Food::Food(x_max_val, y_max_val, '!', "Water")
	{
		volume = volume_val;
		set_actual_score(base_score * volume);
	}

	int get_volume()
	{
		return volume;
	}
	void set_volume(int volume_val)
	{
		if (volume_val < 1 || volume_val > 5)
			cout << "The volume size can only be an integer between 1 and 5" << endl;
		else
			volume = volume_val;
	}

	void generate(char **board)
	{
		Food::generate(board);
		int volume_val = rand() % 5 + 1;
		set_volume(volume_val);
		set_actual_score(base_score * volume);
	}
};

class Snake
{
public:
	int max_len; // max length of the snake
	int head;
	int tail;
	int score;
	int length;

	int **position; // 2*max_len

public:
	Snake(int max_len_val = 15);
	~Snake();

	bool move(char **board, int x_max, int y_max, Food *p_food, char direction = 'd');

	void generate(char **board)
	{
		for (int i = 1; i <= 3; i++)
			board[1][i] = '*';
		board[1][4] = '@';

		for (int i = 0; i < 4; i++)
		{
			position[0][i] = 1;
			position[1][i] = i + 1;
		}
	}
};

Snake::Snake(int max_len_val)
{
	// initialization
	max_len = max_len_val;
	head = 3;
	tail = 0;
	score = 0;
	length = 4;

	position = new int *[2];
	for (int i = 0; i < 2; i++)
	{
		position[i] = new int[max_len];
	}
}

Snake::~Snake()
{
	// memory deallocation for position
	for (int i = 0; i < 2; i++)
	{
		delete[] position[i];
	}
	delete[] position;
	position = nullptr;
}

bool Snake::move(char **board, int x_max, int y_max, Food *p_food, char direction)
{
	int x;
	int y;
	bool game_over = false;

	if (direction == 'w') // up
	{
		x = position[0][head] - 1;
		y = position[1][head];
	}
	else if (direction == 's') // down
	{
		x = position[0][head] + 1;
		y = position[1][head];
	}
	else if (direction == 'a') // left
	{
		x = position[0][head];
		y = position[1][head] - 1;
	}
	else // right
	{
		x = position[0][head];
		y = position[1][head] + 1;
	}

	if (x == 0 || x == (x_max - 1) || y == 0 || y == (y_max - 1)) // move to the boundary -> die
	{
		game_over = true;
	}
	if (board[x][y] != ' ' && !(x == p_food->get_x() && y == p_food->get_y())) // come into itself
	{
		game_over = true;
	}
	if (x == p_food->get_x() && y == p_food->get_y()) // get the food
	{
		if (length < max_len) // only when the length is smaller than the maximum, we increase the snake length
		{
			length++;
			// move one step
			board[x][y] = '@';
			board[position[0][head]][position[1][head]] = '*';
			head = (head + 1) % max_len;
			position[0][head] = x;
			position[1][head] = y;
			score = score + p_food->get_actual_score();

			if (length >= max_len)
				game_over = true;
		}
		else
		{
			// game over when the length is no less than the maximum
			game_over = true;
		}
	}
	else // regular move
	{
		board[position[0][tail]][position[1][tail]] = ' ';
		tail = (tail + 1) % max_len;
		board[position[0][head]][position[1][head]] = '*';
		head = (head + 1) % max_len;
		position[0][head] = x;
		position[1][head] = y;
		board[position[0][head]][position[1][head]] = '@';
	}

	return game_over;
}

class Environment
{
	int x_max;
	int y_max; // the range of the board
	char **board;

	// initialize food
	Apple apple;
	Water water;
	Food *p_food;

	Snake snake;

public:
	Environment(int x_max_val = 0, int y_max_val = 0);
	~Environment();

	void display(int score);
	void generate(Food *p_food);

	void run();
	bool check_eaten(); // check whether the food has been eaten
};

Environment::Environment(int x_max_val, int y_max_val)
{
	// initialize the board
	x_max = x_max_val;
	y_max = y_max_val;

	board = new char *[x_max];
	for (int i = 0; i < x_max; i++)
	{
		board[i] = new char[y_max];
	}
	for (int i = 1; i <= x_max - 2; i++)
		for (int j = 1; j <= y_max - 2; j++)
			board[i][j] = ' ';

	for (int i = 0; i < y_max; i++)
		board[0][i] = board[x_max - 1][i] = '#';
	for (int i = 1; i < x_max - 1; i++)
		board[i][0] = board[i][y_max - 1] = '#';

	// initialize the food
	apple.set_xmax(x_max_val);
	apple.set_ymax(y_max_val);

	water.set_xmax(x_max_val);
	water.set_ymax(y_max_val);

	// initialize the snake
	// initialize the head position
	snake.generate(board);

	// counting down
	cout << "\n\n\t\tThe game is about to begin!" << endl;
	for (int i = 3; i >= 0; i--)
	{
		long start = clock();
		while (clock() - start <= 1000)
			; // 1 s

		if (i > 0)
			cout << "\n\n\t\tCountdown:" << i << endl;
	}
}

Environment::~Environment()
{
	// memory deallocation for board
	for (int i = 0; i < x_max; i++)
	{
		delete[] board[i];
	}
	delete[] board;
	board = nullptr;
}

void Environment::display(int score) // display all the information
{
	cout << endl;
	for (int i = 0; i < x_max; i++)
	{
		cout << "\t";
		for (int j = 0; j < y_max; j++)
			cout << board[i][j] << ' ';
		if (i == 2)
			cout << "\tScore:" << score;
		cout << endl;
	}
}

void Environment::generate(Food *p_food)
{
	p_food->generate(board);
}

void Environment::run() // run the game
{
	bool game_over;
	// generate food
	int index = rand() % 2;
	if (index == 0) // generate apple
	{
		p_food = &apple;
	}
	else // generate water
	{
		p_food = &water;
	}
	generate(p_food);

	display(snake.score);
	do
	{
		// choose a direction
		char direction;
		cout << "\n\nPlease select the moving direction! (w : up, s : down, a: left, d: right)" << endl;
		cin >> direction;

		game_over = snake.move(board, x_max, y_max, p_food, direction);
		// check whether the food is eaten
		if (check_eaten())
		{
			// generate food
			int index = rand() % 2;
			if (index == 0) // generate apple
			{
				p_food = &apple;
			}
			else // generate water
			{
				p_food = &water;
			}
			generate(p_food);
		}
		display(snake.score);

	} while (!game_over);
	if (game_over)
	{
		cout << "Game over!" << endl;
		cout << "Your final score is: " << snake.score << endl;
		if (snake.length >= snake.max_len)
		{
			cout << "Congratulations! You successfully grow up." << endl;
		}
		else
		{
			cout << "Sad! You die before growing up." << endl;
		}
	}
}

bool Environment::check_eaten() // check whether the food has been eaten
{
	int **position = snake.position;
	int head = snake.head;
	if (position[0][head] == p_food->get_x() && position[1][head] == p_food->get_y())
	{
		return true;
	}
	else
	{
		return false;
	}
}

int main()
{
	srand(time(0));
	Environment env(22, 22);
	env.run();
}