*********************************************
* Get Cross Sectional Characteristics
*********************************************


************************************************************
* This file loads polygenic scores from two publicly available sources:
*   1) The SSGAC's Public Release of the Educational Attainment Score from 
*      the Lee et al (2018) paper in Nature Genetics,
*
*   2) The Version 3 Release of the Polygenic Score file from the HRS.
* 
************************************************************


* First, load in EA3 (Lee et al 2018) score:
clear all
insheet using "$EA3ScoreDir\Lee_et_al_(2018)_PGS_HRS.txt"

rename hhid HHIDNum
rename pn   PNNum

* Rename the principal components to make the names consistent with previously
* written code.  There is no substantive reason for this:

forvalues pind=1(1)10{
	rename pc`pind' ev`pind'
}

keep HHIDNum PNNum pgs_ea3_gwas ev*

save "$CleanData\EA3_LeeEtAl.dta", replace


clear all
use "$HRSPGS3Dir\PGENSCORE3E_R.dta"

destring HHID, gen(HHIDNum)
destring PN, gen(PNNum)

* Rename the HRS principal components to make them easier to loop over / call
* in commands:

		rename PC1_5A    fv1
		rename PC1_5B    fv2
		rename PC1_5C    fv3
		rename PC1_5D    fv4
		rename PC1_5E    fv5
		rename PC6_10A   fv6
		rename PC6_10B   fv7
		rename PC6_10C   fv8
		rename PC6_10D   fv9
		rename PC6_10E   fv10

* merge with the cleaned EA3 score:
merge 1:1 HHIDNum PNNum using "$CleanData\EA3_LeeEtAl.dta", gen (EA3Merge)


keep HHIDNum PNNum EA_PGS3_EDU2_SSGAC16 EA_PGS3_EDU3_SSGAC18 pgs_ea3_gwas ev* fv*

egen EA3Score=std(pgs_ea3_gwas)
egen EA2Score=std(EA_PGS3_EDU2_SSGAC16)
egen EA3ScoreHRS=std(EA_PGS3_EDU3_SSGAC18)	


save "$CleanData\GenesWealth_PGS.dta", replace



clear all


*********************************************
* Load the Cross-Wave Tracker File
* to get basic demographics and Identifiers
*********************************************

clear all

use "$Tracker16\HRS_Tracker16.dta"


destring HHID, gen(HHIDNum)
destring PN, gen(PNNum)

* Male Binary:
gen Male=.
replace Male=1 if GENDER==1
replace Male=0 if GENDER==2

* Clean School Years:
gen Educ=SCHLYRS
	replace Educ=. if Educ>=99
	
* Merge with the PGS File:

merge 1:1 HHIDNum PNNum using "$CleanData\GenesWealth_PGS.dta", gen(GW_PGS_Merge)	

keep HHID PN HHIDNum PNNum EA3Score EA2Score EA3ScoreHRS ev* fv* Male Educ DEGREE BIRTHYR *SUBHH *INSAMP *FINR *WGTR *COUPLE *PPN RACE *ALIVE EXDEATHYR

merge 1:1 HHID PN using "$CleanData/HRS_YearRetired.dta", gen(TempMerge)
drop if TempMerge==2

drop TempMerge

save "$CleanData\GenesWealth_CrossSectionVars.dta", replace

clear all	


use "$Tracker16\HRS_Tracker16.dta" 

keep HHID PN *SUBHH *INSAMP 

expand 11

bys HHID PN: gen WaveCounter=_n

gen YEAR=.
replace YEAR=1992 if WaveCounter==1
replace YEAR=1994 if WaveCounter==2
replace YEAR=1996 if WaveCounter==3
replace YEAR=1998 if WaveCounter==4
replace YEAR=2000 if WaveCounter==5
replace YEAR=2002 if WaveCounter==6
replace YEAR=2004 if WaveCounter==7
replace YEAR=2006 if WaveCounter==8
replace YEAR=2008 if WaveCounter==9
replace YEAR=2010 if WaveCounter==10
replace YEAR=2012 if WaveCounter==11

	* Clean the identifiers (destring them), and create hhipdn as a combintion numeric:

gen SUBHH="."
		replace SUBHH=ASUBHH if YEAR==1992
		replace SUBHH=CSUBHH if YEAR==1994
		replace SUBHH=ESUBHH if YEAR==1996
		replace SUBHH=FSUBHH if YEAR==1998
		replace SUBHH=GSUBHH if YEAR==2000
		replace SUBHH=HSUBHH if YEAR==2002
		replace SUBHH=JSUBHH if YEAR==2004
		replace SUBHH=KSUBHH if YEAR==2006
		replace SUBHH=LSUBHH if YEAR==2008
		replace SUBHH=MSUBHH if YEAR==2010
		replace SUBHH=NSUBHH if YEAR==2012
		
gen InSamp=0
		replace InSamp=1 if YEAR==1992 & AINSAMP==1
		replace InSamp=1 if YEAR==1994 & CINSAMP==1
		replace InSamp=1 if YEAR==1996 & EINSAMP==1
		replace InSamp=1 if YEAR==1998 & FINSAMP==1
		replace InSamp=1 if YEAR==2000 & GINSAMP==1
		replace InSamp=1 if YEAR==2002 & HINSAMP==1
		replace InSamp=1 if YEAR==2004 & JINSAMP==1
		replace InSamp=1 if YEAR==2006 & KINSAMP==1
		replace InSamp=1 if YEAR==2008 & LINSAMP==1
		replace InSamp=1 if YEAR==2010 & MINSAMP==1
		replace InSamp=1 if YEAR==2012 & NINSAMP==1		
		
gen InSampFull=.
		replace InSampFull=AINSAMP if YEAR==1992
		replace InSampFull=CINSAMP if YEAR==1994
		replace InSampFull=EINSAMP if YEAR==1996
		replace InSampFull=FINSAMP if YEAR==1998
		replace InSampFull=GINSAMP if YEAR==2000
		replace InSampFull=HINSAMP if YEAR==2002
		replace InSampFull=JINSAMP if YEAR==2004
		replace InSampFull=KINSAMP if YEAR==2006
		replace InSampFull=LINSAMP if YEAR==2008
		replace InSampFull=MINSAMP if YEAR==2010
		replace InSampFull=NINSAMP if YEAR==2012


keep HHID PN SUBHH InSamp InSampFull YEAR

bys HHID PN SUBHH: gen Counter=_n
gen Temp=(Counter==1)
bys HHID SUBHH: egen NumUniqueRespondents=total(Temp)
bys HHID SUBHH: gen SUBHHCounter=_n
tab NumUniqueRespondents if SUBHHCounter==1

gen OneOrTwoPersonHH=(NumUniqueRespondents==1 | NumUniqueRespondents==2)


save "$CleanData\HHIDPNPanel.dta", replace

keep if SUBHHCounter==1

keep HHID SUBHH NumUniqueRespondents 

save "$CleanData\SUBHHNumResp.dta", replace

clear all

		
*************************************
* Children
*************************************		
		
		
* Load 1992 Data:

clear all

infile using "$HRSSurveys92/h92sta/KIDS.dct" , using("$HRSSurveys92/h92da/KIDS.da")

bys HHID ASUBHH: gen NumKids1992=_N
bys HHID ASUBHH: gen Counter=_n

keep if Counter==1

keep HHID ASUBHH NumKids1992

save "$CleanData/HRSNumKids_Module92.dta", replace


clear all

infile using "$HRSSurveys92/h92sta/HHList.dct" , using("$HRSSurveys92/h92da/HHList.da")

merge m:1 HHID ASUBHH using "$CleanData/HRSNumKids_Module92.dta", gen(KidsMerge92)

