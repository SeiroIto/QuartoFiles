
/* NOTE: THERE CAN BE MORE THAN ONE RESPONDENT WITHIN AN HHID-SUBHH HOUSEHOLD */

/* Setting up. Merge with the Pre Load values to know which random assignments households get */
clear all
local year "2002"
local smallyear="02"
local survey="$HRSSurveys02"
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
keep HHID PN H*
save "$CleanData/HRSTrackerSmall`year'.dta", replace

/* Now reload expectations data */
clear
use "$CleanData/HRS_RAWwithPreLoad`year'.dta"

/* What do you think are the chances that your income will keep up with the cost of
         living for the next five years? */
gen ProbRealIncUp_`year'              =HP004
gen ProbRealIncUp_Dk_`year'           =0
replace ProbRealIncUp_Dk_`year'       =1 if HP004==998		 
 
/* 	Now ask about bequests (including property and valuables) */
gen ProbBeqMoreThan10k_`year'         =HP005
gen ProbBeqMoreThan10k_Dk_`year'      =0
replace ProbBeqMoreThan10k_Dk_`year'=1 if HP005==998

gen ProbBeqMoreThan100k_`year'        =HP006
gen ProbBeqMoreThan100k_Dk_`year'     =0
replace ProbBeqMoreThan100k_Dk_`year' =1 if HP006==998

gen ProbBeqMoreThan500k_`year'        =HP059
gen ProbBeqMoreThan500k_Dk_`year'     =0
replace ProbBeqMoreThan500k_Dk_`year' =1 if HP059==998

gen ProbBeqAny_`year'                 =HP007
gen ProbBeqAny_Dk_`year'              =0
replace ProbBeqAny_Dk_`year'          =1 if HP007==998

/* What are the chances that you  [or your]   [you/husband/wife/partner]  will receive
   an inheritance during the next 10 years? */
gen ProbRecInher_`year'               =HP008
gen ProbRecInher_Dk_`year'            =0
replace ProbRecInher_Dk_`year'        =1 if HP008==998

/* How large do you expect the inheritence to be? */
gen SizeInher_`year'                  =HP010
gen SizeInher_Dk_`year'               =0
replace SizeInher_Dk_`year'           =1 if HP013==98 /* Using HP013 since recorded after binning */
gen SizeInherPointEst_`year'          =0
replace SizeInherPointEst_`year'      =1 if HP010<99999998
gen double SizeInher_minval           =HP011
gen double SizeInher_maxval           =HP012

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
gen CantDoProbs_`year'                =HP009

/*  Probability you lose job you want to keep. Only applies to households still working
    and not self-employed: J020=1 and J021~=2 */
gen ProbLoseJob_`year'                =HP014

/*  Probability you find "equally good job (as the one you had) in same line of work?
    Again, only for employed, those answering MP014. */
gen ProbFindJob_`year'                =HP015

/*  What is chance work for pay in the future? Only applies if not working (J020~=1)  */
gen ProbWorkforPay_`year'             =HP016
gen ProbWorkforPay_Dk_`year'          =0
replace ProbWorkforPay_Dk_`year'      =1 if HP016==998

/*  What is probability R will be working at 62? Only applies if less than 62 and HP016~=0 */
gen ProbWorkPost62_`year'             =HP017
gen ProbWorkPost62_Dk_`year'          =0
/*  Captures Dk to main question, then to the 0% and 100% follow up questions */
replace ProbWorkPost62_Dk_`year'      =1 if HP017==998

/*  What is probability R will be working at 65? Only applies if older than 62 and less than 65 and J021==1 */
gen ProbWorkPost65_`year'             =HP018
gen ProbWorkPost65_Dk_`year'          =0
replace ProbWorkPost65_Dk_`year'      =1 if HP018==998

/* Probability health will limit work activity in next 10 years */
gen HealthLimitWork_`year'            =HP019
gen HealthLimitWork_Dk_`year'         =0
replace HealthLimitWork_Dk_`year'     =1 if HP019==998

