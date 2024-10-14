/***********************************************************************************************************************************************************
															CURRENT JOB (SEcTION J)
***********************************************************************************************************************************************************/
clear all
infile using "$HRSSurveys08/h08sta/H08J_R.dct" , using("$HRSSurveys08/h08da/H08J_R.da")
local year "2008"
gen YEAR=`year'
sort HHID LSUBHH
gen SUBHH=LSUBHH

local flag=0
local impute_numobs=0

/****************************************************************************
 Job change since last wave or no?
****************************************************************************/ 
gen SameEmployer_`year' =.
replace SameEmployer_`year'=1 if LJ045==1 | LJ045==3
replace SameEmployer_`year'=0 if LJ045==4 | LJ045==5

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
replace PrevEmpPens_`year'=1 if LJ084==1
replace PrevEmpPens_`year'=. if LJ084==8 | LJ084==9

gen PrevEmpNumPlans_`year'=LJ085
replace PrevEmpNumPlans_`year'=. if LJ085>=95
replace PrevEmpNumPlans_`year'=1 if LJ086==1

/***************************************
PENSION 1
***************************************/
gen PrevEmpdbPlan_1_`year'=0
replace PrevEmpdbPlan_1_`year'=1 if LJW001A==1
replace PrevEmpdbPlan_1_`year'=. if LJW001A==8 | LJW001A==9

gen PrevEmpdcPlan_1_`year'=0
replace PrevEmpdcPlan_1_`year'=1 if LJW001A==2
replace PrevEmpdcPlan_1_`year'=. if LJW001A==8 | LJW001A==9

gen double PrevPlanamt_1_`year'=0
replace    PrevPlanamt_1_`year'=LJW009A if LJW009A~=.

quietly sum PrevPlanamt_1_`year' if PrevPlanamt_1_`year'<=99999998, det
local MaxPrevPlanamt=r(max)

gen double PrevPlanamt_1_dkRf_`year'=0
replace PrevPlanamt_1_dkRf_`year'=1 if PrevPlanamt_1_`year'==99999998 | PrevPlanamt_1_`year'==99999999
replace PrevPlanamt_1_`year'=. if PrevPlanamt_1_dkRf_`year'==1

gen double PrevPlanamt_1_PointEst_`year'=0
replace PrevPlanamt_1_PointEst_`year'=1 if PrevPlanamt_1_`year'~=.

/* # of missings is verfied by codebook. 9/25, db */
gen double PrevPlan_1_minval=LJW010A
gen double PrevPlan_1_maxval=LJW011A

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
replace PrevEmpdbPlan_2_`year'=1 if LJW001B==1
replace PrevEmpdbPlan_2_`year'=. if LJW001B==8 | LJW001B==9

gen PrevEmpdcPlan_2_`year'=0
replace PrevEmpdcPlan_2_`year'=1 if LJW001B==2
replace PrevEmpdcPlan_2_`year'=. if LJW001B==8 | LJW001B==9

gen double PrevPlanamt_2_`year'=0
replace    PrevPlanamt_2_`year'=LJW009B if LJW009B~=.

quietly sum PrevPlanamt_2_`year' if PrevPlanamt_2_`year'<=99999998, det
local MaxPrevPlanamt=r(max)

gen double PrevPlanamt_2_dkRf_`year'=0
replace PrevPlanamt_2_dkRf_`year'=1 if PrevPlanamt_2_`year'==99999998 | PrevPlanamt_2_`year'==99999999
replace PrevPlanamt_2_`year'=. if PrevPlanamt_2_dkRf_`year'==1

gen double PrevPlanamt_2_PointEst_`year'=0
replace PrevPlanamt_2_PointEst_`year'=1 if PrevPlanamt_2_`year'~=.

/* # of missings is verfied by codebook. 9/25, db */
gen double PrevPlan_2_minval=LJW010B
gen double PrevPlan_2_maxval=LJW011B

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
replace PrevEmpdbPlan_3_`year'=1 if LJW001C==1
replace PrevEmpdbPlan_3_`year'=. if LJW001C==8 | LJW001C==9

