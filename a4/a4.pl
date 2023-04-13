/* submit this file
*
*
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
*
*/


/* the following "member" function is explained in the tutorial and given to you */
/* it checks if the first argument X is a list member of the second argument which is a list */
member(X,[X|_]). 
member(X,[_|L]) :- member(X,L).

/* "more_popular" is a fact that A is more popular than B */
/* [x] please implement the other facts for "more_popular" */
/* it should take 3 arguments in this order: A, B, and the ranking list */

% more_popular(A,B,[A,B,_,_,_]). 
% more_popular(A,B,[A,_,B,_,_]).
% more_popular(A,B,[A,_,_,B,_]).
% more_popular(A,B,[A,_,_,_,B]).
% more_popular(A,B,[_,A,B,_,_]).
% more_popular(A,B,[_,A,_,B,_]).
% more_popular(A,B,[_,A,_,_,B]).
% more_popular(A,B,[_,_,A,B,_]).
% more_popular(A,B,[_,_,A,_,B]).
% more_popular(A,B,[_,_,_,A,B]).

more_popular(A,B,[A|T]) :- member(B,T).
more_popular(A,B,[_|T]) :- more_popular(A,B,T).

/* "less_popular" is a fact that A is less popular than B */
/* [x] please implement the other facts for "less_popular" */
/* it should take 3 arguments in this order: A, B, and the ranking list */

% less_popular(A,B,[B,A,_,_,_]).
% less_popular(A,B,[B,_,A,_,_]).
% less_popular(A,B,[B,_,_,A,_]).
% less_popular(A,B,[B,_,_,_,A]).
% less_popular(A,B,[_,B,A,_,_]).
% less_popular(A,B,[_,B,_,A,_]).
% less_popular(A,B,[_,B,_,_,A]).
% less_popular(A,B,[_,_,B,A,_]).
% less_popular(A,B,[_,_,B,_,A]).
% less_popular(A,B,[_,_,_,B,A]).

less_popular(A,B,[B|T]) :- member(A,T).
less_popular(A,B,[_|T]) :- less_popular(A,B,T).

% TODO: dont know why this cause infinite loop
% less_popular(A,B,L) :- not(more_popular(A,B,L)).

/* [x] please implement facts for "most_popular", "almost_most_popular" and "medium_popular", "almost_least_popular", and "least_popular" */
/* it should take two arguments in this order: the student denoted by an unknown such as A, and the ranking list */

most_popular(A,[A,_,_,_,_]). 
almost_most_popular(A,[_,A,_,_,_]).
medium_popular(A,[_,_,A,_,_]).
almost_least_popular(A,[_,_,_,A,_]).
least_popular(A,[_,_,_,_,A]).

/* facts of rivals: the rivals mean a pair of students who have very close popularity - meaning their ranks differ by at most 1 */
/* [x] please implement the other facts for "rivals" */
/* it should take 3 arguments in this order: A, B, and the ranking list */

% rivals(A,B,[A,B,_,_,_]). 
% rivals(A,B,[B,A,_,_,_]).
% rivals(A,B,[_,A,B,_,_]).
% rivals(A,B,[_,B,A,_,_]).
% rivals(A,B,[_,_,A,B,_]).
% rivals(A,B,[_,_,B,A,_]).
% rivals(A,B,[_,_,_,A,B]).
% rivals(A,B,[_,_,_,B,A]).

rivals(A,B,[A,B|_]).
rivals(A,B,[B,A|_]).
rivals(A,B,[_|L]) :- rivals(A,B,L).

