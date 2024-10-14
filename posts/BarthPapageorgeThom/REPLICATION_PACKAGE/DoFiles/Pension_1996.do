/***********************************************************************************************************************************************************
															CURRENT JOB (SECTION G)
***********************************************************************************************************************************************************/
clear all
infile using "$HRSSurveys96/h96sta/H96G_R.dct" , using("$HRSSurveys96/h96da/H96G_R.da")
local year "1996"
gen YEAR=`year'
sort HHID ESUBHH
gen SUBHH=ESUBHH

local flag=0
local impute_numobs=0

/****************************************************************************
 Job change since last wave or no?
****************************************************************************/ 
gen SameEmployer_`year' =.
replace SameEmployer_`year'=1 if E2655==1
replace SameEmployer_`year'=0 if E2655==5

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
replace PrevEmpPens_`year'=1 if E2680==1
replace PrevEmpPens_`year'=. if E2680==8 | E2680==9

/***************************************
PENSION 1
***************************************/
gen PrevEmpdbPlan_1_`year'=0
replace PrevEmpdbPlan_1_`year'=1 if E2681==1 | E2681==3
replace PrevEmpdbPlan_1_`year'=. if E2681==8 | E2681==9

gen PrevEmpdcPlan_1_`year'=0
replace PrevEmpdcPlan_1_`year'=1 if E2681==2 | E2681==3
replace PrevEmpdcPlan_1_`year'=. if E2681==8 | E2681==9

gen double PrevPlanAmt_1_`year'=0
replace    PrevPlanAmt_1_`year'=E2684 if E2684~=.

quietly sum PrevPlanAmt_1_`year' if PrevPlanAmt_1_`year'<=9999998, det
local MaxPrevPlanAmt=r(max)

gen double PrevPlanAmt_1_dkRf_`year'=0
replace PrevPlanAmt_1_dkRf_`year'=1 if PrevPlanAmt_1_`year'==9999998 | PrevPlanAmt_1_`year'==9999999
replace PrevPlanAmt_1_`year'=. if PrevPlanAmt_1_dkRf_`year'==1

gen double PrevPlanAmt_1_PointEst_`year'=0
replace PrevPlanAmt_1_PointEst_`year'=1 if PrevPlanAmt_1_`year'~=.

/***************************************
PENSION 1 (for B accounts)
***************************************/
replace    PrevPlanAmt_1_`year'=E2716 if E2716~=.
replace PrevPlanAmt_1_dkRf_`year'=1 if PrevPlanAmt_1_`year'==9999998 | PrevPlanAmt_1_`year'==9999999
replace PrevPlanAmt_1_`year'=. if PrevPlanAmt_1_dkRf_`year'==1
replace PrevPlanAmt_1_PointEst_`year'=1 if PrevPlanAmt_1_`year'~=.

/****************************************************************************
                          CURRENT JOB PENSIONS
****************************************************************************/
gen     NumPen_`year'=0
replace NumPen_`year'=E2837 if E2837~=.
replace NumPen_`year'=.     if E2837==98 | E2837==99

gen     HasPen_`year'=0
replace HasPen_`year'=1     if NumPen_`year'>0
replace HasPen_`year'=.     if NumPen_`year'==.

/***************************************
  PENSION AT CURRENT JOB #1
***************************************/
gen PlanType_1_`year'=E2840_1		 
		 
* If dcordbPlan=1, then dc, if 0 then db
gen     HasdcPlan_1_`year'=0
replace HasdcPlan_1_`year'=1 if E2840_1==2 | E2840_1==3
replace HasdcPlan_1_`year'=. if E2840_1>=8 & E2840_1~=.

