/***********************************************************************************************************************************************************
															CURRENT JOB (SECTION J)
***********************************************************************************************************************************************************/
clear all
infile using "$HRSSurveys10/h10sta/H10J_R.dct" , using("$HRSSurveys10/h10da/H10J_R.da")
local year "2010"
gen YEAR=`year'
sort HHID MSUBHH
gen SUBHH=MSUBHH

local flag=0
local impute_numobs=0

/****************************************************************************
 Job change since last wave or no?
****************************************************************************/ 
gen SameEmployer_`year' =.
replace SameEmployer_`year'=1 if MJ045==1 | MJ045==3
replace SameEmployer_`year'=0 if MJ045==4 | MJ045==5

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
replace PrevEmpPens_`year'=1 if MJ084==1
replace PrevEmpPens_`year'=. if MJ084==8 | MJ084==9

gen PrevEmpNumPlans_`year'=MJ085
replace PrevEmpNumPlans_`year'=. if MJ085>=95
replace PrevEmpNumPlans_`year'=1 if MJ086==1

/***************************************
PENSION 1
***************************************/
gen     PrevEmpdbPlan_1_`year'=0
replace PrevEmpdbPlan_1_`year'=1 if MJW001A==1
replace PrevEmpdbPlan_1_`year'=. if MJW001A==8 | MJW001A==9

gen     PrevEmpdcPlan_1_`year'=0
replace PrevEmpdcPlan_1_`year'=1 if MJW001A==2
replace PrevEmpdcPlan_1_`year'=. if MJW001A==8 | MJW001A==9

gen double PrevPlanamt_1_`year'=0
replace    PrevPlanamt_1_`year'=MJW009A if MJW009A~=.

quietly sum PrevPlanamt_1_`year' if PrevPlanamt_1_`year'<=99999998, det
local MaxPrevPlanamt=r(max)

gen double PrevPlanamt_1_dkRf_`year'=0
replace PrevPlanamt_1_dkRf_`year'=1 if PrevPlanamt_1_`year'==99999998 | PrevPlanamt_1_`year'==99999999
replace PrevPlanamt_1_`year'=. if PrevPlanamt_1_dkRf_`year'==1

gen double PrevPlanamt_1_PointEst_`year'=0
replace PrevPlanamt_1_PointEst_`year'=1 if PrevPlanamt_1_`year'~=.

/* # of missings is verfied by codebook. 9/25, db */
gen double PrevPlan_1_minval=MJW010A
gen double PrevPlan_1_maxval=MJW011A

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
replace PrevEmpdbPlan_2_`year'=1 if MJW001B==1
replace PrevEmpdbPlan_2_`year'=. if MJW001B==8 | MJW001B==9

gen PrevEmpdcPlan_2_`year'=0
replace PrevEmpdcPlan_2_`year'=1 if MJW001B==2
replace PrevEmpdcPlan_2_`year'=. if MJW001B==8 | MJW001B==9

gen double PrevPlanamt_2_`year'=0
replace    PrevPlanamt_2_`year'=MJW009B if MJW009B~=.

quietly sum PrevPlanamt_2_`year' if PrevPlanamt_2_`year'<=99999998, det
local MaxPrevPlanamt=r(max)

gen double PrevPlanamt_2_dkRf_`year'=0
replace PrevPlanamt_2_dkRf_`year'=1 if PrevPlanamt_2_`year'==99999998 | PrevPlanamt_2_`year'==99999999
replace PrevPlanamt_2_`year'=. if PrevPlanamt_2_dkRf_`year'==1

gen double PrevPlanamt_2_PointEst_`year'=0
replace PrevPlanamt_2_PointEst_`year'=1 if PrevPlanamt_2_`year'~=.

/* # of missings is verfied by codebook. 9/25, db */
gen double PrevPlan_2_minval=MJW010B
gen double PrevPlan_2_maxval=MJW011B

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
replace PrevEmpdbPlan_3_`year'=1 if MJW001C==1
replace PrevEmpdbPlan_3_`year'=. if MJW001C==8 | MJW001C==9

