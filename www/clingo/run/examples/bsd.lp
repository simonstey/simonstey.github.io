policy(reducedBSD3, br1) .
policy(reducedBSD3, br2) .
policy(reducedBSD3, br3) .

rule(br1, permission, brt1) .   
rule(br2, duty, brt2) .    
rule(br3, prohibition, brt3) .    

ruletarget(brt1,odrl_reproduce) .
ruletarget(brt2,cc_Notice) .
ruletarget(brt3,dalicc_promote) .

