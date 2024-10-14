
* 1960s

clear all

use "$CPSDecades\CPS_1960s\CPS_1960s.dta", replace
gen Year=(year-1)
merge m:1 Year using "$ExternalDir\SSATopCodeLevels.dta", gen(TopCodeMerge)
keep if TopCodeMerge==3

	gen    IncWageClean=incwage 
		   replace IncWageClean=. if incwage>=9999998
		   
	gen    IncBusClean=incbus
		   replace IncBusClean=.  if  incbus>=9999998

	gen    IncFarmClean=incfarm
		   replace IncFarmClean=. if incfarm>=9999998		   
		   
	egen EarnedIncome=rowtotal(IncWageClean IncBusClean IncFarmClean), missing
	

forvalues yr=1962(1)1969{



	sum EarnedIncome if year==`yr' & EarnedIncome~=. & wtsupp>0 & EarnedIncome>=SSATopCode [fw=round(wtsupp)], det
	gen TopCodeMean`yr'=r(mean)
	gen TopCodeMedian`yr'=r(p50)
	
	sum SSATopCode if year==`yr', det
	gen SSATopCode`yr'=r(p50)
	
}


gen ID=_n
keep if ID==1
drop SSATopCode
keep TopCodeM* *TopCode* ID
reshape long TopCodeMean TopCodeMedian SSATopCode, i(ID) j(Year)

keep Year TopCodeMean TopCodeMedian SSATopCode

save "$CleanData\TopCodeStats1960sComplete.dta", replace

clear all




* 1970s

clear all

use "$CPSDecades\CPS_1970s\CPS_1970s.dta", replace

gen Year=(year-1)
merge m:1 Year using "$ExternalDir\SSATopCodeLevels.dta", gen(TopCodeMerge)
keep if TopCodeMerge==3

	gen    IncWageClean=incwage 
		   replace IncWageClean=. if incwage>=9999998
		   
	gen    IncBusClean=incbus
		   replace IncBusClean=.  if  incbus>=9999998

	gen    IncFarmClean=incfarm
		   replace IncFarmClean=. if incfarm>=9999998		   
		   
	egen EarnedIncome=rowtotal(IncWageClean IncBusClean IncFarmClean), missing
	

forvalues yr=1970(1)1979{



	sum EarnedIncome if year==`yr' & EarnedIncome~=. & wtsupp>0 & EarnedIncome>=SSATopCode [fw=round(wtsupp)], det
	gen TopCodeMean`yr'=r(mean)
	gen TopCodeMedian`yr'=r(p50)
	
	sum SSATopCode if year==`yr', det
	gen SSATopCode`yr'=r(p50)
	
}


gen ID=_n
keep if ID==1
drop SSATopCode
keep TopCodeM* *TopCode* ID
reshape long TopCodeMean TopCodeMedian SSATopCode, i(ID) j(Year)

keep Year TopCodeMean TopCodeMedian SSATopCode

save "$CleanData\TopCodeStats1970sComplete.dta", replace

clear all




* 1980s

clear all

use "$CPSDecades\CPS_1980s\CPS_1980s.dta", replace

gen Year=(year-1)
merge m:1 Year using "$ExternalDir\SSATopCodeLevels.dta", gen(TopCodeMerge)
keep if TopCodeMerge==3

	gen    IncWageClean=incwage 
		   replace IncWageClean=. if incwage>=9999998
		   
	gen    IncBusClean=incbus
		   replace IncBusClean=.  if  incbus>=9999998

	gen    IncFarmClean=incfarm
		   replace IncFarmClean=. if incfarm>=9999998		   
		   
	egen EarnedIncome=rowtotal(IncWageClean IncBusClean IncFarmClean), missing
	

forvalues yr=1980(1)1989{



	sum EarnedIncome if year==`yr' & EarnedIncome~=. & wtsupp>0 & EarnedIncome>=SSATopCode [fw=round(wtsupp)], det
	gen TopCodeMean`yr'=r(mean)
	gen TopCodeMedian`yr'=r(p50)
	
	sum SSATopCode if year==`yr', det
	gen SSATopCode`yr'=r(p50)
	
}


gen ID=_n
keep if ID==1
drop SSATopCode
keep TopCodeM* *TopCode* ID
reshape long TopCodeMean TopCodeMedian SSATopCode, i(ID) j(Year)

keep Year TopCodeMean TopCodeMedian SSATopCode

save "$CleanData\TopCodeStats1980sComplete.dta", replace

clear all




* 1990s

clear all

use "$CPSDecades\CPS_1990s\CPS_1990s.dta", replace

gen Year=(year-1)
merge m:1 Year using "$ExternalDir\SSATopCodeLevels.dta", gen(TopCodeMerge)
keep if TopCodeMerge==3

	gen    IncWageClean=incwage 
		   replace IncWageClean=. if incwage>=9999998
		   
	gen    IncBusClean=incbus
		   replace IncBusClean=.  if  incbus>=9999998

	gen    IncFarmClean=incfarm
		   replace IncFarmClean=. if incfarm>=9999998		   
		   
	egen EarnedIncome=rowtotal(IncWageClean IncBusClean IncFarmClean), missing
	

forvalues yr=1990(1)1999{



	sum EarnedIncome if year==`yr' & EarnedIncome~=. & wtsupp>0 & EarnedIncome>=SSATopCode [fw=round(wtsupp)], det
	gen TopCodeMean`yr'=r(mean)
	gen TopCodeMedian`yr'=r(p50)
	
	sum SSATopCode if year==`yr', det
	gen SSATopCode`yr'=r(p50)
	
}


