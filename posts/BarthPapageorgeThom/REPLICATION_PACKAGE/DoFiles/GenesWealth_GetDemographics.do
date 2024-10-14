
/* Demographics - 1992  */

clear all

infile using "$HRSSurveys92/h92sta/HEALTH.dct" , using("$HRSSurveys92/h92da/HEALTH.da")

gen RegionBorn_92=V205

gen MotherEduc_92=V212
	replace MotherEduc=. if MotherEduc>=98
	
/*         212     A4.     What is the highest grade of school your mother
                        completed? [IF DK, PROBE:  What would be your best
                        guess?]
                ____________________________________________________________

                        Code grade (00-17)

                        98.     DK
                        99.     NA */	
	
	
gen FatherEduc_92=V213
	replace FatherEduc=. if FatherEduc>=98

/*         213     A5.     And what is the highest grade of school your father
                        completed? [IF DK, PROBE:  What would be your best
                        guess?]
                ____________________________________________________________

                        Code grade (00-17)

                        98.     DK
                        99.     NA  */	
	
gen ReligionDenom_92=V214

	gen ReligCat_92=.
		replace ReligCat_92=1  if ReligionDenom>=1   & ReligionDenom<=10
		replace ReligCat_92=2  if ReligionDenom>=11  & ReligionDenom<=20
		replace ReligCat_92=3  if ReligionDenom>=21  & ReligionDenom<=40
		replace ReligCat_92=4  if ReligionDenom>=41  & ReligionDenom<=50
		replace ReligCat_92=5  if ReligionDenom>=51  & ReligionDenom<=60
		replace ReligCat_92=6  if ReligionDenom>=61  & ReligionDenom<=70
		replace ReligCat_92=7  if ReligionDenom==71  
		replace ReligCat_92=8  if ReligionDenom>=81  & ReligionDenom<=90
		replace ReligCat_92=9  if ReligionDenom>=91  & ReligionDenom<=97

/* See 	Codes in Codebook, 1-10, Reformation Protestant
                           11-20, Pietistic Protestant
						   21-40, Fundamentalist Protestant
						   41-50, General Protestant
						   51-60, Catholic / Orthodox 
						   61-70, Nontraditional Christian 
						   71     Jewish
						   81-90, Non Judeo-Christian
						   91-97, No Religion
						   98,    DK / NA
						   99,    Refused */
						   
		
		
gen ReligionAttend_92=V215
	
keep HHID PN *92

gen YEAR=1992

save "$CleanData/HRSDemo92.dta", replace



/* Demographic Variables from 1994 */

clear all
infile using "$HRSSurveys94/h94sta/W2A.dct" , using("$HRSSurveys94/h94da/W2A.da")


gen RegionBorn_94=W216

gen ReligionDenom_94=W226

	gen ReligCat_94=.
		replace ReligCat_94=1  if ReligionDenom>=1   & ReligionDenom<=10
		replace ReligCat_94=2  if ReligionDenom>=11  & ReligionDenom<=20
		replace ReligCat_94=3  if ReligionDenom>=21  & ReligionDenom<=40
		replace ReligCat_94=4  if ReligionDenom>=41  & ReligionDenom<=50
		replace ReligCat_94=5  if ReligionDenom>=51  & ReligionDenom<=60
		replace ReligCat_94=6  if ReligionDenom>=61  & ReligionDenom<=70
		replace ReligCat_94=7  if ReligionDenom==71  
		replace ReligCat_94=8  if ReligionDenom>=81  & ReligionDenom<=90
		replace ReligCat_94=9  if ReligionDenom>=91  & ReligionDenom<=97

/* See 	Codes in Codebook, 1-10, Reformation Protestant
                           11-20, Pietistic Protestant
						   21-40, Fundamentalist Protestant
						   41-50, General Protestant
						   51-60, Catholic / Orthodox 
						   61-70, Nontraditional Christian 
						   71     Jewish
						   81-90, Non Judeo-Christian
						   91-97, No Religion
						   98,    DK / NA
						   99,    Refused */


gen ReligionAttend_94=W227


keep HHID PN *94

gen YEAR=1994

