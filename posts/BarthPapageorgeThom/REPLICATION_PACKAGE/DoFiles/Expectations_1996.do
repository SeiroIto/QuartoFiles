
/* NOTE: THERE CAN BE MORE THAN ONE RESPONDENT WITHIN AN HHID-SUBHH HOUSEHOLD */

/* Setting up. Merge with the Pre Load values to know which random assignments households get */
clear all
local year "1996"
local smallyear="96"
local survey="$HRSSurveys96"
local rangemethod="mid" /* cab be "mid", "min", or "max"; could also bootstrap */
local impute_numobs=3

infile using "`survey'/h`smallyear'sta/H`smallyear'H_R.dct" , using("`survey'/h`smallyear'da/H`smallyear'H_R.da")
merge 1:1 HHID PN using "$CleanData/HRSPreLoad`year'.dta", assert(3)
tab _merge /* Should be all matched */
drop _merge
save "$CleanData/HRS_RAWwithPreLoad`year'.dta", replace

/* Need age data later, which comes from the Cross-Wave Tracker File, so will load
   that now, keep relevant variables and save, so can be easily merged later. */
use "$Tracker16/HRS_Tracker16.dta"
keep HHID PN E*
save "$CleanData/HRSTrackerSmall`year'.dta", replace

/* Now reload expectations data */
clear
use "$CleanData/HRS_RAWwithPreLoad`year'.dta"

/* What do you think are the chances that your income will keep up with the cost of
         living for the next five years? */
gen ProbRealIncUp_`year'              =E3787
gen ProbRealIncUp_Dk_`year'           =0
replace ProbRealIncUp_Dk_`year'       =1 if E3787==998		 
 
/* 	Now ask about bequests (including property and valuables) */
gen ProbBeqMoreThan10k_`year'         =E3824
gen ProbBeqMoreThan10k_Dk_`year'      =0
replace ProbBeqMoreThan10k_Dk_`year'=1 if E3824==998

gen ProbBeqMoreThan100k_`year'        =E3825
gen ProbBeqMoreThan100k_Dk_`year'     =0
replace ProbBeqMoreThan100k_Dk_`year' =1 if E3825==998

gen ProbBeqAny_`year'                 =E3826
gen ProbBeqAny_Dk_`year'              =0
replace ProbBeqAny_Dk_`year'          =1 if E3826==998

/* What are the chances that you  [or your]   [you/husband/wife/partner]  will receive
   an inheritance during the next 10 years? */
gen ProbRecInher_`year'               =E3827
gen ProbRecInher_Dk_`year'            =0
replace ProbRecInher_Dk_`year'        =1 if E3827==998

/* How large do you expect the inheritence to be? */
gen SizeInher_`year'                  =E3828
gen SizeInher_Dk_`year'               =0
replace SizeInher_Dk_`year'           =1 if E3828==9999998
gen SizeInherPointEst_`year'          =0
replace SizeInherPointEst_`year'      =1 if E3828<9999997

local Inher_Bin1 10000
local Inher_Bin2 50000
local Inher_Bin3 250000
local Inher_Bin4 1000000

/* The HRS changed from 1=less, 3=about, and 5=more, to 1="yes" and 5="no",
   to the question of whether amount is MORE than threshold values. 
   For inheritance observations reported in ranges, we assign the sample median value
   from households reporting values in that range. This global can be changed in 00 Run.do*/
**** Less than first bin lower bound ****
sum SizeInher_`year' if SizeInherPointEst_`year'==1 & SizeInher_`year'>0 & SizeInher_`year'<`Inher_Bin1', detail
*return list
assert r(N)>`impute_numobs'
replace SizeInher_`year'=r(p$bin_pctile) if E3830==5

**** Second Bin ****
sum SizeInher_`year' if SizeInherPointEst_`year'==1 & SizeInher_`year'>`Inher_Bin1' & SizeInher_`year'<`Inher_Bin2', detail
*return list
assert r(N)>`impute_numobs'
replace SizeInher_`year'=r(p$bin_pctile) if E3830==1 & E3829==5

