/***********************************************************************************************************************************************************
															cURRENT JOb (SEcTION J)
***********************************************************************************************************************************************************/
clear all
infile using "$HRSSurveys92/h92sta/EMPLOYER.dct" , using("$HRSSurveys92/h92da/EMPLOYER.da")
local year "1992"
gen YEAR=`year'
sort HHID ASUBHH
gen SUBHH=ASUBHH
*merge HHID GSUBHH using "$cleandata/HRSFinRandUnfold_2000.dta" /* merge w/ random assignment data */
*keep if _merge==3  /* all obs should be matched */

/* The following code is for testing purposes. It keeps one observation per household so that we can
compare the number of observations generated vs. the number stated in the codebook: */

sort HHID SUBHH /*GFINR*/
by HHID SUBHH: gen double mynH=_n
*drop if mynH>1 /*& GFINR>3*/

local flag=0
local impute_numobs=0

*** No job change Q in 1992 since it is first wave ***

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
replace PrevEmpPens_`year'=1 if V3448==1
replace PrevEmpPens_`year'=. if V3448==8 | V3448==9

/* XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
Note: This is from the Last Job section
   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX */
/***************************************
PENSION 1 (If Self-employed!)
***************************************/
gen PrevEmpdbPlan_1_`year'=0
replace PrevEmpdbPlan_1_`year'=1 if V3501==1 | V3501==3
replace PrevEmpdbPlan_1_`year'=. if V3501==8 | V3501==9

gen PrevEmpdcPlan_1_`year'=0
replace PrevEmpdcPlan_1_`year'=1 if V3501==2 | V3501==3
replace PrevEmpdcPlan_1_`year'=. if V3501==8 | V3501==9

gen double PrevPlanAmt_1_`year'=0
replace    PrevPlanAmt_1_`year'=V3525 if V3525~=. 

gen double PrevPlanAmt_1_dkRf_`year'=0
replace PrevPlanAmt_1_dkRf_`year'=1 if PrevPlanAmt_1_`year'<9999996
replace PrevPlanAmt_1_`year'=. if PrevPlanAmt_1_dkRf_`year'==1

gen double PrevPlanAmt_1_PointEst_`year'=0
replace PrevPlanAmt_1_PointEst_`year'=1 if PrevPlanAmt_1_`year'~=.


/* XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
Note: This is from the Job History section
   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX */
/***************************************
PENSION 2
***************************************/
gen PrevEmpdbPlan_2_`year'=0
replace PrevEmpdbPlan_2_`year'=1 if V3621==1 | V3621==3
replace PrevEmpdbPlan_2_`year'=. if V3621==8 | V3621==9

gen PrevEmpdcPlan_2_`year'=0
replace PrevEmpdcPlan_2_`year'=1 if V3621==2 | V3621==3
replace PrevEmpdcPlan_2_`year'=. if V3621==8 | V3621==9

gen double PrevPlanAmt_2_`year'=0
replace    PrevPlanAmt_2_`year'=V3645 if V3645~=. 

gen double PrevPlanAmt_2_dkRf_`year'=0
replace PrevPlanAmt_2_dkRf_`year'=1 if PrevPlanAmt_2_`year'>=9999996
replace PrevPlanAmt_2_`year'=. if PrevPlanAmt_2_dkRf_`year'==1

gen double PrevPlanAmt_2_PointEst_`year'=0
replace PrevPlanAmt_2_PointEst_`year'=1 if PrevPlanAmt_2_`year'~=.


/* XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
Note: This is from the Job History section
   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX */
/***************************************
PENSION 3
***************************************/
gen PrevEmpdbPlan_3_`year'=0
replace PrevEmpdbPlan_3_`year'=1 if V3708==1 | V3708==3
replace PrevEmpdbPlan_3_`year'=. if V3708==8 | V3708==9

gen PrevEmpdcPlan_3_`year'=0
replace PrevEmpdcPlan_3_`year'=1 if V3708==2 | V3708==3
replace PrevEmpdcPlan_3_`year'=. if V3708==8 | V3708==9

gen double PrevPlanAmt_3_`year'=0
replace    PrevPlanAmt_3_`year'=V3732 if V3732~=. 

gen double PrevPlanAmt_3_dkRf_`year'=0
replace PrevPlanAmt_3_dkRf_`year'=1 if PrevPlanAmt_3_`year'>=9999996
replace PrevPlanAmt_3_`year'=. if PrevPlanAmt_3_dkRf_`year'==1

gen double PrevPlanAmt_3_PointEst_`year'=0
replace PrevPlanAmt_3_PointEst_`year'=1 if PrevPlanAmt_3_`year'~=.