/* Only applies if J505 or J517 is equal to one (is looking for a job) */
gen ProbFindJobFewMonths_`year'       =HP020
gen ProbFindJobFewMonths_Dk_`year'    =0
replace ProbFindJobFewMonths_Dk_`year'=1 if HP020==998

/* Chance that R moves in next two years */
gen ProbMoveNext2yrs_`year'           =HP021
gen ProbMoveNext2yrs_Dk_`year'        =0
replace ProbMoveNext2yrs_Dk_`year'    =1 if HP021==998

/* Will R move to another state? 1=yes, 2=no */
gen MoveNewState_`year'               =HP022
gen MoveNewState_Dk_`year'            =0
replace MoveNewState_Dk_`year'        =1 if HP022==8

/* Which State? (Masked to protect anonymity). Dk has 0 observations. */
gen MoveWhichState_`year'             =HP023M

/* Do you think you will buy or build a home, rent, move in with someone else or what?
          760           1. BUY OR BUILD
          398           2. RENT
          174           3. MOVE IN WITH SOMEONE ELSE
           69           8. DK (Don't Know); NA (Not Ascertained) */
gen HomeIfMove_`year'                 =HP025
gen HomeIfMove_Dk_`year'              =0
replace HomeIfMove_Dk_`year'          =1 if HP025==8

/* With whom would you live?
           73           1. CHILD
            7           2. PARENT
           58           3. OTHER RELATIVE
           24           5. ASSISTED LIVING OR OTHER LONG TERM CARE FACILITY
            8           7. OTHER (SPECIFY)
            4           8. DK (Don't Know); NA (Not Ascertained) */
gen WhomLiveWithIfMove_`year'         =HP026
gen WhomLiveWithIfMove_Dk_`year'      =0
replace WhomLiveWithIfMove_Dk_`year'  =1 if HP026==8			
	   

/* Percent chance live to be 75 or more */
gen ProbLive75More_`year'             =HP028
gen ProbLive75More_Dk_`year'          =0
replace ProbLive75More_Dk_`year'      =1 if HP028==998
			
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
        
/* What is the percent chance that you will live to be [85/80/90/95/100] or more?
         80 (IF AGE IS 65-69)
         85 (IF AGE IS 70-74)
         90 (IF AGE IS 75-79)
         95 (IF AGE IS 80-84)
         100 (IF AGE IS 85-89) */		 
gen ProbLiveToVarious_`year'          =HP029
gen ProbLiveToVarious_Dk_`year'       =0
replace ProbLiveToVarious_Dk_`year'   =1 if HP029==998

gen ProbLiveTo80_`year'=0
replace ProbLiveTo80_`year'=1 if HAGE<=69 & ProbLiveToVarious_`year'~=.
gen ProbLiveTo85_`year'=0
replace ProbLiveTo85_`year'=1 if (HAGE>=70 & HAGE<=74 & ProbLiveToVarious_`year'~=.)
gen ProbLiveTo90_`year'=0
replace ProbLiveTo90_`year'=1 if HAGE>=75 & HAGE<=79 & ProbLiveToVarious_`year'~=.
gen ProbLiveTo95_`year'=0
replace ProbLiveTo95_`year'=1 if HAGE>=80 & HAGE<=84 & ProbLiveToVarious_`year'~=.
gen ProbLiveTo100_`year'=0
replace ProbLiveTo100_`year'=1 if HAGE>=85 & HAGE<=89 & ProbLiveToVarious_`year'~=.

/* Chances give $5k in financial help to grown children, family, or friends? */
gen GiveFinHelp5k_`year'              =HP030
gen GiveFinHelp5k_Dk_`year'           =0
replace GiveFinHelp5k_Dk_`year'       =1 if HP030==998

/* Chances receive $5k in financial help from grown children, family, or friends? */
gen RecFinHelp5k_`year'               =HP031
gen RecFinHelp5k_Dk_`year'            =0
replace RecFinHelp5k_Dk_`year'        =1 if HP031==998

