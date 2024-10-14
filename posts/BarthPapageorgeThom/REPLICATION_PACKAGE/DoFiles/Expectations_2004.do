
/* NOTE: THERE CAN BE MORE THAN ONE RESPONDENT WITHIN AN HHID-SUBHH HOUSEHOLD */

/* Setting up. Merge with the Pre Load values to know which random assignments households get */
clear all
local year "2004"
local smallyear="04"
local survey="$HRSSurveys04"
local rangemethod="mid" /* cab be "mid", "min", or "max"; could also bootstrap */
local impute_numobs=3

infile using "`survey'/h`smallyear'sta/H`smallyear'P_R.dct" , using("`survey'/h`smallyear'da/H`smallyear'P_R.da")
merge 1:1 HHID PN using "$CleanData/HRSPreLoad`year'.dta", assert(3)
tab _merge /* Should be all matched */
drop _merge
save "$CleanData/HRS_RAWwithPreLoad`year'.dta", replace

/* Need age data later, which comes from the Cross-Wave Tracker File, so will load
   that now, keep relevant variables and save, so can be easily merged later. */
use "$Tracker16/HRS_Tracker16.dta"
keep HHID PN J*
save "$CleanData/HRSTrackerSmall`year'.dta", replace

/* Now reload expectations data */
clear
use "$CleanData/HRS_RAWwithPreLoad`year'.dta"

/* What do you think are the chances that your income will keep up with the cost of
         living for the next five years? */
gen ProbRealIncUp_`year'              =JP004
gen ProbRealIncUp_Dk_`year'           =0
replace ProbRealIncUp_Dk_`year'       =1 if JP004==998		 
 
/* 	Now ask about bequests (including property and valuables) */
gen ProbBeqMoreThan10k_`year'         =JP005
gen ProbBeqMoreThan10k_Dk_`year'      =0
replace ProbBeqMoreThan10k_Dk_`year'=1 if JP005==998

gen ProbBeqMoreThan100k_`year'        =JP006
gen ProbBeqMoreThan100k_Dk_`year'     =0
replace ProbBeqMoreThan100k_Dk_`year' =1 if JP006==998

gen ProbBeqMoreThan500k_`year'        =JP059
gen ProbBeqMoreThan500k_Dk_`year'     =0
replace ProbBeqMoreThan500k_Dk_`year' =1 if JP059==998

gen ProbBeqAny_`year'                 =JP007
gen ProbBeqAny_Dk_`year'              =0
replace ProbBeqAny_Dk_`year'          =1 if JP007==998

/* What are the chances that you  [or your]   [you/husband/wife/partner]  will receive
   an inheritance during the next 10 years? */
gen ProbRecInher_`year'               =JP008
gen ProbRecInher_Dk_`year'            =0
replace ProbRecInher_Dk_`year'        =1 if JP008==998

/* How large do you expect the inheritence to be? */
gen SizeInher_`year'                  =JP010
gen SizeInher_Dk_`year'               =0
replace SizeInher_Dk_`year'           =1 if JP013==98 /* Using JP013 since recorded after binning */
gen SizeInherPointEst_`year'          =0
replace SizeInherPointEst_`year'      =1 if JP010<99999998
gen double SizeInher_minval           =JP011
gen double SizeInher_maxval           =JP012

local SizeInher_Binmin0   0
local SizeInher_Binmin1   10001
local SizeInher_Binmin2   50001
local SizeInher_Binmin3   250001
local SizeInher_Binmin4   1000001
local SizeInher_Binmax0   9999
local SizeInher_Binmax1   49999
local SizeInher_Binmax2   249999
local SizeInher_Binmax3   999999
local SizeInher_Binmax4   999999996
local SizeInher_Binexact1 10000
local SizeInher_Binexact2 50000
local SizeInher_Binexact3 250000
local SizeInher_Binexact4 1000000

/* Generating exact values here */
replace SizeInher_`year'=`SizeInher_Binexact1' if SizeInher_minval==`SizeInher_Binexact1' & SizeInher_maxval==`SizeInher_Binexact1'
replace SizeInher_`year'=`SizeInher_Binexact2' if SizeInher_minval==`SizeInher_Binexact2' & SizeInher_maxval==`SizeInher_Binexact2'
replace SizeInher_`year'=`SizeInher_Binexact3' if SizeInher_minval==`SizeInher_Binexact3' & SizeInher_maxval==`SizeInher_Binexact3'
replace SizeInher_`year'=`SizeInher_Binexact4' if SizeInher_minval==`SizeInher_Binexact4' & SizeInher_maxval==`SizeInher_Binexact4'

/* Generating median for bin "0" */
sum SizeInher_`year' if SizeInherPointEst_`year'==1 & SizeInher_`year'>=`SizeInher_Binmin0' & SizeInher_`year'<=`SizeInher_Binmax0', detail
assert r(N)>`impute_numobs'
replace SizeInher_`year'=r(p$bin_pctile) if SizeInher_minval==`SizeInher_Binmin0' & SizeInher_maxval==`SizeInher_Binmax0'

