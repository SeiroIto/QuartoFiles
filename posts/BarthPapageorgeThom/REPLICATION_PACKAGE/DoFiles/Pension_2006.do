/***********************************************************************************************************************************************************
															CURRENT JOB (SECTION J)
***********************************************************************************************************************************************************/
clear all
infile using "$HRSSurveys06/h06sta/H06J_R.dct" , using("$HRSSurveys06/h06da/H06J_R.da")
local year "2006"
gen YEAR=`year'
sort HHID KSUBHH
gen SUBHH=KSUBHH

local flag=0
local impute_numobs=0

/****************************************************************************
 Job Change since last wave or no?
****************************************************************************/ 
gen SameEmployer_`year' =.
replace SameEmployer_`year'=1 if KJ045==1 | KJ045==3
replace SameEmployer_`year'=0 if KJ045==4 | KJ045==5

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
replace PrevEmpPens_`year'=1 if KJ084==1
replace PrevEmpPens_`year'=. if KJ084==8 | KJ084==9

gen PrevEmpNumPlans_`year'=KJ085
replace PrevEmpNumPlans_`year'=. if KJ085>=95
replace PrevEmpNumPlans_`year'=1 if KJ086==1

/***************************************
PENSION 1
***************************************/
gen PrevEmpDBPlan_1_`year'=0
replace PrevEmpDBPlan_1_`year'=1 if KJW001A==1
replace PrevEmpDBPlan_1_`year'=. if KJW001A==8 | KJW001A==9

gen PrevEmpDCPlan_1_`year'=0
replace PrevEmpDCPlan_1_`year'=1 if KJW001A==2
replace PrevEmpDCPlan_1_`year'=. if KJW001A==8 | KJW001A==9

gen double PrevPlanAmt_1_`year'=0
replace    PrevPlanAmt_1_`year'=KJW009A if KJW009A~=.

quietly sum PrevPlanAmt_1_`year' if PrevPlanAmt_1_`year'<=99999998, det
local MaxPrevPlanAmt=r(max)

gen double PrevPlanAmt_1_DkRf_`year'=0
replace PrevPlanAmt_1_DkRf_`year'=1 if PrevPlanAmt_1_`year'==99999998 | PrevPlanAmt_1_`year'==99999999
replace PrevPlanAmt_1_`year'=. if PrevPlanAmt_1_DkRf_`year'==1

gen double PrevPlanAmt_1_PointEst_`year'=0
replace PrevPlanAmt_1_PointEst_`year'=1 if PrevPlanAmt_1_`year'~=.

/* # of missings is verfied by codebook. 9/25, DB */
gen double PrevPlan_1_minval=KJW010A
gen double PrevPlan_1_maxval=KJW011A

local binmin0   0
local binmin1   10001
local binmin2   20001
local binmin3   50001
local binmin4   150001
local binmax0   9999
local binmax1   19999
local binmax2   49999
local binmax3   149999
local binmax4   99999996
local binexact1 10000
local binexact2 20000
local binexact3 50000
local binexact4 150000

/* Generating exact values here */
replace PrevPlanAmt_1_`year'=`binexact1' if PrevPlan_1_minval==`binexact1' & PrevPlan_1_maxval==`binexact1'
replace PrevPlanAmt_1_`year'=`binexact2' if PrevPlan_1_minval==`binexact2' & PrevPlan_1_maxval==`binexact2'
replace PrevPlanAmt_1_`year'=`binexact3' if PrevPlan_1_minval==`binexact3' & PrevPlan_1_maxval==`binexact3'
replace PrevPlanAmt_1_`year'=`binexact4' if PrevPlan_1_minval==`binexact4' & PrevPlan_1_maxval==`binexact4'

* Generate bins
forval num=0/4{
    sum PrevPlanAmt_1_`year' if PrevPlanAmt_1_PointEst_`year'==1 & PrevPlanAmt_1_`year' > `binmin`num'' & PrevPlanAmt_1_`year' < `binmax`num'', detail
    cap assert r(N)>`impute_numobs'
    if _rc{
        replace PrevPlanAmt_1_`year'=r(p$bin_pctile) if PrevPlan_1_minval==`binmin`num'' & PrevPlan_1_maxval==`binmax`num''
    }
    else{
        replace PrevPlanAmt_1_`year'=(`binmin`num''+`binmin`num'')/2 if PrevPlan_1_minval==`binmin`num'' & PrevPlan_1_maxval==`binmax`num''
    }
}

/***************************************
PENSION 2
***************************************/
gen PrevEmpDBPlan_2_`year'=0
replace PrevEmpDBPlan_2_`year'=1 if KJW001B==1
replace PrevEmpDBPlan_2_`year'=. if KJW001B==8 | KJW001B==9

gen PrevEmpDCPlan_2_`year'=0
replace PrevEmpDCPlan_2_`year'=1 if KJW001B==2
replace PrevEmpDCPlan_2_`year'=. if KJW001B==8 | KJW001B==9

gen double PrevPlanAmt_2_`year'=0
replace    PrevPlanAmt_2_`year'=KJW009B if KJW009B~=.

quietly sum PrevPlanAmt_2_`year' if PrevPlanAmt_2_`year'<=99999998, det
local MaxPrevPlanAmt=r(max)

gen double PrevPlanAmt_2_DkRf_`year'=0
replace PrevPlanAmt_2_DkRf_`year'=1 if PrevPlanAmt_2_`year'==99999998 | PrevPlanAmt_2_`year'==99999999
replace PrevPlanAmt_2_`year'=. if PrevPlanAmt_2_DkRf_`year'==1

gen double PrevPlanAmt_2_PointEst_`year'=0
replace PrevPlanAmt_2_PointEst_`year'=1 if PrevPlanAmt_2_`year'~=.

/* # of missings is verfied by codebook. 9/25, DB */
gen double PrevPlan_2_minval=KJW010B
gen double PrevPlan_2_maxval=KJW011B

local binmin0   0
local binmin1   10001
local binmin2   20001
local binmin3   50001
local binmin4   150001
local binmax0   9999
local binmax1   19999
local binmax2   49999
local binmax3   149999
local binmax4   99999996
local binexact1 10000
local binexact2 20000
local binexact3 50000
local binexact4 150000

/* Generating exact values here */
replace PrevPlanAmt_2_`year'=`binexact1' if PrevPlan_2_minval==`binexact1' & PrevPlan_2_maxval==`binexact1'
replace PrevPlanAmt_2_`year'=`binexact2' if PrevPlan_2_minval==`binexact2' & PrevPlan_2_maxval==`binexact2'
replace PrevPlanAmt_2_`year'=`binexact3' if PrevPlan_2_minval==`binexact3' & PrevPlan_2_maxval==`binexact3'
replace PrevPlanAmt_2_`year'=`binexact4' if PrevPlan_2_minval==`binexact4' & PrevPlan_2_maxval==`binexact4'

* Generate bins
forval num=0/4{
    sum PrevPlanAmt_2_`year' if PrevPlanAmt_2_PointEst_`year'==1 & PrevPlanAmt_2_`year' > `binmin`num'' & PrevPlanAmt_2_`year' < `binmax`num'', detail
    cap assert r(N)>`impute_numobs'
    if _rc{
        replace PrevPlanAmt_2_`year'=r(p$bin_pctile) if PrevPlan_2_minval==`binmin`num'' & PrevPlan_2_maxval==`binmax`num''
    }
    else{
        replace PrevPlanAmt_2_`year'=(`binmin`num''+`binmin`num'')/2 if PrevPlan_2_minval==`binmin`num'' & PrevPlan_2_maxval==`binmax`num''
    }
}

/***************************************
PENSION 3
***************************************/
gen PrevEmpDBPlan_3_`year'=0
replace PrevEmpDBPlan_3_`year'=1 if KJW001C==1
replace PrevEmpDBPlan_3_`year'=. if KJW001C==8 | KJW001C==9

gen PrevEmpDCPlan_3_`year'=0
replace PrevEmpDCPlan_3_`year'=1 if KJW001C==2
replace PrevEmpDCPlan_3_`year'=. if KJW001C==8 | KJW001C==9

gen double PrevPlanAmt_3_`year'=0
replace    PrevPlanAmt_3_`year'=KJW009C if KJW009C~=.

quietly sum PrevPlanAmt_3_`year' if PrevPlanAmt_3_`year'<=99999998, det
local MaxPrevPlanAmt=r(max)

gen double PrevPlanAmt_3_DkRf_`year'=0
replace PrevPlanAmt_3_DkRf_`year'=1 if PrevPlanAmt_3_`year'==99999998 | PrevPlanAmt_3_`year'==99999999
replace PrevPlanAmt_3_`year'=. if PrevPlanAmt_3_DkRf_`year'==1

gen double PrevPlanAmt_3_PointEst_`year'=0
replace PrevPlanAmt_3_PointEst_`year'=1 if PrevPlanAmt_3_`year'~=.

/* # of missings is verfied by codebook. 9/25, DB */
gen double PrevPlan_3_minval=KJW010C
gen double PrevPlan_3_maxval=KJW011C

local binmin0   0
local binmin1   10001
local binmin2   20001
local binmin3   50001
local binmin4   150001
local binmax0   9999
local binmax1   19999
local binmax2   49999
local binmax3   149999
local binmax4   99999996
local binexact1 10000
local binexact2 20000
local binexact3 50000
local binexact4 150000

/* Generating exact values here */
replace PrevPlanAmt_3_`year'=`binexact1' if PrevPlan_3_minval==`binexact1' & PrevPlan_3_maxval==`binexact1'
replace PrevPlanAmt_3_`year'=`binexact2' if PrevPlan_3_minval==`binexact2' & PrevPlan_3_maxval==`binexact2'
replace PrevPlanAmt_3_`year'=`binexact3' if PrevPlan_3_minval==`binexact3' & PrevPlan_3_maxval==`binexact3'
replace PrevPlanAmt_3_`year'=`binexact4' if PrevPlan_3_minval==`binexact4' & PrevPlan_3_maxval==`binexact4'

* Generate bins
forval num=0/4{
    sum PrevPlanAmt_3_`year' if PrevPlanAmt_3_PointEst_`year'==1 & PrevPlanAmt_3_`year' > `binmin`num'' & PrevPlanAmt_3_`year' < `binmax`num'', detail
    cap assert r(N)>`impute_numobs'
    if _rc{
        replace PrevPlanAmt_3_`year'=r(p$bin_pctile) if PrevPlan_3_minval==`binmin`num'' & PrevPlan_3_maxval==`binmax`num''
    }
    else{
        replace PrevPlanAmt_3_`year'=(`binmin`num''+`binmin`num'')/2 if PrevPlan_3_minval==`binmin`num'' & PrevPlan_3_maxval==`binmax`num''
    }
}

/***************************************
PENSION 4
***************************************/
gen PrevEmpDBPlan_4_`year'=0
replace PrevEmpDBPlan_4_`year'=1 if KJW001D==1
replace PrevEmpDBPlan_4_`year'=. if KJW001D==8 | KJW001D==9

gen PrevEmpDCPlan_4_`year'=0
replace PrevEmpDCPlan_4_`year'=1 if KJW001D==2
replace PrevEmpDCPlan_4_`year'=. if KJW001D==8 | KJW001D==9

gen double PrevPlanAmt_4_`year'=0
replace    PrevPlanAmt_4_`year'=KJW009D if KJW009D~=.

quietly sum PrevPlanAmt_4_`year' if PrevPlanAmt_4_`year'<=99999998, det
local MaxPrevPlanAmt=r(max)

gen double PrevPlanAmt_4_DkRf_`year'=0
replace PrevPlanAmt_4_DkRf_`year'=1 if PrevPlanAmt_4_`year'==99999998 | PrevPlanAmt_4_`year'==99999999
replace PrevPlanAmt_4_`year'=. if PrevPlanAmt_4_DkRf_`year'==1

gen double PrevPlanAmt_4_PointEst_`year'=0
replace PrevPlanAmt_4_PointEst_`year'=1 if PrevPlanAmt_4_`year'~=.

/* No missing obs in 2006 */

