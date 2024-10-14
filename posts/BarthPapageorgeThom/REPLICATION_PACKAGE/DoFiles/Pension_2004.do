/***********************************************************************************************************************************************************
															CURRENT JOB (SECTION J)
***********************************************************************************************************************************************************/
clear all
infile using "$HRSSurveys04/h04sta/H04J_R.dct" , using("$HRSSurveys04/h04da/H04J_R.da")
local year "2004"
gen YEAR=`year'
sort HHID JSUBHH
gen SUBHH=JSUBHH

local flag=0
local impute_numobs=0

/****************************************************************************
 Job change since last wave or no?
****************************************************************************/ 
gen SameEmployer_`year' =.
replace SameEmployer_`year'=1 if JJ045==1 | JJ045==3
replace SameEmployer_`year'=0 if JJ045==4 | JJ045==5

/****************************************************************************
                                  PENSIONS
****************************************************************************/

/****************************************************************************
                        IF CHANGED JOBS ONLY
****************************************************************************/


/****************************************************************************
                         PREVIOUS JOb PENIONS
****************************************************************************/
gen PrevEmpPens_`year'=0
replace PrevEmpPens_`year'=1 if JJ084==1
replace PrevEmpPens_`year'=. if JJ084==8 | JJ084==9

gen PrevEmpNumPlans_`year'=JJ085
replace PrevEmpNumPlans_`year'=. if JJ085>=95
replace PrevEmpNumPlans_`year'=1 if JJ086==1

/***************************************
PENSION 1
***************************************/
gen PrevEmpdbPlan_1_`year'=0
replace PrevEmpdbPlan_1_`year'=1 if JJW001a==1
replace PrevEmpdbPlan_1_`year'=. if JJW001a==8 | JJW001a==9

gen PrevEmpdcPlan_1_`year'=0
replace PrevEmpdcPlan_1_`year'=1 if JJW001a==2
replace PrevEmpdcPlan_1_`year'=. if JJW001a==8 | JJW001a==9

gen double PrevPlanamt_1_`year'=0
replace    PrevPlanamt_1_`year'=JJW009a if JJW009a~=.

quietly sum PrevPlanamt_1_`year' if PrevPlanamt_1_`year'<=999998, det
local MaxPrevPlanamt=r(max)

gen double PrevPlanamt_1_dkRf_`year'=0
replace PrevPlanamt_1_dkRf_`year'=1 if PrevPlanamt_1_`year'==999998 | PrevPlanamt_1_`year'==999999
replace PrevPlanamt_1_`year'=. if PrevPlanamt_1_dkRf_`year'==1

gen double PrevPlanamt_1_PointEst_`year'=0
replace PrevPlanamt_1_PointEst_`year'=1 if PrevPlanamt_1_`year'~=.

/* # of missings is verfied by codebook. 9/25, db */
gen double PrevPlan_1_minval=JJW010a
gen double PrevPlan_1_maxval=JJW011a

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
replace PrevPlanamt_1_`year'=`binexact1' if PrevPlan_1_minval==`binexact1' & PrevPlan_1_maxval==`binexact1'
replace PrevPlanamt_1_`year'=`binexact2' if PrevPlan_1_minval==`binexact2' & PrevPlan_1_maxval==`binexact2'
replace PrevPlanamt_1_`year'=`binexact3' if PrevPlan_1_minval==`binexact3' & PrevPlan_1_maxval==`binexact3'
replace PrevPlanamt_1_`year'=`binexact4' if PrevPlan_1_minval==`binexact4' & PrevPlan_1_maxval==`binexact4'

* Generate bins
forval num=0/4{
    sum PrevPlanamt_1_`year' if PrevPlanamt_1_PointEst_`year'==1 & PrevPlanamt_1_`year' > `binmin`num'' & PrevPlanamt_1_`year' < `binmax`num'', detail
    cap assert r(N)>`impute_numobs'
    if _rc{
        replace PrevPlanamt_1_`year'=r(p$bin_pctile) if PrevPlan_1_minval==`binmin`num'' & PrevPlan_1_maxval==`binmax`num''
    }
    else{
        replace PrevPlanamt_1_`year'=(`binmin`num''+`binmin`num'')/2 if PrevPlan_1_minval==`binmin`num'' & PrevPlan_1_maxval==`binmax`num''
    }
}

/***************************************
PENSION 2
***************************************/
gen PrevEmpdbPlan_2_`year'=0
replace PrevEmpdbPlan_2_`year'=1 if JJW001b==1
replace PrevEmpdbPlan_2_`year'=. if JJW001b==8 | JJW001b==9

gen PrevEmpdcPlan_2_`year'=0
replace PrevEmpdcPlan_2_`year'=1 if JJW001b==2
replace PrevEmpdcPlan_2_`year'=. if JJW001b==8 | JJW001b==9

gen double PrevPlanamt_2_`year'=0
replace    PrevPlanamt_2_`year'=JJW009b if JJW009b~=.

quietly sum PrevPlanamt_2_`year' if PrevPlanamt_2_`year'<=999998, det
local MaxPrevPlanamt=r(max)

gen double PrevPlanamt_2_dkRf_`year'=0
replace PrevPlanamt_2_dkRf_`year'=1 if PrevPlanamt_2_`year'==999998 | PrevPlanamt_2_`year'==999999
replace PrevPlanamt_2_`year'=. if PrevPlanamt_2_dkRf_`year'==1

gen double PrevPlanamt_2_PointEst_`year'=0
replace PrevPlanamt_2_PointEst_`year'=1 if PrevPlanamt_2_`year'~=.

