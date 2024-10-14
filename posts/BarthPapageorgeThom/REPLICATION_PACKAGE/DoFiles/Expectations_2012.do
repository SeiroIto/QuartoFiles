
/* NOTE: THERE CAN BE MORE THAN ONE RESPONDENT WITHIN AN HHID-SUBHH HOUSEHOLD */

/* Setting up. Merge with the Pre Load values to know which random assignments households get */
clear all
local year "2012"
local smallyear="12"
local survey="$HRSSurveys12"

infile using "`survey'/h`smallyear'sta/H`smallyear'P_R.dct" , using("`survey'/h`smallyear'da/H`smallyear'P_R.da")
merge 1:1 HHID PN using "$CleanData/HRSPreLoad`year'.dta", assert(3)
tab _merge /* Should be all matched */
drop _merge
save "$CleanData/HRS_RAWwithPreLoad`year'.dta", replace

/* Need age data later, which comes from the Cross-Wave Tracker File, so will load
   that now, keep relevant variables and save, so can be easily merged later. */
use "$Tracker16/HRS_Tracker16.dta"
keep HHID PN N*
save "$CleanData/HRSTrackerSmall`year'.dta", replace

/* Now reload expectations data */
clear
use "$CleanData/HRS_RAWwithPreLoad`year'.dta"

/* Number of 0-100 questions asked */
gen NumQs_`year'                   =NP155
 
/* Number of questions answered Dk or Rf */
gen NumDkRf_`year'                 =NP156

/* ProbHomeValChange gives percentage probability that home value changes one year from now.
   HomeValFlag records whether "home value change" was up (home value increases), or down
   (home value decreases). Respondents were randomly assigned the up or down change. */
gen ProbHomeValChange_`year'       =NP166
gen ProbHomeValChange_Dk_`year'    =0
replace ProbHomeValChange_Dk_`year'=1 if NP166==998
gen HomeValFlag_`year'             =0
replace HomeValFlag_`year'         =1 if NP170==2

/*  Now ask what probability is home value increases/decreases by certain amount, specifically
    10%, 20%, 30%, or 40%, and could be up or down. So one of eight possibilities, and each
	household assigned only one. Thus, I create dummies for each of the eight possible questions. */
gen ProbHomeValChangeByPerc_`year'       =NP168
gen ProbHomeValChangeByPerc_Dk_`year'    =0
replace ProbHomeValChangeByPerc_Dk_`year'=1 if NP168==998
gen HomeChangeUp40_`year'         =0
replace HomeChangeUp40_`year'     =1 if NP170==2 & (NX523==8 | NX523==1)
gen HomeChangeUp30_`year'         =0
replace HomeChangeUp30_`year'     =1 if NP170==2 & (NX523==7 | NX523==2)
gen HomeChangeUp20_`year'         =0
replace HomeChangeUp20_`year'     =1 if NP170==2 & (NX523==6 | NX523==3)
gen HomeChangeUp10_`year'         =0
replace HomeChangeUp10_`year'     =1 if NP170==2 & (NX523==5 | NX523==4)
gen HomeChangeDown40_`year'       =0
replace HomeChangeDown40_`year'   =1 if NP170==1 & (NX523==1 | NX523==8)
gen HomeChangeDown30_`year'       =0
replace HomeChangeDown30_`year'   =1 if NP170==1 & (NX523==2 | NX523==7)
gen HomeChangeDown20_`year'       =0
replace HomeChangeDown20_`year'   =1 if NP170==1 & (NX523==3 | NX523==6)
gen HomeChangeDown10_`year'       =0
replace HomeChangeDown10_`year'   =1 if NP170==1 & (NX523==4 | NX523==5)


/* 	Now ask about bequests (including property and valuables) */
gen ProbBeqMoreThan10k_`year'       =NP005
gen ProbBeqMoreThan10k_Dk_`year'    =0
replace ProbBeqMoreThan10k_Dk_`year'=1 if NP005==998

gen ProbBeqMoreThan100k_`year'       =NP006
gen ProbBeqMoreThan100k_Dk_`year'    =0
replace ProbBeqMoreThan100k_Dk_`year'=1 if NP006==998

gen ProbBeqMoreThan500k_`year'       =NP059
gen ProbBeqMoreThan500k_Dk_`year'    =0
replace ProbBeqMoreThan500k_Dk_`year'=1 if NP059==998

gen ProbBeqAny_`year'                =NP007
gen ProbBeqAny_Dk_`year'             =0
replace ProbBeqAny_Dk_`year'         =1 if NP007==998
/* 	User Note: Any R who refuses or does not know how to answer the first three
    0-100 questions of section P, will not be asked any further questions in this
    section. The actual sequence of questions varies and depends on specific skips. */