gen PrevEmpdcPlan_3_`year'=0
replace PrevEmpdcPlan_3_`year'=1 if LJW001C==2
replace PrevEmpdcPlan_3_`year'=. if LJW001C==8 | LJW001C==9

gen double PrevPlanamt_3_`year'=0
replace    PrevPlanamt_3_`year'=LJW009C if LJW009C~=.

quietly sum PrevPlanamt_3_`year' if PrevPlanamt_3_`year'<=99999998, det
local MaxPrevPlanamt=r(max)

gen double PrevPlanamt_3_dkRf_`year'=0
replace PrevPlanamt_3_dkRf_`year'=1 if PrevPlanamt_3_`year'==99999998 | PrevPlanamt_3_`year'==99999999
replace PrevPlanamt_3_`year'=. if PrevPlanamt_3_dkRf_`year'==1

gen double PrevPlanamt_3_PointEst_`year'=0
replace PrevPlanamt_3_PointEst_`year'=1 if PrevPlanamt_3_`year'~=.

/* # of missings is verfied by codebook. 9/25, db */
gen double PrevPlan_3_minval=LJW010C
gen double PrevPlan_3_maxval=LJW011C

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
replace PrevEmpdbPlan_4_`year'=1 if LJW001D==1
replace PrevEmpdbPlan_4_`year'=. if LJW001D==8 | LJW001D==9

gen PrevEmpdcPlan_4_`year'=0
replace PrevEmpdcPlan_4_`year'=1 if LJW001D==2
replace PrevEmpdcPlan_4_`year'=. if LJW001D==8 | LJW001D==9

gen double PrevPlanamt_4_`year'=0
replace    PrevPlanamt_4_`year'=LJW009D if LJW009D~=.

quietly sum PrevPlanamt_4_`year' if PrevPlanamt_4_`year'<=99999998, det
local MaxPrevPlanamt=r(max)

gen double PrevPlanamt_4_dkRf_`year'=0
replace PrevPlanamt_4_dkRf_`year'=1 if PrevPlanamt_4_`year'==99999998 | PrevPlanamt_4_`year'==99999999
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
replace PlanType_1_`year'=LJ338_1 if LJ338_1~=.	 

* If dcordbPlan=1, then dc, if 0 then db
gen     HasdcPlan_1_`year'=0
replace HasdcPlan_1_`year'=1 if LJ393_1==1 | LJ393_1==2 | (LJ393_1>=4 & LJ393_1<95)
replace HasdcPlan_1_`year'=. if LJ393_1>=95 & LJ393_1~=.

gen     HasdbPlan_1_`year'=0
replace HasdbPlan_1_`year'=1 if LJ393_1==3
replace HasdbPlan_1_`year'=. if LJ393_1>=95 & LJ393_1~=.	 

/***************************************************
 This is plan amount for type a and b account only
***************************************************/
gen PlanamtNochng_1_`year'    =     0

/***************************************************
 This is plan amount for type b account (dc) only
***************************************************/
*gen PlanamtNochng_1_`year'    =     0
replace PlanamtNochng_1_`year'=     LJ413_1 if LJ413_1~=.
replace PlanamtNochng_1_`year'=.            if LJ413_1==99999996 | LJ413_1==99999998 | LJ413_1==99999999
gen PlanamtNochng_1_dkRf_`year'=0
replace PlanamtNochng_1_dkRf_`year'=1 if PlanamtNochng_1_`year'==.
gen PlanamtNochng_1_PointEst_`year'=0
replace PlanamtNochng_1_PointEst_`year'=1 if PlanamtNochng_1_dkRf_`year'==0

gen double PlanNochng_1_minval=LJ414_1
gen double PlanNochng_1_maxval=LJ415_1

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
 This is plan stock allocation for type B account (DC) only
