/***********************************************************************************************************************************************************
															cURRENT JOb (SEcTION J)
***********************************************************************************************************************************************************/
clear all
infile using "$HRSSurveys98/h98sta/H98G_R.dct" , using("$HRSSurveys98/h98da/H98G_R.da")
local year "1998"
gen YEAR=`year'
sort HHID FSUBHH
gen SUBHH=FSUBHH
*merge HHID GSUBHH using "$cleandata/HRSFinRandUnfold_2000.dta" /* merge w/ random assignment data */
*keep if _merge==3  /* all obs should be matched */

/* The following code is for testing purposes. It keeps one observation per household so that we can
compare the number of observations generated vs. the number stated in the codebook: */

sort HHID SUBHH /*GFINR*/
by HHID SUBHH: gen double mynH=_n
*drop if mynH>1 /*& GFINR>3*/

local flag=0
local impute_numobs=0

/****************************************************************************
 Job change since last wave or no?
****************************************************************************/ 
/*       according to our records, in [PREV WaVE FIRST R IW MONTH]/[/Prev Wave Iw
         Mo][Previous Wave First R Interview Year]/[Prev Wave Iw Yr] you were [working
         for [PREV WaVE EMPLOYER NaME]/also working for someone else].
                 
         are you still working there?
         
         If there has been merger and acquisition use code 3 or 4
         
         If no previous wave employer name appears and R had more than one job, we are
         interested in Rs main job

         .................................................................................
          2734           1.  YES
            86           3.  YES, bUT OWNERSHIP HaS cHaNGEd (VOL)
             3           4.  NO, OWNERSHIP HaS cHaNGEd (VOL)
           367           5.  NO
             6           7.  dENIES WORKING (FOR NaMEd EMPLOYER)
             2           8.  dK (don't Know); Na (Not ascertained)
                         9.  RF (Refused)
         18836       blank.  INaP (Inapplicable); Partial Interview */
gen SameEmployer_`year' =.
replace SameEmployer_`year'=1 if F3166==1
replace SameEmployer_`year'=0 if F3166==5

/****************************************************************************
****************************************************************************
****************************************************************************
****************************************************************************
                                  PENSIONS
****************************************************************************
****************************************************************************	   
****************************************************************************	  
****************************************************************************/

/* SOME NOTES:
everyone gets asked 848 and 849
if participating, go to 885
if not participating, and if same employer aNd had participated last wave, go to 854, then 888
if not participating  and if last wave not participated and plans offered, get asked 325, 326, 850-852, 328, 908, 327, 330-334
then get asked about whether new plan is offered, 855, 856 if participate in new plan
then everyone gets asked 335 (and 336 if necessary)
then to current pension block loop 858 and onward */




/****************************************************************************
/****************************************************************************
/****************************************************************************
                         IF cHaNGEd JObS ONLY
****************************************************************************/
****************************************************************************/						 
****************************************************************************/


/****************************************************************************
                         PREVIOUS JOB PENIONS
****************************************************************************/
gen PrevEmpPens_`year'=0
replace PrevEmpPens_`year'=1 if F3202==1
replace PrevEmpPens_`year'=. if F3202==8 | F3202==9


/***************************************
PENSION 1
***************************************/
gen PrevEmpdbPlan_1_`year'=0
replace PrevEmpdbPlan_1_`year'=1 if F3203==1 | F3203==3
replace PrevEmpdbPlan_1_`year'=. if F3203==8 | F3203==9

gen PrevEmpdcPlan_1_`year'=0
replace PrevEmpdcPlan_1_`year'=1 if F3203==2 | F3203==3
replace PrevEmpdcPlan_1_`year'=. if F3203==8 | F3203==9

gen double PrevPlanAmt_1_`year'=0
replace    PrevPlanAmt_1_`year'=F3206 if F3206~=.
replace    PrevPlanAmt_1_`year'=.       if F3206==99999998 | F3206==99999999 

quietly sum PrevPlanAmt_1_`year' if PrevPlanAmt_1_`year'<=99999998, det
local MaxPrevPlanAmt=r(max)

gen double PrevPlanAmt_1_dkRf_`year'=0
replace PrevPlanAmt_1_dkRf_`year'=1 if PrevPlanAmt_1_`year'==99999998 | PrevPlanAmt_1_`year'==99999999
replace PrevPlanAmt_1_`year'=. if PrevPlanAmt_1_dkRf_`year'==1

gen double PrevPlanAmt_1_PointEst_`year'=0
replace PrevPlanAmt_1_PointEst_`year'=1 if PrevPlanAmt_1_`year'~=.