/* [x] please implement other parts of the body according to the facts given on the webpage  */
/* player(name,club,food,sport,music) */
this_year_ranking(Ranking) :-
more_popular(player(jack,_,chicken,_,_), player(rookie,killer_club,_,_,_), Ranking),
more_popular(player(scout,_,_,baseball,_), player(viper,_,_,_,jazz_music), Ranking),
almost_most_popular(player(_,_,_,_,pop_music), Ranking),
more_popular(player(_,_,_,_,pop_music), player(_,_,hamburger,baseball,_), Ranking),
less_popular(player(ning,_,hot_pot,_,_), player(_,royal_club,_,_,rock_music), Ranking),
less_popular(player(_,magic_club,_,_,_), player(_,_,_,swimming,jazz_music), Ranking),
most_popular(player(_,_,_,football,_), Ranking),
medium_popular(player(_,_,_,_,blues), Ranking),
least_popular(player(_,_,_,running,classical_music), Ranking),
almost_least_popular(player(_,_,chips,_,_), Ranking),
more_popular(player(_,_,chips,_,_), player(_,magic_club,hot_pot,_,_), Ranking),
less_popular(player(_,_,hamburger,_,_), player(_,_,bread,_,_), Ranking),
rivals(player(_,royal_club,_,_,rock_music), player(_,killer_club,_,_,_), Ranking),
more_popular(player(_,royal_club,_,_,rock_music), player(_,killer_club,_,_,_), Ranking),
rivals(player(_,_,_,baseball,blues), player(_,_,bread,basketball,_), Ranking),
less_popular(player(_,_,_,baseball,blues), player(_,_,bread,basketball,_), Ranking),
rivals(player(_,_,chips,swimming,_), player(_,elf_club,_,_,_), Ranking),
less_popular(player(_,_,chips,swimming,_), player(_,elf_club,_,_,_), Ranking),
rivals(player(_,knight_club,chips,_,_), player(_,_,_,running,classical_music), Ranking),
more_popular(player(_,knight_club,chips,_,_), player(_,_,_,running,classical_music), Ranking).


/* Testcases for self-testing:
query (who likes chicken?):
this_year_ranking(_Ranking), member(player(X,_,chicken,_,_), _Ranking).
answer:
X=jack

query (who is from knight_club?):
this_year_ranking(_Ranking), member(player(X,knight_club,_,_,_), _Ranking).
answer:
X=viper

query (who are the rival(s) of viper?):
this_year_ranking(_Ranking), rivals(player(viper,_,_,_,_),player(X,_,_,_,_),_Ranking).
answer:
X=ning;
X=scout

query (who are the rival(s) of the student who likes classical music?):
this_year_ranking(_Ranking), rivals(player(_,_,_,_,classical_music),player(X,_,_,_,_),_Ranking).
X = viper

query (who are the rival(s) of the player who comes from elf_club?):
this_year_ranking(_Ranking), rivals(player(_,elf_club,_,_,_),player(X,_,_,_,_),_Ranking).
answer:
X = rookie
X = viper

query (find out all the information deduced by Prolog from your rules and facts about this year's ranking):
this_year_ranking(Ranking).
answer:
Ranking = [
player(jack,royal_club,chicken,football,rock_music),
player(rookie,killer_club,bread,basketball,pop_music),
player(scout,elf_club,hamburger,baseball,blues),
player(viper,knight_club,chips,swimming,jazz_music),
player(ning,magic_club,hot_pot,running,classical_music)
]
*/


/* [x] please implement the other parts of the rule body for "last_year_ranking" */
last_year_ranking(Ranking) :-
medium_popular(player(viper,_,_,_,_), Ranking),
least_popular(player(ning,_,_,_,_), Ranking),
rivals(player(scout,_,_,_,_), player(jack,_,_,_,_), Ranking),
more_popular(player(scout,_,_,_,_), player(jack,_,_,_,_), Ranking),
more_popular(player(jack,_,_,_,_), player(viper,_,_,_,_), Ranking),
rivals(player(jack,_,_,_,_), player(viper,_,_,_,_), Ranking),
rivals(player(viper,_,_,_,_), player(rookie,_,_,_,_), Ranking),
less_popular(player(rookie,_,_,_,_), player(viper,_,_,_,_), Ranking),
rivals(player(rookie,_,_,_,_), player(ning,_,_,_,_), Ranking),
more_popular(player(rookie,_,_,_,_), player(ning,_,_,_,_), Ranking).


/* Testcases for self-testing:
query (Who was the most popular in last year?)
last_year_ranking(_Ranking),most_popular(player(X,_,_,_,_),_Ranking).
answer
X=scout

query (Who was the almost most popular in last year?)
last_year_ranking(_Ranking),almost_most_popular(player(X,_,_,_,_),_Ranking).
answer
X=jack

query (Who was the almost least popular in last year?)
last_year_ranking(_Ranking),almost_least_popular(player(X,_,_,_,_),_Ranking).
answer
X=rookie



Note that when we ask questions about the last year's ranking, we only care about the ranking, and NOT the personal information.

That is, you won't get a meaningful answer for this kind of queries:
last_year_ranking(_Ranking), member(player(X,_,chicken,_,_), _Ranking).
answer
X = scout
X = jack
X = viper
X = rookie
X = ning

because we didn't provide that information (e.g. favourite food) when we wrote the last_year_ranking rule.

*/
