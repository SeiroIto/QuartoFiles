clear all

set matsize 1000
set maxvar 25000, perm


clear all
/* Load HHIDPN Panel - This is just a scaffolding for the rest of the panel.
It is based on the latest Tracker File and just contains the identifiers
(HHID PN SUBHH), YEAR, and a categorical variable indicating whether or 
not the individual is in the sample for that year / wave */
use "$CleanData\HHIDPNPanel.dta"

keep HHID PN YEAR SUBHH InSamp InSampFull

/* Codes for InSampFull 

                    1.  In the sample
                    2.  Belonging to a cohort not interviewed this wave
                    3.  Not yet entered, but belonging to a cohort interviewed in
                             this wave
                    4.  Formally dropped from the sample: HRS-AHEAD overlap never
                             appeared in AHEAD
                    5.  No longer in sample because complete exit or post-exit
                             interview has been obtained
                    6.  Formally dropped from the sample before the wave: Not known
                             to be deceased, termination per request by respondent,
                             spouse, or other living proxy
                    7.  Formally dropped from the sample before the wave: Deceased,
                             unable to find exit proxy
                    8.  Formally dropped from the sample: Other reasons
                    9.  One of 42 cases mistakenly dropped in HRS 2000 */

* Drop observations for HHID-SUBHH-YEAR for years before the individuals were 
* interviewed
gen NotCohortYet=(InSampFull==2)					
bys HHID SUBHH YEAR: egen HHNotCohortYet=min(NotCohortYet)					
drop if HHNotCohortYet==1		

/* Codes for SUBHH 

              0.  Original household
              1.  Sub-household, split off from original
              2.  Sub-household, split off from original
              3.  Deceased respondent household
              4.  Deceased respondent household
              5.  Sub-household, split off a household that already split into
                             a '1' and '2'
              6.  Sub-household, split off a household that already split into
                             a '1' and '2'
              7.  Used when two respondents split and then recombine with each
                             other
              9.  Not in the sample this wave  */

* Drop person-year observations for who were not in the sample in a given wave, 
* or for respondents who were deceased as of that wave: 			  
drop if SUBHH=="9"
drop if SUBHH=="3" | SUBHH=="4"			
					
/* Merge the Main Employment Panel, drop observations in that panel but not in the HHIDPNPanel */
merge 1:1 HHID PN YEAR using "$CleanData\HRSEmpIncPanel.dta", gen(EmpPanelMerge)
drop if EmpPanelMerge==2

/* Merge with Cross Sectional Characteristics (including polygenic scores) */
merge m:1 HHID PN using "$CleanData\GenesWealth_CrossSectionVars.dta", gen(CrossXMerge)	
drop if CrossXMerge==2


* Now, merge with the BLS CPI Index:
gen CPIYear=YEAR

merge m:1 CPIYear using "$CPIDir\CPI_U_1913_2016_2k10.dta", gen(YearMerge)
	* Drop observations that correspond to years that aren't in data:
	drop if YearMerge==2


* Get an indicator for whether a person was the financial respondent:

gen FinRespondent=0
	replace FinRespondent=1 if YEAR==1992 & AFINR==1
	replace FinRespondent=1 if YEAR==1994 & CFINR==1
	replace FinRespondent=1 if YEAR==1996 & EFINR==1
	replace FinRespondent=1 if YEAR==1998 & FFINR==1
	replace FinRespondent=1 if YEAR==2000 & GFINR==1
	replace FinRespondent=1 if YEAR==2002 & HFINR==1
	replace FinRespondent=1 if YEAR==2004 & JFINR==1
	replace FinRespondent=1 if YEAR==2006 & KFINR==1
	replace FinRespondent=1 if YEAR==2008 & LFINR==1
	replace FinRespondent=1 if YEAR==2010 & MFINR==1
	replace FinRespondent=1 if YEAR==2012 & NFINR==1
	
		
* Get COUPLED Status		
gen Coupled=.
		
	replace Coupled=ACOUPLE if YEAR==1992
	replace Coupled=CCOUPLE if YEAR==1994
	replace Coupled=ECOUPLE if YEAR==1996
	replace Coupled=FCOUPLE if YEAR==1998
	replace Coupled=GCOUPLE if YEAR==2000
	replace Coupled=HCOUPLE if YEAR==2002
	replace Coupled=JCOUPLE if YEAR==2004
	replace Coupled=KCOUPLE if YEAR==2006
	replace Coupled=LCOUPLE if YEAR==2008
	replace Coupled=MCOUPLE if YEAR==2010
	replace Coupled=NCOUPLE if YEAR==2012
		
	replace Coupled=0 if Coupled==5			

* Get Spouse / Partner Identifier:		
gen SpousePN=""
		
	replace SpousePN=APPN if YEAR==1992
	replace SpousePN=CPPN if YEAR==1994
	replace SpousePN=EPPN if YEAR==1996
	replace SpousePN=FPPN if YEAR==1998
	replace SpousePN=GPPN if YEAR==2000
	replace SpousePN=HPPN if YEAR==2002
	replace SpousePN=JPPN if YEAR==2004
	replace SpousePN=KPPN if YEAR==2006
	replace SpousePN=LPPN if YEAR==2008
	replace SpousePN=MPPN if YEAR==2010
	replace SpousePN=NPPN if YEAR==2012
			
	
* Get the respondent weight for each year: 		
		
gen RWeight=.
			replace RWeight=AWGTR if YEAR==1992
			replace RWeight=CWGTR if YEAR==1994
			replace RWeight=EWGTR if YEAR==1996
			replace RWeight=FWGTR if YEAR==1998
			replace RWeight=GWGTR if YEAR==2000
			replace RWeight=HWGTR if YEAR==2002
			replace RWeight=JWGTR if YEAR==2004
			replace RWeight=KWGTR if YEAR==2006
			replace RWeight=LWGTR if YEAR==2008
			replace RWeight=MWGTR if YEAR==2010
			replace RWeight=NWGTR if YEAR==2012
			
* Merge with HRS-based Average Annual Income (through 2010):
merge m:1 HHID SUBHH using "$CleanData\HRSEmpIncMeasures.dta", gen(HRSIncMerge)			
drop if HRSIncMerge==2		
		
		
* Merge with Imputed Cognition Panel:
merge 1:1 HHID PN YEAR using "$CleanData\HRS_CleanCogFullPanel.dta", gen(CogMerge)
drop if CogMerge==2
		
			
		