/* Generating median for bin 1 */
sum SizeInher_`year' if SizeInherPointEst_`year'==1 & SizeInher_`year'>=`SizeInher_Binmin1' & SizeInher_`year'<=`SizeInher_Binmax1', detail
assert r(N)>`impute_numobs'
replace SizeInher_`year'=r(p$bin_pctile) if SizeInher_minval==`SizeInher_Binmin1' & SizeInher_maxval==`SizeInher_Binmax1'

/* Generating median for bin 2 */
sum SizeInher_`year' if SizeInherPointEst_`year'==1 & SizeInher_`year'>=`SizeInher_Binmin2' & SizeInher_`year'<=`SizeInher_Binmax2', detail
assert r(N)>`impute_numobs'
replace SizeInher_`year'=r(p$bin_pctile) if SizeInher_minval==`SizeInher_Binmin2' & SizeInher_maxval==`SizeInher_Binmax2'

/* Generating median for bin 3 */
sum SizeInher_`year' if SizeInherPointEst_`year'==1 & SizeInher_`year'>=`SizeInher_Binmin3' & SizeInher_`year'<=`SizeInher_Binmax3', detail
assert r(N)>`impute_numobs'
replace SizeInher_`year'=r(p$bin_pctile) if SizeInher_minval==`SizeInher_Binmin3' & SizeInher_maxval==`SizeInher_Binmax3'

/* Generating median for bin 4 */
sum SizeInher_`year' if SizeInherPointEst_`year'==1 & SizeInher_`year'>=`SizeInher_Binmin4' & SizeInher_`year'<=`SizeInher_Binmax4', detail
assert r(N)>`impute_numobs'
replace SizeInher_`year'=r(p$bin_pctile) if SizeInher_minval==`SizeInher_Binmin4' & SizeInher_maxval==`SizeInher_Binmax4'


/* 	User Note: Any R who refuses or does not know how to answer the first three
    0-100 questions of section P, will not be asked any further questions in this
    section. The actual sequence of questions varies and depends on specific skips. */
gen CantDoProbs_`year'                =JP009

/*  Probability you lose job you want to keep. Only applies to households still working
    and not self-employed: J020=1 and J021~=2 */
gen ProbLoseJob_`year'                =JP014

/*  Probability you find "equally good job (as the one you had) in same line of work?
    Again, only for employed, those answering MP014. */
gen ProbFindJob_`year'                =JP015

/*  What is chance work for pay in the future? Only applies if not working (J020~=1)  */
gen ProbWorkforPay_`year'             =JP016
gen ProbWorkforPay_Dk_`year'          =0
replace ProbWorkforPay_Dk_`year'      =1 if JP016==998

/*  What is probability R will be working at 62? Only applies if less than 62 and JP016~=0 */
gen ProbWorkPost62_`year'             =JP017
gen ProbWorkPost62_Dk_`year'          =0
/*  Captures Dk to main question, then to the 0% and 100% follow up questions */
replace ProbWorkPost62_Dk_`year'      =1 if JP017==998

/*  What is probability R will be working at 65? Only applies if older than 62 and less than 65 and J021==1 */
gen ProbWorkPost65_`year'             =JP018
gen ProbWorkPost65_Dk_`year'          =0
replace ProbWorkPost65_Dk_`year'      =1 if JP018==998