/* What is chance will have to move to a nursuing home ever (in next 5 years)?
   If age<65, question is ever. If age>=65, question is in next 5 years. */
gen ProbMoveToNH_`year'               =HP032
gen ProbMoveToNH_Dk_`year'            =0
replace ProbMoveToNH_Dk_`year'        =1 if HP032==998
gen NH5years_`year'                   =0
replace NH5years_`year'               =1 if HAGE>=65
gen NHEver_`year'                     =0
replace NHEver_`year'                 =1 if HAGE<65

/* Probability US has economic depression in next 10 years */
gen ProbUSEconDep_`year'              =HP034
gen ProbUSEconDep_Dk_`year'           =0
replace ProbUSEconDep_Dk_`year'       =1 if HP034==998

/* Probability congress changes social security to be less generous in next
   10 years. */
gen SSChangeLessGenerous_`year'       =HP035
gen SSChangeLessGenerous_Dk_`year'    =0
replace SSChangeLessGenerous_Dk_`year'=1 if HP035==998

/* In deciding how much of their  family) income to spend or save, people are likely to think about
   different financial planning periods. In planning your (family's) saving and spending, which of
   the following time periods is most important to you (and your (husband/wife/partner)), the next
   few months, the next year, the next few years, the next 5-10 years, or longer than 10 years? */
gen     FinPlanPerFewMonths_`year'    =0
gen     FinPlanPerOneYr_`year'        =0
gen     FinPlanPerFewYrs_`year'       =0
gen     FinPlanPerFiveTenYrs_`year'   =0
gen     FinPlanPerMoreTenYrs_`year'   =0
replace FinPlanPerFewMonths_`year'    =1 if HP041==1
replace FinPlanPerOneYr_`year'        =1 if HP041==2
replace FinPlanPerFewYrs_`year'       =1 if HP041==3
replace FinPlanPerFiveTenYrs_`year'   =1 if HP041==4
replace FinPlanPerMoreTenYrs_`year'   =1 if HP041==5

gen FinPlanCat_`year'=HP041

/* Will children have higher, lower, same standard of living at your age? */
gen     ChildBetterOff_`year'         =0
gen     ChildWorseOff_`year'          =0
gen     ChildSameOff_`year'           =0
replace ChildBetterOff_`year'         =1 if HP042==1
replace ChildWorseOff_`year'          =1 if HP042==2
replace ChildSameOff_`year'           =1 if HP042==3

/* Follow up about "much" better or worse off. 1=yes, 0=no. */
gen     ChildMuchBetter_`year'        =0
replace ChildMuchBetter_`year'        =1 if HP043==1
gen     ChildMuchWorse_`year'         =0
replace ChildMuchWorse_`year'         =1 if HP044==1
						
/* Chance that mutual fund shares invested in blue chip stocks worth more next year.
   Reason for the "replace" line is because of error by HRS, see question HP047 for details. */
gen ProbMarketUp_`year'               =HP047
replace ProbMarketUp_`year'           =HP050 if HP047==.
gen ProbMarketUp_Dk_`year'            =0
replace ProbMarketUp_Dk_`year'        =1 if HP047==998

/* Chance that mutual fund shares invested in blue chip stocks worth 10% more next year
   Reason for the "replace" line is because of error by HRS, see question HP047 for details. */
gen ProbMarketUp10perc_`year'         =HP048
replace ProbMarketUp10perc_`year'     =HP049 if HP048==.
gen ProbMarketUp10perc_Dk_`year'      =0
replace ProbMarketUp10perc_Dk_`year'  =1 if HP048==998

/* How much-if any-have the events of September 11 shaken your own personal sense of safety
   and security: have they shaken it a great deal, a good amount, not too much, or not at all?
         2869           1. A GREAT DEAL
         3782           2. A GOOD AMOUNT
         6514           3. NOT TOO MUCH
         2741           4. NOT AT ALL
          142           8. DK (Don't Know)*/