/*
/***************************************
PENSION 2 (for Type A & B accounts)
***************************************/
gen PrevEmpdbPlan_2_`year'=0
replace PrevEmpdbPlan_2_`year'=1 if G3455_2==1 | G3455_2==3
replace PrevEmpdbPlan_2_`year'=. if G3455_2==8 | G3455_2==9

gen PrevEmpdcPlan_2_`year'=0
replace PrevEmpdcPlan_2_`year'=1 if G3455_2==2 | G3455_2==3
replace PrevEmpdcPlan_2_`year'=. if G3455_2==8 | G3455_2==9

gen double PrevPlanAmt_2_`year'=0
replace    PrevPlanAmt_2_`year'=G3458_2 if G3458_2~=.
replace    PrevPlanAmt_2_`year'=.       if G3458_2==99999998 | G3458_2==99999999 

quietly sum PrevPlanAmt_2_`year' if PrevPlanAmt_2_`year'<=99999998, det
local MaxPrevPlanAmt=r(max)

gen double PrevPlanAmt_2_dkRf_`year'=0
replace PrevPlanAmt_2_dkRf_`year'=1 if PrevPlanAmt_2_`year'==99999998 | PrevPlanAmt_2_`year'==99999999
replace PrevPlanAmt_2_`year'=. if PrevPlanAmt_2_dkRf_`year'==1

gen double PrevPlanAmt_2_PointEst_`year'=0
replace PrevPlanAmt_2_PointEst_`year'=1 if PrevPlanAmt_2_`year'~=.


/***************************************
PENSION 3 (for Type A & B accounts)
***************************************/
gen PrevEmpdbPlan_3_`year'=0
replace PrevEmpdbPlan_3_`year'=1 if G3455_3==1 | G3455_3==3
replace PrevEmpdbPlan_3_`year'=. if G3455_3==8 | G3455_3==9

gen PrevEmpdcPlan_3_`year'=0
replace PrevEmpdcPlan_3_`year'=1 if G3455_3==2 | G3455_3==3
replace PrevEmpdcPlan_3_`year'=. if G3455_3==8 | G3455_3==9

gen double PrevPlanAmt_3_`year'=0
replace    PrevPlanAmt_3_`year'=G3458_3 if G3458_3~=.
replace    PrevPlanAmt_3_`year'=.       if G3458_3==99999998 | G3458_3==99999999 

quietly sum PrevPlanAmt_3_`year' if PrevPlanAmt_3_`year'<=99999998, det
local MaxPrevPlanAmt=r(max)

gen double PrevPlanAmt_3_dkRf_`year'=0
replace PrevPlanAmt_3_dkRf_`year'=1 if PrevPlanAmt_3_`year'==99999998 | PrevPlanAmt_3_`year'==99999999
replace PrevPlanAmt_3_`year'=. if PrevPlanAmt_3_dkRf_`year'==1

gen double PrevPlanAmt_3_PointEst_`year'=0
replace PrevPlanAmt_3_PointEst_`year'=1 if PrevPlanAmt_3_`year'~=.


/***************************************
PENSION 4 (for Type A & B accounts)
***************************************/
gen PrevEmpdbPlan_4_`year'=0
replace PrevEmpdbPlan_4_`year'=1 if G3455_4==1 | G3455_4==3
replace PrevEmpdbPlan_4_`year'=. if G3455_4==8 | G3455_4==9

gen PrevEmpdcPlan_4_`year'=0
replace PrevEmpdcPlan_4_`year'=1 if G3455_4==2 | G3455_4==3
replace PrevEmpdcPlan_4_`year'=. if G3455_4==8 | G3455_4==9

gen double PrevPlanAmt_4_`year'=0
replace    PrevPlanAmt_4_`year'=G3458_4 if G3458_4~=.
replace    PrevPlanAmt_4_`year'=.       if G3458_4==99999998 | G3458_4==99999999 

quietly sum PrevPlanAmt_4_`year' if PrevPlanAmt_4_`year'<=99999998, det
local MaxPrevPlanAmt=r(max)

gen double PrevPlanAmt_4_dkRf_`year'=0
replace PrevPlanAmt_4_dkRf_`year'=1 if PrevPlanAmt_4_`year'==99999998 | PrevPlanAmt_4_`year'==99999999
replace PrevPlanAmt_4_`year'=. if PrevPlanAmt_4_dkRf_`year'==1

gen double PrevPlanAmt_4_PointEst_`year'=0
replace PrevPlanAmt_4_PointEst_`year'=1 if PrevPlanAmt_4_`year'~=.
*/

/***************************************
PENSION 1 (for B accounts)
***************************************/