**** Third Bin ****
sum SizeInher_`year' if SizeInherPointEst_`year'==1 & SizeInher_`year'>`Inher_Bin2' & SizeInher_`year'<`Inher_Bin3', detail
*return list
assert r(N)>`impute_numobs'
replace SizeInher_`year'=r(p$bin_pctile) if E3829==1 & E3831==5

**** Fourth Bin ****
sum SizeInher_`year' if SizeInherPointEst_`year'==1 & SizeInher_`year'>`Inher_Bin3' & SizeInher_`year'<`Inher_Bin4', detail
*return list
assert r(N)>`impute_numobs'
replace SizeInher_`year'=r(p$bin_pctile) if E3831==1 & E3832==5

**** Fifth Bin ****
sum SizeInher_`year' if SizeInherPointEst_`year'==1 & SizeInher_`year'>`Inher_Bin4' & SizeInher_`year'<=99999996, detail
*return list
assert r(N)>`impute_numobs'
replace SizeInher_`year'=r(p$bin_pctile) if E3832==1

/* Replace Dk again */
*replace SizeInher_Dk_`year'           =0 if SizeInher_`year'~=.

/*  Probability you lose job you want to keep. Only applies to households still working
    and not self-employed: J020=1 and J021~=2 */
gen ProbLoseJob_`year'                =E3788
gen ProbLoseJob_Dk_`year'             =0
replace ProbLoseJob_Dk_`year'         =1 if E3788==998

/*  Probability you find "equally good job (as the one you had) in same line of work?
    Again, only for employed, those answering MP014. */
gen ProbFindJob_`year'                =E3789
gen ProbFindJob_Dk_`year'             =0
replace ProbFindJob_Dk_`year'         =1 if E3789==998

/*  What is chance work for pay in the future? Only applies if not working (J020~=1)  */
gen ProbWorkforPay_`year'             =E3790
gen ProbWorkforPay_Dk_`year'          =0
replace ProbWorkforPay_Dk_`year'      =1 if E3790==998

/*  What is probability R will be working at 62? Only applies if less than 62 and HP016~=0 */
gen ProbWorkPost62_`year'             =E3796
gen ProbWorkPost62_Dk_`year'          =0
replace ProbWorkPost62_Dk_`year'      =1 if E3796==998

/*  What is probability R will be working at 65? Only applies if older than 62 and less than 65 and J021==1 */
gen ProbWorkPost65_`year'             =E3797
gen ProbWorkPost65_Dk_`year'          =0
replace ProbWorkPost65_Dk_`year'      =1 if E3797==998

/* Probability health will limit work activity in next 10 years */
gen HealthLimitWork_`year'            =E3798
gen HealthLimitWork_Dk_`year'         =0
replace HealthLimitWork_Dk_`year'     =1 if E3798==998

/* Only applies if J505 or J517 is equal to one (is looking for a job) */
gen ProbFindJobFewMonths_`year'       =E3800
gen ProbFindJobFewMonths_Dk_`year'    =0
replace ProbFindJobFewMonths_Dk_`year'=1 if E3800==998			
	   
/* Percent chance live to be 75 or more */
gen ProbLive75More_`year'             =E3819
gen ProbLive75More_Dk_`year'          =0
replace ProbLive75More_Dk_`year'      =1 if E3819==998
			
/* Now going to merge with TrackerSmall, created at top, to get age. Age is needed to calculate
   ProbLiveToVarious age values below. To do this, I create HHIDnum just to count number of
   observations, to make sure all observations are matched. */
destring HHID, generate(HHIDnum)
sum HHIDnum
local obscount = `r(N)'
drop HHIDnum

/* Merge to get age */
merge 1:1 HHID PN using "$CleanData/HRSTrackerSmall`year'.dta", assert(2 3)
assert _m ~= 1
count if _m == 3 
assert `r(N)' == `obscount'
tab _merge /* Merge 3 should be equal to number of HHIDnum observations above*/

