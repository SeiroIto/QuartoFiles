
/* NOTE: THERE CAN BE MORE THAN ONE RESPONDENT WITHIN AN HHID-SUBHH HOUSEHOLD */

/* Setting up. Merge with the Pre Load values to know which random assignments households get */
clear all
local year "2006"
local smallyear="06"
local survey="$HRSSurveys06"
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
keep HHID PN K*
save "$CleanData/HRSTrackerSmall`year'.dta", replace

/* Now reload expectations data */
clear
use "$CleanData/HRS_RAWwithPreLoad`year'.dta"

/* What do you think are the chances that your income will keep up with the cost of
         living for the next five years? */
gen ProbRealIncUp_`year'              =KP004
gen ProbRealIncUp_Dk_`year'           =0
replace ProbRealIncUp_Dk_`year'       =1 if KP004==998		 
 
/* 	Now ask about bequests (including property and valuables) */
gen ProbBeqMoreThan10k_`year'         =KP005
gen ProbBeqMoreThan10k_Dk_`year'      =0
replace ProbBeqMoreThan10k_Dk_`year'=1 if KP005==998

gen ProbBeqMoreThan100k_`year'        =KP006
gen ProbBeqMoreThan100k_Dk_`year'     =0
replace ProbBeqMoreThan100k_Dk_`year' =1 if KP006==998

gen ProbBeqMoreThan500k_`year'        =KP059
gen ProbBeqMoreThan500k_Dk_`year'     =0
replace ProbBeqMoreThan500k_Dk_`year' =1 if KP059==998

gen ProbBeqAny_`year'                 =KP007
gen ProbBeqAny_Dk_`year'              =0
replace ProbBeqAny_Dk_`year'          =1 if KP007==998

/* What are the chances that you  [or your]   [you/husband/wife/partner]  will receive
   an inheritance during the next 10 years? */
gen ProbRecInher_`year'               =KP008
gen ProbRecInher_Dk_`year'            =0
replace ProbRecInher_Dk_`year'        =1 if KP008==998

/* How large do you expect the inheritence to be? */
gen SizeInher_`year'                  =KP010
gen SizeInher_Dk_`year'               =0
replace SizeInher_Dk_`year'           =1 if KP013==98
gen SizeInherPointEst_`year'          =0
replace SizeInherPointEst_`year'      =1 if KP010<99999998
gen double SizeInher_minval           =KP011
gen double SizeInher_maxval           =KP012

local SizeInher_Binmin0   0
local SizeInher_Binmin1   10001
local SizeInher_Binmin2   50001
local SizeInher_Binmin3   250001
local SizeInher_Binmin4   1000001
local SizeInher_Binmax0   9999
local SizeInher_Binmax1   49999
local SizeInher_Binmax2   249999
local SizeInher_Binmax3   999999
local SizeInher_Binmax4   99999996
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
gen CantDoProbs_`year'                =KP009

/*  Probability you lose job you want to keep. Only applies to households still working
    and not self-employed: J020=1 and J021~=2 */
gen ProbLoseJob_`year'                =KP014

/*  Probability you find "equally good job (as the one you had) in same line of work?
    Again, only for employed, those answering MP014. */
gen ProbFindJob_`year'                =KP015

/*  What is chance work for pay in the future? Only applies if not working (J020~=1)  */
gen ProbWorkforPay_`year'             =KP016
gen ProbWorkforPay_Dk_`year'          =0
replace ProbWorkforPay_Dk_`year'      =1 if KP016==998

/*  What is probability R will be working at 62? Only applies if less than 62 and KP016~=0 */
gen ProbWorkPost62_`year'             =KP017
gen ProbWorkPost62_Dk_`year'          =0
/*  Captures Dk to main question, then to the 0% and 100% follow up questions */
replace ProbWorkPost62_Dk_`year'      =1 if KP017==998

/*  What is probability R will be working at 65? Only applies if older than 62 and less than 65 and J021==1 */
gen ProbWorkPost65_`year'             =KP018
gen ProbWorkPost65_Dk_`year'          =0
replace ProbWorkPost65_Dk_`year'      =1 if KP018==998

/* Only applies if J505 or J517 is equal to one (is looking for a job) */
gen ProbFindJobFewMonths_`year'       =KP020
gen ProbFindJobFewMonths_Dk_`year'    =0
replace ProbFindJobFewMonths_Dk_`year'=1 if KP020==998

