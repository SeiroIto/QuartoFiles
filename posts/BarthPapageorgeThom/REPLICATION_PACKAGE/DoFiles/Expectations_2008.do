
/* NOTE: THERE CAN BE MORE THAN ONE RESPONDENT WITHIN AN HHID-SUBHH HOUSEHOLD */

/* Setting up. Merge with the Pre Load values to know which random assignments households get */
clear all
local year "2008"
local smallyear="08"
local survey="$HRSSurveys08"
local rangemethod="mid" /* cab be "mid", "min", or "max"; could also bootstrap */

infile using "`survey'/h`smallyear'sta/H`smallyear'P_R.dct" , using("`survey'/h`smallyear'da/H`smallyear'P_R.da")
merge 1:1 HHID PN using "$CleanData/HRSPreLoad`year'.dta", assert(3)
tab _merge /* Should be all matched */
drop _merge
save "$CleanData/HRS_RAWwithPreLoad`year'.dta", replace

/* Need age data later, which comes from the Cross-Wave Tracker File, so will load
   that now, keep relevant variables and save, so can be easily merged later. */
use "$Tracker16/HRS_Tracker16.dta"
keep HHID PN L*
save "$CleanData/HRSTrackerSmall`year'.dta", replace

/* Now reload expectations data */
clear
use "$CleanData/HRS_RAWwithPreLoad`year'.dta"

/* Number of 0-100 questions asked */
gen NumQs_`year'                      =LP155

/* Number of questions answered Dk or Rf */
gen NumDkRf_`year'                    =LP156
 
/* 	Now ask about bequests (including property and valuables) */
gen ProbBeqMoreThan10k_`year'         =LP005
gen ProbBeqMoreThan10k_Dk_`year'      =0
replace ProbBeqMoreThan10k_Dk_`year'=1 if LP005==998

gen ProbBeqMoreThan100k_`year'        =LP006
gen ProbBeqMoreThan100k_Dk_`year'     =0
replace ProbBeqMoreThan100k_Dk_`year' =1 if LP006==998

gen ProbBeqMoreThan500k_`year'        =LP059
gen ProbBeqMoreThan500k_Dk_`year'     =0
replace ProbBeqMoreThan500k_Dk_`year' =1 if LP059==998

gen ProbBeqAny_`year'                 =LP007
gen ProbBeqAny_Dk_`year'              =0
replace ProbBeqAny_Dk_`year'          =1 if LP007==998


/*  What is chance work for pay in the future? Only applies if not working (J020~=1)  */
gen ProbWorkforPay_`year'             =LP016
gen ProbWorkforPay_Dk_`year'          =0
replace ProbWorkforPay_Dk_`year'      =1 if LP016==998

/*  What is probability R will be working at 62? Only applies if less than 62 and LP016~=0 */
gen ProbWorkPost62_`year'             =LP017
gen ProbWorkPost62_Dk_`year'          =0
/*  Captures Dk to main question, then to the 0% and 100% follow up questions */
replace ProbWorkPost62_Dk_`year'      =1 if LP017==998 | LP124==8 | LP125==998 | LP126==8 | LP127==998
/*  If ProbWorkPost62_`year'=50%, then ask whether is really 50% or is unsure. 1=equally likely,
    2=unsure. */
gen ProbWorkPost62_5050_`year'        =LP123
/* For LP123: When you say zero percent chance, do you mean that you see no chance at all you will be working
   full-time, or do you mean you see a small enough chance that zero is a good approximation?
   473           1.  NO CHANCE AT ALL
   142           3.  APPROXIMATION*/
gen ProbWorkPost62_Zero_`year'        =LP124
/* LP125 asks for best estimate, so I replace value of ProbWorkforPay with this estimate */
replace ProbWorkPost62_`year'         =LP125 if ProbWorkPost62_Zero_`year'==3
/* For LP126: When you say 100 percent chance, do you mean that you are certain you will be working full-time,
   or do you mean you see a large enough chance that 100 is a good approximation?
           636           1.  CERTAIN
           145           3.  APPROXIMATION */