*gen double PrevPlanAmt_1_`year'=0
replace    PrevPlanAmt_1_`year'=F3238 if F3238~=.
replace    PrevPlanAmt_1_`year'=.       if F3238==99999998 | F3238==99999999 

*gen double PrevPlanAmt_1_dkRf_`year'=0
replace PrevPlanAmt_1_dkRf_`year'=1 if PrevPlanAmt_1_`year'==99999998 | PrevPlanAmt_1_`year'==99999999
replace PrevPlanAmt_1_`year'=. if PrevPlanAmt_1_dkRf_`year'==1

*gen double PrevPlanAmt_1_PointEst_`year'=0
replace PrevPlanAmt_1_PointEst_`year'=1 if PrevPlanAmt_1_`year'~=.

/*
/***************************************
PENSION 2 (for B accounts)
***************************************/

*gen double PrevPlanAmt_1_`year'=0
replace    PrevPlanAmt_2_`year'=G3488_2 if G3488_2~=.
replace    PrevPlanAmt_2_`year'=.       if G3488_2==99999998 | G3488_2==99999999 

*gen double PrevPlanAmt_2_dkRf_`year'=0
replace PrevPlanAmt_2_dkRf_`year'=1 if PrevPlanAmt_2_`year'==99999998 | PrevPlanAmt_2_`year'==99999999
replace PrevPlanAmt_2_`year'=. if PrevPlanAmt_2_dkRf_`year'==1

*gen double PrevPlanAmt_2_PointEst_`year'=0
replace PrevPlanAmt_2_PointEst_`year'=1 if PrevPlanAmt_2_`year'~=.


/***************************************
PENSION 3 (for B accounts)
***************************************/

*gen double PrevPlanAmt_1_`year'=0
replace    PrevPlanAmt_3_`year'=G3488_3 if G3488_3~=.
replace    PrevPlanAmt_3_`year'=.       if G3488_3==99999998 | G3488_3==99999999 

*gen double PrevPlanAmt_1_dkRf_`year'=0
replace PrevPlanAmt_3_dkRf_`year'=1 if PrevPlanAmt_3_`year'==99999998 | PrevPlanAmt_3_`year'==99999999
replace PrevPlanAmt_3_`year'=. if PrevPlanAmt_3_dkRf_`year'==1

*gen double PrevPlanAmt_1_PointEst_`year'=0
replace PrevPlanAmt_3_PointEst_`year'=1 if PrevPlanAmt_3_`year'~=.


/***************************************
PENSION 4 (for B accounts)
***************************************/

*gen double PrevPlanAmt_1_`year'=0
replace    PrevPlanAmt_4_`year'=G3488_1 if G3488_4~=.
replace    PrevPlanAmt_4_`year'=.       if G3488_4==99999998 | G3488_1==99999999 

*gen double PrevPlanAmt_1_dkRf_`year'=0
replace PrevPlanAmt_4_dkRf_`year'=1 if PrevPlanAmt_4_`year'==99999998 | PrevPlanAmt_4_`year'==99999999
replace PrevPlanAmt_4_`year'=. if PrevPlanAmt_4_dkRf_`year'==1

*gen double PrevPlanAmt_1_PointEst_`year'=0
replace PrevPlanAmt_4_PointEst_`year'=1 if PrevPlanAmt_4_`year'~=.
*/



/****************************************************************************
                          CURRENT JOB PENSIONS
****************************************************************************/
gen     NumPen_`year'=0
replace NumPen_`year'=F3361 if F3361~=.
replace NumPen_`year'=.     if F3361==98 | F3361==99

gen     HasPen_`year'=0
replace HasPen_`year'=1     if NumPen_`year'>0
replace HasPen_`year'=.     if NumPen_`year'==.


/***************************************
  PENSION aT cURRENT JOb #1
***************************************/
		 
gen PlanType_1_`year'=F3364_1		 
		 
* If dcordbPlan=1, then dc, if 0 then db
gen     HasdcPlan_1_`year'=0
replace HasdcPlan_1_`year'=1 if F3364_1==2 | F3364_1==3
replace HasdcPlan_1_`year'=. if F3364_1>=8 & F3364_1~=.

gen     HasdbPlan_1_`year'=0
replace HasdbPlan_1_`year'=1 if F3364_1==1 | F3364_1==3
replace HasdbPlan_1_`year'=. if F3364_1>=8 & F3364_1~=.
 

/***************************************************
 This is plan amount for type a&b account, the (dc) part only
***************************************************/
gen PlanAmt_1_`year'    =     0
replace PlanAmt_1_`year'=     F3365_1 if F3365_1~=.
replace PlanAmt_1_`year'=.           if F3365_1==99999998 | F3365_1==99999999
gen PlanAmt_aandb_1_dkRf_`year'=0
replace PlanAmt_aandb_1_dkRf_`year'=1 if PlanAmt_1_`year'==.
gen PlanAmt_aandb_1_PointEst_`year'=0
replace PlanAmt_aandb_1_PointEst_`year'=1 if PlanAmt_aandb_1_dkRf_`year'==0


