
/* NOTE: THERE CAN BE MORE THAN ONE RESPONDENT WITHIN AN HHID-SUBHH HOUSEHOLD */

/* Setting up. Merge with the Pre Load values to know which random assignments households get */
clear all
local year "2010"
local smallyear="10"
local survey="$HRSSurveys10"

infile using "`survey'/h`smallyear'sta/H`smallyear'P_R.dct" , using("`survey'/h`smallyear'da/H`smallyear'P_R.da")
merge 1:1 HHID PN using "$CleanData/HRSPreLoad`year'.dta", assert(3)
tab _merge /* Should be all matched */
drop _merge
save "$CleanData/HRS_RAWwithPreLoad`year'.dta", replace

/* Need age data later, which comes from the Cross-Wave Tracker File, so will load
   that now, keep relevant variables and save, so can be easily merged later. */
use "$Tracker16/HRS_Tracker16.dta"
keep HHID PN M*
save "$CleanData/HRSTrackerSmall`year'.dta", replace

/* Now reload expectations data */
clear
use "$CleanData/HRS_RAWwithPreLoad`year'.dta"

/* Number of 0-100 questions asked */
gen NumQs_`year'                   =MP155

/* Number of questions answered Dk or Rf */
gen NumDkRf_`year'                 =MP156

/* ProbHomeValChange gives percentage probability that home value is worth MORE one year from today */
gen ProbHomeValChange_`year'       =MP166
gen ProbHomeValChange_Dk_`year'    =0
replace ProbHomeValChange_Dk_`year'=1 if MP166==998

/*  If ProbHomeValChange_`year'=50%, then ask whether is really 50% or is unsure. 1=equally likely,
    2=unsure. */
gen ProbHomeValChange_5050_`year' =MP167


/*  Now ask what probability is home value increases/decreases by certain amount, specifically
    10%, 20%, 30%, or 40%, and could be up or down. So one of eight possibilities, and each
	household assigned only one. Thus, I create dummies for each of the eight possible questions. */
gen ProbHomeValChangeByPerc_`year'=MP168 /* Is missing for 48 obs., so distorts # obs. in MX523 and MP170 comparisons */
gen ProbHomeValChangeByPerc_Dk_`year'=0
replace ProbHomeValChangeByPerc_Dk_`year'=1 if MP168==998
gen HomeChangeUp40_`year'         =0
replace HomeChangeUp40_`year'     =1 if MP170==2 & (MX523==8 | MX523==1)
gen HomeChangeUp30_`year'         =0
replace HomeChangeUp30_`year'     =1 if MP170==2 & (MX523==7 | MX523==2)
gen HomeChangeUp20_`year'         =0
replace HomeChangeUp20_`year'     =1 if MP170==2 & (MX523==6 | MX523==3)
gen HomeChangeUp10_`year'         =0
replace HomeChangeUp10_`year'     =1 if MP170==2 & (MX523==5 | MX523==4)
gen HomeChangeDown40_`year'       =0
replace HomeChangeDown40_`year'   =1 if MP170==1 & (MX523==1 | MX523==8)
gen HomeChangeDown30_`year'       =0
replace HomeChangeDown30_`year'   =1 if MP170==1 & (MX523==2 | MX523==7)
gen HomeChangeDown20_`year'       =0
replace HomeChangeDown20_`year'   =1 if MP170==1 & (MX523==3 | MX523==6)
gen HomeChangeDown10_`year'       =0
replace HomeChangeDown10_`year'   =1 if MP170==1 & (MX523==4 | MX523==5)

/* 	Now ask about bequests (including property and valuables) */
gen ProbBeqMoreThan10k_`year'       =MP005
gen ProbBeqMoreThan10k_Dk_`year'    =0
replace ProbBeqMoreThan10k_Dk_`year'=1 if MP005==998

gen ProbBeqMoreThan100k_`year'       =MP006
gen ProbBeqMoreThan100k_Dk_`year'    =0
replace ProbBeqMoreThan100k_Dk_`year'=1 if MP006==998

gen ProbBeqMoreThan500k_`year'       =MP059
gen ProbBeqMoreThan500k_Dk_`year'    =0
replace ProbBeqMoreThan500k_Dk_`year'=1 if MP059==998

gen ProbBeqAny_`year'                =MP007
gen ProbBeqAny_Dk_`year'             =0
replace ProbBeqAny_Dk_`year'         =1 if MP007==998

/* 	User Note: Any R who refuses or does not know how to answer the first three
    0-100 questions of section P, will not be asked any further questions in this
    section. The actual sequence of questions varies and depends on specific skips. */
gen CantDoProbs_`year'               =MP164

/*  Probability you lose job you want to keep. Only applies to households still working
    and not self-employed: J020=1 and J021~=2 */
gen ProbLoseJob_`year'               =MP014
gen ProbLoseJob_Dk_`year'            =0
replace ProbLoseJob_Dk_`year'        =1 if MP014==998