/* # of missings is verfied by codebook. 9/25, db */
gen double PrevPlan_2_minval=JJW010b
gen double PrevPlan_2_maxval=JJW011b

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
replace PrevPlanamt_2_`year'=`binexact1' if PrevPlan_2_minval==`binexact1' & PrevPlan_2_maxval==`binexact1'
replace PrevPlanamt_2_`year'=`binexact2' if PrevPlan_2_minval==`binexact2' & PrevPlan_2_maxval==`binexact2'
replace PrevPlanamt_2_`year'=`binexact3' if PrevPlan_2_minval==`binexact3' & PrevPlan_2_maxval==`binexact3'
replace PrevPlanamt_2_`year'=`binexact4' if PrevPlan_2_minval==`binexact4' & PrevPlan_2_maxval==`binexact4'

* Generate bins
forval num=0/4{
    sum PrevPlanamt_2_`year' if PrevPlanamt_2_PointEst_`year'==1 & PrevPlanamt_2_`year' > `binmin`num'' & PrevPlanamt_2_`year' < `binmax`num'', detail
    cap assert r(N)>`impute_numobs'
    if _rc{
        replace PrevPlanamt_2_`year'=r(p$bin_pctile) if PrevPlan_2_minval==`binmin`num'' & PrevPlan_2_maxval==`binmax`num''
    }
    else{
        replace PrevPlanamt_2_`year'=(`binmin`num''+`binmin`num'')/2 if PrevPlan_2_minval==`binmin`num'' & PrevPlan_2_maxval==`binmax`num''
    }
}

/***************************************
PENSION 3
***************************************/
gen PrevEmpdbPlan_3_`year'=0
replace PrevEmpdbPlan_3_`year'=1 if JJW001c==1
replace PrevEmpdbPlan_3_`year'=. if JJW001c==8 | JJW001c==9

gen PrevEmpdcPlan_3_`year'=0
replace PrevEmpdcPlan_3_`year'=1 if JJW001c==2
replace PrevEmpdcPlan_3_`year'=. if JJW001c==8 | JJW001c==9

gen double PrevPlanamt_3_`year'=0
replace    PrevPlanamt_3_`year'=JJW009c if JJW009c~=.

quietly sum PrevPlanamt_3_`year' if PrevPlanamt_3_`year'<=999998, det
local MaxPrevPlanamt=r(max)

gen double PrevPlanamt_3_dkRf_`year'=0
replace PrevPlanamt_3_dkRf_`year'=1 if PrevPlanamt_3_`year'==999998 | PrevPlanamt_3_`year'==999999
replace PrevPlanamt_3_`year'=. if PrevPlanamt_3_dkRf_`year'==1

gen double PrevPlanamt_3_PointEst_`year'=0
replace PrevPlanamt_3_PointEst_`year'=1 if PrevPlanamt_3_`year'~=.

/* # of missings is verfied by codebook. 9/25, db */
gen double PrevPlan_3_minval=JJW010c
gen double PrevPlan_3_maxval=JJW011c

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
replace PrevPlanamt_3_`year'=`binexact1' if PrevPlan_3_minval==`binexact1' & PrevPlan_3_maxval==`binexact1'
replace PrevPlanamt_3_`year'=`binexact2' if PrevPlan_3_minval==`binexact2' & PrevPlan_3_maxval==`binexact2'
replace PrevPlanamt_3_`year'=`binexact3' if PrevPlan_3_minval==`binexact3' & PrevPlan_3_maxval==`binexact3'
replace PrevPlanamt_3_`year'=`binexact4' if PrevPlan_3_minval==`binexact4' & PrevPlan_3_maxval==`binexact4'

* Generate bins
forval num=0/4{
    sum PrevPlanamt_3_`year' if PrevPlanamt_3_PointEst_`year'==1 & PrevPlanamt_3_`year' > `binmin`num'' & PrevPlanamt_3_`year' < `binmax`num'', detail
    cap assert r(N)>`impute_numobs'
    if _rc{
        replace PrevPlanamt_3_`year'=r(p$bin_pctile) if PrevPlan_3_minval==`binmin`num'' & PrevPlan_3_maxval==`binmax`num''
    }
    else{
        replace PrevPlanamt_3_`year'=(`binmin`num''+`binmin`num'')/2 if PrevPlan_3_minval==`binmin`num'' & PrevPlan_3_maxval==`binmax`num''
    }
}

/***************************************
PENSION 4
***************************************/
gen PrevEmpdbPlan_4_`year'=0
replace PrevEmpdbPlan_4_`year'=1 if JJW001d==1
replace PrevEmpdbPlan_4_`year'=. if JJW001d==8 | JJW001d==9

gen PrevEmpdcPlan_4_`year'=0
replace PrevEmpdcPlan_4_`year'=1 if JJW001d==2
replace PrevEmpdcPlan_4_`year'=. if JJW001d==8 | JJW001d==9

gen double PrevPlanamt_4_`year'=0
replace    PrevPlanamt_4_`year'=JJW009d if JJW009d~=.

quietly sum PrevPlanamt_4_`year' if PrevPlanamt_4_`year'<= 999998, det
local MaxPrevPlanamt=r(max)

gen double PrevPlanamt_4_dkRf_`year'=0
replace PrevPlanamt_4_dkRf_`year'=1 if PrevPlanamt_4_`year'== 999998 | PrevPlanamt_4_`year'==999999
replace PrevPlanamt_4_`year'=. if PrevPlanamt_4_dkRf_`year'==1

gen double PrevPlanamt_4_PointEst_`year'=0
replace PrevPlanamt_4_PointEst_`year'=1 if PrevPlanamt_4_`year'~=.

/****************************************************************************
                         IF DID NOT CHANGE JOBS
****************************************************************************/

/***************************************
PENSION AT CURRENT JOB #1
***************************************/ 		 
gen     PlanType_1_`year'=0
replace PlanType_1_`year'=JJ338a if JJ338a~=.	 

