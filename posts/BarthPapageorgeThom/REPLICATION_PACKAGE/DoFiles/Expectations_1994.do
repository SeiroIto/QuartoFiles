
/* NOTE: 1994 (and 1992) are much different from later years, so the loading process in this file differs
   from the later years. */

/* Setting up */
clear all
local year "1994"
local smallyear="94"
local survey="$HRSSurveys94"
local rangemethod="mid" /* cab be "mid", "min", or "max"; could also bootstrap */
local impute_numobs=3

/* Need age data later, which comes from the Cross-Wave Tracker File, so will load
   that now, keep relevant variables and save, so can be easily merged later. */
use "$Tracker16/HRS_Tracker16.dta"
keep HHID PN C*
save "$CleanData/HRSTrackerSmall`year'.dta", replace
clear

/* Now load expectations data */
infile using "`survey'/h`smallyear'sta/W2C.dct" , using("`survey'/h`smallyear'da/W2C.da")

/* 	Now ask about bequests (including property and valuables) */
gen ProbBeqMoreThan10k_`year'         =W5843
gen ProbBeqMoreThan10k_Dk_`year'      =0
replace ProbBeqMoreThan10k_Dk_`year'=1 if W5843==998

gen ProbBeqMoreThan100k_`year'        =W5844
gen ProbBeqMoreThan100k_Dk_`year'     =0
replace ProbBeqMoreThan100k_Dk_`year' =1 if W5844==998

/* What are the chances that you  [or your]   [you/husband/wife/partner]  will receive
   an inheritance during the next 10 years? */
gen ProbRecInher_`year'               =W5845
gen ProbRecInher_Dk_`year'            =0
replace ProbRecInher_Dk_`year'        =1 if W5845==998

/* How large do you expect the inheritence to be? */
gen SizeInher_`year'                  =W5846
gen SizeInher_Dk_`year'               =0
replace SizeInher_Dk_`year'           =1 if W5846==9999998
gen SizeInherPointEst_`year'          =0
replace SizeInherPointEst_`year'      =1 if W5846<9999997

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
replace SizeInher_`year'=r(p$bin_pctile) if W5847==7

**** Second Bin ****
sum SizeInher_`year' if SizeInherPointEst_`year'==1 & SizeInher_`year'>`Inher_Bin1' & SizeInher_`year'<`Inher_Bin2', detail
*return list
assert r(N)>`impute_numobs'
replace SizeInher_`year'=r(p$bin_pctile) if W5847==6

**** Third Bin ****
sum SizeInher_`year' if SizeInherPointEst_`year'==1 & SizeInher_`year'>`Inher_Bin2' & SizeInher_`year'<`Inher_Bin3', detail
*return list
assert r(N)>`impute_numobs'
replace SizeInher_`year'=r(p$bin_pctile) if W5847==4

**** Fourth Bin ****
sum SizeInher_`year' if SizeInherPointEst_`year'==1 & SizeInher_`year'>`Inher_Bin3' & SizeInher_`year'<`Inher_Bin4', detail
*return list
assert r(N)>`impute_numobs'
replace SizeInher_`year'=r(p$bin_pctile) if W5847==2

**** Fifth Bin ****
sum SizeInher_`year' if SizeInherPointEst_`year'==1 & SizeInher_`year'>`Inher_Bin4' & SizeInher_`year'<=99999996, detail
*return list
assert r(N)>`impute_numobs'
replace SizeInher_`year'=r(p$bin_pctile) if W5847==1

/* Replace Dk again */
*replace SizeInher_Dk_`year'           =0 if SizeInher_`year'~=.

/*  Probability you lose job you want to keep. Only applies to households still working
    and not self-employed: J020=1 and J021~=2 */
