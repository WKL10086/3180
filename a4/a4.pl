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
/* it should take 3 arguments in this order: A, B, and the ranking list */
/* [x] please implement the other facts for "more_popular" */
/* note that there may be other ways to implement this, please feel free to remove the example fact and re-implement the whole thing in your own way, as long as it works for the example queries */

more_popular(A,B,[A,B,_,_,_]). 
more_popular(A,B,[A,_,B,_,_]).
more_popular(A,B,[A,_,_,B,_]).
more_popular(A,B,[A,_,_,_,B]).
more_popular(A,B,[_,A,B,_,_]).
more_popular(A,B,[_,A,_,B,_]).
more_popular(A,B,[_,A,_,_,B]).
more_popular(A,B,[_,_,A,B,_]).
more_popular(A,B,[_,_,A,_,B]).
more_popular(A,B,[_,_,_,A,B]).

/* "less_popular" is a fact that A is less popular than B */
/* it should take 3 arguments in this order: A, B, and the ranking list */
/* [ ] please implement the other facts for "less_popular" */
/* note that there may be other ways to implement this, please feel free to remove the example fact and re-implement the whole thing in your own way, as long as it works for the example queries */

less_popular(A,B,[B,A,_,_,_]). 

/* [x] please implement facts for "most_popular", "almost_most_popular" and "medium_popular", "almost_least_popular", and "least_popular" */
/* it should take two arguments in this order: the student denoted by an unknown such as A, and the ranking list */

most_popular(A,[A,_,_,_,_]). 
almost_most_popular(A,[_,A,_,_,_]).
medium_popular(A,[_,_,A,_,_]).
almost_least_popular(A,[_,_,_,A,_]).
least_popular(A,[_,_,_,_,A]).

/* facts of rivals: the rivals mean a pair of students who have very close popularity - meaning their ranks differ by at most 1 */
/* it should take 3 arguments in this order: A, B, and the ranking list */
/* the first one has been given to you as an example */
/* [x] please implement the other facts for "rivals" */

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

/* [ ] please implement other parts of the body according to the facts given on the webpage  */
/* the first two are given to you as examples */
/* player(name, club, food, sport, music) */
this_year_ranking(Ranking) :-
more_popular(player(jack,_,chicken,_,_), player(rookie,killer_club,_,_,_), Ranking),
more_popular(player(scout,_,_,baseball,_), player(viper,_,_,_,jazzy), Ranking),
/* [ ] please implement the other parts of the rule body for "this_year_ranking" */


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
X=scout

query (find out all the information deduced by Prolog from your rules and facts about this year's ranking):
this_year_ranking(Ranking).
answer:
(we won't give you the answer for this one... try to deduce that yourself :))
*/


last_year_ranking(Ranking) :-
medium_popupar(player(viper,_,_,_,_), Ranking),
least_popular(player(ning,_,_,_,_), Ranking),
/* [ ] please implement the other parts of the rule body for "last_year_ranking" */


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

because we didn't provide that information (e.g. favourite food) when we wrote the last_year_ranking rule.

*/
