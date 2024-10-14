
/* NOTE: THERE CAN BE MORE THAN ONE RESPONDENT WITHIN AN HHID-SUBHH HOUSEHOLD */

/* Setting up. Merge with the Pre Load values to know which random assignments households get */
clear all
local year "1998"
local smallyear="98"
local survey="$HRSSurveys98"
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
keep HHID PN F*
save "$CleanData/HRSTrackerSmall`year'.dta", replace

/* Now reload expectations data */
clear
use "$CleanData/HRS_RAWwithPreLoad`year'.dta"

/* What do you think are the chances that your income will keep up with the cost of
         living for the next five years? */
gen ProbRealIncUp_`year'              =F4571
gen ProbRealIncUp_Dk_`year'           =0
replace ProbRealIncUp_Dk_`year'       =1 if F4571==998		 
 
/* 	Now ask about bequests (including property and valuables) */
gen ProbBeqMoreThan10k_`year'         =F4572
gen ProbBeqMoreThan10k_Dk_`year'      =0
replace ProbBeqMoreThan10k_Dk_`year'=1 if F4572==998

gen ProbBeqMoreThan100k_`year'        =F4574
gen ProbBeqMoreThan100k_Dk_`year'     =0
replace ProbBeqMoreThan100k_Dk_`year' =1 if F4574==998

gen ProbBeqAny_`year'                 =F4575
gen ProbBeqAny_Dk_`year'              =0
replace ProbBeqAny_Dk_`year'          =1 if F4575==998

/* What are the chances that you  [or your]   [you/husband/wife/partner]  will receive
   an inheritance during the next 10 years? */
gen ProbRecInher_`year'               =F4576
gen ProbRecInher_Dk_`year'            =0
replace ProbRecInher_Dk_`year'        =1 if F4576==998

/* How large do you expect the inheritence to be? */
gen SizeInher_`year'                  =F4578
gen SizeInher_Dk_`year'               =0
replace SizeInher_Dk_`year'           =1 if F4578==99999998
gen SizeInherPointEst_`year'          =0
replace SizeInherPointEst_`year'      =1 if F4578<99999997

local Inher_Bin1 10000
local Inher_Bin2 50000
local Inher_Bin3 250000
local Inher_Bin4 1000000

replace SizeInher_`year'=10000   if F4580==3
replace SizeInher_`year'=50000   if F4579==3
replace SizeInher_`year'=250000  if F4581==3
replace SizeInher_`year'=1000000 if F4582==3


**** Less than first bin lower bound ****
sum SizeInher_`year' if SizeInherPointEst_`year'==1 & SizeInher_`year'>0 & SizeInher_`year'<`Inher_Bin1', detail
*return list
assert r(N)>`impute_numobs'
replace SizeInher_`year'=r(p$bin_pctile) if F4580==1

**** Second Bin ****
sum SizeInher_`year' if SizeInherPointEst_`year'==1 & SizeInher_`year'>`Inher_Bin1' & SizeInher_`year'<`Inher_Bin2', detail
*return list
assert r(N)>`impute_numobs'
replace SizeInher_`year'=r(p$bin_pctile) if F4580==5 & F4579==1

**** Third Bin ****
sum SizeInher_`year' if SizeInherPointEst_`year'==1 & SizeInher_`year'>`Inher_Bin2' & SizeInher_`year'<`Inher_Bin3', detail
*return list
assert r(N)>`impute_numobs'
replace SizeInher_`year'=r(p$bin_pctile) if F4579==5 & F4581==1

**** Fourth Bin ****
sum SizeInher_`year' if SizeInherPointEst_`year'==1 & SizeInher_`year'>`Inher_Bin3' & SizeInher_`year'<`Inher_Bin4', detail
*return list
assert r(N)>`impute_numobs'
replace SizeInher_`year'=r(p$bin_pctile) if F4581==5 & F4582==1

**** Fifth Bin ****
sum SizeInher_`year' if SizeInherPointEst_`year'==1 & SizeInher_`year'>`Inher_Bin4' & SizeInher_`year'<=99999996, detail
*return list
assert r(N)>`impute_numobs'
replace SizeInher_`year'=r(p$bin_pctile) if F4582==5

/* Replace Dk again */
*replace SizeInher_Dk_`year'           =0 if SizeInher_`year'~=.


/* 	User Note: Any R who refuses or does not know how to answer the first three
    0-100 questions of section P, will not be asked any further questions in this
    section. The actual sequence of questions varies and depends on specific skips.
	0= can't do, 1=can do. */
gen CantDoProbs_`year'                =F4577

/*  Probability you lose job you want to keep. Only applies to households still working
    and not self-employed: J020=1 and J021~=2 */
gen ProbLoseJob_`year'                =F4583
gen ProbLoseJob_Dk_`year'             =0
replace ProbLoseJob_Dk_`year'         =1 if F4583==998

/*  Probability you find "equally good job (as the one you had) in same line of work?
    Again, only for employed, those answering MP014. */