* Now we merge in the Household Wealth Data. There are three sets of files
* that need to be merge:  
*  1) Wealth Data (RANDWealth`YR'.dta) - Merged at the HHID PN level, even 
*     though this contains sub-household level aggregates.
*  2) Pension Data (Pension`YR'.dta") - Merged at the HHID PN level
*  3) Expectations Data (HRSExp`YR'.dta) - Merged at the HHID PN level.

		
		
* Here we initialize variables that will contain the various wealth measures and components
* of wealth (and some flows) contained in the RANDWealth files:	

gen FinWealth_NoImpute=.       /* FinWealth_NoImpute is total financial wealth (excluding pension and 401k-type plans) excluding imputed values*/
gen FinWealth_WithImpute=.	   /* FinWealth_WithImpute is total financial wealth (excluding pension and 401k-type plans) including imputed values*/
gen FinWealth_WithImputeNoH=.  /* FinWealth_WithImputeNoH is total financial wealth (excluding pension and 401k-type plans) including imputed values but excluding housing*/	

gen WealthInStocks_WithImpute=. /* WealthInStocks_WithImpute is total value of stock held directly, in mutual funds, and in IRA accounts */
gen IRAVal=.        /* IRAval is wealth in IRA accounts */
gen StockVal=.      /* Stock val is value of stocks and stock mutual funds */ 
gen CashVal=.       /* CashVal is value of checkings and savings accounts */
gen CDVal=.         /* CDVal is value of certificats of deposit */
gen BondVal=.       /* BondVal is value of bonds and bond mutual funds */
gen OtherAssetVal=. /* OtherAssetVal is value of other assets not described in existing categories */
gen OtherDebtVal=.  /* Other debt is debt not described in existing categories */
gen TrustVal=.      /* TrustVal is value of trusts */
gen TransVal=.      /* TransVal is the value of vehicles and other transportation assets */

gen RecInher_1=.    /* RecInher_1 is an indicator for whether the respondent or spouse has ever received an inheritance or other large lump sum payment */
gen RecInher_2=.    /* RecInher_2 is an indicator for whether the respondent or spouse has ever received a second inheritance or other large lump sum payment */
gen RecInher_3=.    /* RecInher_3 is an indicator for whether the respondent or spouse has ever received a third inheritance or other large lump sum payment */
gen InherAmt_1=.    /* InherAmt_1 is the value of the first inheritance or large lump sum payment */
gen InherAmt_2=.    /* InherAmt_2 is the value of the second inheritance or large lump sum payment */
gen InherAmt_3=.    /* InherAmt_3 is the value of the third inheritance or large lump sum payment */

gen BusVal=.     /* BusVal is value of privately held businesses */
gen BusVal_Imp=.  /* BusVal_Imp is the value of private businesses including imputed values */ 
gen HasBusVal=.  /* HasBusVal is an indicator equal to one if the respondent owns his/her own business */

gen RetIncMarketVal=. /* RetIncMarketVal is the calculated, present discounted value of the sum of social security, defined benefit pension, and annuity income */
gen SSMarketVal=.     /* SSMarketVal is the calculated, present discounted value of social security income */
gen PenMarketVal=.    /* PenMarketVal is the calculated, present discounted value of defined benefit pension income */

gen HouseVal=.    /* HouseVal is gross value of primary residence */
gen MortgVal=.    /* MortgVal is value of the primary residence mortgage */
gen HmLnVal=.     /* HmLnVal is the value of loans taken against the value of the home */
gen HouseVal2=.   /* HouseVal2 is value of secondary residence */
gen SecMortgVal=. /* SecMortgVal is value of mortgage on the secondary residence */ 
gen HasHouse=.    /* HasHouse is an indicator equal to one if the respondent owns their home */
gen HasHouse2=.   /* HasHouse2 is an indicator equal to one if the respondent owns a secondary residence */
gen NetHomeVal=.  /* NetHomeVal is value of primary and secondary residence, minus their respective mortgages*/
gen RealEstateVal=.   /* RealEstateVal is the value of (non-residence) real estate investments */



* Merge with the RANDWealth Files and set values of the panel variables equal to the wave-specific values for each year:
foreach YR in 1992 1994 1996 1998 2000 2002 2004 2006 2008 2010 2012 {
	merge m:1 HHID PN using "$CleanData\RANDWealth`YR'.dta", gen(MergeWealth`YR')
	
	foreach var in FinWealth_NoImpute FinWealth_WithImpute FinWealth_WithImputeNoH ///
	               WealthInStocks_WithImpute IRAVal StockVal CashVal CDVal BondVal ///
				   OtherAssetVal OtherDebtVal TrustVal TransVal                     ///
				   RecInher_1 RecInher_2 RecInher_3 InherAmt_1 InherAmt_2 InherAmt_3  ///
				   BusVal BusVal_Imp  HasBusVal RetIncMarketVal SSMarketVal PenMarketVal ///
				   HouseVal MortgVal  HmLnVal   ///
				   HouseVal2 SecMortgVal  HasHouse HasHouse2 NetHomeVal  RealEstateVal {
		

			cap replace `var'=`var'_`YR' if YEAR==`YR'
		}
		
}


* Here we initialize variables that will contain the various measured
*  contained in the Pension files:	

gen HasDB=.         /* HasDB is an indicator variable equal to one if the respondent has a defined benefit pension plan */
gen HasDC=.         /* HasDC is an indicator variable equal to one if the respondent has a defined contribution pension plan */
gen TotAllPenAmt=.  /* TotAllPenAmt is the value of all retirement accounts across all current and previous employers that were not rolled over into an IRA or converted to an annuity */
gen PlanStockDoll=. /* PlanStockDoll is the total dollar amount of stock investments in non-IRA retirement accounts */
gen PrevEmpPens=.   /* PrevEmpPens is an indicator equal to one if the respondent has a pension account at a previous employer */

foreach YR in 1992 1994 1996 1998 2000 2002 2004 2006 2008 2010 {
	merge m:1 HHID PN using "$CleanData\Pension`YR'.dta", gen(PensionMerge`YR')
	
	foreach var in HasDB HasDC TotAllPenAmt PlanStockDoll PrevEmpPens {
		replace `var'=`var'_`YR' if YEAR==`YR'
	}
}



* Initialize the variables in the Expectations Exp`YR' files:


gen ProbMarketUp=.   /* ProbMarketUp is the probability the stock market goes up in the following year */
gen ProbUSEconDep=.  /* ProbUSEconDep is the probability of a major depression in next 10 years */
gen ProbDDInf=.      /* ProbDDInf is probability the U.S. will experience double digit inflation sometime in next 10 years */
gen FollowMarket=.   /* FollowMarket is a variable describing how closely the respondent follows the stock market: 1=Very closely, 2=Somewhat closely, 3=Not at all, 8=DK, 9=RF */
gen FinPlanCat=.     /* FinPlanCat is length of financial planning horizon: 1=next few months, 2=next year, 3=next few years, 4=next 5-10 years, 5=longer than 10 years, 8=DK, 9=RF */
gen IncRAbin=.       /* IncRAbin is the income risk-aversion bin the respondent ends up in (values of 1-6) */
gen InherRAbin=.     /* InherRAbin is the inheritance risk-aversion bin the respondent ends up in (values of 1-6) */
gen BusRAbin=.       /* BusRAbin is the business risk-aversion bin the respondent ends up in (values of 1-6) */


* First, merge the files:
foreach YR in 1992 1994 1996 1998 2000 2002 2004 2006 2008 2010 2012 {
	merge m:1 HHID PN using "$CleanData\HRSExp`YR'.dta", gen(MergeExpectations`YR')
}


* Now, the loops below replace the panel variables with the wave-specific values, 
* and we have separate loops for each variable because they each asked in different
* sets of years:

foreach YR in  1994 1996 1998 2000 2002 2004 2006 2008{
	foreach var in ProbUSEconDep   {
		replace `var'=`var'_`YR' if YEAR==`YR'
	}
	
}

foreach YR in             2002 2004 2006 2008 2010 2012 {
	
	foreach var in ProbMarketUp   {
		replace `var'=`var'_`YR' if YEAR==`YR'
	}	
}


foreach YR in             1994 1996 1998 2000 {

		replace ProbDDInf=ProbDoubleDigitInf_`YR' if YEAR==`YR'

}

foreach YR in   2004 2006 2008 2010 2012 {
	
	foreach var in  FollowMarket {
		replace `var'=`var'_`YR' if YEAR==`YR'
	}
	
}



foreach YR in  1992 1998 2000 2002 2004 2006 2012 {
	
	replace FinPlanCat=FinPlanCat_`YR' if YEAR==`YR'
	
}


foreach YR in 1998 2000 2002 2004 2006 {

	replace IncRAbin=IncRAbin_`YR' if YEAR==`YR'
	
	if ((`YR'==2002) | (`YR'==2006)) {
		replace InherRAbin=InherRAbin_`YR' if YEAR==`YR'
		replace BusRAbin=BusRAbin_`YR'     if YEAR==`YR'
	}
	
} 


* Merge with the Off-the-Shelf RAND total wealth measure (requires defining a new identifier)

gen HHIDPN=HHID+PN
destring HHIDPN, gen(HHIDPNNum)

merge 1:1 HHIDPNNum YEAR using "$CleanData\RANDTotWealthPanel.dta", gen(RANDPreMadeWealthMerge)

		
		

	   *************************************************************************
	   *  Household Structure in Basic HH Sample
	   *************************************************************************
		
		* Drop if InSamp==. This gets rid of observations that were not in the
		* HHID PN Panel, but were in data sets that we merged in.
		drop if InSamp==.
		
		* First get a variable that counts off observations for a particular 
		* HHID-SUBHH household.  This will allow us to calculate some
		* time-invariant statistics for the cross-section of all HHID-SUBHH's
		* that we observe by restricting to Counter==1:
		
		* HHIDPNCounter: Person-Year Observations
		* HHIDSUBHHCounter: HHID-SUBHH-Year Observations
		* HHIDSUBHHPersCounter: Person-Year Observations within a Household
		
		sort HHID PN YEAR
		bys  HHID PN:         gen HHIDPNCounter=_n
		
		sort HHID SUBHH YEAR PN
		bys  HHID SUBHH:      gen HHIDSUBHHCounter=_n
	    
		sort HHID SUBHH PN YEAR
		bys  HHID SUBHH PN:   gen HHIDSUBHHPersCounter=_n
		
		sort HHID SUBHH YEAR PN
		bys  HHID SUBHH YEAR: gen HHIDSUBHHYearCounter=_n
		
		tab HHIDSUBHHYearCounter
		* Note that HHIDSUBHHPersCounter counts off each person-year that
		* an individual spends in a different SUBHH.  So this takes a value
		* of 1 just once for each time an individual appears in a household.  
		* Totalling the "ones" for a person gives the number of distinct 
		* SUBHH to which this person has belonged.  Totalling the "ones"
		* over all observations for an HHID-SUBHH gives the number of unique
		* persons observed in the Household.  We will be particularly interested
		* in this total (NumUniq_HHIDSUBHH), since we will be restricting to 
		* simple family structures with either 1 or 2 respondents:
		gen Temp=0
		replace Temp=1 if HHIDSUBHHPersCounter==1 
		bys HHID PN: egen Pers_NumHHIDSUBHHEver=total(Temp)
		bys HHID SUBHH: egen NumUniq_HHIDSUBHH=total(Temp)
		drop Temp
		
		bys HHID SUBHH: egen HHIDSUBHH_MaxNumHHIDSUBHH=max(Pers_NumHHIDSUBHHEver)
		
		***************************************************************************
		* ESTABLISH FAMILY STRUCTURE
		***************************************************************************
		* Now, get the number of distinct Males and Females in the Household
		* We will restrict our attention to households with 1 Female 0 Male, 
		* 1 Male, 0 Female, or 1 Male and 1 Female.
		
		* Now, get a count of how many distinct men and women exist inside of
		* an HHID-SUBHH combination: 
		
		gen TempM=(HHIDSUBHHPersCounter==1 & Male==1)
		gen TempF=(HHIDSUBHHPersCounter==1 & Male==0)
		gen TempO=(HHIDSUBHHPersCounter==1 & Male==.)
		
		bys HHID SUBHH: egen NumDistinctMales=total(TempM)
		bys HHID SUBHH: egen NumDistinctFemales=total(TempF)
		bys HHID SUBHH: egen NumDistinctOther=total(TempO)

		drop TempM TempF TempO
		
		
		
		* Get indicator for MOnly, FOnly, MF household: 
		gen MOnly=0
		replace MOnly=1 if NumDistinctMales==1 & NumDistinctFemale==0 & NumDistinctOther==0
		
		gen FOnly=0
		replace FOnly=1 if NumDistinctMales==0 & NumDistinctFemale==1 & NumDistinctOther==0
		
		gen MF=0
		replace MF=1    if NumDistinctMales==1 & NumDistinctFemale==1 & NumDistinctOther==0
		
	
		gen FamStructure=.
		replace FamStructure=1 if MF==1
		replace FamStructure=2 if FOnly==1
		replace FamStructure=3 if MOnly==1		
		
		
		gen Temp=0
		replace Temp=1 if FamStructure==.
		bys HHID PN: egen Pers_EverDiffFS=max(Temp)
		drop Temp
		
		************************************************************************
		******************************************************
		* Keep only those households with FamStructure=1,2,3
		* That is, we only keep those households where we only
		* ever observe 1 man 0 women, 0 men 1 woman, or 1 man
		* and 1 woman. 
		******************************************************
		tab HHIDSUBHHYearCounter
		drop if FamStructure==.
	    tab HHIDSUBHHYearCounter


	/**********************************************************
	* Clean Inheritance Variables  :
	*
	* The variables RecInher_1, RecInher_2, RecInhder_3
	* are tied to survey items that ask about lump sum flows to 
	* the household. These could include insurance payments, 
	* inheritances, etc.  There are up to three such flows 
	* recorded, and the dummies RecInher_1 RecInher_2 and RecInher_3
	* indicate whether flows 1, 2, and 3 were inheritances, respectively.
	* The variables InherAmt_1 InherAmt_2 InherAmt_3 indicate the 
	* dollar amount of these flows (regardless of whether they are 
	* inheritances or not).
	***********************************************************/

	* Loop over inheritance amounts and build a binary indicating whether
	* or not the household received an inheritance in a given year:
	
	gen InherBinary=0
	replace InherBinary=1 if RecInher_1==1 | RecInher_2==1 | RecInher_3==1
	
	* Now, generate a year-specific Inheritance Variable.
	* Initialize it to missing:
	
	forvalues IND=1(1)3{
		gen TempInher`IND'=0
			replace TempInher`IND'=InherAmt_`IND' if RecInher_`IND'==1
			
		gen TempMissInherAmt`IND'=(RecInher_`IND'==1 & InherAmt_`IND'==.)
	}	
		
	egen InherAmt=rowtotal(TempInher1 TempInher2 TempInher3), missing
	egen MissInherAmt=rowmax(TempMissInherAmt1 TempMissInherAmt2 TempMissInherAmt3)
	
	gen RealInherAmt=InherAmt/CPIFactor
	replace RealInherAmt=0 if RealInherAmt==.



	*******************************************************************
	* Inheritance Variables at the Household Level:
	* Now we are going to create SUBHH - level Inheritance variables
	* It is important to note that the Inheritance flows are measured
	* at the household level and merged at the person level - each household
	* member will have the same values for RealInherAmt.  So when we
	* create household-level variables, we will be mindful to not
	* double count inheritance flow.  So that's why we use the "max"
	*******************************************************************
	bys HHID SUBHH YEAR: egen RealInher_SUBHH_YEAR=max(RealInherAmt)
	
	* Create a set of TIME INVARIANT variables that indicate Inheritnace flows
	* to the SUBHH for each year up to 2010:
	
	foreach yr in 1992 1994 1996 1998 2000 2002 2004 2006 2008 2010 {
		gen Temp=0
		replace Temp=RealInher_SUBHH_YEAR if HHIDSUBHHYearCounter==1 & RealInher_SUBHH_YEAR~=. & YEAR==`yr'
		bys HHID SUBHH: egen Inher_SUBHH_`yr'=max(Temp)
		drop Temp
	}
	
	gen CumRealInher_SUBHH=0
	replace CumRealInher_SUBHH=Inher_SUBHH_1992 if YEAR==1992
	replace CumRealInher_SUBHH=Inher_SUBHH_1992+Inher_SUBHH_1994 if YEAR==1994
	replace CumRealInher_SUBHH=Inher_SUBHH_1992+Inher_SUBHH_1994+Inher_SUBHH_1996 if YEAR==1996
	replace CumRealInher_SUBHH=Inher_SUBHH_1992+Inher_SUBHH_1994+Inher_SUBHH_1996+Inher_SUBHH_1998 if YEAR==1998
	replace CumRealInher_SUBHH=Inher_SUBHH_1992+Inher_SUBHH_1994+Inher_SUBHH_1996+Inher_SUBHH_1998+Inher_SUBHH_2000 if YEAR==2000
	replace CumRealInher_SUBHH=Inher_SUBHH_1992+Inher_SUBHH_1994+Inher_SUBHH_1996+Inher_SUBHH_1998+Inher_SUBHH_2000+Inher_SUBHH_2002 if YEAR==2002
	replace CumRealInher_SUBHH=Inher_SUBHH_1992+Inher_SUBHH_1994+Inher_SUBHH_1996+Inher_SUBHH_1998+Inher_SUBHH_2000+Inher_SUBHH_2002+Inher_SUBHH_2004 if YEAR==2004
	replace CumRealInher_SUBHH=Inher_SUBHH_1992+Inher_SUBHH_1994+Inher_SUBHH_1996+Inher_SUBHH_1998+Inher_SUBHH_2000+Inher_SUBHH_2002+Inher_SUBHH_2004+Inher_SUBHH_2006 if YEAR==2006
	replace CumRealInher_SUBHH=Inher_SUBHH_1992+Inher_SUBHH_1994+Inher_SUBHH_1996+Inher_SUBHH_1998+Inher_SUBHH_2000+Inher_SUBHH_2002+Inher_SUBHH_2004+Inher_SUBHH_2006+Inher_SUBHH_2008 if YEAR==2008
	replace CumRealInher_SUBHH=Inher_SUBHH_1992+Inher_SUBHH_1994+Inher_SUBHH_1996+Inher_SUBHH_1998+Inher_SUBHH_2000+Inher_SUBHH_2002+Inher_SUBHH_2004+Inher_SUBHH_2006+Inher_SUBHH_2008+Inher_SUBHH_2010 if YEAR==2010
	
	gen Temp=0
	replace Temp=RealInher_SUBHH_YEAR if HHIDSUBHHYearCounter==1
	bys HHID SUBHH: egen TotalRealInher_SUBHH=total(Temp), missing
	drop Temp
	
	gen AnyInherSUBHH=TotalRealInher_SUBHH>0
	replace AnyInherSUBHH=. if TotalRealInher_SUBHH==.
	
	bys HHID SUBHH: egen EverInherBinary=max(InherBinary)
	
	gen logTotalRealInher_SUBHH=log(TotalRealInher_SUBHH)
	replace logTotalRealInher_SUBHH=0 if AnyInherSUBHH==0
	
	
	********************************************************************



******************************************************
******************************************************
* Get Real Values of Financial Wealth Variables:
******************************************************
******************************************************

* Real Financial Wealth (note that this doesn't yet include 401k accounts)
* FinWealth_WithImpute = RetIncMarketVal + RealEstateVal + TransVal + 
*                         BusVal + IRAVal + StockVal + CashVal + CDVal + BondVal
*                         OtherAssetVal - OtherDebtVal + TrustVal + HouseVal +
*                         - MortgVal - HmLnVal + HousVal2 - SecMortgVal  

* Get Real Versions of Each component:

foreach var in RetIncMarketVal TotAllPenAmt  RealEstateVal TransVal BusVal IRAVal StockVal ///
               CashVal CDVal BondVal OtherAssetVal OtherDebtVal TrustVal HouseVal ///  
			   MortgVal HmLnVal HouseVal2 SecMortgVal PenMarketVal RANDWealth {
			   gen Real`var'=`var'/CPIFactor
}


bys HHID SUBHH YEAR: egen TotAllPenAmtHH=total(TotAllPenAmt), missing

gen RealFinWealth=(FinWealth_WithImpute+TotAllPenAmtHH-TransVal)/CPIFactor
gen RealFinWealthNoH=(FinWealth_WithImputeNoH+TotAllPenAmtHH-TransVal)/CPIFactor
gen RealFinWealthNoP=(FinWealth_WithImpute-TransVal-RetIncMarketVal)/CPIFactor
gen RealFinWealthNoPH=(FinWealth_WithImputeNoH-TransVal-RetIncMarketVal)/CPIFactor			
gen RealFinWealthNoBiz=(FinWealth_WithImpute+TotAllPenAmtHH-TransVal-BusVal)/CPIFactor
		
			
* Real Pension, Transportation Assets, and Home Value:		
gen RealTrans=TransVal/CPIFactor
gen RealHomeValue=NetHomeVal/CPIFactor
	replace RealHomeValue=0 if HasHouse==0
	


* Clean AnyStocks / Any Bonds:


* Now, generate an AnyStocks Question based on the RiskyWeight variable:
bys HHID SUBHH YEAR: egen MaxPlanStockDollSUBHHYr=max(PlanStockDoll)

gen AnyStocks=.
replace AnyStocks=0 if WealthInStocks_WithImpute==0 & MaxPlanStockDollSUBHHYr==0
replace AnyStocks=1 if (WealthInStocks_WithImpute>0 & WealthInStocks_WithImpute~=.)
replace AnyStocks=1 if (MaxPlanStockDollSUBHHYr>0 & MaxPlanStockDollSUBHHYr~=.)


gen AnyStocksAlt=.
replace AnyStocksAlt=0 if WealthInStocks_WithImpute==0 & MaxPlanStockDollSUBHHYr==0
replace AnyStocksAlt=1 if (WealthInStocks_WithImpute>0 & WealthInStocks_WithImpute~=.)
replace AnyStocksAlt=1 if (MaxPlanStockDollSUBHHYr>0 & MaxPlanStockDollSUBHHYr~=.)
replace AnyStocksAlt=0 if WealthInStocks_WithImpute==0 & MaxPlanStockDollSUBHHYr==.
replace AnyStocksAlt=0 if WealthInStocks_WithImpute==. & MaxPlanStockDollSUBHHYr==0


* Indicator for receiving any Defined Benefit Income:
gen GetPen= PenMarketVal>0
replace GetPen=. if PenMarketVal==.	




*************************************
* Clean Expectations Variables:
*
*  1) ProbMarketUp
*  2) ProbRec
*  3) ProbDDInf
*
*************************************

*************************
* 1) Probability Market Up
*************************

