clear all

/* Read in life tables data */
foreach sheet in "Birth_Yr_1900" "Birth_Yr_1910" "Birth_Yr_1920" "Birth_Yr_1930" "Birth_Yr_1940" "Birth_Yr_1950" "Birth_Yr_1960" "Birth_Yr_1970" "Birth_Yr_1980" {
  clear
  import excel using "$LifeTablesData/LifeTables.xlsx", sheet("`sheet'") firstrow
  drop H
  drop if mx==.
  gen birthyear=substr("`sheet'",10,4)
  order birthyear
  save "$LifeTablesData/LifeTables_`sheet'.dta", replace
}

/* Combine life tables data */
clear
use          "$LifeTablesData/LifeTables_Birth_Yr_1900.dta"
append using "$LifeTablesData/LifeTables_Birth_Yr_1910.dta"
append using "$LifeTablesData/LifeTables_Birth_Yr_1920.dta"
append using "$LifeTablesData/LifeTables_Birth_Yr_1930.dta"
append using "$LifeTablesData/LifeTables_Birth_Yr_1940.dta"
append using "$LifeTablesData/LifeTables_Birth_Yr_1950.dta"
append using "$LifeTablesData/LifeTables_Birth_Yr_1960.dta"
append using "$LifeTablesData/LifeTables_Birth_Yr_1970.dta"
append using "$LifeTablesData/LifeTables_Birth_Yr_1980.dta"

/* lx  = the number of persons surviving to exact age x, (or the number of persons reaching exact age x during each year in the stationary population)
   dx  = the number of deaths between exact ages x and x+1, (or the number of deaths at age last birthday each year in the stationary population)
   Lx  = the number of person-years lived between exact ages x and x+1, (or the number of persons alive at age last birthday x at any time in the stationary population)
         We assume a uniform distribution of deaths for ages greater than 0.
   Tx  = the number of person-years lived after exact age x, (or the number of persons alive at age last birthday x or older at any time in the stationary population)
   ex  = the average number of years of life remaining at exact age x
   ymx = the central death rate for the population that is between exact ages x and x+y
   yfx = separation factor; the average number of years not lived between exact ages x and x+y for those who die between exact ages x and +y */

/* Rename variables */  
rename mx  Age
rename mqx MaleProbDeath
rename mlx MaleTotalLives
rename mdx MaleTotalDeaths
rename mLx MaleTotPersYrsLivedBet
rename mTx MaleTotPersYrsLivedAft
rename mex MaleAvgYrsRemain

rename fx  FemaleAge
rename fqx FemaleProbDeath
rename flx FemaleTotalLives
rename fdx FemaleTotalDeaths
rename fLx FemaleTotPersYrsLivedBet
rename fTx FemaleTotPersYrsLivedAft
rename fex FemaleAvgYrsRemain
rename birthyear cohort_yr
destring cohort_yr, replace

/* Keep only relevant variables */
keep cohort_yr Age MaleProbDeath FemaleAge FemaleProbDeath

/* Generate cumulative survival probabilities as sum of log survival probabilities (this is easier than
   doing cumulative products in Stata) */
gen MaleSurvProb                                          =1-MaleProbDeath
gen FemaleSurvProb                                        =1-FemaleProbDeath
gen LogMaleSurvProb                                       =log(MaleSurvProb)
gen LogFemaleSurvProb                                     =log(FemaleSurvProb)
bysort cohort_yr (Age)  : gen CumLogSumMaleSurvProb       =sum(LogMaleSurvProb)
bysort cohort_yr (Age)  : gen CumLogSumFemaleSurvProb     =sum(LogFemaleSurvProb)
gen CumMaleSurvProb                                       =exp(CumLogSumMaleSurvProb)
gen CumFemaleSurvProb                                     =exp(CumLogSumFemaleSurvProb)

/* count_var takes the value 1, 2, 3,... for each observation within a cohort year and age */
bysort cohort_yr (Age)  : gen count_var                   =_n

/* Generate the annual discount factor */
                          gen log_rate                    =log(1.015)
						  
/* Compounded discounted rate of return (logged then exponentiated) */						  
                          gen disc_factor                 =exp(count_var*log_rate)