gen PrevEmpdcPlan_3_`year'=0
replace PrevEmpdcPlan_3_`year'=1 if MJW001C==2
replace PrevEmpdcPlan_3_`year'=. if MJW001C==8 | MJW001C==9

gen double PrevPlanamt_3_`year'=0
replace    PrevPlanamt_3_`year'=MJW009C if MJW009C~=.

quietly sum PrevPlanamt_3_`year' if PrevPlanamt_3_`year'<=99999998, det
local MaxPrevPlanamt=r(max)

gen double PrevPlanamt_3_dkRf_`year'=0
replace PrevPlanamt_3_dkRf_`year'=1 if PrevPlanamt_3_`year'==99999998 | PrevPlanamt_3_`year'==99999999
replace PrevPlanamt_3_`year'=. if PrevPlanamt_3_dkRf_`year'==1

gen double PrevPlanamt_3_PointEst_`year'=0
replace PrevPlanamt_3_PointEst_`year'=1 if PrevPlanamt_3_`year'~=.

/* # of missings is verfied by codebook. 9/25, db */
gen double PrevPlan_3_minval=MJW010C
gen double PrevPlan_3_maxval=MJW011C

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
replace PrevEmpdbPlan_4_`year'=1 if MJW001D==1
replace PrevEmpdbPlan_4_`year'=. if MJW001D==8 | MJW001D==9

gen PrevEmpdcPlan_4_`year'=0
replace PrevEmpdcPlan_4_`year'=1 if MJW001D==2
replace PrevEmpdcPlan_4_`year'=. if MJW001D==8 | MJW001D==9

gen double PrevPlanamt_4_`year'=0
replace    PrevPlanamt_4_`year'=MJW009D if MJW009D~=.

quietly sum PrevPlanamt_4_`year' if PrevPlanamt_4_`year'<=99999998, det
local MaxPrevPlanamt=r(max)

gen double PrevPlanamt_4_dkRf_`year'=0
replace PrevPlanamt_4_dkRf_`year'=1 if PrevPlanamt_4_`year'==.
replace PrevPlanamt_4_`year'=. if PrevPlanamt_4_dkRf_`year'==1

gen double PrevPlanamt_4_PointEst_`year'=0
replace PrevPlanamt_4_PointEst_`year'=1 if PrevPlanamt_4_`year'~=.

/* Binning and current job pension code available in archived versions*/

/****************************************************************************
                         IF DID NOT CHANGE JOBS
****************************************************************************/
/***************************************
PENSION AT CURRENT JOB #1
***************************************/ 		 
gen     PlanType_1_`year'=0
replace PlanType_1_`year'=MJ338_1 if MJ338_1~=.	 

* If dcordbPlan=1, then dc, if 0 then db
gen     HasdcPlan_1_`year'=0
replace HasdcPlan_1_`year'=1 if MJ393_1==1 | MJ393_1==2 | (MJ393_1>=4 & MJ393_1<95)
replace HasdcPlan_1_`year'=. if MJ393_1>=95 & MJ393_1~=.

gen     HasdbPlan_1_`year'=0
replace HasdbPlan_1_`year'=1 if MJ393_1==3
replace HasdbPlan_1_`year'=. if MJ393_1>=95 & MJ393_1~=.	 

/***************************************************
 This is plan amount for type a and b account only
***************************************************/
gen PlanamtNochng_1_`year'    =     0

/***************************************************
 This is plan amount for type b account (dc) only
***************************************************/
replace PlanamtNochng_1_`year'=     MJ413_1 if MJ413_1~=.
replace PlanamtNochng_1_`year'=.            if MJ413_1==99999996 | MJ413_1==99999998 | MJ413_1==99999999
gen PlanamtNochng_1_dkRf_`year'=0
replace PlanamtNochng_1_dkRf_`year'=1 if PlanamtNochng_1_`year'==.
gen PlanamtNochng_1_PointEst_`year'=0
replace PlanamtNochng_1_PointEst_`year'=1 if PlanamtNochng_1_dkRf_`year'==0