gen DK_ProbMarketUp=(ProbMarketUp==998)
	replace DK_ProbMarketUp=. if ProbMarketUp>998

gen ProbMarketUpWithDK=ProbMarketUp
	replace ProbMarketUpWithDK=. if ProbMarketUp>998

replace ProbMarketUp=. if ProbMarketUp>100

* We set 71 percent as our objective belief for the probablity that the stock
* market rises in a given year
gen Dev_PMUP=abs(ProbMarketUp-71)

gen Extreme_PMUP_0=(ProbMarketUp==0)
replace Extreme_PMUP_0=. if ProbMarketUp==.

gen Extreme_PMUP_50=(ProbMarketUp==50)
replace Extreme_PMUP_50=. if ProbMarketUp==.

gen Extreme_PMUP_100=(ProbMarketUp==100)
replace Extreme_PMUP_100=. if ProbMarketUp==.


gen PMUPCat=.
	replace PMUPCat=1 if (DK_ProbMarketUp==0 & Extreme_PMUP_50==0 & Extreme_PMUP_0==0 & Extreme_PMUP_100==0 & ProbMarketUp!=.)
	replace PMUPCat=2 if Extreme_PMUP_0==1
	replace PMUPCat=3 if Extreme_PMUP_100==1
	replace PMUPCat=4 if Extreme_PMUP_0==1
	replace PMUPCat=5 if DK_ProbMarketUp==1
	
	
	
	
