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

%% policy(p1) .

%% rule(p1,permission,all,print,all) .
%% %% rule(p1,prohibition,all,present,all) .
%% rule(p1,permission,all,share,all) .
%% rule(p1,prohibition,all,distribute,all) .
%% rule(p1,permission,all,download,all) .

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

rule(P, T, Pa, Y, As) :- rule(P, T, Pa, X, As), sameAs(X,Y) .
rule(P, T, Pa, Y, As) :- rule(P, T, Pa, X, As), includedIn(Y,X) .



response(T, Pa, Ac, As) :- rule(_, T, Pa, Ac, As) .

conflict(response(T1, Pa, Y, As), response(T2, Pa, X, As))  :- response(T1, Pa, Y, As), response(T2, Pa, X, As), T1 != T2, includedIn(Y,X) . 


conflict(response(permission, Pa, Y, As), response(prohibition, Pa, X, As))  :- response(permission, Pa, Y, As), response(prohibition, Pa, X, As), includedIn(Y,X) . 
conflict(response(permission, Pa, Y, As), response(prohibition, Pa, X, As)) :- response(permission, Pa, Y, As), response(prohibition, Pa, X, As), sameAs(Y,X) . 
conflict(response(permission, Pa, X, As), response(prohibition, Pa, Y, As)) :- response(permission,Pa, X, As), response(prohibition,Pa, Y, As), implies(X,Y) .


conflict(R1,R2) :- conflict(R2,R1) .

{fresponse(R1) ; fresponse(R2)} = 1 :- conflict(R1,R2) .
fresponse(response(T, Pa, Ac, As)) :- response(T, Pa, Ac, As), not conflict(response(T, Pa, Ac, As),_) .

permission(Pa,Ac,As) :- fresponse(response(permission, Pa, Ac, As)) .
prohibition(Pa,Ac,As) :- fresponse(response(prohibition, Pa, Ac, As)) .
duty(Pa,Ac,As) :- fresponse(response(duty, Pa, Ac, As)) .

:- duty(Pa,Ac,As), prohibition(Pa,Ac,As) .

#show permission/3.
#show prohibition/3.
#show duty/3.
%#show ffresponse/4.
%#show fresponse/1.
%#show response/4.
%#show rt_match/2.
%#show ruletarget/4.