gen double PlanNochng_1_minval=MJ414_1
gen double PlanNochng_1_maxval=MJ415_1

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
replace PlanPctStocksNoChng_1_`year'=MJ812_1 if MJ812_1~=.
replace PlanPctStocksNoChng_1_`year'=. if MJ812_1==998 | MJ812_1==999
gen PlanPctStocksNoChng_1_DkRF_`year'=0
replace PlanPctStocksNoChng_1_DkRF_`year'=1 if MJ812_1==998 | MJ812_1==999
gen PPS_NoChng_1_PointEst_`year'=0
replace PPS_NoChng_1_PointEst_`year'=1 if PlanPctStocksNoChng_1_DkRF_`year'==0

gen double PctStocksNoChng_1_minval=MJ813_1
gen double PctStocksNoChng_1_maxval=MJ814_1

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
replace CompPctStocksNoChng_1_`year'=MJ816_1
replace CompPctStocksNoChng_1_`year'=. if MJ816_1==998 | MJ816_1==999
gen CompPctStocksNoChng_1_DkRF_`year'=0
replace CompPctStocksNoChng_1_DkRF_`year'=1 if MJ816_1==998 | MJ816_1==999
gen CPSNoChng_1_PointEst_`year'=0
replace CPSNoChng_1_PointEst_`year'=1 if CompPctStocksNoChng_1_DkRF_`year'==0

gen double CompPctStocksNoChng_1_minval=MJ817_1
gen double CompPctStocksNoChng_1_maxval=MJ818_1

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
gen     PlanType_2_`year'=0
replace PlanType_2_`year'=MJ338_2 if MJ338_2~=.	 

* If dcordbPlan=1, then dc, if 0 then db
gen     HasdcPlan_2_`year'=0
replace HasdcPlan_2_`year'=1 if MJ393_2==1 | MJ393_2==2 | (MJ393_2>=4 & MJ393_2<95)
replace HasdcPlan_2_`year'=. if MJ393_2>=95 & MJ393_2~=.

gen     HasdbPlan_2_`year'=0
replace HasdbPlan_2_`year'=1 if MJ393_2==3
replace HasdbPlan_2_`year'=. if MJ393_2>=95 & MJ393_2~=.	 

/***************************************************
 This is plan amount for type a and b account only
***************************************************/
gen PlanamtNochng_2_`year'    =     0

/***************************************************
 This is plan amount for type b account (dc) only
***************************************************/
replace PlanamtNochng_2_`year'=     MJ413_2 if MJ413_2~=.
replace PlanamtNochng_2_`year'=.            if MJ413_2==99999996 | MJ413_2==99999998 | MJ413_2==99999999
gen PlanamtNochng_2_dkRf_`year'=0
replace PlanamtNochng_2_dkRf_`year'=1 if PlanamtNochng_2_`year'==.
gen PlanamtNochng_2_PointEst_`year'=0
replace PlanamtNochng_2_PointEst_`year'=1 if PlanamtNochng_2_dkRf_`year'==0

gen double PlanNochng_2_minval=MJ414_2
gen double PlanNochng_2_maxval=MJ415_2

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
replace PlanPctStocksNoChng_2_`year'=MJ812_2 if MJ812_2~=.
replace PlanPctStocksNoChng_2_`year'=. if MJ812_2==998 | MJ812_2==999
gen PlanPctStocksNoChng_2_DkRF_`year'=0
replace PlanPctStocksNoChng_2_DkRF_`year'=1 if MJ812_2==998 | MJ812_2==999
gen PPS_NoChng_2_PointEst_`year'=0
replace PPS_NoChng_2_PointEst_`year'=1 if PlanPctStocksNoChng_2_DkRF_`year'==0

