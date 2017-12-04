:-  dynamic playerCard/4.
:-  dynamic dealerCard/4.
:-  dynamic cash/1.
:-  dynamic initialCash/1.

getCard(R,S,V,Random) :- random(1,53,Random), card(R,S,V,Random). 

intro :- write('Welcome to black jack!'),nl, 
         write('Play as long as you\'d like or until out of money.'),nl,
         write('How much money would you like to start with? '),nl.
                        
dealPlayerCard :- getCard(R,S,V,Random), 
                  not(playerCard(_,_,_,Random)) -> assertz(playerCard(R,S,V,Random)) ; 
                  dealPlayerCard.

dealDealerCard :- getCard(R,S,V,Random), 
                  not(dealerCard(_,_,_,Random)) -> assertz(dealerCard(R,S,V,Random)) ; 
                  dealDealerCard.

dealCards :- dealPlayerCard, dealDealerCard.

clearCards :- retract(playerCard(_,_,_,_)), retract(dealerCard(_,_,_,_)),fail.
clearCards.

oneGame :- clearCards, bet, playRound.

bet :- write('How much would you like to bet?'),nl,
       getBet,nl.
       
getBet :- readsentence(R1),!, cleanLine(R1,R),
          atomic_list_concat(R,S),
          atom_number(S,N),
          number(N), cash(C),
          N =< C -> asserta(bet(N)) ; 
          bet.

playRound :- dealCards, findall(V, playerCard(_,_,V,_), L),
                       sum_list(L,HandSum),
                       (HandSum < 22) -> hit_stand;
                       end_round. 

hit_stand :- printPlayerCards,nl,
              write('hit or stand?'),nl,
              readsentence(R1),!,
              cleanLine(R1,R),nl,
              R = [h,i,t] -> playRound;
              end_round.

cleanLine([F|L],R) :- F = [10] -> R = L;
                         R = [F|L].

end_round :- write('======================'),nl,
             once(playerWins; playerLoses),
             write('======================'),nl,nl,
             once(outOfCash ; play_again).

play_again :- write('Would you like to play another round?'),nl,
              write('yes or no?'),nl,
              readsentence(R1),!,nl,
              cleanLine(R1,R),
              answer(R).
              
outOfCash :- cash(0),
             write('You\'re all out of cash.'),nl,
             gameResults, nl.

answer([y,e,s]) :- oneGame, !.
answer([n,o]) :- write('Thank you for playing blackjack!'),nl,
                 gameResults.


gameResults :- write('======================'),nl,
               write('Final Results:'),nl,nl,
               write('  Started with $'), initialCash(Ic), write(Ic),nl,nl,
               write('  Finished with $'), cash(C), write(C),nl,
               write('======================'),nl,
               endMessage(Ic,C),
               retract(cash(_)), retract(initialCash(_)).


endMessage(Initial,End) :- Initial >= End -> 
                           write('Better luck next time...') ; 
                           write('It\'s your lucky day!'),
                           nl.

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

playerLoses :- write('You Lost.'), nl,nl,
               printPlayerCards, nl,
               printDealerCards, nl,
               cash(C), retract(cash(_)),
               bet(B), retract(bet(_)),
               C2 is C - B, asserta(cash(C2)),
               write('Cash: $'), write(C2),nl.

printPlayerCards :- write('Your Cards:'),nl,nl,
                    playerCard(R,S,_,_),
                    write('  '), write(R), write(' of '), write(S),nl,
                    fail.
printPlayerCards.


printDealerCards :- write('Dealer Cards:'),nl,nl,
                     dealerCard(R,S,_,_),
                     write('  '), write(R), write(' of '), write(S),nl,
                     fail.
printDealerCards.

getStartingCash :- readsentence(R),!, 
                   atomic_list_concat(R,S), 
                   atom_number(S,N), 
                   number(N), asserta(initialCash(N)), asserta(cash(N)).

blackjack :- intro, 
             getStartingCash,nl,
             oneGame.