*************************************************

***************************
* 2)  Probability Recession
***************************

gen DK_ProbRecession=(ProbUSEconDep==998)
	replace DK_ProbRecession=. if ProbUSEconDep>998 

gen PRecWithDK=ProbUSEconDep
replace PRecWithDK=. if PRecWithDK>998

replace ProbUSEconDep=. if ProbUSEconDep>100

* We set 36 percent as our objective belief for the probability that the US 
* economy faces a major depression in the next 10 years
gen Dev_PRec=abs(ProbUSEconDep-36)


gen Extreme_PRec_0=(ProbUSEconDep==0)
replace Extreme_PRec_0=. if ProbUSEconDep==.

gen Extreme_PRec_50=(ProbUSEconDep==50)
replace Extreme_PRec_50=. if ProbUSEconDep==.

gen Extreme_PRec_100=(ProbUSEconDep==100)
replace Extreme_PRec_100=. if ProbUSEconDep==.

gen PRecCat=.
	replace PRecCat=1 if (DK_ProbRecession==0 & Extreme_PRec_50==0 & Extreme_PRec_0==0 & Extreme_PRec_100==0 & ProbUSEconDep!=.)
	replace PRecCat=2 if Extreme_PRec_0==1
	replace PRecCat=3 if Extreme_PRec_100==1
	replace PRecCat=4 if Extreme_PRec_50==1
	replace PRecCat=5 if DK_ProbRecession==1
	

	

