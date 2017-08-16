policy(reducedApache, ar1) .
policy(reducedApache, ar2) .
policy(reducedApache, ar3) .
policy(reducedApache, ar4) .
policy(reducedApache, ar5) .
policy(reducedApache, ar6) .
policy(reducedApache, ar7) .
policy(reducedApache, ar8) .

rule(ar1, permission, art1) .   
rule(ar2, permission, art2) .   
rule(ar3, permission, art3) .   
rule(ar4, permission, art4) .   

rule(ar5, duty, art5) .    
rule(ar6, duty, art6) .    
rule(ar7, duty, art7) .    

rule(ar8, prohibition, art8) .    

ruletarget(art1,dalicc_sublicense) .
ruletarget(art2,odrl_display) .
ruletarget(art3,odrl_present) .
ruletarget(art4,odrl_reproduce) .

ruletarget(art5,cc_Notice) .
ruletarget(art6,dalicc_irrevocable) .
ruletarget(art7,dalicc_perpetual) .

ruletarget(art8,odrl_ensureExclusivity) .
asd(df) .
