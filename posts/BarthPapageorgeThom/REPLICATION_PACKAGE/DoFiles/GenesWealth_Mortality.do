

clear all

use "$Tracker16\HRS_Tracker16.dta"

* First, Merge with some cleaned variables from the Cross-Sectional Data:
merge 1:1 HHID PN using "$CleanData\GenesWealth_CrossSectionVars.dta", gen(CrossXMerge)

* Merge with indicators for sample inclusion:
merge 1:1 HHID PN using "$CleanData\GenesWealth_PersonSampleInds.dta", gen(IndMerge)

		
**************************************************
* Section 1- Clean Variables from Tracker Files		
**************************************************

	gen DEATHYR=EXDEATHYR
	gen JOINED=FIRSTIW
	
	* BIRTHYR and Age
	replace BIRTHYR=. if BIRTHYR==0
	
	unique HHID PN
	/* Drop Flag - Drop those with missing GENDER or BIRTHYR */
	drop if GENDER==.
	drop if BIRTHYR==.
	unique HHID PN
		
	* Expand the Data Set by 25 for each year 1992-2016
	expand 25
	bys HHID PN: gen Counter=_n
	gen YEAR=1991+Counter
	
	* Get Vital Status Variables, and create a variable, "DeadNext2," indicating 
	* if the individual dies within two years of date:
	
	gen VitalStatus1992=AALIVE
	gen VitalStatus1993=BALIVE
	gen VitalStatus1994=CALIVE
	gen VitalStatus1995=DALIVE
	gen VitalStatus1996=EALIVE
	gen VitalStatus1998=FALIVE
	gen VitalStatus2000=GALIVE
	gen VitalStatus2002=HALIVE
	gen VitalStatus2004=JALIVE
	gen VitalStatus2006=KALIVE
	gen VitalStatus2008=LALIVE
	gen VitalStatus2010=MALIVE
	gen VitalStatus2012=NALIVE
	gen VitalStatus2014=OALIVE
	gen VitalStatus2016=PALIVE	
	
	
	gen VitalStatus=.
	forvalues yr=1992(2)2016{
		replace VitalStatus=VitalStatus`yr' if YEAR==`yr'
	}
	
	/* Coding for XALIVE variables:
	
	   1. Alive at this wave
	   2. Presumed alive as of this wave
	   5. Known deceased as of this wave
	   6. Known deceased as of prior wave
	*/
			
	gen Alive=(VitalStatus==1 | VitalStatus==2)	
	
	* Get a Variable LastYearAlive indicating the last year that this person was known to be alive
	gen Temp=.
	replace Temp=YEAR if Alive==1
	bys HHID PN: egen LastYearAlive=max(Temp)
	drop Temp
	
	gen Temp=.
	replace Temp=YEAR if (VitalStatus==5 | VitalStatus==6)
	bys HHID PN: egen FirstYearDead=min(Temp)
	drop Temp
	
	
	
	
	gen DieNext=.
	replace DieNext=0 if YEAR<=(LastYearAlive-1)
	replace DieNext=1 if YEAR==(EXDEATHYR-1)
	
	gen DieNextAltDef=.
	replace DieNextAltDef=0 if YEAR<=(LastYearAlive-1)
	replace DieNextAltDef=1 if YEAR==(FirstYearDead-1)
	
				
	gen YearGenotyped=.
	replace YearGenotyped=2006 if GENETICS06==1
	replace YearGenotyped=2008 if GENETICS08==1
	replace YearGenotyped=2010 if GENETICS10==1
	replace YearGenotyped=2012 if GENETICS12==1
			
	gen Age=YEAR-BIRTHYR
	
	gen HHIDPN=HHID+PN
			
			
_eststo Death1: reg DieNext       ev1-ev10 i.Age i.BIRTHYR i.Educ i.DEGREE EA3Score if YEAR>=YearGenotyped & Age>=50 & Age<=90 & Pers_EverInRetSample==1 & YEAR<=2014, cluster(HHIDPN)	
			gen DieNextSample=e(sample)