gen double PctStocksNoChng_2_minval=MJ813_2
gen double PctStocksNoChng_2_maxval=MJ814_2

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
replace CompPctStocksNoChng_2_`year'=MJ816_2
replace CompPctStocksNoChng_2_`year'=. if MJ816_2==998 | MJ816_2==999
gen CompPctStocksNoChng_2_DkRF_`year'=0
replace CompPctStocksNoChng_2_DkRF_`year'=1 if MJ816_2==998 | MJ816_2==999
gen CPSNoChng_2_PointEst_`year'=0
replace CPSNoChng_2_PointEst_`year'=1 if CompPctStocksNoChng_2_DkRF_`year'==0

gen double CompPctStocksNoChng_2_minval=MJ817_2
gen double CompPctStocksNoChng_2_maxval=MJ818_2

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
gen     PlanType_3_`year'=0
replace PlanType_3_`year'=MJ338_3 if MJ338_3~=.	 

* If dcordbPlan=1, then dc, if 0 then db
gen     HasdcPlan_3_`year'=0
replace HasdcPlan_3_`year'=1 if MJ393_3==1 | MJ393_3==2 | (MJ393_3>=4 & MJ393_3<95)
replace HasdcPlan_3_`year'=. if MJ393_3>=95 & MJ393_3~=.

gen     HasdbPlan_3_`year'=0
replace HasdbPlan_3_`year'=1 if MJ393_3==3
replace HasdbPlan_3_`year'=. if MJ393_3>=95 & MJ393_3~=.	 

/***************************************************
 This is plan amount for type a and b account only
***************************************************/
gen PlanamtNochng_3_`year'    =     0

/***************************************************
 This is plan amount for type b account (dc) only
***************************************************/
replace PlanamtNochng_3_`year'=     MJ413_3 if MJ413_3~=.
replace PlanamtNochng_3_`year'=.            if MJ413_3==99999996 | MJ413_3==99999998 | MJ413_3==99999999
gen PlanamtNochng_3_dkRf_`year'=0
replace PlanamtNochng_3_dkRf_`year'=1 if PlanamtNochng_3_`year'==.
gen PlanamtNochng_3_PointEst_`year'=0
replace PlanamtNochng_3_PointEst_`year'=1 if PlanamtNochng_3_dkRf_`year'==0

gen double PlanNochng_3_minval=MJ414_3
gen double PlanNochng_3_maxval=MJ415_3

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
replace PlanPctStocksNoChng_3_`year'=MJ812_3 if MJ812_3~=.
replace PlanPctStocksNoChng_3_`year'=. if MJ812_3==998 | MJ812_3==999
gen PlanPctStocksNoChng_3_DkRF_`year'=0
replace PlanPctStocksNoChng_3_DkRF_`year'=1 if MJ812_3==998 | MJ812_3==999
gen PPS_NoChng_3_PointEst_`year'=0
replace PPS_NoChng_3_PointEst_`year'=1 if PlanPctStocksNoChng_3_DkRF_`year'==0

gen double PctStocksNoChng_3_minval=MJ813_3
gen double PctStocksNoChng_3_maxval=MJ814_3

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
replace CompPctStocksNoChng_3_`year'=MJ816_3
replace CompPctStocksNoChng_3_`year'=. if MJ816_3==998 | MJ816_3==999
gen CompPctStocksNoChng_3_DkRF_`year'=0
replace CompPctStocksNoChng_3_DkRF_`year'=1 if MJ816_3==998 | MJ816_3==999
gen CPSNoChng_3_PointEst_`year'=0
replace CPSNoChng_3_PointEst_`year'=1 if CompPctStocksNoChng_3_DkRF_`year'==0

/***************************************
PENSION AT CURRENT JOb #4
***************************************/ 		 
gen     PlanType_4_`year'=0
replace PlanType_4_`year'=MJ338_4 if MJ338_4~=.	 

