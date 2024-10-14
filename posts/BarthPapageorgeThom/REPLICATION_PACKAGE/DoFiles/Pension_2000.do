/***********************************************************************************************************************************************************
															CURRENT JOB (SECTION G)
***********************************************************************************************************************************************************/
clear all
infile using "$HRSSurveys00/h00sta/H00G_R.dct" , using("$HRSSurveys00/h00da/H00G_R.da")
local year "2000"
gen YEAR=`year'
sort HHID GSUBHH
gen SUBHH=GSUBHH

local flag=0
local impute_numobs=0

/****************************************************************************
 Job change since last wave or no?
****************************************************************************/ 
gen SameEmployer_`year' =.
replace SameEmployer_`year'=1 if G3416==1
replace SameEmployer_`year'=0 if G3416==5

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
replace PrevEmpPens_`year'=1 if G3452==1
replace PrevEmpPens_`year'=. if G3452==8 | G3452==9

/***************************************
PENSION 1 (for Type A & B accounts)
***************************************/
gen PrevEmpdbPlan_1_`year'=0
replace PrevEmpdbPlan_1_`year'=1 if G3455_1==1 | G3455_1==3
replace PrevEmpdbPlan_1_`year'=. if G3455_1==8 | G3455_1==9

gen PrevEmpdcPlan_1_`year'=0
replace PrevEmpdcPlan_1_`year'=1 if G3455_1==2 | G3455_1==3
replace PrevEmpdcPlan_1_`year'=. if G3455_1==8 | G3455_1==9

gen double PrevPlanAmt_1_`year'=0
replace    PrevPlanAmt_1_`year'=G3458_1 if G3458_1~=.

quietly sum PrevPlanAmt_1_`year' if PrevPlanAmt_1_`year'<=99999998, det
local MaxPrevPlanAmt=r(max)

gen double PrevPlanAmt_1_dkRf_`year'=0
replace PrevPlanAmt_1_dkRf_`year'=1 if PrevPlanAmt_1_`year'==99999998 | PrevPlanAmt_1_`year'==99999999
replace PrevPlanAmt_1_`year'=. if PrevPlanAmt_1_dkRf_`year'==1

gen double PrevPlanAmt_1_PointEst_`year'=0
replace PrevPlanAmt_1_PointEst_`year'=1 if PrevPlanAmt_1_`year'~=.

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

quietly sum PrevPlanAmt_4_`year' if PrevPlanAmt_4_`year'<=99999998, det
local MaxPrevPlanAmt=r(max)

gen double PrevPlanAmt_4_dkRf_`year'=0
replace PrevPlanAmt_4_dkRf_`year'=1 if PrevPlanAmt_4_`year'==99999998 | PrevPlanAmt_4_`year'==99999999
replace PrevPlanAmt_4_`year'=. if PrevPlanAmt_4_dkRf_`year'==1

gen double PrevPlanAmt_4_PointEst_`year'=0
replace PrevPlanAmt_4_PointEst_`year'=1 if PrevPlanAmt_4_`year'~=.

/***************************************
PENSION 1 (for B accounts)
***************************************/
replace    PrevPlanAmt_1_`year'=G3488_1 if G3488_1~=.
replace    PrevPlanAmt_1_`year'=.       if G3488_1==99999998 | G3488_1==99999999 

replace PrevPlanAmt_1_dkRf_`year'=1 if G3488_1==99999998 | G3488_1==99999999
replace PrevPlanAmt_1_PointEst_`year'=1 if PrevPlanAmt_1_`year'~=.

/***************************************
PENSION 2 (for B accounts)
***************************************/
replace    PrevPlanAmt_2_`year'=G3488_2 if G3488_2~=.
replace    PrevPlanAmt_2_`year'=.       if G3488_2==99999998 | G3488_2==99999999 

replace PrevPlanAmt_2_dkRf_`year'=1 if G3488_2==99999998 | G3488_2==99999999
replace PrevPlanAmt_2_PointEst_`year'=1 if PrevPlanAmt_2_`year'~=.

/***************************************
PENSION 3 (for B accounts)
***************************************/
replace    PrevPlanAmt_3_`year'=G3488_3 if G3488_3~=.
replace    PrevPlanAmt_3_`year'=.       if G3488_3==99999998 | G3488_3==99999999 

replace PrevPlanAmt_3_dkRf_`year'=1 if G3488_3==99999998 | G3488_3==99999999
replace PrevPlanAmt_3_PointEst_`year'=1 if PrevPlanAmt_3_`year'~=.

/***************************************
PENSION 4 (for B accounts)
***************************************/
replace    PrevPlanAmt_4_`year'=G3488_1 if G3488_4~=.
replace    PrevPlanAmt_4_`year'=.       if G3488_4==99999998 | G3488_1==99999999 

replace PrevPlanAmt_4_dkRf_`year'=1 if G3488_4==99999998 | G3488_4==99999999
replace PrevPlanAmt_4_PointEst_`year'=1 if PrevPlanAmt_4_`year'~=.

/****************************************************************************
                          CURRENT JOB PENSIONS
****************************************************************************/
gen     NumPen_`year'=0
replace NumPen_`year'=G3621 if G3621~=.
replace NumPen_`year'=.     if G3621==98 | G3621==99

gen     HasPen_`year'=0
replace HasPen_`year'=1     if NumPen_`year'>0
replace HasPen_`year'=.     if NumPen_`year'==.


/***************************************
  PENSION AT CURRENT JOB #1
***************************************/
gen PlanType_1_`year'=G3624_1
		 
* If dcordbPlan=1, then dc, if 0 then db
gen     HasdcPlan_1_`year'=0
replace HasdcPlan_1_`year'=1 if G3624_1==2 | G3624_1==3
replace HasdcPlan_1_`year'=. if G3624_1>=8 & G3624_1~=.

gen     HasdbPlan_1_`year'=0
replace HasdbPlan_1_`year'=1 if G3624_1==1 | G3624_1==3
replace HasdbPlan_1_`year'=. if G3624_1>=8 & G3624_1~=.
 
/***************************************************
 This is plan amount for type a&b account, the (dc) part only
***************************************************/
gen PlanAmt_1_`year'    =     0
replace PlanAmt_1_`year'=     G3625_1 if G3625_1~=.
replace PlanAmt_1_`year'=.           if G3625_1==99999998 | G3625_1==99999999
gen PlanAmt_aandb_1_dkRf_`year'=0
replace PlanAmt_aandb_1_dkRf_`year'=1 if PlanAmt_1_`year'==.
gen PlanAmt_aandb_1_PointEst_`year'=0
replace PlanAmt_aandb_1_PointEst_`year'=1 if PlanAmt_aandb_1_dkRf_`year'==0

