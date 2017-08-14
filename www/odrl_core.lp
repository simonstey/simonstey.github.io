%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Facts %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

action(use) .
action(share). 
action(distribute). 
action(present). 
action(print). 
action(display). 
action(play). 

%implies
implies(share,distribute) .

includedIn(print, present) .
includedIn(display, present) .
includedIn(play, present) .

includedIn(present, use) .
includedIn(share, use) .
includedIn(distribute, use) .

sameAs(copy,reproduce) .


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Action Relations %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

includedIn(X,Z) :- includedIn(X,Y), includedIn(Y,Z) .

implies(X,Z) :- implies(X,Y), implies(Y,Z) .


sameAs(X,Z) :- sameAs(X,Y), sameAs(Y,Z) .
sameAs(X,Z) :- sameAs(Z,X) .
sameAs(X,X) :- action(X) .

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Parsed ODRL Rules %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ruletarget(RT, Ac, all) :- ruletarget(RT, Ac) .       	
ruletarget(RT, all, Ac, As) :- ruletarget(RT, Ac, As) .
ruletarget(RT, Pa, Y, As) :- ruletarget(RT, Pa, X, As), sameAs(X,Y) .
ruletarget(RT, Pa, X, As) :- ruletarget(RT, Pa, Y, As), includedIn(X,Y) .

%ruletarget(RT, Pa, Y, As) :- ruletarget(RT, Pa, X, As), includedIn(Y,X) .       	

rule(R, P, T, RT) :- rule(R, T, RT), policy(P, R) .
rule(R, P, T, Pa, Ac, As) :- ruletarget(RT, Pa, Ac, As), rule(R, P, T, RT).

%{response(R1,T1,RT1); response(R2,T2,RT2)} = 1 :- rule(R1, _, T1, RT1), rule(R2, _, T2, RT2), T1 != T2,  rt_match(RT1,RT2) .

response(R, T, RT) :- rule(R, _, T, RT) .


response(R, T, Pa, Ac, As) :- response(R,T,RT), ruletarget(RT, Pa, Ac, As) .
%response(R, T, Pa, Y, As) :- response(R, T, Pa, X, As), includedIn(Y,X) . 

%{response(R1, T1, Pa, X, As) ; response(R2, T2, Pa, Y, As)} = 1 :- rule(R1, _, T1, RT1), rule(R2, _, T2, RT2), T1 != T2,  rt_match(RT1,RT2) .

rt_match(RT1,RT2) :- ruletarget(RT1, Pa, Ac, As), ruletarget(RT2, Pa, Ac, As), RT1!=RT2 .
%rt_match(RT1,RT2) :- ruletarget(RT1, all, Ac, As), ruletarget(RT2, Pa, Ac, As) .
%rt_match(RT1,RT2) :- ruletarget(RT1, all, Ac, all), ruletarget(RT2, Pa, Ac, As) .

rt_match(RT1,RT2) :- rt_match(RT2,RT1) .



conflict(R1,R2) :- response(R1, T1, Pa, Ac, As), response(R2, T2, Pa, Ac, As), T1 != T2 . 
conflict(R1,R2) :- response(R1, T1, Pa, Y, As), response(R2, T2, Pa, X, As), T1 != T2, includedIn(Y,X) . 
conflict(R1,R2) :- response(R1, T1, Pa, Y, As), response(R2, T2, Pa, X, As), T1 != T2, sameAs(Y,X) . 
conflict(R1,R2) :- response(R1,permission,Pa, X, As), response(R2,prohibition,Pa, Y, As), implies(X,Y) .
conflict(R1,R2) :- conflict(R2,R1) .

{fresponse(T1, Pa1, Ac1, As1) ; fresponse(T2, Pa2, Ac2, As2)} = 1 :- conflict(R1,R2), response(R1, T1, Pa1, Ac1, As1), response(R2, T2, Pa2, Ac2, As2) .
fresponse(T, Pa, Ac, As) :- response(R, T, Pa, Ac, As) , not conflict(R,_) .

permission(Pa,Ac,As) :- fresponse(permission, Pa, Ac, As) .
prohibition(Pa,Ac,As) :- fresponse(prohibition, Pa, Ac, As) .
duty(Pa,Ac,As) :- fresponse(duty, Pa, Ac, As) .

%:- response(_,T1,RT1), response(_,T2,RT2), T1 != T2,  rt_match(RT1,RT2) .
%:- fresponse(R1, T1, Pa, Ac, As), fresponse(R2, T2, Pa, Ac, As), T1 != T2 . 
%:- fresponse(R1, T1, Pa, Y, As), fresponse(R2, T2, Pa, X, As), T1 != T2, includedIn(Y,X) . 
%:- fresponse(R1,permission,Pa, X, As), fresponse(R2,prohibition,Pa, Y, As), implies(X,Y) .
%:- rt_match(RT1,RT2), not response(_,_,RT1), not response(_,_,RT2) .
%:- response(_,permission,Pa, Ac1, As), response(_,prohibition,Pa, Ac2, As), implies(Ac1,Ac2) .
%:- response(_,permission,all, Ac1, As), response(_,prohibition,_, Ac2, As), implies(Ac1,Ac2) .
%:- response(_,permission,_, Ac1, As), response(_,prohibition,all, Ac2, As), implies(Ac1,Ac2) .

#show permission/3.
#show prohibition/3.
#show duty/3.
%#show fresponse/4.
%#show response/5.
%#show rt_match/2.
%#show ruletarget/4.