***********************************************************/
gen PlanPctStocksNoChng_1_`year'=0
replace PlanPctStocksNoChng_1_`year'=LJ812_1 if LJ812_1~=.
replace PlanPctStocksNoChng_1_`year'=. if LJ812_1==998 | LJ812_1==999
gen PlanPctStocksNoChng_1_DkRF_`year'=0
replace PlanPctStocksNoChng_1_DkRF_`year'=1 if LJ812_1==998 | LJ812_1==999
gen PPS_NoChng_1_PointEst_`year'=0
replace PPS_NoChng_1_PointEst_`year'=1 if PlanPctStocksNoChng_1_DkRF_`year'==0

gen double PctStocksNoChng_1_minval=LJ813_1
gen double PctStocksNoChng_1_maxval=LJ814_1

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
replace CompPctStocksNoChng_1_`year'=LJ816_1
replace CompPctStocksNoChng_1_`year'=. if LJ816_1==998 | LJ816_1==999
gen CompPctStocksNoChng_1_DkRF_`year'=0
replace CompPctStocksNoChng_1_DkRF_`year'=1 if LJ816_1==998 | LJ816_1==999
gen CPSNoChng_1_PointEst_`year'=0
replace CPSNoChng_1_PointEst_`year'=1 if CompPctStocksNoChng_1_DkRF_`year'==0

gen double CompPctStocksNoChng_1_minval=LJ817_1
gen double CompPctStocksNoChng_1_maxval=LJ818_1

local binmin0   0
local binmin1   21
local binmin2   41
local binmin3   61
local binmin4   81
local binmax0   19
local binmax1   39
local binmax2   59
local binmax3   79
local binmax4   96
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
gen     PlanType_2_`year'=0
replace PlanType_2_`year'=LJ338_2 if LJ338_2~=.	 

* If dcordbPlan=1, then dc, if 0 then db
gen     HasdcPlan_2_`year'=0
replace HasdcPlan_2_`year'=1 if LJ393_2==1 | LJ393_2==2 | (LJ393_2>=4 & LJ393_2<95)
replace HasdcPlan_2_`year'=. if LJ393_2>=95 & LJ393_2~=.

gen     HasdbPlan_2_`year'=0
replace HasdbPlan_2_`year'=1 if LJ393_2==3
replace HasdbPlan_2_`year'=. if LJ393_2>=95 & LJ393_2~=.	 

/***************************************************
 This is plan amount for type a and b account only
***************************************************/
gen PlanamtNochng_2_`year'    =     0

/***************************************************
 This is plan amount for type b account (dc) only
***************************************************/
replace PlanamtNochng_2_`year'=     LJ413_2 if LJ413_2~=.
replace PlanamtNochng_2_`year'=.            if LJ413_2==99999996 | LJ413_2==99999998 | LJ413_2==99999999
gen PlanamtNochng_2_dkRf_`year'=0
replace PlanamtNochng_2_dkRf_`year'=1 if PlanamtNochng_2_`year'==.
gen PlanamtNochng_2_PointEst_`year'=0
replace PlanamtNochng_2_PointEst_`year'=1 if PlanamtNochng_2_dkRf_`year'==0

gen double PlanNochng_2_minval=LJ414_2
gen double PlanNochng_2_maxval=LJ415_2

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
 This is plan stock allocation for type B account (DC) only
***********************************************************/
gen PlanPctStocksNoChng_2_`year'=0
replace PlanPctStocksNoChng_2_`year'=LJ812_2 if LJ812_2~=.
replace PlanPctStocksNoChng_2_`year'=. if LJ812_2==998 | LJ812_2==999
gen PlanPctStocksNoChng_2_DkRF_`year'=0
replace PlanPctStocksNoChng_2_DkRF_`year'=1 if LJ812_2==998 | LJ812_2==999
gen PPS_NoChng_2_PointEst_`year'=0
replace PPS_NoChng_2_PointEst_`year'=1 if PlanPctStocksNoChng_2_DkRF_`year'==0

gen double PctStocksNoChng_2_minval=LJ813_2
gen double PctStocksNoChng_2_maxval=LJ814_2