gen PersSafety911_`year'              =HP051
gen PersSafety911_Dk_`year'           =0
replace PersSafety911_Dk_`year'       =1 if HP051==8

/* What do you think is the percent chance that there will be a major incident of bio-terrorism
   in the United States in the next five years, directly affecting 100 people or more? */
gen BioTerror_`year'                  =HP052
gen BioTerror_Dk_`year'               =0
replace BioTerror_Dk_`year'           =1 if HP052==998

/* Bio terrorism more or less than 1/1000?
           415          1. LESS THAN ONE IN ONE THOUSAND
           21           2. [VOL:] ABOUT EQUAL TO ONE IN ONE THOUSAND
           42           3. MORE THAN ONE IN ONE THOUSAND
           25           8. DK (Don't Know) */
gen BioTerrorOneTenthPerc_`year'      =HP053
gen BioTerrorOneTenthPerc_Dk_`year'   =0
replace BioTerrorOneTenthPerc_Dk_`year'=1 if HP053==8

/* What do you think is the percent chance that you, yourself will be a victim of
   bioterrorism in the next five years? */
gen SelfBioTerror_`year'              =HP054
gen SelfBioTerror_Dk_`year'           =0
replace SelfBioTerror_Dk_`year'       =1 if HP054==8

/* Would you say the chance is less or more than one in one million?
          3250          1. LESS THAN ONE IN ONE MILLION
          258           2. [VOL:] ABOUT EQUAL TO ONE IN ONE MILLION
          515           3. MORE THAN ONE IN ONE MILLION
          164           8. DK (Don't Know)*/
gen SelfBioTerrorOneMil_`year'        =HP055 
gen SelfBioTerrorOneMil_Dk_`year'     =0
replace SelfBioTerrorOneMil_Dk_`year' =1 if HP055==8

/* Did you get help filling out this section */
gen     NoExpHelp_`year'              =0
gen     SomeExpHelp_`year'            =0
gen     LotExpHelp_`year'             =0
gen     ProxyExpHelp_`year'           =0
replace NoExpHelp_`year'              =1 if HP056==1
replace SomeExpHelp_`year'            =1 if HP056==2
replace LotExpHelp_`year'             =1 if HP056==3
replace ProxyExpHelp_`year'           =1 if HP056==4

/*************************************************************************
					RISK AVERSION QUESTIONS
*************************************************************************/

/******* Income Gambles *************/
/* Income gamble: choose between guaranteed lifetime income (current) or 50-50 gamble that
   lifetime income would double or be cut by one-third. 1=first job, 2=second. */
gen IncGambleOneThird_`year'           =HP036
gen IncGambleOneThird_Dk_`year'        =0
replace IncGambleOneThird_Dk_`year'    =1 if HP036==8

/* Income gamble: If YES to HP036, choose between guaranteed lifetime income (current) or 50-50 gamble that
   lifetime income would double or be cut by one-half. 1=first job, 2=second. */
gen IncGambleOneHalf_`year'            =HP037
gen IncGambleOneHalf_Dk_`year'         =0
replace IncGambleOneHalf_Dk_`year'     =1 if HP037==8

/* Income gamble: If YES to HP037, choose between guaranteed lifetime income (current) or 50-50 gamble that
   lifetime income would double or be cut by 75%. 1=first job, 2=second. */
gen IncGamble75perc_`year'             =HP038
gen IncGamble75perc_Dk_`year'          =0
replace IncGamble75perc_Dk_`year'      =1 if HP038==8

/* Income gamble: If NO to HP036, choose between guaranteed lifetime income (current) or 50-50 gamble that
   lifetime income would double or be cut by 20%. 1=first job, 2=second. */
