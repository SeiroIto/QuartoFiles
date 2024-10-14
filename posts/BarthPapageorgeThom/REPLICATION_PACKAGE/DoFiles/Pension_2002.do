/***********************************************************************************************************************************************************
															cURRENT JOb (SEcTION J)
***********************************************************************************************************************************************************/
clear all
infile using "$HRSSurveys02/h02sta/H02J_R.dct" , using("$HRSSurveys02/h02da/H02J_R.da")
local year "2002"
gen YEAR=`year'
sort HHID HSUBHH
gen SUBHH=HSUBHH

local flag=0
local impute_numobs=0

/****************************************************************************
 Job change since last wave or no?
****************************************************************************/ 
gen SameEmployer_`year' =.
replace SameEmployer_`year'=1 if HJ045==1 | HJ045==3
replace SameEmployer_`year'=0 if HJ045==4 | HJ045==5

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
replace PrevEmpPens_`year'=1 if HJ084==1
replace PrevEmpPens_`year'=. if HJ084==8 | HJ084==9

gen PrevEmpNumPlans_`year'=HJ085
replace PrevEmpNumPlans_`year'=. if HJ085>=95
replace PrevEmpNumPlans_`year'=1 if HJ086==1

/***************************************
PENSION 1
***************************************/
gen PrevEmpdbPlan_1_`year'=0
replace PrevEmpdbPlan_1_`year'=1 if HJ090_1==1
replace PrevEmpdbPlan_1_`year'=. if HJ090_1==8 | HJ090_1==9

gen PrevEmpdcPlan_1_`year'=0
replace PrevEmpdcPlan_1_`year'=1 if HJ090_1==2
replace PrevEmpdcPlan_1_`year'=. if HJ090_1==8 | HJ090_1==9

gen double PrevPlanAmt_1_`year'=0
replace    PrevPlanAmt_1_`year'=HJ097_1 if HJ097_1~=.

quietly sum PrevPlanAmt_1_`year' if PrevPlanAmt_1_`year'<=9999998, det
local MaxPrevPlanAmt=r(max)

gen double PrevPlanAmt_1_dkRf_`year'=0
replace PrevPlanAmt_1_dkRf_`year'=1 if PrevPlanAmt_1_`year'==9999998 | PrevPlanAmt_1_`year'==9999999
replace PrevPlanAmt_1_`year'=. if PrevPlanAmt_1_dkRf_`year'==1

gen double PrevPlanAmt_1_PointEst_`year'=0
replace PrevPlanAmt_1_PointEst_`year'=1 if PrevPlanAmt_1_`year'~=.

/* # of missings is verfied by codebook. 9/25, db */
gen double PrevPlan_1_minval=HJ098_1
gen double PrevPlan_1_maxval=HJ099_1

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
gen PrevEmpdbPlan_2_`year'=0
replace PrevEmpdbPlan_2_`year'=1 if HJ090_2==1
replace PrevEmpdbPlan_2_`year'=. if HJ090_2==8 | HJ090_2==9

gen PrevEmpdcPlan_2_`year'=0
replace PrevEmpdcPlan_2_`year'=1 if HJ090_2==2
replace PrevEmpdcPlan_2_`year'=. if HJ090_2==8 | HJ090_2==9

gen double PrevPlanAmt_2_`year'=0
replace    PrevPlanAmt_2_`year'=HJ097_2 if HJ097_2~=.

quietly sum PrevPlanAmt_2_`year' if PrevPlanAmt_2_`year'<=999998, det
local MaxPrevPlanAmt=r(max)

gen double PrevPlanAmt_2_dkRf_`year'=0
replace PrevPlanAmt_2_dkRf_`year'=1 if PrevPlanAmt_2_`year'==999998 | PrevPlanAmt_2_`year'==999999
replace PrevPlanAmt_2_`year'=. if PrevPlanAmt_2_dkRf_`year'==1

gen double PrevPlanAmt_2_PointEst_`year'=0
replace PrevPlanAmt_2_PointEst_`year'=1 if PrevPlanAmt_2_`year'~=.

/* # of missings is verfied by codebook. 9/25, db */
gen double PrevPlan_2_minval=HJ098_2
gen double PrevPlan_2_maxval=HJ099_2

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
gen PrevEmpdbPlan_3_`year'=0
replace PrevEmpdbPlan_3_`year'=1 if HJ090_3==1
replace PrevEmpdbPlan_3_`year'=. if HJ090_3==8 | HJ090_3==9

gen PrevEmpdcPlan_3_`year'=0
replace PrevEmpdcPlan_3_`year'=1 if HJ090_3==2
replace PrevEmpdcPlan_3_`year'=. if HJ090_3==8 | HJ090_3==9

gen double PrevPlanAmt_3_`year'=0
replace    PrevPlanAmt_3_`year'=HJ097_3 if HJ097_3~=.

quietly sum PrevPlanAmt_3_`year' if PrevPlanAmt_3_`year'<=999998, det
local MaxPrevPlanAmt=r(max)

gen double PrevPlanAmt_3_dkRf_`year'=0
replace PrevPlanAmt_3_dkRf_`year'=1 if PrevPlanAmt_3_`year'==999998 | PrevPlanAmt_3_`year'==999999
replace PrevPlanAmt_3_`year'=. if PrevPlanAmt_3_dkRf_`year'==1

gen double PrevPlanAmt_3_PointEst_`year'=0
replace PrevPlanAmt_3_PointEst_`year'=1 if PrevPlanAmt_3_`year'~=.

/* # of missings is verfied by codebook. 9/25, db */
gen double PrevPlan_3_minval=HJ098_3
gen double PrevPlan_3_maxval=HJ099_3

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
gen PrevEmpdbPlan_4_`year'=0
replace PrevEmpdbPlan_4_`year'=1 if HJ090_4==1
replace PrevEmpdbPlan_4_`year'=. if HJ090_4==8 | HJ090_4==9

gen PrevEmpdcPlan_4_`year'=0
replace PrevEmpdcPlan_4_`year'=1 if HJ090_4==2
replace PrevEmpdcPlan_4_`year'=. if HJ090_4==8 | HJ090_4==9

gen double PrevPlanAmt_4_`year'=0
replace    PrevPlanAmt_4_`year'=HJ097_4 if HJ097_4~=.

quietly sum PrevPlanAmt_4_`year' if PrevPlanAmt_4_`year'<=9999998, det
local MaxPrevPlanAmt=r(max)

gen double PrevPlanAmt_4_dkRf_`year'=0
replace PrevPlanAmt_4_dkRf_`year'=1 if PrevPlanAmt_4_`year'==9999998 | PrevPlanAmt_4_`year'==9999999
replace PrevPlanAmt_4_`year'=. if PrevPlanAmt_4_dkRf_`year'==1

