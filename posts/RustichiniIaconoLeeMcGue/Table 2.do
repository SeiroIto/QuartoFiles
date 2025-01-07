* Creates Table 2 of the main text
	
clear

* Upload data Data_Table_2

	
* use "/Volumes/GoogleDrive/My Drive/AResearch/Polygenic Risk Score/FinalFiles/Replication Files/Data_Table_2.dta"






********************************************************************************
********************  Drop if no data *****************************************
count if type==.
drop  if type ==.



*****************************************************************************
*****************************************************************************
* DZ twins analysis 
*****************************************************************************
*****************************************************************************
* drop if mz==1
* browse idFamily iid Twin 
drop if Twin==0

* gen uni1 = runiform()
* order idFamily iid uni1 zPGS_education member  Twin mz dz 
* gsort idFamily uni1

gen TwinOrder     = 1
replace TwinOrder = 2 if idFamily ~=idFamily[_n+1]
* order idFamily iid uni1 TwinOrder zPGS_education  member Twin  mz dz 
order idFamily iid  TwinOrder   member Twin  mz dz zPGS_education

gen Diff = idFamily*100-iid
* ci means Diff if TwinOrder==1
* ci means Diff if TwinOrder==2
* ci means uni1

* gsort dz idFamily 

order idFamily iid TwinOrder member Twin mz dz male




** Twin's variable computation *************************************************


forvalues i = 1(1)10 {
* display `i'
gen     tpc`i'                = pc`i'[_n-1]              if  TwinOrder == 2 & idFamily == idFamily[_n-1]
replace tpc`i'                = pc`i'[_n+1]              if  TwinOrder == 1 & idFamily == idFamily[_n+1]
}

gen     Tmale                = male[_n-1]              if  TwinOrder == 2 & idFamily == idFamily[_n-1]
* order idFamily iid TwinOrder member Twin mz dz male Tmale
replace Tmale                = male[_n+1]              if  TwinOrder == 1 & idFamily == idFamily[_n+1]

order idFamily iid TwinOrder member Twin mz dz male Tmale pc1 tpc1


gen     tzPGS_education     = zPGS_education[_n-1]   if  TwinOrder == 2 & idFamily == idFamily[_n-1]
replace tzPGS_education     = zPGS_education[_n+1]   if  TwinOrder == 1 & idFamily == idFamily[_n+1]

gen     tzPGS_education_m     = zPGS_education_m[_n-1]   if  TwinOrder == 2 & idFamily == idFamily[_n-1]
replace tzPGS_education_m     = zPGS_education_m[_n+1]   if  TwinOrder == 1 & idFamily == idFamily[_n+1]



gen     tzlogUSDincome_29      = zlogUSDincome_29[_n-1]    if  TwinOrder == 2 & idFamily == idFamily[_n-1]
replace tzlogUSDincome_29      = zlogUSDincome_29[_n+1]    if  TwinOrder == 1 & idFamily == idFamily[_n+1]



gen     TzlogUSDincome1      = zlogUSDincome1[_n-1]    if  TwinOrder == 2 & idFamily == idFamily[_n-1]
replace TzlogUSDincome1      = zlogUSDincome1[_n+1]    if  TwinOrder == 1 & idFamily == idFamily[_n+1]

gen     TzlogUSDincome2      = zlogUSDincome2[_n-1]    if  TwinOrder == 2 & idFamily == idFamily[_n-1]
replace TzlogUSDincome2      = zlogUSDincome2[_n+1]    if  TwinOrder == 1 & idFamily == idFamily[_n+1]


gen     TzIq                = zIq[_n-1]              if  TwinOrder == 2 & idFamily == idFamily[_n-1]
replace TzIq                = zIq[_n+1]              if  TwinOrder == 1 & idFamily == idFamily[_n+1]

gen     tzVER_IQ             = zVER_IQ[_n-1]           if  TwinOrder == 2 & idFamily == idFamily[_n-1]
replace tzVER_IQ             = zVER_IQ[_n+1]           if  TwinOrder == 1 & idFamily == idFamily[_n+1]

gen     tzPER_IQ             = zPER_IQ[_n-1]           if  TwinOrder == 2 & idFamily == idFamily[_n-1]
replace tzPER_IQ             = zPER_IQ[_n+1]           if  TwinOrder == 1 & idFamily == idFamily[_n+1]