/***************************************************
 This is plan amount for type b plan (dc) only
***************************************************/
replace PlanAmt_1_`year'=     G3643_1 if G3643_1~=.
replace PlanAmt_1_`year'=.           if G3643_1==99999998 | G3643_1==99999999
gen PlanAmt_1_dkRf_`year'=0
replace PlanAmt_1_dkRf_`year'=1 if PlanAmt_1_`year'==.
gen PlanAmt_1_PointEst_`year'=0
replace PlanAmt_1_PointEst_`year'=1 if PlanAmt_1_dkRf_`year'==0

local PlanAmt_1_Bin1 5000
local PlanAmt_1_Bin2 20000
local PlanAmt_1_Bin3 50000
local PlanAmt_1_Bin4 150000

local PlanAmt_1_Tree1 G3645_1
local PlanAmt_1_Tree2 G3644_1
local PlanAmt_1_Tree3 G3646_1
local PlanAmt_1_Tree4 G3647_1

**** Less than first bin lower bound ****
sum PlanAmt_1_`year' if (PlanAmt_1_`year'<99999998 & PlanAmt_1_`year'~=.) & PlanAmt_1_`year'>0 & PlanAmt_1_`year'<`PlanAmt_1_Bin1', detail
*return list
assert r(N)>`impute_numobs'
replace PlanAmt_1_`year'=r(p$bin_pctile) if `PlanAmt_1_Tree1'==1
replace PlanAmt_1_`year'=`PlanAmt_1_Bin1' if `PlanAmt_1_Tree1'==3

**** Second Bin ****
sum PlanAmt_1_`year' if (PlanAmt_1_`year'<99999998 & PlanAmt_1_`year'~=.) & PlanAmt_1_`year'>`PlanAmt_1_Bin1' & PlanAmt_1_`year'<`PlanAmt_1_Bin2', detail
*return list
assert r(N)>`impute_numobs'
replace PlanAmt_1_`year'=r(p$bin_pctile) if `PlanAmt_1_Tree2'==1 & `PlanAmt_1_Tree1'==5
replace PlanAmt_1_`year'=`PlanAmt_1_Bin2' if `PlanAmt_1_Tree2'==3

**** Third Bin ****
sum PlanAmt_1_`year' if (PlanAmt_1_`year'<99999998 & PlanAmt_1_`year'~=.) & PlanAmt_1_`year'>`PlanAmt_1_Bin2' & PlanAmt_1_`year'<`PlanAmt_1_Bin3', detail
*return list
assert r(N)>`impute_numobs'
replace PlanAmt_1_`year'=r(p$bin_pctile) if `PlanAmt_1_Tree3'==1 & `PlanAmt_1_Tree2'==5
replace PlanAmt_1_`year'=`PlanAmt_1_Bin3' if `PlanAmt_1_Tree3'==3

**** Fourth Bin ****
sum PlanAmt_1_`year' if (PlanAmt_1_`year'<99999998 & PlanAmt_1_`year'~=.) & PlanAmt_1_`year'>`PlanAmt_1_Bin3' & PlanAmt_1_`year'<`PlanAmt_1_Bin4', detail
*return list
assert r(N)>`impute_numobs'
replace PlanAmt_1_`year'=r(p$bin_pctile) if `PlanAmt_1_Tree4'==1 & `PlanAmt_1_Tree3'==5
replace PlanAmt_1_`year'=`PlanAmt_1_Bin4' if `PlanAmt_1_Tree4'==3

**** Greater than Fourth Bin ****
sum PlanAmt_1_`year' if (PlanAmt_1_`year'<99999998 & PlanAmt_1_`year'~=.) & PlanAmt_1_`year'>`PlanAmt_1_Bin4', detail
*return list
assert r(N)>`impute_numobs'
replace PlanAmt_1_`year'=r(p$bin_pctile) if `PlanAmt_1_Tree4'==5


/***************************************
PENSION AT CURRENT JOB #2
***************************************/
gen PlanType_2_`year'=G3624_2		 
		 
* If dcordbPlan=1, then dc, if 0 then db
gen     HasdcPlan_2_`year'=0
replace HasdcPlan_2_`year'=1 if G3624_2==2 | G3624_2==3
replace HasdcPlan_2_`year'=. if G3624_2>=8 & G3624_2~=.

gen     HasdbPlan_2_`year'=0
replace HasdbPlan_2_`year'=1 if G3624_2==1 | G3624_2==3
replace HasdbPlan_2_`year'=. if G3624_2>=8 & G3624_2~=.
 

/***************************************************
 This is plan amount for type a&b account, the (dc) part only
***************************************************/
gen PlanAmt_2_`year'    =     0
replace PlanAmt_2_`year'=     G3625_2 if G3625_2~=.
replace PlanAmt_2_`year'=.           if G3625_2==99999998 | G3625_2==99999999
gen PlanAmt_aandb_2_dkRf_`year'=0
replace PlanAmt_aandb_2_dkRf_`year'=1 if PlanAmt_2_`year'==.
gen PlanAmt_aandb_2_PointEst_`year'=0
replace PlanAmt_aandb_2_PointEst_`year'=1 if PlanAmt_aandb_2_dkRf_`year'==0

/***************************************************
 This is plan amount for type b plan (dc) only
***************************************************/
replace PlanAmt_2_`year'=     G3643_2 if G3643_2~=.
replace PlanAmt_2_`year'=.           if G3643_2==99999998 | G3643_2==99999999
gen PlanAmt_2_dkRf_`year'=0
replace PlanAmt_2_dkRf_`year'=1 if PlanAmt_2_`year'==.
gen PlanAmt_2_PointEst_`year'=0
replace PlanAmt_2_PointEst_`year'=1 if PlanAmt_2_dkRf_`year'==0

local PlanAmt_2_Bin1 5000
local PlanAmt_2_Bin2 20000
local PlanAmt_2_Bin3 50000
local PlanAmt_2_Bin4 150000