/***************************************************
 This is plan amount for type b plan (dc) only
***************************************************/
replace PlanAmt_1_`year'=     F3383_1 if F3383_1~=.
replace PlanAmt_1_`year'=.           if F3383_1==99999998 | F3383_1==99999999
gen PlanAmt_1_dkRf_`year'=0
replace PlanAmt_1_dkRf_`year'=1 if PlanAmt_1_`year'==.
gen PlanAmt_1_PointEst_`year'=0
replace PlanAmt_1_PointEst_`year'=1 if PlanAmt_1_dkRf_`year'==0


/***************************************
PENSION aT cURRENT JOb #2
***************************************/
gen PlanType_2_`year'=F3364_2		 
		 
* If dcordbPlan=1, then dc, if 0 then db
gen     HasdcPlan_2_`year'=0
replace HasdcPlan_2_`year'=1 if F3364_2==2 | F3364_2==3
replace HasdcPlan_2_`year'=. if F3364_2>=8 & F3364_2~=.

gen     HasdbPlan_2_`year'=0
replace HasdbPlan_2_`year'=1 if F3364_2==1 | F3364_2==3
replace HasdbPlan_2_`year'=. if F3364_2>=8 & F3364_2~=.
 

/***************************************************
 This is plan amount for type a&b account, the (dc) part only
***************************************************/
gen PlanAmt_2_`year'    =     0
replace PlanAmt_2_`year'=     F3365_2 if F3365_2~=.
replace PlanAmt_2_`year'=.           if F3365_2==99999998 | F3365_2==99999999
gen PlanAmt_aandb_2_dkRf_`year'=0
replace PlanAmt_aandb_2_dkRf_`year'=1 if PlanAmt_2_`year'==.
gen PlanAmt_aandb_2_PointEst_`year'=0
replace PlanAmt_aandb_2_PointEst_`year'=1 if PlanAmt_aandb_2_dkRf_`year'==0


/***************************************************
 This is plan amount for type b plan (dc) only
***************************************************/
replace PlanAmt_2_`year'=     F3383_2 if F3383_2~=.
replace PlanAmt_2_`year'=.           if F3383_2==99999998 | F3383_2==99999999
gen PlanAmt_2_dkRf_`year'=0
replace PlanAmt_2_dkRf_`year'=1 if PlanAmt_2_`year'==.
gen PlanAmt_2_PointEst_`year'=0
replace PlanAmt_2_PointEst_`year'=1 if PlanAmt_2_dkRf_`year'==0


/***************************************
PENSION aT cURRENT JOb #3
***************************************/
gen PlanType_3_`year'=F3364_3		 
		 
* If dcordbPlan=1, then dc, if 0 then db
gen     HasdcPlan_3_`year'=0
replace HasdcPlan_3_`year'=1 if F3364_3==2 | F3364_3==3
replace HasdcPlan_3_`year'=. if F3364_3>=8 & F3364_3~=.

gen     HasdbPlan_3_`year'=0
replace HasdbPlan_3_`year'=1 if F3364_3==1 | F3364_3==3
replace HasdbPlan_3_`year'=. if F3364_3>=8 & F3364_3~=.
 

/***************************************************
 This is plan amount for type a&b account, the (dc) part only
***************************************************/
gen PlanAmt_3_`year'    =     0
replace PlanAmt_3_`year'=     F3365_3 if F3365_3~=.
replace PlanAmt_3_`year'=.           if F3365_3==99999998 | F3365_3==99999999
gen PlanAmt_aandb_3_dkRf_`year'=0
replace PlanAmt_aandb_3_dkRf_`year'=1 if PlanAmt_3_`year'==.
gen PlanAmt_aandb_3_PointEst_`year'=0
replace PlanAmt_aandb_3_PointEst_`year'=1 if PlanAmt_aandb_3_dkRf_`year'==0


/***************************************************
 This is plan amount for type b plan (dc) only
***************************************************/
replace PlanAmt_3_`year'=     F3383_3 if F3383_3~=.
replace PlanAmt_3_`year'=.           if F3383_3==99999998 | F3383_3==99999999
gen PlanAmt_3_dkRf_`year'=0
replace PlanAmt_3_dkRf_`year'=1 if PlanAmt_3_`year'==.
gen PlanAmt_3_PointEst_`year'=0
replace PlanAmt_3_PointEst_`year'=1 if PlanAmt_3_dkRf_`year'==0