_eststo Death2: reg DieNext       ev1-ev10 i.Age  i.BIRTHYR i.Educ i.DEGREE EA3Score if YEAR>=YearGenotyped & Age>=50 & Age<=90 & Pers_EverInRetSample==1 & Male==1 & YEAR<=2014, cluster(HHIDPN)			
_eststo Death3: reg DieNext       ev1-ev10 i.Age  i.BIRTHYR i.Educ i.DEGREE EA3Score if YEAR>=YearGenotyped & Age>=50 & Age<=90 & Pers_EverInRetSample==1 & Male==0 & YEAR<=2014, cluster(HHIDPN)			


_eststo DeathAlt1: reg DieNextAltDef       ev1-ev10 i.Age i.BIRTHYR i.Educ i.DEGREE EA3Score if YEAR>=YearGenotyped & Age>=50 & Age<=90 & Pers_EverInRetSample==1, cluster(HHIDPN)			
			gen DieNextAltSample=e(sample)
_eststo DeathAlt2: reg DieNextAltDef       ev1-ev10 i.Age i.BIRTHYR  i.Educ i.DEGREE EA3Score if YEAR>=YearGenotyped & Age>=50 & Age<=90 & Pers_EverInRetSample==1 & Male==1 & YEAR<=2012, cluster(HHIDPN)			
_eststo DeathAlt3: reg DieNextAltDef       ev1-ev10 i.Age i.BIRTHYR  i.Educ i.DEGREE EA3Score if YEAR>=YearGenotyped & Age>=50 & Age<=90 & Pers_EverInRetSample==1 & Male==0 & YEAR<=2014, cluster(HHIDPN)			


			
			
estout Death1 Death2 Death3 using "$TableDir\GENX_T7_Mortality.tex",  ///
replace ///
cells(b(fmt(%9.3fc) star) se(par fmt(%9.3fc)))   ///
keep (EA3Score   )	  ///	
order (EA3Score )	  ///				
eqlabels(none)  ///
style(tex) starlevels(* 0.1 ** 0.05 *** 0.01) stats(N r2, fmt(%9.0f %9.3f) label(Obs. "\$R^{2}$"))

estout DeathAlt1 DeathAlt2 DeathAlt3 using "$TableDir\GENX_T7_Mortality.tex",  ///
append ///
cells(b(fmt(%9.3fc) star) se(par fmt(%9.3fc)))   ///
keep (EA3Score   )	  ///	
order (EA3Score )	  ///				
eqlabels(none)  ///
style(tex) starlevels(* 0.1 ** 0.05 *** 0.01) stats(N r2, fmt(%9.0f %9.3f) label(Obs. "\$R^{2}$"))