gen     HasdbPlan_1_`year'=0
replace HasdbPlan_1_`year'=1 if E2840_1==1 | E2840_1==3
replace HasdbPlan_1_`year'=. if E2840_1>=8 & E2840_1~=.
 

/***************************************************
 This is plan amount for type a&b account, the (dc) part only
***************************************************/
gen PlanAmt_1_`year'    =     0
replace PlanAmt_1_`year'=     E2841_1 if E2841_1~=.
replace PlanAmt_1_`year'=.           if E2841_1==9999998 | E2841_1==9999999
gen PlanAmt_aandb_1_dkRf_`year'=0
replace PlanAmt_aandb_1_dkRf_`year'=1 if PlanAmt_1_`year'==.
gen PlanAmt_aandb_1_PointEst_`year'=0
replace PlanAmt_aandb_1_PointEst_`year'=1 if PlanAmt_aandb_1_dkRf_`year'==0


/***************************************************
 This is plan amount for type b plan (dc) only
***************************************************/
replace PlanAmt_1_`year'=     E2856_1 if E2856_1~=.
replace PlanAmt_1_`year'=.           if E2856_1==9999998 | E2856_1==9999999
gen PlanAmt_1_dkRf_`year'=0
replace PlanAmt_1_dkRf_`year'=1 if PlanAmt_1_`year'==.
gen PlanAmt_1_PointEst_`year'=0
replace PlanAmt_1_PointEst_`year'=1 if PlanAmt_1_dkRf_`year'==0


/***************************************
PENSION AT CURRENT JOB #2
***************************************/
gen PlanType_2_`year'=E2840_2		 
		 
* If dcordbPlan=1, then dc, if 0 then db
gen     HasdcPlan_2_`year'=0
replace HasdcPlan_2_`year'=1 if E2840_2==2 | E2840_2==3
replace HasdcPlan_2_`year'=. if E2840_2>=8 & E2840_2~=.

gen     HasdbPlan_2_`year'=0
replace HasdbPlan_2_`year'=1 if E2840_2==1 | E2840_2==3
replace HasdbPlan_2_`year'=. if E2840_2>=8 & E2840_2~=.
 

/***************************************************
 This is plan amount for type a&b account, the (dc) part only
***************************************************/
gen PlanAmt_2_`year'    =     0
replace PlanAmt_2_`year'=     E2841_2 if E2841_2~=.
replace PlanAmt_2_`year'=.           if E2841_2==9999998 | E2841_2==9999999
gen PlanAmt_aandb_2_dkRf_`year'=0
replace PlanAmt_aandb_2_dkRf_`year'=1 if PlanAmt_2_`year'==.
gen PlanAmt_aandb_2_PointEst_`year'=0
replace PlanAmt_aandb_2_PointEst_`year'=1 if PlanAmt_aandb_2_dkRf_`year'==0


/***************************************************
 This is plan amount for type b plan (dc) only
***************************************************/
replace PlanAmt_2_`year'=     E2856_2 if E2856_2~=.
replace PlanAmt_2_`year'=.           if E2856_2==9999998 | E2856_2==9999999
gen PlanAmt_2_dkRf_`year'=0
replace PlanAmt_2_dkRf_`year'=1 if PlanAmt_2_`year'==.
gen PlanAmt_2_PointEst_`year'=0
replace PlanAmt_2_PointEst_`year'=1 if PlanAmt_2_dkRf_`year'==0


/***************************************
PENSION AT CURRENT JOB #3
***************************************/
gen PlanType_3_`year'=E2840_3		 
		 
* If dcordbPlan=1, then dc, if 0 then db
gen     HasdcPlan_3_`year'=0
replace HasdcPlan_3_`year'=1 if E2840_3==2 | E2840_3==3
replace HasdcPlan_3_`year'=. if E2840_3>=8 & E2840_3~=.

gen     HasdbPlan_3_`year'=0
replace HasdbPlan_3_`year'=1 if E2840_3==1 | E2840_3==3
replace HasdbPlan_3_`year'=. if E2840_3>=8 & E2840_3~=.
 

/***************************************************
 This is plan amount for type a&b account, the (dc) part only
***************************************************/
gen PlanAmt_3_`year'    =     0
replace PlanAmt_3_`year'=     E2841_3 if E2841_3~=.
replace PlanAmt_3_`year'=.           if E2841_3==9999998 | E2841_3==9999999
gen PlanAmt_aandb_3_dkRf_`year'=0
replace PlanAmt_aandb_3_dkRf_`year'=1 if PlanAmt_3_`year'==.
gen PlanAmt_aandb_3_PointEst_`year'=0
replace PlanAmt_aandb_3_PointEst_`year'=1 if PlanAmt_aandb_3_dkRf_`year'==0


