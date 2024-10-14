clear all

/* 1992 Expectations - There actually is not an Expectations section / module 
in the 1992 Wave of the HRS.  However, here we extract the Financial Planning
Horizon Variable, which is contained in the HEALTH file */

infile using "$HRSSurveys92/h92sta/HEALTH.dct" , using("$HRSSurveys92//h92da/HEALTH.da")


gen FinPlanCat_1992=V5124

keep HHID PN FinPlanCat_*

save "$CleanData/HRSExp1992.dta", replace