* If dcordbPlan=1, then dc, if 0 then db
gen     HasdcPlan_1_`year'=0
replace HasdcPlan_1_`year'=1 if JJ393a==1 | JJ393a==2 | (JJ393a>=4 & JJ393a<95)
replace HasdcPlan_1_`year'=. if JJ393a>=95 & JJ393a~=.

gen     HasdbPlan_1_`year'=0
replace HasdbPlan_1_`year'=1 if JJ393a==3
replace HasdbPlan_1_`year'=. if JJ393a>=95 & JJ393a~=.	 

/***************************************************
 This is plan amount for type a and b account only
***************************************************/
gen PlanamtNochng_1_`year'    =     0
replace PlanamtNochng_1_`year'=      JJ339a if JJ339a~=.
replace PlanamtNochng_1_`year'=.            if JJ339a==9999996 | JJ339a==9999998 | JJ339a==9999999
gen PlanamtNochng_aandb_1_dkRf_`year'=0
replace PlanamtNochng_aandb_1_dkRf_`year'=1 if PlanamtNochng_1_`year'==.
gen PaNochng_aandb_1_PointEst_`year'=0
replace PaNochng_aandb_1_PointEst_`year'=1 if PlanamtNochng_aandb_1_dkRf_`year'==0

gen double PlanNochng_aandb_1_minval=JJ340a
gen double PlanNochng_aandb_1_maxval=JJ341a

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
replace PlanamtNochng_1_`year'=`binexact1' if PlanNochng_aandb_1_minval==`binexact1' & PlanNochng_aandb_1_maxval==`binexact1'
replace PlanamtNochng_1_`year'=`binexact2' if PlanNochng_aandb_1_minval==`binexact2' & PlanNochng_aandb_1_maxval==`binexact2'
replace PlanamtNochng_1_`year'=`binexact3' if PlanNochng_aandb_1_minval==`binexact3' & PlanNochng_aandb_1_maxval==`binexact3'
replace PlanamtNochng_1_`year'=`binexact4' if PlanNochng_aandb_1_minval==`binexact4' & PlanNochng_aandb_1_maxval==`binexact4'

* Generate bins
forval num=0/4{
    sum PlanamtNochng_1_`year' if PaNochng_aandb_1_PointEst_`year'==1 & PlanamtNochng_1_`year' > `binmin`num'' & PlanamtNochng_1_`year' < `binmax`num'', detail
    cap assert r(N)>`impute_numobs'
    if _rc{
        replace PlanamtNochng_1_`year'=r(p$bin_pctile) if PlanNochng_aandb_1_minval==`binmin`num'' & PlanNochng_aandb_1_maxval==`binmax`num''
    }
    else{
        replace PlanamtNochng_1_`year'=(`binmin`num''+`binmin`num'')/2 if PlanNochng_aandb_1_minval==`binmin`num'' & PlanNochng_aandb_1_maxval==`binmax`num''
    }
}


/***************************************************
 This is plan amount for type b account (dc) only
***************************************************/
replace PlanamtNochng_1_`year'=     JJ413a if JJ413a~=.
replace PlanamtNochng_1_`year'=.            if JJ413a==99999996 | JJ413a==99999998 | JJ413a==99999999
gen PlanamtNochng_1_dkRf_`year'=0
replace PlanamtNochng_1_dkRf_`year'=1 if PlanamtNochng_1_`year'==.
gen PlanamtNochng_1_PointEst_`year'=0
replace PlanamtNochng_1_PointEst_`year'=1 if PlanamtNochng_1_dkRf_`year'==0

gen double PlanNochng_1_minval=JJ414a
gen double PlanNochng_1_maxval=JJ415a

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
replace PlanamtNochng_1_`year'=`binexact1' if PlanNochng_1_minval==`binexact1' & PlanNochng_1_maxval==`binexact1'
replace PlanamtNochng_1_`year'=`binexact2' if PlanNochng_1_minval==`binexact2' & PlanNochng_1_maxval==`binexact2'
replace PlanamtNochng_1_`year'=`binexact3' if PlanNochng_1_minval==`binexact3' & PlanNochng_1_maxval==`binexact3'
replace PlanamtNochng_1_`year'=`binexact4' if PlanNochng_1_minval==`binexact4' & PlanNochng_1_maxval==`binexact4'

* Generate bins
forval num=0/4{
    sum PlanamtNochng_1_`year' if PlanamtNochng_1_PointEst_`year'==1 & PlanamtNochng_1_`year' > `binmin`num'' & PlanamtNochng_1_`year' < `binmax`num'', detail
    cap assert r(N)>`impute_numobs'
    if _rc{
        replace PlanamtNochng_1_`year'=r(p$bin_pctile) if PlanNochng_1_minval==`binmin`num'' & PlanNochng_1_maxval==`binmax`num''
    }
    else{
        replace PlanamtNochng_1_`year'=(`binmin`num''+`binmin`num'')/2 if PlanNochng_1_minval==`binmin`num'' & PlanNochng_1_maxval==`binmax`num''
    }
}


/***********************************************************
 This is plan stock allocation for type b account (dc) only
***********************************************************/
gen PlanPctStocksNochng_1_`year'=0
replace PlanPctStocksNochng_1_`year'= 1 if JJ418a==1
replace PlanPctStocksNochng_1_`year'=.5 if JJ418a==3
replace PlanPctStocksNochng_1_`year'=.  if JJ418a==8 | JJ418a==9
gen PlanPctStocksNochng_1_dkRF_`year'=0
replace PlanPctStocksNochng_1_dkRF_`year'=1 if JJ418a==7 | JJ418a==8 | JJ418a==9
gen PPS_Nochng_1_PointEst_`year'=0
replace PPS_Nochng_1_PointEst_`year'=1 if PlanPctStocksNochng_1_dkRF_`year'==0


