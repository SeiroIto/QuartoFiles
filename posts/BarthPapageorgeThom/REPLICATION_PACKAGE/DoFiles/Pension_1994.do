/***********************************************************************************************************************************************************
															CURRENT JOB (SECTION FA)
***********************************************************************************************************************************************************/
clear all
infile using "$HRSSurveys94/h94sta/W2FA.dct" , using("$HRSSurveys94/h94da/W2FA.da")
local year "1994"
gen YEAR=`year'
sort HHID CSUBHH
gen SUBHH=CSUBHH

local flag=0
local impute_numobs=0

/****************************************************************************
 Job change since last wave or no?
****************************************************************************/ 
gen SameEmployer_`year' =.
replace SameEmployer_`year'=1 if W3458==1
replace SameEmployer_`year'=0 if W3458==5

/****************************************************************************
                                  PENSIONS
****************************************************************************/

/****************************************************************************
                         IF CHANGED JOBS ONLY
****************************************************************************/

/****************************************************************************
                         PREVIOUS JOB PENIONS
****************************************************************************/
gen PrevEmpPens_`year'=0
replace PrevEmpPens_`year'=1 if W3421==1
replace PrevEmpPens_`year'=. if W3421==8 | W3421==9


/***************************************
PENSION 1 (If Self-employed!)
***************************************/
gen PrevEmpdbPlan_1_`year'=0
replace PrevEmpdbPlan_1_`year'=1 if W3422==1 | W3422==3
replace PrevEmpdbPlan_1_`year'=. if W3422==8 | W3422==9

gen PrevEmpdcPlan_1_`year'=0
replace PrevEmpdcPlan_1_`year'=1 if W3422==2 | W3422==3
replace PrevEmpdcPlan_1_`year'=. if W3422==8 | W3422==9

gen double PrevPlanAmt_1_`year'=0
replace    PrevPlanAmt_1_`year'=W3453 if W3453~=. 

gen double PrevPlanAmt_1_dkRf_`year'=0
replace PrevPlanAmt_1_dkRf_`year'=1 if PrevPlanAmt_1_`year'>9999994
replace PrevPlanAmt_1_`year'=. if PrevPlanAmt_1_dkRf_`year'==1

gen double PrevPlanAmt_1_PointEst_`year'=0
replace PrevPlanAmt_1_PointEst_`year'=1 if PrevPlanAmt_1_`year'~=.

/***************************************
PENSION 2 (Changed jobs)
***************************************/
replace PrevEmpdbPlan_1_`year'=1 if W3572==1 | W3572==3
replace PrevEmpdbPlan_1_`year'=. if W3572==8 | W3572==9

replace PrevEmpdcPlan_1_`year'=1 if W3422==2 | W3422==3
replace PrevEmpdcPlan_1_`year'=. if W3422==8 | W3422==9

replace    PrevPlanAmt_1_`year'=W3603 if W3603~=. 
replace PrevPlanAmt_1_dkRf_`year'=1 if PrevPlanAmt_1_`year'>9999994
replace PrevPlanAmt_1_`year'=. if PrevPlanAmt_1_dkRf_`year'==1
replace PrevPlanAmt_1_PointEst_`year'=1 if PrevPlanAmt_1_`year'~=.

/****************************************************************************
                          CURRENT JOB PENSIONS
****************************************************************************/
gen     NumPen_`year'=0
replace NumPen_`year'=W3711 if W3711~=.
replace NumPen_`year'=.     if W3711==98 | W3711==99

gen     HasPen_`year'=0
replace HasPen_`year'=1     if NumPen_`year'>0
replace HasPen_`year'=.     if NumPen_`year'==.

/***************************************
  PENSION AT CURRENT JOB #1
***************************************/
gen PlanType_1_`year'=W3712		 
		 
* If dcordbPlan=1, then dc, if 0 then db
gen     HasdcPlan_1_`year'=0
replace HasdcPlan_1_`year'=1 if W3712==2 | W3712==3
replace HasdcPlan_1_`year'=. if W3712>=8 & W3712~=.

