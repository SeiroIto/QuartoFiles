
clear all

* Load the Main Panel, which has been assembled off of the MiCDA Server:
use "$ExtDataEnclave\GenesWealth_CleanPanel.dta"
		

* Merge SSA Income Measures:
merge m:1 HHID PN using  "$CleanDataEnclave\GENX_IncomeTots", gen(IncMerge)
	drop if IncMerge==2

		* Get Variables for Personal Income totals for the Male and Female Household
		* Members, respecctively:
		foreach var in TotRealEarnPers TotRealEarnAdjPers NumTopCodePers NumObsTREAdjPers {
		
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


	* Take logs of Income Total variables:			
	foreach var in M_TotRealEarnAdjPers TotRealEarnHH TotRealEarnPers TotRealEarnAdjHH TotRealTotEarnAdjHH TotRealEarnAdjPers {

		gen log`var'=log(`var') 
		gen logP1`var'=log(`var'+1)
	}


	* Now, clean some variables that will be used in the summary statistics:
	
	* Set Zero values for Total Real Total Earnings from the SSA when missing:
	gen TotRealTotEarnAdjHHNonZero=TotRealTotEarnAdjHH
	replace TotRealTotEarnAdjHHNonZero=. if TotRealTotEarnAdjHHNonZero==0

	* Get an indicator for observed zeros for Total Real Total Earnings:
	gen ZeroTotRealTotEarnAdjHH=.
	replace ZeroTotRealTotEarnAdjHH=0 if TotRealTotEarnAdjHH~=.
	replace ZeroTotRealTotEarnAdjHH=1 if TotRealTotEarnAdjHH==0

	* Get an indicator for non-missing Total Real Total Earnings:	
	gen NonMissTotRealTotEarnAdjHH=0
	replace NonMissTotRealTotEarnAdjHH=1 if TotRealTotEarnAdjHH~=.

	* Get Number of Top-Coded person-year observations for household
	gen ZeroTopCodes=.
	replace ZeroTopCodes=0 if NumTopCodeHH~=.
	replace ZeroTopCodes=1 if NumTopCodeHH==0


	
			
    **********************************************************************************
	* Construct Quartiles of the EA score distribution and the EAScoreAvg distribution
	***********************************************************************************
	
		****************************
		* Individual EA Scores
		****************************
		
		gen Temp=.
		replace Temp=EA3Score if Pers_EverInRetSample==1 & NewPersCounter==1
		_pctile  Temp, p(25 50 75) 		
		gen EA_Ind_pr25=r(r1)
		gen EA_Ind_pr50=r(r2)
		gen EA_Ind_pr75=r(r3)
		drop Temp	
		
		gen EA_Ind_Quart=.
		replace EA_Ind_Quart=1 if EA3Score~=. & EA3Score<=EA_Ind_pr25
		replace EA_Ind_Quart=2 if EA3Score~=. & EA3Score>EA_Ind_pr25   & EA3Score<=EA_Ind_pr50
		replace EA_Ind_Quart=3 if EA3Score~=. & EA3Score>EA_Ind_pr50   & EA3Score<=EA_Ind_pr75
		replace EA_Ind_Quart=4 if EA3Score~=. & EA3Score>EA_Ind_pr75
		
		gen EA_Ind_Q4=.
		replace EA_Ind_Q4=0 if (EA_Ind_Quart==1 | EA_Ind_Quart==2 | EA_Ind_Quart==3)
		replace EA_Ind_Q4=1 if EA_Ind_Quart==4	
			
		******************************
		* Household Level EAScoreAvg
		******************************
			
		gen Temp=.
		replace Temp=EA3ScoreAvg if InFirstRetWealthYear==1
		_pctile  Temp, p(25 50 75) 			
		gen EA_HH_pr25=r(r1)
		gen EA_HH_pr50=r(r2)
		gen EA_HH_pr75=r(r3)	
		drop Temp
		
		gen EA_HH_Quart=.
		replace EA_HH_Quart=1 if EA3ScoreAvg~=. & EA3ScoreAvg<=EA_HH_pr25
		replace EA_HH_Quart=2 if EA3ScoreAvg~=. & EA3ScoreAvg>EA_HH_pr25   & EA3ScoreAvg<=EA_HH_pr50
		replace EA_HH_Quart=3 if EA3ScoreAvg~=. & EA3ScoreAvg>EA_HH_pr50   & EA3ScoreAvg<=EA_HH_pr75
		replace EA_HH_Quart=4 if EA3ScoreAvg~=. & EA3ScoreAvg>EA_HH_pr75
		
		gen EA_HH_Q4=.
		replace EA_HH_Q4=0 if (EA_HH_Quart==1 | EA_HH_Quart==2 | EA_HH_Quart==3)
		replace EA_HH_Q4=1 if EA_HH_Quart==4			
			
		

*******************************************************************************
* BEGIN TABLES AND FIGURES
*******************************************************************************


*******************************************************************************
* Table 1: Summary Statistics for Primary Analytical Sample
*******************************************************************************			


* Table 1 
* Get means and standard deviations separately for men and women for the following
* variables:  Year of Birth, Years of Education, Degrees (7 degrees).




foreach samp in Ret NoRet RetLarge NoRetLarge {

	mat T1_SumStats_A_`samp'=J(9,6,9999)
	mat rownames T1_SumStats_A_`samp' = YearBirth YearsEduc NoDegree GED HS SomeColl College MA ProDegree
	mat colnames T1_SumStats_A_`samp' = Men_Mean Men_SD Men_N  Fem_Mean Fem_SD Fem_N

	local RInd=1

	foreach var in BIRTHYR Educ DEGREE_None DEGREE_GED DEGREE_HighSchool DEGREE_TwoYr DEGREE_Coll DEGREE_MA DEGREE_Prof {

		sum M_`var' if InFirst`samp'WealthYear==1
		
		mat T1_SumStats_A_`samp'[`RInd',1]=r(mean)
		mat T1_SumStats_A_`samp'[`RInd',2]=r(sd)
		mat T1_SumStats_A_`samp'[`RInd',3]=r(N)

		sum F_`var' if InFirst`samp'WealthYear==1
		
		mat T1_SumStats_A_`samp'[`RInd',4]=r(mean)
		mat T1_SumStats_A_`samp'[`RInd',5]=r(sd)
		mat T1_SumStats_A_`samp'[`RInd',6]=r(N)	
		
		local RInd=`RInd'+1
	}

		
* Table 1 Panel B: 
* Get mean, standard deviation, and selected percentiles of total household income (cross-sectional)
* Get mean, standard deviation, of number of years top coded	
* Get mean, standard deviation, and selected percentiles of household wealth (all hh-year observations)		
	
mat T1_SumStats_B_`samp'=J(11,3,9999)
mat rownames T1_SumStats_B_`samp' = N Mean StdDev 10thPercentile 25Percentile Median 75thPercentile 90thPercentile MedianNoHousing MedianNoPensions MedianNoPNoH
mat colnames T1_SumStats_B_`samp' = HHIncome YrsTopCoded HHWealth 		
		
	sum TotRealTotEarnAdjHH if InFirst`samp'WealthYear==1, det
		mat T1_SumStats_B_`samp'[1,1]=r(N)
		mat T1_SumStats_B_`samp'[2,1]=r(mean)
		mat T1_SumStats_B_`samp'[3,1]=r(sd)
		mat T1_SumStats_B_`samp'[4,1]=r(p10)
		mat T1_SumStats_B_`samp'[5,1]=r(p25)
		mat T1_SumStats_B_`samp'[6,1]=r(p50)
		mat T1_SumStats_B_`samp'[7,1]=r(p75)
		mat T1_SumStats_B_`samp'[8,1]=r(p90)
	
	sum NumTopCodeHH if InFirst`samp'WealthYear==1, det
		mat T1_SumStats_B_`samp'[1,2]=r(N)
		mat T1_SumStats_B_`samp'[2,2]=r(mean)
		mat T1_SumStats_B_`samp'[3,2]=r(sd)
		
	sum RealFinWealth if `samp'RegSample==1, det
		mat T1_SumStats_B_`samp'[1,3]=r(N)
		mat T1_SumStats_B_`samp'[2,3]=r(mean)
		mat T1_SumStats_B_`samp'[3,3]=r(sd)
		mat T1_SumStats_B_`samp'[4,3]=r(p10)
		mat T1_SumStats_B_`samp'[5,3]=r(p25)
		mat T1_SumStats_B_`samp'[6,3]=r(p50)
		mat T1_SumStats_B_`samp'[7,3]=r(p75)
		mat T1_SumStats_B_`samp'[8,3]=r(p90)
		
	sum RealFinWealthNoH    if `samp'RegSample==1, det
		mat T1_SumStats_B_`samp'[9,3]=r(p50)
		
	sum RealFinWealthNoP    if `samp'RegSample==1, det
		mat T1_SumStats_B_`samp'[10,3]=r(p50)
		
	sum RealFinWealthNoPH   if `samp'RegSample==1, det
		mat T1_SumStats_B_`samp'[11,3]=r(p50)
		
}		

estout matrix(T1_SumStats_A_Ret)   using "$OutputDirEnclave\GENX_T1_SumStats.tex", replace	style(tex)
estout matrix(T1_SumStats_B_Ret)   using "$OutputDirEnclave\GENX_T1_SumStats.tex", append	style(tex)		
		
estout matrix(T1_SumStats_A_NoRet)   using "$OutputDirEnclave\GENX_T1_SumStats.tex", append	style(tex)
estout matrix(T1_SumStats_B_NoRet)   using "$OutputDirEnclave\GENX_T1_SumStats.tex", append	style(tex)	
 
		
		
*******************************************************************************
* TABLE S2: Summary Statistics for YearBorn, Education by Different Samples
*******************************************************************************
gen AllFS=1

local FInd=1
foreach FS in AllFS MF FOnly MOnly {

	mat TableS1_SumStats_FS_`FS'=J(9,6,9999)
	mat rownames TableS1_SumStats_FS_`FS' = YearBirth YearsEduc NoDegree GED HS SomeColl College MA ProDegree 
	mat colnames TableS1_SumStats_FS_`FS' = Men_Mean Men_SD Men_N  Fem_Mean Fem_SD Fem_N

	local RInd=1

	foreach var in BIRTHYR Educ DEGREE_None DEGREE_GED DEGREE_HighSchool DEGREE_TwoYr DEGREE_Coll DEGREE_MA DEGREE_Prof  {

		sum M_`var' if InFirstRetWealthYear==1 & `FS'==1
		
		mat TableS1_SumStats_FS_`FS'[`RInd',1]=r(mean)
		mat TableS1_SumStats_FS_`FS'[`RInd',2]=r(sd)
		mat TableS1_SumStats_FS_`FS'[`RInd',3]=r(N)

		sum F_`var' if InFirstRetWealthYear==1 & `FS'==1
		
		mat TableS1_SumStats_FS_`FS'[`RInd',4]=r(mean)
		mat TableS1_SumStats_FS_`FS'[`RInd',5]=r(sd)
		mat TableS1_SumStats_FS_`FS'[`RInd',6]=r(N)	
		
		local RInd=`RInd'+1
	}

	if (`FInd'==1) {
		estout matrix(TableS1_SumStats_FS_`FS') using "$OutputDirEnclave\GENX_TS2_SumStats.tex", replace	style(tex)
	} 
	else {
		estout matrix(TableS1_SumStats_FS_`FS') using "$OutputDirEnclave\GENX_TS2_SumStats.tex", append	style(tex)
	}
	
	local FInd=`FInd'+1

}		
		
		

		
		
********************************************************************************
* Table 2: Key Variables v.s. Household Avg EA Score
*    The goal here is to examine the relationship between Own Education,
*    Mother's Education, Father's Education, Household Income, Household Wealth
********************************************************************************



mat Table2_EAvsKeyVars=J(9,7,9999)
mat rownames Table2_EAvsKeyVars = Fem_Educ Fem_FathEduc Fem_MothEduc Men_Educ Men_FathEduc M_MothEduc HHInc HHWealth HHWealthWinz
mat colnames Table2_EAvsKeyVars = Q1 Q2 Q3 Q4 DiffQ4Q1 pval_Diff Obs		
		
		
		*****************************************************************************************
		* Time Invariant Characteristics: Own Education, Parental Education, Household Income 
		*****************************************************************************************
		local tmp=1
		foreach var in F_Educ F_FatherEduc F_MotherEduc M_Educ M_FatherEduc M_MotherEduc TotRealTotEarnAdjHH {
		
			forvalues QT=1(1)4{
				sum `var' if InFirstRetWealthYear==1 & EA_HH_Quart==`QT'
				mat Table2_EAvsKeyVars[`tmp',`QT']=r(mean)			
						
			}	
			
			ttest `var'  if InFirstRetWealthYear==1 & (EA_HH_Quart==1 | EA_HH_Quart==4), by(EA_HH_Q4)
				mat Table2_EAvsKeyVars[`tmp',5]=r(mu_2)-r(mu_1)
				mat Table2_EAvsKeyVars[`tmp',6]=r(p)
			quietly sum `var' if InFirstRetWealthYear==1
				mat Table2_EAvsKeyVars[`tmp',7]=r(N)   
			
			local tmp=`tmp'+1
		}		
		*****************************************************************************************
		* Time Varying Characteristics (Wealth)
		*****************************************************************************************		
		local tmp=8
		foreach var in RealFinWealth RealFinWealthWinz {
		
			forvalues QT=1(1)4{
				sum `var' if RetRegSample==1 & EA_HH_Quart==`QT'
				mat Table2_EAvsKeyVars[`tmp',`QT']=r(mean)			
						
			}	
			
			ttest `var'  if RetRegSample==1 & (EA_HH_Quart==1 | EA_HH_Quart==4), by(EA_HH_Q4)
				mat Table2_EAvsKeyVars[`tmp',5]=r(mu_2)-r(mu_1)
				mat Table2_EAvsKeyVars[`tmp',6]=r(p)
			quietly sum `var' if RetRegSample==1
				mat Table2_EAvsKeyVars[`tmp',7]=r(N)   
			
			local tmp=`tmp'+1
		}			
		
estout matrix(Table2_EAvsKeyVars)  using "$OutputDirEnclave\GENX_T2_EAvsKeyVars.tex", replace	style(tex)	
		

*****************************************************************************
* Table 3: Selection by Sample Definition 
*    The goal here is to examine average incidence of Male, Birth Year, 
*    and age across differnt quartiles of the EA distribution
*    for two different samples: our main analysis sample, and the sample
*    that includes retired individuals 
*****************************************************************************
		
mat Table3_EAvsTI_Ret =J(3,8,9999)
mat rownames Table3_EAvsTI_Ret = Male BirthYear Age 
mat colnames Table3_EAvsTI_Ret = Q1 Q2 Q3 Q4 DiffQ4Q1 pval_Diff Obs OverallMean

mat Table3_EAvsTI_NoRet=J(3,8,9999)
mat rownames Table3_EAvsTI_NoRet = Male BirthYear Age 
mat colnames Table3_EAvsTI_NoRet = Q1 Q2 Q3 Q4 DiffQ4Q1 pval_Diff Obs  OverallMean

mat Table3_EAvsTI_RetLarge =J(3,8,9999)
mat rownames Table3_EAvsTI_RetLarge = Male BirthYear Age 
mat colnames Table3_EAvsTI_RetLarge = Q1 Q2 Q3 Q4 DiffQ4Q1 pval_Diff Obs  OverallMean

mat Table3_EAvsTI_NoRetLarge=J(3,8,9999)
mat rownames Table3_EAvsTI_NoRetLarge = Male BirthYear Age 
mat colnames Table3_EAvsTI_NoRetLarge = Q1 Q2 Q3 Q4 DiffQ4Q1 pval_Diff Obs OverallMean


foreach samp in Ret NoRet RetLarge NoRetLarge  {

	********************************************
	* First, get differences in our Main Sample 
	********************************************
		*************************************************
		* Time Invariant Characteristics: BIRTHYR, Male
		*************************************************
		local tmp=1
		foreach var in Male BIRTHYR {
		
			forvalues QT=1(1)4{
				sum `var' if Pers_EverIn`samp'Sample==1 & NewPersCounter==1 & EA_Ind_Quart==`QT'
				mat Table3_EAvsTI_`samp'[`tmp',`QT']=r(mean)			
						
			}	
			
			ttest `var'  if Pers_EverIn`samp'Sample==1 & NewPersCounter==1 & (EA_Ind_Quart==1 | EA_Ind_Quart==4), by(EA_Ind_Q4)
				mat Table3_EAvsTI_`samp'[`tmp',5]=r(mu_2)-r(mu_1)
				mat Table3_EAvsTI_`samp'[`tmp',6]=r(p)
			quietly sum `var' if Pers_EverIn`samp'Sample==1 & NewPersCounter==1
				mat Table3_EAvsTI_`samp'[`tmp',7]=r(N)
				mat Table3_EAvsTI_`samp'[`tmp',8]=r(mean)
			
			local tmp=`tmp'+1
		}

		********************************************
		* Time Varying Characteristic: Age
		********************************************
			forvalues QT=1(1)4{
				sum Age if SUBHH_`samp'_SampleYear==1 & EA_Ind_Quart==`QT'
				mat Table3_EAvsTI_`samp'[3,`QT']=r(mean)			
						
			}			
			ttest Age  if SUBHH_`samp'_SampleYear==1 & (EA_Ind_Quart==1 | EA_Ind_Quart==4), by(EA_Ind_Q4)
				mat Table3_EAvsTI_`samp'[3,5]=r(mu_2)-r(mu_1)
				mat Table3_EAvsTI_`samp'[3,6]=r(p)
			quietly sum Age if SUBHH_`samp'_SampleYear==1
				mat Table3_EAvsTI_`samp'[3,7]=r(N)
				mat Table3_EAvsTI_`samp'[3,8]=r(mean)
				
}				
				
estout matrix(Table3_EAvsTI_Ret)        using "$OutputDirEnclave\GENX_T3_Selection.tex", replace	style(tex)	
estout matrix(Table3_EAvsTI_NoRet)      using "$OutputDirEnclave\GENX_T3_Selection.tex", append	style(tex)			
estout matrix(Table3_EAvsTI_RetLarge)   using "$OutputDirEnclave\GENX_T3_Selection.tex", append	style(tex)			
estout matrix(Table3_EAvsTI_NoRetLarge) using "$OutputDirEnclave\GENX_T3_Selection.tex", append	style(tex)			
		
		
		
*****************************************************
* DESCRIPTIVE FIGURES
*****************************************************

set scheme s2mono

		**************************************
		* Figure 1: Density of EA3ScoreAvg 
		**************************************
		twoway kdensity EA3ScoreAvg if InFirstRetWealthYear==1,  graphregion(color(white)) xtitle("EA Score (Household Average)")  ytitle("Density")
		graph export "$OutputDirEnclave/GENX_Fig1_EA3ScoreAvgDist.pdf", replace		
						
		*************************************************************************************************
		* FIGURE 2: Non-Parametric Relationships between EA3Score (or EA3ScoreAvg) and Household Wealth
		*************************************************************************************************

		
		twoway lowess logRealFinWealthWinz EA3ScoreAvg if  RetRegSample==1 & EA3ScoreAvg>-2.1 & EA3ScoreAvg<2.1, ytitle("log Real Total Wealth ") xsize(4.2) xtitle("EA Score (Household Average)")graphregion(color(white)) yscale(range(12.50  13.75)) ylab(12.50(0.25)13.75) 
		graph export "$OutputDirEnclave/GENX_Fig2_WealthvsEAScore_A.pdf", replace	

		lowess logRealFinWealthWinz EA3ScoreAvg if  RetRegSample==1 & EA3ScoreAvg>-2.1 & EA3ScoreAvg<2.1, gen(SmoothlogW)
		gen EA3ScoreCloseToNeg1=(abs(EA3Score+1)<0.005)
		gen EA3ScoreCloseToPos1=(abs(EA3Score-1)<0.005)
		
		sum SmoothlogW if EA3ScoreCloseToNeg1==1
			local val1=r(mean)
		sum SmoothlogW if EA3ScoreCloseToPos1==1
			local val2=r(mean)
			di `val2'-`val1'
			di exp(`val2')-exp(`val1')
			di (exp(`val2')-exp(`val1'))/(exp(`val1'))
		
		twoway (lowess logRealFinWealthWinz EA3ScoreAvg if  MaxDEGREE<=2              &   RetRegSample==1  & EA3ScoreAvg>-2.1 & EA3ScoreAvg<2.1, lpattern(dash)) ///
		       (lowess logRealFinWealthWinz EA3ScoreAvg if  MaxDEGREE>2 & MaxDEGREE<9 &   RetRegSample==1  & EA3ScoreAvg>-2.1 & EA3ScoreAvg<2.1, lpattern(solid)), ///
			     ytitle("log Real Total Wealth ") xsize(5) xtitle("EA Score (Household Average)")graphregion(color(white)) legend(label(1 "High School or Less") label(2 "At Least Some College")) yscale(range(12.50  14.00)) ymtick(12.50(0.50)14.00) ylab(12.50(0.50)14.00)
		graph export "$OutputDirEnclave/GENX_Fig2_WealthvsEAScore_B.pdf", replace		 

		
		
		
		
********************************************************
* Adjust Regressors with missing values for Regressions
********************************************************


		replace M_Age=50  if FOnly==1
		replace F_Age=50  if MOnly==1
		
		replace M_Educ=0 if FOnly==1
		replace F_Educ=0 if MOnly==1
		
		replace M_DEGREE=0 if FOnly==1
		replace F_DEGREE=0 if MOnly==1
		
		replace M_BIRTHYR=0 if FOnly==1
		replace F_BIRTHYR=0 if MOnly==1

		replace M_FatherEducWithM=9999 if FOnly==1
		replace F_FatherEducWithM=9999 if MOnly==1
		
		replace M_MotherEducWithM=9999 if FOnly==1
		replace F_MotherEducWithM=9999 if MOnly==1
		
		replace M_FEMiss=1 if FOnly==1
		replace F_FEMiss=1 if MOnly==1
		
		replace M_MEMiss=1 if FOnly==1
		replace F_MEMiss=1 if MOnly==1	
		
		replace M_Age=. if M_Age<0
		replace F_Age=. if F_Age<0

save "$CleanDataEnclave\GenesWealth_RegSample", replace	