local PlanAmt_2_Tree1 G3645_2
local PlanAmt_2_Tree2 G3644_2
local PlanAmt_2_Tree3 G3646_2
local PlanAmt_2_Tree4 G3647_2

**** Less than first bin lower bound ****
sum PlanAmt_2_`year' if (PlanAmt_2_`year'<99999998 & PlanAmt_2_`year'~=.) & PlanAmt_2_`year'>0 & PlanAmt_2_`year'<`PlanAmt_2_Bin1', detail
*return list
assert r(N)>`impute_numobs'
replace PlanAmt_2_`year'=r(p$bin_pctile) if `PlanAmt_2_Tree1'==1
replace PlanAmt_2_`year'=`PlanAmt_2_Bin1' if `PlanAmt_2_Tree1'==3

**** Second Bin ****
sum PlanAmt_2_`year' if (PlanAmt_2_`year'<99999998 & PlanAmt_2_`year'~=.) & PlanAmt_2_`year'>`PlanAmt_2_Bin1' & PlanAmt_2_`year'<`PlanAmt_2_Bin2', detail
*return list
assert r(N)>`impute_numobs'
replace PlanAmt_2_`year'=r(p$bin_pctile) if `PlanAmt_2_Tree2'==1 & `PlanAmt_2_Tree1'==5
replace PlanAmt_2_`year'=`PlanAmt_2_Bin2' if `PlanAmt_2_Tree2'==3

**** Third Bin ****
sum PlanAmt_2_`year' if (PlanAmt_2_`year'<99999998 & PlanAmt_2_`year'~=.) & PlanAmt_2_`year'>`PlanAmt_2_Bin2' & PlanAmt_2_`year'<`PlanAmt_2_Bin3', detail
*return list
assert r(N)>`impute_numobs'
replace PlanAmt_2_`year'=r(p$bin_pctile) if `PlanAmt_2_Tree3'==1 & `PlanAmt_2_Tree2'==5
replace PlanAmt_2_`year'=`PlanAmt_2_Bin3' if `PlanAmt_2_Tree3'==3

**** Fourth Bin ****
sum PlanAmt_2_`year' if (PlanAmt_2_`year'<99999998 & PlanAmt_2_`year'~=.) & PlanAmt_2_`year'>`PlanAmt_2_Bin3' & PlanAmt_2_`year'<`PlanAmt_2_Bin4', detail
*return list
assert r(N)>`impute_numobs'
replace PlanAmt_2_`year'=r(p$bin_pctile) if `PlanAmt_2_Tree4'==1 & `PlanAmt_2_Tree3'==5
replace PlanAmt_2_`year'=`PlanAmt_2_Bin4' if `PlanAmt_2_Tree4'==3

**** Greater than Fourth Bin ****
sum PlanAmt_2_`year' if (PlanAmt_2_`year'<99999998 & PlanAmt_2_`year'~=.) & PlanAmt_2_`year'>`PlanAmt_2_Bin4', detail
*return list
assert r(N)>`impute_numobs'
replace PlanAmt_2_`year'=r(p$bin_pctile) if `PlanAmt_2_Tree4'==5


/***************************************
PENSION AT CURRENT JOB #3
***************************************/
gen PlanType_3_`year'=G3624_3		 
		 
* If dcordbPlan=1, then dc, if 0 then db
gen     HasdcPlan_3_`year'=0
replace HasdcPlan_3_`year'=1 if G3624_3==2 | G3624_3==3
replace HasdcPlan_3_`year'=. if G3624_3>=8 & G3624_3~=.

gen     HasdbPlan_3_`year'=0
replace HasdbPlan_3_`year'=1 if G3624_3==1 | G3624_3==3
replace HasdbPlan_3_`year'=. if G3624_3>=8 & G3624_3~=.
 

/***************************************************
 This is plan amount for type a&b account, the (dc) part only
***************************************************/
gen PlanAmt_3_`year'    =     0
replace PlanAmt_3_`year'=     G3625_3 if G3625_3~=.
replace PlanAmt_3_`year'=.           if G3625_3==99999998 | G3625_3==99999999
gen PlanAmt_aandb_3_dkRf_`year'=0
replace PlanAmt_aandb_3_dkRf_`year'=1 if PlanAmt_3_`year'==.
gen PlanAmt_aandb_3_PointEst_`year'=0
replace PlanAmt_aandb_3_PointEst_`year'=1 if PlanAmt_aandb_3_dkRf_`year'==0


/***************************************************
 This is plan amount for type b plan (dc) only
***************************************************/
replace PlanAmt_3_`year'=     G3643_3 if G3643_3~=.
replace PlanAmt_3_`year'=.           if G3643_3==99999998 | G3643_3==99999999
gen PlanAmt_3_dkRf_`year'=0
replace PlanAmt_3_dkRf_`year'=1 if PlanAmt_3_`year'==.
gen PlanAmt_3_PointEst_`year'=0
replace PlanAmt_3_PointEst_`year'=1 if PlanAmt_3_dkRf_`year'==0

local PlanAmt_3_Bin1 5000
local PlanAmt_3_Bin2 20000
local PlanAmt_3_Bin3 50000
local PlanAmt_3_Bin4 150000

local PlanAmt_3_Tree1 G3645_3
local PlanAmt_3_Tree2 G3644_3
local PlanAmt_3_Tree3 G3646_3
local PlanAmt_3_Tree4 G3647_3

**** Less than first bin lower bound ****
sum PlanAmt_3_`year' if (PlanAmt_3_`year'<99999998 & PlanAmt_3_`year'~=.) & PlanAmt_3_`year'>0 & PlanAmt_3_`year'<`PlanAmt_3_Bin1', detail
*return list
assert r(N)>`impute_numobs'
replace PlanAmt_3_`year'=r(p$bin_pctile) if `PlanAmt_3_Tree1'==1
replace PlanAmt_3_`year'=`PlanAmt_3_Bin1' if `PlanAmt_3_Tree1'==3

**** Second Bin ****
sum PlanAmt_3_`year' if (PlanAmt_3_`year'<99999998 & PlanAmt_3_`year'~=.) & PlanAmt_3_`year'>`PlanAmt_3_Bin1' & PlanAmt_3_`year'<`PlanAmt_3_Bin2', detail
*return list
assert r(N)>`impute_numobs'
replace PlanAmt_3_`year'=r(p$bin_pctile) if `PlanAmt_3_Tree2'==1 & `PlanAmt_3_Tree1'==5
replace PlanAmt_3_`year'=`PlanAmt_3_Bin2' if `PlanAmt_3_Tree2'==3