gen CantDoProbs_`year'               =NP009

/*  Probability you lose job you want to keep. Only applies to households still working
    and not self-employed: J020=1 and J021~=2 */
gen ProbLoseJob_`year'               =NP014
gen ProbLoseJob_Dk_`year'            =0
replace ProbLoseJob_Dk_`year'        =1 if NP014==998

/*  Probability you find "equally good job (as the one you had) in same line of work?
    Again, only for employed, those answering MP014. */
gen ProbFindJob_`year'               =NP015
gen ProbFindJob_Dk_`year'            =0
replace ProbFindJob_Dk_`year'        =1 if NP015==998

/*  What is chance work for pay in the future? Only applies if not working (J020~=1)  */
gen ProbWorkforPay_`year'            =NP016
gen ProbWorkforPay_Dk_`year'         =0
replace ProbWorkforPay_Dk_`year'     =1 if NP016==998

/*  What is probability R will be working at 62? Only applies if less than 62 and MP016~=0 */
gen ProbWorkPost62_`year'            =NP017
gen ProbWorkPost62_Dk_`year'         =0
replace ProbWorkPost62_Dk_`year'     =1 if NP017==998
/*  If ProbWorkPost62_`year'=50%, then ask whether is really 50% or is unsure. 1=equally likely,
    2=unsure. */
gen ProbWorkPost62_5050_`year'       =NP123

/*  What is probability R will be working at 65? Only applies if older than 62 and less than 65 and J021==1 */
gen ProbWorkPost65_`year'            =NP018
gen ProbWorkPost65_Dk_`year'         =0
replace ProbWorkPost65_Dk_`year'     =1 if NP018==998

/*  What is probability R will be working at 70? Only applies if less than 70 */
gen ProbWorkPost70_`year'            =NP181
gen ProbWorkPost70_Dk_`year'         =0
replace ProbWorkPost70_Dk_`year'     =1 if NP181==998

gen ProbWorkFTPost70_`year'          =NP182
gen ProbWorkFTPost70_Dk_`year'       =0
replace ProbWorkFTPost70_Dk_`year'   =1 if NP182==998

/* Only applies if J505 or J517 is equal to one (is looking for a job) */
gen ProbFindJobFewMonths_`year'      =NP020
gen ProbFindJobFewMonth_Dk_`year'    =0
replace ProbFindJobFewMonth_Dk_`year'=1 if NP020==998

/* Percent chance live to be 75 or more */
gen ProbLive75More_`year'            =NP028
gen ProbLive75More_Dk_`year'         =0
replace ProbLive75More_Dk_`year'     =1 if NP028==998
/*  If ProbLive75More_`year'=50%, then ask whether is really 50% or is unsure. 1=equally likely,
    2=unsure. */
gen ProbLive75More_5050_`year'    =NP102

/* Now going to merge with TrackerSmall, created at top, to get age. Age is needed to calculate
   ProbLiveToVarious age values below. To do this, I create HHIDnum just to count number of
   observations, to make sure all observations are matched. */
destring HHID, generate(HHIDnum)
sum HHIDnum
local numobs = `r(N)'
drop HHIDnum

/* Merge to get age */
merge 1:1 HHID PN using "$CleanData/HRSTrackerSmall`year'.dta", assert(2 3)
assert _m ~= 1
count if _m == 3
assert `r(N)' == `numobs'
tab _merge /* Merge 3 should be equal to number of HHIDnum observations above*/
		
/* What is the percent chance that you will live to be [85/80/90/95/100] or more?
         80 (IF AGE IS 65-69)
         85 (IF AGE IS 70-74)
         90 (IF AGE IS 75-79)
         95 (IF AGE IS 80-84)
         100 (IF AGE IS 85-89) */		 
gen ProbLiveToVarious_`year'         =NP029
gen ProbLiveToVarious_Dk_`year'      =0
replace ProbLiveToVarious_Dk_`year'  =1 if NP029==998
/* If ProbLiveToVarious_`year'=50%, then ask whether is really 50% or is unsure. 1=equally likely,
    2=unsure. */