/***********************************************************
 This is plan stock allocation in company stock (dc) only
***********************************************************/
gen HasCompStock_1_`year'=0
replace HasCompStock_1_`year'=1 if JJ664a==1
replace HasCompStock_1_`year'=1 if JJ664a==8 | JJ664a==9

/***************************************
PENSION AT CURRENT JOB #2
***************************************/ 		 
gen     PlanType_2_`year'=0
replace PlanType_2_`year'=JJ338b if JJ338b~=.	 

* If dcordbPlan=1, then dc, if 0 then db
gen     HasdcPlan_2_`year'=0
replace HasdcPlan_2_`year'=1 if JJ393b==1 | JJ393b==2 | (JJ393b>=4 & JJ393b<95)
replace HasdcPlan_2_`year'=. if JJ393b>=95 & JJ393b~=.

gen     HasdbPlan_2_`year'=0
replace HasdbPlan_2_`year'=1 if JJ393b==3
replace HasdbPlan_2_`year'=. if JJ393b>=95 & JJ393b~=.	 

/***************************************************
 This is plan amount for type a and b account only
***************************************************/
gen PlanamtNochng_2_`year'    =     0
replace PlanamtNochng_2_`year'=      JJ339b if JJ339b~=.
replace PlanamtNochng_2_`year'=.            if JJ339b==9999996 | JJ339b==9999998 | JJ339b==9999999
gen PlanamtNochng_aandb_2_dkRf_`year'=0
replace PlanamtNochng_aandb_2_dkRf_`year'=1 if PlanamtNochng_2_`year'==.
gen PaNochng_aandb_2_PointEst_`year'=0
replace PaNochng_aandb_2_PointEst_`year'=1 if PlanamtNochng_aandb_2_dkRf_`year'==0

gen double PlanNochng_aandb_2_minval=JJ340b
gen double PlanNochng_aandb_2_maxval=JJ341b

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
replace PlanamtNochng_2_`year'=`binexact1' if PlanNochng_aandb_2_minval==`binexact1' & PlanNochng_aandb_2_maxval==`binexact1'
replace PlanamtNochng_2_`year'=`binexact2' if PlanNochng_aandb_2_minval==`binexact2' & PlanNochng_aandb_2_maxval==`binexact2'
replace PlanamtNochng_2_`year'=`binexact3' if PlanNochng_aandb_2_minval==`binexact3' & PlanNochng_aandb_2_maxval==`binexact3'
replace PlanamtNochng_2_`year'=`binexact4' if PlanNochng_aandb_2_minval==`binexact4' & PlanNochng_aandb_2_maxval==`binexact4'

* Generate bins
forval num=0/4{
    sum PlanamtNochng_2_`year' if PaNochng_aandb_2_PointEst_`year'==1 & PlanamtNochng_2_`year' > `binmin`num'' & PlanamtNochng_2_`year' < `binmax`num'', detail
    cap assert r(N)>`impute_numobs'
    if _rc{
        replace PlanamtNochng_2_`year'=r(p$bin_pctile) if PlanNochng_aandb_2_minval==`binmin`num'' & PlanNochng_aandb_2_maxval==`binmax`num''
    }
    else{
        replace PlanamtNochng_2_`year'=(`binmin`num''+`binmin`num'')/2 if PlanNochng_aandb_2_minval==`binmin`num'' & PlanNochng_aandb_2_maxval==`binmax`num''
    }
}


/***************************************************
 This is plan amount for type b account (dc) only
***************************************************/
replace PlanamtNochng_2_`year'=     JJ413b if JJ413b~=.
replace PlanamtNochng_2_`year'=.            if JJ413b==99999996 | JJ413b==99999998 | JJ413b==99999999
gen PlanamtNochng_2_dkRf_`year'=0
replace PlanamtNochng_2_dkRf_`year'=1 if PlanamtNochng_2_`year'==.
gen PlanamtNochng_2_PointEst_`year'=0
replace PlanamtNochng_2_PointEst_`year'=1 if PlanamtNochng_2_dkRf_`year'==0

gen double PlanNochng_2_minval=JJ414b
gen double PlanNochng_2_maxval=JJ415b

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
replace PlanamtNochng_2_`year'=`binexact1' if PlanNochng_2_minval==`binexact1' & PlanNochng_2_maxval==`binexact1'
replace PlanamtNochng_2_`year'=`binexact2' if PlanNochng_2_minval==`binexact2' & PlanNochng_2_maxval==`binexact2'
replace PlanamtNochng_2_`year'=`binexact3' if PlanNochng_2_minval==`binexact3' & PlanNochng_2_maxval==`binexact3'
replace PlanamtNochng_2_`year'=`binexact4' if PlanNochng_2_minval==`binexact4' & PlanNochng_2_maxval==`binexact4'

* Generate bins
forval num=0/4{
    sum PlanamtNochng_2_`year' if PlanamtNochng_2_PointEst_`year'==1 & PlanamtNochng_2_`year' > `binmin`num'' & PlanamtNochng_2_`year' < `binmax`num'', detail
    cap assert r(N)>`impute_numobs'
    if _rc{
        replace PlanamtNochng_2_`year'=r(p$bin_pctile) if PlanNochng_2_minval==`binmin`num'' & PlanNochng_2_maxval==`binmax`num''
    }
    else{
        replace PlanamtNochng_2_`year'=(`binmin`num''+`binmin`num'')/2 if PlanNochng_2_minval==`binmin`num'' & PlanNochng_2_maxval==`binmax`num''
    }
}

/***********************************************************
 This is plan stock allocation for type b account (dc) only
***********************************************************/
gen PlanPctStocksNochng_2_`year'=0
replace PlanPctStocksNochng_2_`year'= 1 if JJ418b==1
replace PlanPctStocksNochng_2_`year'=.5 if JJ418b==3
replace PlanPctStocksNochng_2_`year'=.  if JJ418b==8 | JJ418b==9
gen PlanPctStocksNochng_2_dkRF_`year'=0
replace PlanPctStocksNochng_2_dkRF_`year'=1 if JJ418b==7 | JJ418b==8 | JJ418b==9
gen PPS_Nochng_2_PointEst_`year'=0
replace PPS_Nochng_2_PointEst_`year'=1 if PlanPctStocksNochng_2_dkRF_`year'==0