gen     TzEduYears          = zEduYears[_n-1]        if  TwinOrder == 2 & idFamily == idFamily[_n-1]
replace TzEduYears          = zEduYears[_n+1]        if  TwinOrder == 1 & idFamily == idFamily[_n+1]

gen     TzGpa                = zGpa[_n-1]            if  TwinOrder == 2 & idFamily == idFamily[_n-1]
replace TzGpa                = zGpa[_n+1]            if  TwinOrder == 1 & idFamily == idFamily[_n+1]

gen     TClassEducation     = ClassEducation[_n-1]   if  TwinOrder == 2 & idFamily == idFamily[_n-1]
replace TClassEducation     = ClassEducation[_n+1]   if  TwinOrder == 1 & idFamily == idFamily[_n+1]

gen     Tcollege            = college[_n-1]          if  TwinOrder == 2 & idFamily == idFamily[_n-1] 
replace Tcollege            = college[_n+1]          if  TwinOrder == 1 & idFamily == idFamily[_n+1] 

gen     TMzNa               = MzNa[_n-1]             if  TwinOrder == 2 & idFamily == idFamily[_n-1] 
replace TMzNa               = MzNa[_n+1]             if  TwinOrder == 1 & idFamily == idFamily[_n+1] 

gen     TzCn                = zCn[_n-1]              if  TwinOrder == 2 & idFamily == idFamily[_n-1] 
replace TzCn                = zCn[_n+1]              if  TwinOrder == 1 & idFamily == idFamily[_n+1] 

gen     TzPa                = zPa[_n-1]              if  TwinOrder == 2 & idFamily == idFamily[_n-1] 
replace TzPa                = zPa[_n+1]              if  TwinOrder == 1 & idFamily == idFamily[_n+1] 

gen     TzNCSk_In           = zNCSk_In[_n-1]         if  TwinOrder == 2 & idFamily == idFamily[_n-1] 
replace TzNCSk_In           = zNCSk_In[_n+1]         if  TwinOrder == 1 & idFamily == idFamily[_n+1] 

** FDE and FEE computation  ****************************************************

********************************************************************************
********************************************************************************
********************************************************************************
* Aver_zPGS_education
* FDE_zPGS_education FDE_zPGS_education
* zincome_Pts  zlogUSDincome_Pts
********************************************************************************
********************************************************************************
********************************************************************************
** Averages 
gen Aver_zPGS_education = 0.5*(zPGS_education + tzPGS_education)
gen Aver_zlogUSDincome1  = 0.5*(zlogUSDincome1  + TzlogUSDincome1)
gen Aver_zIq            = 0.5*(zIq            + TzIq)
gen Aver_zEduYears      = 0.5*(zEduYears      + TzEduYears)
gen Aver_zGpa           = 0.5*(zGpa           + TzGpa)

** Fixed effects and differences
gen FEE_zPGS_education = zPGS_education - Aver_zPGS_education
gen FDE_zPGS_education = zPGS_education - tzPGS_education 

gen FEE_zlogUSDincome1   = zlogUSDincome1 - Aver_zlogUSDincome1
gen FDE_zlogUSDincome1   = zlogUSDincome1 - TzlogUSDincome1 

gen FEE_zIq             = zIq  - Aver_zIq 
gen FDE_zIq             = zIq  - TzIq  

gen FEE_zEduYears       = zEduYears  - Aver_zEduYears 
gen FDE_zEduYears       = zEduYears  - TzEduYears

gen FEE_zGpa            = zGpa  - Aver_zGpa
gen FDE_zGpa            = zGpa  - TzGpa  


********************************************************************************
* browse idFamily iid TwinOrder  member  FEE_zIq FDE_zIq zlogUSDincome TzlogUSDincome zIq TzIq zPGS_education Twin  mz dz


* GPA data: Above2: 012, 34 ABove3 0123, 4
gen Above2 = Gpa>2
gen Above3 = Gpa>3