/* Only applies if J505 or J517 is equal to one (is looking for a job) */
gen ProbFindJobFewMonths_`year'       =JP020
gen ProbFindJobFewMonths_Dk_`year'    =0
replace ProbFindJobFewMonths_Dk_`year'=1 if JP020==998

/* Chance that R moves in next two years */
gen ProbMoveNext2yrs_`year'           =JP021
gen ProbMoveNext2yrs_Dk_`year'        =0
replace ProbMoveNext2yrs_Dk_`year'    =1 if JP021==998

/* Will R move to another state? 1=yes, 2=no */
gen MoveNewState_`year'               =JP022
gen MoveNewState_Dk_`year'            =0
replace MoveNewState_Dk_`year'        =1 if JP022==8

/* Do you think you will buy or build a home, rent, move in with someone else or what?
          760           1. BUY OR BUILD
          398           2. RENT
          174           3. MOVE IN WITH SOMEONE ELSE
           69           8. DK (Don't Know); NA (Not Ascertained) */
gen HomeIfMove_`year'                 =JP025
gen HomeIfMove_Dk_`year'              =0
replace HomeIfMove_Dk_`year'          =1 if JP025==8

/* With whom would you live?
           73           1. CHILD
            7           2. PARENT
           58           3. OTHER RELATIVE
           24           5. ASSISTED LIVING OR OTHER LONG TERM CARE FACILITY
            8           7. OTHER (SPECIFY)
            4           8. DK (Don't Know); NA (Not Ascertained) */
gen WhomLiveWithIfMove_`year'         =JP026
gen WhomLiveWithIfMove_Dk_`year'      =0
replace WhomLiveWithIfMove_Dk_`year'  =1 if JP026==8			
	   

/* Percent chance live to be 75 or more */
gen ProbLive75More_`year'             =JP028
gen ProbLive75More_Dk_`year'          =0
replace ProbLive75More_Dk_`year'      =1 if JP028==998
			
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

/* What is the percent chance that you will live to be [85/80/90/95/100] or more?
         80 (IF AGE IS 65-69)
         85 (IF AGE IS 70-74)
         90 (IF AGE IS 75-79)
         95 (IF AGE IS 80-84)
         100 (IF AGE IS 85-89) */		 
gen ProbLiveToVarious_`year'          =JP029
gen ProbLiveToVarious_Dk_`year'       =0
replace ProbLiveToVarious_Dk_`year'   =1 if JP029==998

gen ProbLiveTo80_`year'=0
replace ProbLiveTo80_`year'=1 if JAGE<=69 & ProbLiveToVarious_`year'~=.
gen ProbLiveTo85_`year'=0
replace ProbLiveTo85_`year'=1 if (JAGE>=70 & JAGE<=74 & ProbLiveToVarious_`year'~=.)
gen ProbLiveTo90_`year'=0
replace ProbLiveTo90_`year'=1 if JAGE>=75 & JAGE<=79 & ProbLiveToVarious_`year'~=.
gen ProbLiveTo95_`year'=0
replace ProbLiveTo95_`year'=1 if JAGE>=80 & JAGE<=84 & ProbLiveToVarious_`year'~=.
gen ProbLiveTo100_`year'=0
replace ProbLiveTo100_`year'=1 if JAGE>=85 & JAGE<=89 & ProbLiveToVarious_`year'~=.

/* Chance medical expensus use up all of savings in next 5 years*/
gen ProbMedUseAllSav5yrs_`year'       =JP070
gen ProbMedUseAllSav5yrs_Dk_`year'    =0
replace ProbMedUseAllSav5yrs_Dk_`year'=1 if JP070==998

/* Chances give $5k in financial help to grown children, family, or friends? */
gen GiveFinHelp5k_`year'              =JP030
gen GiveFinHelp5k_Dk_`year'           =0
replace GiveFinHelp5k_Dk_`year'       =1 if JP030==998

