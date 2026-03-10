% murderer
murderer(X) :- motive(X), access(X).

% murder weapon
murder_weapon(X, 'cowpatties') :- murderer(X), 
			    	  whereabouts(X, thursday, havener);
				  whereabouts(X, wednesday, library).

murder_weapon(X, 'tolietseat') :- murderer(X), 
			          whereabouts(X, wednesday, csbuilding);
				  whereabouts(X, thursday, csbuilding).	

% murder motive
murder_motive(X, 'jealous') :- murderer(X), jealous(X, leopold).
murder_motive(X, 'insane') :- murderer(X), insane(X).
murder_motive(X, 'poor') :- murderer(X), poor(X).

% access
access(X) :- weapon_access(X),
	     key_access(X),
             crime_access(X).

% cow patties
weapon_access(X) :- whereabouts(X, thursday, havener).
weapon_access(X) :- whereabouts(X, wednesday, library).

% toliet seats
weapon_access(X) :- whereabouts(X, wednesday, csbuilding).
weapon_access(X) :- whereabouts(X, thursday, csbuilding).

% key access
key_access(X) :- whereabouts(X, monday, library).
key_access(X) :- whereabouts(X, tuesday, havener).
key_access(davis). 

% crime scene access
crime_access(X) :- whereabouts(X, thursday, csbuilding).
crime_access(X) :- whereabouts(X, friday, csbuilding).

% victim
victim(leopold).

% insane
insane(tauritz).
insane(lin).

% poor
poor(price).
poor(mentis).
poor(lin).
poor(davis).
 
% jealous
jealous(X, Y) :- involved_with(Z, X), involved_with(Z, Y), \+ X==Y.

% involved with
involved_with(X, Y) :- involved(X, Y).
involved_with(X, Y) :- involved(Y, X).

% motive
motive(X) :- insane(X).
motive(X) :- poor(X).
motive(X) :- jealous(X, leopold).

% involved
involved(leopold, price).
involved(price, grayson).
involved(leopold, mentis).
involved(mentis, cheng).
involved(cheng, ercal).
involved(ercal, lin).
involved(tauritz, lin).
involved(tauritz, grayson).

% whereabouts
whereabouts(mentis, monday, library). 
whereabouts(mentis, tuesday, library). 
whereabouts(mentis, wednesday, havener). 
whereabouts(mentis, thursday, library). 
whereabouts(mentis, friday, csbuilding). 

whereabouts(grayson, monday, havener). 
whereabouts(grayson, tuesday, havener). 
whereabouts(grayson, wednesday, havener). 
whereabouts(grayson, thursday, library). 
whereabouts(grayson, friday, csbuilding).
 
whereabouts(ercal, monday, csbuilding). 
whereabouts(ercal, tuesday, havener). 
whereabouts(ercal, wednesday, csbuilding). 
whereabouts(ercal, thursday, csbuilding). 
whereabouts(ercal, friday, csbuilding). 

whereabouts(davis, monday, csbuilding). 
whereabouts(davis, tuesday, havener). 
whereabouts(davis, wednesday, havener). 
whereabouts(davis, thursday, library). 
whereabouts(davis, friday, csbuilding).
 
whereabouts(tauritz, monday, csbuilding). 
whereabouts(tauritz, tuesday, csbuilding). 
whereabouts(tauritz, wednesday, library). 
whereabouts(tauritz, thursday, csbuilding). 
whereabouts(tauritz, friday, csbuilding). 

whereabouts(cheng, monday, csbuilding). 
whereabouts(cheng, tuesday, havener). 
whereabouts(cheng, wednesday, havener). 
whereabouts(cheng, thursday, csbuilding). 
whereabouts(cheng, friday, csbuilding). 

whereabouts(price, monday, library). 
whereabouts(price, tuesday, library). 
whereabouts(price, wednesday, havener). 
whereabouts(price, thursday, library).
whereabouts(price, friday, csbuilding).
 
whereabouts(lin, monday, csbuilding).
whereabouts(lin, tuesday, library). 
whereabouts(lin, wednesday, library). 
whereabouts(lin, thursday, library). 
whereabouts(lin, friday, csbuilding).
