/* THIS FILE BUILDS THE BIRTH COHORT VARIABLE SO THAT THE RETIREMENT INCOME DISCOUNT FACTORS
   CAN BE MERGED ON BIRTH COHORT AND AGE (FOR EACH WAVE) */

/*********************************************************************************
      2012
*********************************************************************************/ 
clear
local year "2012"
infile using "$HRSSurveys12/h12sta/H12PR_R.dct" , using("$HRSSurveys12/h12da/H12PR_R.da")
gen GENDER  = NX060_R
gen BIRTHMO = NX004_R
gen BIRTHYR = NX067_R
gen YEAR=`year'
keep HHID PN GENDER BIRTHYR BIRTHMO YEAR
save "$CleanData/temp`year'.dta", replace

clear
infile using "$HRSSurveys12/h12sta/H12A_R.dct" , using("$HRSSurveys12/h12da/H12A_R.da")
gen Age     = NA019
keep HHID PN Age
merge 1:1 HHID PN using "$CleanData/temp`year'.dta", assert(3) nogen

gen cohort_yr=.
replace cohort_yr=1900 if BIRTHYR>=1900 & BIRTHYR<1910
replace cohort_yr=1910 if BIRTHYR>=1910 & BIRTHYR<1920
replace cohort_yr=1920 if BIRTHYR>=1920 & BIRTHYR<1930
replace cohort_yr=1930 if BIRTHYR>=1930 & BIRTHYR<1940
replace cohort_yr=1940 if BIRTHYR>=1940 & BIRTHYR<1950
replace cohort_yr=1950 if BIRTHYR>=1950 & BIRTHYR<1960
replace cohort_yr=1960 if BIRTHYR>=1960 & BIRTHYR<1970
replace cohort_yr=1970 if BIRTHYR>=1970 & BIRTHYR<1980
replace cohort_yr=1980 if BIRTHYR>=1980 & BIRTHYR<1990

assert ~mi(Age)
assert mi(cohort_yr) if inlist(BIRTHYR, ., 1992, 2001)
drop if Age==.
drop if cohort_yr==.

save "$CleanData/Resp_Demos`year'.dta", replace

/*********************************************************************************
      2010
*********************************************************************************/ 
clear
local year "2010"
infile using "$HRSSurveys10/h10sta/H10PR_R.dct" , using("$HRSSurveys10/h10da/H10PR_R.da")
gen GENDER  = MX060_R
gen BIRTHMO = MX004_R
gen BIRTHYR = MX067_R
gen YEAR=`year'
keep HHID PN GENDER BIRTHYR BIRTHMO YEAR
save "$CleanData/temp`year'.dta", replace

clear
infile using "$HRSSurveys10/h10sta/H10A_R.dct", using("$HRSSurveys10/h10da/H10A_R.da")
gen Age     = MA019
keep HHID PN Age
merge 1:1 HHID PN using "$CleanData/temp`year'.dta", assert(3) nogen

gen cohort_yr=.
replace cohort_yr=1900 if BIRTHYR>=1900 & BIRTHYR<1910
replace cohort_yr=1910 if BIRTHYR>=1910 & BIRTHYR<1920
replace cohort_yr=1920 if BIRTHYR>=1920 & BIRTHYR<1930
replace cohort_yr=1930 if BIRTHYR>=1930 & BIRTHYR<1940
replace cohort_yr=1940 if BIRTHYR>=1940 & BIRTHYR<1950
replace cohort_yr=1950 if BIRTHYR>=1950 & BIRTHYR<1960
replace cohort_yr=1960 if BIRTHYR>=1960 & BIRTHYR<1970
replace cohort_yr=1970 if BIRTHYR>=1970 & BIRTHYR<1980
replace cohort_yr=1980 if BIRTHYR>=1980 & BIRTHYR<1990

assert ~mi(Age)
assert mi(cohort_yr) if BIRTHYR == 1992
drop if Age==.
drop if cohort_yr==.

save "$CleanData/Resp_Demos`year'.dta", replace

/*********************************************************************************
      2008
*********************************************************************************/ 
clear
local year "2008"
infile using "$HRSSurveys08/h08sta/H08PR_R.dct" , using("$HRSSurveys08/h08da/H08PR_R.da")
gen GENDER  = LX060_R
gen BIRTHMO = LX004_R
gen BIRTHYR = LX067_R
gen YEAR=`year'
keep HHID PN GENDER BIRTHYR BIRTHMO YEAR
save "$CleanData/temp`year'.dta", replace