local binmin0   0
local binmin1   21
local binmin2   41
local binmin3   61
local binmin4   81
local binmax0   19
local binmax1   39
local binmax2   59
local binmax3   79
local binmax4   96
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
replace CompPctStocksNoChng_2_`year'=LJ816_2
replace CompPctStocksNoChng_2_`year'=. if LJ816_2==998 | LJ816_2==999
gen CompPctStocksNoChng_2_DkRF_`year'=0
replace CompPctStocksNoChng_2_DkRF_`year'=1 if LJ816_2==998 | LJ816_2==999
gen CPSNoChng_2_PointEst_`year'=0
replace CPSNoChng_2_PointEst_`year'=1 if CompPctStocksNoChng_2_DkRF_`year'==0

gen double CompPctStocksNoChng_2_minval=LJ817_2
gen double CompPctStocksNoChng_2_maxval=LJ818_2

local binmin0   0
local binmin1   21
local binmin2   41
local binmin3   61
local binmin4   81
local binmax0   19
local binmax1   39
local binmax2   59
local binmax3   79
local binmax4   96
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
gen     PlanType_3_`year'=0
replace PlanType_3_`year'=LJ338_3 if LJ338_3~=.	 

* If dcordbPlan=1, then dc, if 0 then db
gen     HasdcPlan_3_`year'=0
replace HasdcPlan_3_`year'=1 if LJ393_3==1 | LJ393_3==2 | (LJ393_3>=4 & LJ393_3<95)
replace HasdcPlan_3_`year'=. if LJ393_3>=95 & LJ393_3~=.

gen     HasdbPlan_3_`year'=0
replace HasdbPlan_3_`year'=1 if LJ393_3==3
replace HasdbPlan_3_`year'=. if LJ393_3>=95 & LJ393_3~=.	 

/***************************************************
 This is plan amount for type a and b account only
***************************************************/
gen PlanamtNochng_3_`year'    =     0

/***************************************************
 This is plan amount for type b account (dc) only
***************************************************/
replace PlanamtNochng_3_`year'=     LJ413_3 if LJ413_3~=.
replace PlanamtNochng_3_`year'=.            if LJ413_3==99999996 | LJ413_3==99999998 | LJ413_3==99999999
gen PlanamtNochng_3_dkRf_`year'=0
replace PlanamtNochng_3_dkRf_`year'=1 if PlanamtNochng_3_`year'==.
gen PlanamtNochng_3_PointEst_`year'=0
replace PlanamtNochng_3_PointEst_`year'=1 if PlanamtNochng_3_dkRf_`year'==0

gen double PlanNochng_3_minval=LJ414_3
gen double PlanNochng_3_maxval=LJ415_3

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
 This is plan stock allocation for type B account (DC) only
***********************************************************/
gen PlanPctStocksNoChng_3_`year'=0
replace PlanPctStocksNoChng_3_`year'=LJ812_3 if LJ812_3~=.
replace PlanPctStocksNoChng_3_`year'=. if LJ812_3==998 | LJ812_3==999
gen PlanPctStocksNoChng_3_DkRF_`year'=0
replace PlanPctStocksNoChng_3_DkRF_`year'=1 if LJ812_3==998 | LJ812_3==999
gen PPS_NoChng_3_PointEst_`year'=0
replace PPS_NoChng_3_PointEst_`year'=1 if PlanPctStocksNoChng_3_DkRF_`year'==0

gen double PctStocksNoChng_3_minval=LJ813_3
gen double PctStocksNoChng_3_maxval=LJ814_3

local binmin0   0
local binmin1   21
local binmin2   41
local binmin3   61
local binmin4   81
local binmax0   19
local binmax1   39
local binmax2   59
local binmax3   79
local binmax4   96
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
replace CompPctStocksNoChng_3_`year'=LJ816_3
replace CompPctStocksNoChng_3_`year'=. if LJ816_3==998 | LJ816_3==999
gen CompPctStocksNoChng_3_DkRF_`year'=0
replace CompPctStocksNoChng_3_DkRF_`year'=1 if LJ816_3==998 | LJ816_3==999
gen CPSNoChng_3_PointEst_`year'=0
replace CPSNoChng_3_PointEst_`year'=1 if CompPctStocksNoChng_3_DkRF_`year'==0

