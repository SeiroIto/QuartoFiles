clear all


set matsize 2000, perm

cap log close

log using $OutputDirEnclave\GenesWealth_AppendixLog.smcl, replace

* Here we just extract the household weights, which we will use for one of the robustness checks:

use "$EnclaveTracker\TRK2016TR_R.dta"

keep HHID PN *WGTHH 

save "$CleanDataEnclave\HHWeights.dta", replace

clear all

use "$CleanDataEnclave\GenesWealth_RegSampleForAppendix.dta"

merge m:1 HHID PN using "$CleanDataEnclave\HHWeights.dta", gen(HHWeightMerge)


	* Construct Household Weights for each year:
	gen HHWeight=.
	replace HHWeight=AWGTHH if YEAR==1992
	replace HHWeight=BWGTHH if YEAR==1993
	replace HHWeight=CWGTHH if YEAR==1994
	replace HHWeight=DWGTHH if YEAR==1995
	replace HHWeight=EWGTHH if YEAR==1996
	replace HHWeight=FWGTHH if YEAR==1998
	replace HHWeight=GWGTHH if YEAR==2000
	replace HHWeight=HWGTHH if YEAR==2002
	replace HHWeight=JWGTHH if YEAR==2004
	replace HHWeight=KWGTHH if YEAR==2006
	replace HHWeight=LWGTHH if YEAR==2008
	replace HHWeight=MWGTHH if YEAR==2010
	replace HHWeight=NWGTHH if YEAR==2012
	replace HHWeight=OWGTHH if YEAR==2014

* Drop those with missing PNNums (added from the above merges but not in our main data set)	
drop if PNNum==.	


* Create some local variables 
local CS_PCVars     "M_ev* F_ev* M_PC_Miss* F_PC_Miss*"
local CS_Demo       "i.M_Age##i.MOnly i.F_Age##i.FOnly i.M_BIRTHYR##i.MOnly i.F_BIRTHYR##i.FOnly  Male i.FOnly i.MOnly i.YEAR"
local CS_EducFull   "i.M_Educ##i.F_Educ i.M_DEGREE##i.F_DEGREE i.M_Educ##i.MOnly i.F_Educ##i.FOnly i.M_DEGREE##i.MOnly i.F_DEGREE##i.FOnly"
local CS_Basic      " `CS_PCVars' `CS_Demo'  `CS_EducFull' "


*******************************************************************************
* FIGURE S1: Plot of Relationship between EA Score Avg and Household Income
*******************************************************************************

twoway lowess logTotRealTotEarnAdjHH EA3ScoreAvg if InFirstRetWealthYear==1  & EA3ScoreAvg>-2.1 & EA3ScoreAvg<2.1, ytitle("log HH Income ") xtitle("EA Score")graphregion(color(white))  
graph export "$OutputDirEnclave/GENX_IncVSEAScore.pdf", replace	



*******************************************************************************
* TABLE S3: Summary Statistics for Income Measures
*******************************************************************************


mat GENX_TS3a_IncSum=J(5,12,9999)
	
	mat rownames GENX_TS3a_IncSum = NonMissTotRealTotEarnAdjHH ZeroTotRealTotEarnAdjHH NumTopCodeHH ZeroTopCodes TotRealTotEarnAdjHH 
	mat colnames GENX_TS3a_IncSum = All_Mean StdDev N  MF_Mean StdDev N  FOnly_Mean StdDev N  MOnly_Mean StdDev N 


local RInd=1