gen IncGambleOneFifth_`year'           =HP039
gen IncGambleOneFifth_Dk_`year'        =0
replace IncGambleOneFifth_Dk_`year'    =1 if HP039==8

/* Income gamble: If NO to HP039, choose between guaranteed lifetime income (current) or 50-50 gamble that
   lifetime income would double or be cut by 10%. 1=first job, 2=second. */
gen IncGambleOneTenth_`year'           =HP040
gen IncGambleOneTenth_Dk_`year'        =0
replace IncGambleOneTenth_Dk_`year'    =1 if HP040==8

/* Now I create a categorical variable for which bin the respondent ends up in:
   Will go from most risk averse to least. So we have the following:
   Bin 1: answer 1 to HP040
   Bin 2: answer 2 to HP040 but 1 to HP039
   Bin 3: answer 2 to HP039 but 1 to HP036
   Bin 4: answer 2 to HP036 but 1 to HP037
   Bin 5: answer 2 to HP037 but 1 to HP038
   Bin 6: answer 2 to HP038 */
   
gen IncRAbin_`year' =0
replace IncRAbin_`year' =1 if HP040==1
replace IncRAbin_`year' =2 if HP040==2 & HP039==1
replace IncRAbin_`year' =3 if HP039==2 & HP036==1
replace IncRAbin_`year' =4 if HP036==2 & HP037==1
replace IncRAbin_`year' =5 if HP037==2 & HP038==1
replace IncRAbin_`year' =6 if HP038==2 

/******* Business Gambles *************/

/* Now I have another kind of question. Suppose that a distant relative left you a
         share in a private business worth one million dollars. You are immediately faced
         with a choice -- whether to cash out now and take the one million dollars, or to
         wait until the company goes public in one month, which would give you a 50-50
         chance of doubling your money to two million dollars and a 50-50 chance of
         losing one-third of it, leaving you 667 thousand dollars.
   Would you cash out immediately or wait until after the company goes public?.
         1=cash out, 2=wait. */
gen BusGambleOneThird_`year'           =HP060
gen BusGambleOneThird_Dk_`year'        =0
replace BusGambleOneThird_Dk_`year'    =1 if HP060==8

/* Business gamble: If WAIT to HP060, choose between cash outor 50-50 gamble that
   business value would double or be cut by one-half. 1=cash out, 2=wait. */
gen BusGambleOneHalf_`year'            =HP061
gen BusGambleOneHalf_Dk_`year'         =0
replace BusGambleOneHalf_Dk_`year'     =1 if HP061==8

/* Business gamble: If WAIT to HP061, choose between cash outor 50-50 gamble that
   business value would double or be cut by 75%. 1=cash out, 2=wait. */
gen BusGamble75perc_`year'             =HP062
gen BusGamble75perc_Dk_`year'          =0
replace BusGamble75perc_Dk_`year'      =1 if HP062==8

/* Business gamble: If CASH OUT to HP060, choose between cash outor 50-50 gamble that
   business value would double or be cut by 20%. 1=cash out, 2=wait. */
gen BusGambleOneFifth_`year'           =HP063
gen BusGambleOneFifth_Dk_`year'        =0
replace BusGambleOneFifth_Dk_`year'    =1 if HP063==8

/* Business gamble: If CASH OUT to HP063, choose between cash outor 50-50 gamble that
   business value would double or be cut by 10%. 1=cash out, 2=wait. */
gen BusGambleOneTenth_`year'           =HP064
gen BusGambleOneTenth_Dk_`year'        =0
replace BusGambleOneTenth_Dk_`year'    =1 if HP064==8

/* Now I create a categorical variable for which bin the respondent ends up in:
   Will go from most risk averse to least. So we have the following:
   Bin 1: answer 1 to HP064
   Bin 2: answer 2 to HP064 but 1 to HP063
   Bin 3: answer 2 to HP063 but 1 to HP060
   Bin 4: answer 2 to HP060 but 1 to HP061
   Bin 5: answer 2 to HP061 but 1 to HP062
   Bin 6: answer 2 to HP062 */
   