/****************************************************************************
/****************************************************************************
/****************************************************************************
                   I DO NOT KNOW WHO THE FOLLOWING APPLIES TO
****************************************************************************/
****************************************************************************/						 
****************************************************************************/

/****************************************************************************
                          CURRENT JOB PENSIONS
****************************************************************************/
*gen     NumPen_`year'=0
replace NumPen_`year'=F3398 if F3398~=.
replace NumPen_`year'=.     if F3398==98 | F3398==99

*gen     HasPen_`year'=0
replace HasPen_`year'=1     if NumPen_`year'>0
replace HasPen_`year'=.     if NumPen_`year'==.


/***************************************
  PENSION aT cURRENT JOb #1
***************************************/

/*       401-K, 403-b, 457, ESOP, IRa, SRa, (TSP) thrift/savings, stock/profit sharing,
         money purchase plans, SEP/Simple, 401a, and cash balance plans are all type b
         retirement plans
         
         Type a plans are often called 'defined benefit' plans
         Type b plans are often called 'defined contribution'
          
		  1534           1.  TYPE a (FORMULa)
          2266           2.  TYPE b (accOUNT)
           102           3.  bOTH a & b
           165           8.  dK (don't Know); Na (Not ascertained)
             9           9.  RF (Refused)
         17958       blank.  INaP (Inapplicable); Partial Interview */		 
*gen PlanType_1_`year'=G3683_1		 
		 
* If dcordbPlan=1, then dc, if 0 then db
*gen     HasdcPlan_1_`year'=0
replace HasdcPlan_1_`year'=1 if F3403_1==2 | F3403_1==3
replace HasdcPlan_1_`year'=. if F3403_1>=8 & F3403_1~=.

*gen     HasdbPlan_1_`year'=0
replace HasdbPlan_1_`year'=1 if F3403_1==1 | F3403_1==3
replace HasdbPlan_1_`year'=. if F3403_1>=8 & F3403_1~=.
 

/***************************************************
 This is plan amount for type a&b account, the (dc) part only
***************************************************/
*gen PlanAmt_1_`year'    =     0
replace PlanAmt_1_`year'=     F3404_1 if F3404_1~=.
replace PlanAmt_1_`year'=.           if F3404_1==99999998 | F3404_1==99999999
*gen PlanAmt_aandb_1_dkRf_`year'=0
replace PlanAmt_aandb_1_dkRf_`year'=1 if PlanAmt_1_`year'==.
*gen PlanAmt_aandb_1_PointEst_`year'=0
replace PlanAmt_aandb_1_PointEst_`year'=1 if PlanAmt_aandb_1_dkRf_`year'==0

**************************************************************************************************************************need to do binning for this...
/***************************************************
 This is plan amount for type b plan (dc) only
***************************************************/
replace PlanAmt_1_`year'=     F3470_1 if F3470_1~=.
replace PlanAmt_1_`year'=.           if F3470_1==99999998 | F3470_1==99999999
*gen PlanAmt_1_dkRf_`year'=0
replace PlanAmt_1_dkRf_`year'=1 if PlanAmt_1_`year'==.
*gen PlanAmt_1_PointEst_`year'=0
replace PlanAmt_1_PointEst_`year'=1 if PlanAmt_1_dkRf_`year'==0


/***********************************************************
 This is plan stock allocation for type b account (dc) only
***********************************************************/

gen PlanPctStocks_1_`year'=0
replace PlanPctStocks_1_`year'= 1 if F3472_1==1
replace PlanPctStocks_1_`year'=.5 if F3472_1==3
replace PlanPctStocks_1_`year'=.  if F3472_1==8 | F3472_1==9
gen PlanPctStocks_1_dkRF_`year'=0
replace PlanPctStocks_1_dkRF_`year'=1 if F3472_1==7 | F3472_1==8 | F3472_1==9
gen PPS_1_PointEst_`year'=0
replace PPS_1_PointEst_`year'=1 if PlanPctStocks_1_dkRF_`year'==0


/***************************************
PENSION aT cURRENT JOb #2
***************************************/
replace HasdcPlan_2_`year'=1 if F3403_2==2 | F3403_2==3
replace HasdcPlan_2_`year'=. if F3403_2>=8 & F3403_2~=.