/***********************************************************
 This is plan stock allocation IN cOMPaNY STOcK (dc) only
***********************************************************/
gen HasCompStock_2_`year'=0
replace HasCompStock_2_`year'=1 if JJ664b==1
replace HasCompStock_2_`year'=1 if JJ664b==8 | JJ664b==9

/***************************************
PENSION aT CURRENT JOB #3
***************************************/ 		 
gen     PlanType_3_`year'=0
replace PlanType_3_`year'=JJ338c if JJ338c~=.	 

* If dcordbPlan=1, then dc, if 0 then db
gen     HasdcPlan_3_`year'=0
replace HasdcPlan_3_`year'=1 if JJ393c==1 | JJ393c==2 | (JJ393c>=4 & JJ393c<95)
replace HasdcPlan_3_`year'=. if JJ393c>=95 & JJ393c~=.

gen     HasdbPlan_3_`year'=0
replace HasdbPlan_3_`year'=1 if JJ393c==3
replace HasdbPlan_3_`year'=. if JJ393c>=95 & JJ393c~=.	 

/***************************************************
 This is plan amount for type a and b account only
***************************************************/
gen PlanamtNochng_3_`year'    =     0

/***************************************************
 This is plan amount for type b account (dc) only
***************************************************/
replace PlanamtNochng_3_`year'=     JJ413c if JJ413c~=.
replace PlanamtNochng_3_`year'=.            if JJ413c==99999996 | JJ413c==99999998 | JJ413c==99999999
gen PlanamtNochng_3_dkRf_`year'=0
replace PlanamtNochng_3_dkRf_`year'=1 if PlanamtNochng_3_`year'==.
gen PlanamtNochng_3_PointEst_`year'=0
replace PlanamtNochng_3_PointEst_`year'=1 if PlanamtNochng_3_dkRf_`year'==0

gen double PlanNochng_3_minval=JJ414c
gen double PlanNochng_3_maxval=JJ415c

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
replace PlanamtNochng_3_`year'=`binexact1' if PlanNochng_3_minval==`binexact1' & PlanNochng_3_maxval==`binexact1'
replace PlanamtNochng_3_`year'=`binexact2' if PlanNochng_3_minval==`binexact2' & PlanNochng_3_maxval==`binexact2'
replace PlanamtNochng_3_`year'=`binexact3' if PlanNochng_3_minval==`binexact3' & PlanNochng_3_maxval==`binexact3'
replace PlanamtNochng_3_`year'=`binexact4' if PlanNochng_3_minval==`binexact4' & PlanNochng_3_maxval==`binexact4'

* Generate bins
forval num=0/4{
    sum PlanamtNochng_3_`year' if PlanamtNochng_3_PointEst_`year'==1 & PlanamtNochng_3_`year' > `binmin`num'' & PlanamtNochng_3_`year' < `binmax`num'', detail
    cap assert r(N)>`impute_numobs'
    if _rc{
        replace PlanamtNochng_3_`year'=r(p$bin_pctile) if PlanNochng_3_minval==`binmin`num'' & PlanNochng_3_maxval==`binmax`num''
    }
    else{
        replace PlanamtNochng_3_`year'=(`binmin`num''+`binmin`num'')/2 if PlanNochng_3_minval==`binmin`num'' & PlanNochng_3_maxval==`binmax`num''
    }
}

/***********************************************************
 This is plan stock allocation for type b account (dc) only
***********************************************************/
gen PlanPctStocksNochng_3_`year'=0
replace PlanPctStocksNochng_3_`year'= 1 if JJ418c==1
replace PlanPctStocksNochng_3_`year'=.5 if JJ418c==3
replace PlanPctStocksNochng_3_`year'=.  if JJ418c==8 | JJ418c==9
gen PlanPctStocksNochng_3_dkRF_`year'=0
replace PlanPctStocksNochng_3_dkRF_`year'=1 if JJ418c==7 | JJ418c==8 | JJ418c==9
gen PPS_Nochng_3_PointEst_`year'=0
replace PPS_Nochng_3_PointEst_`year'=1 if PlanPctStocksNochng_3_dkRF_`year'==0

/***********************************************************
 This is plan stock allocation IN cOMPaNY STOcK (dc) only
***********************************************************/
gen HasCompStock_3_`year'=0
replace HasCompStock_3_`year'=1 if JJ664b==1
replace HasCompStock_3_`year'=1 if JJ664b==8 | JJ664b==9

/***************************************
PENSION AT CURRENT JOB #4
***************************************/ 		 
gen     PlanType_4_`year'=0
replace PlanType_4_`year'=JJ338d if JJ338d~=.	 

* If dcordbPlan=1, then dc, if 0 then db
gen     HasdcPlan_4_`year'=0
replace HasdcPlan_4_`year'=1 if JJ393d==1 | JJ393d==2 | (JJ393d>=4 & JJ393d<95)
replace HasdcPlan_4_`year'=. if JJ393d>=95 & JJ393d~=.

gen     HasdbPlan_4_`year'=0
replace HasdbPlan_4_`year'=1 if JJ393d==3
replace HasdbPlan_4_`year'=. if JJ393d>=95 & JJ393d~=.	 

/***************************************************
 This is plan amount for type a and b account only
***************************************************/
gen PlanamtNochng_4_`year'    =     0

/***************************************************
 This is plan amount for type b account (dc) only
***************************************************/
replace PlanamtNochng_4_`year'=     JJ413d if JJ413d~=.
replace PlanamtNochng_4_`year'=.            if JJ413d==99999996 | JJ413d==99999998 | JJ413d==99999999
gen PlanamtNochng_4_dkRf_`year'=0
replace PlanamtNochng_4_dkRf_`year'=1 if PlanamtNochng_4_`year'==.
gen PlanamtNochng_4_PointEst_`year'=0
replace PlanamtNochng_4_PointEst_`year'=1 if PlanamtNochng_4_dkRf_`year'==0