gen     HasdbPlan_1_`year'=0
replace HasdbPlan_1_`year'=1 if W3712==1 | W3712==3
replace HasdbPlan_1_`year'=. if W3712>=8 & W3712~=.
 
/***************************************************
 This is plan amount for type a&b account, the (dc) part only
***************************************************/
gen PlanAmt_1_`year'    =     0
replace PlanAmt_1_`year'=     W3713 if W3713~=.
replace PlanAmt_1_`year'=.           if W3713>=9999994
gen PlanAmt_aandb_1_dkRf_`year'=0
replace PlanAmt_aandb_1_dkRf_`year'=1 if PlanAmt_1_`year'==.
gen PlanAmt_aandb_1_PointEst_`year'=0
replace PlanAmt_aandb_1_PointEst_`year'=1 if PlanAmt_aandb_1_dkRf_`year'==0

/***************************************************
 This is plan amount for type b plan (dc) only
***************************************************/
replace PlanAmt_1_`year'=     W3723 if W3723~=.
replace PlanAmt_1_`year'=.           if W3723>=9999994
gen PlanAmt_1_dkRf_`year'=0
replace PlanAmt_1_dkRf_`year'=1 if PlanAmt_1_`year'==.
gen PlanAmt_1_PointEst_`year'=0
replace PlanAmt_1_PointEst_`year'=1 if PlanAmt_1_dkRf_`year'==0

/***************************************
PENSION AT CURRENT JOB #2
***************************************/
gen PlanType_2_`year'=W3724		 
		 
* If dcordbPlan=1, then dc, if 0 then db
gen     HasdcPlan_2_`year'=0
replace HasdcPlan_2_`year'=1 if W3724==2 | W3724==3
replace HasdcPlan_2_`year'=. if W3724>=8 & W3724~=.

gen     HasdbPlan_2_`year'=0
replace HasdbPlan_2_`year'=1 if W3724==1 | W3724==3
replace HasdbPlan_2_`year'=. if W3724>=8 & W3724~=.
 
/***************************************************
 This is plan amount for type a&b account, the (dc) part only
***************************************************/
gen PlanAmt_2_`year'    =     0
replace PlanAmt_2_`year'=     W3725 if W3725~=.
replace PlanAmt_2_`year'=.           if W3725>=9999994
gen PlanAmt_aandb_2_dkRf_`year'=0
replace PlanAmt_aandb_2_dkRf_`year'=1 if PlanAmt_2_`year'==.
gen PlanAmt_aandb_2_PointEst_`year'=0
replace PlanAmt_aandb_2_PointEst_`year'=1 if PlanAmt_aandb_2_dkRf_`year'==0

/***************************************************
 This is plan amount for type b plan (dc) only
***************************************************/
replace PlanAmt_2_`year'=     W3735 if W3735~=.
replace PlanAmt_2_`year'=.           if W3735>=9999994
gen PlanAmt_2_dkRf_`year'=0
replace PlanAmt_2_dkRf_`year'=1 if PlanAmt_2_`year'==.
gen PlanAmt_2_PointEst_`year'=0
replace PlanAmt_2_PointEst_`year'=1 if PlanAmt_2_dkRf_`year'==0

/***************************************
PENSION AT CURRENT JOB #3
***************************************/
gen PlanType_3_`year'=W3736		 
		 
* If dcordbPlan=1, then dc, if 0 then db
gen     HasdcPlan_3_`year'=0
replace HasdcPlan_3_`year'=1 if W3736==2 | W3736==3
replace HasdcPlan_3_`year'=. if W3736>=8 & W3736~=.

gen     HasdbPlan_3_`year'=0
replace HasdbPlan_3_`year'=1 if W3736==1 | W3736==3
replace HasdbPlan_3_`year'=. if W3736>=8 & W3736~=.
 
/***************************************************
 This is plan amount for type a&b account, the (dc) part only
***************************************************/
gen PlanAmt_3_`year'    =     0
replace PlanAmt_3_`year'=     W3737 if W3737~=.
replace PlanAmt_3_`year'=.           if W3737>=9999994
gen PlanAmt_aandb_3_dkRf_`year'=0
replace PlanAmt_aandb_3_dkRf_`year'=1 if PlanAmt_3_`year'==.
gen PlanAmt_aandb_3_PointEst_`year'=0
replace PlanAmt_aandb_3_PointEst_`year'=1 if PlanAmt_aandb_3_dkRf_`year'==0

/***************************************************
 This is plan amount for type b plan (dc) only
***************************************************/
replace PlanAmt_3_`year'=     W3747 if W3747~=.
replace PlanAmt_3_`year'=.           if W3747>=9999994
gen PlanAmt_3_dkRf_`year'=0
replace PlanAmt_3_dkRf_`year'=1 if PlanAmt_3_`year'==.
gen PlanAmt_3_PointEst_`year'=0
replace PlanAmt_3_PointEst_`year'=1 if PlanAmt_3_dkRf_`year'==0