/* No binning necessary in 2008 */

/***************************************
PENSION AT CURRENT JON #4
***************************************/ 		 
gen     PlanType_4_`year'=0
replace PlanType_4_`year'=LJ338_4 if LJ338_4~=.	 

* If dcordbPlan=1, then dc, if 0 then db
gen     HasdcPlan_4_`year'=0
replace HasdcPlan_4_`year'=1 if LJ393_4==1 | LJ393_4==2 | (LJ393_4>=4 & LJ393_4<95)
replace HasdcPlan_4_`year'=. if LJ393_4>=95 & LJ393_4~=.

gen     HasdbPlan_4_`year'=0
replace HasdbPlan_4_`year'=1 if LJ393_4==3
replace HasdbPlan_4_`year'=. if LJ393_4>=95 & LJ393_4~=.	 

/***************************************************
 This is plan amount for type a and b account only
***************************************************/
gen PlanamtNochng_4_`year'    =     0

/***************************************************
 This is plan amount for type b account (dc) only
***************************************************/
replace PlanamtNochng_4_`year'=     LJ413_4 if LJ413_4~=.
replace PlanamtNochng_4_`year'=.            if LJ413_4==99999996 | LJ413_4==99999998 | LJ413_4==99999999
gen PlanamtNochng_4_dkRf_`year'=0
replace PlanamtNochng_4_dkRf_`year'=1 if PlanamtNochng_4_`year'==.
gen PlanamtNochng_4_PointEst_`year'=0
replace PlanamtNochng_4_PointEst_`year'=1 if PlanamtNochng_4_dkRf_`year'==0

/***********************************************************
 This is plan stock allocation for type B account (DC) only
***********************************************************/
gen PlanPctStocksNoChng_4_`year'=0
replace PlanPctStocksNoChng_4_`year'=LJ812_4 if LJ812_4~=.
replace PlanPctStocksNoChng_4_`year'=. if LJ812_4==998 | LJ812_4==999
gen PlanPctStocksNoChng_4_DkRF_`year'=0
replace PlanPctStocksNoChng_4_DkRF_`year'=1 if LJ812_4==998 | LJ812_4==999
gen PPS_NoChng_4_PointEst_`year'=0
replace PPS_NoChng_4_PointEst_`year'=1 if PlanPctStocksNoChng_4_DkRF_`year'==0

gen double PctStocksNoChng_4_minval=LJ813_4
gen double PctStocksNoChng_4_maxval=LJ814_4

local binmin0   0
local binmin1   21
local binmin2   41
local binmin3   61
local binmin4   81
local binmax0   19
local binmax1   39
local binmax2   59
local binmax3   79
local binmax4   96
local binexact1 20
local binexact2 40
local binexact3 60
local binexact4 80

/* Generating exact values here */
replace PlanPctStocksNoChng_4_`year'=`binexact1' if PctStocksNoChng_4_minval==`binexact1' & PctStocksNoChng_4_maxval==`binexact1'
replace PlanPctStocksNoChng_4_`year'=`binexact2' if PctStocksNoChng_4_minval==`binexact2' & PctStocksNoChng_4_maxval==`binexact2'
replace PlanPctStocksNoChng_4_`year'=`binexact3' if PctStocksNoChng_4_minval==`binexact3' & PctStocksNoChng_4_maxval==`binexact3'
replace PlanPctStocksNoChng_4_`year'=`binexact4' if PctStocksNoChng_4_minval==`binexact4' & PctStocksNoChng_4_maxval==`binexact4'

* Generate bins
forval num=0/4{
    sum PlanPctStocksNoChng_4_`year' if PPS_NoChng_4_PointEst_`year'==1 & PlanPctStocksNoChng_4_`year' > `binmin`num'' & PlanPctStocksNoChng_4_`year' < `binmax`num'', detail
    cap assert r(N)>`impute_numobs'
    if _rc{
        replace PlanPctStocksNoChng_4_`year'=r(p$bin_pctile) if PctStocksNoChng_4_minval==`binmin`num'' & PctStocksNoChng_4_maxval==`binmax`num''
    }
    else{
        replace PlanPctStocksNoChng_4_`year'=(`binmin`num''+`binmin`num'')/2 if PctStocksNoChng_4_minval==`binmin`num'' & PctStocksNoChng_4_maxval==`binmax`num''
    }
}