/***************************************************
 This is plan amount for type b plan (dc) only
***************************************************/
replace PlanAmt_3_`year'=     E2856_3 if E2856_3~=.
replace PlanAmt_3_`year'=.           if E2856_3==9999998 | E2856_3==9999999
gen PlanAmt_3_dkRf_`year'=0
replace PlanAmt_3_dkRf_`year'=1 if PlanAmt_3_`year'==.
gen PlanAmt_3_PointEst_`year'=0
replace PlanAmt_3_PointEst_`year'=1 if PlanAmt_3_dkRf_`year'==0

/****************************************************************************
                          CURRENT JOB PENSIONS
****************************************************************************/
replace NumPen_`year'=E2870 if E2870~=.
replace NumPen_`year'=.     if E2870==98 | E2870==99

replace HasPen_`year'=1     if NumPen_`year'>0
replace HasPen_`year'=.     if NumPen_`year'==.

/***************************************
  PENSION AT CURRENT JOB #1
***************************************/ 
* If dcordbPlan=1, then dc, if 0 then db
replace HasdcPlan_1_`year'=1 if E2875_1==2 | E2875_1==3
replace HasdcPlan_1_`year'=. if E2875_1>=8 & E2875_1~=.

replace HasdbPlan_1_`year'=1 if E2875_1==1 | E2875_1==3
replace HasdbPlan_1_`year'=. if E2875_1>=8 & E2875_1~=.
 

/***************************************************
 This is plan amount for type a&b account, the (dc) part only
***************************************************/
replace PlanAmt_1_`year'=     E2876_1 if E2876_1~=.
replace PlanAmt_1_`year'=.           if E2876_1==9999997 | E2876_1==9999998 | E2876_1==9999999
replace PlanAmt_aandb_1_dkRf_`year'=1 if PlanAmt_1_`year'==.
replace PlanAmt_aandb_1_PointEst_`year'=1 if PlanAmt_aandb_1_dkRf_`year'==0

/***************************************************
 This is plan amount for type b plan (dc) only
***************************************************/
replace PlanAmt_1_`year'=     E2942_1 if E2942_1~=.
replace PlanAmt_1_`year'=.           if E2942_1==9999998 | E2942_1==9999999
replace PlanAmt_1_dkRf_`year'=1 if PlanAmt_1_`year'==.
replace PlanAmt_1_PointEst_`year'=1 if PlanAmt_1_dkRf_`year'==0

/***********************************************************
 This is plan stock allocation for type b account (dc) only
***********************************************************/
gen PlanPctStocks_1_`year'=0
replace PlanPctStocks_1_`year'= 1 if E2944_1==1
replace PlanPctStocks_1_`year'=.5 if E2944_1==3
replace PlanPctStocks_1_`year'=.  if E2944_1==8 | E2944_1==9
gen PlanPctStocks_1_dkRF_`year'=0
replace PlanPctStocks_1_dkRF_`year'=1 if E2944_1==7 | E2944_1==8 | E2944_1==9
gen PPS_1_PointEst_`year'=0
replace PPS_1_PointEst_`year'=1 if PlanPctStocks_1_dkRF_`year'==0

/***************************************
PENSION AT CURRENT JOB #2
***************************************/
* If dcordbPlan=1, then dc, if 0 then db
replace HasdcPlan_2_`year'=1 if E2875_2==2 | E2875_2==3
replace HasdcPlan_2_`year'=. if E2875_2>=8 & E2875_2~=.

replace HasdbPlan_2_`year'=1 if E2875_2==1 | E2875_2==3
replace HasdbPlan_2_`year'=. if E2875_2>=8 & E2875_2~=.
 

