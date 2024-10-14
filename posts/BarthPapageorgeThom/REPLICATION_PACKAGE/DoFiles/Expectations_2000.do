
/* NOTE: THERE CAN BE MORE THAN ONE RESPONDENT WITHIN AN HHID-SUBHH HOUSEHOLD */

/* Setting up. Merge with the Pre Load values to know which random assignments households get */
clear all
local year "2000"
local smallyear="00"
local survey="$HRSSurveys00"
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
keep HHID PN G*
save "$CleanData/HRSTrackerSmall`year'.dta", replace

/* Now reload expectations data */
clear
use "$CleanData/HRS_RAWwithPreLoad`year'.dta"

/* What do you think are the chances that your income will keep up with the cost of
         living for the next five years? */
gen ProbRealIncUp_`year'              =G4984
gen ProbRealIncUp_Dk_`year'           =0
replace ProbRealIncUp_Dk_`year'       =1 if G4984==998		 
 
/* 	Now ask about bequests (including property and valuables) */
gen ProbBeqMoreThan10k_`year'         =G4985
gen ProbBeqMoreThan10k_Dk_`year'      =0
replace ProbBeqMoreThan10k_Dk_`year'=1 if G4985==998

gen ProbBeqMoreThan100k_`year'        =G4987
gen ProbBeqMoreThan100k_Dk_`year'     =0
replace ProbBeqMoreThan100k_Dk_`year' =1 if G4987==998

gen ProbBeqAny_`year'                 =G4988
gen ProbBeqAny_Dk_`year'              =0
replace ProbBeqAny_Dk_`year'          =1 if G4988==998

/* What are the chances that you  [or your]   [you/husband/wife/partner]  will receive
   an inheritance during the next 10 years? */
gen ProbRecInher_`year'               =G4989
gen ProbRecInher_Dk_`year'            =0
replace ProbRecInher_Dk_`year'        =1 if G4989==998

/* How large do you expect the inheritence to be? */
gen SizeInher_`year'                  =G4991
gen SizeInher_Dk_`year'               =0
replace SizeInher_Dk_`year'           =1 if G4991==99999998
gen SizeInherPointEst_`year'          =0
replace SizeInherPointEst_`year'      =1 if G4991<99999998

local Inher_Bin1 10000
local Inher_Bin2 50000
local Inher_Bin3 250000
local Inher_Bin4 1000000

replace SizeInher_`year'=10000   if G4993==3
replace SizeInher_`year'=50000   if G4992==3
replace SizeInher_`year'=250000  if G4994==3
replace SizeInher_`year'=1000000 if G4995==3


**** Less than first bin lower bound ****
sum SizeInher_`year' if SizeInherPointEst_`year'==1 & SizeInher_`year'>0 & SizeInher_`year'<`Inher_Bin1', detail
*return list
assert r(N)>`impute_numobs'
replace SizeInher_`year'=r(p$bin_pctile) if G4993==1

**** Second Bin ****
sum SizeInher_`year' if SizeInherPointEst_`year'==1 & SizeInher_`year'>`Inher_Bin1' & SizeInher_`year'<`Inher_Bin2', detail
*return list
assert r(N)>`impute_numobs'
replace SizeInher_`year'=r(p$bin_pctile) if G4993==5 & G4992==1

**** Third Bin ****
sum SizeInher_`year' if SizeInherPointEst_`year'==1 & SizeInher_`year'>`Inher_Bin2' & SizeInher_`year'<`Inher_Bin3', detail
*return list
assert r(N)>`impute_numobs'
replace SizeInher_`year'=r(p$bin_pctile) if G4992==5 & G4994==1

**** Fourth Bin ****
sum SizeInher_`year' if SizeInherPointEst_`year'==1 & SizeInher_`year'>`Inher_Bin3' & SizeInher_`year'<`Inher_Bin4', detail
*return list
assert r(N)>`impute_numobs'
replace SizeInher_`year'=r(p$bin_pctile) if G4994==5 & G4995==1

**** Fifth Bin ****
sum SizeInher_`year' if SizeInherPointEst_`year'==1 & SizeInher_`year'>`Inher_Bin4' & SizeInher_`year'<=99999996, detail
*return list
assert r(N)>`impute_numobs'
replace SizeInher_`year'=r(p$bin_pctile) if G4995==5