save "$CleanData/HRSDemo94.dta", replace



/* Demographic Variables from 1996  */

clear all
infile using "$HRSSurveys96/h96sta/H96A_R.dct" , using("$HRSSurveys96/h96da/H96A_R.da")


gen RegionBorn_96=E640M

/* 
E640M     A2A. REGION - US BORN                     
          Section: A            Level: Respondent      CAI Reference: Q19062
          Type: Numeric         Width: 2               Decimals: 0  */

gen RegionSch_96 =E715M

/* E715M     A27. REGION WHERE LIVE WHEN IN SCH-MASKE  
          Section: A            Level: Respondent      CAI Reference: Q19066
          Type: Numeric         Width: 2               Decimals: 0

          A27. In what state or country did you live most of the time you were (in
          grade school/in high school/about age 10)? */
		  

gen MotherEduc8_96=E654

/* E654      A4.MOTHER EDUC                            
          Section: A            Level: Respondent      CAI Reference: Q654
          Type: Numeric         Width: 1               Decimals: 0

          A4. Did your mother attend 8 years or more of school?  */

gen FatherEduc8_96=E655

/* E655      A5.FATHER EDUC                            
          Section: A            Level: Respondent      CAI Reference: Q655
          Type: Numeric         Width: 1               Decimals: 0

          A5. Did your father attend 8 years or more of school? */


gen RuralChildhood_96=E718

/* E718      A28.LIVE IN CITY/TOWN/RURAL               
          Section: A            Level: Respondent      CAI Reference: Q718
          Type: Numeric         Width: 1               Decimals: 0

          A28. Were you living in a rural area most of the time when you were (in
          grade school/in high school/about age 10)? */

		  
		  
gen Religion_96=E732
gen ReligionDenom_96=E733
gen ReligionImport_98=E735

/* See codebook for religious codes - they are different from 1992 / 1994 coding */

keep HHID PN *96

gen YEAR=1996

save "$CleanData/HRSDemo96.dta", replace



/* Demographic Variables from 1998 - New Format */
clear all
infile using "$HRSSurveys98/h98sta/H98A_R.dct" , using("$HRSSurveys98/h98da/H98A_R.da")

*******************************
* Region Born / Went to School
*******************************
gen RegionBorn_98    =F972M
gen RegionSch_98     =F1035M
gen RuralChildhood_98=F1038

********************************************
* Family SES / Family Background Variables: 
********************************************
gen HealthChild_98    =F992
gen FamilySES_98      =F993
gen FamDiff_Move_98   =F994
gen FamDiff_Help_98   =F995
gen FamDiff_FUnemp_98 =F996
gen FatherUsOcc_98    =F997HM
* Note there are two Father Occupation Variables - F997HM and F997AM.  The 
* F997AM variable uses a coding scheme with fewer categories and is for the 
* AHEAD respondents.  However, all individuals with a non-missing entry for
* F997AM have a non-missing value for F997HM, so we will use that variable, since
* it is more detailed.  
gen FatherEduc_98=F1000
gen MotherEduc_98=F1001

**********************************************
* Religion Variables 
**********************************************

gen Religion_98=F1052
gen ReligionDenom_98=F1053M
gen ReligionImport_98=F1055


keep HHID PN *98

gen YEAR=1998

save "$CleanData/HRSDemo98.dta", replace


/* Demographic Variables from 2000 - New Format */
clear all
infile using "$HRSSurveys00/h00sta/H00A_R.dct" , using("$HRSSurveys00/h00da/H00A_R.da")


*******************************
* Region Born / Went to School
*******************************
gen RegionBorn_00    =G1061M
gen RegionSch_00     =G1122M
gen RuralChildhood_00=G1125

********************************************
* Family SES / Family Background Variables: 
********************************************
gen HealthChild_00    =G1079
gen FamilySES_00      =G1080
gen FamDiff_Move_00   =G1081
gen FamDiff_Help_00   =G1082
gen FamDiff_FUnemp_00 =G1083
gen FatherUsOcc_00    =G1084M
* Note there are two Father Occupation Variables - F997HM and F997AM.  The 
* F997AM variable uses a coding scheme with fewer categories and is for the 
* AHEAD respondents.  However, all individuals with a non-missing entry for
* F997AM have a non-missing value for F997HM, so we will use that variable, since
* it is more detailed.  
gen FatherEduc_00=G1087
gen MotherEduc_00=G1088

