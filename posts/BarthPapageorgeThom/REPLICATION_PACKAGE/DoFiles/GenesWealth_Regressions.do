clear all


set matsize 2000, perm

cap log close

log using $OutputDirEnclave\GenesWealth_RegressionsLog.smcl, replace

use "$CleanDataEnclave\GenesWealth_RegSample.dta"

* Create some local variables 
local CS_PCVars     "M_ev* F_ev* M_PC_Miss* F_PC_Miss*"
local CS_Demo       "i.M_Age##i.MOnly i.F_Age##i.FOnly i.M_BIRTHYR##i.MOnly i.F_BIRTHYR##i.FOnly  Male i.FOnly i.MOnly i.YEAR"
local CS_EducFull   "i.M_Educ##i.F_Educ i.M_DEGREE##i.F_DEGREE i.M_Educ##i.MOnly i.F_Educ##i.FOnly i.M_DEGREE##i.MOnly i.F_DEGREE##i.FOnly"
local CS_Basic      " `CS_PCVars' `CS_Demo'  `CS_EducFull' "

******************************************************************
* TABLE 4: Basic Regressions, including different control sets
******************************************************************
* reg logRealFinWealthWinz M_ev* F_ev* M_PC_Miss* F_PC_Miss*  c.M_Age##i.MOnly c.F_Age##i.FOnly  Male i.FOnly i.MOnly i.YEAR i.M_Educ##i.F_Educ i.M_DEGREE##i.F_DEGREE i.M_Educ##i.MOnly i.F_Educ##i.FOnly i.M_DEGREE##i.MOnly i.F_DEGREE##i.FOnly logTotRealTotEarnAdjHH  EA3ScoreAvg  if WealthRegSample==1, cluster(HHID)