/* Replace Dk again */
*replace SizeInher_Dk_`year'           =0 if SizeInher_`year'~=.


/* 	User Note: Any R who refuses or does not know how to answer the first three
    0-100 questions of section P, will not be asked any further questions in this
    section. The actual sequence of questions varies and depends on specific skips.
	0= can't do, 1=can do. */
gen CantDoProbs_`year'                =G4990

/*  Probability you lose job you want to keep. Only applies to households still working
    and not self-employed: J020=1 and J021~=2 */
gen ProbLoseJob_`year'                =G4996
gen ProbLoseJob_Dk_`year'             =0
replace ProbLoseJob_Dk_`year'         =1 if G4996==998

/*  Probability you find "equally good job (as the one you had) in same line of work?
    Again, only for employed, those answering MP014. */
gen ProbFindJob_`year'                =G4997
gen ProbFindJob_Dk_`year'             =0
replace ProbFindJob_Dk_`year'         =1 if G4997==998

/*  What is chance work for pay in the future? Only applies if not working (J020~=1)  */
gen ProbWorkforPay_`year'             =G4998
gen ProbWorkforPay_Dk_`year'          =0
replace ProbWorkforPay_Dk_`year'      =1 if G4998==998

/*  What is probability R will be working at 62? Only applies if less than 62 and HP016~=0 */
gen ProbWorkPost62_`year'             =G5002
gen ProbWorkPost62_Dk_`year'          =0
replace ProbWorkPost62_Dk_`year'      =1 if G5002==998

/*  What is probability R will be working at 65? Only applies if older than 62 and less than 65 and J021==1 */
gen ProbWorkPost65_`year'             =G5003
gen ProbWorkPost65_Dk_`year'          =0
replace ProbWorkPost65_Dk_`year'      =1 if G5003==998

/* Probability health will limit work activity in next 10 years */
gen HealthLimitWork_`year'            =G5004
gen HealthLimitWork_Dk_`year'         =0
replace HealthLimitWork_Dk_`year'     =1 if G5004==998

/* Only applies if J505 or J517 is equal to one (is looking for a job) */
gen ProbFindJobFewMonths_`year'       =G5006
gen ProbFindJobFewMonths_Dk_`year'    =0
replace ProbFindJobFewMonths_Dk_`year'=1 if G5006==998

/* Chance that R moves in next two years */
gen ProbMoveNext2yrs_`year'           =G5010
gen ProbMoveNext2yrs_Dk_`year'        =0
replace ProbMoveNext2yrs_Dk_`year'    =1 if G5010==998

/* Will R move to another state? 1=yes, 2=no */
gen MoveNewState_`year'               =G5011
gen MoveNewState_Dk_`year'            =0
replace MoveNewState_Dk_`year'        =1 if G5011==8

/* Which State? (Masked to protect anonymity). Dk has 0 observations. */
gen MoveWhichState_`year'             =G5012M

/* Do you think you will buy or build a home, rent, move in with someone else or what?
            346         1. BUY OR BUILD
            278         2. RENT
             83         3. MOVE IN WITH SOMEONE ELSE
             60         8. DK (don't know); NA (not ascertained) */
gen HomeIfMove_`year'                 =G5015
gen HomeIfMove_Dk_`year'              =0
replace HomeIfMove_Dk_`year'          =1 if G5015==8

/* With whom would you live?
             36         1. CHILD
              1         2. PARENT
             22         3. OTHER RELATIVE
             20         5. Assisted living or other long term care facility
              2         7. OTHER (SPECIFY)
              2         8. DK (don't know); NA (not ascertained) */
gen WhomLiveWithIfMove_`year'         =G5016
gen WhomLiveWithIfMove_Dk_`year'      =0
replace WhomLiveWithIfMove_Dk_`year'  =1 if G5016==8			
	   

/* Percent chance live to be 75 or more */
gen ProbLive75More_`year'             =G5018
gen ProbLive75More_Dk_`year'          =0
replace ProbLive75More_Dk_`year'      =1 if G5018==998
			
/* Now going to merge with TrackerSmall, created at top, to get age. Age is needed to calculate
   ProbLiveToVarious age values below. To do this, I create HHIDnum just to count number of
   observations, to make sure all observations are matched. */
