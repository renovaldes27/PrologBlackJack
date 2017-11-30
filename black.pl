:-  dynamic playerCard/4.
:-  dynamic dealerCard/4.

getCard(R,S,V,Random) :- random(1,53,Random), card(R,S,V,Random). 



intro :- write('Welcome to black jack!'),nl, 
         write('Play as long as you\'d like or until out of money.'),nl,
         write('Are you ready to begin? '),nl.


blackJack :- intro, readsentence(R), 
             R = [y,e,s] -> write('place holder'); 
                            write('Thank you for playing BlackJack.'), nl.                        

                        
dealPlayerCard :- getCard(R,S,V,Random), not(playerCard(_,_,_,Random)) -> assertz(playerCard(R,S,V,Random)) ; dealPlayerCard.
dealDealerCard :- getCard(R,S,V,Random), not(dealerCard(_,_,_,Random)) -> assertz(dealerCard(R,S,V,Random)) ; dealDealerCard.

dealCards :- dealPlayerCard, dealDealerCard.

clearCards :- retract(playerCard(_,_,_,_)), retract(dealerCard(_,_,_,_)),fail.
clearCards.