mat GENX_MortSumStats=J(2,12,99999)

		mat rownames GENX_MortSumStats = DieNext DieNextAlt

		mat colnames GENX_MortSumStats = Mean StdDev N      Mean StdDev N   ///
		                                 Mean StdDev N      Mean StdDev N	
	
	
	cap gen AllFS=1
	
	local FS=0
	
	foreach FVar in AllFS MF FOnly MOnly {
	
		sum DieNext if DieNextSample==1 & `FVar'==1
		
			mat GENX_MortSumStats[1,3*`FS'+1]=r(mean)
			mat GENX_MortSumStats[1,3*`FS'+2]=r(sd)	
			mat GENX_MortSumStats[1,3*`FS'+3]=r(N)
			
		sum DieNextAltDef if DieNextAltSample==1 & `FVar'==1
		
			mat GENX_MortSumStats[2,3*`FS'+1]=r(mean)
			mat GENX_MortSumStats[2,3*`FS'+2]=r(sd)	
			mat GENX_MortSumStats[2,3*`FS'+3]=r(N)			
			
			
			local FS=`FS'+1
	}
	
	
estout matrix(GENX_MortSumStats) using "$TableDir\GENX_T7_Mortality.tex", append



/* Merge in Expectations Data */

clear all
set matsize 2000, perm

use "$CleanData\GenesWealth_CleanPanel.dta"

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

forvalues yr=1992(2)2012{
	merge m:1 HHID PN SUBHH using "$CleanData\SurvivalExpectations`yr'.dta", gen(ExpectMerge`yr')

}

gen ProbLive75More=.

forvalues yr=1992(2)2012{
	replace ProbLive75More=ProbLive75More_`yr' if YEAR==`yr'

}

replace ProbLive75More=. if ProbLive75More>100


* Create some local variables 
local CS_PCVars     "M_ev* F_ev* M_PC_Miss* F_PC_Miss*"
local CS_Demo       "i.M_Age##i.MOnly i.F_Age##i.FOnly i.M_BIRTHYR##i.MOnly i.F_BIRTHYR##i.FOnly  Male i.FOnly i.MOnly i.YEAR"
local CS_EducFull   "i.M_Educ##i.F_Educ i.M_DEGREE##i.F_DEGREE i.M_Educ##i.MOnly i.F_Educ##i.FOnly i.M_DEGREE##i.MOnly i.F_DEGREE##i.FOnly"
local CS_Basic      " `CS_PCVars' `CS_Demo'  `CS_EducFull' "

_eststo PL75:    reg ProbLive75More `CS_Basic' EA3Score    if HHSample==1 & Age>=50 & Age<=65, cluster(HHID)
	gen InExp75Samp=e(sample)
_eststo PL75Men: reg ProbLive75More `CS_Basic' EA3Score    if HHSample==1 & Male==1 & Age>=50 & Age<=65, cluster(HHID) 
_eststo PL75Wom: reg ProbLive75More `CS_Basic' EA3Score    if HHSample==1 & Male==0 & Age>=50 & Age<=65, cluster(HHID) 


_eststo PL75Avg:    reg ProbLive75More `CS_Basic' EA3ScoreAvg    if HHSample==1 & Age>=50 & Age<=65, cluster(HHID) 
_eststo PL75MenAvg: reg ProbLive75More `CS_Basic' EA3ScoreAvg    if HHSample==1 & Male==1 & Age>=50 & Age<=65, cluster(HHID) 
_eststo PL75WomAvg: reg ProbLive75More `CS_Basic' EA3ScoreAvg    if HHSample==1 & Male==0 & Age>=50 & Age<=65, cluster(HHID) 


gen Exp75_AboveMed=.
		
forvalues AG=50(1)65{
sum ProbLive75More if InExp75Samp==1 & Age==`AG', det
replace Exp75_AboveMed=0 if InExp75Samp==1 & Age==`AG' & ProbLive75More<r(p50)
replace Exp75_AboveMed=1 if InExp75Samp==1 & Age==`AG' & ProbLive75More>=r(p50)
}		

bys HHID SUBHH: egen FracExp75AboveMedHH=mean(Exp75_AboveMed)
bys HHID PN   : egen FracExp75AboveMedInd=mean(Exp75_AboveMed)


estout PL75 PL75Men PL75Wom using  "$TableDir\GENX_T7_Mortality.tex",  ///
append ///
cells(b(fmt(%9.3fc) star) se(par fmt(%9.3fc)))   ///
keep (EA3Score   )	  ///	
order (EA3Score )	  ///				
eqlabels(none)  ///
style(tex) starlevels(* 0.1 ** 0.05 *** 0.01) stats(N r2, fmt(%9.0f %9.3f) label(Obs. "\$R^{2}$"))

estout PL75Avg PL75MenAvg PL75WomAvg using "$TableDir\GENX_T7_Mortality.tex",  ///
append ///
cells(b(fmt(%9.3fc) star) se(par fmt(%9.3fc)))   ///
keep (EA3ScoreAvg   )	  ///	
order (EA3ScoreAvg )	  ///				
eqlabels(none)  ///
style(tex) starlevels(* 0.1 ** 0.05 *** 0.01) stats(N r2, fmt(%9.0f %9.3f) label(Obs. "\$R^{2}$"))	

mat PL75Stats=J(1,1,9999)
sum ProbLive75More if InExp75Samp==1, det
mat PL75Stats[1,1]=r(mean)
estout matrix(PL75Stats) using "$TableDir\GENX_T7_Mortality.tex", append



