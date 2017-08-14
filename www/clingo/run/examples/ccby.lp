policy(reducedCCBY, cr1) .
policy(reducedCCBY, cr2) .
policy(reducedCCBY, cr3) .
policy(reducedCCBY, cr4) .
policy(reducedCCBY, cr5) .
policy(reducedCCBY, cr6) .

rule(cr1, permission, crt1) .   

rule(cr2, duty, crt2) .    
rule(cr3, duty, crt3) .    
rule(cr4, duty, crt4) .    

rule(cr5, prohibition, crt5) .    
rule(cr6, prohibition, crt6) .    

ruletarget(crt1,odrl_present) .

ruletarget(crt2,cc_Notice) .
ruletarget(crt3,cc_SourceCode) .
ruletarget(crt4,dalicc_irrevocable) .

ruletarget(crt5,dalicc_sublicense) .
ruletarget(crt6,odrl_ensureExclusivity) .