clear
infile using "$HRSSurveys08/h08sta/H08A_R.dct" , using("$HRSSurveys08/h08da/H08A_R.da")
gen Age     = LA019
keep HHID PN Age
merge 1:1 HHID PN using "$CleanData/temp`year'.dta", assert(3) nogen

* Impute Age
replace Age = YEAR - BIRTHYR if Age == 0 

gen cohort_yr=.
replace cohort_yr=1900 if BIRTHYR>=1900 & BIRTHYR<1910
replace cohort_yr=1910 if BIRTHYR>=1910 & BIRTHYR<1920
replace cohort_yr=1920 if BIRTHYR>=1920 & BIRTHYR<1930
replace cohort_yr=1930 if BIRTHYR>=1930 & BIRTHYR<1940
replace cohort_yr=1940 if BIRTHYR>=1940 & BIRTHYR<1950
replace cohort_yr=1950 if BIRTHYR>=1950 & BIRTHYR<1960
replace cohort_yr=1960 if BIRTHYR>=1960 & BIRTHYR<1970
replace cohort_yr=1970 if BIRTHYR>=1970 & BIRTHYR<1980
replace cohort_yr=1980 if BIRTHYR>=1980 & BIRTHYR<1990

assert ~mi(Age)
assert ~mi(cohort_yr)
drop if Age==.
drop if cohort_yr==.

save "$CleanData/Resp_Demos`year'.dta", replace

/*********************************************************************************
      2006
*********************************************************************************/ 
clear
local year "2006"
infile using "$HRSSurveys06/h06sta/H06PR_R.dct" , using("$HRSSurveys06/h06da/H06PR_R.da")
gen GENDER  = KX060_R
gen BIRTHMO = KX004_R
gen BIRTHYR = KX067_R
gen YEAR=`year'
keep HHID PN GENDER BIRTHYR BIRTHMO YEAR
save "$CleanData/temp`year'.dta", replace

clear
infile using "$HRSSurveys06/h06sta/H06A_R.dct" , using("$HRSSurveys06/h06da/H06A_R.da")
gen Age     = KA019
keep HHID PN Age
merge 1:1 HHID PN using "$CleanData/temp`year'.dta", assert(3) nogen

gen cohort_yr=.
replace cohort_yr=1900 if BIRTHYR>=1900 & BIRTHYR<1910
replace cohort_yr=1910 if BIRTHYR>=1910 & BIRTHYR<1920
replace cohort_yr=1920 if BIRTHYR>=1920 & BIRTHYR<1930
replace cohort_yr=1930 if BIRTHYR>=1930 & BIRTHYR<1940
replace cohort_yr=1940 if BIRTHYR>=1940 & BIRTHYR<1950
replace cohort_yr=1950 if BIRTHYR>=1950 & BIRTHYR<1960
replace cohort_yr=1960 if BIRTHYR>=1960 & BIRTHYR<1970
replace cohort_yr=1970 if BIRTHYR>=1970 & BIRTHYR<1980
replace cohort_yr=1980 if BIRTHYR>=1980 & BIRTHYR<1990

assert ~mi(Age)
assert ~mi(cohort_yr)
drop if Age==.
drop if cohort_yr==.

save "$CleanData/Resp_Demos`year'.dta", replace

/*********************************************************************************
      2004
*********************************************************************************/ 
clear
local year "2004"
infile using "$HRSSurveys04/h04sta/H04PR_R.dct" , using("$HRSSurveys04/h04da/H04PR_R.da")
gen GENDER  = JX060_R
gen BIRTHMO = JX004_R
gen BIRTHYR = JX067_R
gen YEAR=`year'
keep HHID PN GENDER BIRTHYR BIRTHMO YEAR
save "$CleanData/temp`year'.dta", replace

clear
infile using "$HRSSurveys04/h04sta/H04A_R.dct" , using("$HRSSurveys04/h04da/H04A_R.da")
gen Age     = JA019
keep HHID PN Age
merge 1:1 HHID PN using "$CleanData/temp`year'.dta", assert(3) nogen