* If dcordbPlan=1, then dc, if 0 then db
gen     HasdcPlan_4_`year'=0
replace HasdcPlan_4_`year'=1 if MJ393_4==1 | MJ393_4==2 | (MJ393_4>=4 & MJ393_4<95)
replace HasdcPlan_4_`year'=. if MJ393_4>=95 & MJ393_4~=.

gen     HasdbPlan_4_`year'=0
replace HasdbPlan_4_`year'=1 if MJ393_4==3
replace HasdbPlan_4_`year'=. if MJ393_4>=95 & MJ393_4~=.	 

/***************************************************
 This is plan amount for type a and b account only
***************************************************/
gen PlanamtNochng_4_`year'    =     0

/***************************************************
 This is plan amount for type b account (dc) only
***************************************************/
replace PlanamtNochng_4_`year'=     MJ413_4 if MJ413_4~=.
replace PlanamtNochng_4_`year'=.            if MJ413_4==99999996 | MJ413_4==99999998 | MJ413_4==99999999
gen PlanamtNochng_4_dkRf_`year'=0
replace PlanamtNochng_4_dkRf_`year'=1 if PlanamtNochng_4_`year'==.
gen PlanamtNochng_4_PointEst_`year'=0
replace PlanamtNochng_4_PointEst_`year'=1 if PlanamtNochng_4_dkRf_`year'==0

/***********************************************************
 This is plan stock allocation for type B account (DC) only
***********************************************************/
gen PlanPctStocksNoChng_4_`year'=0
replace PlanPctStocksNoChng_4_`year'=MJ812_4 if MJ812_4~=.
replace PlanPctStocksNoChng_4_`year'=. if MJ812_4==998 | MJ812_4==999
gen PlanPctStocksNoChng_4_DkRF_`year'=0
replace PlanPctStocksNoChng_4_DkRF_`year'=1 if MJ812_4==998 | MJ812_4==999
gen PPS_NoChng_4_PointEst_`year'=0
replace PPS_NoChng_4_PointEst_`year'=1 if PlanPctStocksNoChng_4_DkRF_`year'==0

gen double PctStocksNoChng_4_minval=MJ813_4
gen double PctStocksNoChng_4_maxval=MJ814_4

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
replace CompPctStocksNoChng_4_`year'=MJ816_4
replace CompPctStocksNoChng_4_`year'=. if MJ816_4==998 | MJ816_4==999
gen CompPctStocksNoChng_4_DkRF_`year'=0
replace CompPctStocksNoChng_4_DkRF_`year'=1 if MJ816_4==998 | MJ816_4==999
gen CPSNoChng_4_PointEst_`year'=0
replace CPSNoChng_4_PointEst_`year'=1 if CompPctStocksNoChng_4_DkRF_`year'==0

/***************************************
 DORMANT PLANS FROM PREVIOUS JOBS
***************************************/
gen HasdormPlan_`year'=0
/* db plans */
replace HasdormPlan_`year'=1 if (MJW097M1E==3 | MJW097M1E==10)  | (MJW097M2E==3  | MJW097M2E==10) | (MJW097M3E==3  | MJW097M3E==10) | ///
                                (MJW097M4E==3 | MJW097M4E==10)  | (MJW097M5E==3  | MJW097M5E==10) | (MJW097M6E==3  | MJW097M6E==10)
