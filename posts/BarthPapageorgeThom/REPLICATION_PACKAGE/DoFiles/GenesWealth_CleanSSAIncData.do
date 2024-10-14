clear all

* First, load the deceased spouse earnings file.  There are not many individuals
* listed here (1,956).  We are just going to keep the earnings variables
* and the hhidpn identifier and save this so we can merge it with the main
* individual earnings file.

use "$SSAIncDirSpouse\xdspsumern.dta"

rename HHIDPN hhidpn
rename HHID   hhid
rename PN      pn
rename LASTYR  lastyr
rename SOURCE source
rename STUDY  study

keep hhidpn hhid pn lastyr source ERN*


forvalues yr=1951(1)2013{
	rename ERN`yr' DSP_ERN`yr'
}


keep hhidpn DSP*

save "$CleanDataEnclave\DeceasedSpouseData.dta", replace 
clear all




****************************************************************************
* Load the Social Security Administration Cross-Wave Summary Earnings File
****************************************************************************

* Keep identifying variables as well as Earnings variables (ERN*), agricultural
* income variables (A*), and self-employment flags (S*)

clear all

use "$SSAIncDirResp\xyrsumern.dta"

keep hhidpn hhid pn lastyr source ERN* A* S*

* Merge with the Deceased spouse file:
merge 1:1 hhidpn using "$CleanDataEnclave\DeceasedSpouseData.dta", gen(DSP_Merge)
	
	* Drop a very small number of individuals (42) in the Decreased spouse file that are not
	* matched with the individual earnings panel:
	drop if DSP_Merge==2

reshape long ERN A S DSP_ERN, i(hhidpn) j(Year)

rename hhid HHID
rename pn   PN

* Merge with the CPI data (2010 base)
merge m:1 Year using "$ExtDataEnclave\CPI_U_1913_2016_2k10.dta", gen(YearMerge)
	* Drop observations that correspond to years that aren't in data:
	drop if YearMerge==2

	
******************************************************************************
* Calculate the Top Code Values for Each Year, and generate Indicator 
* Variables for whether an individual earnings observation is equal to the
* top code, or if the deceased spouse sum is greater than or equal to the
* top code.  Since there could be multiple deceased spouses, it is possible
* that individuals could have sums for DSP_ERN that exceed that annual top 
* code amount.
*******************************************************************************

* Fist, get an indicator for missing values
*   .n indicates an amount between $0.01 and $49.99
*   .m indicates a year for which earnings data are not available (after last year in SSA data set)
*   .a is an unknown code (most likely a typo), we set to missing.

	replace ERN=0      if ERN==.n
	replace DSP_ERN=0  if DSP_ERN==.n

	replace ERN=.       if ERN==.m
	replace DSP_ERN=.   if DSP_ERN==.m

	replace ERN=.       if ERN==.a
	replace DSP_ERN=.   if DSP_ERN==.a
	
	gen MissERN=(ERN==.)
	gen MissDSP_ERN=(DSP_ERN==.)
     

		 
gen TopCode=.
gen TopCodeDSP=.

forvalues yr=1951(1)2013{

	sum ERN if Year==`yr'
	gen TempMax=r(max)
	
	gen SSAMax_`yr'=TempMax
	
	replace TopCode=0 if Year==`yr' & MissERN==0
	replace TopCode=1 if Year==`yr' & ERN==TempMax & MissERN==0
	
	
	replace TopCodeDSP=0 if Year==`yr' & MissDSP_ERN==0
	replace TopCodeDSP=1 if Year==`yr' & DSP_ERN>=TempMax & MissDSP_ERN==0
	
	drop TempMax

}


* Get the last year of non-missing earnings data.  This is just lastyr
gen LastNonMissEarnYear=lastyr

* Get the last year of strictly positive earnings data:
gen Temp=.
replace Temp=Year if MissERN==0 & ERN>0
bys hhidpn: egen LastPositiveEarnYear=max(Temp)
drop Temp

* Get the last year and first year of positive earnings:
gen Temp=.
replace Temp=Year if MissERN==0 & ERN>0
bys hhidpn: egen FirstEarnYear=min(Temp)
bys hhidpn: egen LastEarnYear=max(Temp)
drop Temp


bys HHID: egen HH_FirstEarnYear=min(FirstEarnYear)
bys HHID: egen HH_LastEarnYear=max(LastEarnYear)

* Get an Indicator for any agricultural income:
gen SSA_AnyAgInc=0
replace SSA_AnyAgInc=1 if A>0 & A<=9 & Year<=1977 
replace SSA_AnyAgInc=1 if A==1       & Year>1977

bys HHID PN: egen SSA_YearsAgInc=total(SSA_AnyAgInc)
bys HHID PN: egen SSA_YearsAgIncHH=total(SSA_AnyAgInc)

* Get an Indicator for Any Self-Employment Income

gen SSA_AnySE=0
replace SSA_AnySE=1 if S>0 & S<=4 & Year<=1977
replace SSA_AnySE=1 if S==1       & Year>1977

bys HHID PN: egen SSA_YearsSEInc=total(SSA_AnySE)
bys HHID: egen SSA_YearsSEIncHH=total(SSA_AnySE)