/****************************************************************************
                         CURRENT JOB PENIONS
****************************************************************************/

gen     NumPen_`year'=0
replace NumPen_`year'=KJ269 if KJ269~=.
replace NumPen_`year'=.     if KJ269==98 | KJ269==99
replace NumPen_`year'=1     if KJ270==1

gen     HasPen_`year'=0
replace HasPen_`year'=1     if NumPen_`year'>0
replace HasPen_`year'=.     if NumPen_`year'==.


/***************************************
  PENSION AT CURRENT JOB #1
***************************************/
gen PlanType_1_`year'=KJ272A		 
		 
* If DCorDBPlan=1, then DC, if 0 then DB
gen     HasDCPlan_1_`year'=0
replace HasDCPlan_1_`year'=1 if KJ272A==2 | KJ272A==3
replace HasDCPlan_1_`year'=. if KJ272A>=8 & KJ272A~=.

gen     HasDBPlan_1_`year'=0
replace HasDBPlan_1_`year'=1 if KJ272A==1 | KJ272A==3
replace HasDBPlan_1_`year'=. if KJ272A>=8 & KJ272A~=.

/***************************************************
 This is plan amount for type A&B account, the (DC) part only
***************************************************/
gen PlanAmt_1_`year'    =     0
replace PlanAmt_1_`year'=     KJ273A if KJ273A~=.
replace PlanAmt_1_`year'=.           if KJ273A==-2 | KJ273A==99999998 | KJ273A==99999999
gen PlanAmt_AandB_1_DkRf_`year'=0
replace PlanAmt_AandB_1_DkRf_`year'=1 if PlanAmt_1_`year'==.
gen PlanAmt_AandB_1_PointEst_`year'=0
replace PlanAmt_AandB_1_PointEst_`year'=1 if PlanAmt_AandB_1_DkRf_`year'==0

gen double Plan_AandB_1_minval=KJ274A
gen double Plan_AandB_1_maxval=KJ275A

local binmin0   0
local binmin1   25001
local binmin2   50001
local binmin3   100001
local binmin4   250001
local binmax0   24999
local binmax1   49999
local binmax2   99999
local binmax3   249999
local binmax4   99999996
local binexact1 25000
local binexact2 50000
local binexact3 100000
local binexact4 250000

/* Generating exact values here */
replace PlanAmt_1_`year'=`binexact1' if Plan_AandB_1_minval==`binexact1' & Plan_AandB_1_maxval==`binexact1'
replace PlanAmt_1_`year'=`binexact2' if Plan_AandB_1_minval==`binexact2' & Plan_AandB_1_maxval==`binexact2'
replace PlanAmt_1_`year'=`binexact3' if Plan_AandB_1_minval==`binexact3' & Plan_AandB_1_maxval==`binexact3'
replace PlanAmt_1_`year'=`binexact4' if Plan_AandB_1_minval==`binexact4' & Plan_AandB_1_maxval==`binexact4'

* Generate bins
forval num=0/4{
    sum PlanAmt_1_`year' if PlanAmt_AandB_1_PointEst_`year'==1 & PlanAmt_1_`year' > `binmin`num'' & PlanAmt_1_`year' < `binmax`num'', detail
    cap assert r(N)>`impute_numobs'
    if _rc{
        replace PlanAmt_1_`year'=r(p$bin_pctile) if Plan_AandB_1_minval==`binmin`num'' & Plan_AandB_1_maxval==`binmax`num''
    }
    else{
        replace PlanAmt_1_`year'=(`binmin`num''+`binmin`num'')/2 if Plan_AandB_1_minval==`binmin`num'' & Plan_AandB_1_maxval==`binmax`num''
    }
}

/***************************************************
 This is plan amount for type B plan (DC) only
***************************************************/
replace PlanAmt_1_`year'=     KJ307A if KJ307A~=.
replace PlanAmt_1_`year'=.           if KJ307A==-2 | KJ307A==99999998 | KJ307A==99999999
gen PlanAmt_1_DkRf_`year'=0
replace PlanAmt_1_DkRf_`year'=1 if PlanAmt_1_`year'==.
gen PlanAmt_1_PointEst_`year'=0
replace PlanAmt_1_PointEst_`year'=1 if PlanAmt_1_DkRf_`year'==0

gen double Plan_1_minval=KJ308A
gen double Plan_1_maxval=KJ309A

local binmin0   0
local binmin1   5001
local binmin2   20001
local binmin3   50001
local binmin4   150001
local binmax0   4999
local binmax1   19999
local binmax2   49999
local binmax3   149999
local binmax4   99999996
local binexact1 5000
local binexact2 20000
local binexact3 50000
local binexact4 150000

/* Generating exact values here */
replace PlanAmt_1_`year'=`binexact1' if Plan_1_minval==`binexact1' & Plan_1_maxval==`binexact1'
replace PlanAmt_1_`year'=`binexact2' if Plan_1_minval==`binexact2' & Plan_1_maxval==`binexact2'
replace PlanAmt_1_`year'=`binexact3' if Plan_1_minval==`binexact3' & Plan_1_maxval==`binexact3'
replace PlanAmt_1_`year'=`binexact4' if Plan_1_minval==`binexact4' & Plan_1_maxval==`binexact4'

* Generate bins
forval num=0/4{
    sum PlanAmt_1_`year' if PlanAmt_1_PointEst_`year'==1 & PlanAmt_1_`year' > `binmin`num'' & PlanAmt_1_`year' < `binmax`num'', detail
    cap assert r(N)>`impute_numobs'
    if _rc{
        replace PlanAmt_1_`year'=r(p$bin_pctile) if Plan_1_minval==`binmin`num'' & Plan_1_maxval==`binmax`num''
    }
    else{
        replace PlanAmt_1_`year'=(`binmin`num''+`binmin`num'')/2 if Plan_1_minval==`binmin`num'' & Plan_1_maxval==`binmax`num''
    }
}

/***********************************************************
 This is plan stock allocation for type B account (DC) only
***********************************************************/
gen PlanPctStocks_1_`year'=0
replace PlanPctStocks_1_`year'=KJ742A if KJ742A~=. 
replace PlanPctStocks_1_`year'=. if KJ742A==998 | KJ742A==999
gen PlanPctStocks_1_DkRF_`year'=0
replace PlanPctStocks_1_DkRF_`year'=1 if KJ742A==998 | KJ742A==999
gen PlanPctStocks_1_PointEst_`year'=0
replace PlanPctStocks_1_PointEst_`year'=1 if PlanPctStocks_1_DkRF_`year'==0

gen double PctStocks_1_minval=KJ743A
gen double PctStocks_1_maxval=KJ744A

local binmin0   0
local binmin1   21
local binmin2   41
local binmin3   61
local binmin4   81
local binmax0   19
local binmax1   39
local binmax2   59
local binmax3   79
local binmax4   100
local binexact1 20
local binexact2 40
local binexact3 60
local binexact4 80

/* Generating exact values here */
replace PlanPctStocks_1_`year'=`binexact1' if PctStocks_1_minval==`binexact1' & PctStocks_1_maxval==`binexact1'
replace PlanPctStocks_1_`year'=`binexact2' if PctStocks_1_minval==`binexact2' & PctStocks_1_maxval==`binexact2'
replace PlanPctStocks_1_`year'=`binexact3' if PctStocks_1_minval==`binexact3' & PctStocks_1_maxval==`binexact3'
replace PlanPctStocks_1_`year'=`binexact4' if PctStocks_1_minval==`binexact4' & PctStocks_1_maxval==`binexact4'

* Generate bins
forval num=0/4{
    sum PlanPctStocks_1_`year' if PlanPctStocks_1_PointEst_`year'==1 & PlanPctStocks_1_`year' > `binmin`num'' & PlanPctStocks_1_`year' < `binmax`num'', detail
    cap assert r(N)>`impute_numobs'
    if _rc{
        replace PlanPctStocks_1_`year'=r(p$bin_pctile) if PctStocks_1_minval==`binmin`num'' & PctStocks_1_maxval==`binmax`num''
    }
    else{
        replace PlanPctStocks_1_`year'=(`binmin`num''+`binmin`num'')/2 if PctStocks_1_minval==`binmin`num'' & PctStocks_1_maxval==`binmax`num''
    }
}

/***********************************************************
 This is plan stock allocation IN COMPANY STOCK (DC) only
***********************************************************/
gen CompPctStocks_1_`year'=0
replace CompPctStocks_1_`year'=KJ747A if KJ747A~=.
replace CompPctStocks_1_`year'=. if KJ747A==998 | KJ747A==999
gen CompPctStocks_1_DkRF_`year'=0
replace CompPctStocks_1_DkRF_`year'=1 if KJ747A==998 | KJ747A==999
gen CompPctStocks_1_PointEst_`year'=0
replace CompPctStocks_1_PointEst_`year'=1 if CompPctStocks_1_DkRF_`year'==0

gen double CompPctStocks_1_minval=KJ748A
gen double CompPctStocks_1_maxval=KJ749A

local binmin0   0
local binmin1   21
local binmin2   41
local binmin3   61
local binmin4   81
local binmax0   19
local binmax1   39
local binmax2   59
local binmax3   79
local binmax4   100
local binexact1 20
local binexact2 40
local binexact3 60
local binexact4 80