/***********************************************************
 This is plan stock allocation for type b account (dc) only
***********************************************************/
gen PlanPctStocksNochng_4_`year'=0
replace PlanPctStocksNochng_4_`year'= 1 if JJ418d==1
replace PlanPctStocksNochng_4_`year'=.5 if JJ418d==3
replace PlanPctStocksNochng_4_`year'=.  if JJ418d==8 | JJ418d==9
gen PlanPctStocksNochng_4_dkRF_`year'=0
replace PlanPctStocksNochng_4_dkRF_`year'=1 if JJ418d==7 | JJ418d==8 | JJ418d==9
gen PPS_Nochng_4_PointEst_`year'=0
replace PPS_Nochng_4_PointEst_`year'=1 if PlanPctStocksNochng_4_dkRF_`year'==0


/***********************************************************
 This is plan stock allocation IN cOMPaNY STOcK (dc) only
***********************************************************/
gen HasCompStock_4_`year'=0
replace HasCompStock_4_`year'=1 if JJ664d==1
replace HasCompStock_4_`year'=1 if JJ664d==8 | JJ664d==9

/***************************************
 DORMANT PLANS FROM PREVIOUS JOBS
***************************************/
gen HasdormPlan_`year'=0
/* db plans */
replace HasdormPlan_`year'=1 if  JJ434a1==1  | JJ434a2==1   | JJ434a3==1
replace HasdormPlan_`year'=. if (JJ434a1==8  & JJ434a1==9)  | (JJ434a2==8 & JJ434a2==9) | (JJ434a3==8 & JJ434a3==9)
                                
								
replace HasdormPlan_`year'=1 if  JJ434b1==1  | JJ434b2==1   | JJ434b3==1
replace HasdormPlan_`year'=. if (JJ434b1==8  & JJ434b1==9)  | (JJ434b2==8 & JJ434b2==9) | (JJ434b3==8 & JJ434b3==9)

replace HasdormPlan_`year'=1 if  JJ434c1==1  | JJ434c2==1
replace HasdormPlan_`year'=. if (JJ434c1==8  & JJ434c1==9)  | (JJ434c2==8 & JJ434c2==9)

replace HasdormPlan_`year'=1 if  JJ434d1==1  | JJ434d2==1
replace HasdormPlan_`year'=. if (JJ434d1==8  & JJ434d1==9)  | (JJ434d2==8 & JJ434d2==9)               


/* dc plans */
replace HasdormPlan_`year'=1 if  JJ450a1==1  | JJ450a2==1   | JJ450a3==1   | JJ450a4==1 
replace HasdormPlan_`year'=. if (JJ450a1>=95 & JJ450a1<=99) | (JJ450a2>=95 & JJ450a2<=99) | (JJ450a3>=95 & JJ450a3<=99) | ///
                                (JJ450a4>=95 & JJ450a4<=99)
								
replace HasdormPlan_`year'=1 if  JJ450b1==1  | JJ450b2==1   | JJ450b3==1
replace HasdormPlan_`year'=. if (JJ450b1>=95 & JJ450b1<=99) | (JJ450b2>=95 & JJ450b2<=99) | (JJ450b3>=95 & JJ450b3<=99)

replace HasdormPlan_`year'=1 if  JJ450c1==1  | JJ450c2==1   | JJ450c3==1
replace HasdormPlan_`year'=. if (JJ450c1>=95 & JJ450c1<=99) | (JJ450c2>=95 & JJ450c2<=99) | (JJ450c3>=95 & JJ450c3<=99)
  
replace HasdormPlan_`year'=1 if  JJ450d1==1  | JJ450d2==1
replace HasdormPlan_`year'=. if (JJ450d1>=95 & JJ450d1<=99) | (JJ450d2>=95 & JJ450d2<=99)


/***************************************
 DORMANT PENSION #1
***************************************/
gen     dormHasdcPlan_1_`year'=0
replace dormHasdcPlan_1_`year'=1 if  JJ450a1==1  | JJ450a2==1   | JJ450a3==1   | JJ450a4==1 
replace dormHasdcPlan_1_`year'=. if (JJ450a1>=95 & JJ450a1<=99) | (JJ450a2>=95 & JJ450a2<=99) | (JJ450a3>=95 & JJ450a3<=99) | ///
                                    (JJ450a4>=95 & JJ450a4<=99) 

gen     dormHasdbPlan_1_`year'=0
replace dormHasdbPlan_1_`year'=1 if  JJ434a1==1  | JJ434a2==1   | JJ434a3==1
replace dormHasdbPlan_1_`year'=. if (JJ434a1==8  & JJ434a1==9)  | (JJ434a2==8 & JJ434a2==9) | (JJ434a3==8 & JJ434a3==9)

gen double dormPlanamt_1_`year'=0
replace    dormPlanamt_1_`year'=JJ465a if JJ465a~=.

quietly sum dormPlanamt_1_`year' if dormPlanamt_1_`year'<=99999998, det
local MaxPlanamt=r(max)

gen double dormPlanamt_1_dkRf_`year'=0
replace dormPlanamt_1_dkRf_`year'=1 if dormPlanamt_1_`year'==99999998 | dormPlanamt_1_`year'==99999999
replace dormPlanamt_1_`year'=. if dormPlanamt_1_dkRf_`year'==1

gen double dormPlanamt_1_PointEst_`year'=0
replace dormPlanamt_1_PointEst_`year'=1 if dormPlanamt_1_`year'~=.