gen double PrevPlanAmt_4_PointEst_`year'=0
replace PrevPlanAmt_4_PointEst_`year'=1 if PrevPlanAmt_4_`year'~=.

/****************************************************************************
                         CURRENT JON PENIONS
****************************************************************************/
gen     NumPen_`year'=0
replace NumPen_`year'=HJ269 if HJ269~=.
replace NumPen_`year'=.     if HJ269==98 | HJ269==99
replace NumPen_`year'=1     if HJ270==1

gen     HasPen_`year'=0
replace HasPen_`year'=1     if NumPen_`year'>0
replace HasPen_`year'=.     if NumPen_`year'==.


/***************************************
  PENSION AT CURRENT JOB #1
***************************************/
gen PlanType_1_`year'=HJ272_1		 
		 
* If dcordbPlan=1, then dc, if 0 then db
gen     HasdcPlan_1_`year'=0
replace HasdcPlan_1_`year'=1 if HJ272_1==2 | HJ272_1==3
replace HasdcPlan_1_`year'=. if HJ272_1>=8 & HJ272_1~=.

gen     HasdbPlan_1_`year'=0
replace HasdbPlan_1_`year'=1 if HJ272_1==1 | HJ272_1==3
replace HasdbPlan_1_`year'=. if HJ272_1>=8 & HJ272_1~=.
 
/***************************************************
 This is plan amount for type a&b account, the (dc) part only
***************************************************/
gen PlanAmt_1_`year'    =     0
replace PlanAmt_1_`year'=     HJ273_1 if HJ273_1~=.
replace PlanAmt_1_`year'=.           if HJ273_1==999998 | HJ273_1==999999
gen PlanAmt_aandb_1_dkRf_`year'=0
replace PlanAmt_aandb_1_dkRf_`year'=1 if PlanAmt_1_`year'==.
gen PlanAmt_aandb_1_PointEst_`year'=0
replace PlanAmt_aandb_1_PointEst_`year'=1 if PlanAmt_aandb_1_dkRf_`year'==0

gen double Plan_aandb_1_minval=HJ274_1
gen double Plan_aandb_1_maxval=HJ275_1

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
replace PlanAmt_1_`year'=`binexact1' if Plan_aandb_1_minval==`binexact1' & Plan_aandb_1_maxval==`binexact1'
replace PlanAmt_1_`year'=`binexact2' if Plan_aandb_1_minval==`binexact2' & Plan_aandb_1_maxval==`binexact2'
replace PlanAmt_1_`year'=`binexact3' if Plan_aandb_1_minval==`binexact3' & Plan_aandb_1_maxval==`binexact3'
replace PlanAmt_1_`year'=`binexact4' if Plan_aandb_1_minval==`binexact4' & Plan_aandb_1_maxval==`binexact4'

* Generate bins
forval num=0/4{
    sum PlanAmt_1_`year' if PlanAmt_aandb_1_PointEst_`year'==1 & PlanAmt_1_`year' > `binmin`num'' & PlanAmt_1_`year' < `binmax`num'', detail
    cap assert r(N)>`impute_numobs'
    if _rc{
        replace PlanAmt_1_`year'=r(p$bin_pctile) if Plan_aandb_1_minval==`binmin`num'' & Plan_aandb_1_maxval==`binmax`num''
    }
    else{
        replace PlanAmt_1_`year'=(`binmin`num''+`binmin`num'')/2 if Plan_aandb_1_minval==`binmin`num'' & Plan_aandb_1_maxval==`binmax`num''
    }
}

/***************************************************
 This is plan amount for type b plan (dc) only
***************************************************/
replace PlanAmt_1_`year'=     HJ307_1 if HJ307_1~=.
replace PlanAmt_1_`year'=.           if HJ307_1==99999998 | HJ307_1==99999999
gen PlanAmt_1_dkRf_`year'=0
replace PlanAmt_1_dkRf_`year'=1 if PlanAmt_1_`year'==.
gen PlanAmt_1_PointEst_`year'=0
replace PlanAmt_1_PointEst_`year'=1 if PlanAmt_1_dkRf_`year'==0

gen double Plan_1_minval=HJ308_1
gen double Plan_1_maxval=HJ309_1

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

/***************************************
PENSION AT CURRENT JOB #2
***************************************/
gen PlanType_2_`year'=HJ272_2		 
		 
* If dcordbPlan=1, then dc, if 0 then db
gen     HasdcPlan_2_`year'=0
replace HasdcPlan_2_`year'=1 if HJ272_2==2 | HJ272_2==3
replace HasdcPlan_2_`year'=. if HJ272_2>=8 & HJ272_2~=.

gen     HasdbPlan_2_`year'=0
replace HasdbPlan_2_`year'=1 if HJ272_2==1 | HJ272_2==3
replace HasdbPlan_2_`year'=. if HJ272_2>=8 & HJ272_2~=.

/***************************************************
 This is plan amount for type a&b account, the (dc) part only
***************************************************/
gen PlanAmt_2_`year'    =     0
replace PlanAmt_2_`year'=     HJ273_2 if HJ273_2~=.
replace PlanAmt_2_`year'=.           if HJ273_2==999998 | HJ273_2==999999
gen PlanAmt_aandb_2_dkRf_`year'=0
replace PlanAmt_aandb_2_dkRf_`year'=1 if PlanAmt_2_`year'==.
gen PlanAmt_aandb_2_PointEst_`year'=0
replace PlanAmt_aandb_2_PointEst_`year'=1 if PlanAmt_aandb_2_dkRf_`year'==0

gen double Plan_aandb_2_minval=HJ274_2
gen double Plan_aandb_2_maxval=HJ275_2

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
replace PlanAmt_2_`year'=`binexact1' if Plan_aandb_2_minval==`binexact1' & Plan_aandb_2_maxval==`binexact1'
replace PlanAmt_2_`year'=`binexact2' if Plan_aandb_2_minval==`binexact2' & Plan_aandb_2_maxval==`binexact2'
replace PlanAmt_2_`year'=`binexact3' if Plan_aandb_2_minval==`binexact3' & Plan_aandb_2_maxval==`binexact3'
replace PlanAmt_2_`year'=`binexact4' if Plan_aandb_2_minval==`binexact4' & Plan_aandb_2_maxval==`binexact4'