*gen     HasdbPlan_2_`year'=0
replace HasdbPlan_2_`year'=1 if F3403_2==1 | F3403_2==3
replace HasdbPlan_2_`year'=. if F3403_2>=8 & F3403_2~=.
 

/***************************************************
 This is plan amount for type a&b account, the (dc) part only
***************************************************/
*gen PlanAmt_2_`year'    =     0
replace PlanAmt_2_`year'=     F3404_2 if F3404_2~=.
replace PlanAmt_2_`year'=.           if F3404_2==99999998 | F3404_2==99999999
*gen PlanAmt_aandb_2_dkRf_`year'=0
replace PlanAmt_aandb_2_dkRf_`year'=1 if PlanAmt_2_`year'==.
*gen PlanAmt_aandb_2_PointEst_`year'=0
replace PlanAmt_aandb_2_PointEst_`year'=1 if PlanAmt_aandb_2_dkRf_`year'==0

**************************************************************************************************************************need to do binning for this...
/***************************************************
 This is plan amount for type b plan (dc) only
***************************************************/
replace PlanAmt_2_`year'=     F3470_2 if F3470_2~=.
replace PlanAmt_2_`year'=.           if F3470_2==99999998 | F3470_2==99999999
*gen PlanAmt_2_dkRf_`year'=0
replace PlanAmt_2_dkRf_`year'=1 if PlanAmt_2_`year'==.
*gen PlanAmt_2_PointEst_`year'=0
replace PlanAmt_2_PointEst_`year'=1 if PlanAmt_2_dkRf_`year'==0


/***********************************************************
 This is plan stock allocation for type b account (dc) only
***********************************************************/

gen PlanPctStocks_2_`year'=0
replace PlanPctStocks_2_`year'= 1 if F3472_2==1
replace PlanPctStocks_2_`year'=.5 if F3472_2==3
replace PlanPctStocks_2_`year'=.  if F3472_2==8 | F3472_2==9
gen PlanPctStocks_2_dkRF_`year'=0
replace PlanPctStocks_2_dkRF_`year'=1 if F3472_2==7 | F3472_2==8 | F3472_2==9
gen PPS_2_PointEst_`year'=0
replace PPS_2_PointEst_`year'=1 if PlanPctStocks_2_dkRF_`year'==0


/***************************************
PENSION aT cURRENT JOb #3
***************************************/
replace HasdcPlan_3_`year'=1 if F3403_3==2 | F3403_3==3
replace HasdcPlan_3_`year'=. if F3403_3>=8 & F3403_3~=.

*gen     HasdbPlan_3_`year'=0
replace HasdbPlan_3_`year'=1 if F3403_3==1 | F3403_3==3
replace HasdbPlan_3_`year'=. if F3403_3>=8 & F3403_3~=.
 

/***************************************************
 This is plan amount for type a&b account, the (dc) part only
***************************************************/
*gen PlanAmt_3_`year'    =     0
replace PlanAmt_3_`year'=     F3404_3 if F3404_3~=.
replace PlanAmt_3_`year'=.           if F3404_3==99999998 | F3404_3==99999999
*gen PlanAmt_aandb_3_dkRf_`year'=0
replace PlanAmt_aandb_3_dkRf_`year'=1 if PlanAmt_3_`year'==.
*gen PlanAmt_aandb_3_PointEst_`year'=0
replace PlanAmt_aandb_3_PointEst_`year'=1 if PlanAmt_aandb_3_dkRf_`year'==0

**************************************************************************************************************************need to do binning for this...
/***************************************************
 This is plan amount for type b plan (dc) only
***************************************************/
replace PlanAmt_3_`year'=     F3470_3 if F3470_3~=.
replace PlanAmt_3_`year'=.           if F3470_3==99999998 | F3470_3==99999999
*gen PlanAmt_3_dkRf_`year'=0
replace PlanAmt_3_dkRf_`year'=1 if PlanAmt_3_`year'==.
*gen PlanAmt_3_PointEst_`year'=0
replace PlanAmt_3_PointEst_`year'=1 if PlanAmt_3_dkRf_`year'==0


/***********************************************************
 This is plan stock allocation for type b account (dc) only
***********************************************************/

gen PlanPctStocks_3_`year'=0
replace PlanPctStocks_3_`year'= 1 if F3472_3==1
replace PlanPctStocks_3_`year'=.5 if F3472_3==3
replace PlanPctStocks_3_`year'=.  if F3472_3==8 | F3472_3==9
gen PlanPctStocks_3_dkRF_`year'=0
replace PlanPctStocks_3_dkRF_`year'=1 if F3472_3==7 | F3472_3==8 | F3472_3==9
gen PPS_3_PointEst_`year'=0
replace PPS_3_PointEst_`year'=1 if PlanPctStocks_3_dkRF_`year'==0