gen ID=_n
keep if ID==1
drop SSATopCode
keep TopCodeM* *TopCode* ID
reshape long TopCodeMean TopCodeMedian SSATopCode, i(ID) j(Year)

keep Year TopCodeMean TopCodeMedian SSATopCode

save "$CleanData\TopCodeStats1990sComplete.dta", replace

clear all


* 2000s

clear all

use "$CPSDecades\CPS_2000s\CPS_2000s.dta", replace

gen Year=(year-1)
merge m:1 Year using "$ExternalDir\SSATopCodeLevels.dta", gen(TopCodeMerge)
keep if TopCodeMerge==3

	gen    IncWageClean=incwage 
		   replace IncWageClean=. if incwage>=9999998
		   
	gen    IncBusClean=incbus
		   replace IncBusClean=.  if  incbus>=9999998

	gen    IncFarmClean=incfarm
		   replace IncFarmClean=. if incfarm>=9999998		   
		   
	egen EarnedIncome=rowtotal(IncWageClean IncBusClean IncFarmClean), missing
	

forvalues yr=2000(1)2009{



	sum EarnedIncome if year==`yr' & EarnedIncome~=. & wtsupp>0 & EarnedIncome>=SSATopCode [fw=round(wtsupp)], det
	gen TopCodeMean`yr'=r(mean)
	gen TopCodeMedian`yr'=r(p50)
	
	sum SSATopCode if year==`yr', det
	gen SSATopCode`yr'=r(p50)
	
}


gen ID=_n
keep if ID==1
drop SSATopCode
keep TopCodeM* *TopCode* ID
reshape long TopCodeMean TopCodeMedian SSATopCode, i(ID) j(Year)

keep Year TopCodeMean TopCodeMedian SSATopCode

save "$CleanData\TopCodeStats2000sComplete.dta", replace

clear all



* 2010s

clear all
use $CPSDecades\CPS_2010s\CPS_2010s.dta, replace

gen Year=(year-1)
merge m:1 Year using "$ExternalDir\SSATopCodeLevels.dta", gen(TopCodeMerge)
keep if TopCodeMerge==3

	gen    IncWageClean=incwage 
		   replace IncWageClean=. if incwage>=9999998
		   
	gen    IncBusClean=incbus
		   replace IncBusClean=.  if  incbus>=9999998

	gen    IncFarmClean=incfarm
		   replace IncFarmClean=. if incfarm>=9999998		   
		   
	egen EarnedIncome=rowtotal(IncWageClean IncBusClean IncFarmClean), missing
	

forvalues yr=2010(1)2015{



	sum EarnedIncome if year==`yr' & EarnedIncome~=. & wtsupp>0 & EarnedIncome>=SSATopCode [fw=round(wtsupp)], det
	gen TopCodeMean`yr'=r(mean)
	gen TopCodeMedian`yr'=r(p50)
	
	sum SSATopCode if year==`yr', det
	gen SSATopCode`yr'=r(p50)
	
}


gen ID=_n
keep if ID==1
drop SSATopCode
keep TopCodeM* *TopCode* ID
reshape long TopCodeMean TopCodeMedian SSATopCode, i(ID) j(Year)

keep Year TopCodeMean TopCodeMedian SSATopCode

save "$CleanData\TopCodeStats2010sComplete.dta", replace

clear all


use "$CleanData\TopCodeStats1960sComplete.dta"
append using "$CleanData\TopCodeStats1970sComplete.dta"
append using "$CleanData\TopCodeStats1980sComplete.dta"
append using "$CleanData\TopCodeStats1990sComplete.dta"
append using "$CleanData\TopCodeStats2000sComplete.dta"
append using "$CleanData\TopCodeStats2010sComplete.dta"

* Correct for Year reflecting PREVIOUS YEAR Outcomes:

replace Year=(Year-1)

save "$CleanData\TopCodeStatsComplete.dta", replace