* Generate bins
forval num=0/4{
    sum PlanAmt_2_`year' if PlanAmt_aandb_2_PointEst_`year'==1 & PlanAmt_2_`year' > `binmin`num'' & PlanAmt_2_`year' < `binmax`num'', detail
    cap assert r(N)>`impute_numobs'
    if _rc{
        replace PlanAmt_2_`year'=r(p$bin_pctile) if Plan_aandb_2_minval==`binmin`num'' & Plan_aandb_2_maxval==`binmax`num''
    }
    else{
        replace PlanAmt_2_`year'=(`binmin`num''+`binmin`num'')/2 if Plan_aandb_2_minval==`binmin`num'' & Plan_aandb_2_maxval==`binmax`num''
    }
}

/***************************************************
 This is plan amount for type b plan (dc) only
***************************************************/
replace PlanAmt_2_`year'=     HJ307_2 if HJ307_2~=.
replace PlanAmt_2_`year'=.           if HJ307_2==9999998 | HJ307_2==9999999
gen PlanAmt_2_dkRf_`year'=0
replace PlanAmt_2_dkRf_`year'=1 if PlanAmt_2_`year'==.
gen PlanAmt_2_PointEst_`year'=0
replace PlanAmt_2_PointEst_`year'=1 if PlanAmt_2_dkRf_`year'==0

gen double Plan_2_minval=HJ308_2
gen double Plan_2_maxval=HJ309_2

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

/***************************************
PENSION AT CURRENT JOB #3
***************************************/
gen PlanType_3_`year'=HJ272_3		 
		 
* If dcordbPlan=1, then dc, if 0 then db
gen     HasdcPlan_3_`year'=0
replace HasdcPlan_3_`year'=1 if HJ272_3==2 | HJ272_3==3
replace HasdcPlan_3_`year'=. if HJ272_3>=8 & HJ272_3~=.

gen     HasdbPlan_3_`year'=0
replace HasdbPlan_3_`year'=1 if HJ272_3==1 | HJ272_3==3
replace HasdbPlan_3_`year'=. if HJ272_3>=8 & HJ272_3~=.

/***************************************************
 This is plan amount for type a&b account, the (dc) part only
***************************************************/
gen PlanAmt_3_`year'    =     0
replace PlanAmt_3_`year'=     HJ273_3 if HJ273_3~=.
replace PlanAmt_3_`year'=.           if HJ273_3==999998 | HJ273_3==999999
gen PlanAmt_aandb_3_dkRf_`year'=0
replace PlanAmt_aandb_3_dkRf_`year'=1 if PlanAmt_3_`year'==.
gen PlanAmt_aandb_3_PointEst_`year'=0
replace PlanAmt_aandb_3_PointEst_`year'=1 if PlanAmt_aandb_3_dkRf_`year'==0

/***************************************************
 This is plan amount for type b plan (dc) only
***************************************************/
replace PlanAmt_3_`year'=     HJ307_3 if HJ307_3~=.
replace PlanAmt_3_`year'=.           if HJ307_3==-2 | HJ307_3==999998 | HJ307_3==999999
gen PlanAmt_3_dkRf_`year'=0
replace PlanAmt_3_dkRf_`year'=1 if PlanAmt_3_`year'==.
gen PlanAmt_3_PointEst_`year'=0
replace PlanAmt_3_PointEst_`year'=1 if PlanAmt_3_dkRf_`year'==0

gen double Plan_3_minval=HJ308_3
gen double Plan_3_maxval=HJ309_3

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

/***************************************
PENSION AT CURRENT JOB #4
***************************************/
gen PlanType_4_`year'=HJ272_4		 
		 
* If dcordbPlan=1, then dc, if 0 then db
gen     HasdcPlan_4_`year'=0
replace HasdcPlan_4_`year'=1 if HJ272_4==2 | HJ272_4==3
replace HasdcPlan_4_`year'=. if HJ272_4>=8 & HJ272_4~=.

gen     HasdbPlan_4_`year'=0
replace HasdbPlan_4_`year'=1 if HJ272_4==1 | HJ272_4==3
replace HasdbPlan_4_`year'=. if HJ272_4>=8 & HJ272_4~=.


/***************************************************
 This is plan amount for type a&b account, the (dc) part only
***************************************************/
/* No obs in 2006
   --------------- */
gen PlanAmt_4_`year'    =     0
replace PlanAmt_4_`year'=     HJ273_4 if HJ273_4~=.
replace PlanAmt_4_`year'=.           if HJ273_4==8 | HJ273_4==9
gen PlanAmt_aandb_4_dkRf_`year'=0
replace PlanAmt_aandb_4_dkRf_`year'=1 if PlanAmt_4_`year'==.
gen PlanAmt_aandb_4_PointEst_`year'=0
replace PlanAmt_aandb_4_PointEst_`year'=1 if PlanAmt_aandb_4_dkRf_`year'==0

/****************************************************************************
                         IF DID NOT CHANGE JOBS
****************************************************************************/

/***************************************
PENSION AT CURRENT JOb #1
***************************************/ 		 
replace PlanType_1_`year'=HJ338_1 if HJ338_1~=.	 

* If dcordbPlan=1, then dc, if 0 then db
replace HasdcPlan_1_`year'=1 if HJ393_1==1 | HJ393_1==2 | (HJ393_1>=4 & HJ393_1<95)
replace HasdcPlan_1_`year'=. if HJ393_1>=95 & HJ393_1~=.

replace HasdbPlan_1_`year'=1 if HJ393_1==3
replace HasdbPlan_1_`year'=. if HJ393_1>=95 & HJ393_1~=.	 

/***************************************************
 This is plan amount for type a and b account only
***************************************************/
gen PlanAmtNochng_1_`year'    =     0
replace PlanAmtNochng_1_`year'=      HJ339_1 if HJ339_1~=.
replace PlanAmtNochng_1_`year'=.            if HJ339_1==999998 | HJ339_1==999999
gen PlanAmtNochng_aandb_1_dkRf_`year'=0
replace PlanAmtNochng_aandb_1_dkRf_`year'=1 if PlanAmtNochng_1_`year'==.
gen PaNochng_aandb_1_PointEst_`year'=0
replace PaNochng_aandb_1_PointEst_`year'=1 if PlanAmtNochng_aandb_1_dkRf_`year'==0

gen double PlanNochng_aandb_1_minval=HJ340_1
gen double PlanNochng_aandb_1_maxval=HJ341_1

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
replace PlanAmtNochng_1_`year'=`binexact1' if PlanNochng_aandb_1_minval==`binexact1' & PlanNochng_aandb_1_maxval==`binexact1'
replace PlanAmtNochng_1_`year'=`binexact2' if PlanNochng_aandb_1_minval==`binexact2' & PlanNochng_aandb_1_maxval==`binexact2'
replace PlanAmtNochng_1_`year'=`binexact3' if PlanNochng_aandb_1_minval==`binexact3' & PlanNochng_aandb_1_maxval==`binexact3'
replace PlanAmtNochng_1_`year'=`binexact4' if PlanNochng_aandb_1_minval==`binexact4' & PlanNochng_aandb_1_maxval==`binexact4'

