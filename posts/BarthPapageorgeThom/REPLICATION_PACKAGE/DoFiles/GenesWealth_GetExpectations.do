

clear all
infile using "$HRSSurveys92/h92sta/HEALTH.dct" , using("$HRSSurveys92/h92da/HEALTH.da")


gen ProbLive75More_1992=(V5115/10)*100
gen SUBHH=ASUBHH

keep HHID PN SUBHH ProbLive75More_1992

save "$CleanData\SurvivalExpectations1992.dta", replace

clear all

infile using "$HRSSurveys94/h94sta/W2C.dct" , using("$HRSSurveys94/h94da/W2C.da")

gen ProbLive75More_1994=W5839
gen SUBHH=CSUBHH

keep HHID PN SUBHH ProbLive75More_1994

save "$CleanData\SurvivalExpectations1994.dta", replace


clear all

infile using "$HRSSurveys96/h96sta/H96H_R.dct" , using("$HRSSurveys96/h96da/H96H_R.da")


gen ProbLive75More_1996=E3819
gen SUBHH=ESUBHH

keep HHID PN SUBHH ProbLive75More_1996

save "$CleanData\SurvivalExpectations1996.dta", replace



clear all

infile using "$HRSSurveys98/h98sta/H98H_R.dct" , using("$HRSSurveys98/h98da/H98H_R.da")

gen ProbLive75More_1998=F4605
gen SUBHH=FSUBHH

keep HHID PN SUBHH ProbLive75More_1998

save "$CleanData\SurvivalExpectations1998.dta", replace



clear all

infile using "$HRSSurveys00/h00sta/H00H_R.dct" , using("$HRSSurveys00/h00da/H00H_R.da")

gen ProbLive75More_2000=G5018
gen SUBHH=GSUBHH

keep HHID PN SUBHH ProbLive75More_2000

save "$CleanData\SurvivalExpectations2000.dta", replace


clear all
infile using "$HRSSurveys02/h02sta/H02P_R.dct" , using("$HRSSurveys02/h02da/H02P_R.da")

gen ProbLive75More_2002=HP028
gen SUBHH=HSUBHH

keep HHID PN SUBHH ProbLive75More_2002

save "$CleanData\SurvivalExpectations2002.dta", replace


clear all
infile using "$HRSSurveys04/h04sta/H04P_R.dct" , using("$HRSSurveys04/h04da/H04P_R.da")

gen ProbLive75More_2004=JP028
gen SUBHH=JSUBHH

keep HHID PN SUBHH ProbLive75More_2004

save "$CleanData\SurvivalExpectations2004.dta", replace



clear all
infile using "$HRSSurveys06/h06sta/H06P_R.dct" , using("$HRSSurveys06/h06da/H06P_R.da")

gen ProbLive75More_2006=KP028
gen SUBHH=KSUBHH

keep HHID PN SUBHH ProbLive75More_2006

save "$CleanData\SurvivalExpectations2006.dta", replace



clear all

infile using "$HRSSurveys08/h08sta/H08P_R.dct" , using("$HRSSurveys08/h08da/H08P_R.da")

gen ProbLive75More_2008=LP028
gen SUBHH=LSUBHH

keep HHID PN SUBHH ProbLive75More_2008

save "$CleanData\SurvivalExpectations2008.dta", replace


clear all
infile using "$HRSSurveys10/h10sta/H10P_R.dct" , using("$HRSSurveys10/h10da/H10P_R.da")

gen ProbLive75More_2010=MP028
gen SUBHH=MSUBHH

keep HHID PN SUBHH ProbLive75More_2010

save "$CleanData\SurvivalExpectations2010.dta", replace


clear all
infile using "$HRSSurveys12/h12sta/H12P_R.dct" , using("$HRSSurveys12/h12da/H12P_R.da")

gen ProbLive75More_2012=NP028
gen SUBHH=NSUBHH

keep HHID PN SUBHH ProbLive75More_2012

save "$CleanData\SurvivalExpectations2012.dta", replace