gen ProbWorkPost62_100_`year'         =LP126
replace ProbWorkPost62_`year'         =LP127 if ProbWorkPost62_100_`year'==3

/*  What is probability R will be working at 65? Only applies if older than 62 and less than 65 and J021==1 */
gen ProbWorkPost65_`year'             =LP018
gen ProbWorkPost65_Dk_`year'          =0
replace ProbWorkPost65_Dk_`year'      =1 if LP018==998

/* Only applies if J505 or J517 is equal to one (is looking for a job) */
gen ProbFindJobFewMonths_`year'       =LP020
gen ProbFindJobFewMonths_Dk_`year'    =0
replace ProbFindJobFewMonths_Dk_`year'=1 if LP020==998

/* Percent chance live to be 75 or more */
gen ProbLive75More_`year'             =LP028
gen ProbLive75More_Dk_`year'          =0
replace ProbLive75More_Dk_`year'      =1 if LP028==998 | LP132==8 | LP133==998 | LP134==8 | LP135==998
/*  If ProbLive75More_`year'=50%, then ask whether is really 50% or is unsure. 1=equally likely,
    2=unsure. */
gen ProbLive75More_5050_`year'        =LP102
/* When you say zero percent chance, do you mean that you see no chance at all you will live to 75 or beyond,
   or do you mean you see a small enough chance that zero is a good approximation? 
			153           1.  NO CHANCE AT ALL
            71            3.  APPROXIMATION */
gen ProbLive75More_Zero_`year'       =LP132
replace ProbLive75More_`year'        =LP133 if ProbLive75More_Zero_`year'==3
/* When you say 100 percent chance, do you mean that you are certain you will live to 75 or beyond,
   or do you mean you see a large enough chance that 100 is a good approximation?
           503           1.  CERTAIN
           358           3.  APPROXIMATION */
gen ProbLive75More_100_`year'        =LP134
replace ProbLive75More_`year'        =LP135 if ProbLive75More_100_`year'==3
/* IF R SAID {10 or 20 or 25 or 30 or 40 or 60 or 70 or 75 or 80 or 90} PERCENT CHANCE THAT WILL LIVE
   TO 75 YEARS OF AGE (P028 = 10 or 20 or 25 or 30 or 40 or 60 or 70 or 75 or 80 or 90), CONTINUE ON TO P128:
   "When you said PERCENTAGE PER P028 percent just now, did you mean this as an exact number
    or were you rounding or approximating?"
			1029           1.  EXACT NUMBER
            2185           3.  APPROXIMATION*/
gen ProbLive75More_Approx_`year'     =LP128
gen ProbLive75More_Min_`year'        =LP130
gen ProbLive75More_Max_`year'        =LP131   
			
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

/* If live to 75, chance that health will allow to live independently; only for age<65 I think. */
gen ProbLivIndat75_`year'            =LP103
gen ProbLivIndat75_Dk_`year'         =0
replace ProbLivIndat75_Dk_`year'     =1 if LP103==998

/* Assuming that you are still living at 75, what are the chances that you will be free of serious problems
   in thinking, reasoning or remembering things that would interfere with your ability to manage your own affairs? */
gen ProbManAffairsat75_`year'        =LP104
gen ProbManAffairsat75_Dk_`year'     =0
replace ProbManAffairsat75_Dk_`year' =1 if LP104==998

/* What is the percent chance that you will live to be [85/80/90/95/100] or more?
         80 (IF AGE IS 65-69)
         85 (IF AGE IS 70-74)
         90 (IF AGE IS 75-79)
         95 (IF AGE IS 80-84)
         100 (IF AGE IS 85-89) */		 
gen ProbLiveToVarious_`year'         =LP029
gen ProbLiveToVarious_Dk_`year'      =0
replace ProbLiveToVarious_Dk_`year'  =1 if LP029==998 | LP158==8  | LP159==998  | LP160==8  | LP161==998