**** Third Bin ****
sum PlanAmt_3_`year' if (PlanAmt_3_`year'<99999998 & PlanAmt_3_`year'~=.) & PlanAmt_3_`year'>`PlanAmt_3_Bin2' & PlanAmt_3_`year'<`PlanAmt_3_Bin3', detail
*return list
assert r(N)>`impute_numobs'
replace PlanAmt_3_`year'=r(p$bin_pctile) if `PlanAmt_3_Tree3'==1 & `PlanAmt_3_Tree2'==5
replace PlanAmt_3_`year'=`PlanAmt_3_Bin3' if `PlanAmt_3_Tree3'==3

**** Fourth Bin ****
sum PlanAmt_3_`year' if (PlanAmt_3_`year'<99999998 & PlanAmt_3_`year'~=.) & PlanAmt_3_`year'>`PlanAmt_3_Bin3' & PlanAmt_3_`year'<`PlanAmt_3_Bin4', detail
*return list
assert r(N)>`impute_numobs'
replace PlanAmt_3_`year'=r(p$bin_pctile) if `PlanAmt_3_Tree4'==1 & `PlanAmt_3_Tree3'==5
replace PlanAmt_3_`year'=`PlanAmt_3_Bin4' if `PlanAmt_3_Tree4'==3

**** Greater than Fourth Bin ****
sum PlanAmt_3_`year' if (PlanAmt_3_`year'<99999998 & PlanAmt_3_`year'~=.) & PlanAmt_3_`year'>`PlanAmt_3_Bin4', detail
*return list
assert r(N)>`impute_numobs'
replace PlanAmt_3_`year'=r(p$bin_pctile) if `PlanAmt_3_Tree4'==5


/***************************************
PENSION AT CURRENT JOB #4
***************************************/
gen PlanType_4_`year'=G3624_4		 
		 
* If dcordbPlan=1, then dc, if 0 then db
gen     HasdcPlan_4_`year'=0
replace HasdcPlan_4_`year'=1 if G3624_4==2 | G3624_4==3
replace HasdcPlan_4_`year'=. if G3624_4>=8 & G3624_4~=.

gen     HasdbPlan_4_`year'=0
replace HasdbPlan_4_`year'=1 if G3624_4==1 | G3624_4==3
replace HasdbPlan_4_`year'=. if G3624_4>=8 & G3624_4~=.
 

/***************************************************
 This is plan amount for type a&b account, the (dc) part only
***************************************************/
gen PlanAmt_4_`year'    =     0
replace PlanAmt_4_`year'=     G3625_4 if G3625_4~=.
replace PlanAmt_4_`year'=.           if G3625_4==99999998 | G3625_4==99999999
gen PlanAmt_aandb_4_dkRf_`year'=0
replace PlanAmt_aandb_4_dkRf_`year'=1 if PlanAmt_4_`year'==.
gen PlanAmt_aandb_4_PointEst_`year'=0
replace PlanAmt_aandb_4_PointEst_`year'=1 if PlanAmt_aandb_4_dkRf_`year'==0


/***************************************************
 This is plan amount for type b plan (dc) only
***************************************************/
replace PlanAmt_4_`year'=     G3643_4 if G3643_4~=.
replace PlanAmt_4_`year'=.           if G3643_4==99999998 | G3643_4==99999999
gen PlanAmt_4_dkRf_`year'=0
replace PlanAmt_4_dkRf_`year'=1 if PlanAmt_4_`year'==.
gen PlanAmt_4_PointEst_`year'=0
replace PlanAmt_4_PointEst_`year'=1 if PlanAmt_4_dkRf_`year'==0

local PlanAmt_4_Bin1 5000
local PlanAmt_4_Bin2 20000
local PlanAmt_4_Bin3 50000
local PlanAmt_4_Bin4 150000

local PlanAmt_4_Tree1 G3645_4
local PlanAmt_4_Tree2 G3644_4
local PlanAmt_4_Tree3 G3646_4
local PlanAmt_4_Tree4 G3647_4

**** Less than first bin lower bound ****
sum PlanAmt_4_`year' if (PlanAmt_4_`year'<99999998 & PlanAmt_4_`year'~=.) & PlanAmt_4_`year'>0 & PlanAmt_4_`year'<`PlanAmt_4_Bin1', detail
*return list
assert r(N)>`impute_numobs'
replace PlanAmt_4_`year'=r(p$bin_pctile) if `PlanAmt_4_Tree1'==1
replace PlanAmt_4_`year'=`PlanAmt_4_Bin1' if `PlanAmt_4_Tree1'==3

**** Second Bin ****
sum PlanAmt_4_`year' if (PlanAmt_4_`year'<99999998 & PlanAmt_4_`year'~=.) & PlanAmt_4_`year'>`PlanAmt_4_Bin1' & PlanAmt_4_`year'<`PlanAmt_4_Bin2', detail
*return list
assert r(N)>`impute_numobs'
replace PlanAmt_4_`year'=r(p$bin_pctile) if `PlanAmt_4_Tree2'==1 & `PlanAmt_4_Tree1'==5
replace PlanAmt_4_`year'=`PlanAmt_4_Bin2' if `PlanAmt_4_Tree2'==3

**** Third Bin ****
sum PlanAmt_4_`year' if (PlanAmt_4_`year'<99999998 & PlanAmt_4_`year'~=.) & PlanAmt_4_`year'>`PlanAmt_4_Bin2' & PlanAmt_4_`year'<`PlanAmt_4_Bin3', detail
*return list
assert r(N)== 0
replace PlanAmt_4_`year'=(`PlanAmt_4_Bin2'+`PlanAmt_4_Bin3')/2 if `year'==2000 & `PlanAmt_4_Tree3'==1 & `PlanAmt_4_Tree2'==5
replace PlanAmt_4_`year'=`PlanAmt_4_Bin3' if `PlanAmt_4_Tree3'==3

**** Fourth Bin ****
sum PlanAmt_4_`year' if (PlanAmt_4_`year'<99999998 & PlanAmt_4_`year'~=.) & PlanAmt_4_`year'>`PlanAmt_4_Bin3' & PlanAmt_4_`year'<`PlanAmt_4_Bin4', detail
*return list
assert r(N)>`impute_numobs'
replace PlanAmt_4_`year'=r(p$bin_pctile) if `PlanAmt_4_Tree4'==1 & `PlanAmt_4_Tree3'==5
replace PlanAmt_4_`year'=`PlanAmt_4_Bin4' if `PlanAmt_4_Tree4'==3

**** Greater than Fourth Bin ****
sum PlanAmt_4_`year' if (PlanAmt_4_`year'<99999998 & PlanAmt_4_`year'~=.) & PlanAmt_4_`year'>`PlanAmt_4_Bin4', detail
*return list
assert r(N)==0
replace PlanAmt_4_`year'=`PlanAmt_4_Bin4' if `PlanAmt_4_Tree4'==5