gen BothTwins = zPGS_education !=. & tzPGS_education !=. 
gen DataGpaFE = zPGS_education !=. &  zPa !=. &  MzNa   !=. &  zCn   !=. &  MzExt   !=. &  zEffort_17    !=. & MzAcadprobs_17   !=.
gen DataIQFE = zPGS_education !=. &  zPa !=. &  MzNa   !=. &  zCn   !=. &  MzExt   !=. &  zEffort_17    !=. & MzAcadprobs_17   !=. 
gene DataClogCollege = college ~=. & zPGS_education ~=. &    zPa ~=. &  MzNa ~=. &  zCn ~=. &  MzExt ~=. &  zEffort_17 ~=. &  MzAcadprobs_17 ~=. 
gen DataIQ = zIq   !=. & zPGS_education   !=. & tzPGS_education   !=. & zlogUSDincome_Pts   !=. &  zed_parents   !=. 
gen DataIQ_AD = Aver_zPGS_education  !=. & FEE_zPGS_education  !=. & zlogUSDincome_Pts  !=. & zed_parents !=. 
* gen DatazlogUSDincomeFE = zlogUSDincome1 !=.



order idFamily iid  type TwinOrder mz dz Twin Gpa zIq TzIq zPGS_education tzPGS_education  Aver_zPGS_education BothTwins college Tcollege  zEduYears TzEduYears /*
*/    zCn TzCn MzNa TMzNa zPa TzPa zNCSk_In TzNCSk_In zlogUSDincome_Pts zed_parents


* browse idFamily iid TwinOrder zPGS_education TzPGS_education BothTwins
********************************************************************************
********************************************************************************
********************************************************************************



rename TzEduYears tzEduYears
rename TzGpa tzGpa
rename Tcollege tcollege
rename TzlogUSDincome1 tzlogUSDincome1

rename MzNa mzNa
rename TMzNa tmzNa
rename TzPa tzPa
rename TzCn tzCn
rename Tmale tmale

gen tzIq = TzIq

gen malepGS = male*zPGS_education
gen maletpGS = tmale*tzPGS_education

order idFamily iid type TwinOrder mz dz Twin Gpa zIq TzIq zPGS_education tzPGS_education zEduYears tzEduYears zed_parents zlogUSDincome_Pts  zPGS_mother zPGS_father male malepGS maletpGS 
exit


* Nlcom https://www.stata.com/manuals/semsempostestimation.pdf
* https://www.stata.com/manuals/semexample42g.pdf#semExample42g
* To read names of coefficients: sem, coeflegend

********************************************************************************
********************************************************************************
***************  SEM for  Ed Years *********************************************
********************************************************************************
********************************************************************************


******* SEM of Pathways from PGS to Education Years ****************************
*** Main regression, No FE*********************************	
sem ( zPGS_education@slopePGS  malePGS@slopemalePG  zed_parents@slopeHEdu zlogUSDincome_Pts@slopeHIn  zPGS_mother@slopePGSm zPGS_father@slopePGSf  male /*
	*/ pc1  pc2  pc3  pc4  pc5  pc6  pc7  pc8  pc9  pc10 _cons@c ->  zEduYears) ///
    (tzPGS_education@slopePGS maletpGS@slopemalePG  zed_parents@slopeHEdu zlogUSDincome_Pts@slopeHIn zPGS_mother@slopePGSm zPGS_father@slopePGSf  tmale /*
	*/tpc1 tpc2 tpc3 tpc4 tpc5 tpc6 tpc7 tpc8 tpc9 tpc10 _cons@c -> tzEduYears) ///
	(zPGS_mother zPGS_father                          ->  zed_parents zlogUSDincome_Pts) ///
	if type==1 & Twin==1
	
* Comparison with MTAG 	
	sem ( zPGS_education_m@slopePGS  malePGS@slopemalePG  zed_parents@slopeHEdu zlogUSDincome_Pts@slopeHIn  zPGSm_mother@slopePGSm zPGSm_father@slopePGSf  male /*
	*/ pc1  pc2  pc3  pc4  pc5  pc6  pc7  pc8  pc9  pc10 _cons@c ->  zEduYears) ///
    (tzPGS_education_m@slopePGS maletpGS@slopemalePG  zed_parents@slopeHEdu zlogUSDincome_Pts@slopeHIn zPGSm_mother@slopePGSm zPGSm_father@slopePGSf  tmale /*
	*/tpc1 tpc2 tpc3 tpc4 tpc5 tpc6 tpc7 tpc8 tpc9 tpc10 _cons@c -> tzEduYears) ///
	(zPGSm_mother zPGSm_father                          ->  zed_parents zlogUSDincome_Pts) ///
	if type==1 & Twin==1
	
	