/***********************************************************
 This is plan stock allocation IN COMPANY STOCK (DC) only
***********************************************************/
gen CompPctStocksNoChng_4_`year'=0
replace CompPctStocksNoChng_4_`year'=LJ816_4
replace CompPctStocksNoChng_4_`year'=. if LJ816_4==998 | LJ816_4==999
gen CompPctStocksNoChng_4_DkRF_`year'=0
replace CompPctStocksNoChng_4_DkRF_`year'=1 if LJ816_4==998 | LJ816_4==999
gen CPSNoChng_4_PointEst_`year'=0
replace CPSNoChng_4_PointEst_`year'=1 if CompPctStocksNoChng_4_DkRF_`year'==0

/* No binning necessary in 2008 */

/***************************************
 DORMANT PLANS FROM PREVIOUS JOBS
***************************************/
gen HasdormPlan_`year'=0
/* db plans */
replace HasdormPlan_`year'=1 if  LJ434_1M1==1  | LJ434_1M2==1   | LJ434_1M3==1    | LJ434_1M4==1
replace HasdormPlan_`year'=. if (LJ434_1M1==8  & LJ434_1M1==9)  | (LJ434_1M2==8 & LJ434_1M2==9) | (LJ434_1M3==8 & LJ434_1M3==9) | ///
                                (LJ434_1M4==8  & LJ434_1M4==9)
                                							
replace HasdormPlan_`year'=1 if  LJ434_2M1==1  | LJ434_2M2==1   | LJ434_2M3==1
replace HasdormPlan_`year'=. if (LJ434_2M1==8  & LJ434_2M1==9)  | (LJ434_2M2==8 & LJ434_2M2==9) | (LJ434_2M3==8 & LJ434_2M3==9)

replace HasdormPlan_`year'=1 if  LJ434_3M1==1  | LJ434_3M2==1
replace HasdormPlan_`year'=. if (LJ434_3M1==8  & LJ434_3M1==9)  | (LJ434_3M2==8 & LJ434_3M2==9)

replace HasdormPlan_`year'=1 if  LJ434_4M1==1  | LJ434_4M2==1
replace HasdormPlan_`year'=. if (LJ434_4M1==8  & LJ434_4M1==9)  | (LJ434_4M2==8 & LJ434_4M2==9)               


/* dc plans */
replace HasdormPlan_`year'=1 if  LJ450_1M1==1  | LJ450_1M2==1   | LJ450_1M3==1   | LJ450_1M4==1  
replace HasdormPlan_`year'=. if (LJ450_1M1>=95 & LJ450_1M1<=99) | (LJ450_1M2>=95 & LJ450_1M2<=99) | (LJ450_1M3>=95 & LJ450_1M3<=99) | ///
                                (LJ450_1M4>=95 & LJ450_1M4<=99) 
								
replace HasdormPlan_`year'=1 if  LJ450_2M1==1  | LJ450_2M2==1   | LJ450_2M3==1
replace HasdormPlan_`year'=. if (LJ450_2M1>=95 & LJ450_2M1<=99) | (LJ450_2M2>=95 & LJ450_2M2<=99) | (LJ450_2M3>=95 & LJ450_2M3<=99)

replace HasdormPlan_`year'=1 if  LJ450_3M1==1  | LJ450_3M2==1   | LJ450_3M3==1
replace HasdormPlan_`year'=. if (LJ450_3M1>=95 & LJ450_3M1<=99) | (LJ450_3M2>=95 & LJ450_3M2<=99) | (LJ450_3M3>=95 & LJ450_3M3<=99)
  
replace HasdormPlan_`year'=1 if  LJ450_4M1==1  | LJ450_4M2==1
replace HasdormPlan_`year'=. if (LJ450_4M1>=95 & LJ450_4M1<=99) | (LJ450_4M2>=95 & LJ450_4M2<=99)


/***************************************
 DORMANT PENSION #1
***************************************/
gen     dormHasdcPlan_1_`year'=0
replace dormHasdcPlan_1_`year'=1 if  LJ450_1M1==1  | LJ450_1M2==1   | LJ450_1M3==1   | LJ450_1M4==1   
replace dormHasdcPlan_1_`year'=. if (LJ450_1M1>=95 & LJ450_1M1<=99) | (LJ450_1M2>=95 & LJ450_1M2<=99) | (LJ450_1M3>=95 & LJ450_1M3<=99) | ///
                                    (LJ450_1M4>=95 & LJ450_1M4<=99) 