* Generate bins
forval num=0/4{
    sum PlanAmtNochng_1_`year' if PaNochng_aandb_1_PointEst_`year'==1 & PlanAmtNochng_1_`year' > `binmin`num'' & PlanAmtNochng_1_`year' < `binmax`num'', detail
    cap assert r(N)>`impute_numobs'
    if _rc{
        replace PlanAmtNochng_1_`year'=r(p$bin_pctile) if PlanNochng_aandb_1_minval==`binmin`num'' & PlanNochng_aandb_1_maxval==`binmax`num''
    }
    else{
        replace PlanAmtNochng_1_`year'=(`binmin`num''+`binmin`num'')/2 if PlanNochng_aandb_1_minval==`binmin`num'' & PlanNochng_aandb_1_maxval==`binmax`num''
    }
}

/***************************************************
 This is plan amount for type b account (dc) only
***************************************************/
replace PlanAmtNochng_1_`year'=     HJ413_1 if HJ413_1~=.
replace PlanAmtNochng_1_`year'=.            if HJ413_1==9999998 | HJ413_1==9999999
gen PlanAmtNochng_1_dkRf_`year'=0
replace PlanAmtNochng_1_dkRf_`year'=1 if PlanAmtNochng_1_`year'==.
gen PlanAmtNochng_1_PointEst_`year'=0
replace PlanAmtNochng_1_PointEst_`year'=1 if PlanAmtNochng_1_dkRf_`year'==0

gen double PlanNochng_1_minval=HJ414_1
gen double PlanNochng_1_maxval=HJ415_1

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
replace PlanAmtNochng_1_`year'=`binexact1' if PlanNochng_1_minval==`binexact1' & PlanNochng_1_maxval==`binexact1'
replace PlanAmtNochng_1_`year'=`binexact2' if PlanNochng_1_minval==`binexact2' & PlanNochng_1_maxval==`binexact2'
replace PlanAmtNochng_1_`year'=`binexact3' if PlanNochng_1_minval==`binexact3' & PlanNochng_1_maxval==`binexact3'
replace PlanAmtNochng_1_`year'=`binexact4' if PlanNochng_1_minval==`binexact4' & PlanNochng_1_maxval==`binexact4'

* Generate bins
forval num=0/4{
    sum PlanAmtNochng_1_`year' if PlanAmtNochng_1_PointEst_`year'==1 & PlanAmtNochng_1_`year' > `binmin`num'' & PlanAmtNochng_1_`year' < `binmax`num'', detail
    cap assert r(N)>`impute_numobs'
    if _rc{
        replace PlanAmtNochng_1_`year'=r(p$bin_pctile) if PlanNochng_1_minval==`binmin`num'' & PlanNochng_1_maxval==`binmax`num''
    }
    else{
        replace PlanAmtNochng_1_`year'=(`binmin`num''+`binmin`num'')/2 if PlanNochng_1_minval==`binmin`num'' & PlanNochng_1_maxval==`binmax`num''
    }
}

/***********************************************************
 This is plan stock allocation for type b account (dc) only
***********************************************************/
gen PlanPctStocksNochng_1_`year'=0
replace PlanPctStocksNochng_1_`year'= 1 if HJ418_1==1
replace PlanPctStocksNochng_1_`year'=.5 if HJ418_1==3
replace PlanPctStocksNochng_1_`year'=.  if HJ418_1==8 | HJ418_1==9
gen PlanPctStocksNochng_1_dkRF_`year'=0
replace PlanPctStocksNochng_1_dkRF_`year'=1 if HJ418_1==7 | HJ418_1==8 | HJ418_1==9
gen PPS_Nochng_1_PointEst_`year'=0
replace PPS_Nochng_1_PointEst_`year'=1 if PlanPctStocksNochng_1_dkRF_`year'==0

/***************************************
PENSION AT CURRENT JOB #2
***************************************/ 		 
replace PlanType_2_`year'=HJ338_2 if HJ338_2~=.	 

* If dcordbPlan=1, then dc, if 0 then db
replace HasdcPlan_2_`year'=1 if HJ393_2==1 | HJ393_2==2 | (HJ393_2>=4 & HJ393_2<95)
replace HasdcPlan_2_`year'=. if HJ393_2>=95 & HJ393_2~=.

replace HasdbPlan_2_`year'=1 if HJ393_2==3
replace HasdbPlan_2_`year'=. if HJ393_2>=95 & HJ393_2~=.	 

/***************************************************
 This is plan amount for type a and b account only
***************************************************/
gen PlanAmtNochng_2_`year'    =     0
replace PlanAmtNochng_2_`year'=      HJ339_2 if HJ339_2~=.
replace PlanAmtNochng_2_`year'=.            if HJ339_2==999998 | HJ339_2==999999
gen PlanAmtNochng_aandb_2_dkRf_`year'=0
replace PlanAmtNochng_aandb_2_dkRf_`year'=1 if PlanAmtNochng_2_`year'==.
gen PaNochng_aandb_2_PointEst_`year'=0
replace PaNochng_aandb_2_PointEst_`year'=1 if PlanAmtNochng_aandb_2_dkRf_`year'==0

gen double PlanNochng_aandb_2_minval=HJ340_2
gen double PlanNochng_aandb_2_maxval=HJ341_2

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
replace PlanAmtNochng_2_`year'=`binexact1' if PlanNochng_aandb_2_minval==`binexact1' & PlanNochng_aandb_2_maxval==`binexact1'
replace PlanAmtNochng_2_`year'=`binexact2' if PlanNochng_aandb_2_minval==`binexact2' & PlanNochng_aandb_2_maxval==`binexact2'
replace PlanAmtNochng_2_`year'=`binexact3' if PlanNochng_aandb_2_minval==`binexact3' & PlanNochng_aandb_2_maxval==`binexact3'
replace PlanAmtNochng_2_`year'=`binexact4' if PlanNochng_aandb_2_minval==`binexact4' & PlanNochng_aandb_2_maxval==`binexact4'