gen ProbLiveToVarious_5050_`year'=NP157
/* Now create dummies for which age category you are asked about; note age=999 folks excluded (3 of them) */
gen ProbLiveTo80_`year'=0
replace ProbLiveTo80_`year' =1 if NAGE>=65 & NAGE<=69 & ProbLiveToVarious_`year'~=.
gen ProbLiveTo85_`year'=0
replace ProbLiveTo85_`year' =1 if (NAGE>=70 & NAGE<=74 & ProbLiveToVarious_`year'~=.) | (NAGE<65  & ProbLiveToVarious_`year'~=.)
gen ProbLiveTo90_`year'=0
replace ProbLiveTo90_`year' =1 if NAGE>=75 & NAGE<=79 & ProbLiveToVarious_`year'~=.
gen ProbLiveTo95_`year'=0
replace ProbLiveTo95_`year' =1 if NAGE>=80 & NAGE<=84 & ProbLiveToVarious_`year'~=.
gen ProbLiveTo100_`year'=0
replace ProbLiveTo100_`year'=1 if NAGE>=85 & NAGE<=89 & ProbLiveToVarious_`year'~=.

/* Assuming that you are still living at [80/85/90/95/100] what are the chances, that you will be
   free of serious problems in thinking, reasoning or remembering things that would interfere with
   your ability to manage your own affairs? */
gen ProbMentalOkAtAge_`year'         =NP107
gen ProbMentalOkAtAge_Dk_`year'      =0
replace ProbMentalOkAtAge_Dk_`year'  =1 if NP107==998

/* Now create dummies for which age category you are asked about; note age=999 folks excluded (1 of them).
   Note: any age < 65 does not answer, except for HHID-PN: 500726-011, which I think is a data error
   (should not have been asked) and is therefore excluded. */
gen ProbMentalOkAt80_`year'=0
replace ProbMentalOkAt80_`year'=1  if NAGE>=65 & NAGE<=69 & ProbMentalOkAtAge_`year'~=.
gen ProbMentalOkAt85_`year'=0
replace ProbMentalOkAt85_`year'=1  if (NAGE>=70 & NAGE<=74 & ProbMentalOkAtAge_`year'~=.)
gen ProbMentalOkAt90_`year'=0
replace ProbMentalOkAt90_`year'=1  if NAGE>=75 & NAGE<=79 & ProbMentalOkAtAge_`year'~=.
gen ProbMentalOkAt95_`year'=0
replace ProbMentalOkAt95_`year'=1  if NAGE>=80 & NAGE<=84 & ProbMentalOkAtAge_`year'~=.
gen ProbMentalOkAt100_`year'=0 
replace ProbMentalOkAt100_`year'=1 if NAGE>=85 & NAGE<=89 & ProbMentalOkAtAge_`year'~=.

/* What are the chances you spend more than x on health expenditures */
gen HealthSpendMoreThan1500_`year'       =NP175
gen HealthSpendMoreThan1500_Dk_`year'    =0
replace HealthSpendMoreThan1500_Dk_`year'=1 if NP175==998

gen HealthSpendMoreThan500_`year'        =NP176
gen HealthSpendMoreThan500_Dk_`year'     =0
replace HealthSpendMoreThan500_Dk_`year' =1 if NP176==998
				
gen HealthSpendMoreThan3000_`year'       =NP177
gen HealthSpendMoreThan3000_Dk_`year'    =0
replace HealthSpendMoreThan3000_Dk_`year'=1 if NP177==998

gen HealthSpendMoreThan8000_`year'       =NP178
gen HealthSpendMoreThan8000_Dk_`year'    =0
replace HealthSpendMoreThan8000_Dk_`year'=1 if NP178==998

/* What is chance will have to move to a nursuing home ever (in next 5 years)?
   If age<65, question is ever. If age>=65, question is in next 5 years. */
gen ProbMoveToNH_`year'                  =NP032
gen ProbMoveToNH_Dk_`year'               =0
replace ProbMoveToNH_Dk_`year'           =1 if NP032==998
gen NH5years_`year'                      =0
replace NH5years_`year'                  =1 if NAGE>=65
gen NHEver_`year'                        =0
replace NHEver_`year'                    =1 if NAGE<65

/* Probability congress changes social security to be less generous in next
   10 years. */
gen SSChangeLessGenerous_`year'          =NP110
gen SSChangeLessGenerous_Dk_`year'       =0
replace SSChangeLessGenerous_Dk_`year'   =1 if NP110==998
/* If SSChangeLessGenerous_`year'=50%, then ask whether is really 50% or is unsure. 1=equally likely,
   2=unsure. */
gen SSChangeLessGenerous_5050_`year'     =NP179

/* Probability your personal SS benefits will get cut in next 10 years. Only for those currently
   receiving SS. */
gen SSRecPersLessGenerous_`year'         =NP111
gen SSRecPersLessGenerous_Dk_`year'      =0
replace SSRecPersLessGenerous_Dk_`year'  =1 if NP111==998	
/* Probability your personal SS benefits will get cut in next 10 years. Only for those who expect
   to receive SS in the futre. */
gen SSFutPersLessGenerous_`year'         =NP112
gen SSFutPersLessGenerous_Dk_`year'      =0
replace SSFutPersLessGenerous_Dk_`year'  =1 if NP112==998

/* Probability your personal Medicare benefits will get cut in next 10 years. */
gen MedRecPersLessGenerous_`year'        =NP183
gen MedRecPersLessGenerous_Dk_`year'     =0
replace MedRecPersLessGenerous_Dk_`year' =1 if NP183==998
				