* estat vce	

********************************************************************************
***************  SEM for  College *********************************************
********************************************************************************




*** Main regression, for college,probit, No FE*********************************	
gsem ( zPGS_education@slopePGS  malePGS@slopemalePG  zed_parents@slopeHEdu zlogUSDincome_Pts@slopeHIn  zPGS_mother@slopePGSm zPGS_father@slopePGSf  male /*
	*/ pc1  pc2  pc3  pc4  pc5  pc6  pc7  pc8  pc9  pc10 _cons@c ->  college, probit) ///
    (tzPGS_education@slopePGS maletpGS@slopemalePG  zed_parents@slopeHEdu zlogUSDincome_Pts@slopeHIn zPGS_mother@slopePGSm zPGS_father@slopePGSf  tmale /*
	*/tpc1 tpc2 tpc3 tpc4 tpc5 tpc6 tpc7 tpc8 tpc9 tpc10 _cons@c ->  college, probit) ///
	(zPGS_mother zPGS_father                          ->  zed_parents zlogUSDincome_Pts) ///
	if type==1 & Twin==1
	
*** Main regression for college,linear, No FE*********************************	
gsem ( zPGS_education@slopePGS  malePGS@slopemalePG  zed_parents@slopeHEdu zlogUSDincome_Pts@slopeHIn  zPGS_mother@slopePGSm zPGS_father@slopePGSf  male /*
	*/ pc1  pc2  pc3  pc4  pc5  pc6  pc7  pc8  pc9  pc10 _cons@c ->  college) ///
    (tzPGS_education@slopePGS maletpGS@slopemalePG  zed_parents@slopeHEdu zlogUSDincome_Pts@slopeHIn zPGS_mother@slopePGSm zPGS_father@slopePGSf  tmale /*
	*/tpc1 tpc2 tpc3 tpc4 tpc5 tpc6 tpc7 tpc8 tpc9 tpc10 _cons@c ->  college) ///
	(zPGS_mother zPGS_father                          ->  zed_parents zlogUSDincome_Pts) ///
	if type==1 & Twin==1

*  SEM Education Years 
sem (zPGS_mother zPGS_father -> zed_parents zlogUSDincome_Pts) ///
	(zed_parents zlogUSDincome_Pts  zPGS_education male zPGS_mother  zPGS_father   _cons  ->  zEduYears) ///
	if Twin==1
	
	sem, coeflegend
	
*  SEM Education Years: comparison MTAG 
sem (zPGSm_mother zPGSm_father -> zed_parents zlogUSDincome_Pts) ///
	(zed_parents zlogUSDincome_Pts  zPGS_education_m male zPGSm_mother  zPGSm_father   _cons  ->  zEduYears) ///
	if Twin==1	
	
	
	
* Twins, richer model 

sem (zPGS_mother zPGS_father                          -> zed_parents zlogUSDincome_Pts) ///
    ( zPGS_education@slopePGS  malePGS@slopemalePG zed_parents@slopeHEdu zlogUSDincome_Pts@slopeHIn  zIq  mzNa  zPa  zCn  male  pc1  pc2  pc3  pc4  pc5  pc6  pc7  pc8  pc9  pc10 _cons@c ->  zEduYears) ///
    (tzPGS_education@slopePGS maletpGS@slopemalePG zed_parents@slopeHEdu zlogUSDincome_Pts@slopeHIn tzIq tmzNa tzPa tzCn tmale tpc1 tpc2 tpc3 tpc4 tpc5 tpc6 tpc7 tpc8 tpc9 tpc10 _cons@c -> tzEduYears) ///	
	if type==1 & Twin==1
	
	
* Twins, richer, Family Environment
sem (zPGS_mother zPGS_father                          -> FE zed_parents zlogUSDincome_Pts) ///
    ( zPGS_education@slopePGS  malePGS@slopemalePG zed_parents@slopeHEdu zlogUSDincome_Pts@slopeHIn  zIq  mzNa  zPa  zCn FE@slopeF male pc1 pc2 pc3 pc4 pc5 pc6 pc7 pc8 pc9 pc10 _cons@c ->  zEduYears) ///
    (tzPGS_education@slopePGS maletpGS@slopemalePG zed_parents@slopeHEdu zlogUSDincome_Pts@slopeHIn tzIq tmzNa tzPa tzCn FE@slopeF tmale tpc1 tpc2 tpc3 tpc4 tpc5 tpc6 tpc7 tpc8 tpc9 tpc10 _cons@c -> tzEduYears) ///
	if type==1 & Twin==1
	
	


	
