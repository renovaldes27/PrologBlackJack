:-  dynamic playerCard/4.
:-  dynamic dealerCard/4.
:-  dynamic cash/1.
:-  dynamic initialCash/1.
:-  dynamic bet/1.

% predicate used for getting a random card from a standard
% deck of 52 cards.
getCard(R,S,V,Random) :- random(1,53,Random), card(R,S,V,Random). 

% Intro only called at the start of blackjack.
% Just a welcome message.
intro :- write('Welcome to black jack!'),nl, 
         write('Play as long as you\'d like or until out of money.'),nl,
         write('How much money would you like to start with? '),nl.

% predicate used for getting a new card and adding
% it to the current playerCards. Only adds cards
% that are not currently in the players hand.
dealPlayerCard :- getCard(R,S,V,Random), 
                  not(playerCard(_,_,_,Random)) -> assertz(playerCard(R,S,V,Random)) ; 
                  dealPlayerCard.

% predicate used for getting a new card and adding
% it to the current dealerCards. Only adds cards
% that are not currently in the dealers hand.
dealDealerCard :- getCard(R,S,V,Random), 
                  not(dealerCard(_,_,_,Random)) -> assertz(dealerCard(R,S,V,Random)) ; 
                  dealDealerCard.

% predicate used to deal a single playerCard and dealerCard.
dealCards :- dealPlayerCard, dealDealerCard.

% predicate used to clear all playerCards and dealerCards after 
% playing a round.
clearCards :- retract(playerCard(_,_,_,_)), retract(dealerCard(_,_,_,_)),fail.
clearCards.

% predicate used to play one game, includes
% betting along with the actual playRound call.
% Called when a new round should be started.
oneGame :- clearCards, bet, playRound.

% main predicate called for taking a players bet at the start
% of a round. Outputs bet statement and calls
% getBet predicate which takes the actual input.
bet :- write('How much would you like to bet?'),nl,
       getBet,nl.

% predicate used for taking a players bet at the start of a round.
% If a bet entered is greater than players cash then
% the user is prompted again.
getBet :- readsentence(R1),!, cleanLine(R1,R),
          atomic_list_concat(R,S),
          atom_number(S,N),
          number(N), cash(C),
          N =< C -> asserta(bet(N)) ; 
          bet.

% predicate called at the start of a new round to start the actual
% gameplay. Allows player to hit/stand
% if possible, or they bust and lose.
playRound :- dealCards, findall(V, playerCard(_,_,V,_), L),
                       sum_list(L,HandSum),
                       (HandSum < 22) -> hit_stand;
                       end_round. 

% predicate used in gameplay to see if a player wants
% to hit/stand. If the player says
% hit then they will recieve another round of cards,
% otherwise the round is over.
hit_stand :- printPlayerCards,nl,
              write('hit or stand?'),nl,
              readsentence(R1),!,
              cleanLine(R1,R),nl,
              R = [h,i,t] -> playRound;
              end_round.

% predicate used for stripping the extra \n from input read.
% Only called as a helper function when taking user input.
cleanLine([F|L],R) :- F = [10] -> R = L;
                         R = [F|L].

% predicate called to bring a round to the end.
% Checks to see who the winner of the round is
% and also checks to see if the user would like to
% play another game.
end_round :- write('======================'),nl,
             once(playerWins; playerLoses),
             write('======================'),nl,nl,
             once(outOfCash ; play_again).

% predicate used to check if the user would like to play another game
% of blackjack. Only called if the user still has cash left.
play_again :- write('Would you like to play another round?'),nl,
              write('yes or no?'),nl,
              readsentence(R1),!,nl,
              cleanLine(R1,R),
              once(answer(R) ; play_again).

% predicate used to check if a user is out of cash.
% If true then the entire game is over and results 
% are output.
outOfCash :- cash(0),
             write('You\'re all out of cash.'),nl,
             gameResults, nl.

% predicate used to check the answer the user
% input in the play_again predicate.
answer([y,e,s]) :- oneGame, !.
answer([n,o]) :- write('Thank you for playing blackjack!'),nl,
                 gameResults.

% predicate called at the conclusion of the main game
% to output the final results. Outputs the users
% starting cash and ending cash along
% with a message that changes depending on their 
% winnings.
gameResults :- write('======================'),nl,
               write('Final Results:'),nl,nl,
               write('  Started with $'), initialCash(Ic), write(Ic),nl,nl,
               write('  Finished with $'), cash(C), write(C),nl,
               write('======================'),nl,
               endMessage(Ic,C),
               retract(cash(_)), retract(initialCash(_)).

% predicate used to output the appropriate
% end messgae if the user won/lost cash.
endMessage(Initial,End) :- Initial >= End -> 
                           write('Better luck next time...') ; 
                           write('It\'s your lucky day!'),
                           nl.
% predicate that only matches if the player wins the current round.
% If the player wins then their bet is added onto their current cash.
% Player wins if:
%                - Total sum of cards is 21.
%                - Dealer busts.
%                - Neither busts but playerSum > dealerSum
%                
playerWins :- findall(V1, playerCard(_,_,V1,_), L1),
              sum_list(L1, PlayerSum),
              findall(V2, dealerCard(_,_,V2,_), L2),
              sum_list(L2,DealerSum), 
              once(DealerSum > 21 ; 21 is PlayerSum ; PlayerSum > DealerSum),
              PlayerSum < 22,
              write('You Won!'),nl,nl,
              printPlayerCards,nl,
              printDealerCards,nl,
              cash(C), retract(cash(_)),
              bet(B), retract(bet(_)),
              C2 is C + B, asserta(cash(C2)),
              write('Cash: $'), write(C2),nl.

% predicate that is called if the user loses.
% Subtracts the user's bet from their current cash.
playerLoses :- write('You Lost.'), nl,nl,
               printPlayerCards, nl,
               printDealerCards, nl,
               cash(C), retract(cash(_)),
               bet(B), retract(bet(_)),
               C2 is C - B, asserta(cash(C2)),
               write('Cash: $'), write(C2),nl.

% predicate used to format and output the users
% current cards.
printPlayerCards :- write('Your Cards:'),nl,nl,
                    playerCard(R,S,_,_),
                    write('  '), write(R), write(' of '), write(S),nl,
                    fail.
printPlayerCards.

% predicate used to format and output the current dealer
% cards.
printDealerCards :- write('Dealer Cards:'),nl,nl,
                     dealerCard(R,S,_,_),
                     write('  '), write(R), write(' of '), write(S),nl,
                     fail.
printDealerCards.

% predicate used to get the user's initial cash at the start of
% a new main game.
getStartingCash :- readsentence(R),!, 
                   atomic_list_concat(R,S), 
                   atom_number(S,N), 
                   number(N), asserta(initialCash(N)), asserta(cash(N)).

% MAIN PREDICATE.
% Called to start the game.
% Starts a chain of calls that will only end when
% the user is out of cash or decides
% to quit.
blackjack :- intro, 
             getStartingCash,nl,
             oneGame.