******************************************
* 3)  Probability Double Digit Inflation
******************************************

gen DK_ProbDDInf=(ProbDDInf==998)
	replace DK_ProbDDInf=. if (ProbDDInf>998  | ProbDDInf==996 | ProbDDInf==997)

gen PDDInfWithDK=ProbDDInf
replace PDDInfWithDK=. if (ProbDDInf>998  | ProbDDInf==996 | ProbDDInf==997)

replace ProbDDInf=. if ProbDDInf>100

* We set 29 percent as our objective probability that the US will face double
* digit inflation in the next 10 years
gen Dev_DDInf=abs(ProbDDInf-29)	


gen Extreme_DDInf_0=(ProbDDInf==0)
replace Extreme_DDInf_0=. if ProbDDInf==.

gen Extreme_DDInf_50=(ProbDDInf==50)
replace Extreme_DDInf_50=. if ProbDDInf==.

gen Extreme_DDInf_100=(ProbDDInf==100)
replace Extreme_DDInf_100=. if ProbDDInf==.

gen DDInfCat=.
	replace DDInfCat=1 if (DK_ProbDDInf==0 & Extreme_DDInf_50==0 & Extreme_DDInf_0==0 & Extreme_DDInf_100==0 & ProbDDInf!=.)
	replace DDInfCat=2 if Extreme_DDInf_0==1
	replace DDInfCat=3 if Extreme_DDInf_100==1
	replace DDInfCat=4 if Extreme_DDInf_50==1
	replace DDInfCat=5 if DK_ProbDDInf==1
		
	
	
* Get some measures of the Belief Variables that are time invariant