gen     dormHasdbPlan_1_`year'=0
replace dormHasdbPlan_1_`year'=1 if  LJ434_1M1==1  | LJ434_1M2==1   | LJ434_1M3==1
replace dormHasdbPlan_1_`year'=. if (LJ434_1M1==8  & LJ434_1M1==9)  | (LJ434_1M2==8 & LJ434_1M2==9) | (LJ434_1M3==8 & LJ434_1M3==9)

gen double dormPlanamt_1_`year'=0
replace    dormPlanamt_1_`year'=LJ465_1 if LJ465_1~=.

quietly sum dormPlanamt_1_`year' if dormPlanamt_1_`year'<=99999998, det
local MaxPlanamt=r(max)

gen double dormPlanamt_1_dkRf_`year'=0
replace dormPlanamt_1_dkRf_`year'=1 if dormPlanamt_1_`year'==99999998 | dormPlanamt_1_`year'==99999999
replace dormPlanamt_1_`year'=. if dormPlanamt_1_dkRf_`year'==1

gen double dormPlanamt_1_PointEst_`year'=0
replace dormPlanamt_1_PointEst_`year'=1 if dormPlanamt_1_`year'~=.

/* # of missings is verfied by codebook. 9/25, db */
gen double dormPlan_1_minval=LJ466_1
gen double dormPlan_1_maxval=LJ467_1

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
replace dormHasdcPlan_2_`year'=1 if  LJ450_2M1==1  | LJ450_2M2==1   | LJ450_2M3==1
replace dormHasdcPlan_2_`year'=. if (LJ450_2M1>=95 & LJ450_2M1<=99) | (LJ450_2M2>=95 & LJ450_2M2<=99) | (LJ450_2M3>=95 & LJ450_2M3<=99)

gen     dormHasdbPlan_2_`year'=0
replace dormHasdbPlan_2_`year'=1 if  LJ434_2M1==1  | LJ434_2M2==1   | LJ434_2M3==1
replace dormHasdbPlan_2_`year'=. if (LJ434_2M1==8  & LJ434_2M1==9)  | (LJ434_2M2==8 & LJ434_2M2==9) | (LJ434_2M3==8 & LJ434_2M3==9)
                                    

gen double dormPlanamt_2_`year'=0
replace    dormPlanamt_2_`year'=LJ465_2 if LJ465_2~=.

quietly sum dormPlanamt_2_`year' if dormPlanamt_2_`year'<=99999998, det
local MaxPlanamt=r(max)

gen double dormPlanamt_2_dkRf_`year'=0
replace dormPlanamt_2_dkRf_`year'=1 if dormPlanamt_2_`year'==99999998 | dormPlanamt_2_`year'==99999999
replace dormPlanamt_2_`year'=. if dormPlanamt_2_dkRf_`year'==1

gen double dormPlanamt_2_PointEst_`year'=0
replace dormPlanamt_2_PointEst_`year'=1 if dormPlanamt_2_`year'~=.

/* # of missings is verfied by codebook. 9/25, db */
gen double dormPlan_2_minval=LJ466_2
gen double dormPlan_2_maxval=LJ467_2

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
replace dormHasdcPlan_3_`year'=1 if  LJ450_3M1==1  | LJ450_3M2==1   | LJ450_3M3==1
replace dormHasdcPlan_3_`year'=. if (LJ450_3M1>=95 & LJ450_3M1<=99) | (LJ450_3M2>=95 & LJ450_3M2<=99) | (LJ450_3M3>=95 & LJ450_3M3<=99)