/* If ProbLiveToVarious_`year'=50%, then ask whether is really 50% or is unsure. 1=equally likely,
    2=unsure. */
gen ProbLiveToVarious_5050_`year'     =LP157
/* Now create dummies for which age category you are asked about; note age=999 folks excluded (3 of them) */
gen ProbLiveTo80_`year'=0
replace ProbLiveTo80_`year'=1 if LAGE>=65 & LAGE<=69 & ProbLiveToVarious_`year'~=.
gen ProbLiveTo85_`year'=0
replace ProbLiveTo85_`year'=1 if (LAGE>=70 & LAGE<=74 & ProbLiveToVarious_`year'~=.) | (LAGE<65  & ProbLiveToVarious_`year'~=.)
gen ProbLiveTo90_`year'=0
replace ProbLiveTo90_`year'=1 if LAGE>=75 & LAGE<=79 & ProbLiveToVarious_`year'~=.
gen ProbLiveTo95_`year'=0
replace ProbLiveTo95_`year'=1 if LAGE>=80 & LAGE<=84 & ProbLiveToVarious_`year'~=.
gen ProbLiveTo100_`year'=0
replace ProbLiveTo100_`year'=1 if LAGE>=85 & LAGE<=89 & ProbLiveToVarious_`year'~=.

/* For LP029: When you say zero percent chance, do you mean that you see no chance at all you will live
   to [85/80/90/95/100] or do you mean you see a small enough chance that zero is a good approximation? */
gen ProbLivetoVarious_Zero_`year'    =LP158
replace ProbLiveToVarious_`year'     =LP159 if ProbLivetoVarious_Zero_`year'==3

/* For LP029: When you say 100 percent chance, do you mean that you are certain you will live
   to [85/80/90/95/100] or beyond, or do you mean you see a large enough chance that 100 is a good approximation? */
gen ProbLivetoVarious_100_`year'     =LP160
replace ProbLiveToVarious_`year'     =LP161 if ProbLivetoVarious_100_`year'==3

/* When you said 50 percent just now, did you mean this as an exact number or were you rounding or approximating?
   1=exact, 3=approximating. */
gen ProbLivetoVarious_Exact_`year'   =LP136

/* If ProbLivetoVarious_Exact_`year'==3, asks for range (min and max). */
gen ProbLivetoVarious_Min_`year'     =LP138
gen ProbLivetoVarious_Max_`year'     =LP139

/* Probability that health will be good enough to live independently at various ages*/
gen ProbLiveIndVarious_`year'        =LP106
gen ProbLiveIndVarious_Dk_`year'     =0
replace ProbLiveIndVarious_Dk_`year' =1 if LP106==998
/* Dummies for appropriate age values for question LP106. */
gen ProbLiveInd80_`year'=0
replace ProbLiveInd80_`year'=1 if LAGE>=65 & LAGE<=69 & ProbLiveIndVarious_`year'~=.
gen ProbLiveInd85_`year'=0
replace ProbLiveInd85_`year'=1 if (LAGE>=70 & LAGE<=74 & ProbLiveIndVarious_`year'~=.) | (LAGE<65  & ProbLiveIndVarious_`year'~=.)
gen ProbLiveInd90_`year'=0
replace ProbLiveInd90_`year'=1 if LAGE>=75 & LAGE<=79 & ProbLiveIndVarious_`year'~=.
gen ProbLiveInd95_`year'=0
replace ProbLiveInd95_`year'=1 if LAGE>=80 & LAGE<=84 & ProbLiveIndVarious_`year'~=.
gen ProbLiveInd100_`year'=0
replace ProbLiveInd100_`year'=1 if LAGE>=85 & LAGE<=89 & ProbLiveIndVarious_`year'~=.

/* Probability will be able to manage affairs at various ages */
gen ProbManAffairsVarious_`year'      =LP107
gen ProbManAffairsVarious_Dk_`year'   =0
replace ProbManAffairsVarious_Dk_`year'=1 if LP107==998 
/* Dummies for appropriate age values for question LP106. */
gen ProbManAffairs80_`year'=0
replace ProbManAffairs80_`year'=1 if LAGE>=65 & LAGE<=69 & ProbManAffairsVarious_`year'~=.
gen ProbManAffairs85_`year'=0
replace ProbManAffairs85_`year'=1 if (LAGE>=70 & LAGE<=74 & ProbManAffairsVarious_`year'~=.) | (LAGE<65  & ProbManAffairsVarious_`year'~=.)
gen ProbManAffairs90_`year'=0
replace ProbManAffairs90_`year'=1 if LAGE>=75 & LAGE<=79 & ProbManAffairsVarious_`year'~=.
gen ProbManAffairs95_`year'=0
replace ProbManAffairs95_`year'=1 if LAGE>=80 & LAGE<=84 & ProbManAffairsVarious_`year'~=.
gen ProbManAffairs100_`year'=0
replace ProbManAffairs100_`year'=1 if LAGE>=85 & LAGE<=89 & ProbManAffairsVarious_`year'~=.

/* Earlier we asked you to rate your health on a scale of excellent, very good, good, fair or poor
    and you rated your current health as [excellent/very good/good/fair/poor].
   What are the chances that your health will [still be excellent/still be very good or better/still
    be good or better/still be fair or better/have improved significantly] FOUR years from now? */
gen ProbHealthSame4yrs_`year'        =LP108
gen ProbHealthSame4yrs_Dk_`year'     =0
replace ProbHealthSame4yrs_Dk_`year' =1 if LP108==998

gen ProbHealthDecl4yrs_`year'        =LP109
gen ProbHealthDecl4yrs_Dk_`year'     =0
replace ProbHealthDecl4yrs_Dk_`year' =1 if LP109==998

/* Chance medical expensus use up all of savings in next 5 years*/
gen ProbMedUseAllSav5yrs_`year'      =LP070
gen ProbMedUseAllSav5yrs_Dk_`year'   =0
replace ProbMedUseAllSav5yrs_Dk_`year'=1 if LP070==998

/* What is chance will have to move to a nursuing home ever (in next 5 years)?
   If age<65, question is ever. If age>=65, question is in next 5 years. */
gen ProbMoveToNH_`year'               =LP032
gen ProbMoveToNH_Dk_`year'            =0
replace ProbMoveToNH_Dk_`year'        =1 if LP032==998
gen NH5years_`year'                   =0
replace NH5years_`year'               =1 if LAGE>=65
gen NHEver_`year'                     =0
replace NHEver_`year'                 =1 if LAGE<65

/* Probability US has economic depression in next 10 years */
gen ProbUSEconDep_`year'              =LP034
gen ProbUSEconDep_Dk_`year'           =0
replace ProbUSEconDep_Dk_`year'       =1 if LP034==998

/* Probability congress changes social security to be less generous in next
   10 years. */
gen SSChangeLessGenerous_`year'       =LP110
gen SSChangeLessGenerous_Dk_`year'    =0
replace SSChangeLessGenerous_Dk_`year'=1 if LP110==998

/* Probability your personal SS benefits will get cut in next 10 years. Only for those currently
   receiving SS. */
gen SSRecPersLessGenerous_`year'      =LP111
gen SSRecPersLessGenerous_Dk_`year'   =0
replace SSRecPersLessGenerous_Dk_`year'=1 if LP111==998	

/* Probability your personal SS benefits will get cut in next 10 years. Only for those who expect
   to receive SS in the futre. */
gen SSFutPersLessGenerous_`year'      =LP112
gen SSFutPersLessGenerous_Dk_`year'   =0
replace SSFutPersLessGenerous_Dk_`year'=1 if LP112==998			
				
/* Chance that mutual fund shares invested in blue chip stocks worth more next year */
gen ProbMarketUp_`year'               =LP047
gen ProbMarketUp_Dk_`year'            =0
replace ProbMarketUp_Dk_`year'        =1 if LP047==998 | LP145==8 | LP146==998 | LP147==8 | LP148==998

/* If ProbMarketUp_`year'=50%, then ask whether is really 50% or is unsure. 1=equally likely,
   2=unsure. */
gen MarketUp_5050_`year'              =LP113

/* If answered 0% to Market Up probability */
gen ProbMarketUp_Zero_`year'          =LP145
replace ProbMarketUp_`year'           =LP146 if ProbMarketUp_Zero_`year'==3
/* If answered 100% to Market Up Probability */
gen ProbMarketUp_100_`year'           =LP147
replace ProbMarketUp_`year'           =LP148 if ProbMarketUp_100_`year'==3

/* Now asks for probability that mutual fund shares will have fallen or gained by certain amount.
   Each respondent gets asked only one scenario, and these are randomized. Whether "gained" or
   "fallen" and by how much is stored in LP162 and LP163. */
gen ProbMarketChangeVarious_`year'   =LP150
gen ProbMarketChangeVarious_Dk_`year'=0
replace ProbMarketChangeVarious_Dk_`year'=1 if LP150==998

gen MarketChangeUp40_`year'          =0
replace MarketChangeUp40_`year'      =1 if LP162==2 & LP163==40
gen MarketChangeUp30_`year'          =0
replace MarketChangeUp30_`year'      =1 if LP162==2 & LP163==30
gen MarketChangeUp20_`year'          =0
replace MarketChangeUp20_`year'      =1 if LP162==2 & LP163==20
gen MarketChangeUp10_`year'          =0
replace MarketChangeUp10_`year'      =1 if LP162==2 & LP163==10
gen MarketChangeDown40_`year'        =0
replace MarketChangeDown40_`year'    =1 if LP162==1 & LP163==40
gen MarketChangeDown30_`year'        =0
replace MarketChangeDown30_`year'    =1 if LP162==1 & LP163==30
gen MarketChangeDown20_`year'        =0
replace MarketChangeDown20_`year'    =1 if LP162==1 & LP163==20
gen MarketChangeDown10_`year'        =0
replace MarketChangeDown10_`year'    =1 if LP162==1 & LP163==10

/* Probability cost of living increases by 5% or more per year on average */
gen ProbCOLUp5PercPerYear_`year'     =LP116
gen ProbCOLUp5PercPerYear_Dk_`year'  =0
replace ProbCOLUp5PercPerYear_Dk_`year'=1 if LP116==998

/* How closely do you follow the stock market? */
gen FollowMarket_`year'               =LP097
gen FollowMarket_Dk_`year'            =0
replace FollowMarket_Dk_`year'        =1 if LP097==998

/* Did you get help filling out this section */
gen     NoExpHelp_`year'              =0
gen     SomeExpHelp_`year'            =0
gen     LotExpHelp_`year'             =0
gen     ProxyExpHelp_`year'           =0
replace NoExpHelp_`year'              =1 if LP056==1
replace SomeExpHelp_`year'            =1 if LP056==2
replace LotExpHelp_`year'             =1 if LP056==3
replace ProxyExpHelp_`year'           =1 if LP056==4

gen FinPlanCat_`year'=.
gen ProbDoubleDigitInf_`year'=.
gen IncRAbin_`year'=.
gen InherRAbin_`year'=.
gen BusRAbin_`year'=.

keep HHID PN ProbMarketUp_`year' ProbUSEconDep_`year' ProbDoubleDigitInf_`year' FollowMarket_`year' FinPlanCat_`year' IncRAbin_`year' InherRAbin_`year' BusRAbin_`year'

save "$CleanData/HRSExp`year'.dta", replace