**********************************************
* Religion Variables 
**********************************************

gen Religion_00=G1139
gen ReligionDenom_00=G1140M
gen ReligionImport_00=G1142


keep HHID PN *00

gen YEAR=2000

save "$CleanData/HRSDemo00.dta", replace




/* Demographic Variables from 2002 - New Format */
clear all
infile using "$HRSSurveys02/h02sta/H02B_R.dct" , using("$HRSSurveys02/h02da/H02B_R.da")


*******************************
* Region Born / Went to School
*******************************
gen RegionBorn_02    =HB003M
gen RegionSch_02     =HB047M
gen RuralChildhood_02=HB049

********************************************
* Family SES / Family Background Variables: 
********************************************
gen HealthChild_02    =HB019
gen FamilySES_02      =HB020
gen FamDiff_Move_02   =HB021
gen FamDiff_Help_02   =HB022
gen FamDiff_FUnemp_02 =HB023
gen FatherUsOcc_02    =HB024M
*  Parental Education Variables  
gen FatherEduc_02=HB026
gen MotherEduc_02=HB027

**********************************************
* Religion Variables 
**********************************************

gen Religion_02=HB050
gen ReligionDenom_02=HB052M
gen ReligionImport_02=HB053


keep HHID PN *02

gen YEAR=2002

save "$CleanData/HRSDemo02.dta", replace




/* Demographic Variables from 2004 - New Format */
clear all
infile using "$HRSSurveys04/h04sta/H04B_R.dct" , using("$HRSSurveys04/h04da/H04B_R.da")


*******************************
* Region Born / Went to School
*******************************
gen RegionBorn_04    =JB003M
gen RegionSch_04     =JB047M
gen RuralChildhood_04=JB049

********************************************
* Family SES / Family Background Variables: 
********************************************
gen HealthChild_04    =JB019
gen FamilySES_04      =JB020
gen FamDiff_Move_04   =JB021
gen FamDiff_Help_04   =JB022
gen FamDiff_FUnemp_04 =JB023
gen FatherUsOcc_04    =JB024M
*  Parental Education Variables  
gen FatherEduc_04=JB026
gen MotherEduc_04=JB027

**********************************************
* Religion Variables 
**********************************************

gen Religion_04=JB050
gen ReligionDenom_04=JB052M
gen ReligionImport_04=JB053


keep HHID PN *04

gen YEAR=2004

save "$CleanData/HRSDemo04.dta", replace



/* Demographic Variables from 2006 - New Format */
clear all
infile using "$HRSSurveys06/h06sta/H06B_R.dct" , using("$HRSSurveys06/h06da/H06B_R.da")


*******************************
* Region Born / Went to School
*******************************
gen RegionBorn_06    =KB003M
gen RegionSch_06     =KB047M
gen RuralChildhood_06=KB049

********************************************
* Family SES / Family Background Variables: 
********************************************
gen HealthChild_06    =KB019
gen FamilySES_06      =KB020
gen FamDiff_Move_06   =KB021
gen FamDiff_Help_06   =KB022
gen FamDiff_FUnemp_06 =KB023
gen FatherUsOcc_06    =KB024M
*  Parental Education Variables  
gen FatherEduc_06=KB026
gen MotherEduc_06=KB027

**********************************************
* Religion Variables 
**********************************************

gen Religion_06=KB050
gen ReligionDenom_06=KB052M
gen ReligionImport_06=KB053

keep HHID PN *06

gen YEAR=2006

save "$CleanData/HRSDemo06.dta", replace



/* Demographic Variables from 2008 - New Format */
clear all
infile using "$HRSSurveys08/h08sta/H08B_R.dct" , using("$HRSSurveys08/h08da/H08B_R.da")


*******************************
* Region Born / Went to School
*******************************
gen RegionBorn_08    =LB003M
gen RegionSch_08     =LB047M
gen RuralChildhood_08=LB049