gen ProbFindJob_`year'                =F4584
gen ProbFindJob_Dk_`year'             =0
replace ProbFindJob_Dk_`year'         =1 if F4584==998

/*  What is chance work for pay in the future? Only applies if not working (J020~=1)  */
gen ProbWorkforPay_`year'             =F4585
gen ProbWorkforPay_Dk_`year'          =0
replace ProbWorkforPay_Dk_`year'      =1 if F4585==998

/*  What is probability R will be working at 62? Only applies if less than 62 and HP016~=0 */
gen ProbWorkPost62_`year'             =F4589
gen ProbWorkPost62_Dk_`year'          =0
replace ProbWorkPost62_Dk_`year'      =1 if F4589==998

/*  What is probability R will be working at 65? Only applies if older than 62 and less than 65 and J021==1 */
gen ProbWorkPost65_`year'             =F4590
gen ProbWorkPost65_Dk_`year'          =0
replace ProbWorkPost65_Dk_`year'      =1 if F4590==998

/* Probability health will limit work activity in next 10 years */
gen HealthLimitWork_`year'            =F4591
gen HealthLimitWork_Dk_`year'         =0
replace HealthLimitWork_Dk_`year'     =1 if F4591==998

/* Only applies if J505 or J517 is equal to one (is looking for a job) */
gen ProbFindJobFewMonths_`year'       =F4593
gen ProbFindJobFewMonths_Dk_`year'    =0
replace ProbFindJobFewMonths_Dk_`year'=1 if F4593==998

/* Chance that R moves in next two years */
gen ProbMoveNext2yrs_`year'           =F4597
gen ProbMoveNext2yrs_Dk_`year'        =0
replace ProbMoveNext2yrs_Dk_`year'    =1 if F4597==998

/* Will R move to another state? 1=yes, 2=no */
gen MoveNewState_`year'               =F4598
gen MoveNewState_Dk_`year'            =0
replace MoveNewState_Dk_`year'        =1 if F4598==8

/* Which State? (Masked to protect anonymity). Dk has 0 observations. */
gen MoveWhichState_`year'             =F4599M

/* Do you think you will buy or build a home, rent, move in with someone else or what? */
gen HomeIfMove_`year'                 =F4602
gen HomeIfMove_Dk_`year'              =0
replace HomeIfMove_Dk_`year'          =1 if F4602==8

/* With whom would you live? */
gen WhomLiveWithIfMove_`year'         =F4603
gen WhomLiveWithIfMove_Dk_`year'      =0
replace WhomLiveWithIfMove_Dk_`year'  =1 if F4603==8			
	   
/* Percent chance live to be 75 or more */
gen ProbLive75More_`year'             =F4605
gen ProbLive75More_Dk_`year'          =0
replace ProbLive75More_Dk_`year'      =1 if F4605==998
			
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
assert `r(N)' == 1 
count if _m == 3 
assert `r(N)' == `obscount' - 1
tab _merge /* Merge 3 should be equal to number of HHIDnum observations above
			  MZ note - this is not true for this file.*/

/* In 2000 onward, ask about probability of living to various ages. In 1998 and previous,
   only ask about living to 85.  */		 
gen ProbLiveToVarious_`year'          =F4607
gen ProbLiveToVarious_Dk_`year'       =0
replace ProbLiveToVarious_Dk_`year'   =1 if F4607==998
  /* Everyone asked about living to 85 only */
gen ProbLiveTo80_`year'               =0
gen ProbLiveTo85_`year'               =0
replace ProbLiveTo85_`year'           =1 if F4607~=.
gen ProbLiveTo90_`year'               =0
gen ProbLiveTo95_`year'               =0
gen ProbLiveTo100_`year'              =0

/* Chances give $5k in financial help to grown children, family, or friends? */
gen GiveFinHelp5k_`year'              =F4608
gen GiveFinHelp5k_Dk_`year'           =0
replace GiveFinHelp5k_Dk_`year'       =1 if F4608==998

/* Chances receive $5k in financial help from grown children, family, or friends? */
gen RecFinHelp5k_`year'               =F4609
gen RecFinHelp5k_Dk_`year'            =0
replace RecFinHelp5k_Dk_`year'        =1 if F4609==998

/* What is chance will have to move to a nursuing home ever (in next 5 years)?
   If age<65, question is ever. If age>=65, question is in next 5 years. */
gen ProbMoveToNH_`year'               =F4610
gen ProbMoveToNH_Dk_`year'            =0
replace ProbMoveToNH_Dk_`year'        =1 if F4610==998
gen NH5years_`year'                   =0
replace NH5years_`year'               =1 if FAGE>=65
gen NHEver_`year'                     =0
replace NHEver_`year'                 =1 if FAGE<65

/* Chance U.S. experiences double-digit inflation in next ten years */
gen ProbDoubleDigitInf_`year'         =F4611
gen ProbDoubleDigitInf_Dk_`year'      =0
replace ProbDoubleDigitInf_Dk_`year'  =1 if F4611==998

/* Probability US has economic depression in next 10 years */
gen ProbUSEconDep_`year'              =F4612
gen ProbUSEconDep_Dk_`year'           =0
replace ProbUSEconDep_Dk_`year'       =1 if F4612==998

