card(two,club,2,1).
card(three,club,3,2).
card(four,club,4,3).
card(five,club,5,4).
card(six,club,6,5).
card(seven,club,7,6).
card(eight,club,8,7).
card(nine,club,9,8).
card(ten,club,10,9).
card(jack,club,10,10).
card(queen,club,10,11).
card(king,club,10,12).
card(ace,club,10,13). 

card(two,heart,2,14).
card(three,heart,3,15).
card(four,heart,4,16).
card(five,heart,5,17).
card(six,heart,6,18).
card(seven,heart,7,19).
card(eight,heart,8,20).
card(nine,heart,9,21).
card(ten,heart,10,22).
card(jack,heart,10,23).
card(queen,heart,10,24).
card(king,heart,10,25).
card(ace,heart,10,26).

card(two,diamond,2,27).
card(three,diamond,3,28).
card(four,diamond,4,29).
card(five,diamond,5,30).
card(six,diamond,6,31).
card(seven,diamond,7,32).
card(eight,diamond,8,33).
card(nine,diamond,9,34).
card(ten,diamond,10,35).
card(jack,diamond,10,36).
card(queen,diamond,10,37).
card(king,diamond,10,38).
card(ace,diamond,10,39).

card(two,spade,2,40).
card(three,spade,3,41).
card(four,spade,4,42).
card(five,spade,5,43).
card(six,spade,6,44).
card(seven,spade,7,45).
card(eight,spade,8,46).
card(nine,spade,9,47).
card(ten,spade,10,48).
card(jack,spade,10,49).
card(queen,spade,10,50).
card(king,spade,10,51).
card(ace,spade,10,52).



%getCard :- random(1,53,Random), card(R,V,Random), write(R), nl, write(V).