/****************************************************************************
                          CURRENT JOB PENSIONS
****************************************************************************/
replace NumPen_`year'=G3678 if G3678~=.
replace NumPen_`year'=.     if G3678==98 | G3678==99

replace HasPen_`year'=1     if NumPen_`year'>0
replace HasPen_`year'=.     if NumPen_`year'==.

/***************************************
  PENSION AT CURRENT JOB #1
***************************************/
* If dcordbPlan=1, then dc, if 0 then db
replace HasdcPlan_1_`year'=1 if G3683_1==2 | G3683_1==3
replace HasdcPlan_1_`year'=. if G3683_1>=8 & G3683_1~=.

replace HasdbPlan_1_`year'=1 if G3683_1==1 | G3683_1==3
replace HasdbPlan_1_`year'=. if G3683_1>=8 & G3683_1~=.

/***************************************************
 This is plan amount for type a&b account, the (dc) part only
***************************************************/
replace PlanAmt_1_`year'=     G3684_1 if G3684_1~=.
replace PlanAmt_1_`year'=.           if G3684_1==99999998 | G3684_1==99999999
replace PlanAmt_aandb_1_dkRf_`year'=1 if PlanAmt_1_`year'==.
replace PlanAmt_aandb_1_PointEst_`year'=1 if PlanAmt_aandb_1_dkRf_`year'==0

/***************************************************
 This is plan amount for type b plan (dc) only
***************************************************/
replace PlanAmt_1_`year'=     G3755_1 if G3755_1~=.
replace PlanAmt_1_`year'=.           if G3755_1==99999998 | G3755_1==99999999
replace PlanAmt_1_dkRf_`year'=1 if PlanAmt_1_`year'==.
replace PlanAmt_1_PointEst_`year'=1 if PlanAmt_1_dkRf_`year'==0

local PlanAmt_1_Bin1 5000
local PlanAmt_1_Bin2 20000
local PlanAmt_1_Bin3 50000
local PlanAmt_1_Bin4 150000

local PlanAmt_1_Tree1 G3757_1
local PlanAmt_1_Tree2 G3756_1
local PlanAmt_1_Tree3 G3758_1
local PlanAmt_1_Tree4 G3759_1

**** Less than first bin lower bound ****
sum PlanAmt_1_`year' if (PlanAmt_1_`year'<99999998 & PlanAmt_1_`year'~=.) & PlanAmt_1_`year'>0 & PlanAmt_1_`year'<`PlanAmt_1_Bin1', detail
*return list
assert r(N)>`impute_numobs'
replace PlanAmt_1_`year'=r(p$bin_pctile) if `PlanAmt_1_Tree1'==1
replace PlanAmt_1_`year'=`PlanAmt_1_Bin1' if `PlanAmt_1_Tree1'==3

**** Second Bin ****
sum PlanAmt_1_`year' if (PlanAmt_1_`year'<99999998 & PlanAmt_1_`year'~=.) & PlanAmt_1_`year'>`PlanAmt_1_Bin1' & PlanAmt_1_`year'<`PlanAmt_1_Bin2', detail
*return list
assert r(N)>`impute_numobs'
replace PlanAmt_1_`year'=r(p$bin_pctile) if `PlanAmt_1_Tree2'==1 & `PlanAmt_1_Tree1'==5
replace PlanAmt_1_`year'=`PlanAmt_1_Bin2' if `PlanAmt_1_Tree2'==3

**** Third Bin ****
sum PlanAmt_1_`year' if (PlanAmt_1_`year'<99999998 & PlanAmt_1_`year'~=.) & PlanAmt_1_`year'>`PlanAmt_1_Bin2' & PlanAmt_1_`year'<`PlanAmt_1_Bin3', detail
*return list
assert r(N)>`impute_numobs'
replace PlanAmt_1_`year'=r(p$bin_pctile) if `PlanAmt_1_Tree3'==1 & `PlanAmt_1_Tree2'==5
replace PlanAmt_1_`year'=`PlanAmt_1_Bin3' if `PlanAmt_1_Tree3'==3

**** Fourth Bin ****
sum PlanAmt_1_`year' if (PlanAmt_1_`year'<99999998 & PlanAmt_1_`year'~=.) & PlanAmt_1_`year'>`PlanAmt_1_Bin3' & PlanAmt_1_`year'<`PlanAmt_1_Bin4', detail
*return list
assert r(N)>`impute_numobs'
replace PlanAmt_1_`year'=r(p$bin_pctile) if `PlanAmt_1_Tree4'==1 & `PlanAmt_1_Tree3'==5
replace PlanAmt_1_`year'=`PlanAmt_1_Bin4' if `PlanAmt_1_Tree4'==3

**** Greater than Fourth Bin ****
sum PlanAmt_1_`year' if (PlanAmt_1_`year'<99999998 & PlanAmt_1_`year'~=.) & PlanAmt_1_`year'>`PlanAmt_1_Bin4', detail
*return list
assert r(N)>`impute_numobs'
replace PlanAmt_1_`year'=r(p$bin_pctile) if `PlanAmt_1_Tree4'==5

/***********************************************************
 This is plan stock allocation for type b account (dc) only
***********************************************************/
gen PlanPctStocks_1_`year'=0
replace PlanPctStocks_1_`year'= 1 if G3761_1==1
replace PlanPctStocks_1_`year'=.5 if G3761_1==3
replace PlanPctStocks_1_`year'=.  if G3761_1==8 | G3761_1==9
gen PlanPctStocks_1_dkRF_`year'=0
replace PlanPctStocks_1_dkRF_`year'=1 if G3761_1==7 | G3761_1==8 | G3761_1==9
gen PPS_1_PointEst_`year'=0
replace PPS_1_PointEst_`year'=1 if PlanPctStocks_1_dkRF_`year'==0