/* Chances give $1k in financial help to grown children, family, or friends? */
gen GiveFinHelp1k_`year'              =JP071
gen GiveFinHelp1k_Dk_`year'           =0
replace GiveFinHelp1k_Dk_`year'       =1 if JP071==998

/* Chances give $10k in financial help to grown children, family, or friends? */
gen GiveFinHelp10k_`year'             =JP072
gen GiveFinHelp10k_Dk_`year'          =0
replace GiveFinHelp10k_Dk_`year'      =1 if JP072==998

/* Chances give $20k in financial help to grown children, family, or friends? */
gen GiveFinHelp20k_`year'             =JP073
gen GiveFinHelp20k_Dk_`year'          =0
replace GiveFinHelp20k_Dk_`year'      =1 if JP073==998

/* Chances receive $5k in financial help from grown children, family, or friends? */
gen RecFinHelp5k_`year'               =JP031
gen RecFinHelp5k_Dk_`year'            =0
replace RecFinHelp5k_Dk_`year'        =1 if JP031==998

/* Chances receive $2.5k in financial help from grown children, family, or friends? */
gen RecFinHelp2pt5k_`year'            =JP074
gen RecFinHelp2pt5k_Dk_`year'         =0
replace RecFinHelp2pt5k_Dk_`year'     =1 if JP074==998

/* Chances receive $1k in financial help from grown children, family, or friends? */
gen RecFinHelp1k_`year'               =JP075
gen RecFinHelp1k_Dk_`year'            =0
replace RecFinHelp1k_Dk_`year'        =1 if JP075==998

/* Chances receive $10k in financial help from grown children, family, or friends? */
gen RecFinHelp10k_`year'              =JP076
gen RecFinHelp10k_Dk_`year'           =0
replace RecFinHelp10k_Dk_`year'       =1 if JP076==998

/* What is chance will have to move to a nursuing home ever (in next 5 years)?
   If age<65, question is ever. If age>=65, question is in next 5 years. */
gen ProbMoveToNH_`year'               =JP032
gen ProbMoveToNH_Dk_`year'            =0
replace ProbMoveToNH_Dk_`year'        =1 if JP032==998
gen NH5years_`year'                   =0
replace NH5years_`year'               =1 if JAGE>=65
gen NHEver_`year'                     =0
replace NHEver_`year'                 =1 if JAGE<65

/* Probability US has economic depression in next 10 years */
gen ProbUSEconDep_`year'              =JP034
gen ProbUSEconDep_Dk_`year'           =0
replace ProbUSEconDep_Dk_`year'       =1 if JP034==998
						
/* Chance that mutual fund shares invested in blue chip stocks worth more next year */
gen ProbMarketUp_`year'               =JP047
gen ProbMarketUp_Dk_`year'            =0
replace ProbMarketUp_Dk_`year'        =1 if JP047==998

/* How closely do you follow the stock market? */
gen FollowMarket_`year'               =JP097
gen FollowMarket_Dk_`year'            =0
replace FollowMarket_Dk_`year'        =1 if JP097==998

gen     FinPlanPerFewMonths_`year'    =0
gen     FinPlanPerOneYr_`year'        =0
gen     FinPlanPerFewYrs_`year'       =0
gen     FinPlanPerFiveTenYrs_`year'   =0
gen     FinPlanPerMoreTenYrs_`year'   =0
replace FinPlanPerFewMonths_`year'    =1 if JP041==1
replace FinPlanPerOneYr_`year'        =1 if JP041==2
replace FinPlanPerFewYrs_`year'       =1 if JP041==3
replace FinPlanPerFiveTenYrs_`year'   =1 if JP041==4
replace FinPlanPerMoreTenYrs_`year'   =1 if JP041==5

gen FinPlanCat_`year'=JP041

/* Will children have higher, lower, same standard of living at your age? */
gen     ChildBetterOff_`year'         =0
gen     ChildWorseOff_`year'          =0
gen     ChildSameOff_`year'           =0
replace ChildBetterOff_`year'         =1 if JP042==1
replace ChildWorseOff_`year'          =1 if JP042==2
replace ChildSameOff_`year'           =1 if JP042==3