********************************************
* Family SES / Family Background Variables: 
********************************************
gen HealthChild_08    =LB019
gen FamilySES_08      =LB020
gen FamDiff_Move_08   =LB021
gen FamDiff_Help_08   =LB022
gen FamDiff_FUnemp_08 =LB023
gen FatherUsOcc_08    =LB024M
*  Parental Education Variables  
gen FatherEduc_08=LB026
gen MotherEduc_08=LB027

**********************************************
* Religion Variables 
**********************************************

gen Religion_08=LB050
gen ReligionDenom_08=LB052M
gen ReligionImport_08=LB053


/* Now, look at more detailed Childhood health variables */

gen CH_MissSchool_08=LB099
gen CH_Measles_08   =LB100
gen CH_Mumps_08     =LB101
gen CH_CPox_08      =LB102
gen CH_Sight_08     =LB103
gen CH_ParSmoke_08  =LB104
gen CH_Asthma_08    =LB105
gen CH_Diabetes_08  =LB106
gen CH_Resp_08      =LB107
gen CH_Speech_08    =LB108
gen CH_Allergy_08   =LB109
gen CH_Heart_08     =LB110
gen CH_Ear_08       =LB111
gen CH_Epilepsy_08  =LB112
gen CH_Migraines_08 =LB113
gen CH_Stomach_08   =LB114
gen CH_BloodP_08    =LB115
gen CH_Depression_08=LB116
gen CH_Drugs_08     =LB117
gen CH_Psych_08     =LB118
gen CH_Concuss_08   =LB119
gen CH_Disable_08   =LB120
gen CH_Smoke_08     =LB122
gen CH_Learn_08     =LB123
gen CH_Other_08     =LB124



keep HHID PN *08

gen YEAR=2008

save "$CleanData/HRSDemo08.dta", replace


/* Demographic Variables from 2010 - New Format */
clear all
infile using "$HRSSurveys10/h10sta/H10B_R.dct" , using("$HRSSurveys10/h10da/H10B_R.da")


*******************************
* Region Born / Went to School
*******************************
gen RegionBorn_10    =MB003M
gen RegionSch_10     =MB047M
gen RuralChildhood_10=MB049

********************************************
* Family SES / Family Background Variables: 
********************************************
gen HealthChild_10    =MB019
gen FamilySES_10      =MB020
gen FamDiff_Move_10   =MB021
gen FamDiff_Help_10   =MB022
gen FamDiff_FUnemp_10 =MB023
gen FatherUsOcc_10    =MB024M
*  Parental Education Variables  
gen FatherEduc_10=MB026
gen MotherEduc_10=MB027

**********************************************
* Religion Variables 
**********************************************

gen Religion_10=MB050
gen ReligionDenom_10=MB052M
gen ReligionImport_10=MB053


/* Now, look at more detailed Childhood health variables */

gen CH_MissSchool_10=MB099
gen CH_Measles_10   =MB100
gen CH_Mumps_10     =MB101
gen CH_CPox_10      =MB102
gen CH_Sight_10     =MB103
gen CH_ParSmoke_10  =MB104
gen CH_Asthma_10    =MB105
gen CH_Diabetes_10  =MB106
gen CH_Resp_10      =MB107
gen CH_Speech_10    =MB108
gen CH_Allergy_10   =MB109
gen CH_Heart_10     =MB110
gen CH_Ear_10       =MB111
gen CH_Epilepsy_10  =MB112
gen CH_Migraines_10 =MB113
gen CH_Stomach_10   =MB114
gen CH_BloodP_10    =MB115
gen CH_Depression_10=MB116
gen CH_Drugs_10     =MB117
gen CH_Psych_10     =MB118
gen CH_Concuss_10   =MB119
gen CH_Disable_10   =MB120
gen CH_Smoke_10     =MB122
gen CH_Learn_10     =MB123
gen CH_Other_10     =MB124


keep HHID PN *10

gen YEAR=2010

save "$CleanData/HRSDemo10.dta", replace


/* Demographic Variables from 2012 - New Format */
clear all
infile using "$HRSSurveys12/h12sta/H12B_R.dct" , using("$HRSSurveys12/h12da/H12B_R.da")