/***************************************************
 This is plan amount for type a&b account, the (dc) part only
***************************************************/
replace PlanAmt_2_`year'=     E2876_2 if E2876_2~=.
replace PlanAmt_2_`year'=.           if E2876_2==9999997 | E2876_2==9999998 | E2876_2==9999999
replace PlanAmt_aandb_2_dkRf_`year'=1 if PlanAmt_2_`year'==.
replace PlanAmt_aandb_2_PointEst_`year'=1 if PlanAmt_aandb_2_dkRf_`year'==0

/***************************************************
 This is plan amount for type b plan (dc) only
***************************************************/
replace PlanAmt_2_`year'=     E2942_2 if E2942_2~=.
replace PlanAmt_2_`year'=.           if E2942_2==9999998 | E2942_2==9999999
replace PlanAmt_2_dkRf_`year'=1 if PlanAmt_2_`year'==.
replace PlanAmt_2_PointEst_`year'=1 if PlanAmt_2_dkRf_`year'==0

/***********************************************************
 This is plan stock allocation for type b account (dc) only
***********************************************************/
gen PlanPctStocks_2_`year'=0
replace PlanPctStocks_2_`year'= 1 if E2944_2==1
replace PlanPctStocks_2_`year'=.5 if E2944_2==3
replace PlanPctStocks_2_`year'=.  if E2944_2==8 | E2944_2==9
gen PlanPctStocks_2_dkRF_`year'=0
replace PlanPctStocks_2_dkRF_`year'=1 if E2944_2==7 | E2944_2==8 | E2944_2==9
gen PPS_2_PointEst_`year'=0
replace PPS_2_PointEst_`year'=1 if PlanPctStocks_2_dkRF_`year'==0

/***************************************
PENSION AT CURRENT JOB #3
***************************************/
* If dcordbPlan=1, then dc, if 0 then db
replace HasdcPlan_3_`year'=1 if E2875_3==2 | E2875_3==3
replace HasdcPlan_3_`year'=. if E2875_3>=8 & E2875_3~=.

replace HasdbPlan_3_`year'=1 if E2875_3==1 | E2875_3==3
replace HasdbPlan_3_`year'=. if E2875_3>=8 & E2875_3~=.
 
/***************************************************
 This is plan amount for type a&b account, the (dc) part only
***************************************************/
replace PlanAmt_3_`year'=     E2876_3 if E2876_3~=.
replace PlanAmt_3_`year'=.           if E2876_3==9999997 | E2876_3==9999998 | E2876_3==9999999
replace PlanAmt_aandb_3_dkRf_`year'=1 if PlanAmt_3_`year'==.
replace PlanAmt_aandb_3_PointEst_`year'=1 if PlanAmt_aandb_3_dkRf_`year'==0

/***************************************************
 This is plan amount for type b plan (dc) only
***************************************************/
replace PlanAmt_3_`year'=     E2942_3 if E2942_3~=.
replace PlanAmt_3_`year'=.           if E2942_3==9999998 | E2942_3==9999999
replace PlanAmt_3_dkRf_`year'=1 if PlanAmt_3_`year'==.
replace PlanAmt_3_PointEst_`year'=1 if PlanAmt_3_dkRf_`year'==0

/***********************************************************
 This is plan stock allocation for type b account (dc) only
***********************************************************/
gen PlanPctStocks_3_`year'=0
replace PlanPctStocks_3_`year'= 1 if E2944_3==1
replace PlanPctStocks_3_`year'=.5 if E2944_3==3
replace PlanPctStocks_3_`year'=.  if E2944_3==8 | E2944_3==9
gen PlanPctStocks_3_dkRF_`year'=0
replace PlanPctStocks_3_dkRF_`year'=1 if E2944_3==7 | E2944_3==8 | E2944_3==9
gen PPS_3_PointEst_`year'=0
replace PPS_3_PointEst_`year'=1 if PlanPctStocks_3_dkRF_`year'==0

/***************************************
PENSION AT CURRENT JOB "Other Plans"
***************************************/
gen OtrPlanAmt_`year'=0
replace OtrPlanAmt_`year'=E2954 if E2954~=.
replace OtrPlanAmt_`year'=. if E2954==9999998 | E2954==9999999

save "$CleanData/PensionTemp`year'.dta", replace