/* Percent chance live to be 75 or more */
gen ProbLive75More_`year'             =KP028
gen ProbLive75More_Dk_`year'          =0
replace ProbLive75More_Dk_`year'      =1 if KP028==998
/*  Do you think that it is about equally likely that you will die before 75 as it is that you will
    live to 75 or beyond, or are you just unsure about the chances [, or do you think no one can know these things]?
	       217           1.  EQUALLY LIKELY
           279           2.  UNSURE
           177           3.  CAN'T KNOW*/
gen ProbLive75More_5050_`year'        =KP102
			
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

/* If live to 75, chance that health will allow to live independently; 
Primarily asked for age<65. */
gen ProbLivIndat75_`year'            =KP103
gen ProbLivIndat75_Dk_`year'         =0
replace ProbLivIndat75_Dk_`year'     =1 if KP103==998

/* Assuming that you are still living at 75, what are the chances that you will be free of serious problems
   in thinking, reasoning or remembering things that would interfere with your ability to manage your own affairs? */
gen ProbManAffairsat75_`year'        =KP104
gen ProbManAffairsat75_Dk_`year'     =0
replace ProbManAffairsat75_Dk_`year' =1 if KP104==998

/* What is the percent chance that you will live to be [85/80/90/95/100] or more?
         80 (IF AGE IS 65-69)
         85 (IF AGE IS 70-74)
         90 (IF AGE IS 75-79)
         95 (IF AGE IS 80-84)
         100 (IF AGE IS 85-89) */		 
gen ProbLiveToVarious_`year'          =KP029
gen ProbLiveToVarious_Dk_`year'       =0
replace ProbLiveToVarious_Dk_`year'   =1 if KP029==998
/*  Do you think that it is about equally likely that you will die before [85/90/95/100] as it is that you will live to
[85/90/95/100] or beyond or are you just unsure about the chances [, or do you think no one can know these things]?
           268           1.  EQUALLY LIKELY
           389           2.  UNSURE
           276           3.  CAN'T KNOW*/
gen ProbLiveToVarious_5050_`year'     =KP105