********************************************************************************
********************************************************************************
************* Cognitive and Non Cognitive, June 2022 style Begin ***************
********************************************************************************	
	
* Fix variance latent: https://www.stata.com/manuals/semintro4.pdf
**************************************************************	


		
	
	
**************************************************************
**************************************************************	 
* SEM Cognitive, Non Cognitive, Including PGS
**************************************************************
**************************************************************
	 sem ( zPGS_education ->  C)  ( zPGS_education ->  NC)  ///
	( C ->  zVER_IQ)  ( C ->  zPER_IQ) ///
	( NC  ->  mzNa) ( NC  ->  zPa ) ( NC  ->  zCn) ///
	(zPGS_mother -> zed_parents zlogUSDincome_Pts) ///
	(zPGS_father -> zed_parents zlogUSDincome_Pts) ///
	( C  NC  zed_parents zlogUSDincome_Pts  male   zPGSm_mother zPGSm_father zPGS_education _cons  ->  zEduYears) ///
	if Twin==1
	
	* Cognitive, Uncorrected PGS	
display _b[C:zPGS_education]
display _b[zEduYears:C]
nlcom  _b[C:zPGS_education]*_b[zEduYears:C]
	 
* Non Cognitive, Uncorrected PGS
display _b[NC:zPGS_education]
display _b[zEduYears:NC]	 	
nlcom   _b[NC:zPGS_education]*_b[zEduYears:NC]
	 
	 
	 
	 
* No GEN model, Uncorrected
**************************************************************
sem ( zPGS_education ->  C)  ( zPGS_education ->  NC)  ///
	( C ->  zVER_IQ)  ( C ->  zPER_IQ) ///
	( NC  ->  mzNa) ( NC  ->  zPa ) ( NC  ->  zCn) ///
	(zPGS_mother -> zed_parents zlogUSDincome_Pts) ///
	(zPGS_father -> zed_parents zlogUSDincome_Pts) ///
	(zed_parents zlogUSDincome_Pts  male   C  NC zPGSm_mother zPGSm_father     _cons  ->  zEduYears) ///
	if Twin==1
	
* sem, coeflegend
	
* Cognitive, Uncorrected PGS	
display _b[C:zPGS_education]
display _b[zEduYears:C]
nlcom  _b[C:zPGS_education]*_b[zEduYears:C]
	 
* Non Cognitive, Uncorrected PGS
display _b[NC:zPGS_education]
display _b[zEduYears:NC]	 	
nlcom   _b[NC:zPGS_education]*_b[zEduYears:NC]

	 **************************************************************
	 * No GEN model, MTAG
	 **************************************************************

sem ( zPGS_education_m ->  C)  ( zPGS_education_m ->  NC)  ///
	( C ->  zVER_IQ)  ( C ->  zPER_IQ) ///
	( NC  ->  mzNa) ( NC  ->  zPa ) ( NC  ->  zCn) ///
	(zPGSm_mother -> zed_parents zlogUSDincome_Pts) ///
	(zPGSm_father -> zed_parents zlogUSDincome_Pts) ///
	(zed_parents zlogUSDincome_Pts  male   C  NC  _cons  ->  zEduYears) ///
	if Twin==1
	
* sem, coeflegend
* Cognitive, MTAG corrected PGS	
display _b[C:zPGS_education_m]
display _b[zEduYears:C]
nlcom  _b[C:zPGS_education_m]*_b[zEduYears:C]
	 
* Non Cognitive, MTAG corrected PGS
display _b[NC:zPGS_education_m]
display _b[zEduYears:NC]	 	
nlcom   _b[NC:zPGS_education_m]*_b[zEduYears:NC]

********************************************************************************
********************************************************************************
************* Cognitive and Non Cognitive: End *********************************
********************************************************************************	







********************************************************************************
********************************************************************************
******* Tables for main text end here: *****************************************
******* Additional Analyis in the Additional Analysis file *********************
********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************