* Generate bins
forval num=0/4{
    sum PlanAmtNochng_2_`year' if PaNochng_aandb_2_PointEst_`year'==1 & PlanAmtNochng_2_`year' > `binmin`num'' & PlanAmtNochng_2_`year' < `binmax`num'', detail
    cap assert r(N)>`impute_numobs'
    if _rc{
        replace PlanAmtNochng_2_`year'=r(p$bin_pctile) if PlanNochng_aandb_2_minval==`binmin`num'' & PlanNochng_aandb_2_maxval==`binmax`num''
    }
    else{
        replace PlanAmtNochng_2_`year'=(`binmin`num''+`binmin`num'')/2 if PlanNochng_aandb_2_minval==`binmin`num'' & PlanNochng_aandb_2_maxval==`binmax`num''
    }
}

/***************************************************
 This is plan amount for type b account (dc) only
***************************************************/
replace PlanAmtNochng_2_`year'=     HJ413_2 if HJ413_2~=.
replace PlanAmtNochng_2_`year'=.            if HJ413_2==999998 | HJ413_2==999999
gen PlanAmtNochng_2_dkRf_`year'=0
replace PlanAmtNochng_2_dkRf_`year'=1 if PlanAmtNochng_2_`year'==.
gen PlanAmtNochng_2_PointEst_`year'=0
replace PlanAmtNochng_2_PointEst_`year'=1 if PlanAmtNochng_2_dkRf_`year'==0

gen double PlanNochng_2_minval=HJ414_2
gen double PlanNochng_2_maxval=HJ415_2

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
replace PlanAmtNochng_2_`year'=`binexact1' if PlanNochng_2_minval==`binexact1' & PlanNochng_2_maxval==`binexact1'
replace PlanAmtNochng_2_`year'=`binexact2' if PlanNochng_2_minval==`binexact2' & PlanNochng_2_maxval==`binexact2'
replace PlanAmtNochng_2_`year'=`binexact3' if PlanNochng_2_minval==`binexact3' & PlanNochng_2_maxval==`binexact3'
replace PlanAmtNochng_2_`year'=`binexact4' if PlanNochng_2_minval==`binexact4' & PlanNochng_2_maxval==`binexact4'

* Generate bins
forval num=0/4{
    sum PlanAmtNochng_2_`year' if PlanAmtNochng_2_PointEst_`year'==1 & PlanAmtNochng_2_`year' > `binmin`num'' & PlanAmtNochng_2_`year' < `binmax`num'', detail
    cap assert r(N)>`impute_numobs'
    if _rc{
        replace PlanAmtNochng_2_`year'=r(p$bin_pctile) if PlanNochng_2_minval==`binmin`num'' & PlanNochng_2_maxval==`binmax`num''
    }
    else{
        replace PlanAmtNochng_2_`year'=(`binmin`num''+`binmin`num'')/2 if PlanNochng_2_minval==`binmin`num'' & PlanNochng_2_maxval==`binmax`num''
    }
}

/***********************************************************
 This is plan stock allocation for type b account (dc) only
***********************************************************/
gen PlanPctStocksNochng_2_`year'=0
replace PlanPctStocksNochng_2_`year'= 1 if HJ418_2==1
replace PlanPctStocksNochng_2_`year'=.5 if HJ418_2==3
replace PlanPctStocksNochng_2_`year'=.  if HJ418_2==8 | HJ418_2==9
gen PlanPctStocksNochng_2_dkRF_`year'=0
replace PlanPctStocksNochng_2_dkRF_`year'=1 if HJ418_2==7 | HJ418_2==8 | HJ418_2==9
gen PPS_Nochng_2_PointEst_`year'=0
replace PPS_Nochng_2_PointEst_`year'=1 if PlanPctStocksNochng_2_dkRF_`year'==0

/***************************************
PENSION AT CURRENT JOB #3
***************************************/ 		 
replace PlanType_3_`year'=HJ338_3 if HJ338_3~=.	 

* If dcordbPlan=1, then dc, if 0 then db
replace HasdcPlan_3_`year'=1 if HJ393_3==1 | HJ393_3==2 | (HJ393_3>=4 & HJ393_3<95)
replace HasdcPlan_3_`year'=. if HJ393_3>=95 & HJ393_3~=.

replace HasdbPlan_3_`year'=1 if HJ393_3==3
replace HasdbPlan_3_`year'=. if HJ393_3>=95 & HJ393_3~=.	 

/***************************************************
 This is plan amount for type a and b account only
***************************************************/
gen PlanAmtNochng_3_`year'    =     0

/***************************************************
 This is plan amount for type b account (dc) only
***************************************************/
replace PlanAmtNochng_3_`year'=     HJ413_3 if HJ413_3~=.
replace PlanAmtNochng_3_`year'=.            if HJ413_3==99998 | HJ413_3==99999
gen PlanAmtNochng_3_dkRf_`year'=0
replace PlanAmtNochng_3_dkRf_`year'=1 if PlanAmtNochng_3_`year'==.
gen PlanAmtNochng_3_PointEst_`year'=0
replace PlanAmtNochng_3_PointEst_`year'=1 if PlanAmtNochng_3_dkRf_`year'==0

gen double PlanNochng_3_minval=HJ414_3
gen double PlanNochng_3_maxval=HJ415_3

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
replace PlanAmtNochng_3_`year'=`binexact1' if PlanNochng_3_minval==`binexact1' & PlanNochng_3_maxval==`binexact1'
replace PlanAmtNochng_3_`year'=`binexact2' if PlanNochng_3_minval==`binexact2' & PlanNochng_3_maxval==`binexact2'
replace PlanAmtNochng_3_`year'=`binexact3' if PlanNochng_3_minval==`binexact3' & PlanNochng_3_maxval==`binexact3'
replace PlanAmtNochng_3_`year'=`binexact4' if PlanNochng_3_minval==`binexact4' & PlanNochng_3_maxval==`binexact4'

* Generate bins
forval num=0/4{
    sum PlanAmtNochng_3_`year' if PlanAmtNochng_3_PointEst_`year'==1 & PlanAmtNochng_3_`year' > `binmin`num'' & PlanAmtNochng_3_`year' < `binmax`num'', detail
    cap assert r(N)>`impute_numobs'
    if _rc{
        replace PlanAmtNochng_3_`year'=r(p$bin_pctile) if PlanNochng_3_minval==`binmin`num'' & PlanNochng_3_maxval==`binmax`num''
    }
    else{
        replace PlanAmtNochng_3_`year'=(`binmin`num''+`binmin`num'')/2 if PlanNochng_3_minval==`binmin`num'' & PlanNochng_3_maxval==`binmax`num''
    }
}