/***************************************
PENSION AT CURRENT JOB #2
***************************************/
* If dcordbPlan=1, then dc, if 0 then db
replace HasdcPlan_2_`year'=1 if G3683_2==2 | G3683_2==3
replace HasdcPlan_2_`year'=. if G3683_2>=8 & G3683_2~=.

replace HasdbPlan_2_`year'=1 if G3683_2==1 | G3683_2==3
replace HasdbPlan_2_`year'=. if G3683_2>=8 & G3683_2~=.

/***************************************************
 This is plan amount for type a&b account, the (dc) part only
***************************************************/
replace PlanAmt_2_`year'=     G3684_2 if G3684_2~=.
replace PlanAmt_2_`year'=.           if G3684_2==99999998 | G3684_2==99999999
replace PlanAmt_aandb_2_dkRf_`year'=1 if PlanAmt_2_`year'==.
replace PlanAmt_aandb_2_PointEst_`year'=1 if PlanAmt_aandb_2_dkRf_`year'==0

/***************************************************
 This is plan amount for type b plan (dc) only
***************************************************/
replace PlanAmt_2_`year'=     G3755_2 if G3755_2~=.
replace PlanAmt_2_`year'=.           if G3755_2==99999998 | G3755_2==99999999
replace PlanAmt_2_dkRf_`year'=1 if PlanAmt_2_`year'==.
replace PlanAmt_2_PointEst_`year'=1 if PlanAmt_2_dkRf_`year'==0

local PlanAmt_2_Bin1 5000
local PlanAmt_2_Bin2 20000
local PlanAmt_2_Bin3 50000
local PlanAmt_2_Bin4 150000

local PlanAmt_2_Tree1 G3757_2
local PlanAmt_2_Tree2 G3756_2
local PlanAmt_2_Tree3 G3758_2
local PlanAmt_2_Tree4 G3759_2

**** Less than first bin lower bound ****
sum PlanAmt_2_`year' if (PlanAmt_2_`year'<99999998 & PlanAmt_2_`year'~=.) & PlanAmt_2_`year'>0 & PlanAmt_2_`year'<`PlanAmt_2_Bin1', detail
*return list
assert r(N)>`impute_numobs'
replace PlanAmt_2_`year'=r(p$bin_pctile) if `PlanAmt_2_Tree1'==1
replace PlanAmt_2_`year'=`PlanAmt_2_Bin1' if `PlanAmt_2_Tree1'==3

**** Second Bin ****
sum PlanAmt_2_`year' if (PlanAmt_2_`year'<99999998 & PlanAmt_2_`year'~=.) & PlanAmt_2_`year'>`PlanAmt_2_Bin1' & PlanAmt_2_`year'<`PlanAmt_2_Bin2', detail
*return list
assert r(N)>`impute_numobs'
replace PlanAmt_2_`year'=r(p$bin_pctile) if `PlanAmt_2_Tree2'==1 & `PlanAmt_2_Tree1'==5
replace PlanAmt_2_`year'=`PlanAmt_2_Bin2' if `PlanAmt_2_Tree2'==3

**** Third Bin ****
sum PlanAmt_2_`year' if (PlanAmt_2_`year'<99999998 & PlanAmt_2_`year'~=.) & PlanAmt_2_`year'>`PlanAmt_2_Bin2' & PlanAmt_2_`year'<`PlanAmt_2_Bin3', detail
*return list
assert r(N)>`impute_numobs'
replace PlanAmt_2_`year'=r(p$bin_pctile) if `PlanAmt_2_Tree3'==1 & `PlanAmt_2_Tree2'==5
replace PlanAmt_2_`year'=`PlanAmt_2_Bin3' if `PlanAmt_2_Tree3'==3

**** Fourth Bin ****
sum PlanAmt_2_`year' if (PlanAmt_2_`year'<99999998 & PlanAmt_2_`year'~=.) & PlanAmt_2_`year'>`PlanAmt_2_Bin3' & PlanAmt_2_`year'<`PlanAmt_2_Bin4', detail
*return list
assert r(N)>`impute_numobs'
replace PlanAmt_2_`year'=r(p$bin_pctile) if `PlanAmt_2_Tree4'==1 & `PlanAmt_2_Tree3'==5
replace PlanAmt_2_`year'=`PlanAmt_2_Bin4' if `PlanAmt_2_Tree4'==3

**** Greater than Fourth Bin ****
sum PlanAmt_2_`year' if (PlanAmt_2_`year'<99999998 & PlanAmt_2_`year'~=.) & PlanAmt_2_`year'>`PlanAmt_2_Bin4', detail
*return list
assert r(N)>`impute_numobs'
replace PlanAmt_2_`year'=r(p$bin_pctile) if `PlanAmt_2_Tree4'==5

/***********************************************************
 This is plan stock allocation for type b account (dc) only
***********************************************************/
gen PlanPctStocks_2_`year'=0
replace PlanPctStocks_2_`year'= 1 if G3761_2==1
replace PlanPctStocks_2_`year'=.5 if G3761_2==3
replace PlanPctStocks_2_`year'=.  if G3761_2==8 | G3761_2==9
gen PlanPctStocks_2_dkRF_`year'=0
replace PlanPctStocks_2_dkRF_`year'=1 if G3761_2==7 | G3761_2==8 | G3761_2==9
gen PPS_2_PointEst_`year'=0
replace PPS_2_PointEst_`year'=1 if PlanPctStocks_2_dkRF_`year'==0

/***************************************
PENSION AT CURRENT JOB #3
***************************************/
* If dcordbPlan=1, then dc, if 0 then db
replace HasdcPlan_3_`year'=1 if G3683_3==2 | G3683_3==3
replace HasdcPlan_3_`year'=. if G3683_3>=8 & G3683_3~=.

replace HasdbPlan_3_`year'=1 if G3683_3==1 | G3683_3==3
replace HasdbPlan_3_`year'=. if G3683_3>=8 & G3683_3~=.