/* Generating exact values here */
replace CompPctStocks_1_`year'=`binexact1' if CompPctStocks_1_minval==`binexact1' & CompPctStocks_1_maxval==`binexact1'
replace CompPctStocks_1_`year'=`binexact2' if CompPctStocks_1_minval==`binexact2' & CompPctStocks_1_maxval==`binexact2'
replace CompPctStocks_1_`year'=`binexact3' if CompPctStocks_1_minval==`binexact3' & CompPctStocks_1_maxval==`binexact3'

* Generate bins
forval num=0/4{
    sum CompPctStocks_1_`year' if CompPctStocks_1_PointEst_`year'==1 & CompPctStocks_1_`year' > `binmin`num'' & CompPctStocks_1_`year' < `binmax`num'', detail
    cap assert r(N)>`impute_numobs'
    if _rc{
        replace CompPctStocks_1_`year'=r(p$bin_pctile) if CompPctStocks_1_minval==`binmin`num'' & CompPctStocks_1_maxval==`binmax`num''
    }
    else{
        replace CompPctStocks_1_`year'=(`binmin`num''+`binmin`num'')/2 if CompPctStocks_1_minval==`binmin`num'' & CompPctStocks_1_maxval==`binmax`num''
    }
}

/***************************************
PENSION AT CURRENT JOB #2
***************************************/		 
gen PlanType_2_`year'=KJ272B		 
		 
* If DCorDBPlan=1, then DC, if 0 then DB
gen     HasDCPlan_2_`year'=0
replace HasDCPlan_2_`year'=1 if KJ272B==2 | KJ272B==3
replace HasDCPlan_2_`year'=. if KJ272B>=8 & KJ272B~=.

gen     HasDBPlan_2_`year'=0
replace HasDBPlan_2_`year'=1 if KJ272B==1 | KJ272B==3
replace HasDBPlan_2_`year'=. if KJ272B>=8 & KJ272B~=.
 
/***************************************************
 This is plan amount for type A&B account, the (DC) part only
***************************************************/
gen PlanAmt_2_`year'    =     0
replace PlanAmt_2_`year'=     KJ273B if KJ273B~=.
replace PlanAmt_2_`year'=.           if KJ273B==-2 | KJ273B==99999998 | KJ273B==99999999
gen PlanAmt_AandB_2_DkRf_`year'=0
replace PlanAmt_AandB_2_DkRf_`year'=1 if PlanAmt_2_`year'==.
gen PlanAmt_AandB_2_PointEst_`year'=0
replace PlanAmt_AandB_2_PointEst_`year'=1 if PlanAmt_AandB_2_DkRf_`year'==0

gen double Plan_AandB_2_minval=KJ274B
gen double Plan_AandB_2_maxval=KJ275B

local binmin0   0
local binmin1   25001
local binmin2   50001
local binmin3   100001
local binmin4   250001
local binmax0   24999
local binmax1   49999
local binmax2   99999
local binmax3   249999
local binmax4   99999996
local binexact1 25000
local binexact2 50000
local binexact3 100000
local binexact4 250000

/* Generating exact values here */
replace PlanAmt_2_`year'=`binexact1' if Plan_AandB_2_minval==`binexact1' & Plan_AandB_2_maxval==`binexact1'
replace PlanAmt_2_`year'=`binexact2' if Plan_AandB_2_minval==`binexact2' & Plan_AandB_2_maxval==`binexact2'
replace PlanAmt_2_`year'=`binexact3' if Plan_AandB_2_minval==`binexact3' & Plan_AandB_2_maxval==`binexact3'
replace PlanAmt_2_`year'=`binexact4' if Plan_AandB_2_minval==`binexact4' & Plan_AandB_2_maxval==`binexact4'

* Generate bins
forval num=0/4{
    sum PlanAmt_2_`year' if PlanAmt_AandB_2_PointEst_`year'==1 & PlanAmt_2_`year' > `binmin`num'' & PlanAmt_2_`year' < `binmax`num'', detail
    cap assert r(N)>`impute_numobs'
    if _rc{
        replace PlanAmt_2_`year'=r(p$bin_pctile) if Plan_AandB_2_minval==`binmin`num'' & Plan_AandB_2_maxval==`binmax`num''
    }
    else{
        replace PlanAmt_2_`year'=(`binmin`num''+`binmin`num'')/2 if Plan_AandB_2_minval==`binmin`num'' & Plan_AandB_2_maxval==`binmax`num''
    }
}

/***************************************************
 This is plan amount for type B plan (DC) only
***************************************************/
replace PlanAmt_2_`year'=     KJ307B if KJ307B~=.
replace PlanAmt_2_`year'=.           if KJ307B==-2 | KJ307B==99999998 | KJ307B==99999999
gen PlanAmt_2_DkRf_`year'=0
replace PlanAmt_2_DkRf_`year'=1 if PlanAmt_2_`year'==.
gen PlanAmt_2_PointEst_`year'=0
replace PlanAmt_2_PointEst_`year'=1 if PlanAmt_2_DkRf_`year'==0

gen double Plan_2_minval=KJ308B
gen double Plan_2_maxval=KJ309B

local binmin0   0
local binmin1   5001
local binmin2   20001
local binmin3   50001
local binmin4   150001
local binmax0   4999
local binmax1   19999
local binmax2   49999
local binmax3   149999
local binmax4   99999996
local binexact1 5000
local binexact2 20000
local binexact3 50000
local binexact4 150000

/* Generating exact values here */
replace PlanAmt_2_`year'=`binexact1' if Plan_2_minval==`binexact1' & Plan_2_maxval==`binexact1'
replace PlanAmt_2_`year'=`binexact2' if Plan_2_minval==`binexact2' & Plan_2_maxval==`binexact2'
replace PlanAmt_2_`year'=`binexact3' if Plan_2_minval==`binexact3' & Plan_2_maxval==`binexact3'
replace PlanAmt_2_`year'=`binexact4' if Plan_2_minval==`binexact4' & Plan_2_maxval==`binexact4'

* Generate bins
forval num=0/4{
    sum PlanAmt_2_`year' if PlanAmt_2_PointEst_`year'==1 & PlanAmt_2_`year' > `binmin`num'' & PlanAmt_2_`year' < `binmax`num'', detail
    cap assert r(N)>`impute_numobs'
    if _rc{
        replace PlanAmt_2_`year'=r(p$bin_pctile) if Plan_2_minval==`binmin`num'' & Plan_2_maxval==`binmax`num''
    }
    else{
        replace PlanAmt_2_`year'=(`binmin`num''+`binmin`num'')/2 if Plan_2_minval==`binmin`num'' & Plan_2_maxval==`binmax`num''
    }
}

/***********************************************************
 This is plan stock allocation for type B account (DC) only
***********************************************************/
gen PlanPctStocks_2_`year'=0
replace PlanPctStocks_2_`year'=KJ742B if KJ742B~=. 
replace PlanPctStocks_2_`year'=. if KJ742B==998 | KJ742B==999
gen PlanPctStocks_2_DkRF_`year'=0
replace PlanPctStocks_2_DkRF_`year'=1 if KJ742B==998 | KJ742B==999
gen PlanPctStocks_2_PointEst_`year'=0
replace PlanPctStocks_2_PointEst_`year'=1 if PlanPctStocks_2_DkRF_`year'==0

gen double PctStocks_2_minval=KJ743B
gen double PctStocks_2_maxval=KJ744B

local binmin0   0
local binmin1   21
local binmin2   41
local binmin3   61
local binmin4   81
local binmax0   19
local binmax1   39
local binmax2   59
local binmax3   79
local binmax4   100
local binexact1 20
local binexact2 40
local binexact3 60
local binexact4 80

/* Generating exact values here */
replace PlanPctStocks_2_`year'=`binexact1' if PctStocks_2_minval==`binexact1' & PctStocks_2_maxval==`binexact1'
replace PlanPctStocks_2_`year'=`binexact2' if PctStocks_2_minval==`binexact2' & PctStocks_2_maxval==`binexact2'
replace PlanPctStocks_2_`year'=`binexact3' if PctStocks_2_minval==`binexact3' & PctStocks_2_maxval==`binexact3'
replace PlanPctStocks_2_`year'=`binexact4' if PctStocks_2_minval==`binexact4' & PctStocks_2_maxval==`binexact4'

* Generate bins
forval num=0/4{
    sum PlanPctStocks_2_`year' if PlanPctStocks_2_PointEst_`year'==1 & PlanPctStocks_2_`year' > `binmin`num'' & PlanPctStocks_2_`year' < `binmax`num'', detail
    cap assert r(N)>`impute_numobs'
    if _rc{
        replace PlanPctStocks_2_`year'=r(p$bin_pctile) if PctStocks_2_minval==`binmin`num'' & PctStocks_2_maxval==`binmax`num''
    }
    else{
        replace PlanPctStocks_2_`year'=(`binmin`num''+`binmin`num'')/2 if PctStocks_2_minval==`binmin`num'' & PctStocks_2_maxval==`binmax`num''
    }
}

/***********************************************************
 This is plan stock allocation IN COMPANY STOCK (DC) only
***********************************************************/
gen CompPctStocks_2_`year'=0
replace CompPctStocks_2_`year'=KJ747B if KJ747B~=.
replace CompPctStocks_2_`year'=. if KJ747B==998 | KJ747B==999
gen CompPctStocks_2_DkRF_`year'=0
replace CompPctStocks_2_DkRF_`year'=1 if KJ747B==998 | KJ747B==999
gen CompPctStocks_2_PointEst_`year'=0
replace CompPctStocks_2_PointEst_`year'=1 if CompPctStocks_2_DkRF_`year'==0

gen double CompPctStocks_2_minval=KJ748B
gen double CompPctStocks_2_maxval=KJ749B

local binmin0   0
local binmin1   21
local binmin2   41
local binmin3   61
local binmin4   81
local binmax0   19
local binmax1   39
local binmax2   59
local binmax3   79
local binmax4   100
local binexact1 20
local binexact2 40
local binexact3 60
local binexact4 80

/* Generating exact values here */
replace CompPctStocks_2_`year'=`binexact1' if CompPctStocks_2_minval==`binexact1' & CompPctStocks_2_maxval==`binexact1'
replace CompPctStocks_2_`year'=`binexact2' if CompPctStocks_2_minval==`binexact2' & CompPctStocks_2_maxval==`binexact2'
replace CompPctStocks_2_`year'=`binexact3' if CompPctStocks_2_minval==`binexact3' & CompPctStocks_2_maxval==`binexact3'
replace CompPctStocks_2_`year'=`binexact4' if CompPctStocks_2_minval==`binexact4' & CompPctStocks_2_maxval==`binexact4'

* Generate bins
forval num=0/4{
    sum CompPctStocks_2_`year' if CompPctStocks_2_PointEst_`year'==1 & CompPctStocks_2_`year' > `binmin`num'' & CompPctStocks_2_`year' < `binmax`num'', detail
    cap assert r(N)>`impute_numobs'
    if _rc{
        replace CompPctStocks_2_`year'=r(p$bin_pctile) if CompPctStocks_2_minval==`binmin`num'' & CompPctStocks_2_maxval==`binmax`num''
    }
    else{
        replace CompPctStocks_2_`year'=(`binmin`num''+`binmin`num'')/2 if CompPctStocks_2_minval==`binmin`num'' & CompPctStocks_2_maxval==`binmax`num''
    }
}

/***************************************
PENSION AT CURRENT JOB #3
***************************************/
gen PlanType_3_`year'=KJ272C		 
		 
* If DCorDBPlan=1, then DC, if 0 then DB
gen     HasDCPlan_3_`year'=0
replace HasDCPlan_3_`year'=1 if KJ272C==2 | KJ272C==3
replace HasDCPlan_3_`year'=. if KJ272C>=8 & KJ272C~=.

gen     HasDBPlan_3_`year'=0
replace HasDBPlan_3_`year'=1 if KJ272C==1 | KJ272C==3
replace HasDBPlan_3_`year'=. if KJ272C>=8 & KJ272C~=.
 

/***************************************************
 This is plan amount for type A&B account, the (DC) part only
***************************************************/
gen PlanAmt_3_`year'    =     0
replace PlanAmt_3_`year'=     KJ273C if KJ273C~=.
replace PlanAmt_3_`year'=.           if KJ273C==-2 | KJ273C==99999998 | KJ273C==99999999
gen PlanAmt_AandB_3_DkRf_`year'=0
replace PlanAmt_AandB_3_DkRf_`year'=1 if PlanAmt_3_`year'==.
gen PlanAmt_AandB_3_PointEst_`year'=0
replace PlanAmt_AandB_3_PointEst_`year'=1 if PlanAmt_AandB_3_DkRf_`year'==0

gen double Plan_AandB_3_minval=KJ274C
gen double Plan_AandB_3_maxval=KJ275C

local binmin0   0
local binmin1   25001
local binmin2   50001
local binmin3   100001
local binmin4   250001
local binmax0   24999
local binmax1   49999
local binmax2   99999
local binmax3   249999
local binmax4   99999996
local binexact1 25000
local binexact2 50000
local binexact3 100000
local binexact4 250000

/* Generating exact values here */
replace PlanAmt_3_`year'=`binexact1' if Plan_AandB_3_minval==`binexact1' & Plan_AandB_3_maxval==`binexact1'
replace PlanAmt_3_`year'=`binexact2' if Plan_AandB_3_minval==`binexact2' & Plan_AandB_3_maxval==`binexact2'
replace PlanAmt_3_`year'=`binexact3' if Plan_AandB_3_minval==`binexact3' & Plan_AandB_3_maxval==`binexact3'
replace PlanAmt_3_`year'=`binexact4' if Plan_AandB_3_minval==`binexact4' & Plan_AandB_3_maxval==`binexact4'

* Generate bins
forval num=0/4{
    sum PlanAmt_3_`year' if PlanAmt_AandB_3_PointEst_`year'==1 & PlanAmt_3_`year' > `binmin`num'' & PlanAmt_3_`year' < `binmax`num'', detail
    cap assert r(N)>`impute_numobs'
    if _rc{
        replace PlanAmt_3_`year'=r(p$bin_pctile) if Plan_AandB_3_minval==`binmin`num'' & Plan_AandB_3_maxval==`binmax`num''
    }
    else{
        replace PlanAmt_3_`year'=(`binmin`num''+`binmin`num'')/2 if Plan_AandB_3_minval==`binmin`num'' & Plan_AandB_3_maxval==`binmax`num''
    }
}

/***************************************************
 This is plan amount for type B plan (DC) only
***************************************************/
replace PlanAmt_3_`year'=     KJ307C if KJ307C~=.
replace PlanAmt_3_`year'=.           if KJ307C==-2 | KJ307C==99999998 | KJ307C==99999999
gen PlanAmt_3_DkRf_`year'=0
replace PlanAmt_3_DkRf_`year'=1 if PlanAmt_3_`year'==.
gen PlanAmt_3_PointEst_`year'=0
replace PlanAmt_3_PointEst_`year'=1 if PlanAmt_3_DkRf_`year'==0

gen double Plan_3_minval=KJ308C
gen double Plan_3_maxval=KJ309C

local binmin0   0
local binmin1   5001
local binmin2   20001
local binmin3   50001
local binmin4   150001
local binmax0   4999
local binmax1   19999
local binmax2   49999
local binmax3   149999
local binmax4   99999996
local binexact1 5000
local binexact2 20000
local binexact3 50000
local binexact4 150000

/* Generating exact values here */
replace PlanAmt_3_`year'=`binexact1' if Plan_3_minval==`binexact1' & Plan_3_maxval==`binexact1'
replace PlanAmt_3_`year'=`binexact2' if Plan_3_minval==`binexact2' & Plan_3_maxval==`binexact2'
replace PlanAmt_3_`year'=`binexact3' if Plan_3_minval==`binexact3' & Plan_3_maxval==`binexact3'
replace PlanAmt_3_`year'=`binexact4' if Plan_3_minval==`binexact4' & Plan_3_maxval==`binexact4'

* Generate bins
forval num=0/4{
    sum PlanAmt_3_`year' if PlanAmt_3_PointEst_`year'==1 & PlanAmt_3_`year' > `binmin`num'' & PlanAmt_3_`year' < `binmax`num'', detail
    cap assert r(N)>`impute_numobs'
    if _rc{
        replace PlanAmt_3_`year'=r(p$bin_pctile) if Plan_3_minval==`binmin`num'' & Plan_3_maxval==`binmax`num''
    }
    else{
        replace PlanAmt_3_`year'=(`binmin`num''+`binmin`num'')/2 if Plan_3_minval==`binmin`num'' & Plan_3_maxval==`binmax`num''
    }
}

/***********************************************************
 This is plan stock allocation for type B account (DC) only
***********************************************************/
gen PlanPctStocks_3_`year'=0
replace PlanPctStocks_3_`year'=KJ742C if KJ742C~=. 
replace PlanPctStocks_3_`year'=. if KJ742C==998 | KJ742C==999
gen PlanPctStocks_3_DkRF_`year'=0
replace PlanPctStocks_3_DkRF_`year'=1 if KJ742C==998 | KJ742C==999
gen PlanPctStocks_3_PointEst_`year'=0
replace PlanPctStocks_3_PointEst_`year'=1 if PlanPctStocks_3_DkRF_`year'==0

gen double PctStocks_3_minval=KJ743C
gen double PctStocks_3_maxval=KJ744C

local binmin0   0
local binmin1   21
local binmin2   41
local binmin3   61
local binmin4   81
local binmax0   19
local binmax1   39
local binmax2   59
local binmax3   79
local binmax4   100
local binexact1 20
local binexact2 40
local binexact3 60
local binexact4 80

/* Generating exact values here */
replace PlanPctStocks_3_`year'=`binexact1' if PctStocks_3_minval==`binexact1' & PctStocks_3_maxval==`binexact1'
replace PlanPctStocks_3_`year'=`binexact2' if PctStocks_3_minval==`binexact2' & PctStocks_3_maxval==`binexact2'
replace PlanPctStocks_3_`year'=`binexact3' if PctStocks_3_minval==`binexact3' & PctStocks_3_maxval==`binexact3'
replace PlanPctStocks_3_`year'=`binexact4' if PctStocks_3_minval==`binexact4' & PctStocks_3_maxval==`binexact4'

* Generate bins
forval num=0/4{
    sum PlanPctStocks_3_`year' if PlanPctStocks_3_PointEst_`year'==1 & PlanPctStocks_3_`year' > `binmin`num'' & PlanPctStocks_3_`year' < `binmax`num'', detail
    cap assert r(N)>`impute_numobs'
    if _rc{
        replace PlanPctStocks_3_`year'=r(p$bin_pctile) if PctStocks_3_minval==`binmin`num'' & PctStocks_3_maxval==`binmax`num''
    }
    else{
        replace PlanPctStocks_3_`year'=(`binmin`num''+`binmin`num'')/2 if PctStocks_3_minval==`binmin`num'' & PctStocks_3_maxval==`binmax`num''
    }
}

/***********************************************************
 This is plan stock allocation IN COMPANY STOCK (DC) only
***********************************************************/
gen CompPctStocks_3_`year'=0
replace CompPctStocks_3_`year'=KJ747C if KJ747C~=.
replace CompPctStocks_3_`year'=. if KJ747C==998 | KJ747C==999
gen CompPctStocks_3_DkRF_`year'=0
replace CompPctStocks_3_DkRF_`year'=1 if KJ747C==998 | KJ747C==999
gen CompPctStocks_3_PointEst_`year'=0
replace CompPctStocks_3_PointEst_`year'=1 if CompPctStocks_3_DkRF_`year'==0

gen double CompPctStocks_3_minval=KJ748C
gen double CompPctStocks_3_maxval=KJ749C

local binmin0   0
local binmin1   21
local binmin2   41
local binmin3   61
local binmin4   81
local binmax0   19
local binmax1   39
local binmax2   59
local binmax3   79
local binmax4   100
local binexact1 20
local binexact2 40
local binexact3 60
local binexact4 80

/* Generating exact values here */
replace CompPctStocks_3_`year'=`binexact1' if CompPctStocks_3_minval==`binexact1' & CompPctStocks_3_maxval==`binexact1'
replace CompPctStocks_3_`year'=`binexact2' if CompPctStocks_3_minval==`binexact2' & CompPctStocks_3_maxval==`binexact2'
replace CompPctStocks_3_`year'=`binexact3' if CompPctStocks_3_minval==`binexact3' & CompPctStocks_3_maxval==`binexact3'
replace CompPctStocks_3_`year'=`binexact4' if CompPctStocks_3_minval==`binexact4' & CompPctStocks_3_maxval==`binexact4'

* Generate bins
forval num=0/4{
    sum CompPctStocks_3_`year' if CompPctStocks_3_PointEst_`year'==1 & CompPctStocks_3_`year' > `binmin`num'' & CompPctStocks_3_`year' < `binmax`num'', detail
    cap assert r(N)>`impute_numobs'
    if _rc{
        replace CompPctStocks_3_`year'=r(p$bin_pctile) if CompPctStocks_3_minval==`binmin`num'' & CompPctStocks_3_maxval==`binmax`num''
    }
    else{
        replace CompPctStocks_3_`year'=(`binmin`num''+`binmin`num'')/2 if CompPctStocks_3_minval==`binmin`num'' & CompPctStocks_3_maxval==`binmax`num''
    }
}

/***************************************
PENSION AT CURRENT JOB #4
***************************************/
gen PlanType_4_`year'=KJ272D		 
		 
* If DCorDBPlan=1, then DC, if 0 then DB
gen     HasDCPlan_4_`year'=0
replace HasDCPlan_4_`year'=1 if KJ272D==2 | KJ272D==3
replace HasDCPlan_4_`year'=. if KJ272D>=8 & KJ272D~=.

gen     HasDBPlan_4_`year'=0
replace HasDBPlan_4_`year'=1 if KJ272D==1 | KJ272D==3
replace HasDBPlan_4_`year'=. if KJ272D>=8 & KJ272D~=.

/***************************************************
 This is plan amount for type A&B account, the (DC) part only
***************************************************/
/* No obs in 2006 */
gen PlanAmt_4_`year'    =     0
replace PlanAmt_4_`year'=     KJ273D if KJ273D~=.
replace PlanAmt_4_`year'=.           if KJ273D==-2 | KJ273D==99999998 | KJ273D==99999999
gen PlanAmt_AandB_4_DkRf_`year'=0
replace PlanAmt_AandB_4_DkRf_`year'=1 if PlanAmt_4_`year'==.
gen PlanAmt_AandB_4_PointEst_`year'=0
replace PlanAmt_AandB_4_PointEst_`year'=1 if PlanAmt_AandB_4_DkRf_`year'==0

/***********************************************************
 This is plan stock allocation for type B account (DC) only
***********************************************************/
gen PlanPctStocks_4_`year'=0 

/***********************************************************
 This is plan stock allocation IN COMPANY STOCK (DC) only
***********************************************************/
gen CompPctStocks_4_`year'=0 

/****************************************************************************
                         IF DID NOT CHANGE JOBS
****************************************************************************/

/***************************************
PENSION AT CURRENT JOB #1
***************************************/ 		 
replace PlanType_1_`year'=KJ338A if KJ338A~=.	 

* If DCorDBPlan=1, then DC, if 0 then DB
replace HasDCPlan_1_`year'=1 if KJ393A==1 | KJ393A==2 | (KJ393A>=4 & KJ393A<95)
replace HasDCPlan_1_`year'=. if KJ393A>=95 & KJ393A~=.

replace HasDBPlan_1_`year'=1 if KJ393A==3
replace HasDBPlan_1_`year'=. if KJ393A>=95 & KJ393A~=.	 

/* This is only for people not participating in a plan */
gen     PlanAutoEnroll_1_`year'=.
replace PlanAutoEnroll_1_`year'=1 if KJ820A==2
replace PlanAutoEnroll_1_`year'=0 if KJ820A==1


/***************************************************
 This is plan amount for type A and B account only
***************************************************/
gen PlanAmtNoChng_1_`year'    =     0
replace PlanAmtNoChng_1_`year'=      KJ339A if KJ339A~=.
replace PlanAmtNoChng_1_`year'=.            if KJ339A==-2 | KJ339A==99999998 | KJ339A==99999999
gen PlanAmtNoChng_AandB_1_DkRf_`year'=0
replace PlanAmtNoChng_AandB_1_DkRf_`year'=1 if PlanAmtNoChng_1_`year'==.
gen PANoChng_AandB_1_PointEst_`year'=0
replace PANoChng_AandB_1_PointEst_`year'=1 if PlanAmtNoChng_AandB_1_DkRf_`year'==0

gen double PlanNoChng_AandB_1_minval=KJ340A
gen double PlanNoChng_AandB_1_maxval=KJ341A

local binmin0   0
local binmin1   5001
local binmin2   20001
local binmin3   50001
local binmin4   150001
local binmax0   4999
local binmax1   19999
local binmax2   49999
local binmax3   149999
local binmax4   99999996
local binexact1 5000
local binexact2 20000
local binexact3 50000
local binexact4 150000

/* Generating exact values here */
replace PlanAmtNoChng_1_`year'=`binexact1' if PlanNoChng_AandB_1_minval==`binexact1' & PlanNoChng_AandB_1_maxval==`binexact1'
replace PlanAmtNoChng_1_`year'=`binexact2' if PlanNoChng_AandB_1_minval==`binexact2' & PlanNoChng_AandB_1_maxval==`binexact2'
replace PlanAmtNoChng_1_`year'=`binexact3' if PlanNoChng_AandB_1_minval==`binexact3' & PlanNoChng_AandB_1_maxval==`binexact3'
replace PlanAmtNoChng_1_`year'=`binexact4' if PlanNoChng_AandB_1_minval==`binexact4' & PlanNoChng_AandB_1_maxval==`binexact4'

* Generate bins
forval num=0/4{
    sum PlanAmtNoChng_1_`year' if PANoChng_AandB_1_PointEst_`year'==1 & PlanAmtNoChng_1_`year' > `binmin`num'' & PlanAmtNoChng_1_`year' < `binmax`num'', detail
    cap assert r(N)>`impute_numobs'
    if _rc{
        replace PlanAmtNoChng_1_`year'=r(p$bin_pctile) if PlanNoChng_AandB_1_minval==`binmin`num'' & PlanNoChng_AandB_1_maxval==`binmax`num''
    }
    else{
        replace PlanAmtNoChng_1_`year'=(`binmin`num''+`binmin`num'')/2 if PlanNoChng_AandB_1_minval==`binmin`num'' & PlanNoChng_AandB_1_maxval==`binmax`num''
    }
}

/***************************************************
 This is plan amount for type B account (DC) only
***************************************************/
replace PlanAmtNoChng_1_`year'=     KJ413A if KJ413A~=.
replace PlanAmtNoChng_1_`year'=.            if KJ413A==-2 | KJ413A==99999998 | KJ413A==99999999
gen PlanAmtNoChng_1_DkRf_`year'=0
replace PlanAmtNoChng_1_DkRf_`year'=1 if PlanAmtNoChng_1_`year'==.
gen PlanAmtNoChng_1_PointEst_`year'=0
replace PlanAmtNoChng_1_PointEst_`year'=1 if PlanAmtNoChng_1_DkRf_`year'==0

gen double PlanNoChng_1_minval=KJ414A
gen double PlanNoChng_1_maxval=KJ415A

local binmin0   0
local binmin1   5001
local binmin2   20001
local binmin3   50001
local binmin4   150001
local binmax0   4999
local binmax1   19999
local binmax2   49999
local binmax3   149999
local binmax4   99999996
local binexact1 5000
local binexact2 20000
local binexact3 50000
local binexact4 150000

/* Generating exact values here */
replace PlanAmtNoChng_1_`year'=`binexact1' if PlanNoChng_1_minval==`binexact1' & PlanNoChng_1_maxval==`binexact1'
replace PlanAmtNoChng_1_`year'=`binexact2' if PlanNoChng_1_minval==`binexact2' & PlanNoChng_1_maxval==`binexact2'
replace PlanAmtNoChng_1_`year'=`binexact3' if PlanNoChng_1_minval==`binexact3' & PlanNoChng_1_maxval==`binexact3'
replace PlanAmtNoChng_1_`year'=`binexact4' if PlanNoChng_1_minval==`binexact4' & PlanNoChng_1_maxval==`binexact4'

* Generate bins
forval num=0/4{
    sum PlanAmtNoChng_1_`year' if PlanAmtNoChng_1_PointEst_`year'==1 & PlanAmtNoChng_1_`year' > `binmin`num'' & PlanAmtNoChng_1_`year' < `binmax`num'', detail
    cap assert r(N)>`impute_numobs'
    if _rc{
        replace PlanAmtNoChng_1_`year'=r(p$bin_pctile) if PlanNoChng_1_minval==`binmin`num'' & PlanNoChng_1_maxval==`binmax`num''
    }
    else{
        replace PlanAmtNoChng_1_`year'=(`binmin`num''+`binmin`num'')/2 if PlanNoChng_1_minval==`binmin`num'' & PlanNoChng_1_maxval==`binmax`num''
    }
}

/***********************************************************
 This is plan stock allocation for type B account (DC) only
***********************************************************/
gen PlanPctStocksNoChng_1_`year'=0
replace PlanPctStocksNoChng_1_`year'=KJ812A if KJ812A~=.
replace PlanPctStocksNoChng_1_`year'=. if KJ812A==998 | KJ812A==999
gen PlanPctStocksNoChng_1_DkRF_`year'=0
replace PlanPctStocksNoChng_1_DkRF_`year'=1 if KJ812A==998 | KJ812A==999
gen PPS_NoChng_1_PointEst_`year'=0
replace PPS_NoChng_1_PointEst_`year'=1 if PlanPctStocksNoChng_1_DkRF_`year'==0

gen double PctStocksNoChng_1_minval=KJ813A
gen double PctStocksNoChng_1_maxval=KJ814A

local binmin0   0
local binmin1   21
local binmin2   41
local binmin3   61
local binmin4   81
local binmax0   19
local binmax1   39
local binmax2   59
local binmax3   79
local binmax4   99999996
local binexact1 20
local binexact2 40
local binexact3 60
local binexact4 80

/* Generating exact values here */
replace PlanPctStocksNoChng_1_`year'=`binexact1' if PctStocksNoChng_1_minval==`binexact1' & PctStocksNoChng_1_maxval==`binexact1'
replace PlanPctStocksNoChng_1_`year'=`binexact2' if PctStocksNoChng_1_minval==`binexact2' & PctStocksNoChng_1_maxval==`binexact2'
replace PlanPctStocksNoChng_1_`year'=`binexact3' if PctStocksNoChng_1_minval==`binexact3' & PctStocksNoChng_1_maxval==`binexact3'
replace PlanPctStocksNoChng_1_`year'=`binexact4' if PctStocksNoChng_1_minval==`binexact4' & PctStocksNoChng_1_maxval==`binexact4'

* Generate bins
forval num=0/4{
    sum PlanPctStocksNoChng_1_`year' if PPS_NoChng_1_PointEst_`year'==1 & PlanPctStocksNoChng_1_`year' > `binmin`num'' & PlanPctStocksNoChng_1_`year' < `binmax`num'', detail
    cap assert r(N)>`impute_numobs'
    if _rc{
        replace PlanPctStocksNoChng_1_`year'=r(p$bin_pctile) if PctStocksNoChng_1_minval==`binmin`num'' & PctStocksNoChng_1_maxval==`binmax`num''
    }
    else{
        replace PlanPctStocksNoChng_1_`year'=(`binmin`num''+`binmin`num'')/2 if PctStocksNoChng_1_minval==`binmin`num'' & PctStocksNoChng_1_maxval==`binmax`num''
    }
}

/***********************************************************
 This is plan stock allocation IN COMPANY STOCK (DC) only
***********************************************************/
gen CompPctStocksNoChng_1_`year'=0
replace CompPctStocksNoChng_1_`year'=KJ816A
replace CompPctStocksNoChng_1_`year'=. if KJ816A==998 | KJ816A==999
gen CompPctStocksNoChng_1_DkRF_`year'=0
replace CompPctStocksNoChng_1_DkRF_`year'=1 if KJ816A==998 | KJ816A==999
gen CPSNoChng_1_PointEst_`year'=0
replace CPSNoChng_1_PointEst_`year'=1 if CompPctStocksNoChng_1_DkRF_`year'==0

gen double CompPctStocksNoChng_1_minval=KJ817A
gen double CompPctStocksNoChng_1_maxval=KJ818A

local binmin0   0
local binmin1   21
local binmin2   41
local binmin3   61
local binmin4   81
local binmax0   19
local binmax1   39
local binmax2   59
local binmax3   79
local binmax4   99999996
local binexact1 20
local binexact2 40
local binexact3 60
local binexact4 80

/* Generating exact values here */
replace CompPctStocksNoChng_1_`year'=`binexact1' if CompPctStocksNoChng_1_minval==`binexact1' & CompPctStocksNoChng_1_maxval==`binexact1'
replace CompPctStocksNoChng_1_`year'=`binexact2' if CompPctStocksNoChng_1_minval==`binexact2' & CompPctStocksNoChng_1_maxval==`binexact2'
replace CompPctStocksNoChng_1_`year'=`binexact3' if CompPctStocksNoChng_1_minval==`binexact3' & CompPctStocksNoChng_1_maxval==`binexact3'
replace CompPctStocksNoChng_1_`year'=`binexact4' if CompPctStocksNoChng_1_minval==`binexact4' & CompPctStocksNoChng_1_maxval==`binexact4'

* Generate bins
forval num=0/4{
    sum CompPctStocksNoChng_1_`year' if CPSNoChng_1_PointEst_`year'==1 & CompPctStocksNoChng_1_`year' > `binmin`num'' & CompPctStocksNoChng_1_`year' < `binmax`num'', detail
    cap assert r(N)>`impute_numobs'
    if _rc{
        replace CompPctStocksNoChng_1_`year'=r(p$bin_pctile) if CompPctStocksNoChng_1_minval==`binmin`num'' & CompPctStocksNoChng_1_maxval==`binmax`num''
    }
    else{
        replace CompPctStocksNoChng_1_`year'=(`binmin`num''+`binmin`num'')/2 if CompPctStocksNoChng_1_minval==`binmin`num'' & CompPctStocksNoChng_1_maxval==`binmax`num''
    }
}

/***************************************
PENSION AT CURRENT JOB #2
***************************************/ 		 
replace PlanType_2_`year'=KJ338B if KJ338B~=.	 

* If DCorDBPlan=1, then DC, if 0 then DB
replace HasDCPlan_2_`year'=1 if KJ393B==1 | KJ393B==2 | (KJ393B>=4 & KJ393B<95)
replace HasDCPlan_2_`year'=. if KJ393B>=95 & KJ393B~=.

replace HasDBPlan_2_`year'=1 if KJ393B==3
replace HasDBPlan_2_`year'=. if KJ393B>=95 & KJ393B~=.	 

/* This is only for people not participating in a plan */
gen     PlanAutoEnroll_2_`year'=.
replace PlanAutoEnroll_2_`year'=1 if KJ820B==2
replace PlanAutoEnroll_2_`year'=0 if KJ820B==1


/***************************************************
 This is plan amount for type A and B account only
***************************************************/
gen PlanAmtNoChng_2_`year'    =     0
replace PlanAmtNoChng_2_`year'=      KJ339B if KJ339B~=.
replace PlanAmtNoChng_2_`year'=.            if KJ339B==99999998 | KJ339B==99999999
gen PlanAmtNoChng_AandB_2_DkRf_`year'=0
replace PlanAmtNoChng_AandB_2_DkRf_`year'=1 if PlanAmtNoChng_2_`year'==.
gen PANoChng_AandB_2_PointEst_`year'=0
replace PANoChng_AandB_2_PointEst_`year'=1 if PlanAmtNoChng_AandB_2_DkRf_`year'==0

gen double PlanNoChng_AandB_2_minval=KJ340B
gen double PlanNoChng_AandB_2_maxval=KJ341B

local binmin0   0
local binmin1   5001
local binmin2   20001
local binmin3   50001
local binmin4   150001
local binmax0   4999
local binmax1   19999
local binmax2   49999
local binmax3   149999
local binmax4   99999996
local binexact1 5000
local binexact2 20000
local binexact3 50000
local binexact4 150000

/* Generating exact values here */
replace PlanAmtNoChng_2_`year'=`binexact1' if PlanNoChng_AandB_2_minval==`binexact1' & PlanNoChng_AandB_2_maxval==`binexact1'
replace PlanAmtNoChng_2_`year'=`binexact2' if PlanNoChng_AandB_2_minval==`binexact2' & PlanNoChng_AandB_2_maxval==`binexact2'
replace PlanAmtNoChng_2_`year'=`binexact3' if PlanNoChng_AandB_2_minval==`binexact3' & PlanNoChng_AandB_2_maxval==`binexact3'
replace PlanAmtNoChng_2_`year'=`binexact4' if PlanNoChng_AandB_2_minval==`binexact4' & PlanNoChng_AandB_2_maxval==`binexact4'

* Generate bins
forval num=0/4{
    sum PlanAmtNoChng_2_`year' if PANoChng_AandB_2_PointEst_`year'==1 & PlanAmtNoChng_2_`year' > `binmin`num'' & PlanAmtNoChng_2_`year' < `binmax`num'', detail
    cap assert r(N)>`impute_numobs'
    if _rc{
        replace PlanAmtNoChng_2_`year'=r(p$bin_pctile) if PlanNoChng_AandB_2_minval==`binmin`num'' & PlanNoChng_AandB_2_maxval==`binmax`num''
    }
    else{
        replace PlanAmtNoChng_2_`year'=(`binmin`num''+`binmin`num'')/2 if PlanNoChng_AandB_2_minval==`binmin`num'' & PlanNoChng_AandB_2_maxval==`binmax`num''
    }
}

/***************************************************
 This is plan amount for type B account (DC) only
***************************************************/
replace PlanAmtNoChng_2_`year'=     KJ413B if KJ413B~=.
replace PlanAmtNoChng_2_`year'=.            if KJ413B==99999998 | KJ413B==99999999
gen PlanAmtNoChng_2_DkRf_`year'=0
replace PlanAmtNoChng_2_DkRf_`year'=1 if PlanAmtNoChng_2_`year'==.
gen PlanAmtNoChng_2_PointEst_`year'=0
replace PlanAmtNoChng_2_PointEst_`year'=1 if PlanAmtNoChng_2_DkRf_`year'==0

gen double PlanNoChng_2_minval=KJ414B
gen double PlanNoChng_2_maxval=KJ415B

local binmin0   0
local binmin1   5001
local binmin2   20001
local binmin3   50001
local binmin4   150001
local binmax0   4999
local binmax1   19999
local binmax2   49999
local binmax3   149999
local binmax4   99999996
local binexact1 5000
local binexact2 20000
local binexact3 50000
local binexact4 150000

/* Generating exact values here */
replace PlanAmtNoChng_2_`year'=`binexact1' if PlanNoChng_2_minval==`binexact1' & PlanNoChng_2_maxval==`binexact1'
replace PlanAmtNoChng_2_`year'=`binexact2' if PlanNoChng_2_minval==`binexact2' & PlanNoChng_2_maxval==`binexact2'
replace PlanAmtNoChng_2_`year'=`binexact3' if PlanNoChng_2_minval==`binexact3' & PlanNoChng_2_maxval==`binexact3'
replace PlanAmtNoChng_2_`year'=`binexact4' if PlanNoChng_2_minval==`binexact4' & PlanNoChng_2_maxval==`binexact4'

* Generate bins
forval num=0/4{
    sum PlanAmtNoChng_2_`year' if PlanAmtNoChng_2_PointEst_`year'==1 & PlanAmtNoChng_2_`year' > `binmin`num'' & PlanAmtNoChng_2_`year' < `binmax`num'', detail
    cap assert r(N)>`impute_numobs'
    if _rc{
        replace PlanAmtNoChng_2_`year'=r(p$bin_pctile) if PlanNoChng_2_minval==`binmin`num'' & PlanNoChng_2_maxval==`binmax`num''
    }
    else{
        replace PlanAmtNoChng_2_`year'=(`binmin`num''+`binmin`num'')/2 if PlanNoChng_2_minval==`binmin`num'' & PlanNoChng_2_maxval==`binmax`num''
    }
}

/***********************************************************
 This is plan stock allocation for type B account (DC) only
***********************************************************/

gen PlanPctStocksNoChng_2_`year'=0
replace PlanPctStocksNoChng_2_`year'=KJ812B if KJ812B~=.
replace PlanPctStocksNoChng_2_`year'=. if KJ812B==998 | KJ812B==999
gen PlanPctStocksNoChng_2_DkRF_`year'=0
replace PlanPctStocksNoChng_2_DkRF_`year'=1 if KJ812B==998 | KJ812B==999
gen PPS_NoChng_2_PointEst_`year'=0
replace PPS_NoChng_2_PointEst_`year'=1 if PlanPctStocksNoChng_2_DkRF_`year'==0

gen double PctStocksNoChng_2_minval=KJ813B
gen double PctStocksNoChng_2_maxval=KJ814B

local binmin0   0
local binmin1   21
local binmin2   41
local binmin3   61
local binmin4   81
local binmax0   19
local binmax1   39
local binmax2   59
local binmax3   79
local binmax4   99999996
local binexact1 20
local binexact2 40
local binexact3 60
local binexact4 80

/* Generating exact values here */
replace PlanPctStocksNoChng_2_`year'=`binexact1' if PctStocksNoChng_2_minval==`binexact1' & PctStocksNoChng_2_maxval==`binexact1'
replace PlanPctStocksNoChng_2_`year'=`binexact2' if PctStocksNoChng_2_minval==`binexact2' & PctStocksNoChng_2_maxval==`binexact2'
replace PlanPctStocksNoChng_2_`year'=`binexact3' if PctStocksNoChng_2_minval==`binexact3' & PctStocksNoChng_2_maxval==`binexact3'
replace PlanPctStocksNoChng_2_`year'=`binexact4' if PctStocksNoChng_2_minval==`binexact4' & PctStocksNoChng_2_maxval==`binexact4'

* Generate bins
forval num=0/4{
    sum PlanPctStocksNoChng_2_`year' if PPS_NoChng_2_PointEst_`year'==1 & PlanPctStocksNoChng_2_`year' > `binmin`num'' & PlanPctStocksNoChng_2_`year' < `binmax`num'', detail
    cap assert r(N)>`impute_numobs'
    if _rc{
        replace PlanPctStocksNoChng_2_`year'=r(p$bin_pctile) if PctStocksNoChng_2_minval==`binmin`num'' & PctStocksNoChng_2_maxval==`binmax`num''
    }
    else{
        replace PlanPctStocksNoChng_2_`year'=(`binmin`num''+`binmin`num'')/2 if PctStocksNoChng_2_minval==`binmin`num'' & PctStocksNoChng_2_maxval==`binmax`num''
    }
}

/***********************************************************
 This is plan stock allocation IN COMPANY STOCK (DC) only
***********************************************************/
gen CompPctStocksNoChng_2_`year'=0
replace CompPctStocksNoChng_2_`year'=KJ816B
replace CompPctStocksNoChng_2_`year'=. if KJ816B==998 | KJ816B==999
gen CompPctStocksNoChng_2_DkRF_`year'=0
replace CompPctStocksNoChng_2_DkRF_`year'=1 if KJ816B==998 | KJ816B==999
gen CPSNoChng_2_PointEst_`year'=0
replace CPSNoChng_2_PointEst_`year'=1 if CompPctStocksNoChng_2_DkRF_`year'==0

gen double CompPctStocksNoChng_2_minval=KJ817B
gen double CompPctStocksNoChng_2_maxval=KJ818B

local binmin0   0
local binmin1   21
local binmin2   41
local binmin3   61
local binmin4   81
local binmax0   19
local binmax1   39
local binmax2   59
local binmax3   79
local binmax4   99999996
local binexact1 20
local binexact2 40
local binexact3 60
local binexact4 80

/* Generating exact values here */
replace CompPctStocksNoChng_2_`year'=`binexact1' if CompPctStocksNoChng_2_minval==`binexact1' & CompPctStocksNoChng_2_maxval==`binexact1'
replace CompPctStocksNoChng_2_`year'=`binexact2' if CompPctStocksNoChng_2_minval==`binexact2' & CompPctStocksNoChng_2_maxval==`binexact2'
replace CompPctStocksNoChng_2_`year'=`binexact3' if CompPctStocksNoChng_2_minval==`binexact3' & CompPctStocksNoChng_2_maxval==`binexact3'
replace CompPctStocksNoChng_2_`year'=`binexact4' if CompPctStocksNoChng_2_minval==`binexact4' & CompPctStocksNoChng_2_maxval==`binexact4'

* Generate bins
forval num=0/4{
    sum CompPctStocksNoChng_2_`year' if CPSNoChng_2_PointEst_`year'==1 & CompPctStocksNoChng_2_`year' > `binmin`num'' & CompPctStocksNoChng_2_`year' < `binmax`num'', detail
    cap assert r(N)>`impute_numobs'
    if _rc{
        replace CompPctStocksNoChng_2_`year'=r(p$bin_pctile) if CompPctStocksNoChng_2_minval==`binmin`num'' & CompPctStocksNoChng_2_maxval==`binmax`num''
    }
    else{
        replace CompPctStocksNoChng_2_`year'=(`binmin`num''+`binmin`num'')/2 if CompPctStocksNoChng_2_minval==`binmin`num'' & CompPctStocksNoChng_2_maxval==`binmax`num''
    }
}

/***************************************
PENSION AT CURRENT JOB #3
***************************************/ 		 
replace PlanType_3_`year'=KJ338C if KJ338C~=.	 

* If DCorDBPlan=1, then DC, if 0 then DB
replace HasDCPlan_3_`year'=1 if KJ393C==1 | KJ393C==2 | (KJ393C>=4 & KJ393C<95)
replace HasDCPlan_3_`year'=. if KJ393C>=95 & KJ393C~=.

replace HasDBPlan_3_`year'=1 if KJ393C==3
replace HasDBPlan_3_`year'=. if KJ393C>=95 & KJ393C~=.	 

/* This is only for people not participating in a plan */
gen     PlanAutoEnroll_3_`year'=.
replace PlanAutoEnroll_3_`year'=1 if KJ820C==2
replace PlanAutoEnroll_3_`year'=0 if KJ820C==1


/***************************************************
 This is plan amount for type A and B account only
***************************************************/
/* Only one binned obs in 2006 and not credible */
gen PlanAmtNoChng_3_`year'    =     0

/***************************************************
 This is plan amount for type B account (DC) only
***************************************************/
replace PlanAmtNoChng_3_`year'=     KJ413C if KJ413C~=.
replace PlanAmtNoChng_3_`year'=.            if KJ413C==99999998 | KJ413C==99999999
gen PlanAmtNoChng_3_DkRf_`year'=0
replace PlanAmtNoChng_3_DkRf_`year'=1 if PlanAmtNoChng_3_`year'==.
gen PlanAmtNoChng_3_PointEst_`year'=0
replace PlanAmtNoChng_3_PointEst_`year'=1 if PlanAmtNoChng_3_DkRf_`year'==0

gen double PlanNoChng_3_minval=KJ414C
gen double PlanNoChng_3_maxval=KJ415C

local binmin0   0
local binmin1   5001
local binmin2   20001
local binmin3   50001
local binmin4   150001
local binmax0   4999
local binmax1   19999
local binmax2   49999
local binmax3   149999
local binmax4   99999996
local binexact1 5000
local binexact2 20000
local binexact3 50000
local binexact4 150000

/* Generating exact values here */
replace PlanAmtNoChng_3_`year'=`binexact1' if PlanNoChng_3_minval==`binexact1' & PlanNoChng_3_maxval==`binexact1'
replace PlanAmtNoChng_3_`year'=`binexact2' if PlanNoChng_3_minval==`binexact2' & PlanNoChng_3_maxval==`binexact2'
replace PlanAmtNoChng_3_`year'=`binexact3' if PlanNoChng_3_minval==`binexact3' & PlanNoChng_3_maxval==`binexact3'
replace PlanAmtNoChng_3_`year'=`binexact4' if PlanNoChng_3_minval==`binexact4' & PlanNoChng_3_maxval==`binexact4'

* Generate bins
forval num=0/4{
    sum PlanAmtNoChng_3_`year' if PlanAmtNoChng_3_PointEst_`year'==1 & PlanAmtNoChng_3_`year' > `binmin`num'' & PlanAmtNoChng_3_`year' < `binmax`num'', detail
    cap assert r(N)>`impute_numobs'
    if _rc{
        replace PlanAmtNoChng_3_`year'=r(p$bin_pctile) if PlanNoChng_3_minval==`binmin`num'' & PlanNoChng_3_maxval==`binmax`num''
    }
    else{
        replace PlanAmtNoChng_3_`year'=(`binmin`num''+`binmin`num'')/2 if PlanNoChng_3_minval==`binmin`num'' & PlanNoChng_3_maxval==`binmax`num''
    }
}

/***********************************************************
 This is plan stock allocation for type B account (DC) only
***********************************************************/

gen PlanPctStocksNoChng_3_`year'=0
replace PlanPctStocksNoChng_3_`year'=KJ812C if KJ812C~=.
replace PlanPctStocksNoChng_3_`year'=. if KJ812C==998 | KJ812C==999
gen PlanPctStocksNoChng_3_DkRF_`year'=0
replace PlanPctStocksNoChng_3_DkRF_`year'=1 if KJ812C==998 | KJ812C==999
gen PPS_NoChng_3_PointEst_`year'=0
replace PPS_NoChng_3_PointEst_`year'=1 if PlanPctStocksNoChng_3_DkRF_`year'==0

gen double PctStocksNoChng_3_minval=KJ813C
gen double PctStocksNoChng_3_maxval=KJ814C

local binmin0   0
local binmin1   21
local binmin2   41
local binmin3   61
local binmin4   81
local binmax0   19
local binmax1   39
local binmax2   59
local binmax3   79
local binmax4   99999996
local binexact1 20
local binexact2 40
local binexact3 60
local binexact4 80

/* Generating exact values here */
replace PlanPctStocksNoChng_3_`year'=`binexact1' if PctStocksNoChng_3_minval==`binexact1' & PctStocksNoChng_3_maxval==`binexact1'
replace PlanPctStocksNoChng_3_`year'=`binexact2' if PctStocksNoChng_3_minval==`binexact2' & PctStocksNoChng_3_maxval==`binexact2'
replace PlanPctStocksNoChng_3_`year'=`binexact3' if PctStocksNoChng_3_minval==`binexact3' & PctStocksNoChng_3_maxval==`binexact3'
replace PlanPctStocksNoChng_3_`year'=`binexact4' if PctStocksNoChng_3_minval==`binexact4' & PctStocksNoChng_3_maxval==`binexact4'

* Generate bins
forval num=0/4{
    sum PlanPctStocksNoChng_3_`year' if PPS_NoChng_3_PointEst_`year'==1 & PlanPctStocksNoChng_3_`year' > `binmin`num'' & PlanPctStocksNoChng_3_`year' < `binmax`num'', detail
    cap assert r(N)>`impute_numobs'
    if _rc{
        replace PlanPctStocksNoChng_3_`year'=r(p$bin_pctile) if PctStocksNoChng_3_minval==`binmin`num'' & PctStocksNoChng_3_maxval==`binmax`num''
    }
    else{
        replace PlanPctStocksNoChng_3_`year'=(`binmin`num''+`binmin`num'')/2 if PctStocksNoChng_3_minval==`binmin`num'' & PctStocksNoChng_3_maxval==`binmax`num''
    }
}

/***********************************************************
 This is plan stock allocation IN COMPANY STOCK (DC) only
***********************************************************/
gen CompPctStocksNoChng_3_`year'=0
replace CompPctStocksNoChng_3_`year'=KJ816C
replace CompPctStocksNoChng_3_`year'=. if KJ816C==998 | KJ816C==999
gen CompPctStocksNoChng_3_DkRF_`year'=0
replace CompPctStocksNoChng_3_DkRF_`year'=1 if KJ816C==998 | KJ816C==999
gen CPSNoChng_3_PointEst_`year'=0
replace CPSNoChng_3_PointEst_`year'=1 if CompPctStocksNoChng_3_DkRF_`year'==0

/***************************************
PENSION AT CURRENT JOB #4
***************************************/ 		 
replace PlanType_4_`year'=KJ338D if KJ338D~=.	 

* If DCorDBPlan=1, then DC, if 0 then DB
replace HasDCPlan_4_`year'=1 if KJ393D==1 | KJ393D==2 | (KJ393D>=4 & KJ393D<95)
replace HasDCPlan_4_`year'=. if KJ393D>=95 & KJ393D~=.

replace HasDBPlan_4_`year'=1 if KJ393D==3
replace HasDBPlan_4_`year'=. if KJ393D>=95 & KJ393D~=.	 

/* This is only for people not participating in a plan */
gen     PlanAutoEnroll_4_`year'=.
replace PlanAutoEnroll_4_`year'=1 if KJ820C==2
replace PlanAutoEnroll_4_`year'=0 if KJ820C==1

/***************************************************
 This is plan amount for type A and B account only
***************************************************/
/* No plans in 2006 */
gen PlanAmtNoChng_4_`year'    =     0

/***************************************************
 This is plan amount for type B account (DC) only
***************************************************/
*gen PlanAmtNoChng_4_`year'    =     0
replace PlanAmtNoChng_4_`year'=     KJ413D if KJ413D~=.
replace PlanAmtNoChng_4_`year'=.            if KJ413D==99999996 | KJ413D==99999998 | KJ413D==99999999
gen PlanAmtNoChng_4_DkRf_`year'=0
replace PlanAmtNoChng_4_DkRf_`year'=1 if PlanAmtNoChng_4_`year'==.
gen PlanAmtNoChng_4_PointEst_`year'=0
replace PlanAmtNoChng_4_PointEst_`year'=1 if PlanAmtNoChng_4_DkRf_`year'==0

/* No obs to bin in 2006*/

/***********************************************************
 This is plan stock allocation for type B account (DC) only
***********************************************************/

gen PlanPctStocksNoChng_4_`year'=0
replace PlanPctStocksNoChng_4_`year'=KJ812D if KJ812D~=.
replace PlanPctStocksNoChng_4_`year'=. if KJ812D==998 | KJ812D==999
gen PlanPctStocksNoChng_4_DkRF_`year'=0
replace PlanPctStocksNoChng_4_DkRF_`year'=1 if KJ812D==998 | KJ812D==999
gen PPS_NoChng_4_PointEst_`year'=0
replace PPS_NoChng_4_PointEst_`year'=1 if PlanPctStocksNoChng_4_DkRF_`year'==0

/* No obs to bin in 2006*/

/***************************************
 DORMANT PLANS FROM PREVIOUS JOBS
***************************************/
gen HasDormPlan_`year'=0
/* DB plans */
replace HasDormPlan_`year'=1 if  KJ434A1==1  | KJ434A2==1   | KJ434A3==1   | KJ434A4==1
replace HasDormPlan_`year'=. if (KJ434A1==8  & KJ434A1==9)  | (KJ434A2==8 & KJ434A2==9) | (KJ434A3==8 & KJ434A3==9) | ///
                                (KJ434A4==8  & KJ434A4==9)
								
replace HasDormPlan_`year'=1 if  KJ434B1==1  | KJ434B2==1   | KJ434B3==1
replace HasDormPlan_`year'=. if (KJ434B1==8  & KJ434B1==9)  | (KJ434B2==8 & KJ434B2==9) | (KJ434B3==8 & KJ434B3==9)

replace HasDormPlan_`year'=1 if  KJ434C1==1  | KJ434C2==1
replace HasDormPlan_`year'=. if (KJ434C1==8  & KJ434C1==9)  | (KJ434C2==8 & KJ434C2==9)

replace HasDormPlan_`year'=1 if  KJ434D1==1  | KJ434D2==1
replace HasDormPlan_`year'=. if (KJ434D1==8  & KJ434D1==9)  | (KJ434D2==8 & KJ434D2==9)               

/* DC plans */
replace HasDormPlan_`year'=1 if  KJ450A1==1  | KJ450A2==1   | KJ450A3==1   | KJ450A4==1  
replace HasDormPlan_`year'=. if (KJ450A1>=95 & KJ450A1<=99) | (KJ450A2>=95 & KJ450A2<=99) | (KJ450A3>=95 & KJ450A3<=99) | ///
                                (KJ450A4>=95 & KJ450A4<=99) 
								
replace HasDormPlan_`year'=1 if  KJ450B1==1  | KJ450B2==1   | KJ450B3==1
replace HasDormPlan_`year'=. if (KJ450B1>=95 & KJ450B1<=99) | (KJ450B2>=95 & KJ450B2<=99) | (KJ450B3>=95 & KJ450B3<=99)

replace HasDormPlan_`year'=1 if  KJ450C1==1  | KJ450C2==1   | KJ450C3==1
replace HasDormPlan_`year'=. if (KJ450C1>=95 & KJ450C1<=99) | (KJ450C2>=95 & KJ450C2<=99) | (KJ450C3>=95 & KJ450C3<=99)
  
replace HasDormPlan_`year'=1 if  KJ450D1==1  | KJ450D2==1
replace HasDormPlan_`year'=. if (KJ450D1>=95 & KJ450D1<=99) | (KJ450D2>=95 & KJ450D2<=99)


/***************************************
 DORMANT PENSION #1
***************************************/
gen     DormHasDCPlan_1_`year'=0
replace DormHasDCPlan_1_`year'=1 if  KJ450A1==1  | KJ450A2==1   | KJ450A3==1   | KJ450A4==1   
replace DormHasDCPlan_1_`year'=. if (KJ450A1>=95 & KJ450A1<=99) | (KJ450A2>=95 & KJ450A2<=99) | (KJ450A3>=95 & KJ450A3<=99) | ///
                                    (KJ450A4>=95 & KJ450A4<=99) 

gen     DormHasDBPlan_1_`year'=0
replace DormHasDBPlan_1_`year'=1 if  KJ434A1==1  | KJ434A2==1   | KJ434A3==1   | KJ434A4==1
replace DormHasDBPlan_1_`year'=. if (KJ434A1==8  & KJ434A1==9)  | (KJ434A2==8 & KJ434A2==9) | (KJ434A3==8 & KJ434A3==9) | ///
                                    (KJ434A4==8  & KJ434A4==9)

gen double DormPlanAmt_1_`year'=0
replace    DormPlanAmt_1_`year'=KJ465A if KJ465A~=.

quietly sum DormPlanAmt_1_`year' if DormPlanAmt_1_`year'<=99999998, det
local MaxPlanAmt=r(max)

gen double DormPlanAmt_1_DkRf_`year'=0
replace DormPlanAmt_1_DkRf_`year'=1 if DormPlanAmt_1_`year'==99999998 | DormPlanAmt_1_`year'==99999999
replace DormPlanAmt_1_`year'=. if DormPlanAmt_1_DkRf_`year'==1

gen double DormPlanAmt_1_PointEst_`year'=0
replace DormPlanAmt_1_PointEst_`year'=1 if DormPlanAmt_1_`year'~=.

/* # of missings is verfied by codebook. 9/25, DB */
gen double DormPlan_1_minval=KJ466A
gen double DormPlan_1_maxval=KJ467A

local binmin0   0
local binmin1   5001
local binmin2   20001
local binmin3   50001
local binmin4   150001
local binmax0   4999
local binmax1   19999
local binmax2   49999
local binmax3   149999
local binmax4   99999996
local binexact1 5000
local binexact2 20000
local binexact3 50000
local binexact4 150000

/* Generating exact values here */
replace DormPlanAmt_1_`year'=`binexact1' if DormPlan_1_minval==`binexact1' & DormPlan_1_maxval==`binexact1'
replace DormPlanAmt_1_`year'=`binexact2' if DormPlan_1_minval==`binexact2' & DormPlan_1_maxval==`binexact2'
replace DormPlanAmt_1_`year'=`binexact3' if DormPlan_1_minval==`binexact3' & DormPlan_1_maxval==`binexact3'
replace DormPlanAmt_1_`year'=`binexact4' if DormPlan_1_minval==`binexact4' & DormPlan_1_maxval==`binexact4'

* Generate bins
forval num=0/4{
    sum DormPlanAmt_1_`year' if DormPlanAmt_1_PointEst_`year'==1 & DormPlanAmt_1_`year' > `binmin`num'' & DormPlanAmt_1_`year' < `binmax`num'', detail
    cap assert r(N)>`impute_numobs'
    if _rc{
        replace DormPlanAmt_1_`year'=r(p$bin_pctile) if DormPlan_1_minval==`binmin`num'' & DormPlan_1_maxval==`binmax`num''
    }
    else{
        replace DormPlanAmt_1_`year'=(`binmin`num''+`binmin`num'')/2 if DormPlan_1_minval==`binmin`num'' & DormPlan_1_maxval==`binmax`num''
    }
}

/***************************************
 DORMANT PENSION #2
***************************************/
gen     DormHasDCPlan_2_`year'=0
replace DormHasDCPlan_2_`year'=1 if  KJ450B1==1  | KJ450B2==1   | KJ450B3==1
replace DormHasDCPlan_2_`year'=. if (KJ450B1>=95 & KJ450B1<=99) | (KJ450B2>=95 & KJ450B2<=99) | (KJ450B3>=95 & KJ450B3<=99)

gen     DormHasDBPlan_2_`year'=0
replace DormHasDBPlan_2_`year'=1 if  KJ434B1==1  | KJ434B2==1   | KJ434B3==1
replace DormHasDBPlan_2_`year'=. if (KJ434B1==8  & KJ434B1==9)  | (KJ434B2==8 & KJ434B2==9) | (KJ434B3==8 & KJ434B3==9)
                                    

gen double DormPlanAmt_2_`year'=0
replace    DormPlanAmt_2_`year'=KJ465B if KJ465B~=.

quietly sum DormPlanAmt_2_`year' if DormPlanAmt_2_`year'<=99999998, det
local MaxPlanAmt=r(max)

gen double DormPlanAmt_2_DkRf_`year'=0
replace DormPlanAmt_2_DkRf_`year'=1 if DormPlanAmt_2_`year'==99999998 | DormPlanAmt_2_`year'==99999999
replace DormPlanAmt_2_`year'=. if DormPlanAmt_2_DkRf_`year'==1

gen double DormPlanAmt_2_PointEst_`year'=0
replace DormPlanAmt_2_PointEst_`year'=1 if DormPlanAmt_2_`year'~=.

/* # of missings is verfied by codebook. 9/25, DB */
gen double DormPlan_2_minval=KJ466B
gen double DormPlan_2_maxval=KJ467B

local binmin0   0
local binmin1   5001
local binmin2   20001
local binmin3   50001
local binmin4   150001
local binmax0   4999
local binmax1   19999
local binmax2   49999
local binmax3   149999
local binmax4   99999996
local binexact1 5000
local binexact2 20000
local binexact3 50000
local binexact4 150000

/* Generating exact values here */
replace DormPlanAmt_2_`year'=`binexact1' if DormPlan_2_minval==`binexact1' & DormPlan_2_maxval==`binexact1'
replace DormPlanAmt_2_`year'=`binexact2' if DormPlan_2_minval==`binexact2' & DormPlan_2_maxval==`binexact2'
replace DormPlanAmt_2_`year'=`binexact3' if DormPlan_2_minval==`binexact3' & DormPlan_2_maxval==`binexact3'
replace DormPlanAmt_2_`year'=`binexact4' if DormPlan_2_minval==`binexact4' & DormPlan_2_maxval==`binexact4'

* Generate bins
forval num=0/4{
    sum DormPlanAmt_2_`year' if DormPlanAmt_2_PointEst_`year'==1 & DormPlanAmt_2_`year' > `binmin`num'' & DormPlanAmt_2_`year' < `binmax`num'', detail
    cap assert r(N)>`impute_numobs'
    if _rc{
        replace DormPlanAmt_2_`year'=r(p$bin_pctile) if DormPlan_2_minval==`binmin`num'' & DormPlan_2_maxval==`binmax`num''
    }
    else{
        replace DormPlanAmt_2_`year'=(`binmin`num''+`binmin`num'')/2 if DormPlan_2_minval==`binmin`num'' & DormPlan_2_maxval==`binmax`num''
    }
}

/***************************************
 DORMANT PENSION #3
***************************************/
gen     DormHasDCPlan_3_`year'=0
replace DormHasDCPlan_3_`year'=1 if  KJ450C1==1  | KJ450C2==1   | KJ450C3==1
replace DormHasDCPlan_3_`year'=. if (KJ450C1>=95 & KJ450C1<=99) | (KJ450C2>=95 & KJ450C2<=99) | (KJ450C3>=95 & KJ450C3<=99)

gen     DormHasDBPlan_3_`year'=0
replace DormHasDBPlan_3_`year'=1 if  KJ434C1==1  | KJ434C2==1
replace DormHasDBPlan_3_`year'=. if (KJ434C1==8  & KJ434C1==9)  | (KJ434C2==8 & KJ434C2==9)
                                    

gen double DormPlanAmt_3_`year'=0
replace    DormPlanAmt_3_`year'=KJ465C if KJ465C~=.

quietly sum DormPlanAmt_3_`year' if DormPlanAmt_3_`year'<=99999998, det
local MaxPlanAmt=r(max)

gen double DormPlanAmt_3_DkRf_`year'=0
replace DormPlanAmt_3_DkRf_`year'=1 if DormPlanAmt_3_`year'==99999998 | DormPlanAmt_3_`year'==99999999
replace DormPlanAmt_3_`year'=. if DormPlanAmt_3_DkRf_`year'==1

gen double DormPlanAmt_3_PointEst_`year'=0
replace DormPlanAmt_3_PointEst_`year'=1 if DormPlanAmt_3_`year'~=.

/* # of missings is verfied by codebook. 9/25, DB */
gen double DormPlan_3_minval=KJ466C
gen double DormPlan_3_maxval=KJ467C

local binmin0   0
local binmin1   5001
local binmin2   20001
local binmin3   50001
local binmin4   150001
local binmax0   4999
local binmax1   19999
local binmax2   49999
local binmax3   149999
local binmax4   99999996
local binexact1 5000
local binexact2 20000
local binexact3 50000
local binexact4 150000

/* Generating exact values here */
replace DormPlanAmt_3_`year'=`binexact1' if DormPlan_3_minval==`binexact1' & DormPlan_3_maxval==`binexact1'
replace DormPlanAmt_3_`year'=`binexact2' if DormPlan_3_minval==`binexact2' & DormPlan_3_maxval==`binexact2'
replace DormPlanAmt_3_`year'=`binexact3' if DormPlan_3_minval==`binexact3' & DormPlan_3_maxval==`binexact3'
replace DormPlanAmt_3_`year'=`binexact4' if DormPlan_3_minval==`binexact4' & DormPlan_3_maxval==`binexact4'

* Generate bins
forval num=0/4{
    sum DormPlanAmt_3_`year' if DormPlanAmt_3_PointEst_`year'==1 & DormPlanAmt_3_`year' > `binmin`num'' & DormPlanAmt_3_`year' < `binmax`num'', detail
    cap assert r(N)>`impute_numobs'
    if _rc{
        replace DormPlanAmt_3_`year'=r(p$bin_pctile) if DormPlan_3_minval==`binmin`num'' & DormPlan_3_maxval==`binmax`num''
    }
    else{
        replace DormPlanAmt_3_`year'=(`binmin`num''+`binmin`num'')/2 if DormPlan_3_minval==`binmin`num'' & DormPlan_3_maxval==`binmax`num''
    }
}

/***************************************
 DORMANT PENSION #4
***************************************/
gen     DormHasDCPlan_4_`year'=0
replace DormHasDCPlan_4_`year'=1 if  KJ450D1==1  | KJ450D2==1
replace DormHasDCPlan_4_`year'=. if (KJ450D1>=95 & KJ450D1<=99) | (KJ450D2>=95 & KJ450D2<=99)

gen     DormHasDBPlan_4_`year'=0
replace DormHasDBPlan_4_`year'=1 if  KJ434D1==1  | KJ434D2==1
replace DormHasDBPlan_4_`year'=. if (KJ434D1==8  & KJ434D1==9)  | (KJ434D2==8 & KJ434D2==9)
                                    

gen double DormPlanAmt_4_`year'=0
replace    DormPlanAmt_4_`year'=KJ465D if KJ465D~=.

quietly sum DormPlanAmt_4_`year' if DormPlanAmt_4_`year'<=99999998, det
local MaxPlanAmt=r(max)

gen double DormPlanAmt_4_DkRf_`year'=0
replace DormPlanAmt_4_DkRf_`year'=1 if DormPlanAmt_4_`year'==99999998 | DormPlanAmt_4_`year'==99999999
replace DormPlanAmt_4_`year'=. if DormPlanAmt_4_DkRf_`year'==1

gen double DormPlanAmt_4_PointEst_`year'=0
replace DormPlanAmt_4_PointEst_`year'=1 if DormPlanAmt_4_`year'~=.

/* # of missings is verfied by codebook. 9/25, DB */
gen double DormPlan_4_minval=KJ466D
gen double DormPlan_4_maxval=KJ467D

local binmin0   0
local binmin1   5001
local binmin2   20001
local binmin3   50001
local binmin4   150001
local binmax0   4999
local binmax1   19999
local binmax2   49999
local binmax3   149999
local binmax4   99999996
local binexact1 5000
local binexact2 20000
local binexact3 50000
local binexact4 150000

/* Generating exact values here */
replace DormPlanAmt_4_`year'=`binexact1' if DormPlan_4_minval==`binexact1' & DormPlan_4_maxval==`binexact1'
replace DormPlanAmt_4_`year'=`binexact2' if DormPlan_4_minval==`binexact2' & DormPlan_4_maxval==`binexact2'
replace DormPlanAmt_4_`year'=`binexact3' if DormPlan_4_minval==`binexact3' & DormPlan_4_maxval==`binexact3'
replace DormPlanAmt_4_`year'=`binexact4' if DormPlan_4_minval==`binexact4' & DormPlan_4_maxval==`binexact4'

* Generate bins
forval num=0/4{
    sum DormPlanAmt_4_`year' if DormPlanAmt_4_PointEst_`year'==1 & DormPlanAmt_4_`year' > `binmin`num'' & DormPlanAmt_4_`year' < `binmax`num'', detail
    cap assert r(N)>`impute_numobs'
    if _rc{
        replace DormPlanAmt_4_`year'=r(p$bin_pctile) if DormPlan_4_minval==`binmin`num'' & DormPlan_4_maxval==`binmax`num''
    }
    else{
        replace DormPlanAmt_4_`year'=(`binmin`num''+`binmin`num'')/2 if DormPlan_4_minval==`binmin`num'' & DormPlan_4_maxval==`binmax`num''
    }
}

/****************************************************************************
       AGGREGATES
****************************************************************************/
gen TotPrevPenAmt_`year' = PrevPlanAmt_1_`year' + PrevPlanAmt_2_`year' + PrevPlanAmt_3_`year' + PrevPlanAmt_4_`year' 

gen TotCurrPenAmt_`year' = PlanAmtNoChng_1_`year' + PlanAmtNoChng_2_`year' + PlanAmtNoChng_3_`year'+ PlanAmtNoChng_4_`year' 

gen TotDormPenAmt_`year' = DormPlanAmt_1_`year' + DormPlanAmt_2_`year' + DormPlanAmt_3_`year' + DormPlanAmt_4_`year' 

gen TotAllPenAmt_`year'  = TotPrevPenAmt_`year' + TotCurrPenAmt_`year' + TotDormPenAmt_`year'


gen PlanStockDoll_`year' = (PlanPctStocks_1_`year'/100)*PlanAmt_1_`year' + (PlanPctStocks_2_`year'/100)*PlanAmt_2_`year' + ///
                               (PlanPctStocks_3_`year'/100)*PlanAmt_3_`year' + (PlanPctStocks_4_`year'/100)*PlanAmt_4_`year' + ///
							   (PlanPctStocksNoChng_1_`year'/100)*PlanAmtNoChng_1_`year'                                     + ///
							   (PlanPctStocksNoChng_2_`year'/100)*PlanAmtNoChng_2_`year'                                     + ///
							   (PlanPctStocksNoChng_3_`year'/100)*PlanAmtNoChng_3_`year'                                     + ///
							   (PlanPctStocksNoChng_4_`year'/100)*PlanAmtNoChng_4_`year'
							   
gen     PlanStockTotPct_`year'=0
replace PlanStockTotPct_`year'=PlanStockDoll_`year'/TotAllPenAmt_`year' if TotAllPenAmt_`year'>0 

gen     HasDB_`year'=0
replace HasDB_`year'=1 if HasDBPlan_1_`year'==1     | HasDBPlan_2_`year'==1     | HasDBPlan_3_`year'==1     | HasDBPlan_4_`year'==1 | ///
                          PrevEmpDBPlan_1_`year'==1 | PrevEmpDBPlan_2_`year'==1 | PrevEmpDBPlan_3_`year'==1 | PrevEmpDBPlan_4_`year'==1 | ///
                          DormHasDBPlan_1_`year'==1 | DormHasDBPlan_2_`year'==1 | DormHasDBPlan_3_`year'==1 | DormHasDBPlan_4_`year'==1 

gen     HasDC_`year'=0
replace HasDC_`year'=1 if HasDCPlan_1_`year'==1     | HasDCPlan_2_`year'==1     | HasDCPlan_3_`year'==1     | HasDCPlan_4_`year'==1 | ///
                          PrevEmpDCPlan_1_`year'==1 | PrevEmpDCPlan_2_`year'==1 | PrevEmpDCPlan_3_`year'==1 | PrevEmpDCPlan_4_`year'==1 | ///
                          DormHasDCPlan_1_`year'==1 | DormHasDCPlan_2_`year'==1 | DormHasDCPlan_3_`year'==1 | DormHasDCPlan_4_`year'==1 


keep HHID SUBHH PN HasDB_`year' HasDC_`year' TotAllPenAmt_`year' PlanStockDoll_`year' PrevEmpPens_`year'
save "$CleanData/Pension`year'.dta", replace