/***************************************
PENSION aT cURRENT JOb "Other Plans"
***************************************/
gen OtrPlanAmt_`year'=0
replace OtrPlanAmt_`year'=F3482 if F3482~=.
replace OtrPlanAmt_`year'=. if F3482==99999998 | F3482==99999999




/****************************************************************************
                         PREVIOUS JOB PENIONS (From Last Job Section)
****************************************************************************/



/***************************************
PENSION 5
***************************************/
gen PrevEmpdbPlan_5_`year'=0
replace PrevEmpdbPlan_5_`year'=1 if F3203==1 | F3203==3
replace PrevEmpdbPlan_5_`year'=. if F3203==8 | F3203==9

gen PrevEmpdcPlan_5_`year'=0
replace PrevEmpdcPlan_5_`year'=1 if F3203==2 | F3203==3
replace PrevEmpdcPlan_5_`year'=. if F3203==8 | F3203==9

gen double PrevPlanAmt_5_`year'=0
replace    PrevPlanAmt_5_`year'=F3206 if F3206~=.
replace    PrevPlanAmt_5_`year'=.       if F3206==99999998 | F3206==99999999 

quietly sum PrevPlanAmt_5_`year' if PrevPlanAmt_5_`year'<=99999998, det
local MaxPrevPlanAmt=r(max)

gen double PrevPlanAmt_5_dkRf_`year'=0
replace PrevPlanAmt_5_dkRf_`year'=1 if PrevPlanAmt_5_`year'==99999998 | PrevPlanAmt_5_`year'==99999999
replace PrevPlanAmt_5_`year'=. if PrevPlanAmt_5_dkRf_`year'==1

gen double PrevPlanAmt_5_PointEst_`year'=0
replace PrevPlanAmt_5_PointEst_`year'=1 if PrevPlanAmt_5_`year'~=.

/***************************************
PENSION 1 (for B accounts)
***************************************/

*gen double PrevPlanAmt_5_`year'=0
replace    PrevPlanAmt_5_`year'=F3238 if F3238~=.
replace    PrevPlanAmt_5_`year'=.       if F3238==99999998 | F3238==99999999 

*gen double PrevPlanAmt_5_dkRf_`year'=0
replace PrevPlanAmt_5_dkRf_`year'=1 if PrevPlanAmt_5_`year'==99999998 | PrevPlanAmt_5_`year'==99999999
replace PrevPlanAmt_5_`year'=. if PrevPlanAmt_5_dkRf_`year'==1

*gen double PrevPlanAmt_5_PointEst_`year'=0
replace PrevPlanAmt_5_PointEst_`year'=1 if PrevPlanAmt_5_`year'~=.







save "$CleanData/PensionTemp`year'.dta", replace


/***************************************
 DORMANT PLANS FROM PREVIOUS JOBS
***************************************/
clear all
infile using "$HRSSurveys98/h98sta/H98J_R.dct" , using("$HRSSurveys98/h98da/H98J_R.da")
local year "1998"
gen YEAR=`year'
sort HHID FSUBHH
gen SUBHH=FSUBHH
*merge HHID GSUBHH using "$cleandata/HRSFinRandUnfold_2000.dta" /* merge w/ random assignment data */
*keep if _merge==3  /* all obs should be matched */

/* The following code is for testing purposes. It keeps one observation per household so that we can
compare the number of observations generated vs. the number stated in the codebook: */

sort HHID SUBHH /*GFINR*/
by HHID SUBHH: gen double mynH=_n
*drop if mynH>1 /*& GFINR>3*/

local flag=0
local impute_numobs=0



/*** NOTE: Only 4 dormant plans asked about, but when asked about status
           are asked to select all that apply, so HasdormPlan variable
		   has up to four possible selections for each of the four dormant
		   funds possible. ***/

gen HasdormPlan_`year'=0
/* db and dc plans */
replace HasdormPlan_`year'=1 if  F5084_1<=7 | F5084_2<=7 | F5089_1<=7 | F5089_2<=7
replace HasdormPlan_`year'=. if (F5084_1==8 | F5084_1==9) | (F5084_2==8 | F5084_2==9) | (F5089_1==8 | F5089_1==9) | (F5089_2==8 | F5089_2==9)


/***************************************
 DORMANT PENSION #1
***************************************/
gen     dormHasdcPlan_1_`year'=0
replace dormHasdcPlan_1_`year'=1 if  F5089_1<=7 | F5089_2<=7
replace dormHasdcPlan_1_`year'=. if (F5089_1==8 | F5089_1==9) | (F5089_2==8 | F5089_2==9)

gen     dormHasdbPlan_1_`year'=0
replace dormHasdbPlan_1_`year'=1 if  F5084_1<=7 | F5084_2<=7
replace dormHasdbPlan_1_`year'=. if (F5084_1==8 | F5084_1==9) | (F5084_2==8 | F5084_2==9)

