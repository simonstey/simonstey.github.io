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

includedIn(copy, use) .
includedIn(reproduce, use) .

sameAs(copy,reproduce) .

%% policy(p1) .

%% rule(p1,permission,all,copy,all) .

%% policy(p3) .

%% rule(p3,permission,all,use,all) .
%% %% rule(p1,prohibition,all,present,all) .
%% %% rule(p1,permission,all,share,all) .
%% %% rule(p1,prohibition,all,distribute,all) .
%% %% rule(p1,permission,all,download,all,satisfied) .

%% policy(p2) .

%% rule(p2,permission,all,present,all) .
%% %% rule(p2,prohibition,all,present,all) .
%% %% rule(p2,permission,all,share,all) .
%% rule(p2,prohibition,all,reproduce,all) .
%% %% rule(p2,permission,all,download,all,satisfied) .

%% query(permission, all, odrl_present, all) .
%% query(prohibition, all, odrl_ensureExclusivity, all) .
%% query(prohibition, all, distribute, all) .

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
%rule(P, T, Pa, Ac, As) :- rule(P, T, Pa, Ac, As, satisfied) .


response(P, T, Pa, Ac, As) :- rule(P, T, Pa, Ac, As) .


conflict(response(P, T1, Pa, Y, As), response(P, T2, Pa, X, As))  :- response(P, T1, Pa, Y, As), response(P, T2, Pa, X, As), T1 != T2, includedIn(Y,X) . 
conflict(response(P, permission, Pa, Y, As), response(P, prohibition, Pa, X, As))  :- response(P, permission, Pa, Y, As), response(P, prohibition, Pa, X, As), includedIn(Y,X) . 
conflict(response(P, permission, Pa, Y, As), response(P, prohibition, Pa, X, As)) :- response(P, permission, Pa, Y, As), response(P, prohibition, Pa, X, As), sameAs(Y,X) . 
conflict(response(P, permission, Pa, X, As), response(P, prohibition, Pa, Y, As)) :- response(P, permission,Pa, X, As), response(P, prohibition,Pa, Y, As), implies(X,Y) .


conflict(R1,R2) :- conflict(R2,R1) .

%{fresponse(R1) ; fresponse(R2)} = 1 :- conflict(R1,R2) .
fresponse(response(P, T, Pa, Ac, As)) :- response(P, T, Pa, Ac, As), not conflict(response(P, T, Pa, Ac, As),_) .

permission(P,Pa,Ac,As) :- fresponse(response(P, permission, Pa, Ac, As)), solution(P) .
prohibition(P,Pa,Ac,As) :- fresponse(response(P, prohibition, Pa, Ac, As)), solution(P) .
duty(P,Pa,Ac,As) :- fresponse(response(P, duty, Pa, Ac, As)), solution(P) .

{solution(P)} :- fresponse(response(P, T, Pa, Ac, As)), query(T, Pa, Ac, As) .%policy(P2), not solution(P2), P != P2 .


:- solution(P1), solution(P2), P1 != P2 .
:- {solution(P)} 0 .
:- not fresponse(response(P, T, Pa, Ac, As)), query(T, Pa, Ac, As), solution(P) .

 :- permission(P,Pa,Ac,As), prohibition(P,Pa,Ac,As) .
 :- duty(P,Pa,Ac,As), prohibition(P,Pa,Ac,As) .

#show permission/4.
#show prohibition/4.
#show duty/4.
#show query/4.
#show solution/1.
%#show ffresponse/4.
%#show fresponse/1.
%#show response/4.
%#show rt_match/2.
%#show ruletarget/4.