foreach var in PRec PMUP DDInf {

bys HHID PN: egen Ever_Extreme_`var'_0=max(Extreme_`var'_0)
bys HHID PN: egen Ever_Extreme_`var'_100=max(Extreme_`var'_100)

bys HHID SUBHH: egen HHEver_Extreme_`var'_0=max(Extreme_`var'_0)
bys HHID SUBHH: egen HHEver_Extreme_`var'_100=max(Extreme_`var'_100)

bys HHID PN: egen Num_Extreme_`var'_0=total(Extreme_`var'_0), missing 
bys HHID PN: egen Num_Extreme_`var'_100=total(Extreme_`var'_100), missing 


}

bys HHID PN: egen MaxDev_Prec=max(Dev_PRec)
bys HHID PN: egen MaxDev_PMUP=max(Dev_PMUP)
bys HHID PN: egen MaxDev_DDInf=max(Dev_DDInf)


gen Temp=(ProbUSEconDep~=.)
bys HHID PN: egen NumObsPrec=total(Temp)
drop Temp

gen Temp=(ProbMarketUp~=.)
bys HHID PN: egen NumObsPMUP=total(Temp)
drop Temp

gen Temp=(ProbDDInf~=.)
bys HHID PN: egen NumObsDDInf=total(Temp)
drop Temp
		
gen ExpSample1=(Ever_Extreme_PRec_0~=. & Ever_Extreme_PMUP_0~=.)
gen ExpSample2=(Ever_Extreme_PRec_0~=. & Ever_Extreme_PMUP_0~=. & Ever_Extreme_DDInf_0~=.)
		

gen IncRAbin1=0
replace IncRAbin1=1 if IncRAbin==1
gen IncRAbin6=0
replace IncRAbin6=1 if IncRAbin==6

gen IncRiskTolBin=0
replace IncRiskTolBin=1 if IncRAbin==1 
replace IncRiskTolBin=. if IncRAbin==. | IncRAbin==0

gen BusRiskTolBin=0
replace BusRiskTolBin=1 if BusRAbin==1 
replace BusRiskTolBin=. if BusRAbin==. | BusRAbin==0

gen InherRiskTolBin=0
replace InherRiskTolBin=1 if InherRAbin==1 	
replace InherRiskTolBin=. if InherRAbin==. | InherRAbin==0

replace IncRAbin=.   if IncRAbin==0
replace BusRAbin=.   if BusRAbin==0
replace InherRAbin=. if InherRAbin==0
		
		
gen HighIncRA=(IncRAbin==1)
replace HighIncRA=. if IncRAbin==.

bys HHID PN: egen MaxHighIncRA=max(HighIncRA)
bys HHID PN: egen MinHighIncRA=min(HighIncRA)

gen HighInherRA=(InherRAbin==1)
replace HighInherRA=. if InherRAbin==.

bys HHID PN: egen MaxHighInherRA=max(HighInherRA)
bys HHID PN: egen MinHighInherRA=min(HighInherRA)
	
gen HighBusRA=(BusRAbin==1)
replace HighBusRA=. if BusRAbin==.

bys HHID PN: egen MaxHighBusRA=max(HighBusRA)
bys HHID PN: egen MinHighBusRA=min(HighBusRA)

bys HHID SUBHH: egen HH_MaxHighBusRA=max(MaxHighBusRA)
bys HHID SUBHH: egen HH_MaxHighIncRA=max(MaxHighIncRA)
bys HHID SUBHH: egen HH_MaxHighInherRA=max(MaxHighInherRA)	
	
	gen IncRAbinVar  =-1*IncRAbin
	gen InherRAbinVar=-1*InherRAbin
	gen BusRAbinVar  =-1*BusRAbin		
		
		
	
gen HHIDSUBHH=HHID*10+SUBHH


gen Age=YEAR-BIRTHYR


* Get Household Indicator for not having anyone who is working and not retired:

gen Temp=(WorkForPay==1 & Retired==0)
bys HHID SUBHH YEAR: egen HH_NumWorkNoRet=total(Temp)
drop Temp



		gen SampleYears=((YEAR>2000 & YEAR<2012) | (YEAR==1998 | YEAR==1996))	

		
		drop if YEAR>2010
		drop if SUBHH==""
		

		
		***************************************************************************
		* Generate Some Person-Specific Variables.  This will be important
		* Below when we create Male and Female Specific Regressors.  Below we
		* also clean some household-level variables (like the inheritance
		* variables).
		***************************************************************************		
			


			
			bys HHID PN: egen MinAgeHHIDPN=min(Age)

			gen Temp=.
			replace Temp=YEAR if Retired==1 & YEAR~=.
			bys HHID PN: egen MinYearRetired=min(Temp)
			drop Temp

			gen Temp=.
			replace Temp=YEAR if Retired==0 & YEAR~=.
			bys HHID PN: egen MaxYearNotRetired=max(Temp)
			drop Temp		
			
			gen Temp=0
			replace Temp=1 if Retired~=.
			bys HHID PN: egen NumNonMissRetired=total(Temp)
			drop Temp
		
		
			gen Temp=.
			replace Temp=YEAR if HH_NumWorkNoRet==0
			bys HHID SUBHH: egen MinRetYearSUBHH=min(Temp)
			drop Temp
			
			
			gen Temp=0
			replace Temp=1 if HH_NumWorkNoRet==0
			bys HHID SUBHH: egen AlwaysRetiredHH=min(Temp)
			drop Temp
			
			
			gen Temp=0
			replace Temp=1 if Retired==1
			bys HHID PN: egen EverRetired=max(Temp)
			drop Temp
			
			
			bys HHID PN: egen EverHomeMaker=max(HomeMaker)
			
			gen Temp=.
			replace Temp=YEAR if WorkForPay==1 & YEAR~=.
			bys HHID PN: egen MaxYearWorkForPay=max(Temp)
			drop Temp		
			
			gen Temp=.
			replace Temp=YEAR if WorkForPay==1 & Retired==0 & YEAR~=.
			bys HHID PN: egen MaxYearWorkForPayRet0=max(Temp)
			drop Temp		
			
					
			replace FinPlanCat=. if FinPlanCat>5
			replace FinPlanCat=. if FinPlanCat==0
			
			bys HHID PN: egen MinFinPlanCat=min(FinPlanCat)
			bys HHID PN: egen MaxFinPlanCat=max(FinPlanCat)
		
			gen CalcBY=YEAR-Age
			bys HHID PN: egen ModalBY=mode(CalcBY), minmode
			
			replace BIRTHYR=. if BIRTHYR==0
		

			   
	   
		************************************************************************
		* Get Male and Female Values of Time-Invariant Characteristics at the
		* HHID-SUBHH level (financial household level)
		************************************************************************
			replace FatherEducWithM=9999 if FEMiss==.
			replace FEMiss=1             if FEMiss==.
			
			replace MotherEducWithM=9999 if MEMiss==.
			replace MEMiss=1             if MEMiss==.
										
			foreach var in Male DEGREE Educ BIRTHYR RACE FatherEduc MotherEduc FatherEducWithM MotherEducWithM FEMiss MEMiss      ///
			               EA3Score EA3ScoreHRS ///
						   EverRetired NumChildEver TotKids TotKidsOPN YearRetired  ///
						     Pers_EverDiffFS                     ///
						   fv1 fv2 fv3 fv4 fv5 fv6 fv7 fv8 fv9 fv10                   ///
						   EXDEATHYR AALIVE BALIVE CALIVE DALIVE EALIVE FALIVE GALIVE HALIVE JALIVE KALIVE LALIVE MALIVE NALIVE OALIVE    ///
						   MaxDev_PMUP MaxDev_Prec MaxDev_DDInf  Ever_Extreme_PMUP_0  Ever_Extreme_PMUP_100  ///
						   Ever_Extreme_PRec_0  Ever_Extreme_PRec_100 Ever_Extreme_DDInf_0  Ever_Extreme_DDInf_100 /// 
						   MinFinPlanCat MaxFinPlanCat        ///
						   ev1 ev2 ev3 ev4 ev5 ev6 ev7 ev8 ev9 ev10   {
			
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
		
		gen M_Age=(YEAR-M_BIRTHYR)
		gen F_Age=(YEAR-F_BIRTHYR)
		
		gen MaxDEGREE=.
		replace MaxDEGREE=M_DEGREE if MOnly==1
		replace MaxDEGREE=F_DEGREE if FOnly==1
		replace MaxDEGREE=M_DEGREE if MF==1
		replace MaxDEGREE=F_DEGREE if MF==1 & M_DEGREE==9
		replace MaxDEGREE=F_DEGREE if MF==1 & M_DEGREE~=9 & F_DEGREE~=9 & (F_DEGREE>M_DEGREE)
		
	
		* Get Age Retired:
		gen M_AgeRetired=M_YearRetired-M_BIRTHYR
		gen F_AgeRetired=F_YearRetired-F_BIRTHYR


		* Clean Children Variables.  Get intra-household maximum for three different measures:
		egen MaxNumChildHH=rowmax(M_NumChildEver F_NumChildEver)
		egen MaxNumTotKidsHH=rowmax(M_TotKids F_TotKids)
		egen MaxNumTotKidsOPNHH=rowmax(M_TotKidsOPN F_TotKidsOPN)		
	     
		***********************************************************************
		* Replace the principal components with zeros if they are missing
		* and if we are dealing with an MF household
		***********************************************************************
		
		gen M_PC_Miss=(M_ev1==.)
		gen F_PC_Miss=(F_ev1==.)
		
		gen M_PC_MissxMOnly=M_PC_Miss*MOnly
		gen F_PC_MissxFOnly=F_PC_Miss*FOnly
		
		foreach var in ev1 ev2 ev3 ev4 ev5 ev6 ev7 ev8 ev9 ev10 {
			
			replace M_`var'=0 if M_`var'==. & ((F_PC_Miss==0 & MF==1) | (FOnly==1))
			replace F_`var'=0 if F_`var'==. & ((M_PC_Miss==0 & MF==1) | (MOnly==1))
			
			gen M_`var'xMOnly=M_`var'*MOnly
			gen F_`var'xFOnly=F_`var'*FOnly
						
		}

		
		*********************************************************************
		* Our basic Household Sample is limited to self-identified whites
		* who are cohabiting with other self-identified whites
		**********************************************************************
		gen HHSample=(MF==1 & M_RACE==1 & F_RACE==1) | (FOnly==1 & F_RACE==1) | (MOnly==1 & M_RACE==1)
		
		
		* Drop Small Number of Households with missing Years of Schooling:
		drop if (F_Educ==. & (MF==1 | FOnly==1)) | (M_Educ==. & (MF==1 | MOnly==1))		  

		* For a very small number of observations, two individuals report being the financial respondnt in the 
		* same HHID SUBHH.  
	
		* Get number of people who claim to be Financial Respondent in this HHID SUBHH in a given year:
		bys HHID SUBHH YEAR: egen NumFR=total(FinRespondent)

		* For each indiviudal (HHID PN), get the total number of sample years in which the individual
		* was the financial respondent.
		gen Temp=0
		replace Temp=1 if FinRespondent==1 & SampleYears==1 & HHSample==1
		bys HHID PN: egen FinRespObs=total(Temp)
		drop Temp
		
		* Get the maximum of FinRespObs across individuals in the HHID SUBHH in a given yeawr
		bys HHID SUBHH YEAR: egen MaxNumFinRespObs=max(FinRespObs)

		* Now, in those household years with two financial respondents, set FinRespondent equal to
		* zero for the individual observed fewer times as the financial respondent:
		replace FinRespondent=0 if NumFR==2 & FinRespondent==1 & FinRespObs<MaxNumFinRespObs	
	
	
	* Define some variables indicating inclusion in samples of interest.  
	* 1) WealthRegSample - all household-year observations in the Sample Years, for white households:
	* 2) WealthRegSampleNoRet - Same as above, but do not impose a restirction that the household be retired.  
	
	bys HHID SUBHH YEAR: egen MaxAgeSUBHH=max(Age)
	bys HHID SUBHH YEAR: egen MinAgeSUBHH=min(Age)
	
	gen InAgeRangeRet=(MinAgeSUBHH>=65 & MaxAgeSUBHH<=75)
	gen InAgeRangeRetLarge=(MinAgeSUBHH>=55 & MaxAgeSUBHH<=85)
	
	gen InAgeRangeNoRet=(MinAgeSUBHH>=50 & MaxAgeSUBHH<=75)
	gen InAgeRangeNoRetLarge=(MaxAgeSUBHH<=85)
	
	gen WealthRegSample=(HH_NumWorkNoRet==0 & FinRespondent==1 & SampleYears==1 & HHSample==1 & InAgeRangeRet==1)
	gen WealthRegSampleNoRet=(FinRespondent==1 & SampleYears==1 & HHSample==1 & InAgeRangeNoRet==1)	

	gen WealthRegSampleLarge=(HH_NumWorkNoRet==0 & FinRespondent==1 & SampleYears==1 & HHSample==1 & InAgeRangeRetLarge==1)
	gen WealthRegSampleNoRetLarge=(FinRespondent==1 & SampleYears==1 & HHSample==1 & InAgeRangeNoRetLarge==1)		
	
	* Winsorize the wealth variables.  Notice that they were previously winsorized on a different sample, so we will
	* drop the winsorized variables in logs and levels and re-winsorize on the WealthRegSample.
 
	gen RFW=RealFinWealth
	gen RFWNoP=RealFinWealthNoP
	gen RFWNoH=RealFinWealthNoH
	gen RFWNoPH=RealFinWealthNoPH
	gen RFWNoBiz=RealFinWealthNoBiz
	gen RRW=RANDWealth
	
	foreach WVar in RFW RFWNoP RFWNoH RFWNoPH RFWNoBiz RRW {
	
		sum `WVar' if WealthRegSample==1, det 
			gen `WVar'_1=r(p1)
			gen `WVar'_99=r(p99)
		gen `WVar'Winz=`WVar'
		replace `WVar'Winz=`WVar'_1   if `WVar'<`WVar'_1  & `WVar'~=.
		replace `WVar'Winz=`WVar'_99  if `WVar'>`WVar'_99 & `WVar'~=.
	
	}
	
	gen RealFinWealthWinz=RFWWinz
	gen RealFinWealthNoPWinz=RFWNoPWinz
	gen RealFinWealthNoHWinz=RFWNoHWinz
	gen RealFinWealthNoPHWinz=RFWNoPHWinz
	gen RealFinWealthNoBizWinz=RFWNoBizWinz
	gen RealRANDWealthWinz=RRWWinz
	
	foreach var in RealFinWealthWinz RealFinWealthNoPWinz RealFinWealthNoHWinz RealFinWealthNoPHWinz RealFinWealthNoBizWinz RealRANDWealthWinz {
		gen log`var'=log(`var')
	}
	
	gen RealFinWealthWinz_1k=RealFinWealthWinz/1000
	
	*********************************************************
	* Calculate the Average EA score in the household:
	*********************************************************
	
	gen RAW_EA3ScoreAvg=.
	replace RAW_EA3ScoreAvg=(M_EA3Score+F_EA3Score)/2 if M_EA3Score~=.  & F_EA3Score~=. & MF==1
	replace RAW_EA3ScoreAvg=M_EA3Score                if M_EA3Score~=.  & F_EA3Score==. & MF==1
	replace RAW_EA3ScoreAvg=F_EA3Score                if M_EA3Score==.  & F_EA3Score~=. & MF==1
	
	replace RAW_EA3ScoreAvg=M_EA3Score                if M_EA3Score~=.  & MOnly==1
	replace RAW_EA3ScoreAvg=F_EA3Score                if F_EA3Score~=.  & FOnly==1
	
	* Get Average RAW EA3 Score average for household observations in our basic wealth regression:
	reg logRealFinWealthWinz  RAW_EA3ScoreAvg     if  HH_NumWorkNoRet==0 & FinRespondent==1 & SampleYears==1 & HHSample==1 & InAgeRangeRet==1, cluster(HHID)	
		gen Temp=.
		replace Temp=YEAR if e(sample)
		bys HHID SUBHH: egen MinYearWealthReg=min(Temp)
		drop Temp
	
	sum RAW_EA3ScoreAvg if YEAR==MinYearWealthReg & e(sample)
	
	gen EA3ScoreAvg=(RAW_EA3ScoreAvg-r(mean))/(r(sd))	
	
			