/****************************************************************************
                          CURRENT JOB PENSIONS
****************************************************************************/



/***************************************
  PENSION aT cURRENT JOb #1
***************************************/
		 


/***************************************
PENSION aT cURRENT JOb #2
***************************************/



/***************************************
PENSION aT cURRENT JOb #3
***************************************/






/****************************************************************************
/****************************************************************************
/****************************************************************************
                   IF DIDN'T CHANGE JOBS I THINK?
****************************************************************************/
****************************************************************************/						 
****************************************************************************/

/****************************************************************************
                          CURRENT JOB PENSIONS
****************************************************************************/
gen     NumPen_`year'=0
replace NumPen_`year'=V2908 if V2908~=.
replace NumPen_`year'=.     if V2908==98 | V2908==99

gen     HasPen_`year'=0
replace HasPen_`year'=1     if NumPen_`year'>0
replace HasPen_`year'=.     if NumPen_`year'==.


/***************************************
  PENSION aT cURRENT JOb #1
***************************************/ 
		 
gen PlanType_1_`year'=V2909		 
		 
* If dcordbPlan=1, then dc, if 0 then db
gen     HasdcPlan_1_`year'=0
replace HasdcPlan_1_`year'=1 if V2909==2 | V2909==3
replace HasdcPlan_1_`year'=. if V2909>=8 & V2909~=.

gen     HasdbPlan_1_`year'=0
replace HasdbPlan_1_`year'=1 if V2909==1 | V2909==3
replace HasdbPlan_1_`year'=. if V2909>=8 & V2909~=.

/***************************************************
 This is plan amount for type b plan (dc) only
***************************************************/
gen PlanAmt_1_`year'    =     0
replace PlanAmt_1_`year'=     V2940 if V2940~=.
replace PlanAmt_1_`year'=.           if V2940<9999996
gen PlanAmt_aandb_1_dkRf_`year'=0
replace PlanAmt_aandb_1_dkRf_`year'=1 if PlanAmt_1_`year'==.
gen PlanAmt_aandb_1_PointEst_`year'=0
replace PlanAmt_aandb_1_PointEst_`year'=1 if PlanAmt_aandb_1_dkRf_`year'==0

/***********************************************************
 This is plan stock allocation for type b account (dc) only
***********************************************************/
gen PlanPctStocks_1_`year'=0
replace PlanPctStocks_1_`year'= 1 if V2942==1
replace PlanPctStocks_1_`year'=.5 if V2942==3
replace PlanPctStocks_1_`year'=.  if V2942==8 | V2942==9
gen PlanPctStocks_1_dkRF_`year'=0
replace PlanPctStocks_1_dkRF_`year'=1 if V2942==7 | V2942==8 | V2942==9
gen PPS_1_PointEst_`year'=0
replace PPS_1_PointEst_`year'=1 if PlanPctStocks_1_dkRF_`year'==0


/***************************************
PENSION aT cURRENT JOb #2
***************************************/
gen PlanType_2_`year'=3009		 
		 
* If dcordbPlan=1, then dc, if 0 then db
gen     HasdcPlan_2_`year'=0
replace HasdcPlan_2_`year'=1 if 3009==2 | 3009==3
replace HasdcPlan_2_`year'=. if 3009>=8 & 3009~=.

gen     HasdbPlan_2_`year'=0
replace HasdbPlan_2_`year'=1 if 3009==1 | 3009==3
replace HasdbPlan_2_`year'=. if 3009>=8 & 3009~=.
 
/***************************************************
 This is plan amount for type b plan (dc) only
***************************************************/
gen PlanAmt_2_`year'    =     0
replace PlanAmt_2_`year'=     V3040 if V3040~=.
replace PlanAmt_2_`year'=.           if V3040<9999996
gen PlanAmt_aandb_2_dkRf_`year'=0
replace PlanAmt_aandb_2_dkRf_`year'=1 if PlanAmt_2_`year'==.
gen PlanAmt_aandb_2_PointEst_`year'=0
replace PlanAmt_aandb_2_PointEst_`year'=1 if PlanAmt_aandb_2_dkRf_`year'==0

/***********************************************************
 This is plan stock allocation for type b account (dc) only
***********************************************************/
gen PlanPctStocks_2_`year'=0
replace PlanPctStocks_2_`year'= 1 if V3042==1
replace PlanPctStocks_2_`year'=.5 if V3042==3
replace PlanPctStocks_2_`year'=.  if V3042==8 | V3042==9
gen PlanPctStocks_2_dkRF_`year'=0
replace PlanPctStocks_2_dkRF_`year'=1 if V3042==7 | V3042==8 | V3042==9
gen PPS_2_PointEst_`year'=0
replace PPS_2_PointEst_`year'=1 if PlanPctStocks_2_dkRF_`year'==0