/***************************************
 DORMANT PLANS FROM PREVIOUS JOBS
***************************************/
clear all
infile using "$HRSSurveys96/h96sta/H96J_R.dct" , using("$HRSSurveys96/h96da/H96J_R.da")
local year "1996"
gen YEAR=`year'
sort HHID ESUBHH
gen SUBHH=ESUBHH

local flag=0
local impute_numobs=0

gen HasdormPlan_`year'=0
/* db and dc plans */
replace HasdormPlan_`year'=1 if  E4324_1<=7 | E4324_2<=7 | E4329_1<=7 | E4329_2<=7
replace HasdormPlan_`year'=. if (E4324_1==8 | E4324_1==9) | (E4324_2==8 | E4324_2==9) | (E4329_1==8 | E4329_1==9) | (E4329_2==8 | E4329_2==9)
                                
/***************************************
 DORMANT PENSION #1
***************************************/
gen     dormHasdcPlan_1_`year'=0
replace dormHasdcPlan_1_`year'=1 if  E4329_1<=7 | E4329_2<=7
replace dormHasdcPlan_1_`year'=. if (E4329_1==8 | E4329_1==9) | (E4329_2==8 | E4329_2==9)

gen     dormHasdbPlan_1_`year'=0
replace dormHasdbPlan_1_`year'=1 if  E4324_1<=7 | E4324_2<=7
replace dormHasdbPlan_1_`year'=. if (E4324_1==8 | E4324_1==9) | (E4324_2==8 | E4324_2==9)

gen double dormPlanAmt_1_`year'=0
replace    dormPlanAmt_1_`year'=E4330_1 if E4330_1~=.

gen double dormPlanAmt_1_dkRf_`year'=0
replace dormPlanAmt_1_dkRf_`year'=1 if dormPlanAmt_1_`year'==9999997 | dormPlanAmt_1_`year'==9999998 | dormPlanAmt_1_`year'==9999999
replace dormPlanAmt_1_`year'=. if dormPlanAmt_1_dkRf_`year'==1

gen double dormPlanAmt_1_PointEst_`year'=0
replace dormPlanAmt_1_PointEst_`year'=1 if dormPlanAmt_1_`year'~=.

/***************************************
 DORMANT PENSION #2
***************************************/
gen     dormHasdcPlan_2_`year'=0
replace dormHasdcPlan_2_`year'=1 if  E4329_2<=7 | E4329_2<=7
replace dormHasdcPlan_2_`year'=. if (E4329_2==8 | E4329_2==9) | (E4329_2==8 | E4329_2==9)

gen     dormHasdbPlan_2_`year'=0
replace dormHasdbPlan_2_`year'=1 if  E4324_2<=7 | E4324_2<=7
replace dormHasdbPlan_2_`year'=. if (E4324_2==8 | E4324_2==9) | (E4324_2==8 | E4324_2==9)

gen double dormPlanAmt_2_`year'=0
replace    dormPlanAmt_2_`year'=E4330_2 if E4330_2~=.

gen double dormPlanAmt_2_dkRf_`year'=0
replace dormPlanAmt_2_dkRf_`year'=1 if dormPlanAmt_2_`year'==9999997 | dormPlanAmt_2_`year'==9999998 | dormPlanAmt_2_`year'==9999999 
replace dormPlanAmt_2_`year'=. if dormPlanAmt_2_dkRf_`year'==1

gen double dormPlanAmt_2_PointEst_`year'=0
replace dormPlanAmt_2_PointEst_`year'=1 if dormPlanAmt_2_`year'~=.


save "$CleanData/DormPension`year'.dta", replace


/****************************************************************************
       MERGE
****************************************************************************/
merge 1:1 HHID SUBHH PN using "$CleanData/PensionTemp`year'.dta", assert(3) nogen

/****************************************************************************
       AGGREGATES
****************************************************************************/
gen TotPrevPenAmt_`year' = PrevPlanAmt_1_`year' 

gen TotcurrPenAmt_`year' = PlanAmt_1_`year' + PlanAmt_2_`year' + PlanAmt_3_`year' 

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