foreach var in NonMissTotRealTotEarnAdjHH ZeroTotRealTotEarnAdjHH NumTopCodeHH ZeroTopCodes TotRealTotEarnAdjHH    ///
 {
		
	local FInd=1	
	foreach FS in AllFS MF FOnly MOnly {
	
		sum `var' if InFirstRetWealthYear==1 & `FS'==1
		
		mat GENX_TS3a_IncSum[`RInd',3*(`FInd'-1)+1]=r(mean)
		mat GENX_TS3a_IncSum[`RInd',3*(`FInd'-1)+2]=r(sd)	
		mat GENX_TS3a_IncSum[`RInd',3*(`FInd'-1)+3]=r(N)	
	
		local FInd=`FInd'+1
	}
	
	local RInd=`RInd'+1
}

estout matrix(GENX_TS3a_IncSum) using "$OutputDirEnclave\GENX_TS3_SumStatsInc.tex", replace style(tex)



mat GENX_TS3b_EarnDist=J(4,10,9999)

	mat rownames GENX_TS3b_EarnDist  = All MF MOnly FOnly 
	mat colnames GENX_TS3b_EarnDist  = p1 p10 p25 p50 p75 p90 p99 Mean StdDev N


local RInd=1
foreach Samp in AllFS MF FOnly MOnly {

	sum TotRealTotEarnAdjHH if InFirstRetWealthYear==1 & `Samp'==1, det
	
	mat GENX_TS3b_EarnDist[`RInd',1]=r(p1)
	mat GENX_TS3b_EarnDist[`RInd',2]=r(p10)
	mat GENX_TS3b_EarnDist[`RInd',3]=r(p25)
	mat GENX_TS3b_EarnDist[`RInd',4]=r(p50)
	mat GENX_TS3b_EarnDist[`RInd',5]=r(p75)
	mat GENX_TS3b_EarnDist[`RInd',6]=r(p90)
	mat GENX_TS3b_EarnDist[`RInd',7]=r(p99)
	mat GENX_TS3b_EarnDist[`RInd',8]=r(mean)
	mat GENX_TS3b_EarnDist[`RInd',9]=r(sd)
	mat GENX_TS3b_EarnDist[`RInd',10]=r(N)
	
	local RInd=`RInd'+1
	
}


estout matrix(GENX_TS3b_EarnDist) using "$OutputDirEnclave\GENX_TS3_SumStatsInc.tex", append



*************************************************************************
* TABLE S4-S5  Detailed Summary Statistics on Components of Wealth
*************************************************************************
	 
		mat WealthSumStats=J(4,8,9999)
		mat rownames WealthSumStats = TotalWealth NoHousing NoRet NoHouseorRet
		mat colnames WealthSumStats = p10 p25 p50 p75 p90 Mean StDev N
	 
		local RInd=1
		foreach var in RealFinWealthWinz RealFinWealthNoH RealFinWealthNoP RealFinWealthNoPH {
		
				sum `var' if RetRegSample==1, det
					mat WealthSumStats[`RInd',1]=r(p10)
					mat WealthSumStats[`RInd',2]=r(p25)
					mat WealthSumStats[`RInd',3]=r(p50)
					mat WealthSumStats[`RInd',4]=r(p75)
					mat WealthSumStats[`RInd',5]=r(p90)
					mat WealthSumStats[`RInd',6]=r(mean)
					mat WealthSumStats[`RInd',7]=r(sd)
					mat WealthSumStats[`RInd',8]=r(N)		
		
			local RInd=`RInd'+1
		}
	    
		esttab mat(WealthSumStats) using "$OutputDirEnclave\GENX_TS4_WealthStats.tex", b(%11.0f) style(tex) replace
	 
	 
		mat WealthComponentStats=J(17,9,9999)
		mat rownames WealthComponentStats = TotAllPenAmt RetIncMarketVal RealEstateVal BusVal IRAVal StockVal ///
										CashVal CDVal BondVal OtherAssetVal OtherDebtVal TrustVal HouseVal ///  
										MortgVal HmLnVal HouseVal2 SecMortgVal   
		mat colnames WealthComponentStats  = p10 p25 p50 p75 p90 Mean N MedianShare MeanShare


		local RInd=1
		
		foreach var in RealTotAllPenAmt RealRetIncMarketVal  RealRealEstateVal RealBusVal RealIRAVal RealStockVal ///
										RealCashVal RealCDVal RealBondVal RealOtherAssetVal RealOtherDebtVal RealTrustVal RealHouseVal ///  
										RealMortgVal RealHmLnVal RealHouseVal2 RealSecMortgVal {
				sum `var' if RetRegSample==1, det
					mat WealthComponentStats[`RInd',1]=r(p10)
					mat WealthComponentStats[`RInd',2]=r(p25)
					mat WealthComponentStats[`RInd',3]=r(p50)
					mat WealthComponentStats[`RInd',4]=r(p75)
					mat WealthComponentStats[`RInd',5]=r(p90)
					mat WealthComponentStats[`RInd',6]=r(mean)
					mat WealthComponentStats[`RInd',7]=r(N)
					
				gen TempShare=`var'/RealFinWealth
				sum TempShare if RetRegSample==1 & RealFinWealth>0 , det
					
					mat WealthComponentStats[`RInd',8]=r(p50)
					mat WealthComponentStats[`RInd',9]=r(mean)
					
				local RInd=`RInd'+1	
				drop TempShare
		}
		
		esttab mat(WealthComponentStats) using "$OutputDirEnclave\GENX_TS5_WealthComponentStats.tex", b(%11.2f) style(tex) replace

**********************************
* TABLE S7: Assortative Mating
**********************************

	* Generate an indicator for every being in an MF household with non-missing scores
	* for both males and females:

	gen Temp=0
	replace Temp=1 if InFirstRetWealthYear==1 & MF==1 & M_EA3Score~=. & F_EA3Score~=.
	bys HHID SUBHH: egen Temp2=max(Temp)
	bys HHID PN: egen InAssortMatSample=max(Temp2)
	drop Temp Temp2

	gen Temp=.
	replace Temp=EA3Score if InAssortMatSample==1 & NewPersCounter==1
	_pctile  Temp, p(25 50 75) 			
	gen EApr25=r(r1)
	gen EApr50=r(r2)
	gen EApr75=r(r3)
	drop Temp

	foreach GND in M F {
		
		gen `GND'_EA_Quart=.
		replace `GND'_EA_Quart=1 if `GND'_EA3Score~=. & `GND'_EA3Score<=EApr25
		replace `GND'_EA_Quart=2 if `GND'_EA3Score~=. & `GND'_EA3Score>EApr25 & `GND'_EA3Score<=EApr50
		replace `GND'_EA_Quart=3 if `GND'_EA3Score~=. & `GND'_EA3Score>EApr50 & `GND'_EA3Score<=EApr75
		replace `GND'_EA_Quart=4 if `GND'_EA3Score~=. & `GND'_EA3Score>EApr75 

	}

	tabout M_EA_Quart F_EA_Quart if InFirstRetWealthYear==1 & MF==1 & M_EA3Score~=. & F_EA3Score~=. using "$OutputDirEnclave\GENX_TS7_AssortMating.tex", cells(col) replace stats(chi2)




	reg EA3Score Educ i.DEGREE if InAssortMatSample==1 & NewPersCounter==1
	gen InAssortRegSamp=e(sample)		
	predict  EA3EducResid if InAssortRegSamp==1, resid
	_pctile  EA3EducResid, p(25 50 75)
	gen EAResidpr25=r(r1)
	gen EAResidpr50=r(r2)
	gen EAResidpr75=r(r3)


	gen Temp=.
	replace Temp=EA3EducResid if InAssortRegSamp==1 & Male==1
	bys HHID PN:    egen Temp2=max(Temp)
	bys HHID SUBHH: egen M_EA3EducResid=max(Temp2)
	drop Temp Temp2


	gen Temp=.
	replace Temp=EA3EducResid if InAssortRegSamp==1 & Male==0
	bys HHID PN:    egen Temp2=max(Temp)
	bys HHID SUBHH: egen F_EA3EducResid=max(Temp2)
	drop Temp Temp2

			
			
	foreach GND in M F {
		
		gen `GND'_EAResid_Quart=.
		replace `GND'_EAResid_Quart=1 if `GND'_EA3EducResid~=. & `GND'_EA3EducResid<=EAResidpr25
		replace `GND'_EAResid_Quart=2 if `GND'_EA3EducResid~=. & `GND'_EA3EducResid>EAResidpr25 & `GND'_EA3EducResid<=EAResidpr50
		replace `GND'_EAResid_Quart=3 if `GND'_EA3EducResid~=. & `GND'_EA3EducResid>EAResidpr50 & `GND'_EA3EducResid<=EAResidpr75
		replace `GND'_EAResid_Quart=4 if `GND'_EA3EducResid~=. & `GND'_EA3EducResid>EAResidpr75 

	}

		
	tabout M_EAResid_Quart F_EAResid_Quart if InFirstRetWealthYear==1 & MF==1 & M_EA3Score~=. & F_EA3Score~=. using "$OutputDirEnclave\GENX_TS7_AssortMating.tex", cells(col) append stats(chi2)		
		
	mat HHCorrMat=J(1,2,9999)
	mat colnames HHCorrMat = RhoEduc RhoEA3Score
		
	corr M_Educ     F_Educ     if InFirstRetWealthYear==1 & MF==1 & M_EA3Score~=. & F_EA3Score~=.
		mat HHCorrMat[1,1]=r(rho)
	corr M_EA3Score F_EA3Score if InFirstRetWealthYear==1 & MF==1 & M_EA3Score~=. & F_EA3Score~=.
		mat HHCorrMat[1,2]=r(rho)
				
		
******************************************************************************
* Table S8: Parental Resources and Transfers
******************************************************************************

	

	* First, we have to generate an average value of Father's and Mother's
	* Education (averaging across individuals in the household)
		
	egen FatherEducAvg=rowmean(M_FatherEduc F_FatherEduc)
	egen MotherEducAvg=rowmean(M_MotherEduc F_MotherEduc)


_eststo TS8_C1: reg AnyInherSUBHH           `CS_Basic'            EA3ScoreAvg if InFirstRetWealthYear==1, cluster(HHID)
_eststo TS8_C2: reg logTotalRealInher_SUBHH `CS_Basic'            EA3ScoreAvg if InFirstRetWealthYear==1 & logTotalRealInher_SUBHH>0, cluster(HHID)	
_eststo TS8_C3: reg FatherEducAvg           `CS_PCVars' `CS_Demo' EA3ScoreAvg if InFirstRetWealthYear==1, cluster(HHID)
_eststo TS8_C4: reg MotherEducAvg           `CS_PCVars' `CS_Demo' EA3ScoreAvg if InFirstRetWealthYear==1, cluster(HHID)
_eststo TS8_C5: reg FatherEducAvg           `CS_Basic'            EA3ScoreAvg if InFirstRetWealthYear==1, cluster(HHID)
_eststo TS8_C6: reg MotherEducAvg           `CS_Basic'            EA3ScoreAvg if InFirstRetWealthYear==1, cluster(HHID)


estout TS8_C1 TS8_C2 TS8_C3 TS8_C4 TS8_C5 TS8_C6  using "$OutputDirEnclave\GENX_TS8_ParentsTransfers.tex",  ///
replace ///
cells(b(fmt(%9.3fc) star) se(par fmt(%9.3fc)))   ///
keep (EA3ScoreAvg )	  ///	
order (EA3ScoreAvg )	  ///				
eqlabels(none)  ///
style(tex) starlevels(* 0.1 ** 0.05 *** 0.01) stats(N r2, fmt(%9.0f %9.3f) label(Obs. "\$R^{2}$"))			
		
		
		
********************************************************************************
* Table 16: Beliefs / Planning Horizon Matter
********************************************************************************

local CS_PCVars     "M_ev* F_ev* M_PC_Miss* F_PC_Miss*"
local CS_Demo       "i.M_Age##i.MOnly i.F_Age##i.FOnly i.M_BIRTHYR##i.MOnly i.F_BIRTHYR##i.FOnly  Male i.FOnly i.MOnly i.YEAR"
local CS_EducFull   "i.M_Educ##i.F_Educ i.M_DEGREE##i.F_DEGREE i.M_Educ##i.MOnly i.F_Educ##i.FOnly i.M_DEGREE##i.MOnly i.F_DEGREE##i.FOnly"
local CS_Basic      " `CS_PCVars' `CS_Demo'  `CS_EducFull' "


* Show that Beliefs / Planning Horizon Matter for Wealth 

foreach num in 0 100 {
	foreach BVar in PMUP PRec DDInf {
		egen EE_`BVar'_`num'=rowmax(M_Ever_Extreme_`BVar'_`num' F_Ever_Extreme_`BVar'_`num')
		  
	}
}

egen HH_MinFinPlanCat=rowmin(M_MinFinPlanCat F_MinFinPlanCat)
egen HH_MaxDev_PUMP=rowmax(M_MaxDev_PMUP F_MaxDev_PMUP)
egen HH_MaxDev_PRec=rowmax(M_MaxDev_Prec F_MaxDev_Prec)
egen HH_MaxDev_DDInf=rowmax(M_MaxDev_DDInf F_MaxDev_DDInf)



_eststo TS9_BMatter_1: reg logRealFinWealthWinz `CS_Basic' logTotRealTotEarnAdjHH EE_PMUP_0 EE_PMUP_100 EE_PRec_0 EE_PRec_100 EE_DDInf_0 EE_DDInf_100 HH_MaxDev* i.HH_MinFinPlanCat              if WealthRegSample==1, cluster(HHID)
_eststo TS9_BMatter_2: reg logRealFinWealthWinz `CS_Basic' logTotRealTotEarnAdjHH EE_PMUP_0 EE_PMUP_100 EE_PRec_0 EE_PRec_100 EE_DDInf_0 EE_DDInf_100 HH_MaxDev* i.HH_MinFinPlanCat EA3ScoreAvg  if WealthRegSample==1, cluster(HHID)
_eststo TS9_BMatter_3: reg AnyStocks `CS_Basic' logTotRealTotEarnAdjHH EE_PMUP_0 EE_PMUP_100 EE_PRec_0 EE_PRec_100 EE_DDInf_0 EE_DDInf_100 HH_MaxDev* i.HH_MinFinPlanCat              if WealthRegSample==1, cluster(HHID)
_eststo TS9_BMatter_4: reg AnyStocks `CS_Basic' logTotRealTotEarnAdjHH EE_PMUP_0 EE_PMUP_100 EE_PRec_0 EE_PRec_100 EE_DDInf_0 EE_DDInf_100 HH_MaxDev* i.HH_MinFinPlanCat EA3ScoreAvg  if WealthRegSample==1, cluster(HHID)



estout TS9_BMatter_1 TS9_BMatter_2 TS9_BMatter_3 TS9_BMatter_4  using "$OutputDirEnclave\GENX_TS9_BeliefsMatter.tex",  ///
replace ///
cells(b(fmt(%9.3fc) star) se(par fmt(%9.3fc)))   ///
keep (EA3ScoreAvg EE_PMUP_0 EE_PMUP_100 EE_PRec_0 EE_PRec_100 EE_DDInf_0 EE_DDInf_100 2.HH_MinFinPlanCat 3.HH_MinFinPlanCat 4.HH_MinFinPlanCat 5.HH_MinFinPlanCat )	  ///	
order (EA3ScoreAvg EE_PMUP_0 EE_PMUP_100 EE_PRec_0 EE_PRec_100 EE_DDInf_0 EE_DDInf_100 2.HH_MinFinPlanCat 3.HH_MinFinPlanCat 4.HH_MinFinPlanCat 5.HH_MinFinPlanCat  )	  ///				
eqlabels(none)  ///
style(tex) starlevels(* 0.1 ** 0.05 *** 0.01) stats(N r2, fmt(%9.0f %9.3f) label(Obs. "\$R^{2}$"))					
		
		
***********************************************************************************************************************************
* TABLE S10: Robustness Exercises - alternate household samples, and alternate ways of combining EA scores across household members  
***********************************************************************************************************************************	
	
	* Construct Standardized Household Weights for each year:

	gen Temp=0
	replace Temp=HHWeight if RetRegSample==1
	egen SumHHWeight=total(Temp)
	drop Temp

	gen StdHHWeight=(HHWeight/SumHHWeight)*100	
	
	* Construct Max and Min EA3 Scores:
	egen MaxEA3Score=rowmax(M_EA3Score F_EA3Score)
	egen MinEA3Score=rowmin(M_EA3Score F_EA3Score)
	gen TwoScores=(M_EA3Score~=. & F_EA3Score~=.)	
	
	
	local CS_PCVars     "M_ev* F_ev* M_PC_Miss* F_PC_Miss*"
	local CS_Demo       "i.M_Age##i.MOnly i.F_Age##i.FOnly i.M_BIRTHYR##i.MOnly i.F_BIRTHYR##i.FOnly  Male i.FOnly i.MOnly i.YEAR"
	local CS_EducFull   "i.M_Educ##i.F_Educ i.M_DEGREE##i.F_DEGREE i.M_Educ##i.MOnly i.F_Educ##i.FOnly i.M_DEGREE##i.MOnly i.F_DEGREE##i.FOnly"
	local CS_Basic      " `CS_PCVars' `CS_Demo'  `CS_EducFull' "
	

	

_eststo TS10a_C1: reg logRealFinWealthWinz `CS_PCVars' `CS_Demo' `CS_EducFull'                         EA3ScoreAvg  [pw=StdHHWeight] if WealthRegSample==1, cluster(HHID)
_eststo TS10a_C2: reg logRealFinWealthWinz `CS_PCVars' `CS_Demo' `CS_EducFull' logTotRealTotEarnAdjHH  EA3ScoreAvg  [pw=StdHHWeight] if WealthRegSample==1, cluster(HHID)
_eststo TS10a_C3: reg logRealFinWealthWinz `CS_PCVars' `CS_Demo' `CS_EducFull'                         EA3ScoreAvg                   if WealthRegSample==1 & InFirstRetWealthYear==1, cluster(HHID)
_eststo TS10a_C4: reg logRealFinWealthWinz `CS_PCVars' `CS_Demo' `CS_EducFull' logTotRealTotEarnAdjHH  EA3ScoreAvg                   if WealthRegSample==1 & InFirstRetWealthYear==1, cluster(HHID)
_eststo TS10a_C5: reg logRealFinWealthWinz `CS_PCVars' `CS_Demo' `CS_EducFull'                         EA3ScoreAvg                   if WealthRegSample==1 & MF==1, cluster(HHID)
_eststo TS10a_C6: reg logRealFinWealthWinz `CS_PCVars' `CS_Demo' `CS_EducFull' logTotRealTotEarnAdjHH  EA3ScoreAvg                   if WealthRegSample==1 & MF==1, cluster(HHID)		
_eststo TS10a_C7: reg logRealFinWealthWinz `CS_PCVars' `CS_Demo' `CS_EducFull'                         MaxEA3Score MinEA3Score  if WealthRegSample==1 & MF==1 & TwoScores==1, cluster(HHID)
_eststo TS10a_C8: reg logRealFinWealthWinz `CS_PCVars' `CS_Demo' `CS_EducFull' logTotRealTotEarnAdjHH  MaxEA3Score MinEA3Score  if WealthRegSample==1 & MF==1 & TwoScores==1, cluster(HHID)

estout TS10a_C1 TS10a_C2 TS10a_C3 TS10a_C4 TS10a_C5 TS10a_C6 TS10a_C7 TS10a_C8  using "$OutputDirEnclave\GENX_TS10_RobustnessHHStruct.tex",  ///
replace ///
cells(b(fmt(%9.3fc) star) se(par fmt(%9.3fc)))   ///
keep  (EA3ScoreAvg MaxEA3Score MinEA3Score  logTotRealTotEarnAdjHH )	  ///	
order (EA3ScoreAvg MaxEA3Score MinEA3Score  logTotRealTotEarnAdjHH )	  ///				
eqlabels(none)  ///
style(tex) starlevels(* 0.1 ** 0.05 *** 0.01) stats(N r2, fmt(%9.0f %9.3f) label(Obs. "\$R^{2}$"))



		
		
********************************************************************************
* TABLE S11:Robustness Exercises - Alternate Income Controls
********************************************************************************


		* Get Quintiles and Deciles of Wealth Distribution 

		gen TempEarn=.
		replace TempEarn=logTotRealTotEarnAdjHH if InFirstRetWealthYear==1

		xtile tmpHHEarnQuint=TempEarn, nq(5)
		xtile tmpHHEarnDecile=TempEarn, nq(10)	

		bys HHID SUBHH: egen HHEarnQuint=max(tmpHHEarnQuint)
		bys HHID SUBHH: egen HHEarnDecile=max(tmpHHEarnDecile)

		gen SSA=logTotRealTotEarnAdjHH
		gen SSA_2=SSA*SSA
		gen SSA_3=SSA*SSA*SSA
		gen SSA_4=SSA*SSA*SSA*SSA
		gen SSA_5=SSA*SSA*SSA*SSA*SSA
		
			foreach var in AvgEarnTop35 {
			
				* Calculate for Men:
				gen Temp=.
				replace Temp=`var' if Male==1
				bys HHID SUBHH: egen M_`var'=max(Temp)
				drop Temp
				
				* Calculate for Women:
				gen Temp=.
				replace Temp=`var' if Male==0
				bys HHID SUBHH: egen F_`var'=max(Temp)
				drop Temp
				
			}

		gen     logAvgEarnTop35=log(AvgEarnTop35)
		replace logAvgEarnTop35=log(M_AvgEarnTop35) if logAvgEarnTop35==. & (M_AvgEarnTop35>0 & M_AvgEarnTop35~=.)
		replace logAvgEarnTop35=log(F_AvgEarnTop35) if logAvgEarnTop35==. & (F_AvgEarnTop35>0 & F_AvgEarnTop35~=.)		
		
			

_eststo TS11_C1: reg logRealFinWealthWinz `CS_Basic'    logAvgEmpInc                                        EA3ScoreAvg  if WealthRegSample==1, cluster(HHID)
_eststo TS11_C2: reg logRealFinWealthWinz `CS_Basic'    i.NumTopCodeHH logTotRealTotEarnAdjHH                 EA3ScoreAvg  if WealthRegSample==1, cluster(HHID)
_eststo TS11_C3: reg logRealFinWealthWinz `CS_Basic'    i.NumTopCodeHH i.HHEarnQuint logTotRealTotEarnAdjHH   EA3ScoreAvg  if WealthRegSample==1, cluster(HHID)
_eststo TS11_C4: reg logRealFinWealthWinz `CS_Basic'    i.NumTopCodeHH SSA SSA_2 SSA_3 SSA_4 SSA_5            EA3ScoreAvg  if WealthRegSample==1, cluster(HHID)
_eststo TS11_C5: reg logRealFinWealthWinz `CS_Basic'    logTotRealTotEarnAdjHH                                EA3ScoreAvg  if WealthRegSample==1  & HHIDSUBHH_MaxNumHHIDSUBHH==1, cluster(HHID)
_eststo TS11_C6: reg logRealFinWealthWinz `CS_Basic'    logAvgEarnTop35                                       EA3ScoreAvg  if WealthRegSample==1, cluster(HHID)



estout TS11_C1 TS11_C2 TS11_C3 TS11_C4 TS11_C5 TS11_C6 using "$OutputDirEnclave\GENX_TS11_AltIncome.tex",  ///
append ///
cells(b(fmt(%9.3fc) star) se(par fmt(%9.3fc)))   ///
keep  (EA3ScoreAvg logAvgEmpInc logTotRealTotEarnAdjHH SSA SSA_2 SSA_3 SSA_4 SSA_5 logAvgEarnTop35  )	  ///	
order (EA3ScoreAvg logAvgEmpInc logTotRealTotEarnAdjHH SSA SSA_2 SSA_3 SSA_4 SSA_5 logAvgEarnTop35  )	  ///				
eqlabels(none)  ///
style(tex) starlevels(* 0.1 ** 0.05 *** 0.01) stats(N r2, fmt(%9.0f %9.3f) label(Obs. "\$R^{2}$"))



********************************************************************************
* TABLE S12: Robustness Exercises - Alternate Wealth Measures
********************************************************************************

gen lWNoH    =logRealFinWealthNoHWinz
gen lWNoP    =logRealFinWealthNoPWinz
gen lWNoPH   =logRealFinWealthNoPHWinz
gen lWNoBiz  =logRealFinWealthNoBizWinz

local CS_PCVars     "M_ev* F_ev* M_PC_Miss* F_PC_Miss*"
local CS_Demo       "i.M_Age##i.MOnly i.F_Age##i.FOnly i.M_BIRTHYR##i.MOnly i.F_BIRTHYR##i.FOnly  Male i.FOnly i.MOnly i.YEAR"
local CS_EducFull   "i.M_Educ##i.F_Educ i.M_DEGREE##i.F_DEGREE i.M_Educ##i.MOnly i.F_Educ##i.FOnly i.M_DEGREE##i.MOnly i.F_DEGREE##i.FOnly"
local CS_Basic      " `CS_PCVars' `CS_Demo'  `CS_EducFull' "	

_eststo TS12_C1: reg logRealRANDWealthWinz `CS_PCVars' `CS_Demo' `CS_EducFull' logTotRealTotEarnAdjHH  EA3ScoreAvg  if WealthRegSample==1, cluster(HHID)
_eststo TS12_C2: reg lWNoH                 `CS_PCVars' `CS_Demo' `CS_EducFull' logTotRealTotEarnAdjHH  EA3ScoreAvg  if WealthRegSample==1, cluster(HHID)
_eststo TS12_C3: reg lWNoP                 `CS_PCVars' `CS_Demo' `CS_EducFull' logTotRealTotEarnAdjHH  EA3ScoreAvg  if WealthRegSample==1, cluster(HHID)
_eststo TS12_C4: reg lWNoPH                `CS_PCVars' `CS_Demo' `CS_EducFull' logTotRealTotEarnAdjHH  EA3ScoreAvg  if WealthRegSample==1, cluster(HHID)
_eststo TS12_C5: reg lWNoBiz               `CS_PCVars' `CS_Demo' `CS_EducFull' logTotRealTotEarnAdjHH  EA3ScoreAvg  if WealthRegSample==1, cluster(HHID)


estout TS12_C1 TS12_C2 TS12_C3 TS12_C4 TS12_C5 using "$OutputDirEnclave\GENX_TS12_AltWealth.tex",  ///
append ///
cells(b(fmt(%9.3fc) star) se(par fmt(%9.3fc)))   ///
keep  (EA3ScoreAvg logTotRealTotEarnAdjHH  )	  ///	
order (EA3ScoreAvg logTotRealTotEarnAdjHH )	  ///				
eqlabels(none)  ///
style(tex) starlevels(* 0.1 ** 0.05 *** 0.01) stats(N r2, fmt(%9.0f %9.3f) label(Obs. "\$R^{2}$"))

********************************************************************************
* TABLE S13: Robustness Exercises - Alternate Wealth Measures
******************************************************************************** 		
		
local CS_PCVars     "M_ev* F_ev* M_PC_Miss* F_PC_Miss*"
local CS_Demo       "i.M_Age##i.MOnly i.F_Age##i.FOnly i.M_BIRTHYR##i.MOnly i.F_BIRTHYR##i.FOnly  Male i.FOnly i.MOnly i.YEAR"
local CS_EducFull   "i.M_Educ##i.F_Educ i.M_DEGREE##i.F_DEGREE i.M_Educ##i.MOnly i.F_Educ##i.FOnly i.M_DEGREE##i.MOnly i.F_DEGREE##i.FOnly"
local CS_Basic      " `CS_PCVars' `CS_Demo'  `CS_EducFull' "	
		
		
_eststo TS13_C1: reg logRealFinWealthWinz `CS_Basic'                                          EA3ScoreAvg  if WealthRegSample==1, cluster(HHID)		
_eststo TS13_C2: reg logRealFinWealthWinz `CS_Basic'   logTotRealTotEarnAdjHH                 EA3ScoreAvg  if WealthRegSample==1, cluster(HHID)		

_eststo TS13_C3: reg logRealFinWealthWinz `CS_Basic'                                          EA3ScoreAvg  if WealthRegSampleLarge==1, cluster(HHID)		
_eststo TS13_C4: reg logRealFinWealthWinz `CS_Basic'   logTotRealTotEarnAdjHH                 EA3ScoreAvg  if WealthRegSampleLarge==1, cluster(HHID)		

_eststo TS13_C5: reg logRealFinWealthWinz `CS_Basic'                                          EA3ScoreAvg  if WealthRegSampleNoRet==1, cluster(HHID)		
_eststo TS13_C6: reg logRealFinWealthWinz `CS_Basic'   logTotRealTotEarnAdjHH                 EA3ScoreAvg  if WealthRegSampleNoRet==1, cluster(HHID)		

_eststo TS13_C7: reg logRealFinWealthWinz `CS_Basic'                                          EA3ScoreAvg  if WealthRegSampleNoRetLarge==1, cluster(HHID)		
_eststo TS13_C8: reg logRealFinWealthWinz `CS_Basic'   logTotRealTotEarnAdjHH                 EA3ScoreAvg  if WealthRegSampleNoRetLarge==1, cluster(HHID)		

		
estout TS13_C1 TS13_C2 TS13_C3 TS13_C4 TS13_C5 TS13_C6 TS13_C7 TS13_C8  using "$OutputDirEnclave\GENX_TS13_AltSamples.tex",  ///
replace ///
cells(b(fmt(%9.3fc) star) se(par fmt(%9.3fc)))   ///
keep  (EA3ScoreAvg logTotRealTotEarnAdjHH  )	  ///	
order (EA3ScoreAvg logTotRealTotEarnAdjHH )	  ///				
eqlabels(none)  ///
style(tex) starlevels(* 0.1 ** 0.05 *** 0.01) stats(N r2, fmt(%9.0f %9.3f) label(Obs. "\$R^{2}$"))		
		
		
********************************************************************************
* TABLE S14: Robustness Exercises - Alternate Scores		
********************************************************************************		
		
local CS_PCVars     "M_ev* F_ev* M_PC_Miss* F_PC_Miss*"
local CS_PCVarsf    "M_fv* F_fv* M_PCf_Miss* F_PCf_Miss*"
local CS_Demo       "i.M_Age##i.MOnly i.F_Age##i.FOnly i.M_BIRTHYR##i.MOnly i.F_BIRTHYR##i.FOnly  Male i.FOnly i.MOnly i.YEAR"
local CS_EducFull   "i.M_Educ##i.F_Educ i.M_DEGREE##i.F_DEGREE i.M_Educ##i.MOnly i.F_Educ##i.FOnly i.M_DEGREE##i.MOnly i.F_DEGREE##i.FOnly"
local CS_Basic      " `CS_PCVars' `CS_Demo'  `CS_EducFull' "
		
		
		merge m:1 HHIDNum PNNum using "$CleanDataEnclave\EA1_PGS.dta", gen(EA1Merge)
		
		
			foreach var in EA2Score EA1Score EA1ScoreNonLD {
			
				* Calculate for Men:
				gen Temp=.
				replace Temp=`var' if Male==1
				bys HHID SUBHH: egen M_`var'=max(Temp)
				drop Temp
				
				* Calculate for Women:
				gen Temp=.
				replace Temp=`var' if Male==0
				bys HHID SUBHH: egen F_`var'=max(Temp)
				drop Temp
				
			}	
		
		
		
	foreach ScoreVar in EA3ScoreHRS  EA2Score EA1Score EA1ScoreNonLD  {

			gen RAW_`ScoreVar'Avg=.
			replace RAW_`ScoreVar'Avg=(M_`ScoreVar'+F_`ScoreVar')/2  if M_`ScoreVar'~=.  & F_`ScoreVar'~=. & MF==1
			replace RAW_`ScoreVar'Avg=M_`ScoreVar'                   if M_`ScoreVar'~=.  & F_`ScoreVar'==. & MF==1
			replace RAW_`ScoreVar'Avg=F_`ScoreVar'                   if M_`ScoreVar'==.  & F_`ScoreVar'~=. & MF==1
			
			replace RAW_`ScoreVar'Avg=M_`ScoreVar'                if M_`ScoreVar'~=.  & MOnly==1
			replace RAW_`ScoreVar'Avg=F_`ScoreVar'                if F_`ScoreVar'~=.  & FOnly==1
			
			sum RAW_`ScoreVar'Avg if HHIDSUBHHCounter==1
			gen `ScoreVar'Avg=(RAW_`ScoreVar'Avg-r(mean))/(r(sd))

	}		
		
		gen M_PCf_Miss=(M_fv1==.)
		gen F_PCf_Miss=(F_fv1==.)
		
		gen M_PCf_MissxMOnly=M_PCf_Miss*MOnly
		gen F_PCf_MissxFOnly=F_PCf_Miss*FOnly
		
		foreach var in fv1 fv2 fv3 fv4 fv5 fv6 fv7 fv8 fv9 fv10 {
			
			replace M_`var'=0 if M_`var'==. & ((F_PCf_Miss==0 & MF==1) | (FOnly==1))
			replace F_`var'=0 if F_`var'==. & ((M_PCf_Miss==0 & MF==1) | (MOnly==1))
			
			gen M_`var'xMOnly=M_`var'*MOnly
			gen F_`var'xFOnly=F_`var'*FOnly
						
		}		
		
		
local CS_PCVars     "M_ev* F_ev* M_PC_Miss* F_PC_Miss*"
local CS_Demo       "i.M_Age##i.MOnly i.F_Age##i.FOnly i.M_BIRTHYR##i.MOnly i.F_BIRTHYR##i.FOnly  Male i.FOnly i.MOnly i.YEAR"
local CS_EducFull   "i.M_Educ##i.F_Educ i.M_DEGREE##i.F_DEGREE i.M_Educ##i.MOnly i.F_Educ##i.FOnly i.M_DEGREE##i.MOnly i.F_DEGREE##i.FOnly"
local CS_Basic      " `CS_PCVars' `CS_Demo'  `CS_EducFull' "		

	_eststo TS14_C1: reg logRealFinWealthWinz `CS_PCVarsf'  `CS_Demo' `CS_EducFull'   logTotRealTotEarnAdjHH   EA3ScoreHRSAvg    if WealthRegSample==1 & EA3ScoreAvg~=., cluster(HHID)	
	_eststo TS14_C2: reg logRealFinWealthWinz `CS_PCVarsf'  `CS_Demo' `CS_EducFull'   logTotRealTotEarnAdjHH   EA3ScoreHRSAvg    if WealthRegSample==1, cluster(HHID)						
	_eststo TS14_C3: reg logRealFinWealthWinz `CS_PCVarsf'  `CS_Demo' `CS_EducFull'   logTotRealTotEarnAdjHH   EA2ScoreAvg       if WealthRegSample==1 & EA3ScoreAvg~=., cluster(HHID)		
	_eststo TS14_C4: reg logRealFinWealthWinz `CS_PCVarsf'  `CS_Demo' `CS_EducFull'   logTotRealTotEarnAdjHH   EA2ScoreAvg       if WealthRegSample==1, cluster(HHID)
	_eststo TS14_C5: reg logRealFinWealthWinz `CS_PCVars'   `CS_Demo' `CS_EducFull'   logTotRealTotEarnAdjHH   EA1ScoreAvg       if WealthRegSample==1, cluster(HHID)
	_eststo TS14_C6: reg logRealFinWealthWinz `CS_PCVars'   `CS_Demo' `CS_EducFull'   logTotRealTotEarnAdjHH   EA1ScoreNonLDAvg  if WealthRegSample==1, cluster(HHID)


	estout TS14_C1 TS14_C2 TS14_C3 TS14_C4 TS14_C5 TS14_C6     using "$OutputDirEnclave\GENX_TS14_AlternateScores.tex",  ///
	replace  ///
	cells(b(fmt(%9.3fc) star) se(par fmt(%9.3fc)))   ///
	keep  (EA3ScoreHRSAvg  EA2ScoreAvg    EA1ScoreAvg EA1ScoreNonLDAvg )	  ///	
	order (EA3ScoreHRSAvg  EA2ScoreAvg    EA1ScoreAvg EA1ScoreNonLDAvg )	  ///				
	eqlabels(none)  ///
	style(tex) starlevels(* 0.1 ** 0.05 *** 0.01) stats(N r2, fmt(%9.0f %9.3f) label(Obs. "\$R^{2}$"))		
		
		
		
	
	
********************************************************************************
* TABLE S15: Robustness Exercises - Alternate Controls		
********************************************************************************			
		
	********************************	
	* Clean Cognitive Test Scores:
	********************************
	foreach var in CogScoreTot CogScoreNumImp {
	
		gen Temp=.
		replace Temp=`var' if Male==1
		bys HHID SUBHH YEAR: egen M_`var'=min(Temp)
		drop Temp
		
		gen Temp=.
		replace Temp=`var' if Male==0
		bys HHID SUBHH YEAR: egen F_`var'=min(Temp)
		drop Temp	
		
		
	}

	gen AvgCogScore=.
	replace AvgCogScore=M_CogScoreTot                    if (MOnly==1 | (MF==1 & M_CogScoreTot~=. & F_CogScoreTot==.))
	replace AvgCogScore=F_CogScoreTot                    if (FOnly==1 | (MF==1 & M_CogScoreTot==. & F_CogScoreTot~=.))
	replace AvgCogScore=(M_CogScoreTot+F_CogScoreTot)/2  if (MF==1 & M_CogScoreTot~=. & F_CogScoreTot~=.)
		
	bys HHID SUBHH YEAR: egen MaxCogScoreNumImp=max(CogScoreNumImp)	
	
			foreach var in EverHomeMaker {
			
				* Calculate for Men:
				gen Temp=.
				replace Temp=`var' if Male==1
				bys HHID SUBHH: egen M_`var'=max(Temp)
				drop Temp
				
				* Calculate for Women:
				gen Temp=.
				replace Temp=`var' if Male==0
				bys HHID SUBHH: egen F_`var'=max(Temp)
				drop Temp
				
			}		
		
	********************************	
	* Clean Years since retirement:	
	********************************
	gen M_YearsSinceRet=.

	replace M_YearsSinceRet=0 if (FOnly==1)
	replace M_YearsSinceRet=(YEAR-M_YearRetired) if ((MOnly==1 | MF==1) & M_YearRetired~=. & (YEAR>=M_YearRetired))
	replace M_YearsSinceRet=0                    if ((MOnly==1 | MF==1) & M_YearRetired~=. & (YEAR<M_YearRetired))


	gen F_YearsSinceRet=.

	replace F_YearsSinceRet=0 if (MOnly==1)
	replace F_YearsSinceRet=(YEAR-F_YearRetired) if ((FOnly==1 | MF==1) & F_YearRetired~=. & (YEAR>=F_YearRetired))
	replace F_YearsSinceRet=0                    if ((FOnly==1 | MF==1) & F_YearRetired~=. & (YEAR<F_YearRetired))
	replace F_YearsSinceRet=0                    if ((FOnly==1 | MF==1) & F_YearsSinceRet==. & F_EverHomeMaker==1)		
		
	****************************************
	* Clean Years Since Death
	****************************************
	
	gen     M_YearsSinceDeath=0
	replace M_YearsSinceDeath=(YEAR-M_EXDEATHYR) if (MF==1 & M_EXDEATHYR~=. & YEAR>=M_EXDEATHYR)

	gen     F_YearsSinceDeath=0
	replace F_YearsSinceDeath=(YEAR-F_EXDEATHYR) if (MF==1 & F_EXDEATHYR~=. & YEAR>=F_EXDEATHYR)	
		
	*******************************************
	* Do the actual regressions
	*******************************************

	bys HHID SUBHH YEAR: gen NumInSUBHH=_N	
	
	local CS_PCVars     "M_ev* F_ev* M_PC_Miss* F_PC_Miss*"
	local CS_Demo       "i.M_Age##i.MOnly i.F_Age##i.FOnly i.M_BIRTHYR##i.MOnly i.F_BIRTHYR##i.FOnly  Male i.FOnly i.MOnly i.YEAR"
	local CS_EducFull   "i.M_Educ##i.F_Educ i.M_DEGREE##i.F_DEGREE i.M_Educ##i.MOnly i.F_Educ##i.FOnly i.M_DEGREE##i.MOnly i.F_DEGREE##i.FOnly"
	local CS_Basic      " `CS_PCVars' `CS_Demo'  `CS_EducFull' "	
	

		
	* Add Cognitive Test Scores:
	_eststo TS15_C1: reg logRealFinWealthWinz `CS_PCVars' `CS_Demo' `CS_EducFull'                         AvgCogScore  EA3ScoreAvg  if WealthRegSample==1, cluster(HHID)
	_eststo TS15_C2: reg logRealFinWealthWinz `CS_PCVars' `CS_Demo' `CS_EducFull' logTotRealTotEarnAdjHH  AvgCogScore  EA3ScoreAvg  if WealthRegSample==1, cluster(HHID)	
	* Add Children:
	_eststo TS15_C3: reg logRealFinWealthWinz `CS_PCVars' `CS_Demo' `CS_EducFull'                          MaxNumTotKidsOPNHH EA3ScoreAvg  if WealthRegSample==1, cluster(HHID)
	_eststo TS15_C4: reg logRealFinWealthWinz `CS_PCVars' `CS_Demo' `CS_EducFull' logTotRealTotEarnAdjHH   MaxNumTotKidsOPNHH EA3ScoreAvg  if WealthRegSample==1, cluster(HHID)	
	* Add Years Since Retirement:
	_eststo TS15_C5: reg logRealFinWealthWinz `CS_PCVars' `CS_Demo' `CS_EducFull'                          i.M_YearsSinceRet##i.MOnly i.F_YearsSinceRet##i.FOnly EA3ScoreAvg  if WealthRegSample==1, cluster(HHID)
	_eststo TS15_C6: reg logRealFinWealthWinz `CS_PCVars' `CS_Demo' `CS_EducFull' logTotRealTotEarnAdjHH   i.M_YearsSinceRet##i.MOnly i.F_YearsSinceRet##i.FOnly EA3ScoreAvg  if WealthRegSample==1, cluster(HHID)	
	* Years since Death / Num in HH 	
	_eststo TS15_C7: reg logRealFinWealthWinz `CS_PCVars' `CS_Demo' `CS_EducFull'                         i.M_YearsSinceDeath i.F_YearsSinceDeath i.NumInSUBHH##i.MF EA3ScoreAvg  if WealthRegSample==1, cluster(HHID)
	_eststo TS15_C8: reg logRealFinWealthWinz `CS_PCVars' `CS_Demo' `CS_EducFull' logTotRealTotEarnAdjHH  i.M_YearsSinceDeath i.F_YearsSinceDeath i.NumInSUBHH##i.MF EA3ScoreAvg  if WealthRegSample==1, cluster(HHID)
	* Add all extra controls:	
	_eststo TS15_C9: reg logRealFinWealthWinz `CS_PCVars' `CS_Demo' `CS_EducFull'                         AvgCogScore MaxNumTotKidsOPNHH i.M_YearsSinceRet##i.MOnly i.F_YearsSinceRet##i.FOnly   i.M_YearsSinceDeath i.F_YearsSinceDeath i.NumInSUBHH##i.MF EA3ScoreAvg  if WealthRegSample==1, cluster(HHID)
	_eststo TS15_C10:reg logRealFinWealthWinz `CS_PCVars' `CS_Demo' `CS_EducFull' logTotRealTotEarnAdjHH  AvgCogScore MaxNumTotKidsOPNHH i.M_YearsSinceRet##i.MOnly i.F_YearsSinceRet##i.FOnly   i.M_YearsSinceDeath i.F_YearsSinceDeath i.NumInSUBHH##i.MF EA3ScoreAvg  if WealthRegSample==1, cluster(HHID)
		
	estout TS15_C1 TS15_C2 TS15_C3 TS15_C4 TS15_C5 TS15_C6 TS15_C7 TS15_C8 TS15_C9 TS15_C10    using "$OutputDirEnclave\GENX_TS15_AdditionalControls.tex",  ///
	replace  ///
	cells(b(fmt(%9.3fc) star) se(par fmt(%9.3fc)))   ///
	keep  (EA3ScoreAvg AvgCogScore MaxNumTotKidsOPNHH )	  ///	
	order (EA3ScoreAvg AvgCogScore MaxNumTotKidsOPNHH )	  ///				
	eqlabels(none)  ///
	style(tex) starlevels(* 0.1 ** 0.05 *** 0.01) stats(N r2, fmt(%9.0f %9.3f) label(Obs. "\$R^{2}$"))		
		
		
		mat AltControlStats=J(3,6,9999)
		mat rownames AltControlStats = CogScore NumKids YearRetired 
		mat colnames AltControlStats = HH Females Males Rho HHQ1 HHQ4

		sum AvgCogScore if InFirstRetWealthYear==1 
		mat AltControlStats[1,1]=r(mean)
		sum F_CogScoreTot if InFirstRetWealthYear==1
		mat AltControlStats[1,2]=r(mean)
		sum M_CogScoreTot if InFirstRetWealthYear==1
		mat AltControlStats[1,3]=r(mean)

		sum MaxNumTotKidsOPNHH if InFirstRetWealthYear==1
		mat AltControlStats[2,1]=r(mean)
		corr EA3ScoreAvg MaxNumTotKidsOPNHH if InFirstRetWealthYear==1 
		mat AltControlStats[2,4]=r(rho)
		sum MaxNumTotKidsOPNHH if InFirstRetWealthYear==1 & EA_HH_Quart==1
		mat AltControlStats[2,5]=r(mean)
		sum MaxNumTotKidsOPNHH if InFirstRetWealthYear==1 & EA_HH_Quart==4
		mat AltControlStats[2,6]=r(mean)	

		sum F_YearRetired if InFirstRetWealthYear==1 
		mat AltControlStats[3,2]=r(mean)	
		sum M_YearRetired if InFirstRetWealthYear==1 
		mat AltControlStats[3,3]=r(mean)			
		
		
	estout matrix(AltControlStats) using "$OutputDirEnclave\GENX_TS15_AdditionalControls.tex", append	style(tex)	
		


		


		
*******************************************************************************
* Table S6: Summary Statistics for Mechanism Variables
*******************************************************************************

tab IncRAbin,   gen(IncRAbinLevel)
tab InherRAbin, gen(InherRAbinLevel)
tab BusRAbin,   gen(BusRAbinLevel)


forvalues yr=1992(2)2012{
	merge m:1 HHID PN SUBHH using "$CleanDataEnclave\SurvivalExpectations`yr'.dta", gen(ExpectMerge`yr')

}

gen ProbLive75More=.

forvalues yr=1992(2)2012{
	replace ProbLive75More=ProbLive75More_`yr' if YEAR==`yr'

}

replace ProbLive75More=. if ProbLive75More>100

local CS_PCVars     "M_ev* F_ev* M_PC_Miss* F_PC_Miss*"
local CS_Demo       "i.M_Age##i.MOnly i.F_Age##i.FOnly i.M_BIRTHYR##i.MOnly i.F_BIRTHYR##i.FOnly  Male i.FOnly i.MOnly i.YEAR"
local CS_EducFull   "i.M_Educ##i.F_Educ i.M_DEGREE##i.F_DEGREE i.M_Educ##i.MOnly i.F_Educ##i.FOnly i.M_DEGREE##i.MOnly i.F_DEGREE##i.FOnly"
local CS_Basic      " `CS_PCVars' `CS_Demo'  `CS_EducFull' "

reg ProbLive75More `CS_Basic' EA3Score    if HHSample==1 & Age>=50 & Age<=65, cluster(HHID)
	gen InExp75Samp=e(sample)



mat GENX_MechSumStats=J(48,12,99999)

		mat rownames GENX_MechSumStats = FatherEducAvg MotherEducAvg AnyInher InherAmt  ProbLive75More  HasBusVal HasHouse AnyStocks ///
										PMUP_Exp PMUP_Dev PMUP_0 PMUP_50 PMUP_100  ///
										PRec_Exp PRec_Dev PRec_0 PRec_50 PRec_100  ///
										DDInf_Exp DDInf_Dev DDInf_0 DDInf_50 DDInf_100  ///
										PlanHorizon1 PlanHorizon2 PlanHorizon3 PlanHorizon4 PlanHorizon5  ///
										IncRA1 IncRA2 IncRA3 IncRA4 IncRA5 IncRA6              ///
										InherRA1 InherRA2 InherRA3 InherRA4 InherRA5 InherRA6              ///
										BusRA1  BusRA2 BusRA3 BusRA4 BusRA5 BusRA6                 ///
										GetPen RealPenMarketValWinz

		mat colnames GENX_MechSumStats = Mean StdDev N      Mean StdDev N   ///
		                                 Mean StdDev N      Mean StdDev N
										
	
	gen PMUP=ProbMarketUp
	gen PRec=ProbUSEconDep
	gen DDInf=ProbDDInf

	local FS=0
	
	foreach FVar in AllFS MF FOnly MOnly {
	
		sum FatherEducAvg if InFirstRetWealthYear==1 & `FVar'==1
		
			mat GENX_MechSumStats[1,3*`FS'+1]=r(mean)
			mat GENX_MechSumStats[1,3*`FS'+2]=r(sd)	
			mat GENX_MechSumStats[1,3*`FS'+3]=r(N)	
	
		sum MotherEducAvg if InFirstRetWealthYear==1 & `FVar'==1
		
			mat GENX_MechSumStats[2,3*`FS'+1]=r(mean)
			mat GENX_MechSumStats[2,3*`FS'+2]=r(sd)	
			mat GENX_MechSumStats[2,3*`FS'+3]=r(N)
	
		sum AnyInherSUBHH if InFirstRetWealthYear==1 & `FVar'==1
		
			mat GENX_MechSumStats[3,3*`FS'+1]=r(mean)
			mat GENX_MechSumStats[3,3*`FS'+2]=r(sd)	
			mat GENX_MechSumStats[3,3*`FS'+3]=r(N)
	
	
		sum TotalRealInher_SUBHH if InFirstRetWealthYear==1 & AnyInherSUBHH==1 & `FVar'==1
		
			mat GENX_MechSumStats[4,3*`FS'+1]=r(mean)
			mat GENX_MechSumStats[4,3*`FS'+2]=r(sd)	
			mat GENX_MechSumStats[4,3*`FS'+3]=r(N)

		sum ProbLive75More if InExp75Samp==1 & `FVar'==1
		
			mat GENX_MechSumStats[5,3*`FS'+1]=r(mean)
			mat GENX_MechSumStats[5,3*`FS'+2]=r(sd)
			mat GENX_MechSumStats[5,3*`FS'+3]=r(N)
	
	
		sum HasBusVal  if BusinessSample==1 & `FVar'==1
		
			mat GENX_MechSumStats[6,3*`FS'+1]=r(mean)
			mat GENX_MechSumStats[6,3*`FS'+2]=r(sd)
			mat GENX_MechSumStats[6,3*`FS'+3]=r(N)
	
	
		sum HasHouse  if HouseSample==1 & `FVar'==1
		
			mat GENX_MechSumStats[7,3*`FS'+1]=r(mean)
			mat GENX_MechSumStats[7,3*`FS'+2]=r(sd)
			mat GENX_MechSumStats[7,3*`FS'+3]=r(N)
	
		sum AnyStocks  if StocksSample==1 & `FVar'==1
		
			mat GENX_MechSumStats[8,3*`FS'+1]=r(mean)
			mat GENX_MechSumStats[8,3*`FS'+2]=r(sd)
			mat GENX_MechSumStats[8,3*`FS'+3]=r(N)
	

	
		local RowC=9
	
		foreach EVar in PMUP PRec DDInf {
		
			sum `EVar' if ExpSample`EVar'==1 & `FVar'==1
			
				mat GENX_MechSumStats[`RowC',3*`FS'+1]=r(mean)
				mat GENX_MechSumStats[`RowC',3*`FS'+2]=r(sd)
				mat GENX_MechSumStats[`RowC',3*`FS'+3]=r(N)
		
			sum Dev_`EVar' if ExpSample`EVar'==1 & `FVar'==1
			
				mat GENX_MechSumStats[`RowC'+1,3*`FS'+1]=r(mean)
				mat GENX_MechSumStats[`RowC'+1,3*`FS'+2]=r(sd)
				mat GENX_MechSumStats[`RowC'+1,3*`FS'+3]=r(N)
		
			sum Extreme_`EVar'_0 if ExpSample`EVar'==1 & `FVar'==1
			
				mat GENX_MechSumStats[`RowC'+2,3*`FS'+1]=r(mean)
				mat GENX_MechSumStats[`RowC'+2,3*`FS'+2]=r(sd)
				mat GENX_MechSumStats[`RowC'+2,3*`FS'+3]=r(N)
		
			sum Extreme_`EVar'_50 if ExpSample`EVar'==1 & `FVar'==1
			
				mat GENX_MechSumStats[`RowC'+3,3*`FS'+1]=r(mean)
				mat GENX_MechSumStats[`RowC'+3,3*`FS'+2]=r(sd)
				mat GENX_MechSumStats[`RowC'+3,3*`FS'+3]=r(N)
		
			sum Extreme_`EVar'_100 if ExpSample`EVar'==1 & `FVar'==1
			
				mat GENX_MechSumStats[`RowC'+4,3*`FS'+1]=r(mean)
				mat GENX_MechSumStats[`RowC'+4,3*`FS'+2]=r(sd)
				mat GENX_MechSumStats[`RowC'+4,3*`FS'+3]=r(N)
		
		
			local RowC=`RowC'+5
		}
		
		* Starting next with Row 24, look at financial planning categories
		
		forvalues FVal=1(1)5{
		
			sum FPC`FVal' if FinPlanSample==1 & `FVar'==1
			
				mat GENX_MechSumStats[23+`FVal',3*`FS'+1]=r(mean)
				mat GENX_MechSumStats[23+`FVal',3*`FS'+2]=r(sd)
				mat GENX_MechSumStats[23+`FVal',3*`FS'+3]=r(N)
		
		}
		
		* Starting with Row 29:
	    
		local Counter=1
		foreach VR in Inc Inher Bus { 

			forvalues Ind=1(1)6{
				sum `VR'RAbinLevel`Ind' if `VR'RASample==1 & `FVar'==1
				
				mat GENX_MechSumStats[28+`Counter',3*`FS'+1]=r(mean)
				mat GENX_MechSumStats[28+`Counter',3*`FS'+2]=r(sd)
				mat GENX_MechSumStats[28+`Counter',3*`FS'+3]=r(N)
				
				local Counter=`Counter'+1
				
			}
		}
		
		sum GetPen if PenSample==1 & `FVar'==1
		
			mat GENX_MechSumStats[47,3*`FS'+1]=r(mean)
			mat GENX_MechSumStats[47,3*`FS'+2]=r(sd)
			mat GENX_MechSumStats[47,3*`FS'+3]=r(N)
		
		sum RealPenMarketValWinz if PenMarketValSample==1 & `FVar'==1
		
			mat GENX_MechSumStats[48,3*`FS'+1]=r(mean)
			mat GENX_MechSumStats[48,3*`FS'+2]=r(sd)
			mat GENX_MechSumStats[48,3*`FS'+3]=r(N)
	
		local FS=`FS'+1
	}



  

estout matrix(GENX_MechSumStats) using "$OutputDirEnclave\GENX_TS6_MechSumStats.tex", style(tex) replace		
		
		
*******************************************************************************
* Table S6: Differences between Genotyped and Non-Genotyped Individuals
*******************************************************************************

clear all

use "$CleanDataEnclave\GenesWealth_RegSampleForAppendix.dta"

* Get the first Wealth year for each HHID-SUBHH combination.  Of course, 
* an individual person might be part of multiple HHID-SUBHH's, so we will
* then need to take the minimum of this for a person to get their 
* "first household wealth observation"

gen Temp=.
replace Temp=YEAR if RealFinWealthWinz~=. & (HH_NumWorkNoRet==0 & FinRespondent==1 & SampleYears==1)
bys HHID SUBHH: egen tmpYearFirstWealthOb=min(Temp)
drop Temp

bys HHID PN: egen YearFirstWealthOb=min(tmpYearFirstWealthOb)

keep if YEAR==YearFirstWealthOb

bys HHID PN: gen Counter=_n
keep if Counter==1


gen CrossRFWWinz=RealFinWealthWinz
gen RFWAge=Age


keep HHID PN  CrossRFWWinz RFWAge YearFirstWealthOb

save "$CleanDataEnclave\GenesWealth_WealthFirstOb.dta", replace



clear all

use "$EnclaveTracker\TRK2016TR_R.dta"

gen InGeneticSample=(GENETICS06==1 | GENETICS08==1)
gen InGeneticSampleFull=(GENETICS06==1 | GENETICS08==1 | GENETICS10==1 | GENETICS12==1)

* Clean BIRTHYR
replace BIRTHYR=. if BIRTHYR==0

* Generate Male from GENDER
gen Male=.
replace Male=1 if GENDER==1
replace Male=0 if GENDER==2

* Generate Educ
gen Educ=SCHLYRS
replace Educ=. if Educ==99

* Generate White
gen White=.
replace White=1 if RACE==1
replace White=0 if (RACE==2 | RACE==7)

* Look at Total income: TotRealEarnAdjPers
merge 1:1 HHID PN using "$CleanDataEnclave\GENX_IncomeTots", gen(IncMerge)

* Look at Wealth at Age 60: 
merge 1:1 HHID PN using "$CleanDataEnclave\GenesWealth_WealthFirstOb.dta", gen(WealthFirstObMerge)



mat GenoTypeDiffMat=J(6,5,9999)

mat rownames GenoTypeDiffMat = BIRTHYR Educ Male White TotRealEarnAdjPers CrossRFWWinz 
mat colnames GenoTypeDiffMat = Mean_Geno Mean_NoGeno PValDiff

local VarCounter=1
* Differences for everyone:
foreach var in BIRTHYR Educ Male White TotRealEarnAdjPers CrossRFWWinz {

	sum `var' if InGeneticSample==1
		mat GenoTypeDiffMat[`VarCounter',1]=r(mean)
		mat GenoTypeDiffMat[`VarCounter',4]=r(N)
	sum `var' if InGeneticSample==0
		mat GenoTypeDiffMat[`VarCounter',2]=r(mean)
		mat GenoTypeDiffMat[`VarCounter',5]=r(N)
	ttest `var', by(InGeneticSample)
		mat GenoTypeDiffMat[`VarCounter',3]=r(p)
		
local VarCounter=`VarCounter'+1
}

esttab mat(GenoTypeDiffMat)  using "$OutputDirEnclave\GENX_TS1_GenotypeDiffs.tex" , b(%11.2f) replace

mat GenoTypeDiffMatMen=J(6,3,9999)

mat rownames GenoTypeDiffMatMen = BIRTHYR Educ Male White TotRealEarnAdjPers CrossRFWWinz 
mat colnames GenoTypeDiffMatMen = Mean_Geno Mean_NoGeno PValDiff

local VarCounter=1
* Differences for everyone:
foreach var in BIRTHYR Educ Male White TotRealEarnAdjPers CrossRFWWinz {

	sum `var' if InGeneticSample==1 & Male==1
		mat GenoTypeDiffMatMen[`VarCounter',1]=r(mean)
	sum `var' if InGeneticSample==0 & Male==1
		mat GenoTypeDiffMatMen[`VarCounter',2]=r(mean)
	ttest `var', by(InGeneticSample)
		mat GenoTypeDiffMatMen[`VarCounter',3]=r(p)
		
local VarCounter=`VarCounter'+1
}

esttab mat(GenoTypeDiffMatMen)  using "$OutputDirEnclave\GENX_TS1_GenotypeDiffs.tex" , b(%11.2f) append

mat GenoTypeDiffMatWom=J(6,3,9999)

mat rownames GenoTypeDiffMatWom = BIRTHYR Educ Male White TotRealEarnAdjPers CrossRFWWinz 
mat colnames GenoTypeDiffMatWom = Mean_Geno Mean_NoGeno PValDiff

local VarCounter=1
* Differences for everyone:
foreach var in BIRTHYR Educ Male White TotRealEarnAdjPers CrossRFWWinz {

	sum `var' if InGeneticSample==1 & Male==0
		mat GenoTypeDiffMatWom[`VarCounter',1]=r(mean)
	sum `var' if InGeneticSample==0 & Male==0
		mat GenoTypeDiffMatWom[`VarCounter',2]=r(mean)
	ttest `var', by(InGeneticSample)
		mat GenoTypeDiffMatWom[`VarCounter',3]=r(p)
		
local VarCounter=`VarCounter'+1
}

esttab mat(GenoTypeDiffMatWom)  using "$OutputDirEnclave\GENX_TS1_GenotypeDiffs.tex" , b(%11.2f) append

gen logCrossRFWWinz=log(CrossRFWWinz)
gen logTotRealEarnAdjPers=log(TotRealEarnAdjPers)
gen logAvgEarnTop35=log(AvgEarnTop35)

_eststo TS6_C1: reg logCrossRFWWinz       i.BIRTHYR i.RFWAge Male White Educ if InGeneticSample==1
_eststo TS6_C2: reg logCrossRFWWinz       i.BIRTHYR i.RFWAge Male White Educ 
_eststo TS6_C3: reg logTotRealEarnAdjPers i.BIRTHYR Male White Educ if InGeneticSample==1 & Male==1
_eststo TS6_C4: reg logTotRealEarnAdjPers i.BIRTHYR Male White Educ if                      Male==1
_eststo TS6_C5: reg logAvgEarnTop35       i.BIRTHYR Male White Educ if InGeneticSample==1 & Male==0
_eststo TS6_C6: reg logAvgEarnTop35       i.BIRTHYR Male White Educ if                      Male==0


estout TS6_C1 TS6_C2 TS6_C3 TS6_C4 TS6_C5 TS6_C6  using "$OutputDirEnclave\GENX_TS1_GenotypeDiffs.tex",  ///
append ///
cells(b(fmt(%9.3fc) star) se(par fmt(%9.3fc)))   ///
keep  (Educ)	  ///	
order (Educ)	  ///				
eqlabels(none)  ///
style(tex) starlevels(* 0.1 ** 0.05 *** 0.01) stats(N r2, fmt(%9.0f %9.3f) label(Obs. "\$R^{2}$")) 		
		
clear all		
log close		
		