/* Probability congress changes social security to be less generous in next
   10 years. */
gen SSChangeLessGenerous_`year'       =F4613
gen SSChangeLessGenerous_Dk_`year'    =0
replace SSChangeLessGenerous_Dk_`year'=1 if F4613==998

/* In deciding how much of their  family) income to spend or save, people are likely to think about
   different financial planning periods. In planning your (family's) saving and spending, which of
   the following time periods is most important to you (and your (husband/wife/partner)), the next
   few months, the next year, the next few years, the next 5-10 years, or longer than 10 years? */
gen     FinPlanPerFewMonths_`year'    =0
gen     FinPlanPerOneYr_`year'        =0
gen     FinPlanPerFewYrs_`year'       =0
gen     FinPlanPerFiveTenYrs_`year'   =0
gen     FinPlanPerMoreTenYrs_`year'   =0
replace FinPlanPerFewMonths_`year'    =1 if F4619==1
replace FinPlanPerOneYr_`year'        =1 if F4619==2
replace FinPlanPerFewYrs_`year'       =1 if F4619==3
replace FinPlanPerFiveTenYrs_`year'   =1 if F4619==4
replace FinPlanPerMoreTenYrs_`year'   =1 if F4619==5

gen FinPlanCat_`year'=F4619

/* Will children have higher, lower, same standard of living at your age? */
gen     ChildBetterOff_`year'         =0
gen     ChildWorseOff_`year'          =0
gen     ChildSameOff_`year'           =0
replace ChildBetterOff_`year'         =1 if F4620==1
replace ChildWorseOff_`year'          =1 if F4620==2
replace ChildSameOff_`year'           =1 if F4620==3

/* Follow up about "much" better or worse off. 1=yes, 0=no. */
gen     ChildMuchBetter_`year'        =0
replace ChildMuchBetter_`year'        =1 if F4621==1
gen     ChildMuchWorse_`year'         =0
replace ChildMuchWorse_`year'         =1 if F4622==1


/*************************************************************************
					RISK AVERSION QUESTIONS
*************************************************************************/

/******* Income Gambles *************/
/* Income gamble: choose between guaranteed lifetime income (current) or 50-50 gamble that
   lifetime income would double or be cut by one-third. 1=first job, 2=second. */
gen IncGambleOneThird_`year'           =F4614
gen IncGambleOneThird_Dk_`year'        =0
replace IncGambleOneThird_Dk_`year'    =1 if F4614==8

/* Income gamble: If YES to HP036, choose between guaranteed lifetime income (current) or 50-50 gamble that
   lifetime income would double or be cut by one-half. 1=first job, 2=second. */
gen IncGambleOneHalf_`year'            =F4615
gen IncGambleOneHalf_Dk_`year'         =0
replace IncGambleOneHalf_Dk_`year'     =1 if F4615==8

/* Income gamble: If YES to HP037, choose between guaranteed lifetime income (current) or 50-50 gamble that
   lifetime income would double or be cut by 75%. 1=first job, 2=second. */
gen IncGamble75perc_`year'             =F4616
gen IncGamble75perc_Dk_`year'          =0
replace IncGamble75perc_Dk_`year'      =1 if F4616==8

/* Income gamble: If NO to HP036, choose between guaranteed lifetime income (current) or 50-50 gamble that
   lifetime income would double or be cut by 20%. 1=first job, 2=second. */
gen IncGambleOneFifth_`year'           =F4617
gen IncGambleOneFifth_Dk_`year'        =0
replace IncGambleOneFifth_Dk_`year'    =1 if F4617==8

/* Income gamble: If NO to HP039, choose between guaranteed lifetime income (current) or 50-50 gamble that
   lifetime income would double or be cut by 10%. 1=first job, 2=second. */
gen IncGambleOneTenth_`year'           =F4618
gen IncGambleOneTenth_Dk_`year'        =0
replace IncGambleOneTenth_Dk_`year'    =1 if F4618==8

/* Now I create a categorical variable for which bin the respondent ends up in:
   Will go from most risk averse to least */
   
gen IncRAbin_`year' =0
replace IncRAbin_`year' =1 if F4618==1
replace IncRAbin_`year' =2 if F4618==2 & F4617==1
replace IncRAbin_`year' =3 if F4617==2 & F4614==1
replace IncRAbin_`year' =4 if F4614==2 & F4615==1
replace IncRAbin_`year' =5 if F4615==2 & F4616==1
replace IncRAbin_`year' =6 if F4616==2 


gen ProbMarketUp_`year'=.
gen FollowMarket_`year'=.
gen InherRAbin_`year'=.
gen BusRAbin_`year'=.

keep HHID PN ProbMarketUp_`year' ProbUSEconDep_`year' ProbDoubleDigitInf_`year' FollowMarket_`year' FinPlanCat_`year' IncRAbin_`year' InherRAbin_`year' BusRAbin_`year'

save "$CleanData/HRSExp`year'.dta", replace