*******************************
* Region Born / Went to School
*******************************
gen RegionBorn_12    =NB003M
gen RegionSch_12     =NB047M
gen RuralChildhood_12=NB049

********************************************
* Family SES / Family Background Variables: 
********************************************
gen HealthChild_12    =NB019
gen FamilySES_12      =NB020
gen FamDiff_Move_12   =NB021
gen FamDiff_Help_12   =NB022
gen FamDiff_FUnemp_12 =NB023
gen FatherUsOcc_12    =NB024M
*  Parental Education Variables  
gen FatherEduc_12=NB026
gen MotherEduc_12=NB027

**********************************************
* Religion Variables 
**********************************************

gen Religion_12=NB050
gen ReligionDenom_12=NB052M
gen ReligionImport_12=NB053


/* Now, look at more detailed Childhood health variables */

gen CH_MissSchool_12=NB099
gen CH_Measles_12   =NB100
gen CH_Mumps_12     =NB101
gen CH_CPox_12      =NB102
gen CH_Sight_12     =NB103
gen CH_ParSmoke_12  =NB104
gen CH_Asthma_12    =NB105
gen CH_Diabetes_12  =NB106
gen CH_Resp_12      =NB107
gen CH_Speech_12    =NB108
gen CH_Allergy_12   =NB109
gen CH_Heart_12     =NB110
gen CH_Ear_12       =NB111
gen CH_Epilepsy_12  =NB112
gen CH_Migraines_12 =NB113
gen CH_Stomach_12   =NB114
gen CH_BloodP_12    =NB115
gen CH_Depression_12=NB116
gen CH_Drugs_12     =NB117
gen CH_Psych_12     =NB118
gen CH_Concuss_12   =NB119
gen CH_Disable_12   =NB120
gen CH_Smoke_12     =NB122
gen CH_Learn_12     =NB123
gen CH_Other_12     =NB124


keep HHID PN *_12

gen YEAR=2012

save "$CleanData/HRSDemo12.dta", replace





/**************************************
***************************************
  Here we merge the Demographic Files
***************************************
***************************************/
clear all
use "$CleanData/HRSDemo92.dta"
merge 1:1 HHID PN using "$CleanData/HRSDemo94.dta", gen (Merge94)
merge 1:1 HHID PN using "$CleanData/HRSDemo96.dta", gen (Merge96)
merge 1:1 HHID PN using "$CleanData/HRSDemo98.dta", gen (Merge98)
merge 1:1 HHID PN using "$CleanData/HRSDemo00.dta", gen (Merge00)
merge 1:1 HHID PN using "$CleanData/HRSDemo02.dta", gen (Merge02)
merge 1:1 HHID PN using "$CleanData/HRSDemo04.dta", gen (Merge04)
merge 1:1 HHID PN using "$CleanData/HRSDemo06.dta", gen (Merge06)
merge 1:1 HHID PN using "$CleanData/HRSDemo08.dta", gen (Merge08)
merge 1:1 HHID PN using "$CleanData/HRSDemo10.dta", gen (Merge10)
merge 1:1 HHID PN using "$CleanData/HRSDemo12.dta", gen (Merge12)



gen FatherEduc=.
gen MotherEduc=.


replace FatherEduc=FatherEduc_92
replace MotherEduc=MotherEduc_92



foreach YR in 98 00 02 04 06 08 10 12  {
   foreach VAR in FatherEduc MotherEduc  {
		replace `VAR'=`VAR'_`YR' if `VAR'==. & `VAR'_`YR'~=.
   }
}



replace FatherEduc=. if FatherEduc>17
gen FatherEducWithM=FatherEduc
gen FEMiss =(FatherEduc==.)
	replace FatherEducWithM=9999 if FEMiss==1

replace MotherEduc=. if MotherEduc>17	
gen MotherEducWithM=MotherEduc
gen MEMiss=(MotherEduc==.)
	replace MotherEducWithM=9999 if MEMiss==1
	
	
	
	

keep HHID PN MotherEduc* FatherEduc* FEMiss MEMiss
	 
	 
save "$CleanData/HRSParentsEduc.dta", replace