destring HHID, generate(HHIDnum)
sum HHIDnum
local obscount = `r(N)'
drop HHIDnum

/* Merge to get age */
merge 1:1 HHID PN using "$CleanData/HRSTrackerSmall`year'.dta"
count if _m == 1
assert `r(N)' == 3 
count if _m == 3 
assert `r(N)' == `obscount' - 3
tab _merge /* Merge 3 should be equal to number of HHIDnum observations above
			  MZ note - this is not true for this file.*/

/* What is the percent chance that you will live to be [85/80/90/95/100] or more?
         80 (IF AGE IS 65-69)
         85 (IF AGE IS 70-74)
         90 (IF AGE IS 75-79)
         95 (IF AGE IS 80-84)
         100 (IF AGE IS 85-89) */		 
gen ProbLiveToVarious_`year'          =G5020
gen ProbLiveToVarious_Dk_`year'       =0
replace ProbLiveToVarious_Dk_`year'   =1 if G5020==998
gen ProbLiveTo80_`year'=0
replace ProbLiveTo80_`year'=1 if GAGE<=69 & ProbLiveToVarious_`year'~=.
gen ProbLiveTo85_`year'=0
replace ProbLiveTo85_`year'=1 if (GAGE>=70 & GAGE<=74 & ProbLiveToVarious_`year'~=.)
gen ProbLiveTo90_`year'=0
replace ProbLiveTo90_`year'=1 if GAGE>=75 & GAGE<=79 & ProbLiveToVarious_`year'~=.
gen ProbLiveTo95_`year'=0
replace ProbLiveTo95_`year'=1 if GAGE>=80 & GAGE<=84 & ProbLiveToVarious_`year'~=.
gen ProbLiveTo100_`year'=0
replace ProbLiveTo100_`year'=1 if GAGE>=85 & GAGE<=89 & ProbLiveToVarious_`year'~=.

/* Chances give $5k in financial help to grown children, family, or friends? */
gen GiveFinHelp5k_`year'              =G5021
gen GiveFinHelp5k_Dk_`year'           =0
replace GiveFinHelp5k_Dk_`year'       =1 if G5021==998

/* Chances receive $5k in financial help from grown children, family, or friends? */
gen RecFinHelp5k_`year'               =G5022
gen RecFinHelp5k_Dk_`year'            =0
replace RecFinHelp5k_Dk_`year'        =1 if G5022==998

/* What is chance will have to move to a nursuing home ever (in next 5 years)?
   If age<65, question is ever. If age>=65, question is in next 5 years. */
gen ProbMoveToNH_`year'               =G5023
gen ProbMoveToNH_Dk_`year'            =0
replace ProbMoveToNH_Dk_`year'        =1 if G5023==998
gen NH5years_`year'                   =0
replace NH5years_`year'               =1 if GAGE>=65
gen NHEver_`year'                     =0
replace NHEver_`year'                 =1 if GAGE<65

/* Chance U.S. experiences double-digit inflation in next ten years */
gen ProbDoubleDigitInf_`year'         =G5024
gen ProbDoubleDigitInf_Dk_`year'      =0
replace ProbDoubleDigitInf_Dk_`year'  =1 if G5024==998

/* Probability US has economic depression in next 10 years */
gen ProbUSEconDep_`year'              =G5025
gen ProbUSEconDep_Dk_`year'           =0
replace ProbUSEconDep_Dk_`year'       =1 if G5025==998

/* Probability congress changes social security to be less generous in next
   10 years. */
gen SSChangeLessGenerous_`year'       =G5026
gen SSChangeLessGenerous_Dk_`year'    =0
replace SSChangeLessGenerous_Dk_`year'=1 if G5026==998

/* In deciding how much of their  family) income to spend or save, people are likely to think about
   different financial planning periods. In planning your (family's) saving and spending, which of
   the following time periods is most important to you (and your (husband/wife/partner)), the next
   few months, the next year, the next few years, the next 5-10 years, or longer than 10 years? */
gen     FinPlanPerFewMonths_`year'    =0
gen     FinPlanPerOneYr_`year'        =0
gen     FinPlanPerFewYrs_`year'       =0
gen     FinPlanPerFiveTenYrs_`year'   =0
gen     FinPlanPerMoreTenYrs_`year'   =0
replace FinPlanPerFewMonths_`year'    =1 if G5037==1
replace FinPlanPerOneYr_`year'        =1 if G5037==2
replace FinPlanPerFewYrs_`year'       =1 if G5037==3
replace FinPlanPerFiveTenYrs_`year'   =1 if G5037==4
replace FinPlanPerMoreTenYrs_`year'   =1 if G5037==5