replace HasdormPlan_`year'=. if (MJW097M1E==98 | MJW097M1E==99) | (MJW097M2E==98 | MJW097M2E==99) | (MJW097M3E==98 | MJW097M3E==99) | ///
                                (MJW097M4E==98 | MJW097M4E==99) | (MJW097M5E==98 | MJW097M5E==99) | (MJW097M6E==98 | MJW097M6E==99)
                                
								
replace HasdormPlan_`year'=1 if (MJW097M1F==3  | MJW097M1F==10)  | (MJW097M2F==3  | MJW097M2F==10) | (MJW097M3F==3  | MJW097M3F==10)
replace HasdormPlan_`year'=. if (MJW097M1F==98 | MJW097M1F==99)  | (MJW097M2F==98 | MJW097M2F==99) | (MJW097M3F==98 | MJW097M3F==99)

replace HasdormPlan_`year'=1 if (MJW097M1G==3  | MJW097M1G==10)  | (MJW097M2G==3  | MJW097M2G==10)
replace HasdormPlan_`year'=. if (MJW097M1G==98 | MJW097M1G==99)  | (MJW097M2G==98 | MJW097M2G==99)

replace HasdormPlan_`year'=1 if (MJW097M1H==3  | MJW097M1H==10)
replace HasdormPlan_`year'=. if (MJW097M1H==98 | MJW097M1H==99)               


/***************************************
 DORMANT PENSION #1
***************************************/
gen     DormHasDCPlan_1_`year'=0
replace DormHasDCPlan_1_`year'=1 if MJW082E==1 | MJW082E==2 | (MJW082E>=4 & MJW082E<95)
replace DormHasDCPlan_1_`year'=. if MJW082E>=95 & MJW082E~=.

gen     DormHasDBPlan_1_`year'=0
replace DormHasDBPlan_1_`year'=1 if MJW082E==3
replace DormHasDBPlan_1_`year'=. if MJW082E>=95 & MJW082E~=.

gen double DormPlanAmt_1_`year'=0
replace    DormPlanAmt_1_`year'=MJW009E if MJW009E~=.

quietly sum DormPlanAmt_1_`year' if DormPlanAmt_1_`year'<=99999998, det
local MaxPlanAmt=r(max)

gen double DormPlanAmt_1_DkRf_`year'=0
replace DormPlanAmt_1_DkRf_`year'=1 if DormPlanAmt_1_`year'==99999998 | DormPlanAmt_1_`year'==99999999
replace DormPlanAmt_1_`year'=. if DormPlanAmt_1_DkRf_`year'==1

gen double DormPlanAmt_1_PointEst_`year'=0
replace DormPlanAmt_1_PointEst_`year'=1 if DormPlanAmt_1_`year'~=.

/* # of missings is verfied by codebook. 9/25, DB */
gen double DormPlan_1_minval=MJW010E
gen double DormPlan_1_maxval=MJW011E

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
replace DormHasDCPlan_2_`year'=1 if MJW082F==1 | MJW082F==2 | (MJW082F>=4 & MJW082F<95)
replace DormHasDCPlan_2_`year'=. if MJW082F>=95 & MJW082F~=.

gen     DormHasDBPlan_2_`year'=0
replace DormHasDBPlan_2_`year'=1 if MJW082F==3
replace DormHasDBPlan_2_`year'=. if MJW082F>=95 & MJW082F~=.

gen double DormPlanAmt_2_`year'=0
replace    DormPlanAmt_2_`year'=MJW009F if MJW009F~=.

quietly sum DormPlanAmt_2_`year' if DormPlanAmt_2_`year'<=99999998, det
local MaxPlanAmt=r(max)

gen double DormPlanAmt_2_DkRf_`year'=0
replace DormPlanAmt_2_DkRf_`year'=1 if DormPlanAmt_2_`year'==99999998 | DormPlanAmt_2_`year'==99999999
replace DormPlanAmt_2_`year'=. if DormPlanAmt_2_DkRf_`year'==1

gen double DormPlanAmt_2_PointEst_`year'=0
replace DormPlanAmt_2_PointEst_`year'=1 if DormPlanAmt_2_`year'~=.

/* # of missings is verfied by codebook. 9/25, DB */
gen double DormPlan_2_minval=MJW010F
gen double DormPlan_2_maxval=MJW011F

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
replace DormHasDCPlan_3_`year'=1 if MJW082G==1 | MJW082G==2 | (MJW082G>=4 & MJW082G<95)
replace DormHasDCPlan_3_`year'=. if MJW082G>=95 & MJW082G~=.