replace NumKids1992=0 if KidsMerge92==1

tab NumKids1992,m

bys HHID ASUBHH: gen Counter=_n

keep if Counter==1

keep HHID ASUBHH NumKids1992

save "$CleanData/HRSNumChild92.dta", replace


* Note - there is not a comparable "Number of Children Ever Born" Variable in the 1994 Wave


* Load 1996 Data:

/* Demographic Variables from 1996  */
clear all
infile using "$HRSSurveys96/h96sta/H96A_R.dct" , using("$HRSSurveys96/h96da/H96A_R.da")

gen NumChildEver_96=E668

keep HHID PN *96

gen YEAR=1996

save "$CleanData/HRSNumChild96.dta", replace

/* 1998   */
clear all
infile using "$HRSSurveys98/h98sta/H98A_R.dct" , using("$HRSSurveys98/h98da/H98A_R.da")


gen NumChildEver_98=F1006

keep HHID PN *98

gen YEAR=1998

save "$CleanData/HRSNumChild98.dta", replace



/* Demographic Variables from 2000 - New Format */
clear all
infile using "$HRSSurveys00/h00sta/H00A_R.dct" , using("$HRSSurveys00/h00da/H00A_R.da")

gen NumChildEver_00=G1093

keep HHID PN *00

gen YEAR=2000

save "$CleanData/HRSNumChild00.dta", replace


/* Demographic Variables from 2002 - New Format */
clear all
infile using "$HRSSurveys02/h02sta/H02B_R.dct" , using("$HRSSurveys02/h02da/H02B_R.da")

gen NumChildEver_02=HB033

keep HHID PN *02

gen YEAR=2002

save "$CleanData/HRSNumChild02.dta", replace


/* Demographic Variables from 2004 - New Format */
clear all
infile using "$HRSSurveys04/h04sta/H04B_R.dct" , using("$HRSSurveys04/h04da/H04B_R.da")

gen NumChildEver_04=JB033

keep HHID PN *04

gen YEAR=2004

save "$CleanData/HRSNumChild04.dta", replace


/* Demographic Variables from 2006 - New Format */
clear all
infile using "$HRSSurveys06/h06sta/H06B_R.dct" , using("$HRSSurveys06/h06da/H06B_R.da")

gen NumChildEver_06=KB033

keep HHID PN *06

gen YEAR=2006

save "$CleanData/HRSNumChild06.dta", replace


/* Demographic Variables from 2008 - New Format */
clear all
infile using "$HRSSurveys08/h08sta/H08B_R.dct" , using("$HRSSurveys08/h08da/H08B_R.da")

gen NumChildEver_08=LB033

keep HHID PN *08

gen YEAR=2008

save "$CleanData/HRSNumChild08.dta", replace


/* Demographic Variables from 2010 - New Format */
clear all
infile using "$HRSSurveys10/h10sta/H10B_R.dct" , using("$HRSSurveys10/h10da/H10B_R.da")

gen NumChildEver_10=MB033

keep HHID PN *10

gen YEAR=2010

save "$CleanData/HRSNumChild10.dta", replace


/* Demographic Variables from 2012 - New Format */
clear all
infile using "$HRSSurveys12/h12sta/H12B_R.dct" , using("$HRSSurveys12/h12da/H12B_R.da")

gen NumChildEver_12=NB033

keep HHID PN *12

gen YEAR=2012

save "$CleanData/HRSNumChild12.dta", replace


clear all

use "$Tracker16\HRS_Tracker16.dta" 

merge m:1 HHID ASUBHH using  "$CleanData/HRSNumChild92.dta"