gen double dormPlanAmt_1_`year'=0
replace    dormPlanAmt_1_`year'=F5090_1 if F5090_1~=.

gen double dormPlanAmt_1_dkRf_`year'=0
replace dormPlanAmt_1_dkRf_`year'=1 if dormPlanAmt_1_`year'==99999998 | dormPlanAmt_1_`year'==99999999
replace dormPlanAmt_1_`year'=. if dormPlanAmt_1_dkRf_`year'==1

gen double dormPlanAmt_1_PointEst_`year'=0
replace dormPlanAmt_1_PointEst_`year'=1 if dormPlanAmt_1_`year'~=.


/***************************************
 DORMANT PENSION #2
***************************************/
gen     dormHasdcPlan_2_`year'=0
replace dormHasdcPlan_2_`year'=1 if  F5089_2<=7 | F5089_2<=7
replace dormHasdcPlan_2_`year'=. if (F5089_2==8 | F5089_2==9) | (F5089_2==8 | F5089_2==9)

gen     dormHasdbPlan_2_`year'=0
replace dormHasdbPlan_2_`year'=1 if  F5084_2<=7 | F5084_2<=7
replace dormHasdbPlan_2_`year'=. if (F5084_2==8 | F5084_2==9) | (F5084_2==8 | F5084_2==9)

gen double dormPlanAmt_2_`year'=0
replace    dormPlanAmt_2_`year'=F5090_2 if F5090_2~=.

gen double dormPlanAmt_2_dkRf_`year'=0
replace dormPlanAmt_2_dkRf_`year'=1 if dormPlanAmt_2_`year'==99999998 | dormPlanAmt_2_`year'==99999999
replace dormPlanAmt_2_`year'=. if dormPlanAmt_2_dkRf_`year'==1

gen double dormPlanAmt_2_PointEst_`year'=0
replace dormPlanAmt_2_PointEst_`year'=1 if dormPlanAmt_2_`year'~=.


save "$CleanData/DormPension`year'.dta", replace


/****************************************************************************
       MERGE
****************************************************************************/
merge 1:1 HHID SUBHH PN using "$CleanData/PensionTemp`year'.dta"







/****************************************************************************
       aGGREGaTES
****************************************************************************/
gen TotPrevPenAmt_`year' = PrevPlanAmt_1_`year' 

gen TotcurrPenAmt_`year' = /*PlanAmt_1_`year' + PlanAmt_2_`year' + PlanAmt_3_`year' + PlanAmt_4_`year' /*+ OtrPlanAmt_`year'*/ */ ///
                           PlanAmt_1_`year' + PlanAmt_2_`year' + PlanAmt_3_`year' 

gen TotdormPenAmt_`year' = dormPlanAmt_1_`year' + dormPlanAmt_2_`year'

gen TotAllPenAmt_`year'  = TotPrevPenAmt_`year' + TotcurrPenAmt_`year'


gen PlanStockDoll_`year' =     (PlanPctStocks_1_`year'/100)*PlanAmt_1_`year'                                     + ///
							   (PlanPctStocks_2_`year'/100)*PlanAmt_2_`year'                                     + ///
							   (PlanPctStocks_3_`year'/100)*PlanAmt_3_`year'                                     
							   
gen     PlanStockTotPct_`year'=0
replace PlanStockTotPct_`year'=PlanStockDoll_`year'/TotAllPenAmt_`year' if TotAllPenAmt_`year'>0 

gen     HasDB_`year'=0
replace HasDB_`year'=1 if HasdbPlan_1_`year'==1 | HasdbPlan_2_`year'==1 | HasdbPlan_3_`year'==1 | PrevEmpdbPlan_1_`year'==1 | dormHasdbPlan_1_`year' | dormHasdbPlan_2_`year'

gen     HasDC_`year'=0
replace HasDC_`year'=1 if HasdcPlan_1_`year'==1 | HasdcPlan_2_`year'==1 | HasdcPlan_3_`year'==1 | PrevEmpdcPlan_1_`year'==1 | dormHasdcPlan_1_`year' | dormHasdcPlan_2_`year'


keep HHID SUBHH PN HasDB_`year' HasDC_`year' TotAllPenAmt_`year' PlanStockDoll_`year' PrevEmpPens_`year'						  
save "$CleanData/Pension`year'.dta", replace