gen ProbLoseJob_`year'                =W5801
gen ProbLoseJob_Dk_`year'             =0
replace ProbLoseJob_Dk_`year'         =1 if W5801==998

/*  Probability you find "equally good job (as the one you had) in same line of work?
    Again, only for employed, those answering MP014. */
gen ProbFindJob_`year'                =W5802
gen ProbFindJob_Dk_`year'             =0
replace ProbFindJob_Dk_`year'         =1 if W5802==998

/*  What is chance work for pay in the future? Only applies if not working (J020~=1)  */
gen ProbWorkforPay_`year'             =W5803
gen ProbWorkforPay_Dk_`year'          =0
replace ProbWorkforPay_Dk_`year'      =1 if W5803==998

/*  What is probability R will be working at 62? Only applies if less than 62 and HP016~=0 */
gen ProbWorkPost62_`year'             =W5804
gen ProbWorkPost62_Dk_`year'          =0
replace ProbWorkPost62_Dk_`year'      =1 if W5804==998

/*  What is probability R will be working at 65? Only applies if older than 62 and less than 65 and J021==1 */
gen ProbWorkPost65_`year'             =W5805
gen ProbWorkPost65_Dk_`year'          =0
replace ProbWorkPost65_Dk_`year'      =1 if W5805==998

/* Probability health will limit work activity in next 10 years */
gen HealthLimitWork_`year'            =W5806
gen HealthLimitWork_Dk_`year'         =0
replace HealthLimitWork_Dk_`year'     =1 if W5806==998

/* Only applies if J505 or J517 is equal to one (is looking for a job) */
gen ProbFindJobFewMonths_`year'       =W5807
gen ProbFindJobFewMonths_Dk_`year'    =0
replace ProbFindJobFewMonths_Dk_`year'=1 if W5807==998

/* Suppose you were to look for a job with the same pay and benefits as your (current/last) job,
   but where you could work only three days a week if you wanted to. What are the chances that
   you could find a job like that within a few months? */
gen ProbFind3DayJob_`year'	          =W5808
gen ProbFind3DayJob_Dk_`year'         =0
replace ProbFind3DayJob_Dk_`year'     =1 if W5808==998	

/* Suppose you were willing to take a 20 percent pay cut to find a job like your (current/last) job,
   but where you could work only three days a week if you wanted to. What are the chances that you
   could find a job like that within a few months? */
gen ProbFind3DayJob20cut_`year'	          =W5809
gen ProbFind3DayJob20cut_Dk_`year'    =0
replace ProbFind3DayJob20cut_Dk_`year'=1 if W5809==998

/* Chance that R moves in next two years */
gen ProbMoveNext2yrs_`year'           =W5833
gen ProbMoveNext2yrs_Dk_`year'        =0
replace ProbMoveNext2yrs_Dk_`year'    =1 if W5833==998

/* Will R move to another state? 1=yes, 2=no */
gen MoveNewState_`year'               =W5834
gen MoveNewState_Dk_`year'            =0
replace MoveNewState_Dk_`year'        =1 if W5834==8

/* Which State? (Masked to protect anonymity). Dk has 0 observations. */
gen MoveWhichState_`year'             =W5835

/* Do you think you will buy or build a home, rent, move in with someone else or what? */
gen HomeIfMove_`year'                 =W5836
gen HomeIfMove_Dk_`year'              =0
replace HomeIfMove_Dk_`year'          =1 if W5836==8

/* With whom would you live? */
gen WhomLiveWithIfMove_`year'         =W5837
gen WhomLiveWithIfMove_Dk_`year'      =0
replace WhomLiveWithIfMove_Dk_`year'  =1 if W5837==8