/* Follow up about "much" better or worse off. 1=yes, 0=no. */
gen     ChildMuchBetter_`year'        =0
replace ChildMuchBetter_`year'        =1 if JP043==1
gen     ChildMuchWorse_`year'         =0
replace ChildMuchWorse_`year'         =1 if JP044==1

/* Did you get help filling out this section */
gen     NoExpHelp_`year'              =0
gen     SomeExpHelp_`year'            =0
gen     LotExpHelp_`year'             =0
gen     ProxyExpHelp_`year'           =0
replace NoExpHelp_`year'              =1 if JP056==1
replace SomeExpHelp_`year'            =1 if JP056==2
replace LotExpHelp_`year'             =1 if JP056==3
replace ProxyExpHelp_`year'           =1 if JP056==4

/*************************************************************************
					RISK AVERSION QUESTIONS
*************************************************************************/

/******* Income Gambles *************/
/* Income gamble: choose between guaranteed lifetime income (current) or 50-50 gamble that
   lifetime income would double or be cut by one-third. 1=first job, 2=second. */
gen IncGambleOneThird_`year'           =JP036
gen IncGambleOneThird_Dk_`year'        =0
replace IncGambleOneThird_Dk_`year'    =1 if JP036==8

/* Income gamble: If YES to JP036, choose between guaranteed lifetime income (current) or 50-50 gamble that
   lifetime income would double or be cut by one-half. 1=first job, 2=second. */
gen IncGambleOneHalf_`year'            =JP037
gen IncGambleOneHalf_Dk_`year'         =0
replace IncGambleOneHalf_Dk_`year'     =1 if JP037==8

/* Income gamble: If YES to JP037, choose between guaranteed lifetime income (current) or 50-50 gamble that
   lifetime income would double or be cut by 75%. 1=first job, 2=second. */
gen IncGamble75perc_`year'             =JP038
gen IncGamble75perc_Dk_`year'          =0
replace IncGamble75perc_Dk_`year'      =1 if JP038==8

/* Income gamble: If NO to JP036, choose between guaranteed lifetime income (current) or 50-50 gamble that
   lifetime income would double or be cut by 20%. 1=first job, 2=second. */
gen IncGambleOneFifth_`year'           =JP039
gen IncGambleOneFifth_Dk_`year'        =0
replace IncGambleOneFifth_Dk_`year'    =1 if JP039==8

/* Income gamble: If NO to JP039, choose between guaranteed lifetime income (current) or 50-50 gamble that
   lifetime income would double or be cut by 10%. 1=first job, 2=second. */
gen IncGambleOneTenth_`year'           =JP040
gen IncGambleOneTenth_Dk_`year'        =0
replace IncGambleOneTenth_Dk_`year'    =1 if JP040==8

/* Now I create a categorical variable for which bin the respondent ends up in:
   Will go from most risk averse to least. So we have the following:
   Bin 1: answer 1 to JP040
   Bin 2: answer 2 to JP040 but 1 to JP039
   Bin 3: answer 2 to JP039 but 1 to JP036
   Bin 4: answer 2 to JP036 but 1 to JP037
   Bin 5: answer 2 to JP037 but 1 to JP038
   Bin 6: answer 2 to JP038 */
   
gen IncRAbin_`year' =0
replace IncRAbin_`year'=1 if JP040==1
replace IncRAbin_`year'=2 if JP040==2 & JP039==1
replace IncRAbin_`year'=3 if JP039==2 & JP036==1
replace IncRAbin_`year'=4 if JP036==2 & JP037==1
replace IncRAbin_`year'=5 if JP037==2 & JP038==1
replace IncRAbin_`year'=6 if JP038==2 


gen ProbDoubleDigitInf_`year'=.
gen InherRAbin_`year'=.
gen BusRAbin_`year'=.

keep HHID PN ProbMarketUp_`year' ProbUSEconDep_`year' ProbDoubleDigitInf_`year' FollowMarket_`year' FinPlanCat_`year' IncRAbin_`year' InherRAbin_`year' BusRAbin_`year'

save "$CleanData/HRSExp`year'.dta", replace
