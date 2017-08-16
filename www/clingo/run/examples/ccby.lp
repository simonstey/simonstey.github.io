policy(reducedCCBY) .

rule(reducedCCBY, permission, all, odrl_present, all) .
rule(reducedCCBY, duty, all, cc_Notice, all) .
rule(reducedCCBY, duty, all, cc_SourceCode, all) .
rule(reducedCCBY, duty, all, dalicc_irrevocable, all) .
rule(reducedCCBY, prohibition, all, dalicc_sublicense, all) .
rule(reducedCCBY, prohibition, all, odrl_ensureExclusivity, all) .

action(dalicc_sublicense) . 
action(cc_SourceCode) . 
action(odrl_present) . 
action(cc_Notice) . 
action(dalicc_irrevocable) . 
action(odrl_ensureExclusivity) . 