/* What are the chances that you will move to another location when you retire? */
gen ProbMoveWhenRetire_`year'         =W5838
gen ProbMoveWhenRetire_Dk_`year'      =0
replace ProbMoveWhenRetire_Dk_`year'  =1 if W5838==998

/* Percent chance live to be 75 or more */
gen ProbLive75More_`year'             =W5839
gen ProbLive75More_Dk_`year'          =0
replace ProbLive75More_Dk_`year'      =1 if W5839==998
			
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
gen ProbLiveToVarious_`year'          =W5840
gen ProbLiveToVarious_Dk_`year'       =0
replace ProbLiveToVarious_Dk_`year'   =1 if W5840==998
  /* Everyone asked about living to 85 only */
gen ProbLiveTo80_`year'               =0
gen ProbLiveTo85_`year'               =0
replace ProbLiveTo85_`year'           =1 if W5840~=.
gen ProbLiveTo90_`year'               =0
gen ProbLiveTo95_`year'               =0
gen ProbLiveTo100_`year'              =0

/* Chances give $5k in financial help to grown children, family, or friends? */
gen GiveFinHelp5k_`year'              =W5841
gen GiveFinHelp5k_Dk_`year'           =0
replace GiveFinHelp5k_Dk_`year'       =1 if W5841==998

/* Chances receive $5k in financial help from grown children, family, or friends? */
gen RecFinHelp5k_`year'               =W5842
gen RecFinHelp5k_Dk_`year'            =0
replace RecFinHelp5k_Dk_`year'        =1 if W5842==998

/* What is chance will have to move to a nursuing in next 5 years? */
gen ProbMoveToNH_`year'               =W5848
gen ProbMoveToNH_Dk_`year'            =0
replace ProbMoveToNH_Dk_`year'        =1 if W5848==998
gen NH5years_`year'                   =1 if W5848>=0 & W5848<=100

/* Chance U.S. experiences double-digit inflation in next ten years */
gen ProbDoubleDigitInf_`year'         =W5849
gen ProbDoubleDigitInf_Dk_`year'      =0
replace ProbDoubleDigitInf_Dk_`year'  =1 if W5849==998

/* Probability US has economic depression in next 10 years */
gen ProbUSEconDep_`year'              =W5850
gen ProbUSEconDep_Dk_`year'           =0
replace ProbUSEconDep_Dk_`year'       =1 if W5850==998

/* Did parents have higher, lower, same standard of living at your age? */
gen     ParentBetterOff_`year'         =0
gen     ParentWorseOff_`year'          =0
gen     ParentSameOff_`year'           =0
replace ParentBetterOff_`year'         =1 if W5851==1
replace ParentWorseOff_`year'          =1 if W5851==2
replace ParentSameOff_`year'           =1 if W5851==3

/* Follow up about "much" better or worse off. 1=yes, 0=no. */
gen     ParentMuchBetter_`year'        =0
replace ParentMuchBetter_`year'        =1 if W5852==1
gen     ParentMuchWorse_`year'         =0
replace ParentMuchWorse_`year'         =1 if W5853==1

/* Will children have higher, lower, same standard of living at your age? */
gen     ChildBetterOff_`year'         =0
gen     ChildWorseOff_`year'          =0
gen     ChildSameOff_`year'           =0
replace ChildBetterOff_`year'         =1 if W5854==1
replace ChildWorseOff_`year'          =1 if W5854==2
replace ChildSameOff_`year'           =1 if W5854==3

/* Follow up about "much" better or worse off. 1=yes, 0=no. */
gen     ChildMuchBetter_`year'        =0
replace ChildMuchBetter_`year'        =1 if W5855==1
gen     ChildMuchWorse_`year'         =0
replace ChildMuchWorse_`year'         =1 if W5856==1

gen FinPlanCat_`year'=.
gen ProbMarketUp_`year'=.
gen FollowMarket_`year'=.
gen IncRAbin_`year'=.
gen InherRAbin_`year'=.
gen BusRAbin_`year'=.

keep HHID PN ProbMarketUp_`year' ProbUSEconDep_`year' ProbDoubleDigitInf_`year' FollowMarket_`year' FinPlanCat_`year' IncRAbin_`year' InherRAbin_`year' BusRAbin_`year'

save "$CleanData/HRSExp`year'.dta", replace