/***************************************************
 This is plan amount for type a&b account, the (dc) part only
***************************************************/
replace PlanAmt_3_`year'=     G3684_3 if G3684_3~=.
replace PlanAmt_3_`year'=.           if G3684_3==99999998 | G3684_3==99999999
replace PlanAmt_aandb_3_dkRf_`year'=1 if PlanAmt_3_`year'==.
replace PlanAmt_aandb_3_PointEst_`year'=1 if PlanAmt_aandb_3_dkRf_`year'==0

/***************************************************
 This is plan amount for type b plan (dc) only
***************************************************/
replace PlanAmt_3_`year'=     G3755_3 if G3755_3~=.
replace PlanAmt_3_`year'=.           if G3755_3==99999998 | G3755_3==99999999
replace PlanAmt_3_dkRf_`year'=1 if PlanAmt_3_`year'==.
replace PlanAmt_3_PointEst_`year'=1 if PlanAmt_3_dkRf_`year'==0

local PlanAmt_3_Bin1 5000
local PlanAmt_3_Bin2 20000
local PlanAmt_3_Bin3 50000
local PlanAmt_3_Bin4 150000

local PlanAmt_3_Tree1 G3757_3
local PlanAmt_3_Tree2 G3756_3
local PlanAmt_3_Tree3 G3758_3
local PlanAmt_3_Tree4 G3759_3

**** Less than first bin lower bound ****
sum PlanAmt_3_`year' if (PlanAmt_3_`year'<99999998 & PlanAmt_3_`year'~=.) & PlanAmt_3_`year'>0 & PlanAmt_3_`year'<`PlanAmt_3_Bin1', detail
*return list
assert r(N)>`impute_numobs'
replace PlanAmt_3_`year'=r(p$bin_pctile) if `PlanAmt_3_Tree1'==1
replace PlanAmt_3_`year'=`PlanAmt_3_Bin1' if `PlanAmt_3_Tree1'==3

**** Second Bin ****
sum PlanAmt_3_`year' if (PlanAmt_3_`year'<99999998 & PlanAmt_3_`year'~=.) & PlanAmt_3_`year'>`PlanAmt_3_Bin1' & PlanAmt_3_`year'<`PlanAmt_3_Bin2', detail
*return list
assert r(N)>`impute_numobs'
replace PlanAmt_3_`year'=r(p$bin_pctile) if `PlanAmt_3_Tree2'==1 & `PlanAmt_3_Tree1'==5
replace PlanAmt_3_`year'=`PlanAmt_3_Bin2' if `PlanAmt_3_Tree2'==3

**** Third Bin ****
sum PlanAmt_3_`year' if (PlanAmt_3_`year'<99999998 & PlanAmt_3_`year'~=.) & PlanAmt_3_`year'>`PlanAmt_3_Bin2' & PlanAmt_3_`year'<`PlanAmt_3_Bin3', detail
*return list
assert r(N)>`impute_numobs'
replace PlanAmt_3_`year'=r(p$bin_pctile) if `PlanAmt_3_Tree3'==1 & `PlanAmt_3_Tree2'==5
replace PlanAmt_3_`year'=`PlanAmt_3_Bin3' if `PlanAmt_3_Tree3'==3

**** Fourth Bin ****
sum PlanAmt_3_`year' if (PlanAmt_3_`year'<99999998 & PlanAmt_3_`year'~=.) & PlanAmt_3_`year'>`PlanAmt_3_Bin3' & PlanAmt_3_`year'<`PlanAmt_3_Bin4', detail
*return list
assert r(N)>`impute_numobs'
replace PlanAmt_3_`year'=r(p$bin_pctile) if `PlanAmt_3_Tree4'==1 & `PlanAmt_3_Tree3'==5
replace PlanAmt_3_`year'=`PlanAmt_3_Bin4' if `PlanAmt_3_Tree4'==3

**** Greater than Fourth Bin ****
sum PlanAmt_3_`year' if (PlanAmt_3_`year'<99999998 & PlanAmt_3_`year'~=.) & PlanAmt_3_`year'>`PlanAmt_3_Bin4', detail
*return list
assert r(N)>`impute_numobs'
replace PlanAmt_3_`year'=r(p$bin_pctile) if `PlanAmt_3_Tree4'==5

/***********************************************************
 This is plan stock allocation for type b account (dc) only
***********************************************************/
gen PlanPctStocks_3_`year'=0
replace PlanPctStocks_3_`year'= 1 if G3761_3==1
replace PlanPctStocks_3_`year'=.5 if G3761_3==3
replace PlanPctStocks_3_`year'=.  if G3761_3==8 | G3761_3==9
gen PlanPctStocks_3_dkRF_`year'=0
replace PlanPctStocks_3_dkRF_`year'=1 if G3761_3==7 | G3761_3==8 | G3761_3==9
gen PPS_3_PointEst_`year'=0
replace PPS_3_PointEst_`year'=1 if PlanPctStocks_3_dkRF_`year'==0

/***************************************
PENSION AT CURRENT JOB #4
***************************************/
* If dcordbPlan=1, then dc, if 0 then db
replace HasdcPlan_4_`year'=1 if G3683_4==2 | G3683_4==3
replace HasdcPlan_4_`year'=. if G3683_4>=8 & G3683_4~=.

replace HasdbPlan_4_`year'=1 if G3683_4==1 | G3683_4==3
replace HasdbPlan_4_`year'=. if G3683_4>=8 & G3683_4~=.

/***************************************************
 This is plan amount for type a&b account, the (dc) part only
***************************************************/
replace PlanAmt_4_`year'=     G3684_4 if G3684_4~=.
replace PlanAmt_4_`year'=.           if G3684_4==99999998 | G3684_4==99999999
replace PlanAmt_aandb_4_dkRf_`year'=1 if PlanAmt_4_`year'==.
replace PlanAmt_aandb_4_PointEst_`year'=1 if PlanAmt_aandb_4_dkRf_`year'==0

/***************************************************
 This is plan amount for type b plan (dc) only
***************************************************/
replace PlanAmt_4_`year'=     G3755_4 if G3755_4~=.
replace PlanAmt_4_`year'=.           if G3755_4==99999998 | G3755_4==99999999
replace PlanAmt_4_dkRf_`year'=1 if PlanAmt_4_`year'==.
replace PlanAmt_4_PointEst_`year'=1 if PlanAmt_4_dkRf_`year'==0