gen     dormHasdbPlan_3_`year'=0
replace dormHasdbPlan_3_`year'=1 if  LJ434_3M1==1  | LJ434_3M2==1
replace dormHasdbPlan_3_`year'=. if (LJ434_3M1==8  & LJ434_3M1==9)  | (LJ434_3M2==8 & LJ434_3M2==9)
                                    

gen double dormPlanamt_3_`year'=0
replace    dormPlanamt_3_`year'=LJ465_3 if LJ465_3~=.

quietly sum dormPlanamt_3_`year' if dormPlanamt_3_`year'<=99999998, det
local MaxPlanamt=r(max)

gen double dormPlanamt_3_dkRf_`year'=0
replace dormPlanamt_3_dkRf_`year'=1 if dormPlanamt_3_`year'==99999998 | dormPlanamt_3_`year'==99999999
replace dormPlanamt_3_`year'=. if dormPlanamt_3_dkRf_`year'==1

gen double dormPlanamt_3_PointEst_`year'=0
replace dormPlanamt_3_PointEst_`year'=1 if dormPlanamt_3_`year'~=.

/* # of missings is verfied by codebook. 9/25, db */
gen double dormPlan_3_minval=LJ466_3
gen double dormPlan_3_maxval=LJ467_3

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
replace dormHasdcPlan_4_`year'=1 if  LJ450_4M1==1  | LJ450_4M2==1
replace dormHasdcPlan_4_`year'=. if (LJ450_4M1>=95 & LJ450_4M1<=99) | (LJ450_4M2>=95 & LJ450_4M2<=99)

gen     dormHasdbPlan_4_`year'=0
replace dormHasdbPlan_4_`year'=1 if  LJ434_4M1==1  | LJ434_4M2==1
replace dormHasdbPlan_4_`year'=. if (LJ434_4M1==8  & LJ434_4M1==9)  | (LJ434_4M2==8 & LJ434_4M2==9)
                                    

gen double dormPlanamt_4_`year'=0
replace    dormPlanamt_4_`year'=LJ465_4 if LJ465_4~=.

quietly sum dormPlanamt_4_`year' if dormPlanamt_4_`year'<=99999998, det
local MaxPlanamt=r(max)

gen double dormPlanamt_4_dkRf_`year'=0
replace dormPlanamt_4_dkRf_`year'=1 if dormPlanamt_4_`year'==99999998 | dormPlanamt_4_`year'==99999999
replace dormPlanamt_4_`year'=. if dormPlanamt_4_dkRf_`year'==1

gen double dormPlanamt_4_PointEst_`year'=0
replace dormPlanamt_4_PointEst_`year'=1 if dormPlanamt_4_`year'~=.

/* # of missings is verfied by codebook. 9/25, db */
gen double dormPlan_4_minval=LJ466_4
gen double dormPlan_4_maxval=LJ467_4

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

gen TotCurrPenAmt_`year' =  PlanamtNochng_1_`year' + PlanamtNochng_2_`year' + PlanamtNochng_3_`year'+ PlanamtNochng_4_`year' 

gen TotDormPenAmt_`year' = dormPlanamt_1_`year' + dormPlanamt_2_`year' + dormPlanamt_3_`year' + dormPlanamt_4_`year' 

gen TotAllPenAmt_`year'  = TotPrevPenAmt_`year' + TotCurrPenAmt_`year' + TotDormPenAmt_`year'


gen PlanStockDoll_`year' =     (PlanPctStocksNoChng_1_`year'/100)*PlanamtNochng_1_`year'                                     + ///
							   (PlanPctStocksNoChng_2_`year'/100)*PlanamtNochng_2_`year'                                     + ///
							   (PlanPctStocksNoChng_3_`year'/100)*PlanamtNochng_3_`year'                                     + ///
							   (PlanPctStocksNoChng_4_`year'/100)*PlanamtNochng_4_`year'
							   
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