/***********************************************************
 This is plan stock allocation for type b account (dc) only
***********************************************************/
gen PlanPctStocksNochng_3_`year'=0
replace PlanPctStocksNochng_3_`year'= 1 if HJ418_3==1
replace PlanPctStocksNochng_3_`year'=.5 if HJ418_3==3
replace PlanPctStocksNochng_3_`year'=.  if HJ418_3==8 | HJ418_3==9
gen PlanPctStocksNochng_3_dkRF_`year'=0
replace PlanPctStocksNochng_3_dkRF_`year'=1 if HJ418_3==7 | HJ418_3==8 | HJ418_3==9
gen PPS_Nochng_3_PointEst_`year'=0
replace PPS_Nochng_3_PointEst_`year'=1 if PlanPctStocksNochng_3_dkRF_`year'==0

/***************************************
PENSION AT CURRENT JOB #4
***************************************/ 		 
replace PlanType_4_`year'=HJ338_4 if HJ338_4~=.	 

* If dcordbPlan=1, then dc, if 0 then db
replace HasdcPlan_4_`year'=1 if HJ393_4==1 | HJ393_4==2 | (HJ393_4>=4 & HJ393_4<95)
replace HasdcPlan_4_`year'=. if HJ393_4>=95 & HJ393_4~=.

replace HasdbPlan_4_`year'=1 if HJ393_4==3
replace HasdbPlan_4_`year'=. if HJ393_4>=95 & HJ393_4~=.	 

/***************************************************
 This is plan amount for type a and b account only
***************************************************/
gen PlanAmtNochng_4_`year'    =     0

/***************************************************
 This is plan amount for type b account (dc) only
***************************************************/
replace PlanAmtNochng_4_`year'=     HJ413_4 if HJ413_4~=.
replace PlanAmtNochng_4_`year'=.            if HJ413_4==8 | HJ413_4==9
gen PlanAmtNochng_4_dkRf_`year'=0
replace PlanAmtNochng_4_dkRf_`year'=1 if PlanAmtNochng_4_`year'==.
gen PlanAmtNochng_4_PointEst_`year'=0
replace PlanAmtNochng_4_PointEst_`year'=1 if PlanAmtNochng_4_dkRf_`year'==0

/***********************************************************
 This is plan stock allocation for type b account (dc) only
***********************************************************/
gen PlanPctStocksNochng_4_`year'=0
replace PlanPctStocksNochng_4_`year'= 1 if HJ418_4==1
replace PlanPctStocksNochng_4_`year'=.5 if HJ418_4==3
replace PlanPctStocksNochng_4_`year'=.  if HJ418_4==8 | HJ418_4==9
gen PlanPctStocksNochng_4_dkRF_`year'=0
replace PlanPctStocksNochng_4_dkRF_`year'=1 if HJ418_4==7 | HJ418_4==8 | HJ418_4==9
gen PPS_Nochng_4_PointEst_`year'=0
replace PPS_Nochng_4_PointEst_`year'=1 if PlanPctStocksNochng_4_dkRF_`year'==0

/***************************************
 DORMaNT PLANS FROM PREVIOUS JOBS
***************************************/

gen HasdormPlan_`year'=0
/* db plans */
replace HasdormPlan_`year'=1 if  HJ434_1A==1  | HJ434_1B==1   | HJ434_1C==1
replace HasdormPlan_`year'=. if (HJ434_1A==8  & HJ434_1A==9)  | (HJ434_1B==8 & HJ434_1B==9) | (HJ434_1C==8 & HJ434_1C==9)
                                
								
replace HasdormPlan_`year'=1 if  HJ434_2A==1  | HJ434_2B==1   | HJ434_2C==1
replace HasdormPlan_`year'=. if (HJ434_2A==8  & HJ434_2A==9)  | (HJ434_2B==8 & HJ434_2B==9) | (HJ434_2C==8 & HJ434_2C==9)

replace HasdormPlan_`year'=1 if  HJ434_3A==1  | HJ434_3B==1
replace HasdormPlan_`year'=. if (HJ434_3A==8  & HJ434_3A==9)  | (HJ434_3B==8 & HJ434_3B==9)

replace HasdormPlan_`year'=1 if  HJ434_4A==1  | HJ434_4B==1
replace HasdormPlan_`year'=. if (HJ434_4A==8  & HJ434_4A==9)  | (HJ434_4B==8 & HJ434_4B==9)               

/* dc plans */
replace HasdormPlan_`year'=1 if  HJ450_1A==1  | HJ450_1B==1   | HJ450_1C==1   | HJ450_1D==1  
replace HasdormPlan_`year'=. if (HJ450_1A>=95 & HJ450_1A<=99) | (HJ450_1B>=95 & HJ450_1B<=99) | (HJ450_1C>=95 & HJ450_1C<=99) | ///
                                (HJ450_1D>=95 & HJ450_1D<=99)
								
replace HasdormPlan_`year'=1 if  HJ450_2A==1  | HJ450_2B==1   | HJ450_2C==1
replace HasdormPlan_`year'=. if (HJ450_2A>=95 & HJ450_2A<=99) | (HJ450_2B>=95 & HJ450_2B<=99) | (HJ450_2C>=95 & HJ450_2C<=99)

replace HasdormPlan_`year'=1 if  HJ450_3A==1  | HJ450_3B==1   | HJ450_3C==1
replace HasdormPlan_`year'=. if (HJ450_3A>=95 & HJ450_3A<=99) | (HJ450_3B>=95 & HJ450_3B<=99) | (HJ450_3C>=95 & HJ450_3C<=99)
  
replace HasdormPlan_`year'=1 if  HJ450_4A==1  | HJ450_4B==1
replace HasdormPlan_`year'=. if (HJ450_4A>=95 & HJ450_4A<=99) | (HJ450_4B>=95 & HJ450_4B<=99)


/***************************************
 DORMANT PENSION #1
***************************************/
gen     dormHasdcPlan_1_`year'=0
replace dormHasdcPlan_1_`year'=1 if  HJ450_1A==1  | HJ450_1B==1   | HJ450_1C==1   | HJ450_1D==1 
replace dormHasdcPlan_1_`year'=. if (HJ450_1A>=95 & HJ450_1A<=99) | (HJ450_1B>=95 & HJ450_1B<=99) | (HJ450_1C>=95 & HJ450_1C<=99) | ///
                                    (HJ450_1D>=95 & HJ450_1D<=99)

gen     dormHasdbPlan_1_`year'=0
replace dormHasdbPlan_1_`year'=1 if  HJ434_1A==1  | HJ434_1B==1   | HJ434_1C==1
replace dormHasdbPlan_1_`year'=. if (HJ434_1A==8  & HJ434_1A==9)  | (HJ434_1B==8 & HJ434_1B==9) | (HJ434_1C==8 & HJ434_1C==9)

gen double dormPlanAmt_1_`year'=0
replace    dormPlanAmt_1_`year'=HJ465_1 if HJ465_1~=.

quietly sum dormPlanAmt_1_`year' if dormPlanAmt_1_`year'<=999998, det
local MaxPlanAmt=r(max)