/* We observe one value (per wave) of retirement income; imagine that value is X. We want the present discounted value
   of X. Imagine three periods, we would then want to calculate PV = X*P_s1/(1+r) +  X*P_s2/(1+r)^2 + X*P_s3/(1+r)^3, 
   where P_s1 is survival probability for one year, P_s2 is probability of surviving two years, etc. We can write this as
   X*[P_s1/(1+r) +  P_s2/(1+r)^2 + P_s3/(1+r)^3] = XC, the next part of the code calculates C. */  
bysort cohort_yr (Age)  : gen MaleAnnSumVal               =sum(CumMaleSurvProb/disc_factor) 
bysort cohort_yr (Age)  : gen FemaleAnnSumVal             =sum(CumFemaleSurvProb/disc_factor)

/* Now, the SSA data starts at age 1, but we want the current age of the respondent to be "age 1". Imagine the example above, and call
   each annual component of C C_1, C_2, etc., so C= C_1 + C_2 + C3... There are 120 years, and imagine and individual aged 50. We want
   C = C_1 + C_2 + ... C_70 for this individual. To get that, we subtract from the full C (C_1 + ... + C_120), the C of an individual 
   aged 50 (C_50 + ... + C120). The remainder is C_1 + ... + C49  */

	sort cohort_yr Age
	bysort cohort_yr: gen LagMaleProbDeath=MaleProbDeath[_n-1]
	bysort cohort_yr: gen LagFemaleProbDeath=FemaleProbDeath[_n-1]   
   
	gen MaleProbSurvFromLast=(1-LagMaleProbDeath)
	gen FemaleProbSurvFromLast=(1-LagFemaleProbDeath)
	
	
	gen MaleAnnVal=.
	gen FemaleAnnVal=.
	
	forvalues CurrentAge=10(1)118{
	
	* Get Prob of Surviving to each age greater than CurrentAge conditional on survival to Current Age
		
		foreach GENDER in Male Female{
		
			gen TempStream=0
			replace TempStream=0 if Age==`CurrentAge'
			
			local CurrentAgeP1=`CurrentAge'+1
			
			forvalues FutureAge=`CurrentAgeP1'(1)119{
			
				*Get the Probability of Survival to each Future Age, conditional
				*on Survival to CurrentAge:
				gen Temp=.
				replace Temp=log(`GENDER'ProbSurvFromLast) if Age>`CurrentAge' & Age<=`FutureAge'
				bys cohort_yr: egen TempLogSum=total(Temp)
				gen TempSurvProb=exp(TempLogSum)
				replace TempStream=(TempSurvProb)*((1.015)^(-(`FutureAge'-`CurrentAge'))) if Age==`FutureAge'

				drop Temp TempLogSum TempSurvProb 
			}
			
			bys cohort_yr: egen TempAnnVal=total(TempStream)
			replace `GENDER'AnnVal=TempAnnVal if Age==`CurrentAge'
			
			drop TempStream TempAnnVal
		
		}
		
	}
	
	* Set it equal to 0 for age 119 (implicitly assuming a 100 percent death probability, so pension has 0 present discounted value)
	replace MaleAnnVal=0   if Age==119
	replace FemaleAnnVal=0 if Age==119
   
   
   
order cohort_yr Age MaleAnnSumVal FemaleAnnSumVal MaleAnnVal FemaleAnnVal

save "$LifeTablesData/LifeTables_All.dta", replace

/* Now run the file to generate birth cohorts and age within each wave */
clear
quietly do "$GENXDoFiles\Build_Resp_Demos.do"
clear

/* Now merge the cohort life tables on the age and cohort variables (the latter are stored separately by wave, see Build_Resp_Demos.do) 
   This will be used to discount the gauranteed retirement income in the Rand_Wealth`year'.do files (note, for each merge, only keep the 
   matches so the .dta file is self-contained) */
foreach year in "1992" "1994" "1996" "1998" "2000" "2002" "2004" "2006" "2008" "2010" "2012" {
clear
use "$LifeTablesData/LifeTables_All.dta"
merge 1:m Age cohort_yr using "$CleanData/Resp_Demos`year'.dta"
keep if _merge==3
destring HHID, gen(numHHID)
destring PN, gen(numPN)
gen double hhidpn=numHHID*1000+numPN
drop if hhidpn==.
drop _merge
save "$CleanData/AnnFactor`year'.dta", replace 
}