/****************************************************************************
                          IF DIDN'T CHANGE JOBS
****************************************************************************/

/****************************************************************************
                          CURRENT JOB PENSIONS
****************************************************************************/
replace NumPen_`year'=W3755 if W3755~=.
replace NumPen_`year'=.     if W3755==97 | W3755==98 | W3755==99

replace HasPen_`year'=1     if NumPen_`year'>0
replace HasPen_`year'=.     if NumPen_`year'==.

/***************************************
  PENSION AT CURRENT JOB #1
***************************************/ 
* If dcordbPlan=1, then dc, if 0 then db
replace HasdcPlan_1_`year'=1 if W3756==2 | W3756==3
replace HasdcPlan_1_`year'=. if W3756>=8 & W3756~=.

replace HasdbPlan_1_`year'=1 if W3756==1 | W3756==3
replace HasdbPlan_1_`year'=. if W3756>=8 & W3756~=.

/***************************************************
 This is plan amount for type a&b account, the (dc) part only
***************************************************/
replace PlanAmt_1_`year'=     W3757 if W3757~=.
replace PlanAmt_1_`year'=.           if W3757>=9999994
replace PlanAmt_aandb_1_dkRf_`year'=1 if PlanAmt_1_`year'==.
replace PlanAmt_aandb_1_PointEst_`year'=1 if PlanAmt_aandb_1_dkRf_`year'==0

/***************************************************
 This is plan amount for type b plan (dc) only
***************************************************/
replace PlanAmt_1_`year'=     W3797 if W3797~=.
replace PlanAmt_1_`year'=.           if W3797>=9999994
replace PlanAmt_1_dkRf_`year'=1 if PlanAmt_1_`year'==.
replace PlanAmt_1_PointEst_`year'=1 if PlanAmt_1_dkRf_`year'==0

/***********************************************************
 This is plan stock allocation for type b account (dc) only
***********************************************************/
gen PlanPctStocks_1_`year'=0
replace PlanPctStocks_1_`year'= 1 if W3799==1
replace PlanPctStocks_1_`year'=.5 if W3799==3
replace PlanPctStocks_1_`year'=.  if W3799==8 | W3799==9
gen PlanPctStocks_1_dkRF_`year'=0
replace PlanPctStocks_1_dkRF_`year'=1 if W3799==7 | W3799==8 | W3799==9
gen PPS_1_PointEst_`year'=0
replace PPS_1_PointEst_`year'=1 if PlanPctStocks_1_dkRF_`year'==0

/***************************************
PENSION AT CURRENT JOB #2
***************************************/
* If dcordbPlan=1, then dc, if 0 then db
replace HasdcPlan_2_`year'=1 if W3808==2 | W3808==3
replace HasdcPlan_2_`year'=. if W3808>=8 & W3808~=.

replace HasdbPlan_2_`year'=1 if W3808==1 | W3808==3
replace HasdbPlan_2_`year'=. if W3808>=8 & W3808~=.

/***************************************************
 This is plan amount for type a&b account, the (dc) part only
***************************************************/
replace PlanAmt_2_`year'=     W3809 if W3809~=.
replace PlanAmt_2_`year'=.           if W3809>=9999994
replace PlanAmt_aandb_2_dkRf_`year'=1 if PlanAmt_2_`year'==.
replace PlanAmt_aandb_2_PointEst_`year'=1 if PlanAmt_aandb_2_dkRf_`year'==0

/***************************************************
 This is plan amount for type b plan (dc) only
***************************************************/
replace PlanAmt_2_`year'=     W3849 if W3849~=.
replace PlanAmt_2_`year'=.           if W3849>=9999994
replace PlanAmt_2_dkRf_`year'=1 if PlanAmt_2_`year'==.
replace PlanAmt_2_PointEst_`year'=1 if PlanAmt_2_dkRf_`year'==0