gen BusRAbin_`year' =0
replace BusRAbin_`year' =1 if HP064==1
replace BusRAbin_`year' =2 if HP064==2 & HP063==1
replace BusRAbin_`year' =3 if HP063==2 & HP060==1
replace BusRAbin_`year' =4 if HP060==2 & HP061==1
replace BusRAbin_`year' =5 if HP061==2 & HP062==1
replace BusRAbin_`year' =6 if HP062==2 

/******* Inheritence Gambles *************/
/* Now I have another kind of question. Suppose that you unexpectedly inherited one
         million dollars from a distant relative. You are immediately faced with the
         opportunity to take a one-time risky, but possibly rewarding investment option
         that has a 50-50 chance of doubling the money to two million dollars within a
         month and a 50-50 chance of reducing the money by one-third, to 667 thousand
         dollars, within a month.
   Would you take the risky investment option or not?
         1=yes, 5=no. */
gen InherGambleOneThird_`year'           =HP065
gen InherGambleOneThird_Dk_`year'        =0
replace InherGambleOneThird_Dk_`year'    =1 if HP065==8

/* Inheritence gamble: If YES to HP065, choose between cash out or 50-50 gamble that
   Inheritence value would double or be cut by one-half. 1=yes, 5=no. */
gen InherGambleOneHalf_`year'            =HP066
gen InherGambleOneHalf_Dk_`year'         =0
replace InherGambleOneHalf_Dk_`year'     =1 if HP066==8

/* Inheritence gamble: If YES to HP066, choose between cash out or 50-50 gamble that
   Inheritence value would double or be cut by 75%. 1=yes, 5=no. */
gen InherGamble75perc_`year'             =HP067
gen InherGamble75perc_Dk_`year'          =0
replace InherGamble75perc_Dk_`year'      =1 if HP067==8

/* Inheritence gamble: If NO to HP065, choose between cash out or 50-50 gamble that
   Inheritence value would double or be cut by 20%. 1=yes, 5=no. */
gen InherGambleOneFifth_`year'           =HP068
gen InherGambleOneFifth_Dk_`year'        =0
replace InherGambleOneFifth_Dk_`year'    =1 if HP068==8

/* Inheritence gamble: If NO to HP068, choose between cash out or 50-50 gamble that
   Inheritence value would double or be cut by 10%. 1=yes, 5=no. */
gen InherGambleOneTenth_`year'           =HP069
gen InherGambleOneTenth_Dk_`year'        =0
replace InherGambleOneTenth_Dk_`year'    =1 if HP069==8

/* Now I create a categorical variable for which bin the respondent ends up in:
   Will go from most risk averse to least. So we have the following:
   Bin 1: answer 1 to HP069
   Bin 2: answer 2 to HP069 but 1 to HP068
   Bin 3: answer 2 to HP068 but 1 to HP065
   Bin 4: answer 2 to HP065 but 1 to HP066
   Bin 5: answer 2 to HP066 but 1 to HP067
   Bin 6: answer 2 to HP067 */
   
gen InherRAbin_`year' =0
replace InherRAbin_`year' =1 if HP069==5
replace InherRAbin_`year' =2 if HP069==1 & HP068==5
replace InherRAbin_`year' =3 if HP068==1 & HP065==5
replace InherRAbin_`year' =4 if HP065==1 & HP066==5
replace InherRAbin_`year' =5 if HP066==1 & HP067==5
replace InherRAbin_`year' =6 if HP067==1 


gen ProbDoubleDigitInf_`year'=.
gen FollowMarket_`year'=.

keep HHID PN ProbMarketUp_`year' ProbUSEconDep_`year' ProbDoubleDigitInf_`year' FollowMarket_`year' FinPlanCat_`year' IncRAbin_`year' InherRAbin_`year' BusRAbin_`year'

save "$CleanData/HRSExp`year'.dta", replace