gen cohort_yr=.
replace cohort_yr=1900 if BIRTHYR>=1900 & BIRTHYR<1910
replace cohort_yr=1910 if BIRTHYR>=1910 & BIRTHYR<1920
replace cohort_yr=1920 if BIRTHYR>=1920 & BIRTHYR<1930
replace cohort_yr=1930 if BIRTHYR>=1930 & BIRTHYR<1940
replace cohort_yr=1940 if BIRTHYR>=1940 & BIRTHYR<1950
replace cohort_yr=1950 if BIRTHYR>=1950 & BIRTHYR<1960
replace cohort_yr=1960 if BIRTHYR>=1960 & BIRTHYR<1970
replace cohort_yr=1970 if BIRTHYR>=1970 & BIRTHYR<1980
replace cohort_yr=1980 if BIRTHYR>=1980 & BIRTHYR<1990

* Impute missing ages
replace Age = `year' - BIRTHYR if mi(Age)

assert ~mi(Age)
assert ~mi(cohort_yr) if BIRTHYR >= 1900 & BIRTHYR < 1990 
drop if Age==.
drop if cohort_yr==.

save "$CleanData/Resp_Demos`year'.dta", replace

/*********************************************************************************
      2002
*********************************************************************************/ 
clear
local year "2002"
infile using "$HRSSurveys02/h02sta/H02PR_R.dct" , using("$HRSSurveys02/h02da/H02PR_R.da")
gen GENDER  = HX060_R
gen BIRTHMO = HX004_R
gen BIRTHYR = HX067_R
gen YEAR=`year'
keep HHID PN GENDER BIRTHYR BIRTHMO YEAR
save "$CleanData/temp`year'.dta", replace

clear
infile using "$HRSSurveys02/h02sta/H02A_R.dct" , using("$HRSSurveys02/h02da/H02A_R.da")
gen Age     = HA019
keep HHID PN Age
merge 1:1 HHID PN using "$CleanData/temp`year'.dta", assert(3) nogen

gen cohort_yr=.
replace cohort_yr=1900 if BIRTHYR>=1900 & BIRTHYR<1910
replace cohort_yr=1910 if BIRTHYR>=1910 & BIRTHYR<1920
replace cohort_yr=1920 if BIRTHYR>=1920 & BIRTHYR<1930
replace cohort_yr=1930 if BIRTHYR>=1930 & BIRTHYR<1940
replace cohort_yr=1940 if BIRTHYR>=1940 & BIRTHYR<1950
replace cohort_yr=1950 if BIRTHYR>=1950 & BIRTHYR<1960
replace cohort_yr=1960 if BIRTHYR>=1960 & BIRTHYR<1970
replace cohort_yr=1970 if BIRTHYR>=1970 & BIRTHYR<1980
replace cohort_yr=1980 if BIRTHYR>=1980 & BIRTHYR<1990

* Impute missing ages
replace Age = `year' - BIRTHYR if mi(Age)

assert ~mi(Age)
assert ~mi(cohort_yr) if BIRTHYR >= 1900 & BIRTHYR < 1990 
drop if Age==.
drop if cohort_yr==.

save "$CleanData/Resp_Demos`year'.dta", replace

/*********************************************************************************
      2000
*********************************************************************************/ 
clear
local year "2000"
infile using "$HRSSurveys00/h00sta/H00PR_R.dct" , using("$HRSSurveys00/h00da/H00PR_R.da")
gen GENDER  = G35_1
gen BIRTHMO = G30_1
gen BIRTHYR = G29_1
gen YEAR=`year'
keep HHID PN GENDER BIRTHYR BIRTHMO YEAR
save "$CleanData/temp`year'.dta", replace

clear
infile using "$HRSSurveys00/h00sta/H00A_R.dct" , using("$HRSSurveys00/h00da/H00A_R.da")
gen Age     = G1101
keep HHID PN Age
merge 1:1 HHID PN using "$CleanData/temp`year'.dta", assert(3) nogen