/*  Probability you find "equally good job (as the one you had) in same line of work?
    Again, only for employed, those answering MP014. */
gen ProbFindJob_`year'               =MP015
gen ProbFindJob_Dk_`year'            =0
replace ProbFindJob_Dk_`year'        =1 if MP015==998

/*  What is chance work for pay in the future? Only applies if not working (J020~=1)  */
gen ProbWorkforPay_`year'            =MP016
gen ProbWorkforPay_Dk_`year'         =0
replace ProbWorkforPay_Dk_`year'     =1 if MP016==998

/*  What is probability R will be working at 62? Only applies if less than 62 and MP016~=0 */
gen ProbWorkPost62_`year'            =MP017
gen ProbWorkPost62_Dk_`year'         =0
replace ProbWorkPost62_Dk_`year'     =1 if MP017==998
/*  If ProbWorkPost62_`year'=50%, then ask whether is really 50% or is unsure. 1=equally likely,
    2=unsure. */
gen ProbWorkPost62_5050_`year'       =MP123
/* If gave exact answer, asks whether this is exact or rounded. Exact=1, Approximation=3. */
gen ProbWorkPost62_RndExact_`year'   =MP172
/* If gave approximate response to MP172, then asks for range. R gives min and max of range. */
gen ProbWorkPost62_Min_`year'        =MP173
gen ProbWorkPost62_Max_`year'        =MP174

/*  What is probability R will be working at 65? Only applies if older than 62 and less than 65 and J021==1 */
gen ProbWorkPost65_`year'            =MP018
gen ProbWorkPost65_Dk_`year'         =0
replace ProbWorkPost65_Dk_`year'     =1 if MP018==998

/* Only applies if J505 or J517 is equal to one (is looking for a job) */
gen ProbFindJobFewMonths_`year'      =MP020
gen ProbFindJobFewMonths_Dk_`year'   =0
replace ProbFindJobFewMonths_Dk_`year'=1 if MP020==998

/* Percent chance live to be 75 or more */
gen ProbLive75More_`year'            =MP028
gen ProbLive75More_Dk_`year'         =0
replace ProbLive75More_Dk_`year'     =1 if MP028==998
/*  If ProbLive75More_`year'=50%, then ask whether is really 50% or is unsure. 1=equally likely,
    2=unsure. */
gen ProbLive75More_5050_`year'       =MP102

/* Now going to merge with TrackerSmall, created at top, to get age. Age is needed to calculate
   ProbLiveToVarious age values below. To do this, I create HHIDnum just to count number of
   observations, to make sure all observations are matched. */
destring HHID, generate(HHIDnum)
sum HHIDnum
local numobs = `r(N)'
drop HHIDnum

/* Merge to get age */
merge 1:1 HHID PN using "$CleanData/HRSTrackerSmall`year'.dta"
count if _m == 1
assert `r(N)' == 5
count if _m == 3
assert `r(N)' == `numobs' - 5
tab _merge /* Merge 3 should be equal to number of HHIDnum observations above
        MZ note - this is not true for this file.*/
		
/* What is the percent chance that you will live to be [85/80/90/95/100] or more?
         80 (IF AGE IS 65-69)
         85 (IF AGE IS 70-74)
         90 (IF AGE IS 75-79)
         95 (IF AGE IS 80-84)
         100 (IF AGE IS 85-89) */		 
gen ProbLiveToVarious_`year'         =MP029
gen ProbLiveToVarious_Dk_`year'      =0
replace ProbLiveToVarious_Dk_`year'  =1 if MP029==998
/* If ProbLiveToVarious_`year'=50%, then ask whether is really 50% or is unsure. 1=equally likely,
    2=unsure. */