/***************************************
PENSION aT cURRENT JOb #3
***************************************/
gen PlanType_3_`year'=3109		 
		 
* If dcordbPlan=1, then dc, if 0 then db
gen     HasdcPlan_3_`year'=0
replace HasdcPlan_3_`year'=1 if V3109==2 | V3109==3
replace HasdcPlan_3_`year'=. if V3109>=8 & V3109~=.

gen     HasdbPlan_3_`year'=0
replace HasdbPlan_3_`year'=1 if V3109==1 | V3109==3
replace HasdbPlan_3_`year'=. if V3109>=8 & V3109~=.
 
/***************************************************
 This is plan amount for type b plan (dc) only
***************************************************/
gen PlanAmt_3_`year'    =     0
replace PlanAmt_3_`year'=     V3140 if V3140~=.
replace PlanAmt_3_`year'=.           if V3140<9999996
gen PlanAmt_aandb_3_dkRf_`year'=0
replace PlanAmt_aandb_3_dkRf_`year'=1 if PlanAmt_3_`year'==.
gen PlanAmt_aandb_3_PointEst_`year'=0
replace PlanAmt_aandb_3_PointEst_`year'=1 if PlanAmt_aandb_3_dkRf_`year'==0

/***********************************************************
 This is plan stock allocation for type b account (dc) only
***********************************************************/
gen PlanPctStocks_3_`year'=0
replace PlanPctStocks_3_`year'= 1 if V3142==1
replace PlanPctStocks_3_`year'=.5 if V3142==3
replace PlanPctStocks_3_`year'=.  if V3142==8 | V3142==9
gen PlanPctStocks_3_dkRF_`year'=0
replace PlanPctStocks_3_dkRF_`year'=1 if V3142==7 | V3142==8 | V3142==9
gen PPS_3_PointEst_`year'=0
replace PPS_3_PointEst_`year'=1 if PlanPctStocks_3_dkRF_`year'==0


/***************************************
PENSION aT cURRENT JOb "Other Plans"
***************************************/
gen OtrPlanAmt_`year'=0
replace OtrPlanAmt_`year'=V3151 if V3151~=.
replace OtrPlanAmt_`year'=. if V3151<9999996




/****************************************************************************
       aGGREGaTES
****************************************************************************/
gen TotPrevPenAmt_`year' = PrevPlanAmt_1_`year' + PrevPlanAmt_2_`year' + PrevPlanAmt_3_`year'

gen TotcurrPenAmt_`year' = /*PlanAmt_1_`year' + PlanAmt_2_`year' + PlanAmt_3_`year' + PlanAmt_4_`year' /*+ OtrPlanAmt_`year'*/ */ ///
                           PlanAmt_1_`year' + PlanAmt_2_`year' + PlanAmt_3_`year' 

*gen TotdormPenAmt_`year' = dormPlanAmt_1_`year' + dormPlanAmt_2_`year' + dormPlanAmt_3_`year' + dormPlanAmt_4_`year' 

gen TotAllPenAmt_`year'  = TotPrevPenAmt_`year' + TotcurrPenAmt_`year'


gen PlanStockDoll_`year' =     (PlanPctStocks_1_`year'/100)*PlanAmt_1_`year'                                     + ///
							   (PlanPctStocks_2_`year'/100)*PlanAmt_2_`year'                                     + ///
							   (PlanPctStocks_3_`year'/100)*PlanAmt_3_`year'                                     
							   
gen     PlanStockTotPct_`year'=0
replace PlanStockTotPct_`year'=PlanStockDoll_`year'/TotAllPenAmt_`year' if TotAllPenAmt_`year'>0 

gen     HasDB_`year'=0
replace HasDB_`year'=1 if HasdbPlan_1_`year'==1     | HasdbPlan_2_`year'==1     | HasdbPlan_3_`year'==1 ///
                        | PrevEmpdbPlan_1_`year'==1 | PrevEmpdbPlan_2_`year'==1 | PrevEmpdbPlan_3_`year' 

gen     HasDC_`year'=0
replace HasDC_`year'=1 if HasdcPlan_1_`year'==1     | HasdcPlan_2_`year'==1     | HasdcPlan_3_`year'==1 ///
                        | PrevEmpdcPlan_1_`year'==1 | PrevEmpdcPlan_2_`year'==1 | PrevEmpdcPlan_3_`year' 


keep HHID SUBHH PN HasDB_`year' HasDC_`year' TotAllPenAmt_`year' PlanStockDoll_`year' PrevEmpPens_`year'
save "$CleanData/Pension`year'.dta", replace