gen double dormPlanAmt_1_dkRf_`year'=0
replace dormPlanAmt_1_dkRf_`year'=1 if dormPlanAmt_1_`year'==999998 | dormPlanAmt_1_`year'==999999
replace dormPlanAmt_1_`year'=. if dormPlanAmt_1_dkRf_`year'==1

gen double dormPlanAmt_1_PointEst_`year'=0
replace dormPlanAmt_1_PointEst_`year'=1 if dormPlanAmt_1_`year'~=.

/* # of missings is verfied by codebook. 9/25, db */
gen double dormPlan_1_minval=HJ466_1
gen double dormPlan_1_maxval=HJ467_1

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
replace dormPlanAmt_1_`year'=`binexact1' if dormPlan_1_minval==`binexact1' & dormPlan_1_maxval==`binexact1'
replace dormPlanAmt_1_`year'=`binexact2' if dormPlan_1_minval==`binexact2' & dormPlan_1_maxval==`binexact2'
replace dormPlanAmt_1_`year'=`binexact3' if dormPlan_1_minval==`binexact3' & dormPlan_1_maxval==`binexact3'
replace dormPlanAmt_1_`year'=`binexact4' if dormPlan_1_minval==`binexact4' & dormPlan_1_maxval==`binexact4'

* Generate bins
forval num=0/4{
    sum dormPlanAmt_1_`year' if dormPlanAmt_1_PointEst_`year'==1 & dormPlanAmt_1_`year' > `binmin`num'' & dormPlanAmt_1_`year' < `binmax`num'', detail
    cap assert r(N)>`impute_numobs'
    if _rc{
        replace dormPlanAmt_1_`year'=r(p$bin_pctile) if dormPlan_1_minval==`binmin`num'' & dormPlan_1_maxval==`binmax`num''
    }
    else{
        replace dormPlanAmt_1_`year'=(`binmin`num''+`binmin`num'')/2 if dormPlan_1_minval==`binmin`num'' & dormPlan_1_maxval==`binmax`num''
    }
}

/***************************************
DORMANT PENSION #2
***************************************/
gen     dormHasdcPlan_2_`year'=0
replace dormHasdcPlan_2_`year'=1 if  HJ450_2A==1  | HJ450_2B==1   | HJ450_2C==1
replace dormHasdcPlan_2_`year'=. if (HJ450_2A>=95 & HJ450_2A<=99) | (HJ450_2B>=95 & HJ450_2B<=99) | (HJ450_2C>=95 & HJ450_2C<=99)

gen     dormHasdbPlan_2_`year'=0
replace dormHasdbPlan_2_`year'=1 if  HJ434_2A==1  | HJ434_2B==1   | HJ434_2C==1
replace dormHasdbPlan_2_`year'=. if (HJ434_2A==8  & HJ434_2A==9)  | (HJ434_2B==8 & HJ434_2B==9) | (HJ434_2C==8 & HJ434_2C==9)                       

gen double dormPlanAmt_2_`year'=0
replace    dormPlanAmt_2_`year'=HJ465_2 if HJ465_2~=.

quietly sum dormPlanAmt_2_`year' if dormPlanAmt_2_`year'<=999998, det
local MaxPlanAmt=r(max)

gen double dormPlanAmt_2_dkRf_`year'=0
replace dormPlanAmt_2_dkRf_`year'=1 if dormPlanAmt_2_`year'==999998 | dormPlanAmt_2_`year'==999999
replace dormPlanAmt_2_`year'=. if dormPlanAmt_2_dkRf_`year'==1

gen double dormPlanAmt_2_PointEst_`year'=0
replace dormPlanAmt_2_PointEst_`year'=1 if dormPlanAmt_2_`year'~=.

/* # of missings is verfied by codebook. 9/25, db */
gen double dormPlan_2_minval=HJ466_2
gen double dormPlan_2_maxval=HJ467_2

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
replace dormPlanAmt_2_`year'=`binexact1' if dormPlan_2_minval==`binexact1' & dormPlan_2_maxval==`binexact1'
replace dormPlanAmt_2_`year'=`binexact2' if dormPlan_2_minval==`binexact2' & dormPlan_2_maxval==`binexact2'
replace dormPlanAmt_2_`year'=`binexact3' if dormPlan_2_minval==`binexact3' & dormPlan_2_maxval==`binexact3'
replace dormPlanAmt_2_`year'=`binexact4' if dormPlan_2_minval==`binexact4' & dormPlan_2_maxval==`binexact4'

* Generate bins
forval num=0/4{
    sum dormPlanAmt_2_`year' if dormPlanAmt_2_PointEst_`year'==1 & dormPlanAmt_2_`year' > `binmin`num'' & dormPlanAmt_2_`year' < `binmax`num'', detail
    cap assert r(N)>`impute_numobs'
    if _rc{
        replace dormPlanAmt_2_`year'=r(p$bin_pctile) if dormPlan_2_minval==`binmin`num'' & dormPlan_2_maxval==`binmax`num''
    }
    else{
        replace dormPlanAmt_2_`year'=(`binmin`num''+`binmin`num'')/2 if dormPlan_2_minval==`binmin`num'' & dormPlan_2_maxval==`binmax`num''
    }
}

/***************************************
DORMANT PENSION #3
***************************************/
gen     dormHasdcPlan_3_`year'=0
replace dormHasdcPlan_3_`year'=1 if  HJ450_3A==1  | HJ450_3B==1   | HJ450_3C==1
replace dormHasdcPlan_3_`year'=. if (HJ450_3A>=95 & HJ450_3A<=99) | (HJ450_3B>=95 & HJ450_3B<=99) | (HJ450_3C>=95 & HJ450_3C<=99)

gen     dormHasdbPlan_3_`year'=0
replace dormHasdbPlan_3_`year'=1 if  HJ434_3A==1  | HJ434_3B==1
replace dormHasdbPlan_3_`year'=. if (HJ434_3A==8  & HJ434_3A==9)  | (HJ434_3B==8 & HJ434_3B==9)
                                    
gen double dormPlanAmt_3_`year'=0
replace    dormPlanAmt_3_`year'=HJ465_3 if HJ465_3~=.

quietly sum dormPlanAmt_3_`year' if dormPlanAmt_3_`year'<=99998, det
local MaxPlanAmt=r(max)