* Column 1: Raw Results, Bivariate regression of log Wealth on Score:			
_eststo T4_C1: reg logRealFinWealthWinz                                                            EA3ScoreAvg   if  WealthRegSample==1, cluster(HHID)
	
		quietly sum logRealFinWealthWinz if e(sample), det
		local MedLogTemp=r(p50)
		di exp(`MedLogTemp'+_b[EA3ScoreAvg])-exp(`MedLogTemp')

* Column 2: Controls, Age of Male and Female household members, Sex of FR, Calendar Year			
_eststo T4_C2: reg logRealFinWealthWinz `CS_Demo'                                                   EA3ScoreAvg  if WealthRegSample==1, cluster(HHID)
		
* Column 3: Everything in 2, but add Principal Components 			
_eststo T4_C3: reg logRealFinWealthWinz `CS_PCVars' `CS_Demo'                                       EA3ScoreAvg  if WealthRegSample==1, cluster(HHID)

* Column 4: Everything in 3, but add Education - years of schooling measures for M and F household members:			
_eststo T4_C4: reg logRealFinWealthWinz `CS_PCVars' `CS_Demo'                        M_Educ  F_Educ EA3ScoreAvg  if WealthRegSample==1, cluster(HHID)

* Column 5: Everything in 3, but add Educ dummies for ever val. of Educ and Degree for male and female household, and interactions:
_eststo T4_C5: reg logRealFinWealthWinz `CS_PCVars' `CS_Demo' `CS_EducFull'                         EA3ScoreAvg  if WealthRegSample==1, cluster(HHID)

* Columns 6: Everything in 3, but now only add income: 	
_eststo T4_C6: reg logRealFinWealthWinz `CS_PCVars' `CS_Demo'               logTotRealTotEarnAdjHH  EA3ScoreAvg  if WealthRegSample==1, cluster(HHID)

* Columns 7: Everything in 3, but now add both Income and Education Controls:
_eststo T4_C7: reg logRealFinWealthWinz `CS_PCVars' `CS_Demo' `CS_EducFull' logTotRealTotEarnAdjHH  EA3ScoreAvg  if WealthRegSample==1, cluster(HHID)
	
		quietly sum logRealFinWealthWinz if e(sample), det
		local MedLogTemp=r(p50)
		di exp(`MedLogTemp'+_b[EA3ScoreAvg])-exp(`MedLogTemp')

				
estout T4_C1 T4_C2 T4_C3 T4_C4 T4_C5 T4_C6 T4_C7 using "$OutputDirEnclave\GENX_T4_BasicRegs.tex",  ///
replace ///
cells(b(fmt(%9.3fc) star) se(par fmt(%9.3fc)))   ///
keep  (EA3ScoreAvg M_Educ F_Educ logTotRealTotEarnAdjHH )	  ///	
order (EA3ScoreAvg M_Educ F_Educ logTotRealTotEarnAdjHH )	  ///				
eqlabels(none)  ///
style(tex) starlevels(* 0.1 ** 0.05 *** 0.01) stats(N r2, fmt(%9.0f %9.3f) label(Obs. "\$R^{2}$"))			
			
			
	
_eststo RawLevels1: reg RealFinWealthWinz  EA3ScoreAvg     if  WealthRegSample==1, cluster(HHID)
_eststo RawLevels2: reg RealFinWealthWinz  EA3ScoreAvg     if  WealthRegSample==1 & RealFinWealthWinz>0 , cluster(HHID)			
	
estout RawLevels1 RawLevels2 using "$OutputDirEnclave\GENX_T4_BasicRegs.tex",  ///
append  ///
cells(b(fmt(%9.3fc) star) se(par fmt(%9.3fc)))   ///
keep  (EA3ScoreAvg )	  ///	
order (EA3ScoreAvg )	  ///				
eqlabels(none)  ///
style(tex) starlevels(* 0.1 ** 0.05 *** 0.01) stats(N r2, fmt(%9.0f %9.3f) label(Obs. "\$R^{2}$"))	
			
			
mat MaleFemaleEA3Corr=J(1,1,9999)
corr M_EA3Score F_EA3Score if InFirstRetWealthYear==1
mat MaleFemaleEA3Corr[1,1]=r(rho)

estout matrix(MaleFemaleEA3Corr) using "$OutputDirEnclave\GENX_T4_BasicRegs.tex", append	style(tex)		
			
			
			
***********************************************************************************************************
* TABLE 5: Robustness.  Three different specifications with two 
*          different control sets.  
*          Spec 1:  Include EA3 Score of Financial Respondent and Non-Financial Respondent separately
*          Spec 2:  Include non-retired sample with average EA score
*          Spec 3:  Basic specification, but include both log of SSA income and log of HRS income
***********************************************************************************************************			

	**********************************************************************************************
	* First, create scores separately for the financial respondent and non-financial respondent
	**********************************************************************************************
	gen FR_EA3Score=EA3Score if FinRespondent==1
	gen NR_EA3Score=.
		replace NR_EA3Score=F_EA3Score if FinRespondent==1 & Male==1
		replace NR_EA3Score=M_EA3Score if FinRespondent==1 & Male==0

	gen FR_Educ=Educ if FinRespondent==1
	gen NR_Educ=.
		replace NR_Educ=F_Educ if FinRespondent==1 & Male==1
		replace NR_Educ=M_Educ if FinRespondent==1 & Male==0	

_eststo T5_C1: reg logRealFinWealthWinz `CS_PCVars' `CS_Demo' `CS_EducFull'                           FR_EA3Score NR_EA3Score  if WealthRegSample==1,      cluster(HHID)	
_eststo T5_C2: reg logRealFinWealthWinz `CS_PCVars' `CS_Demo' `CS_EducFull' logTotRealTotEarnAdjHH    FR_EA3Score NR_EA3Score  if WealthRegSample==1,      cluster(HHID)		
_eststo T5_C3: reg logRealFinWealthWinz `CS_PCVars' `CS_Demo' `CS_EducFull'                                       EA3ScoreAvg  if WealthRegSampleNoRet==1, cluster(HHID)			
_eststo T5_C4: reg logRealFinWealthWinz `CS_PCVars' `CS_Demo' `CS_EducFull' logTotRealTotEarnAdjHH                EA3ScoreAvg  if WealthRegSampleNoRet==1, cluster(HHID)		
_eststo T5_C5: reg logRealFinWealthWinz `CS_PCVars' `CS_Demo' `CS_EducFull'                                       EA3ScoreAvg  if WealthRegSample==1 & logAvgEmpInc~=., cluster(HHID)
_eststo T5_C6: reg logRealFinWealthWinz `CS_PCVars' `CS_Demo' `CS_EducFull' logTotRealTotEarnAdjHH logAvgEmpInc EA3ScoreAvg  if WealthRegSample==1 & logAvgEmpInc~=., cluster(HHID)	

gen Temp=.
replace Temp=YEAR if e(sample)
bys HHID SUBHH: egen FirstIncCompYear=min(Temp)
drop Temp


mat HRSIncStats=J(1,2,9999)
mat colnames HRSIncStats = MeanHRSInc CorrWithSSAInc

gen AvgIncSUBHH=exp(logAvgEmpInc)
sum AvgIncSUBHH if YEAR==FirstIncCompYear & FinRespondent==1
	mat HRSIncStats[1,1]=r(mean)
corr logTotRealTotEarnAdjHH logAvgEmpInc if YEAR==FirstIncCompYear & FinRespondent==1
	mat HRSIncStats[1,2]=r(rho)



estout T5_C1 T5_C2 T5_C3 T5_C4 T5_C5 T5_C6 using "$OutputDirEnclave\GENX_T5_Robustness.tex",  ///
replace ///
cells(b(fmt(%9.3fc) star) se(par fmt(%9.3fc)))   ///
keep  (FR_EA3Score NR_EA3Score EA3ScoreAvg  logTotRealTotEarnAdjHH logAvgEmpInc )	  ///	
order (FR_EA3Score NR_EA3Score EA3ScoreAvg  logTotRealTotEarnAdjHH logAvgEmpInc )	  ///				
eqlabels(none)  ///
style(tex) starlevels(* 0.1 ** 0.05 *** 0.01) stats(N r2, fmt(%9.0f %9.3f) label(Obs. "\$R^{2}$"))


estout matrix(HRSIncStats) using "$OutputDirEnclave\GENX_T5_Robustness.tex", append	style(tex)


****************************************************************************************************
* TABLE 6: EA Score and Wealth, with Parental Background Variables as Controls
****************************************************************************************************

gen InParentalBackgroundSample=(AnyInherSUBHH~=. & logTotalRealInher_SUBHH~=.) 


_eststo T6_C1: reg logRealFinWealthWinz `CS_Basic'                                       EA3ScoreAvg if WealthRegSample==1 & InParentalBackgroundSample==1,      cluster(HHID)
_eststo T6_C2: reg logRealFinWealthWinz `CS_Basic' AnyInherSUBHH logTotalRealInher_SUBHH EA3ScoreAvg if WealthRegSample==1 & InParentalBackgroundSample==1,      cluster(HHID)
_eststo T6_C3: reg logRealFinWealthWinz `CS_Basic'  EA3ScoreAvg ///
               M_FatherEducWithM M_FEMiss M_MotherEducWithM M_MEMiss F_FatherEducWithM F_FEMiss F_MotherEducWithM F_MEMiss if WealthRegSample==1 & InParentalBackgroundSample==1,      cluster(HHID)
_eststo T6_C4: reg logRealFinWealthWinz `CS_Basic' AnyInherSUBHH logTotalRealInher_SUBHH EA3ScoreAvg ///
               M_FatherEducWithM M_FEMiss M_MotherEducWithM M_MEMiss F_FatherEducWithM F_FEMiss F_MotherEducWithM F_MEMiss if WealthRegSample==1 & InParentalBackgroundSample==1,      cluster(HHID)


estout T6_C1 T6_C2 T6_C3 T6_C4  using "$OutputDirEnclave\GENX_T6_ParentBackground.tex",  ///
replace ///
cells(b(fmt(%9.3fc) star) se(par fmt(%9.3fc)))   ///
keep  (EA3ScoreAvg AnyInherSUBHH logTotalRealInher_SUBHH M_FatherEducWithM F_FatherEducWithM  M_MotherEducWithM F_MotherEducWithM)	  ///	
order (EA3ScoreAvg AnyInherSUBHH logTotalRealInher_SUBHH M_FatherEducWithM F_FatherEducWithM  M_MotherEducWithM F_MotherEducWithM)	  ///				
eqlabels(none)  ///
style(tex) starlevels(* 0.1 ** 0.05 *** 0.01) stats(N r2, fmt(%9.0f %9.3f) label(Obs. "\$R^{2}$"))


****************************************
* Table 8: Risk Aversion 
****************************************	
	
local CS_PCVars     "M_ev* F_ev* M_PC_Miss* F_PC_Miss*"
local CS_Demo       "i.M_Age##i.MOnly i.F_Age##i.FOnly i.M_BIRTHYR##i.MOnly i.F_BIRTHYR##i.FOnly  Male i.FOnly i.MOnly i.YEAR"
local CS_EducFull   "i.M_Educ##i.F_Educ i.M_DEGREE##i.F_DEGREE i.M_Educ##i.MOnly i.F_Educ##i.FOnly i.M_DEGREE##i.MOnly i.F_DEGREE##i.FOnly"
local CS_Basic      " `CS_PCVars' `CS_Demo'  `CS_EducFull' "	
	
	
_eststo T8_C1: reg HighIncRA         `CS_Basic' EA3ScoreAvg if HHSample==1, cluster(HHID)
	gen IncRASample=e(sample)
_eststo T8_C2: reg HighInherRA       `CS_Basic' EA3ScoreAvg if HHSample==1, cluster(HHID)
	gen InherRASample=e(sample)
_eststo T8_C3: reg HighBusRA         `CS_Basic' EA3ScoreAvg if HHSample==1, cluster(HHID)
	gen BusRASample=e(sample)
_eststo T8_C4: oprobit IncRAbinVar   `CS_Basic' EA3ScoreAvg if HHSample==1, cluster(HHID) 	
_eststo T8_C5: oprobit InherRAbinVar `CS_Basic' EA3ScoreAvg if HHSample==1, cluster(HHID) 	
_eststo T8_C6: oprobit BusRAbinVar   `CS_Basic' EA3ScoreAvg if HHSample==1, cluster(HHID) 	
	
set matsize 10000	
	
estout T8_C1 T8_C2 T8_C3 T8_C4 T8_C5 T8_C6   using "$OutputDirEnclave\GENX_T8_RiskAversion.tex",  ///
replace ///
cells(b(fmt(%9.3fc) star) se(par fmt(%9.3fc)))   ///
keep (EA3ScoreAvg )	  ///	
order (EA3ScoreAvg )	  ///				
eqlabels(none)  ///
style(tex) starlevels(* 0.1 ** 0.05 *** 0.01) stats(N r2, fmt(%9.0f %9.3f) label(Obs. "\$R^{2}$"))	


******************************************************************************
* Table 9: EA Score and Portfolio Decisions
******************************************************************************


forvalues YR=1992(2)2014{

	gen Temp=.
	replace Temp=logRealFinWealthWinz if YEAR==`YR' & FinRespondent==1 
	bys HHID SUBHH: egen logRealFinWealthWinz_`YR'=max(Temp)
	drop Temp

}

gen logRealFinWealthWinzLag=.

forvalues YR=1994(2)2014{
	local LagYR=`YR'-2
	replace logRealFinWealthWinzLag=logRealFinWealthWinz_`LagYR' if YEAR==`YR'
}

_eststo T9a_C1: reg HasHouse    `CS_Basic' logTotRealTotEarnAdjHH EA3ScoreAvg if WealthRegSample==1, cluster(HHID)	
	gen HouseSample=e(sample)
_eststo T9a_C2: reg HasBusVal   `CS_Basic' logTotRealTotEarnAdjHH EA3ScoreAvg if WealthRegSample==1, cluster(HHID)	
	gen BusinessSample=e(sample)
_eststo T9a_C3: reg AnyStocks   `CS_Basic' logTotRealTotEarnAdjHH EA3ScoreAvg if WealthRegSample==1, cluster(HHID)	
	gen StocksSample=e(sample)
		
_eststo T9a_C4: reg HasHouse    `CS_Basic' logTotRealTotEarnAdjHH logRealFinWealthWinzLag  EA3ScoreAvg if WealthRegSample==1, cluster(HHID)	
_eststo T9a_C5: reg HasBusVal   `CS_Basic' logTotRealTotEarnAdjHH logRealFinWealthWinzLag  EA3ScoreAvg if WealthRegSample==1, cluster(HHID)
_eststo T9a_C6: reg AnyStocks   `CS_Basic' logTotRealTotEarnAdjHH logRealFinWealthWinzLag  EA3ScoreAvg if WealthRegSample==1, cluster(HHID)
	
estout T9a_C1 T9a_C2 T9a_C3 T9a_C4 T9a_C5 T9a_C6 using "$OutputDirEnclave\GENX_T9_PortfolioChoice.tex",  ///
replace ///
cells(b(fmt(%9.3fc) star) se(par fmt(%9.3fc)))   ///
keep (EA3ScoreAvg logTotRealTotEarnAdjHH    logRealFinWealthWinzLag )	  ///	
order (EA3ScoreAvg logTotRealTotEarnAdjHH    logRealFinWealthWinzLag )	  ///				
eqlabels(none)  ///
style(tex) starlevels(* 0.1 ** 0.05 *** 0.01) stats(N r2, fmt(%9.0f %9.3f) label(Obs. "\$R^{2}$"))


gen PortfolioChoiceSample=(AnyStocks~=. & HasHouse~=. & HasBusVal~=. & WealthRegSample==1)


_eststo T9b_C1: reg logRealFinWealthWinz `CS_Basic' logTotRealTotEarnAdjHH EA3ScoreAvg if PortfolioChoiceSample==1, cluster(HHID)

_eststo T9b_C2: reg logRealFinWealthWinz `CS_Basic' logTotRealTotEarnAdjHH EA3ScoreAvg HasHouse   if PortfolioChoiceSample==1, cluster(HHID)
					 
_eststo T9b_C3: reg logRealFinWealthWinz `CS_Basic' logTotRealTotEarnAdjHH EA3ScoreAvg HasBusVal  if PortfolioChoiceSample==1, cluster(HHID)

_eststo T9b_C4: reg logRealFinWealthWinz `CS_Basic' logTotRealTotEarnAdjHH EA3ScoreAvg AnyStocks  if PortfolioChoiceSample==1, cluster(HHID)

_eststo T9b_C5: reg logRealFinWealthWinz `CS_Basic' logTotRealTotEarnAdjHH EA3ScoreAvg ///
					 AnyStocks HasBusVal HasHouse if PortfolioChoiceSample==1, cluster(HHID)
	
estout T9b_C1 T9b_C2 T9b_C3 T9b_C4 T9b_C5  using "$OutputDirEnclave\GENX_T9_PortfolioChoice.tex",  ///
append ///
cells(b(fmt(%9.3fc) star) se(par fmt(%9.3fc)))   ///
keep (EA3ScoreAvg AnyStocks HasBusVal  HasHouse)	  ///	
order (EA3ScoreAvg AnyStocks HasBusVal HasHouse)	  ///				
eqlabels(none)  ///
style(tex) starlevels(* 0.1 ** 0.05 *** 0.01) stats(N r2, fmt(%9.0f %9.3f) label(Obs. "\$R^{2}$"))


*******************************************************************
* TABLE 10:  Beliefs / Expectations and Finacial Planning Horizon
*******************************************************************



foreach EVar in PMUP PRec DDInf {			
			
_eststo Exp_`EVar'1: reg Dev_`EVar'         `CS_Basic' EA3ScoreAvg if HHSample==1, cluster(HHID) 
	    gen ExpSample`EVar'=e(sample)
_eststo Exp_`EVar'2: reg Extreme_`EVar'_0   `CS_Basic' EA3ScoreAvg if HHSample==1, cluster(HHID) 
_eststo Exp_`EVar'3: reg Extreme_`EVar'_50  `CS_Basic' EA3ScoreAvg if HHSample==1, cluster(HHID) 
_eststo Exp_`EVar'4: reg Extreme_`EVar'_100 `CS_Basic' EA3ScoreAvg if HHSample==1, cluster(HHID) 
		
}

estout Exp_PMUP1 Exp_PMUP2 Exp_PMUP3 Exp_PMUP4   using "$OutputDirEnclave\GENX_T10_Beliefs.tex",  ///
replace ///
cells(b(fmt(%9.3fc) star) se(par fmt(%9.3fc)))   ///
keep (EA3ScoreAvg )	  ///	
order (EA3ScoreAvg )	  ///				
eqlabels(none)  ///
style(tex) starlevels(* 0.1 ** 0.05 *** 0.01) stats(N r2, fmt(%9.0f %9.3f) label(Obs. "\$R^{2}$"))

estout Exp_PRec1 Exp_PRec2 Exp_PRec3 Exp_PRec4   using "$OutputDirEnclave\GENX_T10_Beliefs.tex",  ///
append ///
cells(b(fmt(%9.3fc) star) se(par fmt(%9.3fc)))   ///
keep (EA3ScoreAvg )	  ///	
order (EA3ScoreAvg )	  ///				
eqlabels(none)  ///
style(tex) starlevels(* 0.1 ** 0.05 *** 0.01) stats(N r2, fmt(%9.0f %9.3f) label(Obs. "\$R^{2}$"))		
		
estout Exp_DDInf1 Exp_DDInf2 Exp_DDInf3 Exp_DDInf4   using "$OutputDirEnclave\GENX_T10_Beliefs.tex",  ///
append ///
cells(b(fmt(%9.3fc) star) se(par fmt(%9.3fc)))   ///
keep (EA3ScoreAvg )	  ///	
order (EA3ScoreAvg )	  ///				
eqlabels(none)  ///
style(tex) starlevels(* 0.1 ** 0.05 *** 0.01) stats(N r2, fmt(%9.0f %9.3f) label(Obs. "\$R^{2}$"))			

********************************
* Financial Planning Horizon
********************************

replace FinPlanCat=. if FinPlanCat>5
replace FinPlanCat=. if FinPlanCat==0



forvalues thresh=1(1)4{
	gen MinFPC`thresh'=.
	replace MinFPC`thresh'=0 if MinFinPlanCat<=`thresh' & MinFinPlanCat~=.
	replace MinFPC`thresh'=1 if MinFinPlanCat>`thresh' & MinFinPlanCat~=.
	
	gen FPC_MoreThan`thresh'=.
	replace FPC_MoreThan`thresh'=0 if FinPlanCat<=`thresh' & FinPlanCat~=.
	replace FPC_MoreThan`thresh'=1 if FinPlanCat>`thresh'  & FinPlanCat~=.
	
	gen FPC`thresh'=.
	replace FPC`thresh'=0  if FinPlanCat~=.
	replace FPC`thresh'=1 if FinPlanCat==`thresh'
	
}

gen FPC5=.
replace FPC5=0 if FinPlanCat~=.
replace FPC5=1 if FinPlanCat==5


forvalues TH=1(1)4{
	_eststo Horizon_MoreThan`TH': reg FPC_MoreThan`TH' `CS_Basic' EA3ScoreAvg if HHSample==1, cluster(HHID)
	
	if (`TH'==1){
		gen FinPlanSample=e(sample)
	}
	
}

estout Horizon_MoreThan1 Horizon_MoreThan2 Horizon_MoreThan3 Horizon_MoreThan4   using "$OutputDirEnclave\GENX_T10_Beliefs_Horizon.tex",  ///
append ///
cells(b(fmt(%9.3fc) star) se(par fmt(%9.3fc)))   ///
keep (EA3ScoreAvg )	  ///	
order (EA3ScoreAvg )	  ///				
eqlabels(none)  ///
style(tex) starlevels(* 0.1 ** 0.05 *** 0.01) stats(N r2, fmt(%9.0f %9.3f) label(Obs. "\$R^{2}$"))


********************************************
* Table 11: Defined Benefit Pensions 
********************************************


	gen RealPenMarketValWinz=RealPenMarketVal
	sum RealPenMarketValWinz  if EA3ScoreAvg~=. & WealthRegSample==1 & GetPen==1, det
		gen RPM_1=r(p1)
		gen RPM_99=r(p99)
		replace RealPenMarketValWinz=RPM_1  if RealPenMarketValWinz<RPM_1  & RealPenMarketValWinz~=. & GetPen==1
		replace RealPenMarketValWinz=RPM_99 if RealPenMarketValWinz>RPM_99 & RealPenMarketValWinz~=. & GetPen==1

	gen logRealPenMarketVal=log(RealPenMarketVal)
	gen logRealPenMarketValWinz=log(RealPenMarketValWinz)


	forvalues PCInd=1(1)10{
		gen GetPenxM_ev`PCInd'=GetPen*M_ev`PCInd'
		gen GetPenxM_ev`PCInd'xMOnly=GetPen*M_ev`PCInd'xMOnly
		
		gen GetPenxF_ev`PCInd'=GetPen*F_ev`PCInd'
		gen GetPenxF_ev`PCInd'xFOnly=GetPen*F_ev`PCInd'xFOnly		
	}
	
		gen GetPenxM_PC_Miss=GetPen*M_PC_Miss
		gen GetPenxM_PC_MissxMOnly=GetPen*M_PC_MissxMOnly
		
		gen GetPenxF_PC_Miss=GetPen*F_PC_Miss
		gen GetPenxF_PC_MissxFOnly=GetPen*F_PC_MissxFOnly	
	

	gen EA3ScoreAvgxGetPen=EA3ScoreAvg*GetPen
	
	
_eststo Pension_DV_GetPen:  reg GetPen                  `CS_Basic'           EA3ScoreAvg                            if WealthRegSample==1 & logRealFinWealthWinz~=. , cluster(HHID)
	gen PenSample=e(sample)
_eststo Pension_DV_PenAmt:  reg logRealPenMarketValWinz `CS_Basic'           EA3ScoreAvg                            if WealthRegSample==1 & logRealFinWealthWinz~=. , cluster(HHID)
    gen PenMarketValSample=e(sample)
_eststo Pension_DV_logW:    reg logRealFinWealthWinz    `CS_Basic'           EA3ScoreAvg GetPen                     if WealthRegSample==1 & logRealFinWealthWinz~=. , cluster(HHID)  
_eststo Pension_DV_logWInt: reg logRealFinWealthWinz    `CS_Basic' GetPenx*  EA3ScoreAvg GetPen  EA3ScoreAvgxGetPen if WealthRegSample==1 & logRealFinWealthWinz~=. , cluster(HHID) 
						
estout Pension_DV_GetPen Pension_DV_PenAmt Pension_DV_logW Pension_DV_logWInt  using "$OutputDirEnclave\GENX_T11_Pensions.tex",  ///
replace    /// 
cells(b(fmt(%9.3fc) star) se(par fmt(%9.3fc)))      ///
keep( EA3ScoreAvg  EA3ScoreAvgxGetPen GetPen     )   ///
order( EA3ScoreAvg EA3ScoreAvgxGetPen GetPen     )   ///
eqlabels(none)                         ///
style(tex) starlevels(* .1 ** .05 *** .01) stats( N r2, fmt(%9.0f %9.3f) label(Obs. "\$R^{2}$")) 




save "$CleanDataEnclave\GenesWealth_RegSampleForAppendix.dta", replace



*************************************************************
* Prepare a panel for the Consumption Analysis
* We need to prepare some household-level variables
* to merge in with the consumption / expenditure data
*************************************************************
	
clear all

use "$CleanDataEnclave\GenesWealth_RegSampleForAppendix.dta"

gen HRSYear=YEAR

keep HHID PN SUBHH HRSYear

drop if HRSYear==.

save  "$CleanDataEnclave\GENX_HHIDPNSUBHHPanel.dta", replace  	



clear all

use "$CleanDataEnclave\GenesWealth_RegSampleForAppendix.dta"

bys HHID SUBHH YEAR: gen NumInSUBHH=_N

gen HRSYear=YEAR
keep if HRSYear>=2000 & HRSYear<=2010
keep if FinRespondent==1

bys HHID SUBHH HRSYear: gen TempCounter=_N
drop if TempCounter>1



keep HHID PN SUBHH HRSYear logRealFinWealthWinz logRealFinWealthWinzLag  *FinPlanCat RealInher_SUBHH_YEAR MaxAgeSUBHH NumInSUBHH M_ev* F_ev* M_PC_Miss* F_PC_Miss* ///
                  M_BIRTHYR F_BIRTHYR M_Educ F_Educ M_DEGREE F_DEGREE AllFS MF FOnly MOnly HH_NumWorkNoRet EA3ScoreAvg Male RetRegSample


save  "$CleanDataEnclave\GenesWealth_IncVariables.dta", replace 

clear all

log close