gen ProbLiveTo80_`year'=0
replace ProbLiveTo80_`year'=1 if KAGE>=65 & KAGE<=69 & ProbLiveToVarious_`year'~=.
gen ProbLiveTo85_`year'=0
replace ProbLiveTo85_`year'=1 if (KAGE>=70 & KAGE<=74 & ProbLiveToVarious_`year'~=.) | (KAGE<65  & ProbLiveToVarious_`year'~=.)
gen ProbLiveTo90_`year'=0
replace ProbLiveTo90_`year'=1 if KAGE>=75 & KAGE<=79 & ProbLiveToVarious_`year'~=.
gen ProbLiveTo95_`year'=0
replace ProbLiveTo95_`year'=1 if KAGE>=80 & KAGE<=84 & ProbLiveToVarious_`year'~=.
gen ProbLiveTo100_`year'=0
replace ProbLiveTo100_`year'=1 if KAGE>=85 & KAGE<=89 & ProbLiveToVarious_`year'~=.



/* Probability that health will be good enough to live independently at various ages*/
gen ProbLiveIndVarious_`year'        =KP106
gen ProbLiveIndVarious_Dk_`year'     =0
replace ProbLiveIndVarious_Dk_`year' =1 if KP106==998
/* Dummies for appropriate age values for question KP106. */
gen ProbLiveInd80_`year'=0
replace ProbLiveInd80_`year'=1 if KAGE>=65 & KAGE<=69 & ProbLiveIndVarious_`year'~=.
gen ProbLiveInd85_`year'=0
replace ProbLiveInd85_`year'=1 if (KAGE>=70 & KAGE<=74 & ProbLiveIndVarious_`year'~=.) | (KAGE<65  & ProbLiveIndVarious_`year'~=.)
gen ProbLiveInd90_`year'=0
replace ProbLiveInd90_`year'=1 if KAGE>=75 & KAGE<=79 & ProbLiveIndVarious_`year'~=.
gen ProbLiveInd95_`year'=0
replace ProbLiveInd95_`year'=1 if KAGE>=80 & KAGE<=84 & ProbLiveIndVarious_`year'~=.
gen ProbLiveInd100_`year'=0
replace ProbLiveInd100_`year'=1 if KAGE>=85 & KAGE<=89 & ProbLiveIndVarious_`year'~=.

/* Probability will be able to manage affairs at various ages */
gen ProbManAffairsVarious_`year'      =KP107
gen ProbManAffairsVarious_Dk_`year'   =0
replace ProbManAffairsVarious_Dk_`year'=1 if KP107==998 
/* Dummies for appropriate age values for question KP106. */
gen ProbManAffairs80_`year'=0
replace ProbManAffairs80_`year'=1 if KAGE>=65 & KAGE<=69 & ProbManAffairsVarious_`year'~=.
gen ProbManAffairs85_`year'=0
replace ProbManAffairs85_`year'=1 if (KAGE>=70 & KAGE<=74 & ProbManAffairsVarious_`year'~=.) | (KAGE<65  & ProbManAffairsVarious_`year'~=.)
gen ProbManAffairs90_`year'=0
replace ProbManAffairs90_`year'=1 if KAGE>=75 & KAGE<=79 & ProbManAffairsVarious_`year'~=.
gen ProbManAffairs95_`year'=0
replace ProbManAffairs95_`year'=1 if KAGE>=80 & KAGE<=84 & ProbManAffairsVarious_`year'~=.
gen ProbManAffairs100_`year'=0
replace ProbManAffairs100_`year'=1 if KAGE>=85 & KAGE<=89 & ProbManAffairsVarious_`year'~=.

/* Earlier we asked you to rate your health on a scale of excellent, very good, good, fair or poor
    and you rated your current health as [excellent/very good/good/fair/poor].
   What are the chances that your health will [still be excellent/still be very good or better/still
    be good or better/still be fair or better/have improved significantly] FOUR years from now? */
gen ProbHealthSame4yrs_`year'        =KP108
gen ProbHealthSame4yrs_Dk_`year'     =0
replace ProbHealthSame4yrs_Dk_`year' =1 if KP108==998

gen ProbHealthDecl4yrs_`year'        =KP109
gen ProbHealthDecl4yrs_Dk_`year'     =0
replace ProbHealthDecl4yrs_Dk_`year' =1 if KP109==998

/* Chance medical expensus use up all of savings in next 5 years*/
gen ProbMedUseAllSav5yrs_`year'      =KP070
gen ProbMedUseAllSav5yrs_Dk_`year'   =0
replace ProbMedUseAllSav5yrs_Dk_`year'=1 if KP070==998

/* Chances give $5k in financial help to grown children, family, or friends? */
gen GiveFinHelp5k_`year'              =KP030
gen GiveFinHelp5k_Dk_`year'            =0
replace GiveFinHelp5k_Dk_`year'       =1 if KP030==998

/* Chances give $1k in financial help to grown children, family, or friends? */
gen GiveFinHelp1k_`year'              =KP071
gen GiveFinHelp1k_Dk_`year'            =0
replace GiveFinHelp1k_Dk_`year'       =1 if KP071==998

/* Chances give $10k in financial help to grown children, family, or friends? */
gen GiveFinHelp10k_`year'              =KP072
gen GiveFinHelp10k_Dk_`year'            =0
replace GiveFinHelp10k_Dk_`year'       =1 if KP072==998

/* Chances give $20k in financial help to grown children, family, or friends? */
gen GiveFinHelp20k_`year'              =KP073
gen GiveFinHelp20k_Dk_`year'            =0
replace GiveFinHelp20k_Dk_`year'       =1 if KP073==998

/* Chances receive $5k in financial help from grown children, family, or friends? */
gen RecFinHelp5k_`year'              =KP031
gen RecFinHelp5k_Dk_`year'            =0
replace RecFinHelp5k_Dk_`year'       =1 if KP031==998

/* Chances receive $2.5k in financial help from grown children, family, or friends? */
gen RecFinHelp2pt5k_`year'           =KP074
gen RecFinHelp2pt5k_Dk_`year'         =0
replace RecFinHelp2pt5k_Dk_`year'    =1 if KP074==998

/* Chances receive $1k in financial help from grown children, family, or friends? */
gen RecFinHelp1k_`year'           =KP075
gen RecFinHelp1k_Dk_`year'         =0
replace RecFinHelp1k_Dk_`year'    =1 if KP075==998

/* Chances receive $10k in financial help from grown children, family, or friends? */
gen RecFinHelp10k_`year'           =KP076
gen RecFinHelp10k_Dk_`year'         =0
replace RecFinHelp10k_Dk_`year'    =1 if KP076==998

/* What is chance will have to move to a nursuing home ever (in next 5 years)?
   If age<65, question is ever. If age>=65, question is in next 5 years. */
gen ProbMoveToNH_`year'               =KP032
gen ProbMoveToNH_Dk_`year'            =0
replace ProbMoveToNH_Dk_`year'        =1 if KP032==998
gen NH5years_`year'                   =0
replace NH5years_`year'               =1 if KAGE>=65
gen NHEver_`year'                     =0
replace NHEver_`year'                 =1 if KAGE<65

/* Probability US has economic depression in next 10 years */
gen ProbUSEconDep_`year'              =KP034
gen ProbUSEconDep_Dk_`year'           =0
replace ProbUSEconDep_Dk_`year'       =1 if KP034==998

/* Probability congress changes social security to be less generous in next
   10 years. */
gen SSChangeLessGenerous_`year'       =KP110
gen SSChangeLessGenerous_Dk_`year'    =0
replace SSChangeLessGenerous_Dk_`year'=1 if KP110==998

/* Probability your personal SS benefits will get cut in next 10 years. Only for those currently
   receiving SS. */
gen SSRecPersLessGenerous_`year'      =KP111
gen SSRecPersLessGenerous_Dk_`year'   =0
replace SSRecPersLessGenerous_Dk_`year'=1 if KP111==998	

/* Probability your personal SS benefits will get cut in next 10 years. Only for those who expect
   to receive SS in the futre. */
gen SSFutPersLessGenerous_`year'      =KP112
gen SSFutPersLessGenerous_Dk_`year'   =0
replace SSFutPersLessGenerous_Dk_`year'=1 if KP112==998			
				
/* Chance that mutual fund shares invested in blue chip stocks worth more next year */
gen ProbMarketUp_`year'               =KP047
gen ProbMarketUp_Dk_`year'            =0
replace ProbMarketUp_Dk_`year'        =1 if KP047==998

/* If ProbMarketUp_`year'=50%, then ask whether is really 50% or is unsure.
            81           1.  EQUALLY LIKELY
           851           2.  UNSURE
           383           3.  CAN'T KNOW*/
gen MarketUp_5050_`year'              =KP113

/* Now think 10 years into the future. What are the chances the price of these mutual
   fund shares will increase faster than the cost of living over the next 10 years? */
gen ProbMarketvsCOL_`year'            =KP114
gen ProbMarketvsCOL_Dk_`year'         =0
replace ProbMarketvsCOL_Dk_`year'     =1 if KP114==998

/* Over the next 10 years what are the chances the price of these mutual fund shares will
   increase by 8 percent or more per year on average? */
gen ProbMarketUp8Perc_`year'            =KP115
gen ProbMarketUp8Perc_Dk_`year'         =0
replace ProbMarketUp8Perc_Dk_`year'     =1 if KP115==998

/* Now think how these mutual fund shares might have performed over the past ten years.
   What would you guess was the average annual rate of return earned during the past ten years? */
gen EstMarketRet10yrs_`year'            =KP117
gen EstMarketRet10yrs_Dk_`year'         =0
replace EstMarketRet10yrs_Dk_`year'     =1 if KP120==98 /* using KP120 since recorded after range estimates */
gen EstMarketRet10yrsPointEst_`year'    =0
replace EstMarketRet10yrsPointEst_`year'=1 if KP117<998 

gen double EstMarketRet10yrs_minval           =KP118
gen double EstMarketRet10yrs_maxval           =KP119

local EstMarketRet10yrs_Binmin0   1
local EstMarketRet10yrs_Binmin1   4
local EstMarketRet10yrs_Binmin2   9
local EstMarketRet10yrs_Binmin3   16
local EstMarketRet10yrs_Binmax0   2
local EstMarketRet10yrs_Binmax1   7
local EstMarketRet10yrs_Binmax2   14
local EstMarketRet10yrs_Binmax3   99999996
local EstMarketRet10yrs_Binexact1 0
local EstMarketRet10yrs_Binexact2 3
local EstMarketRet10yrs_Binexact3 8
local EstMarketRet10yrs_Binexact4 15

/* Generating exact values here */
replace EstMarketRet10yrs_`year'=`EstMarketRet10yrs_Binexact1' if EstMarketRet10yrs_minval==`EstMarketRet10yrs_Binexact1' & EstMarketRet10yrs_maxval==`EstMarketRet10yrs_Binexact1'
replace EstMarketRet10yrs_`year'=`EstMarketRet10yrs_Binexact2' if EstMarketRet10yrs_minval==`EstMarketRet10yrs_Binexact2' & EstMarketRet10yrs_maxval==`EstMarketRet10yrs_Binexact2'
replace EstMarketRet10yrs_`year'=`EstMarketRet10yrs_Binexact3' if EstMarketRet10yrs_minval==`EstMarketRet10yrs_Binexact3' & EstMarketRet10yrs_maxval==`EstMarketRet10yrs_Binexact3'
replace EstMarketRet10yrs_`year'=`EstMarketRet10yrs_Binexact4' if EstMarketRet10yrs_minval==`EstMarketRet10yrs_Binexact4' & EstMarketRet10yrs_maxval==`EstMarketRet10yrs_Binexact4'

/* Generating median for bin "0" */
sum EstMarketRet10yrs_`year' if EstMarketRet10yrsPointEst_`year'==1 & EstMarketRet10yrs_`year'>=`EstMarketRet10yrs_Binmin0' & EstMarketRet10yrs_`year'<=`EstMarketRet10yrs_Binmax0', detail
assert r(N)>`impute_numobs'
replace EstMarketRet10yrs_`year'=r(p$bin_pctile) if EstMarketRet10yrs_minval==`EstMarketRet10yrs_Binmin0' & EstMarketRet10yrs_maxval==`EstMarketRet10yrs_Binmax0'

/* Generating median for bin 1 */
sum EstMarketRet10yrs_`year' if EstMarketRet10yrsPointEst_`year'==1 & EstMarketRet10yrs_`year'>=`EstMarketRet10yrs_Binmin1' & EstMarketRet10yrs_`year'<=`EstMarketRet10yrs_Binmax1', detail
assert r(N)>`impute_numobs'
replace EstMarketRet10yrs_`year'=r(p$bin_pctile) if EstMarketRet10yrs_minval==`EstMarketRet10yrs_Binmin1' & EstMarketRet10yrs_maxval==`EstMarketRet10yrs_Binmax1'

/* Generating median for bin 2 */
sum EstMarketRet10yrs_`year' if EstMarketRet10yrsPointEst_`year'==1 & EstMarketRet10yrs_`year'>=`EstMarketRet10yrs_Binmin2' & EstMarketRet10yrs_`year'<=`EstMarketRet10yrs_Binmax2', detail
assert r(N)>`impute_numobs'
replace EstMarketRet10yrs_`year'=r(p$bin_pctile) if EstMarketRet10yrs_minval==`EstMarketRet10yrs_Binmin2' & EstMarketRet10yrs_maxval==`EstMarketRet10yrs_Binmax2'

/* Generating median for bin 3 */
sum EstMarketRet10yrs_`year' if EstMarketRet10yrsPointEst_`year'==1 & EstMarketRet10yrs_`year'>=`EstMarketRet10yrs_Binmin3' & EstMarketRet10yrs_`year'<=`EstMarketRet10yrs_Binmax3', detail
assert r(N)>`impute_numobs'
replace EstMarketRet10yrs_`year'=r(p$bin_pctile) if EstMarketRet10yrs_minval==`EstMarketRet10yrs_Binmin3' & EstMarketRet10yrs_maxval==`EstMarketRet10yrs_Binmax3'


/* Probability cost of living increases by 5% or more per year on average */
gen ProbCOLUp5PercPerYear_`year'     =KP116
gen ProbCOLUp5PercPerYear_Dk_`year'  =0
replace ProbCOLUp5PercPerYear_Dk_`year'=1 if KP116==998

/* How closely do you follow the stock market? */
gen FollowMarket_`year'               =KP097
gen FollowMarket_Dk_`year'            =0
replace FollowMarket_Dk_`year'        =1 if KP097==998

/* Probability move back to Mexico */
gen ProbMoveMexico_`year'             =KP100

/* Probability move back to Mexico *if* have serious health problems */
gen ProbMoveMexicoHealth_`year'       =KP101

/* In deciding how much of their  family) income to spend or save, people are likely to think about
   different financial planning periods. In planning your (family's) saving and spending, which of
   the following time periods is most important to you (and your (husband/wife/partner)), the next
   few months, the next year, the next few years, the next 5-10 years, or longer than 10 years? */
gen     FinPlanPerFewMonths_`year'    =0
gen     FinPlanPerOneYr_`year'        =0
gen     FinPlanPerFewYrs_`year'       =0
gen     FinPlanPerFiveTenYrs_`year'   =0
gen     FinPlanPerMoreTenYrs_`year'   =0
replace FinPlanPerFewMonths_`year'    =1 if KP041==1
replace FinPlanPerOneYr_`year'        =1 if KP041==2
replace FinPlanPerFewYrs_`year'       =1 if KP041==3
replace FinPlanPerFiveTenYrs_`year'   =1 if KP041==4
replace FinPlanPerMoreTenYrs_`year'   =1 if KP041==5

gen FinPlanCat_`year'=KP041

/* Will children have higher, lower, same standard of living at your age? */
gen     ChildBetterOff_`year'         =0
gen     ChildWorseOff_`year'          =0
gen     ChildSameOff_`year'           =0
replace ChildBetterOff_`year'         =1 if KP042==1
replace ChildWorseOff_`year'          =1 if KP042==2
replace ChildSameOff_`year'           =1 if KP042==3

/* Follow up about "much" better or worse off. 1=yes, 0=no. */
gen     ChildMuchBetter_`year'        =0
replace ChildMuchBetter_`year'        =1 if KP043==1
gen     ChildMuchWorse_`year'         =0
replace ChildMuchWorse_`year'         =1 if KP044==1

/* Did you get help filling out this section */
gen     NoExpHelp_`year'              =0
gen     SomeExpHelp_`year'            =0
gen     LotExpHelp_`year'             =0
gen     ProxyExpHelp_`year'           =0
replace NoExpHelp_`year'              =1 if KP056==1
replace SomeExpHelp_`year'            =1 if KP056==2
replace LotExpHelp_`year'             =1 if KP056==3
replace ProxyExpHelp_`year'           =1 if KP056==4

/*************************************************************************
					RISK AVERSION QUESTIONS
*************************************************************************/

/******* Income Gambles *************/
/* Income gamble: choose between guaranteed lifetime income (current) or 50-50 gamble that
   lifetime income would double or be cut by one-third. 1=first job, 2=second. */
gen IncGambleOneThird_`year'           =KP036
gen IncGambleOneThird_Dk_`year'        =0
replace IncGambleOneThird_Dk_`year'    =1 if KP036==8

/* Income gamble: If YES to KP036, choose between guaranteed lifetime income (current) or 50-50 gamble that
   lifetime income would double or be cut by one-half. 1=first job, 2=second. */
gen IncGambleOneHalf_`year'            =KP037
gen IncGambleOneHalf_Dk_`year'         =0
replace IncGambleOneHalf_Dk_`year'     =1 if KP037==8

/* Income gamble: If YES to KP037, choose between guaranteed lifetime income (current) or 50-50 gamble that
   lifetime income would double or be cut by 75%. 1=first job, 2=second. */
gen IncGamble75perc_`year'             =KP038
gen IncGamble75perc_Dk_`year'          =0
replace IncGamble75perc_Dk_`year'      =1 if KP038==8

/* Income gamble: If NO to KP036, choose between guaranteed lifetime income (current) or 50-50 gamble that
   lifetime income would double or be cut by 20%. 1=first job, 2=second. */
gen IncGambleOneFifth_`year'           =KP039
gen IncGambleOneFifth_Dk_`year'        =0
replace IncGambleOneFifth_Dk_`year'    =1 if KP039==8

/* Income gamble: If NO to KP039, choose between guaranteed lifetime income (current) or 50-50 gamble that
   lifetime income would double or be cut by 10%. 1=first job, 2=second. */
gen IncGambleOneTenth_`year'           =KP040
gen IncGambleOneTenth_Dk_`year'        =0
replace IncGambleOneTenth_Dk_`year'    =1 if KP040==8

/* Now I create a categorical variable for which bin the respondent ends up in:
   Will go from most risk averse to least. So we have the following:
   Bin 1: answer 1 to KP040
   Bin 2: answer 2 to KP040 but 1 to KP039
   Bin 3: answer 2 to KP039 but 1 to KP036
   Bin 4: answer 2 to KP036 but 1 to KP037
   Bin 5: answer 2 to KP037 but 1 to KP038
   Bin 6: answer 2 to KP038 */
   
gen IncRAbin_`year' =0
replace IncRAbin_`year' =1 if KP040==1
replace IncRAbin_`year' =2 if KP040==2 & KP039==1
replace IncRAbin_`year' =3 if KP039==2 & KP036==1
replace IncRAbin_`year' =4 if KP036==2 & KP037==1
replace IncRAbin_`year' =5 if KP037==2 & KP038==1
replace IncRAbin_`year' =6 if KP038==2 

/******* Business Gambles *************/

/* Now I have another kind of question. Suppose that a distant relative left you a
         share in a private business worth one million dollars. You are immediately faced
         with a choice -- whether to cash out now and take the one million dollars, or to
         wait until the company goes public in one month, which would give you a 50-50
         chance of doubling your money to two million dollars and a 50-50 chance of
         losing one-third of it, leaving you 667 thousand dollars.
   Would you cash out immediately or wait until after the company goes public?.
         1=cash out, 2=wait. */
gen BusGambleOneThird_`year'           =KP060
gen BusGambleOneThird_Dk_`year'        =0
replace BusGambleOneThird_Dk_`year'    =1 if KP060==8

/* Business gamble: If WAIT to KP060, choose between cash outor 50-50 gamble that
   business value would double or be cut by one-half. 1=cash out, 2=wait. */
gen BusGambleOneHalf_`year'            =KP061
gen BusGambleOneHalf_Dk_`year'         =0
replace BusGambleOneHalf_Dk_`year'     =1 if KP061==8

/* Business gamble: If WAIT to KP061, choose between cash outor 50-50 gamble that
   business value would double or be cut by 75%. 1=cash out, 2=wait. */
gen BusGamble75perc_`year'             =KP062
gen BusGamble75perc_Dk_`year'          =0
replace BusGamble75perc_Dk_`year'      =1 if KP062==8

/* Business gamble: If CASH OUT to KP060, choose between cash outor 50-50 gamble that
   business value would double or be cut by 20%. 1=cash out, 2=wait. */
gen BusGambleOneFifth_`year'           =KP063
gen BusGambleOneFifth_Dk_`year'        =0
replace BusGambleOneFifth_Dk_`year'    =1 if KP063==8

/* Business gamble: If CASH OUT to KP063, choose between cash outor 50-50 gamble that
   business value would double or be cut by 10%. 1=cash out, 2=wait. */
gen BusGambleOneTenth_`year'           =KP064
gen BusGambleOneTenth_Dk_`year'        =0
replace BusGambleOneTenth_Dk_`year'    =1 if KP064==8

/* Now I create a categorical variable for which bin the respondent ends up in:
   Will go from most risk averse to least. So we have the following:
   Bin 1: answer 1 to KP064
   Bin 2: answer 2 to KP064 but 1 to KP063
   Bin 3: answer 2 to KP063 but 1 to KP060
   Bin 4: answer 2 to KP060 but 1 to KP061
   Bin 5: answer 2 to KP061 but 1 to KP062
   Bin 6: answer 2 to KP062 */
   
gen BusRAbin_`year' =0
replace BusRAbin_`year' =1 if KP064==1
replace BusRAbin_`year' =2 if KP064==2 & KP063==1
replace BusRAbin_`year' =3 if KP063==2 & KP060==1
replace BusRAbin_`year' =4 if KP060==2 & KP061==1
replace BusRAbin_`year' =5 if KP061==2 & KP062==1
replace BusRAbin_`year' =6 if KP062==2 

/******* Inheritence Gambles *************/
/* Now I have another kind of question. Suppose that you unexpectedly inherited one
         million dollars from a distant relative. You are immediately faced with the
         opportunity to take a one-time risky, but possibly rewarding investment option
         that has a 50-50 chance of doubling the money to two million dollars within a
         month and a 50-50 chance of reducing the money by one-third, to 667 thousand
         dollars, within a month.
   Would you take the risky investment option or not?
         1=yes, 5=no. */
gen InherGambleOneThird_`year'           =KP065
gen InherGambleOneThird_Dk_`year'        =0
replace InherGambleOneThird_Dk_`year'    =1 if KP065==8

/* Inheritence gamble: If YES to KP065, choose between cash out or 50-50 gamble that
   Inheritence value would double or be cut by one-half. 1=yes, 5=no. */
gen InherGambleOneHalf_`year'            =KP066
gen InherGambleOneHalf_Dk_`year'         =0
replace InherGambleOneHalf_Dk_`year'     =1 if KP066==8

/* Inheritence gamble: If YES to KP066, choose between cash out or 50-50 gamble that
   Inheritence value would double or be cut by 75%. 1=yes, 5=no. */
gen InherGamble75perc_`year'             =KP067
gen InherGamble75perc_Dk_`year'          =0
replace InherGamble75perc_Dk_`year'      =1 if KP067==8

/* Inheritence gamble: If NO to KP065, choose between cash out or 50-50 gamble that
   Inheritence value would double or be cut by 20%. 1=yes, 5=no. */
gen InherGambleOneFifth_`year'           =KP068
gen InherGambleOneFifth_Dk_`year'        =0
replace InherGambleOneFifth_Dk_`year'    =1 if KP068==8

/* Inheritence gamble: If NO to KP068, choose between cash out or 50-50 gamble that
   Inheritence value would double or be cut by 10%. 1=yes, 5=no. */
gen InherGambleOneTenth_`year'           =KP069
gen InherGambleOneTenth_Dk_`year'        =0
replace InherGambleOneTenth_Dk_`year'    =1 if KP069==8

/* Now I create a categorical variable for which bin the respondent ends up in:
   Will go from most risk averse to least. So we have the following:
   Bin 1: answer 1 to KP069
   Bin 2: answer 2 to KP069 but 1 to KP068
   Bin 3: answer 2 to KP068 but 1 to KP065
   Bin 4: answer 2 to KP065 but 1 to KP066
   Bin 5: answer 2 to KP066 but 1 to KP067
   Bin 6: answer 2 to KP067 */
   
gen InherRAbin_`year' =0
replace InherRAbin_`year' =1 if KP069==5
replace InherRAbin_`year' =2 if KP069==1 & KP068==5
replace InherRAbin_`year' =3 if KP068==1 & KP065==5
replace InherRAbin_`year' =4 if KP065==1 & KP066==5
replace InherRAbin_`year' =5 if KP066==1 & KP067==5
replace InherRAbin_`year' =6 if KP067==1 

/************ Other Expectations *********/

gen ProbDoubleDigitInf_`year'=.

keep HHID PN ProbMarketUp_`year' ProbUSEconDep_`year' ProbDoubleDigitInf_`year' FollowMarket_`year' FinPlanCat_`year' IncRAbin_`year' InherRAbin_`year' BusRAbin_`year'

save "$CleanData/HRSExp`year'.dta", replace