gen FinPlanCat_`year'=G5037

/* Will children have higher, lower, same standard of living at your age? */
gen     ChildBetterOff_`year'         =0
gen     ChildWorseOff_`year'          =0
gen     ChildSameOff_`year'           =0
replace ChildBetterOff_`year'         =1 if G5038==1
replace ChildWorseOff_`year'          =1 if G5038==2
replace ChildSameOff_`year'           =1 if G5038==3

/* Follow up about "much" better or worse off. 1=yes, 0=no. */
gen     ChildMuchBetter_`year'        =0
replace ChildMuchBetter_`year'        =1 if G5039==1
gen     ChildMuchWorse_`year'         =0
replace ChildMuchWorse_`year'         =1 if G5040==1
					

/* Did you get help filling out this section */
gen     NoExpHelp_`year'              =0
gen     SomeExpHelp_`year'            =0
gen     LotExpHelp_`year'             =0
gen     ProxyExpHelp_`year'           =0
replace NoExpHelp_`year'              =1 if G5041==1
replace SomeExpHelp_`year'            =1 if G5041==2
replace LotExpHelp_`year'             =1 if G5041==3
replace ProxyExpHelp_`year'           =1 if G5041==4

/*************************************************************************
					RISK AVERSION QUESTIONS
*************************************************************************/

/******* Income Gambles *************/
/* Income gamble: choose between guaranteed lifetime income (current) or 50-50 gamble that
   lifetime income would double or be cut by one-third. 1=first job, 2=second. */
gen IncGambleOneThird_`year'           =G5027
gen IncGambleOneThird_Dk_`year'        =0
replace IncGambleOneThird_Dk_`year'    =1 if G5027==8

/* Income gamble: If YES to HP036, choose between guaranteed lifetime income (current) or 50-50 gamble that
   lifetime income would double or be cut by one-half. 1=first job, 2=second. */
gen IncGambleOneHalf_`year'            =G5033
gen IncGambleOneHalf_Dk_`year'         =0
replace IncGambleOneHalf_Dk_`year'     =1 if G5033==8

/* Income gamble: If YES to HP037, choose between guaranteed lifetime income (current) or 50-50 gamble that
   lifetime income would double or be cut by 75%. 1=first job, 2=second. */
gen IncGamble75perc_`year'             =G5034
gen IncGamble75perc_Dk_`year'          =0
replace IncGamble75perc_Dk_`year'      =1 if G5034==8

/* Income gamble: If NO to HP036, choose between guaranteed lifetime income (current) or 50-50 gamble that
   lifetime income would double or be cut by 20%. 1=first job, 2=second. */
gen IncGambleOneFifth_`year'           =G5035
gen IncGambleOneFifth_Dk_`year'        =0
replace IncGambleOneFifth_Dk_`year'    =1 if G5035==8

/* Income gamble: If NO to HP039, choose between guaranteed lifetime income (current) or 50-50 gamble that
   lifetime income would double or be cut by 10%. 1=first job, 2=second. */
gen IncGambleOneTenth_`year'           =G5036
gen IncGambleOneTenth_Dk_`year'        =0
replace IncGambleOneTenth_Dk_`year'    =1 if G5036==8

/* Now I create a categorical variable for which bin the respondent ends up in:
   Will go from most risk averse to least */
   
gen IncRAbin_`year' =0
replace IncRAbin_`year' =1 if G5036==1
replace IncRAbin_`year' =2 if G5036==2 & G5035==1
replace IncRAbin_`year' =3 if G5035==2 & G5027==1
replace IncRAbin_`year' =4 if G5027==2 & G5033==1
replace IncRAbin_`year' =5 if G5033==2 & G5034==1
replace IncRAbin_`year' =6 if G5034==2 



gen ProbMarketUp_`year'=.
gen FollowMarket_`year'=.
gen InherRAbin_`year'=.
gen BusRAbin_`year'=.

keep HHID PN ProbMarketUp_`year' ProbUSEconDep_`year' ProbDoubleDigitInf_`year' FollowMarket_`year' FinPlanCat_`year' IncRAbin_`year' InherRAbin_`year' BusRAbin_`year'

save "$CleanData/HRSExp`year'.dta", replace