/* # of missings is verfied by codebook. 9/25, db */
gen double dormPlan_1_minval=JJ466a
gen double dormPlan_1_maxval=JJ467a

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
replace dormPlanamt_1_`year'=`binexact1' if dormPlan_1_minval==`binexact1' & dormPlan_1_maxval==`binexact1'
replace dormPlanamt_1_`year'=`binexact2' if dormPlan_1_minval==`binexact2' & dormPlan_1_maxval==`binexact2'
replace dormPlanamt_1_`year'=`binexact3' if dormPlan_1_minval==`binexact3' & dormPlan_1_maxval==`binexact3'
replace dormPlanamt_1_`year'=`binexact4' if dormPlan_1_minval==`binexact4' & dormPlan_1_maxval==`binexact4'

* Generate bins
forval num=0/4{
    sum dormPlanamt_1_`year' if dormPlanamt_1_PointEst_`year'==1 & dormPlanamt_1_`year' > `binmin`num'' & dormPlanamt_1_`year' < `binmax`num'', detail
    cap assert r(N)>`impute_numobs'
    if _rc{
        replace dormPlanamt_1_`year'=r(p$bin_pctile) if dormPlan_1_minval==`binmin`num'' & dormPlan_1_maxval==`binmax`num''
    }
    else{
        replace dormPlanamt_1_`year'=(`binmin`num''+`binmin`num'')/2 if dormPlan_1_minval==`binmin`num'' & dormPlan_1_maxval==`binmax`num''
    }
}

/***************************************
 DORMANT PENSION #2
***************************************/
gen     dormHasdcPlan_2_`year'=0
replace dormHasdcPlan_2_`year'=1 if  JJ450b1==1  | JJ450b2==1   | JJ450b3==1
replace dormHasdcPlan_2_`year'=. if (JJ450b1>=95 & JJ450b1<=99) | (JJ450b2>=95 & JJ450b2<=99) | (JJ450b3>=95 & JJ450b3<=99)

gen     dormHasdbPlan_2_`year'=0
replace dormHasdbPlan_2_`year'=1 if  JJ434b1==1  | JJ434b2==1   | JJ434b3==1
replace dormHasdbPlan_2_`year'=. if (JJ434b1==8  & JJ434b1==9)  | (JJ434b2==8 & JJ434b2==9) | (JJ434b3==8 & JJ434b3==9)
                                    

gen double dormPlanamt_2_`year'=0
replace    dormPlanamt_2_`year'=JJ465b if JJ465b~=.

quietly sum dormPlanamt_2_`year' if dormPlanamt_2_`year'<=99999998, det
local MaxPlanamt=r(max)

gen double dormPlanamt_2_dkRf_`year'=0
replace dormPlanamt_2_dkRf_`year'=1 if dormPlanamt_2_`year'==99999998 | dormPlanamt_2_`year'==99999999
replace dormPlanamt_2_`year'=. if dormPlanamt_2_dkRf_`year'==1

gen double dormPlanamt_2_PointEst_`year'=0
replace dormPlanamt_2_PointEst_`year'=1 if dormPlanamt_2_`year'~=.

/* # of missings is verfied by codebook. 9/25, db */
gen double dormPlan_2_minval=JJ466b
gen double dormPlan_2_maxval=JJ467b

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
replace dormPlanamt_2_`year'=`binexact1' if dormPlan_2_minval==`binexact1' & dormPlan_2_maxval==`binexact1'
replace dormPlanamt_2_`year'=`binexact2' if dormPlan_2_minval==`binexact2' & dormPlan_2_maxval==`binexact2'
replace dormPlanamt_2_`year'=`binexact3' if dormPlan_2_minval==`binexact3' & dormPlan_2_maxval==`binexact3'
replace dormPlanamt_2_`year'=`binexact4' if dormPlan_2_minval==`binexact4' & dormPlan_2_maxval==`binexact4'

* Generate bins
forval num=0/4{
    sum dormPlanamt_2_`year' if dormPlanamt_2_PointEst_`year'==1 & dormPlanamt_2_`year' > `binmin`num'' & dormPlanamt_2_`year' < `binmax`num'', detail
    cap assert r(N)>`impute_numobs'
    if _rc{
        replace dormPlanamt_2_`year'=r(p$bin_pctile) if dormPlan_2_minval==`binmin`num'' & dormPlan_2_maxval==`binmax`num''
    }
    else{
        replace dormPlanamt_2_`year'=(`binmin`num''+`binmin`num'')/2 if dormPlan_2_minval==`binmin`num'' & dormPlan_2_maxval==`binmax`num''
    }
}

/***************************************
 DORMANT PENSION #3
***************************************/
gen     dormHasdcPlan_3_`year'=0
replace dormHasdcPlan_3_`year'=1 if  JJ450c1==1  | JJ450c2==1   | JJ450c3==1
replace dormHasdcPlan_3_`year'=. if (JJ450c1>=95 & JJ450c1<=99) | (JJ450c2>=95 & JJ450c2<=99) | (JJ450c3>=95 & JJ450c3<=99)

gen     dormHasdbPlan_3_`year'=0
replace dormHasdbPlan_3_`year'=1 if  JJ434c1==1  | JJ434c2==1
replace dormHasdbPlan_3_`year'=. if (JJ434c1==8  & JJ434c1==9)  | (JJ434c2==8 & JJ434c2==9)
                                    

gen double dormPlanamt_3_`year'=0
replace    dormPlanamt_3_`year'=JJ465c if JJ465c~=.

quietly sum dormPlanamt_3_`year' if dormPlanamt_3_`year'<=99999998, det
local MaxPlanamt=r(max)

gen double dormPlanamt_3_dkRf_`year'=0
replace dormPlanamt_3_dkRf_`year'=1 if dormPlanamt_3_`year'==99999998 | dormPlanamt_3_`year'==99999999
replace dormPlanamt_3_`year'=. if dormPlanamt_3_dkRf_`year'==1