/* In 2000 onward, ask about probability of living to various ages. In 1998 and previous,
   only ask about living to 85.  */		 
gen ProbLiveToVarious_`year'          =E3821
gen ProbLiveToVarious_Dk_`year'       =0
replace ProbLiveToVarious_Dk_`year'   =1 if E3821==998
  /* Everyone asked about living to 85 only */
gen ProbLiveTo80_`year'               =0
gen ProbLiveTo85_`year'               =0
replace ProbLiveTo85_`year'           =1 if E3821~=.
gen ProbLiveTo90_`year'               =0
gen ProbLiveTo95_`year'               =0
gen ProbLiveTo100_`year'              =0

/* Chances give $5k in financial help to grown children, family, or friends? */
gen GiveFinHelp5k_`year'              =E3822
gen GiveFinHelp5k_Dk_`year'           =0
replace GiveFinHelp5k_Dk_`year'       =1 if E3822==998

/* Chances receive $5k in financial help from grown children, family, or friends? */
gen RecFinHelp5k_`year'               =E3823
gen RecFinHelp5k_Dk_`year'            =0
replace RecFinHelp5k_Dk_`year'        =1 if E3823==998

/* What is chance will have to move to a nursuing home ever (in next 5 years)?
   If age<65, question is ever. If age>=65, question is in next 5 years. */
gen ProbMoveToNH_`year'               =E3833
gen ProbMoveToNH_Dk_`year'            =0
replace ProbMoveToNH_Dk_`year'        =1 if E3833==998
gen NH5years_`year'                   =0
replace NH5years_`year'               =1 if EAGE>=65
gen NHEver_`year'                     =0
replace NHEver_`year'                 =1 if EAGE<65

/* Chance U.S. experiences double-digit inflation in next ten years */
gen ProbDoubleDigitInf_`year'         =E3834
gen ProbDoubleDigitInf_Dk_`year'      =0
replace ProbDoubleDigitInf_Dk_`year'  =1 if E3834==998

/* Probability US has economic depression in next 10 years */
gen ProbUSEconDep_`year'              =E3835
gen ProbUSEconDep_Dk_`year'           =0
replace ProbUSEconDep_Dk_`year'       =1 if E3835==998

/* Probability congress changes social security to be less generous in next
   10 years. */
gen SSChangeLessGenerous_`year'       =E3836
gen SSChangeLessGenerous_Dk_`year'    =0
replace SSChangeLessGenerous_Dk_`year'=1 if E3836==998

/* Will children have higher, lower, same standard of living at your age? */
gen     ChildBetterOff_`year'         =0
gen     ChildWorseOff_`year'          =0
gen     ChildSameOff_`year'           =0
replace ChildBetterOff_`year'         =1 if E3837==1
replace ChildWorseOff_`year'          =1 if E3837==2
replace ChildSameOff_`year'           =1 if E3837==3

/* Follow up about "much" better or worse off. 1=yes, 0=no. */
gen     ChildMuchBetter_`year'        =0
replace ChildMuchBetter_`year'        =1 if E3838==1
gen     ChildMuchWorse_`year'         =0
replace ChildMuchWorse_`year'         =1 if E3839==1

gen FinPlanCat_`year'=.
gen ProbMarketUp_`year'=.
gen FollowMarket_`year'=.
gen IncRAbin_`year'=.
gen InherRAbin_`year'=.
gen BusRAbin_`year'=.

keep HHID PN ProbMarketUp_`year' ProbUSEconDep_`year' ProbDoubleDigitInf_`year' FollowMarket_`year' FinPlanCat_`year' IncRAbin_`year' InherRAbin_`year' BusRAbin_`year'

save "$CleanData/HRSExp`year'.dta", replace
