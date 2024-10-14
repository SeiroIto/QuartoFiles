clear
local wave "7"
local year "2004"
use "$RandDetailDir/randhrsimp1992_2014v2.dta", clear


/*****************************************
  PENSION AND ANNUITY INCOME
*****************************************/
/********************
 Respondent and Spouse
********************/
foreach person in Resp Spse{

  if "`person'" == "Resp" local per "r"
  if "`person'" == "Spse" local per "s"

  * Annuity income
    gen `person'AnnInc_`year' = `per'`wave'iann
    replace `person'AnnInc_`year' = 0 if `person'AnnInc_`year' == .u
  
    * Flag imputed values
    gen `person'AnnInc_Imp_`year' = `per'`wave'ifann
    gen `person'AnnIncContVal_`year' = inlist(`per'`wave'ifann,0,1,8)
    gen `person'AnnIncImpVal_`year'= ~inlist(`per'`wave'ifann,9,.)

  * Pension income
  gen `person'PenInc_`year' = `per'`wave'ipen
  replace `person'PenInc_`year' = 0 if `person'PenInc_`year' == .u

  * Flag imputed values
  gen `person'PenInc_Imp_`year' = `per'`wave'ifpen
  gen `person'PenIncContVal_`year' = inlist(`per'`wave'ifpen,0,1,8)
  gen `person'PenIncImpVal_`year' = ~inlist(`per'`wave'ifpen,9,.)

  * Social security
  gen `person'SSInc_`year' =`per'`wave'isret
  replace `person'SSInc_`year' = 0 if `person'SSInc_`year' == .u

  * Flag imputed values
  gen `person'SSInc_Imp_`year' = `per'`wave'ifsret
  gen `person'SSIncContVal_`year' = inlist(`per'`wave'ifsret, 0, 1,8)
  gen `person'SSIncImpVal_`year' = ~inlist(`per'`wave'ifsret, 9,.)

}

* Total income for a RESPONDENT (including spouse.) Note this is NOT a household
gen AnnInc_`year' = RespAnnInc_`year' + SpseAnnInc_`year'
gen SSInc_`year' = RespSSInc_`year' + SpseSSInc_`year'
gen PenInc_`year' = RespPenInc_`year' + SpsePenInc_`year'
gen RetInc_`year' = AnnInc_`year' + SSInc_`year' + PenInc_`year'

* Flag imputed values for aggregates
foreach var in AnnInc SSInc PenInc{
  gen `var'ContVal_`year' = 1 if Resp`var'ContVal_`year' == 1 & Spse`var'ContVal_`year' == 1
  gen `var'ImpVal_`year' = 1 if max(Resp`var'ContVal_`year', Resp`var'ImpVal_`year') == 1 & max(Spse`var'ContVal_`year', Spse`var'ImpVal_`year') == 1
}

gen RetIncContVal_`year' = 1 if AnnIncContVal_`year' == 1 & SSIncContVal_`year' == 1 & PenIncContVal_`year' == 1
gen RetIncImpVal_`year' = 1 if max(AnnIncContVal_`year', AnnIncImpVal_`year') == 1 & max(SSIncContVal_`year', SSIncImpVal_`year') == 1 & max(PenIncContVal_`year', PenIncImpVal_`year') == 1

* Merge Annunity Factor data
isid hhidpn
merge 1:1 hhidpn using "$CleanData/AnnFactor`year'.dta"
keep if _merge==3
drop _merge
keep if inlist(GENDER,1,2)

foreach var in Ret Ann Pen SS{
  gen `var'MarketVal_`year' = .
  replace `var'MarketVal_`year' = MaleAnnVal*`var'Inc_`year' if GENDER == 1
  replace `var'MarketVal_`year' = FemaleAnnVal*`var'Inc_`year' if GENDER == 2
  assert ~mi(`var'MarketVal_`year') if ~mi(`var'Inc_`year')
}
ren RetMarketVal_`year' RetIncMarketVal_`year'

/*****************************************
  REAL ESTATE (NON-RESIDENCE)
*****************************************/
gen RealEstateVal_`year' = h`wave'arles

* Flag imputed values 
gen RealEstateVal_Imp_`year' = h`wave'afrles
gen RealEstateContVal_`year' = inlist(h`wave'afrles, 1, 6)
gen RealEstateImpVal_`year' = inlist(h`wave'afrles, 1, 2, 3, 6)

* Flag real estate ownership
gen HasRealEstate_`year' = h`wave'aorles

/*****************************************
  TRANSPORTATION
*****************************************/
gen TransVal_`year' = h`wave'atran

* Flag imputed values
gen TransVal_Imp_`year' = h`wave'aftran
gen TransContVal_`year' = inlist(h`wave'aftran, 1, 6)
gen TransImpVal_`year' = inlist(h`wave'aftran, 1, 2, 3, 6)

* Flag transportation ownership
gen HasTrans_`year' = h`wave'aotran

/* note: The net value of vehicles in Wave 1 for the cross-wave imputations is solely the value of vehicles other
than recreational vehicles. To include the value of recreational vehicles, please use H1WTRN2 of the
cross-section imputations. */


/*****************************************
  PRIVATE BUSINESSES
*****************************************/
gen BusVal_`year' = h`wave'absns

* Flag imputed values
gen BusVal_Imp_`year' = h`wave'afbsns
gen BusContVal_`year' = inlist(h`wave'afbsns, 1, 6)
gen BusImpVal_`year' = inlist(h`wave'afbsns, 1, 2, 3, 6)

* Flag private business ownership
gen HasBusVal_`year' = h`wave'aobsns

/*****************************************
  IRA AND KEOGH ACCOUNTS
*****************************************/
* total value of accounts
gen IRAVal_`year' = h`wave'aira

* value of individual accounts
gen IRA_1_Val_`year' = h`wave'aira1
gen IRA_2_Val_`year' = h`wave'aira2
gen IRA_3_Val_`year' = h`wave'aira3

cap assert IRAVal_`year' == IRA_1_Val_`year' + IRA_2_Val_`year' + IRA_3_Val_`year'

* Flag imputed values
gen IRAVal_Imp_`year' = h`wave'afira
gen IRAVal_1_Imp_`year' = h`wave'afira1
gen IRAVal_2_Imp_`year' = h`wave'afira2
gen IRAVal_3_Imp_`year' = h`wave'afira3

forval i = 1/3{
  gen IRA`i'ContVal_`year' = inlist(h`wave'afira`i', 1, 6)
  gen IRA`i'ImpVal_`year' = inlist(h`wave'afira`i', 1, 2, 3, 6)
}

gen IRAContVal_`year' = IRA1ContVal_`year' == 1 & IRA2ContVal_`year' == 1 & IRA3ContVal_`year' == 1
gen IRAImpVal_`year' = IRA1ImpVal_`year' == 1 & IRA2ImpVal_`year' == 1 & IRA3ImpVal_`year' == 1 

* Flag IRA ownership
gen HasAnyIRA_`year' = h`wave'aoira
gen HasIRA_1_`year' = h`wave'aoira1
gen HasIRA_2_`year' = h`wave'aoira2
gen HasIRA_3_`year' = h`wave'aoira3

/*****************************************
  STOCK AND STOCK MUTUAL FUNDS
*****************************************/
gen StockVal_`year' = h`wave'astck

* Flag imputed values
gen StockVal_Imp_`year' = h`wave'afstck
gen StockContVal_`year' = inlist(h`wave'afstck, 1, 6)
gen StockImpVal_`year' = inlist(h`wave'afstck, 1, 2, 3, 6)

* Flag Stock ownership
gen HasStock_`year' = h`wave'aostck

/*****************************************
  CHECKING, SAVING, AND MONEY MARKET ACCOUNTS
*****************************************/
gen CashVal_`year' = h`wave'achck

* Flag imputed values
gen CashVal_Imp_`year' = h`wave'afchck
gen CashContVal_`year' = inlist(h`wave'afchck, 1, 6)
gen CashImpVal_`year' = inlist(h`wave'afchck, 1, 2, 3, 6)

* Flag account ownership
gen HasCash_`year' = h`wave'aochck

/*****************************************
  CDS, GOVT. SAVINGS BONDS, AND T-BILLS
*****************************************/
gen CDVal_`year' = h`wave'acd

* Flag imputed values
gen CDVal_Imp_`year' = h`wave'afcd
gen CDContVal_`year' = inlist(h`wave'afcd, 1, 6)
gen CDImpVal_`year' = inlist(h`wave'afcd, 1, 2, 3, 6)

* Flag CD ownership
gen HasCD_`year' = h`wave'aocd

/*****************************************
  BONDS AND BOND FUNDS
*****************************************/
gen BondVal_`year' = h`wave'abond

* Flag imputed values
gen BondVal_Imp_`year' = h`wave'afbond
gen BondContVal_`year' = inlist(h`wave'afbond, 1, 6)
gen BondImpVal_`year' = inlist(h`wave'afbond, 1, 2, 3, 6)

* Flag bond ownership
gen HasBond_`year' = h`wave'aobond

/*****************************************
  OTHER SAVINGS/ASSETS
*****************************************/
gen OtherAssetVal_`year' = h`wave'aothr           

* Flag imputed values
gen OtherAssetVal_Imp_`year' = h`wave'afothr
gen OtherAssetContVal_`year' = inlist(h`wave'afothr, 1, 6)
gen OtherAssetImpVal_`year' = inlist(h`wave'afothr, 1, 2, 3, 6)

* Flag other asset ownership
gen HasOtherAsset_`year' = h`wave'aoothr

/*****************************************
  OTHER DEBT
*****************************************/
gen OtherDebtVal_`year' = h`wave'adebt            

* Flag imputed values
gen OtherDebtVal_Imp_`year' = h`wave'afdebt
gen OtherDebtContVal_`year' = inlist(h`wave'afdebt, 1, 6)
gen OtherDebtImpVal_`year' = inlist(h`wave'afdebt, 1, 2, 3, 6)

* Flag debt ownership
gen HasOtherDebt_`year' = h`wave'aodebt

/*****************************************
  TRUSTS
*****************************************/
gen TrustVal_`year' = h`wave'atrst            

* Flag imputed vvalues
gen TrustVal_Imp_`year' = h`wave'aftrst
gen TrustContVal_`year' = inlist(h`wave'aftrst, 1,  6)
gen TrustImpVal_`year' = inlist(h`wave'aftrst, 1, 2, 3, 6)

*Flag Trust ownership
gen HasTrust_`year'        =h`wave'aotrst

/*****************************************
  VALUE OF PRIMARY RESIDENCE 
*****************************************/
gen HouseVal_`year' = h`wave'ahous            

* Flag imputed values
gen HouseVal_Imp_`year' = h`wave'ahous
gen HouseContVal_`year' = inlist(h`wave'afhous, 1, 6)
gen HouseImpVal_`year' = inlist(h`wave'afhous, 1, 2, 3, 6)

* Flag home ownership 
gen HasHouse_`year' = h`wave'aohous

/*****************************************
  VALUE OF PRIMARY RESIDENCE MORTGAGES (FIRST AND SECOND)
*****************************************/
assert h`wave'amort == h`wave'amrt1 + h`wave'amrt2
gen MortgVal_`year' = h`wave'amort

* Flag imputed values 
gen MortgVal_Imp_`year' = h`wave'afmort
gen Mortg1Val_Imp_`year' = h`wave'afmrt1
gen Mortg2Val_Imp_`year' = h`wave'afmrt2

forval i = 1/2{
  gen Mortg`i'ContVal_`year' = inlist(h`wave'afmrt`i', 1, 6)
  gen Mortg`i'ImpVal_`year' = inlist(h`wave'afmrt`i', 1, 2, 3, 6)
}

gen MortgContVal_`year' = Mortg1ContVal_`year' ==1 & Mortg2ContVal_`year' == 1
gen MortgImpVal_`year' = Mortg1ImpVal_`year' ==1 & Mortg2ImpVal_`year' == 1

* Flag Mortgage ownership
gen HasMortg_`year' = h`wave'aomort

/*****************************************
  VALUE OF ADDITIONAL HOME LOANS
*****************************************/
* These are home equity lines of credit balances and home equity loans
gen HmLnVal_`year' = h`wave'ahmln           

* Flag imputed values
gen HmLnVal_Imp_`year' = h`wave'afhmln

gen HmLnContVal_`year' = inlist(h`wave'afhmln, 1, 0)
gen HmLn1ContVal_`year' = inlist(h`wave'afeqcd, 1, 6)
gen HmLn2ContVal_`year' = inlist(h`wave'afeqln, 1, 6)
assert HmLnContVal_`year' == 1 if HmLn1ContVal_`year' == 1 & HmLn2ContVal_`year' == 1

gen HmLnVal1_Imp_`year' = inlist(h`wave'afeqcd, 1, 2, 3, 6)
gen HmLnVal2_Imp_`year' = inlist(h`wave'afeqln, 1, 2, 3, 6)
gen HmLnImpVal_`year' = 1 if HmLnVal1_Imp_`year' == 1 & HmLnVal2_Imp_`year' == 1

* Flag ownership of additional home loans
gen HasHmLn_`year' = h`wave'aohmln

/*****************************************
  NET VALUE OF PRIMARY RESIDENCE
*****************************************/
gen NetHomeVal_`year' = h`wave'atoth            


/*****************************************
  VALUE OF SECONDARY RESIDENCE
*****************************************/
gen HouseVal2_`year' = h`wave'ahoub

* Flag imputed values
gen HouseVal2_Imp_`year' = h`wave'afhoub
gen House2ContVal_`year' = inlist(h`wave'afhoub, 1, 6)
gen House2ImpVal_`year' = inlist(h`wave'afhoub, 1, 2, 3, 6)

* Flag second home ownership 
gen HasHouse2_`year' = h`wave'aohoub

/*****************************************
  VALUE OF SECONDARY RESIDENCE MORTGAGES
*****************************************/
gen SecMortgVal_`year' = h`wave'amrtb           

* Flag imputed values
gen SecMortgVal_Imp_`year' =h`wave'afmrtb
gen SecMortgContVal_`year' = inlist(h`wave'afmrtb, 1, 6)
gen SecMortgImpVal_`year' = inlist(h`wave'afmrtb, 1, 2, 3, 6)

* Flag has second morgage
gen HasSecMortg_`year' = h`wave'aomrtb

* Aggregate
foreach version in Cont Imp{
  gen FinWealth_`version'_`year'= RetIncMarketVal_`year' ///
                               + RealEstateVal_`year' ///
                               + TransVal_`year'      ///
                 + BusVal_`year'        ///
                 + IRAVal_`year'        ///
                 + StockVal_`year'      ///
                 + CashVal_`year'       ///
                 + CDVal_`year'         ///
                 + BondVal_`year'       ///
                 + OtherAssetVal_`year' ///
                 - OtherDebtVal_`year'  ///
                 + TrustVal_`year'      ///
                 + HouseVal_`year'      ///
                 - MortgVal_`year'      ///
                 - HmLnVal_`year'       ///
                 + HouseVal2_`year'     ///
                 - SecMortgVal_`year'   ///
              if   RetInc`version'Val_`year'    ==1 ///
                 & RealEstate`version'Val_`year'==1 ///
                 & Trans`version'Val_`year'     ==1 ///
                 & Bus`version'Val_`year'       ==1 ///
                 & IRA`version'Val_`year'       ==1 ///
                 & Stock`version'Val_`year'     ==1 ///
                 & Cash`version'Val_`year'      ==1 ///
                 & CD`version'Val_`year'        ==1 ///
                 & Bond`version'Val_`year'      ==1 ///
                 & OtherAsset`version'Val_`year'==1 ///
                 & OtherDebt`version'Val_`year' ==1 ///
                 & Trust`version'Val_`year'     ==1 ///
                 & House`version'Val_`year'     ==1 ///
                 & Mortg`version'Val_`year'     ==1 ///
                 & HmLn`version'Val_`year'      ==1 ///
                 & House2`version'Val_`year'    ==1 ///
                 & SecMortg`version'Val_`year'  ==1
}
ren (FinWealth_Cont_`year' FinWealth_Imp_`year') (FinWealth_NoImpute_`year' FinWealth_WithImpute_`year')

save "$CleanData/temp1`year'.dta", replace


/*********************************************************************
 LOAD IN ASSET AND INCOME FILE TO GET STOCK ALLOCATIONS
*********************************************************************/
clear all
infile using "$HRSSurveys04/h04sta/H04Q_H.dct" , using("$HRSSurveys04/h04da/H04Q_H.da")
local year "2004"
sort HHID JSUBHH
gen SUBHH=JSUBHH
destring HHID, gen(numHHID)
destring SUBHH, gen(numSUBHH)
gen h7hhid=numHHID*10+numSUBHH

/************************************
	IRA 1 STOCK ALLOCATIONS
************************************/
gen IRA1PercStocks=0
replace IRA1PercStocks=100 if JQ180_1==1
replace IRA1PercStocks=0   if JQ180_1==2
replace IRA1PercStocks=50  if JQ180_1==3
replace IRA1PercStocks=.   if JQ180_1==7 | JQ180_1==8 | JQ180_1==9

/************************************
	IRA 2 STOCK ALLOCATIONS
************************************/
gen IRA2PercStocks=0
replace IRA2PercStocks=100 if JQ180_2==1
replace IRA2PercStocks=0   if JQ180_2==2
replace IRA2PercStocks=50  if JQ180_2==3
replace IRA2PercStocks=.   if JQ180_2==7 | JQ180_2==8 | JQ180_2==9

/************************************
	IRA 3 STOCK ALLOCATIONS
************************************/
gen IRA3PercStocks=0
replace IRA3PercStocks=100 if JQ180_3==1
replace IRA3PercStocks=0   if JQ180_3==2
replace IRA3PercStocks=50  if JQ180_3==3
replace IRA3PercStocks=.   if JQ180_3==7 | JQ180_3==8 | JQ180_3==9

/********************************************************************************************************
                                 Inheritance Code	
********************************************************************************************************/
gen RecInher_1_`year'      =.
replace RecInher_1_`year'  =0 if JQ483_1==5 | (JQ484_1<=7 & JQ484_1>=1)
replace RecInher_1_`year'  =1 if JQ484_1==3

gen YearInher_1_`year'     =JQ487_1
replace YearInher_1_`year' =. if JQ487_1==9998 | JQ487_1==9999

gen MonthInher_1_`year'    =JQ486_1
replace MonthInher_1_`year'=. if JQ486_1==98 | JQ486_1==99

gen InherAmt_1_`year'      =JQ488_1
replace InherAmt_1_`year'  =. if JQ488_1==9999998 | JQ488_1==9999999
/*                  14.  R'S PARENTS
                    15.  BROTHER
                    17.  SISTER
                    19.  OTHER RELATIVE
                    20.  OTHER INDIVIDUAL
                    27.  EX-SPOUSE/PARTNER
                    34.  SPOUSE/PARTNER'S PARENTS */
gen InherRecWho_1_`year'     =JQ490_1

gen RecInher_2_`year'      =.
replace RecInher_2_`year'  =0 if JQ483_2==5 | (JQ484_2<=7 & JQ484_2>=1)
replace RecInher_2_`year'  =1 if JQ484_2==3

gen YearInher_2_`year'     =JQ487_2
replace YearInher_2_`year' =. if JQ487_2==9998 | JQ487_2==9999

gen MonthInher_2_`year'    =JQ486_2
replace MonthInher_2_`year'=. if JQ486_2==98 | JQ486_2==99

gen InherAmt_2_`year'      =JQ488_2
replace InherAmt_2_`year'  =. if JQ488_2==9999998 | JQ488_2==9999999

gen InherRecWho_2_`year'     =JQ490_2

gen RecInher_3_`year'      =.
replace RecInher_3_`year'  =0 if JQ483_3==5 | (JQ484_3<=7 & JQ484_3>=1)
replace RecInher_3_`year'  =1 if JQ484_3==3

gen YearInher_3_`year'     =JQ487_3
replace YearInher_3_`year' =. if JQ487_3==9998 | JQ487_3==9999

gen MonthInher_3_`year'    =JQ486_3
replace MonthInher_3_`year'=. if JQ486_3==98 | JQ486_3==99

gen InherAmt_3_`year'      =JQ488_3
replace InherAmt_3_`year'  =. if JQ488_3==9999998 | JQ488_3==9999999

gen InherRecWho_3_`year'     =JQ490_3

/*********************************************************************************************
	MERGE WITH RAND DATA
*********************************************************************************************/
keep h7hhid HHID SUBHH IRA1PercStocks IRA2PercStocks IRA3PercStocks *Inher*
isid h7hhid
save "$CleanData/IRAStocks`year'.dta", replace
merge 1:m h7hhid using "$CleanData/temp1`year'.dta"
ren _m StockInheritance

/************************************
	DEFINE STOCK WEALTH
************************************/
gen IRA1StockWealth_NoImpute_`year'=IRA_1_Val_`year'*(IRA1PercStocks/100) if IRAVal_1_Imp_`year'==1 | IRAVal_1_Imp_`year'==6
gen IRA2StockWealth_NoImpute_`year'=IRA_2_Val_`year'*(IRA2PercStocks/100) if IRAVal_2_Imp_`year'==1 | IRAVal_2_Imp_`year'==6
gen IRA3StockWealth_NoImpute_`year'=IRA_3_Val_`year'*(IRA3PercStocks/100) if IRAVal_3_Imp_`year'==1 | IRAVal_3_Imp_`year'==6
gen IRAStockWealth_NoImpute_`year'=IRA1StockWealth_NoImpute_`year' + IRA2StockWealth_NoImpute_`year' + IRA3StockWealth_NoImpute_`year'

gen IRA1StockWealth_WithImpute_`year'=IRA_1_Val_`year'*(IRA1PercStocks/100) if IRAVal_1_Imp_`year'==1 | IRAVal_1_Imp_`year'==2 | IRAVal_1_Imp_`year'==3 | IRAVal_1_Imp_`year'==6
gen IRA2StockWealth_WithImpute_`year'=IRA_2_Val_`year'*(IRA2PercStocks/100) if IRAVal_2_Imp_`year'==1 | IRAVal_2_Imp_`year'==2 | IRAVal_2_Imp_`year'==3 | IRAVal_2_Imp_`year'==6
gen IRA3StockWealth_WithImpute_`year'=IRA_3_Val_`year'*(IRA3PercStocks/100) if IRAVal_3_Imp_`year'==1 | IRAVal_3_Imp_`year'==2 | IRAVal_3_Imp_`year'==3 | IRAVal_3_Imp_`year'==6
gen IRAStockWealth_WithImpute_`year'=IRA1StockWealth_WithImpute_`year' + IRA2StockWealth_WithImpute_`year' + IRA3StockWealth_WithImpute_`year'

gen WealthInStocks_NoImpute_`year'=IRAStockWealth_NoImpute_`year' + StockVal_`year' if StockContVal_`year'==1
gen WealthInStocks_WithImpute_`year'=IRAStockWealth_WithImpute_`year' + StockVal_`year' if StockImpVal_`year'==1

gen RiskyWeight1_NoImpute_`year'=WealthInStocks_NoImpute_`year'/FinWealth_NoImpute_`year'
gen RiskyWeight1_WithImpute_`year'=WealthInStocks_WithImpute_`year'/FinWealth_WithImpute_`year'

gen RiskyWeight1_NoImputeNoH_`year'=WealthInStocks_NoImpute_`year'/(FinWealth_NoImpute_`year'-HouseVal_`year'+MortgVal_`year'-HouseVal2_`year'+SecMortgVal_`year'+HmLnVal_`year') ///
    if HouseContVal_`year'==1 & MortgContVal_`year'==1 & House2ContVal_`year'==1 & SecMortgContVal_`year'==1 & HmLnContVal_`year'==1
gen RiskyWeight1_WithImputeNoH_`year'=WealthInStocks_WithImpute_`year'/(FinWealth_WithImpute_`year'-HouseVal_`year'+MortgVal_`year'-HouseVal2_`year'+SecMortgVal_`year'+HmLnVal_`year') ///
    if HouseImpVal_`year'==1 & MortgImpVal_`year'==1  & House2ImpVal_`year'==1 & SecMortgImpVal_`year'==1 & HmLnImpVal_`year'==1

gen RiskyWeight1_NoImputeBus_`year'  =(WealthInStocks_NoImpute_`year'+BusVal_`year')/FinWealth_NoImpute_`year' if BusContVal_`year'==1
gen RiskyWeight1_WithImputeBus_`year'=(WealthInStocks_WithImpute_`year'+BusVal_`year')/FinWealth_WithImpute_`year' if BusImpVal_`year'==1

gen FinWealth_NoImputeNoH_`year'  =FinWealth_NoImpute_`year'  -(HouseVal_`year'-MortgVal_`year'-HmLnVal_`year'+HouseVal2_`year'-SecMortgVal_`year') ///
    if HouseContVal_`year' == 1 & MortgContVal_`year' == 1 & HmLnContVal_`year' == 1 & House2ContVal_`year' == 1 & SecMortgContVal_`year' ==1
gen FinWealth_WithImputeNoH_`year'=FinWealth_WithImpute_`year'-(HouseVal_`year'-MortgVal_`year'-HmLnVal_`year'+HouseVal2_`year'-SecMortgVal_`year') ///
    if HouseImpVal_`year' == 1 & MortgImpVal_`year' == 1 & HmLnImpVal_`year' == 1 & House2ImpVal_`year' == 1 & SecMortgImpVal_`year' ==1
    	
sort hhidpn
drop if PN==""

keep HHID SUBHH PN FinWealth_NoImpute_`year' FinWealth_WithImpute_`year' FinWealth_WithImputeNoH_`year' WealthInStocks_WithImpute_`year' RecInher_1_`year' RecInher_2_`year' ///
     RecInher_3_`year' InherAmt_1_`year' InherAmt_2_`year' InherAmt_3_`year' BusVal_`year' IRAVal_`year' StockVal_`year' CashVal_`year' CDVal_`year' BondVal_`year' ///
	 OtherAssetVal_`year' OtherDebtVal_`year' TrustVal_`year' HouseVal_`year' MortgVal_`year' HmLnVal_`year' HouseVal2_`year' SecMortgVal_`year' BusVal_Imp_`year' ///
	 HasHouse_`year' HasHouse2_`year' NetHomeVal_`year' RetIncMarketVal_`year' RealEstateVal_`year' SSMarketVal_`year' PenMarketVal_`year' TransVal_`year' HasBusVal_`year'

save "$CleanData/RANDWealth`year'.dta", replace							   
						   
						   

