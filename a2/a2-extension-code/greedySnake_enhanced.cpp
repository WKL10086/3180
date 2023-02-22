#include<iostream>
#include <ctime>

using std::cout;
using std::string;
using std::endl;
using std::cin;


class Cell
{
public:
	virtual void generate(char ** board) = 0; // generate position
	virtual void display_info() = 0; // display information
};

class Food :public Cell   // define the class for food
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

	void generate(char ** board)
	{
		do
		{
			x = rand() % (x_max - 2) + 1;   // generate food inside a box
			y = rand() % (y_max - 2) + 1;
		} while (board[x][y] != ' ');
		board[x][y] = shape;
	}

	void display_info()
	{
		char* b = (char*)name.c_str();
		cout << "Name: " << b << '\t';
		cout << "Position: (" << x << ", " << y << ")" << endl;
	}
};

class Apple :public Food
{
	bool maturity;  // whether the apple is mature

public:
	Apple(int x_max_val = 0, int y_max_val = 0, bool maturity_val = false, string name_val = "None"):Food(x_max_val, y_max_val, 'o', "Apple")
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

	void generate(char ** board)
	{
		Food::generate(board);
		int index2 = rand() % 2;
		if (index2 == 0)
		{
			set_maturity(false);
		}
		else
		{
			set_maturity(true);
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

	void display_info()
	{
		Food::display_info();
		if (maturity)
		{
			cout << "Maturity: " << "True" << '\t';
		}
		else
			cout << "Maturity: " << "False" << '\t';
		cout << "Score: " << get_actual_score() << endl;
	}
};

class Water :public Food
{
	int volume;
public:
	Water(int x_max_val = 0, int y_max_val = 0, int volume_val = 1, string name_val = "None"):Food::Food(x_max_val, y_max_val, '!', "Water")
	{
		volume = volume_val;
		set_actual_score(base_score*volume);
	}

	int get_volume()
	{
		return volume;
	}
	void set_volume(int volume_val)
	{
		if (volume_val < 1 || volume_val > 5)
			cout << "The volume size can only be an interger between 1 and 5" << endl;
		else
			volume = volume_val;
	}

	void generate(char ** board)
	{
		Food::generate(board);
		int volume_val = rand() % 5 + 1;
		set_volume(volume_val);
		set_actual_score(base_score*volume);
	}

	void display_info()
	{
		Food::display_info();
		cout << "Volume: " << volume << '\t';
		cout << "Score: " << get_actual_score() << endl;
	}
};

class SnakeCatcher :public Cell
{
public:
	int x;
	int y;  // position, coordinates of the top-left corner
	int x_max;
	int y_max;
	int width;  // width of the active area
	char symbol;
	int score;
	bool is_clear;  // this is a flip value, can be False or True. It is true when the SnakeCatcher is not on the board.
public:
	SnakeCatcher(int x_max_val = 0, int y_max_val = 0, int width_val = 2)
	{
		x = 0;
		y = 0;
		x_max = x_max_val;
		y_max = y_max_val;
		width = width_val;  // 2*2
		symbol = 'x';
		score = -100;
		is_clear = false;
	}

	bool check_can_generate(char ** board)
	{
		bool can_generate = true;
		for (int i = 0; i < width; i++)
		{
			for (int j = 0; j < width; j++)
			{
				if (board[x + i][y + j] != ' ')
				{
					can_generate = false;
					break;
				}
			}
		}
		return can_generate;
	}

	void generate(char ** board)
	{
		do
		{
			x = rand() % (x_max - width - 1) + 1;   // generate food inside a bdox
			y = rand() % (y_max - width - 1) + 1;
		} while (!check_can_generate(board));
		for (int i = 0; i < width; i++)
		{
			for (int j = 0; j < width; j++)
			{
				board[x + i][y + j] = symbol;
			}
		}
		is_clear = false;
	}

	void clear(char ** board)
	{
		for (int i = 0; i < width; i++)
		{
			for (int j = 0; j < width; j++)
			{
				board[x + i][y + j] = ' ';
			}
		}
		is_clear = true;
	}

	void display_info()
	{
		cout << "Here is the snake catcher!" << '\t';
		cout << "Position: (" << x << ", " << y << ")" << endl;
	}
};

class Snake :public Cell
{
public:
	int max_len;   // max length of the snake
	int head;
	int tail;
	int score;
	int length;

	int **position;    // 2*max_len

public:
	Snake(int max_len_val = 15);
	~Snake();

	bool move(char ** board, int x_max, int y_max, Food *p_food, SnakeCatcher &catcher, char direction = 'd');

	void generate(char ** board)
	{
		for (int i = 1; i <= 3; i++)
			board[1][i] = '*';
		board[1][4] = '@';

		for (int i = 0; i<4; i++)
		{
			position[0][i] = 1;
			position[1][i] = i + 1;
		}
	}

	void display_info()
	{
		cout << "Current Score: " << score << '\t';
		cout << "Current Length: " << length << '\t';
		cout << endl;
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

	position = new int*[2];
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

bool Snake::move(char ** board, int x_max, int y_max, Food *p_food, SnakeCatcher &catcher, char direction)
{
	int x;
	int y;
	bool game_over = false;

	if (direction == 'w')  // up
	{
		x = position[0][head] - 1;
		y = position[1][head];
	}
	else if (direction == 's')  // down
	{
		x = position[0][head] + 1;
		y = position[1][head];
	}
	else if (direction == 'a')  // left
	{
		x = position[0][head];
		y = position[1][head] - 1;
	}
	else // right
	{
		x = position[0][head];
		y = position[1][head] + 1;
	}

	if (x == 0 || x == (x_max - 1) || y == 0 || y == (y_max - 1))  // move to the boundary -> die
	{
		game_over = true;
	}
	if (board[x][y] == '*') // come into itself
	{
		game_over = true;
	}
	if (x == p_food->get_x() && y == p_food->get_y())  // get the food
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
			score += p_food->get_actual_score();

			if (length >= max_len)
				game_over = true;
		}
		else
		{
			// game over when the length is no less than the maximum
			game_over = true;
		}
	}
	else if (board[x][y] == catcher.symbol)  // be caught by the snake catcher
	{
		score += catcher.score;  // reduce some score and move

										// remove the catcher
		catcher.clear(board);

		// move
		board[position[0][tail]][position[1][tail]] = ' ';
		tail = (tail + 1) % max_len;
		board[position[0][head]][position[1][head]] = '*';
		head = (head + 1) % max_len;
		position[0][head] = x;
		position[1][head] = y;
		board[position[0][head]][position[1][head]] = '@';
	}
	else  // regular move
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
	int y_max;  // the range of the board
	char ** board;

	// initialize food
	Apple apple;
	Water water;
	Cell *p_cell;
	Food *p_food;

	Snake snake;

	SnakeCatcher catcher;

	int count; // count how many steps the snake has moved
public:
	Environment(int x_max_val = 0, int y_max_val = 0);
	~Environment();

	int get_count()
	{
		return count;
	}

	void display();
	void display_forall(Cell *p);
	void generate(Cell *p_cell);

	void run();
	bool check_eaten();  // check whether the food has been eaten
	bool check_caught(); // check whether the snake has been caught
};

Environment::Environment(int x_max_val, int y_max_val)
{
	// initialize the board
	x_max = x_max_val;
	y_max = y_max_val;

	board = new char*[x_max];
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

	// initialize the snake catcher
	catcher.x_max = x_max_val;
	catcher.y_max = y_max_val;

	// initialize the snake
	// initialize the head position
	p_cell = &snake;
	generate(p_cell);

	// counting down
	cout << "\n\n\t\tThe game is about to begin!" << endl;
	for (int i = 3; i >= 0; i--)
	{
		long start = clock();
		while (clock() - start <= 1000);  // 1 s
										  
		if (i>0)
			cout << "\n\n\t\tCountdown:" << i << endl;
	}

	count = 0;
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

void Environment::display_forall(Cell *p)
{
	p->display_info();
}

void Environment::display()  // display all the information
{
	cout << endl;
	// display the board
	for (int i = 0; i<x_max; i++)
	{
		cout << "\t";
		for (int j = 0; j<y_max; j++)
			cout << board[i][j] << ' ';
		cout << endl;
	}

	// display other information
	Cell *p;

	// food
	p = p_food;
	display_forall(p);
	cout << endl;

	// catcher
	p = &catcher;
	display_forall(p);
	cout << endl;

	// snake
	p = &snake;
	display_forall(p);
}

void Environment::generate(Cell *p_cell)
{
	p_cell->generate(board);
}

void Environment::run()  // run the game
{
	bool game_over;
	// generate food
	int index = rand() % 2;
	if (index == 0)  // generate apple
	{
		p_cell = &apple;
		p_food = &apple;
	}
	else   // generate water
	{
		p_cell = &water;
		p_food = &water;
	}
	generate(p_cell);
	// generate catcher
	p_cell = &catcher;
	generate(p_cell);

	display();
	do
	{
		// choose a direction or move automatically
		char direction;
		cout << "\n\nPlease select the moving direction! (w : up, s : down, a: left, d: right)" << endl;
		cin >> direction;

		game_over = snake.move(board, x_max, y_max, p_food, catcher, direction);
		count++;
		// check whether the food is eaten
		if (check_eaten())
		{
			// generate food
			int index = rand() % 2;
			if (index == 0)  // generate apple
			{
				p_cell = &apple;
				p_food = &apple;
			}
			else   // generate water
			{
				p_cell = &water;
				p_food = &water;
			}
			generate(p_cell);
		}
		if (count == 20) // re-generate the catcher every 20 steps
		{
			count = 0;
			catcher.clear(board);
			// generate catcher
			p_cell = &catcher;
			generate(p_cell);
		}
		if (check_caught())  // or if the snake is caught
		{
			// generate catcher
			p_cell = &catcher;
			generate(p_cell);
			count = 0;
		}
		display();

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

bool Environment::check_eaten()
{
	int ** position = snake.position;
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

bool Environment::check_caught()
{
	return catcher.is_clear;
}

int main()
{
	srand(time(0));
	Environment env(22, 22);
	env.run();
}