* Fill in missing birth years
assert Age > 0 & ~mi(Age)
replace BIRTHYR = `year' - Age if BIRTHYR == 0 

gen cohort_yr=.
replace cohort_yr=1900 if BIRTHYR>=1900 & BIRTHYR<1910
replace cohort_yr=1910 if BIRTHYR>=1910 & BIRTHYR<1920
replace cohort_yr=1920 if BIRTHYR>=1920 & BIRTHYR<1930
replace cohort_yr=1930 if BIRTHYR>=1930 & BIRTHYR<1940
replace cohort_yr=1940 if BIRTHYR>=1940 & BIRTHYR<1950
replace cohort_yr=1950 if BIRTHYR>=1950 & BIRTHYR<1960
replace cohort_yr=1960 if BIRTHYR>=1960 & BIRTHYR<1970
replace cohort_yr=1970 if BIRTHYR>=1970 & BIRTHYR<1980
replace cohort_yr=1980 if BIRTHYR>=1980 & BIRTHYR<1990

assert ~mi(cohort_yr) if BIRTHYR >= 1900 & BIRTHYR < 1990 
drop if Age==.
drop if cohort_yr==.

save "$CleanData/Resp_Demos`year'.dta", replace

/*********************************************************************************
      1998
*********************************************************************************/ 
clear
local year "1998"
infile using "$HRSSurveys98/h98sta/H98PR_R.dct" , using("$HRSSurveys98/h98da/H98PR_R.da")
gen GENDER  = F35_1
gen BIRTHMO = F30_1
gen BIRTHYR = F29_1
gen YEAR=`year'
keep HHID PN GENDER BIRTHYR BIRTHMO YEAR
save "$CleanData/temp`year'.dta", replace

clear
infile using "$HRSSurveys98/h98sta/H98A_R.dct" , using("$HRSSurveys98/h98da/H98A_R.da")
gen Age     = F1014
replace Age=. if Age==0
keep HHID PN Age
merge 1:1 HHID PN using "$CleanData/temp`year'.dta", assert(3) nogen

* Fill in missing birth years
assert GENDER == 0 & BIRTHYR == 0 & BIRTHMO == 0 if mi(Age)
replace BIRTHYR = YEAR - Age if BIRTHYR == 0 

gen cohort_yr=.
replace cohort_yr=1900 if BIRTHYR>=1900 & BIRTHYR<1910
replace cohort_yr=1910 if BIRTHYR>=1910 & BIRTHYR<1920
replace cohort_yr=1920 if BIRTHYR>=1920 & BIRTHYR<1930
replace cohort_yr=1930 if BIRTHYR>=1930 & BIRTHYR<1940
replace cohort_yr=1940 if BIRTHYR>=1940 & BIRTHYR<1950
replace cohort_yr=1950 if BIRTHYR>=1950 & BIRTHYR<1960
replace cohort_yr=1960 if BIRTHYR>=1960 & BIRTHYR<1970
replace cohort_yr=1970 if BIRTHYR>=1970 & BIRTHYR<1980
replace cohort_yr=1980 if BIRTHYR>=1980 & BIRTHYR<1990

assert ~mi(cohort_yr) if BIRTHYR >= 1900 & BIRTHYR < 1990 
drop if Age==.
drop if cohort_yr==.

save "$CleanData/Resp_Demos`year'.dta", replace

/*********************************************************************************
      1996
*********************************************************************************/ 
clear
local year "1996"
infile using "$HRSSurveys96/h96sta/H96CS_R.dct" , using("$HRSSurveys96/h96da/H96CS_R.da")
gen GENDER  = E374
gen BIRTHYR = E373
gen BIRTHMO = .
gen YEAR=`year'
keep HHID PN GENDER BIRTHYR BIRTHMO YEAR
save "$CleanData/temp`year'.dta", replace

clear
infile using "$HRSSurveys96/h96sta/H96B_R.dct" , using("$HRSSurveys96/h96da/H96B_R.da")
gen Age     = E753
replace Age = . if E753==0
keep HHID PN Age
merge 1:1 HHID PN using "$CleanData/temp`year'.dta", assert(3) nogen

* Fill in missing birth years
replace BIRTHYR = YEAR - Age if BIRTHYR == 0 

gen cohort_yr=.
replace cohort_yr=1900 if BIRTHYR>=1900 & BIRTHYR<1910
replace cohort_yr=1910 if BIRTHYR>=1910 & BIRTHYR<1920
replace cohort_yr=1920 if BIRTHYR>=1920 & BIRTHYR<1930
replace cohort_yr=1930 if BIRTHYR>=1930 & BIRTHYR<1940
replace cohort_yr=1940 if BIRTHYR>=1940 & BIRTHYR<1950
replace cohort_yr=1950 if BIRTHYR>=1950 & BIRTHYR<1960
replace cohort_yr=1960 if BIRTHYR>=1960 & BIRTHYR<1970
replace cohort_yr=1970 if BIRTHYR>=1970 & BIRTHYR<1980
replace cohort_yr=1980 if BIRTHYR>=1980 & BIRTHYR<1990