************************************
* TABLE 1: Summary Statistics
************************************

reg logRealFinWealthWinz  EA3ScoreAvg     if  HH_NumWorkNoRet==0 & FinRespondent==1 & SampleYears==1 & HHSample==1 & InAgeRangeRet==1, cluster(HHID)	
gen RetRegSample=e(sample)

reg logRealFinWealthWinz  EA3ScoreAvg     if  HH_NumWorkNoRet==0 & FinRespondent==1 & SampleYears==1 & HHSample==1 & InAgeRangeRetLarge==1, cluster(HHID)	
gen RetLargeRegSample=e(sample)

reg logRealFinWealthWinz  EA3ScoreAvg     if  FinRespondent==1 & SampleYears==1 & HHSample==1 & InAgeRangeNoRet==1, cluster(HHID)	
gen NoRetRegSample=e(sample)

reg logRealFinWealthWinz  EA3ScoreAvg     if  FinRespondent==1 & SampleYears==1 & HHSample==1 & InAgeRangeNoRetLarge==1, cluster(HHID)	
gen NoRetLargeRegSample=e(sample)


* Generate a dummy variable for first household-year observed in the wealth sample for each household:

foreach samp in Ret NoRet RetLarge NoRetLarge  {
gen Temp=.
replace Temp=YEAR if `samp'RegSample==1
bys HHID SUBHH: egen FirstYearIn`samp'Samp=min(Temp)
drop Temp

gen InFirst`samp'WealthYear=(YEAR==FirstYearIn`samp'Samp & `samp'RegSample==1)

}
	
	* Create a new PersCounter variable (the old counter might not be accurate
	* now because we deleted some observations (e.g. missing FamStructure)
	bys HHID PN: gen NewPersCounter=_n
	
	
	tab FamStructure if RetRegSample==1
	
	* Get Indicator for Ever Being in NoRetRegSample:
	foreach samp in Ret NoRet RetLarge NoRetLarge {
		* Create a year-specific indicator if this HHID-SUBHH 
		* contributes an observation to the wealth sample in a given year:	
		bys HHID SUBHH YEAR: egen SUBHH_`samp'_SampleYear=max(`samp'RegSample)
		* Create a time-invariant indicator for HHID-SUBHH combos that contribute
		* to the Basic Wealth Regression Sample		
		bys HHID SUBHH:      egen SUBHH_`samp'_InSample=max(SUBHH_`samp'_SampleYear)
		* Now, create a time-invariant indicator, EverInWealthSample, that indicates
		* if this individual is observed as a memeber of a household that contributes
		* a person-year observation to the basic wealth sample:		
		bys HHID PN:         egen Pers_EverIn`samp'Sample=max(SUBHH_`samp'_InSample)
	}
	
	* Create a series of dummy variables indicating each possible value for the
	* M_DEGREE and F_DEGREE variables:

	foreach var in M_DEGREE F_DEGREE {

		gen `var'_None=(`var'==0)
		replace `var'_None=. if `var'==.
		
		gen `var'_GED=(`var'==1)
		replace `var'_GED=. if `var'==.
		
		gen `var'_HighSchool=(`var'==2)
		replace `var'_HighSchool=. if `var'==.
		
		gen `var'_TwoYr=(`var'==3)
		replace `var'_TwoYr=. if `var'==.
		
		gen `var'_Coll=(`var'==4)
		replace `var'_Coll=. if `var'==.
		
		gen `var'_MA=(`var'==5)
		replace `var'_MA=. if `var'==.
		
		gen `var'_Prof=(`var'==6)
		replace `var'_Prof=. if `var'==.	

		gen `var'_UK_SC=(`var'==9)
		replace `var'_UK_SC=. if `var'==.		
		
	}



save "$CleanData\GenesWealth_CleanPanel.dta", replace

bys HHID PN: gen Counter=_n

keep if Counter==1

keep HHID PN Pers_EverIn* MF MOnly FOnly

save "$CleanData\GenesWealth_PersonSampleInds.dta", replace