/* Chance that mutual fund shares invested in blue chip stocks worth more next year */
gen ProbMarketUp_`year'                  =NP047
gen ProbMarketUp_Dk_`year'               =0
replace ProbMarketUp_Dk_`year'           =1 if NP047==998

/* If ProbMarketUp_`year'=50%, then ask whether is really 50% or is unsure. 1=equally likely,
   2=unsure. */
gen MarketUp_5050_`year'                 =NP113

/* Percent market goes up by more than 20%? */
gen ProbMarketUp20perc_`year'            =NP150
gen ProbMarketUp20perc_Dk_`year'         =0
replace ProbMarketUp20perc_Dk_`year'     =1 if NP150==998

/* Percent market goes down by more than 20%? */
gen ProbMarketDown20perc_`year'          =NP180
gen ProbMarketDown20perc_Dk_`year'       =0
replace ProbMarketDown20perc_Dk_`year'   =1 if NP180==998

/* How closely do you follow the stock market: very closely, somewhat, or not at all?
          1648           1.  VERY CLOSELY
          8541           2.  SOME WHAT CLOSELY
          9947           3.  NOT AT ALL */
gen FollowMarket_`year'                  =NP097
gen FollowMarket_Dk_`year'               =0
replace FollowMarket_Dk_`year'           =1 if NP097==8

gen     FinPlanPerFewMonths_`year'    =0
gen     FinPlanPerOneYr_`year'        =0
gen     FinPlanPerFewYrs_`year'       =0
gen     FinPlanPerFiveTenYrs_`year'   =0
gen     FinPlanPerMoreTenYrs_`year'   =0
replace FinPlanPerFewMonths_`year'    =1 if NP041==1
replace FinPlanPerOneYr_`year'        =1 if NP041==2
replace FinPlanPerFewYrs_`year'       =1 if NP041==3
replace FinPlanPerFiveTenYrs_`year'   =1 if NP041==4
replace FinPlanPerMoreTenYrs_`year'   =1 if NP041==5
gen     FinPlan_Dk_`year'             =0
replace FinPlan_Dk_`year'             =1 if NP041==8

gen FinPlanCat_`year'=NP041

/* Will children have higher, lower, same standard of living at your age? */
gen     ChildBetterOff_`year'         =0
gen     ChildWorseOff_`year'          =0
gen     ChildSameOff_`year'           =0
replace ChildBetterOff_`year'         =1 if NP042==1
replace ChildWorseOff_`year'          =1 if NP042==2
replace ChildSameOff_`year'           =1 if NP042==3
gen     ChildBetterOff_Dk_`year'      =0
replace ChildBetterOff_Dk_`year'      =1 if NP042==8

/* Follow up about "much" better or worse off. 1=yes, 0=no. */
gen     ChildMuchBetter_`year'        =0
replace ChildMuchBetter_`year'        =1 if NP043==1
gen     ChildMuchBetter_Dk_`year'     =0
replace ChildMuchBetter_Dk_`year'     =1 if NP043==8

gen     ChildMuchWorse_`year'         =0
replace ChildMuchWorse_`year'         =1 if NP044==1
gen     ChildMuchWorse_Dk_`year'      =0
replace ChildMuchWorse_Dk_`year'      =1 if NP044==8

/* Will own standard of living be higher, lower, same in 10 years? */
gen     SelfBetterOff_`year'          =0
gen     SelfWorseOff_`year'           =0
gen     SelfSameOff_`year'            =0
replace SelfBetterOff_`year'          =1 if NP185==1
replace SelfWorseOff_`year'           =1 if NP185==2
replace SelfSameOff_`year'            =1 if NP185==3
gen     SelfBetterOff_Dk_`year'       =0
replace SelfBetterOff_Dk_`year'       =1 if NP185==8

/* Did you get help filling out this section */
gen     NoExpHelp_`year'              =0
gen     SomeExpHelp_`year'            =0
gen     LotExpHelp_`year'             =0
gen     ProxyExpHelp_`year'           =0
replace NoExpHelp_`year'              =1 if NP056==1
replace SomeExpHelp_`year'            =1 if NP056==2
replace LotExpHelp_`year'             =1 if NP056==3
replace ProxyExpHelp_`year'           =1 if NP056==4
gen     ExpHelp_Dk_`year'             =0
replace ExpHelp_Dk_`year'             =1 if NP056==8

gen ProbDoubleDigitInf_`year'=.
gen ProbUSEconDep_`year'=.
gen IncRAbin_`year'=.
gen InherRAbin_`year'=.
gen BusRAbin_`year'=.

keep HHID PN ProbMarketUp_`year' ProbUSEconDep_`year' ProbDoubleDigitInf_`year' FollowMarket_`year' FinPlanCat_`year' IncRAbin_`year' InherRAbin_`year' BusRAbin_`year'
 

save "$CleanData/HRSExp`year'.dta", replace