foreach YR in 96 98 00 02 04 06 08 10 12 {
	merge 1:1 HHID PN using "$CleanData/HRSNumChild`YR'.dta", gen(Merge`YR')
}

gen NumChildEver=.

replace NumChildEver=NumKids1992 if NumKids1992~=.

foreach YR in 96 98 00 02 04 06 08 10 12 {
	replace NumChildEver=NumChildEver_`YR' if NumChildEver==. & NumChildEver_`YR'~=. & NumChildEver_`YR'<98
	replace NumChildEver=NumChildEver_`YR' if NumChildEver~=. & NumChildEver_`YR'~=. & NumChildEver_`YR'<98 & (NumChildEver_`YR'>NumChildEver)
}


keep HHID PN NumChildEver

save "$CleanData/HRSNumChildEver.dta", replace		
		

***********************************************************
* Get total number of children from the RAND Family File
***********************************************************

clear all
use "$RandFamDir\randhrsfamr1992_2014v1.dta" 

foreach var in own step oth {
	egen RAND_`var'Kids=rowmax(r1`var'kidkn r2`var'kidkn r3`var'kidkn r4`var'kidkn r5`var'kidkn r6`var'kidkn r7`var'kidkn r8`var'kidkn r9`var'kidkn r10`var'kidkn r11`var'kidkn)
}

egen RAND_TotKids=rowtotal(RAND_ownKids RAND_stepKids RAND_othKids), missing

tostring hhidpn, gen(HHIDPNString)
gen StringLength=length(HHIDPNString)
replace HHIDPNString="0"+HHIDPNString if StringLength==8

gen HHID=substr(HHIDPNString,1,6)
gen PN=substr(HHIDPNString,7,3)

drop if PN==""

keep HHID PN RAND_TotKids RAND_ownKids RAND_stepKids RAND_othKids


sum

save "$CleanData\HRS_RANDNumKids.dta", replace


clear all

use "$RandFamDir\randhrsfamk1992_2014v1.dta" 


bys hhidpn opn: gen Counter=_n

drop if Counter==2

bys hhidpn: gen RAND_TotKidsOPN=_N

tostring hhidpn, gen(HHIDPNString)
gen StringLength=length(HHIDPNString)
replace HHIDPNString="0"+HHIDPNString if StringLength==8

gen HHID=substr(HHIDPNString,1,6)
gen PN=substr(HHIDPNString,7,3)

drop if PN==""

keep HHID PN RAND_TotKidsOPN

bys HHID PN: gen Counter=_n

keep if Counter==1

keep HHID PN RAND_TotKidsOPN

save "$CleanData\HRS_RANDNumKidsOPN.dta", replace



clear all


use "$CleanData\HRS_RANDNumKids.dta"
merge 1:1 HHID PN using "$CleanData\HRS_RANDNumKidsOPN.dta", gen(RANDKidsMerge)
merge 1:1 HHID PN using "$CleanData\HRSNumChildEver.dta", gen(HRSKidsMerge)
merge 1:1 HHID PN using "$CleanData\HRSParentsEduc.dta", gen(HRSParentsEducMerge)

gen TotKids=RAND_TotKids
replace TotKids=NumChildEver    if RAND_TotKids==. & NumChildEver~=.

gen TotKidsOPN=RAND_TotKidsOPN
replace TotKidsOPN=NumChildEver if RAND_TotKidsOPN==. & NumChildEver~=.

keep HHID PN RAND_TotKidsOPN RAND_TotKids NumChildEver TotKids TotKidsOPN FatherEdu* MotherEdu* FEMiss MEMiss

save "$CleanData\GenesWealth_NumKids.dta", replace


clear all

use "$CleanData\GenesWealth_CrossSectionVars.dta"

merge 1:1 HHID PN using "$CleanData\GenesWealth_NumKids.dta", gen(KidsMerge)
	drop if KidsMerge==2
merge 1:1 HHID PN using "$CleanData\HRS_YearRetired.dta", gen(RetireMerge)
	drop if RetireMerge==2

drop KidsMerge RetireMerge

save "$CleanData\GenesWealth_CrossSectionVars.dta", replace