/***********************************************************
 This is plan stock allocation for type b account (dc) only
***********************************************************/
gen PlanPctStocks_2_`year'=0
replace PlanPctStocks_2_`year'= 1 if W3851==1
replace PlanPctStocks_2_`year'=.5 if W3851==3
replace PlanPctStocks_2_`year'=.  if W3851==8 | W3851==9
gen PlanPctStocks_2_dkRF_`year'=0
replace PlanPctStocks_2_dkRF_`year'=1 if W3851==7 | W3851==8 | W3851==9
gen PPS_2_PointEst_`year'=0
replace PPS_2_PointEst_`year'=1 if PlanPctStocks_2_dkRF_`year'==0

/***************************************
PENSION AT CURRENT JOB #3
***************************************/
* If dcordbPlan=1, then dc, if 0 then db
replace HasdcPlan_3_`year'=1 if W3860==2 | W3860==3
replace HasdcPlan_3_`year'=. if W3860>=8 & W3860~=.

replace HasdbPlan_3_`year'=1 if W3860==1 | W3860==3
replace HasdbPlan_3_`year'=. if W3860>=8 & W3860~=.

/***************************************************
 This is plan amount for type a&b account, the (dc) part only
***************************************************/
replace PlanAmt_3_`year'=     W3861 if W3861~=.
replace PlanAmt_3_`year'=.           if W3861>=9999994
replace PlanAmt_aandb_3_dkRf_`year'=1 if PlanAmt_3_`year'==.
replace PlanAmt_aandb_3_PointEst_`year'=1 if PlanAmt_aandb_3_dkRf_`year'==0

/***************************************************
 This is plan amount for type b plan (dc) only
***************************************************/
replace PlanAmt_3_`year'=     W3901 if W3901~=.
replace PlanAmt_3_`year'=.           if W3901>=9999994
replace PlanAmt_3_dkRf_`year'=1 if PlanAmt_3_`year'==.
replace PlanAmt_3_PointEst_`year'=1 if PlanAmt_3_dkRf_`year'==0


/***********************************************************
 This is plan stock allocation for type b account (dc) only
***********************************************************/
gen PlanPctStocks_3_`year'=0
replace PlanPctStocks_3_`year'= 1 if W3903==1
replace PlanPctStocks_3_`year'=.5 if W3903==3
replace PlanPctStocks_3_`year'=.  if W3903==8 | W3903==9
gen PlanPctStocks_3_dkRF_`year'=0
replace PlanPctStocks_3_dkRF_`year'=1 if W3903==7 | W3903==8 | W3903==9
gen PPS_3_PointEst_`year'=0
replace PPS_3_PointEst_`year'=1 if PlanPctStocks_3_dkRF_`year'==0

/***************************************
PENSION aT cURRENT JOb "Other Plans"
***************************************/
gen OtrPlanAmt_`year'=0
replace OtrPlanAmt_`year'=W3912 if W3912~=.
replace OtrPlanAmt_`year'=. if W3912>=9999994

/****************************************************************************
       AGGREGATES
****************************************************************************/
gen TotPrevPenAmt_`year' = PrevPlanAmt_1_`year' 

gen TotcurrPenAmt_`year' = PlanAmt_1_`year' + PlanAmt_2_`year' + PlanAmt_3_`year' 

gen TotAllPenAmt_`year'  = TotPrevPenAmt_`year' + TotcurrPenAmt_`year'


gen PlanStockDoll_`year' =     (PlanPctStocks_1_`year'/100)*PlanAmt_1_`year'                                     + ///
							                 (PlanPctStocks_2_`year'/100)*PlanAmt_2_`year'                                     + ///
							                 (PlanPctStocks_3_`year'/100)*PlanAmt_3_`year'                                     
							   
gen     PlanStockTotPct_`year'=0
replace PlanStockTotPct_`year'=PlanStockDoll_`year'/TotAllPenAmt_`year' if TotAllPenAmt_`year'>0 

gen     HasDB_`year'=0
replace HasDB_`year'=1 if HasdbPlan_1_`year'==1     | HasdbPlan_2_`year'==1     | HasdbPlan_3_`year'==1  | PrevEmpdbPlan_1_`year'==1 

gen     HasDC_`year'=0
replace HasDC_`year'=1 if HasdcPlan_1_`year'==1     | HasdcPlan_2_`year'==1     | HasdcPlan_3_`year'==1 |  PrevEmpdcPlan_1_`year'==1 


keep HHID SUBHH PN HasDB_`year' HasDC_`year' TotAllPenAmt_`year' PlanStockDoll_`year' PrevEmpPens_`year'					  
save "$CleanData/Pension`year'.dta", replace