gen     DormHasDBPlan_3_`year'=0
replace DormHasDBPlan_3_`year'=1 if MJW082G==3
replace DormHasDBPlan_3_`year'=. if MJW082G>=95 & MJW082G~=.

gen double DormPlanAmt_3_`year'=0
replace    DormPlanAmt_3_`year'=MJW009G if MJW009G~=.

quietly sum DormPlanAmt_3_`year' if DormPlanAmt_3_`year'<=99999998, det
local MaxPlanAmt=r(max)

gen double DormPlanAmt_3_DkRf_`year'=0
replace DormPlanAmt_3_DkRf_`year'=1 if DormPlanAmt_3_`year'==99999998 | DormPlanAmt_3_`year'==99999999
replace DormPlanAmt_3_`year'=. if DormPlanAmt_3_DkRf_`year'==1

gen double DormPlanAmt_3_PointEst_`year'=0
replace DormPlanAmt_3_PointEst_`year'=1 if DormPlanAmt_3_`year'~=.

/* # of missings is verfied by codebook. 9/25, DB */
gen double DormPlan_3_minval=MJW010G
gen double DormPlan_3_maxval=MJW011G

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
replace DormHasDCPlan_4_`year'=1 if MJW082H==1 | MJW082H==2 | (MJW082H>=4 & MJW082H<95)
replace DormHasDCPlan_4_`year'=. if MJW082H>=95 & MJW082H~=.

gen     DormHasDBPlan_4_`year'=0
replace DormHasDBPlan_4_`year'=1 if MJW082H==3
replace DormHasDBPlan_4_`year'=. if MJW082H>=95 & MJW082H~=.

gen double DormPlanAmt_4_`year'=0
replace    DormPlanAmt_4_`year'=MJW009H if MJW009H~=.

quietly sum DormPlanAmt_4_`year' if DormPlanAmt_4_`year'<=9999998, det
local MaxPlanAmt=r(max)

gen double DormPlanAmt_4_DkRf_`year'=0
replace DormPlanAmt_4_DkRf_`year'=1 if DormPlanAmt_4_`year'==9999998 | DormPlanAmt_4_`year'==9999999
replace DormPlanAmt_4_`year'=. if DormPlanAmt_4_DkRf_`year'==1

gen double DormPlanAmt_4_PointEst_`year'=0
replace DormPlanAmt_4_PointEst_`year'=1 if DormPlanAmt_4_`year'~=.
/* No obs, 2010 */

/****************************************************************************
       AGGREGATES
****************************************************************************/
gen TotPrevPenAmt_`year' = PrevPlanamt_1_`year' + PrevPlanamt_2_`year' + PrevPlanamt_3_`year' + PrevPlanamt_4_`year' 

gen TotCurrPenAmt_`year' = PlanamtNochng_1_`year' + PlanamtNochng_2_`year' + PlanamtNochng_3_`year' + PlanamtNochng_4_`year'

gen TotDormPenAmt_`year' = DormPlanAmt_1_`year' + DormPlanAmt_2_`year' + DormPlanAmt_3_`year' + DormPlanAmt_4_`year' 

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
                          DormHasDBPlan_1_`year'==1 | DormHasDBPlan_2_`year'==1 | DormHasDBPlan_3_`year'==1 | DormHasDBPlan_4_`year'==1 

gen     HasDC_`year'=0
replace HasDC_`year'=1 if HasdcPlan_1_`year'==1     | HasdcPlan_2_`year'==1     | HasdcPlan_3_`year'==1     | HasdcPlan_4_`year'==1 | ///
                          PrevEmpdcPlan_1_`year'==1 | PrevEmpdcPlan_2_`year'==1 | PrevEmpdcPlan_3_`year'==1 | PrevEmpdcPlan_4_`year'==1 | ///
                          DormHasDCPlan_1_`year'==1 | DormHasDCPlan_2_`year'==1 | DormHasDCPlan_3_`year'==1 | DormHasDCPlan_4_`year'==1 


keep HHID SUBHH PN HasDB_`year' HasDC_`year' TotAllPenAmt_`year' PlanStockDoll_`year' PrevEmpPens_`year'
save "$CleanData/Pension`year'.dta", replace