gen ProbLiveToVarious_5050_`year'=MP157
/* Now create dummies for which age category you are asked about; note age=999 folks excluded (3 of them) */
gen ProbLiveTo80_`year'=0
replace ProbLiveTo80_`year'=1 if MAGE>=65 & MAGE<=69 & ProbLiveToVarious_`year'~=.
gen ProbLiveTo85_`year'=0
replace ProbLiveTo85_`year'=1 if (MAGE>=70 & MAGE<=74 & ProbLiveToVarious_`year'~=.) | (MAGE<65  & ProbLiveToVarious_`year'~=.)
gen ProbLiveTo90_`year'=0
replace ProbLiveTo90_`year'=1 if MAGE>=75 & MAGE<=79 & ProbLiveToVarious_`year'~=.
gen ProbLiveTo95_`year'=0
replace ProbLiveTo95_`year'=1 if MAGE>=80 & MAGE<=84 & ProbLiveToVarious_`year'~=.
gen ProbLiveTo100_`year'=0
replace ProbLiveTo100_`year'=1 if MAGE>=85 & MAGE<=89 & ProbLiveToVarious_`year'~=.

/* What are the chances you spend more than x on health expenditures */
gen HealthSpendMoreThan1500_`year'       =MP175
gen HealthSpendMoreThan1500_Dk_`year'    =0
replace HealthSpendMoreThan1500_Dk_`year'=1 if MP175==998

gen HealthSpendMoreThan500_`year'        =MP176
gen HealthSpendMoreThan500_Dk_`year'     =0
replace HealthSpendMoreThan500_Dk_`year' =1 if MP176==998
				
gen HealthSpendMoreThan3000_`year'       =MP177
gen HealthSpendMoreThan3000_Dk_`year'    =0
replace HealthSpendMoreThan3000_Dk_`year'=1 if MP177==998

gen HealthSpendMoreThan8000_`year'       =MP178
gen HealthSpendMoreThan8000_Dk_`year'    =0
replace HealthSpendMoreThan8000_Dk_`year'=1 if MP178==998

/* What is chance will have to move to a nursuing home ever (in next 5 years)?
   If age<65, question is ever. If age>=65, question is in next 5 years. */
gen ProbMoveToNH_`year'                  =MP032
gen ProbMoveToNH_Dk_`year'               =0
replace ProbMoveToNH_Dk_`year'           =1 if MP032==998
gen NH5years_`year'                      =0
replace NH5years_`year'                  =1 if MAGE>=65
gen NHEver_`year'                        =0
replace NHEver_`year'                    =1 if MAGE<65

/* Probability congress changes social security to be less generous in next
   10 years. */
gen SSChangeLessGenerous_`year'          =MP110
gen SSChangeLessGenerous_Dk_`year'       =0
replace SSChangeLessGenerous_Dk_`year'   =1 if MP110==998
/* If SSChangeLessGenerous_`year'=50%, then ask whether is really 50% or is unsure. 1=equally likely,
   2=unsure. */
gen SSChangeLessGenerous_5050_`year'     =MP179

/* Probability your personal SS benefits will get cut in next 10 years. Only for those currently
   receiving SS. */
gen SSRecPersLessGenerous_`year'         =MP111
gen SSRecPersLessGenerous_Dk_`year'      =0
replace SSRecPersLessGenerous_Dk_`year'  =1 if MP111==998	
/* Probability your personal SS benefits will get cut in next 10 years. Only for those who expect
   to receive SS in the futre. */
gen SSFutPersLessGenerous_`year'         =MP112
gen SSFutPersLessGenerous_Dk_`year'      =0
replace SSFutPersLessGenerous_Dk_`year'  =1 if MP112==998			
				
/* Chance that mutual fund shares invested in blue chip stocks worth more next year */
gen ProbMarketUp_`year'                  =MP047
gen ProbMarketUp_Dk_`year'               =0
replace ProbMarketUp_Dk_`year'           =1 if MP047==998

/* If ProbMarketUp_`year'=50%, then ask whether is really 50% or is unsure. 1=equally likely,
   2=unsure. */
gen MarketUp_5050_`year'                 =MP113

/* Percent market goes up by more than 20%? */
gen ProbMarketUp20perc_`year'            =MP150
gen ProbMarketUp20perc_Dk_`year'         =0
replace ProbMarketUp20perc_Dk_`year'     =1 if MP150==998

/* Percent market goes down by more than 20%? */
gen ProbMarketDown20perc_`year'          =MP180
gen ProbMarketDown20perc_Dk_`year'       =0
replace ProbMarketDown20perc_Dk_`year'   =1 if MP180==998

/* How closely do you follow the stock market? 
          1452           1.  VERY CLOSELY
          7953           2.  SOMEWHAT CLOSELY
          9597           3.  NOT AT ALL */
gen FollowMarket_`year'                  =MP097
gen FollowMarket_Dk_`year'               =0
replace FollowMarket_Dk_`year'           =1 if MP097==8

/* Did you get help filling out this section */
gen     NoExpHelp_`year'              =0
gen     SomeExpHelp_`year'            =0
gen     LotExpHelp_`year'             =0
gen     ProxyExpHelp_`year'           =0
replace NoExpHelp_`year'              =1 if MP056==1
replace SomeExpHelp_`year'            =1 if MP056==2
replace LotExpHelp_`year'             =1 if MP056==3
replace ProxyExpHelp_`year'           =1 if MP056==4
gen     ExpHelp_Dk_`year'             =0
replace ExpHelp_Dk_`year'             =1 if MP056==8

gen FinPlanCat_`year'=. 
gen ProbDoubleDigitInf_`year'=.
gen ProbUSEconDep_`year'=.
gen IncRAbin_`year'=.
gen InherRAbin_`year'=.
gen BusRAbin_`year'=.

keep HHID PN ProbMarketUp_`year' ProbUSEconDep_`year' ProbDoubleDigitInf_`year' FollowMarket_`year' FinPlanCat_`year' IncRAbin_`year' InherRAbin_`year' BusRAbin_`year'

save "$CleanData/HRSExp`year'.dta", replace