local PlanAmt_4_Bin1 5000
local PlanAmt_4_Bin2 20000
local PlanAmt_4_Bin3 50000
local PlanAmt_4_Bin4 150000

local PlanAmt_4_Tree1 G3757_4
local PlanAmt_4_Tree2 G3756_4
local PlanAmt_4_Tree3 G3758_4
local PlanAmt_4_Tree4 G3759_4

**** Less than first bin lower bound ****
sum PlanAmt_4_`year' if (PlanAmt_4_`year'<99999998 & PlanAmt_4_`year'~=.) & PlanAmt_4_`year'>0 & PlanAmt_4_`year'<`PlanAmt_4_Bin1', detail
*return list
assert r(N)>`impute_numobs'
replace PlanAmt_4_`year'=r(p$bin_pctile) if `PlanAmt_4_Tree1'==1
replace PlanAmt_4_`year'=`PlanAmt_4_Bin1' if `PlanAmt_4_Tree1'==3

**** Second Bin ****
sum PlanAmt_4_`year' if (PlanAmt_4_`year'<99999998 & PlanAmt_4_`year'~=.) & PlanAmt_4_`year'>`PlanAmt_4_Bin1' & PlanAmt_4_`year'<`PlanAmt_4_Bin2', detail
*return list
assert r(N)>`impute_numobs'
replace PlanAmt_4_`year'=r(p$bin_pctile) if `PlanAmt_4_Tree2'==1 & `PlanAmt_4_Tree1'==5
replace PlanAmt_4_`year'=`PlanAmt_4_Bin2' if `PlanAmt_4_Tree2'==3

**** Third Bin ****
sum PlanAmt_4_`year' if (PlanAmt_4_`year'<99999998 & PlanAmt_4_`year'~=.) & PlanAmt_4_`year'>`PlanAmt_4_Bin2' & PlanAmt_4_`year'<`PlanAmt_4_Bin3', detail
*return list
*assert r(N)>`impute_numobs'
replace PlanAmt_4_`year'=(`PlanAmt_4_Bin2'+`PlanAmt_4_Bin3')/2  if `year'==2000 & `PlanAmt_4_Tree3'==1 & `PlanAmt_4_Tree2'==5
replace PlanAmt_4_`year'=`PlanAmt_4_Bin3' if `PlanAmt_4_Tree3'==3

**** Fourth Bin ****
sum PlanAmt_4_`year' if (PlanAmt_4_`year'<99999998 & PlanAmt_4_`year'~=.) & PlanAmt_4_`year'>`PlanAmt_4_Bin3' & PlanAmt_4_`year'<`PlanAmt_4_Bin4', detail
*return list
assert r(N)>`impute_numobs'
replace PlanAmt_4_`year'=r(p$bin_pctile) if `PlanAmt_4_Tree4'==1 & `PlanAmt_4_Tree3'==5
replace PlanAmt_4_`year'=`PlanAmt_4_Bin4' if `PlanAmt_4_Tree4'==3

**** Greater than Fourth Bin ****
sum PlanAmt_4_`year' if (PlanAmt_4_`year'<99999998 & PlanAmt_4_`year'~=.) & PlanAmt_4_`year'>`PlanAmt_4_Bin4'
*return list
assert r(N)>`impute_numobs'
replace PlanAmt_4_`year'=r(p$bin_pctile) if `PlanAmt_4_Tree4'==5

/***********************************************************
 This is plan stock allocation for type b account (dc) only
***********************************************************/
gen PlanPctStocks_4_`year'=0
replace PlanPctStocks_4_`year'= 1 if G3761_4==1
replace PlanPctStocks_4_`year'=.5 if G3761_4==3
replace PlanPctStocks_4_`year'=.  if G3761_4==8 | G3761_4==9
gen PlanPctStocks_4_dkRF_`year'=0
replace PlanPctStocks_4_dkRF_`year'=1 if G3761_4==7 | G3761_4==8 | G3761_4==9
gen PPS_4_PointEst_`year'=0
replace PPS_4_PointEst_`year'=1 if PlanPctStocks_4_dkRF_`year'==0

/****************************************************************************
       AGGREGATES
****************************************************************************/
gen TotPrevPenAmt_`year' = PrevPlanAmt_1_`year' + PrevPlanAmt_2_`year' + PrevPlanAmt_3_`year' + PrevPlanAmt_4_`year' 

gen TotcurrPenAmt_`year' = PlanAmt_1_`year' + PlanAmt_2_`year' + PlanAmt_3_`year'+ PlanAmt_4_`year' 

gen TotAllPenAmt_`year'  = TotPrevPenAmt_`year' + TotcurrPenAmt_`year'

gen PlanStockDoll_`year' =     (PlanPctStocks_1_`year'/100)*PlanAmt_1_`year'                                     + ///
							                 (PlanPctStocks_2_`year'/100)*PlanAmt_2_`year'                                     + ///
							                 (PlanPctStocks_3_`year'/100)*PlanAmt_3_`year'                                     + ///
							                 (PlanPctStocks_4_`year'/100)*PlanAmt_4_`year'
							   
gen     PlanStockTotPct_`year'=0
replace PlanStockTotPct_`year'=PlanStockDoll_`year'/TotAllPenAmt_`year' if TotAllPenAmt_`year'>0 

gen     HasDB_`year'=0
replace HasDB_`year'=1 if HasdbPlan_1_`year'==1     | HasdbPlan_2_`year'==1     | HasdbPlan_3_`year'==1     | HasdbPlan_4_`year'==1 | ///
                          PrevEmpdbPlan_1_`year'==1 | PrevEmpdbPlan_2_`year'==1 | PrevEmpdbPlan_3_`year'==1 | PrevEmpdbPlan_4_`year'==1 

gen     HasDC_`year'=0
replace HasDC_`year'=1 if HasdcPlan_1_`year'==1     | HasdcPlan_2_`year'==1     | HasdcPlan_3_`year'==1     | HasdcPlan_4_`year'==1 | ///
                          PrevEmpdcPlan_1_`year'==1 | PrevEmpdcPlan_2_`year'==1 | PrevEmpdcPlan_3_`year'==1 | PrevEmpdcPlan_4_`year'==1 


keep HHID SUBHH PN HasDB_`year' HasDC_`year' TotAllPenAmt_`year' PlanStockDoll_`year' PrevEmpPens_`year'
save "$CleanData/Pension`year'.dta", replace