assert mi(Age) if mi(BIRTHYR)
assert mi(cohort_yr) if mi(BIRTHYR)
drop if Age==.
drop if cohort_yr==.

save "$CleanData/Resp_Demos`year'.dta", replace

/*********************************************************************************
      1994
*********************************************************************************/ 
clear
local year "1994"
infile using "$HRSSurveys94/h94sta/W2CS.dct" , using("$HRSSurveys94/h94da/W2CS.da")
gen GENDER  = W103
gen Age     = W104
gen YEAR=`year'
keep HHID PN GENDER Age YEAR
save "$CleanData/temp`year'.dta", replace

clear
infile using "$HRSSurveys94/h94sta/W2A.dct" , using("$HRSSurveys94/h94da/W2A.da")
gen BIRTHYR = W53
gen BIRTHMO = W52
keep HHID PN BIRTHYR BIRTHMO
merge 1:1 HHID PN using "$CleanData/temp`year'.dta", assert(2 3)

* Fill in missing birth years and Ages
assert mi(BIRTHYR) if _m == 2 
drop _m
replace BIRTHYR = YEAR - Age if mi(BIRTHYR) & Age ~= 0
replace Age = YEAR - BIRTHYR if Age == 0 & ~mi(BIRTHYR)

gen cohort_yr=.
replace cohort_yr=1900 if BIRTHYR>=1900 & BIRTHYR<1910
replace cohort_yr=1910 if BIRTHYR>=1910 & BIRTHYR<1920
replace cohort_yr=1920 if BIRTHYR>=1920 & BIRTHYR<1930
replace cohort_yr=1930 if BIRTHYR>=1930 & BIRTHYR<1940
replace cohort_yr=1940 if BIRTHYR>=1940 & BIRTHYR<1950
replace cohort_yr=1950 if BIRTHYR>=1950 & BIRTHYR<1960
replace cohort_yr=1960 if BIRTHYR>=1960 & BIRTHYR<1970
replace cohort_yr=1970 if BIRTHYR>=1970 & BIRTHYR<1980
replace cohort_yr=1980 if BIRTHYR>=1980 & BIRTHYR<1990

assert Age == 0 if mi(BIRTHYR)
assert ~mi(Age)
assert ~mi(cohort_yr) if BIRTHYR >= 1900 & BIRTHYR < 1990 
drop if Age==.
drop if cohort_yr==.
assert Age > 0

save "$CleanData/Resp_Demos`year'.dta", replace

/*********************************************************************************
      1992
*********************************************************************************/ 
clear
local year "1992"
infile using "$HRSSurveys92/h92sta/HEALTH.dct" , using("$HRSSurveys92/h92da/HEALTH.da")
gen BIRTHYR = V44
gen BIRTHMO = V42
gen GENDER  = V47
gen Age     = V46
replace Age = . if inlist(V46, 997, 998, 999)
gen YEAR=`year'
keep HHID PN GENDER BIRTHYR BIRTHMO Age YEAR

gen cohort_yr=.
replace cohort_yr=1900 if BIRTHYR>=1900 & BIRTHYR<1910
replace cohort_yr=1910 if BIRTHYR>=1910 & BIRTHYR<1920
replace cohort_yr=1920 if BIRTHYR>=1920 & BIRTHYR<1930
replace cohort_yr=1930 if BIRTHYR>=1930 & BIRTHYR<1940
replace cohort_yr=1940 if BIRTHYR>=1940 & BIRTHYR<1950
replace cohort_yr=1950 if BIRTHYR>=1950 & BIRTHYR<1960
replace cohort_yr=1960 if BIRTHYR>=1960 & BIRTHYR<1970
replace cohort_yr=1970 if BIRTHYR>=1970 & BIRTHYR<1980
replace cohort_yr=1980 if BIRTHYR>=1980 & BIRTHYR<1990

assert mi(Age) if BIRTHYR == 9998 & mi(cohort_yr) 
assert ~mi(cohort_yr) if BIRTHYR >= 1900 & BIRTHYR < 1990 
drop if Age==.
drop if cohort_yr==.

save "$CleanData/Resp_Demos`year'.dta", replace