* Merge in data on the SSA Top Codes:
* This indicates the following in each year, 1962-2013
*      TopCodeMedian TopCodeMean
merge m:1 Year using "$ExtDataEnclave\TopCodeStatsComplete.dta", gen(TopCodeMerge)
drop if TopCodeMerge==2

* Generate ERNAdj, which will replace Top coded amounts with TopCodeMean:
gen ERNAdj=ERN
replace ERNAdj=TopCodeMean if TopCode==1 & TopCodeMean~=.
* Generate DSP_ERNAdj, which will replace Top coded amounts with TopCodeMean for 
* Deceased Spouse earnings: 
gen DSP_ERNAdj=DSP_ERN
replace DSP_ERNAdj=TopCodeMean if TopCodeDSP==1 & TopCodeMean~=.


* Generate TotERN as the sum of ERN and DSP_ERN, generate TotERNAdj as 
* the sum of ERNAdj and TotERNAdj:

gen TotERN=ERN
replace TotERN=ERN+DSP_ERN if ERN~=. & DSP_ERN~=.
replace TotERN=DSP_ERN     if ERN==. & DSP_ERN~=.

gen TotERNAdj=ERNAdj
replace TotERNAdj=ERNAdj+DSP_ERNAdj if ERNAdj~=. & DSP_ERNAdj~=.
replace TotERNAdj=DSP_ERNAdj        if ERNAdj==. & DSP_ERNAdj~=.


* Get Real Earnings Amounts based on CPI (2010 base):
gen RealEarn      =ERN/CPI
gen RealEarnAdj   =ERNAdj/CPI
gen RealTotEarn   =TotERN/CPI
gen RealTotEarnAdj=TotERNAdj/CPI


save "$CleanDataEnclave\SSAIncPanelFull.dta", replace 


* Drop if Year>2010 (last wealth year):
drop if Year>2010



* Merge with Tracker 14 File to Get BIRTHYR, and immediately drop those who
* are in the Tracker file but not in the SSA Earnings file:  
merge m:1 HHID PN using  "$EnclaveTracker\TRK2016TR_R.dta", gen(TRK16Merge)
drop if TRK16Merge==2

* generate Age:
gen Age=Year-BIRTHYR


***************************************************************
* Now, generate a series of sums by person and within household:
*  1) Total Personal Income (summing over all years)
*  2) Total Personal Income (adjusting for top coding)
*  3) Total Person Income with Deceased Spouse 
*  4) Total Person Income with Deceased Spouse (adjusting for top coding)

bys HHID PN: egen TotRealEarnPers      =total(RealEarn), missing
bys HHID PN: egen TotRealEarnAdjPers   =total(RealEarnAdj), missing
bys HHID PN: egen TotRealTotEarnPers   =total(RealTotEarn), missing
bys HHID PN: egen TotRealTotEarnAdjPers=total(RealTotEarnAdj), missing
bys HHID PN: egen NumTopCodePers       =total(TopCode), missing

* Now, get the same measures, but sum over all individuals in the HHID:

bys HHID: egen TotRealEarnHH      =total(RealEarn), missing
bys HHID: egen TotRealEarnAdjHH   =total(RealEarnAdj), missing
bys HHID: egen TotRealTotEarnHH   =total(RealTotEarn), missing
bys HHID: egen TotRealTotEarnAdjHH=total(RealTotEarnAdj), missing
bys HHID: egen NumTopCodeHH       =total(TopCode), missing

***********************************************************
gen Temp=0
replace Temp=1 if RealEarnAdj~=.
bys HHID PN: egen NumObsTREAdjPers=total(Temp)
drop Temp

gen Temp=0
replace Temp=1 if RealEarnAdj~=.
bys HHID: egen NumObsTREAdjHH=total(Temp)
drop Temp

gen Temp=0
replace Temp=1 if RealTotEarnAdj~=.
bys HHID: egen NumObsTRETAdjHH=total(Temp)
drop Temp
************************************************************

************************************************************
* Get average for top 35 years in household

* First, get total RealTotEarnAdj within a Hosuehold year Combo:
bys HHID Year: egen TempEarnHHYear=total(RealTotEarnAdj), missing
bys HHID Year: gen TempCounter=_n
replace TempEarnHHYear=. if TempCounter~=1

gen NegTempEarnHHYear=-TempEarnHHYear
bys HHID: egen IncRank=rank(NegTempEarnHHYear), unique 

gen Temp=.
replace Temp=TempEarnHHYear if IncRank>=1 & IncRank<=35
bys HHID: egen AvgEarnTop35=mean(Temp)
drop Temp



keep HHID PN TotRealEarnPers TotRealEarnHH TotRealEarnAdjPers TotRealEarnAdjHH TotRealEarnAdjHH TotRealTotEarnAdjHH NumObs*  NumTopCodePers NumTopCodeHH SSA_YearsAgIncHH SSA_YearsSEIncHH AvgEarnTop35
bys HHID PN: gen Counter=_n
keep if Counter==1

drop Counter

save "$CleanDataEnclave\GENX_IncomeTots.dta", replace





clear all
	