gen double dormPlanamt_3_PointEst_`year'=0
replace dormPlanamt_3_PointEst_`year'=1 if dormPlanamt_3_`year'~=.

/* # of missings is verfied by codebook. 9/25, db */
gen double dormPlan_3_minval=JJ466c
gen double dormPlan_3_maxval=JJ467c

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
replace dormPlanamt_3_`year'=`binexact1' if dormPlan_3_minval==`binexact1' & dormPlan_3_maxval==`binexact1'
replace dormPlanamt_3_`year'=`binexact2' if dormPlan_3_minval==`binexact2' & dormPlan_3_maxval==`binexact2'
replace dormPlanamt_3_`year'=`binexact3' if dormPlan_3_minval==`binexact3' & dormPlan_3_maxval==`binexact3'
replace dormPlanamt_3_`year'=`binexact4' if dormPlan_3_minval==`binexact4' & dormPlan_3_maxval==`binexact4'

* Generate bins
forval num=0/4{
    sum dormPlanamt_3_`year' if dormPlanamt_3_PointEst_`year'==1 & dormPlanamt_3_`year' > `binmin`num'' & dormPlanamt_3_`year' < `binmax`num'', detail
    cap assert r(N)>`impute_numobs'
    if _rc{
        replace dormPlanamt_3_`year'=r(p$bin_pctile) if dormPlan_3_minval==`binmin`num'' & dormPlan_3_maxval==`binmax`num''
    }
    else{
        replace dormPlanamt_3_`year'=(`binmin`num''+`binmin`num'')/2 if dormPlan_3_minval==`binmin`num'' & dormPlan_3_maxval==`binmax`num''
    }
}

/***************************************
 DORMANT PENSION #4
***************************************/
/* Only one obs that cannot be imputed in 2008 */
gen     dormHasdcPlan_4_`year'=0
replace dormHasdcPlan_4_`year'=1 if  JJ450d1==1  | JJ450d2==1
replace dormHasdcPlan_4_`year'=. if (JJ450d1>=95 & JJ450d1<=99) | (JJ450d2>=95 & JJ450d2<=99)

gen     dormHasdbPlan_4_`year'=0
replace dormHasdbPlan_4_`year'=1 if  JJ434d1==1  | JJ434d2==1
replace dormHasdbPlan_4_`year'=. if (JJ434d1==8  & JJ434d1==9)  | (JJ434d2==8 & JJ434d2==9)
                                    
gen double dormPlanamt_4_`year'=0
replace    dormPlanamt_4_`year'=JJ465d if JJ465d~=.

quietly sum dormPlanamt_4_`year' if dormPlanamt_4_`year'<=99999998, det
local MaxPlanamt=r(max)

gen double dormPlanamt_4_dkRf_`year'=0
replace dormPlanamt_4_dkRf_`year'=1 if dormPlanamt_4_`year'==99999998 | dormPlanamt_4_`year'==99999999
replace dormPlanamt_4_`year'=. if dormPlanamt_4_dkRf_`year'==1

gen double dormPlanamt_4_PointEst_`year'=0
replace dormPlanamt_4_PointEst_`year'=1 if dormPlanamt_4_`year'~=.

/* # of missings is verfied by codebook. 9/25, db */
gen double dormPlan_4_minval=JJ466d
gen double dormPlan_4_maxval=JJ467d

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
replace dormPlanamt_4_`year'=`binexact1' if dormPlan_4_minval==`binexact1' & dormPlan_4_maxval==`binexact1'
replace dormPlanamt_4_`year'=`binexact2' if dormPlan_4_minval==`binexact2' & dormPlan_4_maxval==`binexact2'
replace dormPlanamt_4_`year'=`binexact3' if dormPlan_4_minval==`binexact3' & dormPlan_4_maxval==`binexact3'
replace dormPlanamt_4_`year'=`binexact4' if dormPlan_4_minval==`binexact4' & dormPlan_4_maxval==`binexact4'

* Generate bins
forval num=0/4{
    sum dormPlanamt_4_`year' if dormPlanamt_4_PointEst_`year'==1 & dormPlanamt_4_`year' > `binmin`num'' & dormPlanamt_4_`year' < `binmax`num'', detail
    cap assert r(N)>`impute_numobs'
    if _rc{
        replace dormPlanamt_4_`year'=r(p$bin_pctile) if dormPlan_4_minval==`binmin`num'' & dormPlan_4_maxval==`binmax`num''
    }
    else{
        replace dormPlanamt_4_`year'=(`binmin`num''+`binmin`num'')/2 if dormPlan_4_minval==`binmin`num'' & dormPlan_4_maxval==`binmax`num''
    }
}
/****************************************************************************
       AGGREGATES
****************************************************************************/
gen TotPrevPenAmt_`year' = PrevPlanamt_1_`year' + PrevPlanamt_2_`year' + PrevPlanamt_3_`year' + PrevPlanamt_4_`year' 

gen TotcurrPenAmt_`year' = PlanamtNochng_1_`year' + PlanamtNochng_2_`year' + PlanamtNochng_3_`year'+ PlanamtNochng_4_`year' 

gen TotdormPenAmt_`year' = dormPlanamt_1_`year' + dormPlanamt_2_`year' + dormPlanamt_3_`year' + dormPlanamt_4_`year' 

gen TotAllPenAmt_`year'  = TotPrevPenAmt_`year' + TotcurrPenAmt_`year' + TotdormPenAmt_`year'


gen PlanStockDoll_`year' =     (PlanPctStocksNochng_1_`year'/100)*PlanamtNochng_1_`year'                                     + ///
							   (PlanPctStocksNochng_2_`year'/100)*PlanamtNochng_2_`year'                                     + ///
							   (PlanPctStocksNochng_3_`year'/100)*PlanamtNochng_3_`year'                                     + ///
							   (PlanPctStocksNochng_4_`year'/100)*PlanamtNochng_4_`year'
							   
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