gen double dormPlanAmt_3_dkRf_`year'=0
replace dormPlanAmt_3_dkRf_`year'=1 if dormPlanAmt_3_`year'==99998 | dormPlanAmt_3_`year'==99999
replace dormPlanAmt_3_`year'=. if dormPlanAmt_3_dkRf_`year'==1

gen double dormPlanAmt_3_PointEst_`year'=0
replace dormPlanAmt_3_PointEst_`year'=1 if dormPlanAmt_3_`year'~=.

/* # of missings is verfied by codebook. 9/25, db */
gen double dormPlan_3_minval=HJ466_3
gen double dormPlan_3_maxval=HJ467_3

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
replace dormPlanAmt_3_`year'=`binexact1' if dormPlan_3_minval==`binexact1' & dormPlan_3_maxval==`binexact1'
replace dormPlanAmt_3_`year'=`binexact2' if dormPlan_3_minval==`binexact2' & dormPlan_3_maxval==`binexact2'
replace dormPlanAmt_3_`year'=`binexact3' if dormPlan_3_minval==`binexact3' & dormPlan_3_maxval==`binexact3'
replace dormPlanAmt_3_`year'=`binexact4' if dormPlan_3_minval==`binexact4' & dormPlan_3_maxval==`binexact4'

* Generate bins
forval num=0/4{
    sum dormPlanAmt_3_`year' if dormPlanAmt_3_PointEst_`year'==1 & dormPlanAmt_3_`year' > `binmin`num'' & dormPlanAmt_3_`year' < `binmax`num'', detail
    cap assert r(N)>`impute_numobs'
    if _rc{
        replace dormPlanAmt_3_`year'=r(p$bin_pctile) if dormPlan_3_minval==`binmin`num'' & dormPlan_3_maxval==`binmax`num''
    }
    else{
        replace dormPlanAmt_3_`year'=(`binmin`num''+`binmin`num'')/2 if dormPlan_3_minval==`binmin`num'' & dormPlan_3_maxval==`binmax`num''
    }
}

/***************************************
DORMANT PENSION #4
***************************************/
/* Only one obs that cannot be imputed in 2008 */
gen     dormHasdcPlan_4_`year'=0
replace dormHasdcPlan_4_`year'=1 if  HJ450_4A==1  | HJ450_4B==1
replace dormHasdcPlan_4_`year'=. if (HJ450_4A>=95 & HJ450_4A<=99) | (HJ450_4B>=95 & HJ450_4B<=99)

gen     dormHasdbPlan_4_`year'=0
replace dormHasdbPlan_4_`year'=1 if  HJ434_4A==1  | HJ434_4B==1
replace dormHasdbPlan_4_`year'=. if (HJ434_4A==8  & HJ434_4A==9)  | (HJ434_4B==8 & HJ434_4B==9)                          

gen double dormPlanAmt_4_`year'=0
replace    dormPlanAmt_4_`year'=HJ465_4 if HJ465_4~=.

quietly sum dormPlanAmt_4_`year' if dormPlanAmt_4_`year'<=8, det
local MaxPlanAmt=r(max)

gen double dormPlanAmt_4_dkRf_`year'=0
replace dormPlanAmt_4_dkRf_`year'=1 if dormPlanAmt_4_`year'==8 | dormPlanAmt_4_`year'==9
replace dormPlanAmt_4_`year'=. if dormPlanAmt_4_dkRf_`year'==1

gen double dormPlanAmt_4_PointEst_`year'=0
replace dormPlanAmt_4_PointEst_`year'=1 if dormPlanAmt_4_`year'~=.

/****************************************************************************
       AGGREGATES
****************************************************************************/
gen TotPrevPenAmt_`year' = PrevPlanAmt_1_`year' + PrevPlanAmt_2_`year' + PrevPlanAmt_3_`year' + PrevPlanAmt_4_`year' 

gen TotcurrPenAmt_`year' = PlanAmtNochng_1_`year' + PlanAmtNochng_2_`year' + PlanAmtNochng_3_`year'+ PlanAmtNochng_4_`year' 

gen TotdormPenAmt_`year' = dormPlanAmt_1_`year' + dormPlanAmt_2_`year' + dormPlanAmt_3_`year' + dormPlanAmt_4_`year' 

gen TotAllPenAmt_`year'  = TotPrevPenAmt_`year' + TotcurrPenAmt_`year' + TotdormPenAmt_`year'


gen PlanStockDoll_`year' =     (PlanPctStocksNochng_1_`year'/100)*PlanAmtNochng_1_`year'                                     + ///
							   (PlanPctStocksNochng_2_`year'/100)*PlanAmtNochng_2_`year'                                     + ///
							   (PlanPctStocksNochng_3_`year'/100)*PlanAmtNochng_3_`year'                                     + ///
							   (PlanPctStocksNochng_4_`year'/100)*PlanAmtNochng_4_`year'
							   
gen     PlanStockTotPct_`year'=0
replace PlanStockTotPct_`year'=PlanStockDoll_`year'/TotAllPenAmt_`year' if TotAllPenAmt_`year'>0 

gen     HasDB_`year'=0
replace HasDB_`year'=1 if HasdbPlan_1_`year'==1     | HasdbPlan_2_`year'==1     | HasdbPlan_3_`year'==1     | HasdbPlan_4_`year'==1 | ///
                          PrevEmpdbPlan_1_`year'==1 | PrevEmpdbPlan_2_`year'==1 | PrevEmpdbPlan_3_`year'==1 | PrevEmpdbPlan_4_`year'==1 | ///
                          dormHasdbPlan_1_`year'==1 | dormHasdbPlan_2_`year'==1 | dormHasdbPlan_3_`year'==1 | dormHasdbPlan_4_`year'==1 

gen     HasDC_`year'=0
replace HasDC_`year'=1 if HasdcPlan_1_`year'==1     | HasdcPlan_2_`year'==1     | HasdcPlan_3_`year'==1     | HasdcPlan_4_`year'==1 | ///
                          PrevEmpdcPlan_1_`year'==1 | PrevEmpdcPlan_2_`year'==1 | PrevEmpdcPlan_3_`year'==1 | PrevEmpdcPlan_4_`year'==1 | ///
                          dormHasdcPlan_1_`year'==1 | dormHasdcPlan_2_`year'==1 | dormHasdcPlan_3_`year'==1 | dormHasdcPlan_4_`year'==1 


keep HHID SUBHH PN HasDB_`year' HasDC_`year' TotAllPenAmt_`year' PlanStockDoll_`year' PrevEmpPens_`year'
save "$CleanData/Pension`year'.dta", replace
