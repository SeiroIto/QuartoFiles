* Creates Table 1 of the main text
	
clear

* Upload data Data_Table_1

	
* use "/Volumes/GoogleDrive/My Drive/AResearch/Polygenic Risk Score/FinalFiles/Replication Files/Data_Table_1.dta"
********************************************************************************
* idFamily iid type ed_off college_off college 
* ClassEducation college_parents ed_parents iq iq_off EduYears 
* zPGS_education FamMember male Twin member mz dz 

* occ ed wb wb_m wb_d ext_17 sex zygos age_17 sp ac sc sr al ag con ha tr ab pa na cn cohort 
* gpa_17 expect_17 effort_17 acadprobs_17 income_fam 

* zPGS_mother ed_mom college_mom occ_mom iq_mom ac_m sc_m sr_m al_m ag_m con_m ha_m tr_m ab_m pa_m na_m cn_m ext_mom 
* zPGS_father ed_dad college_dad occ_dad iq_dad ac_d sc_d sr_d al_d ag_d con_d ha_d tr_d ab_d pa_d na_d cn_d ext_dad 

* Income variables
* USDincome income in dollars of the twins; USDincome_fam incomes in dollars of the parents, z the STD-variables: zUSDincome zUSDincome_fam
* logUSDincome logUSDincome_fam  are their log transforms; z their STD: zlogUSDincome zlogUSDincome_Pts  

* Variables in EW income data 
*  iid idsex zygosity idac bd_yy vt_29 year_29 age_29 vt_35 year_35 age_35 work_29 jobs_29 hours_29 USDincome_29 work_35 jobs_35 hours_35 USDincome_35 gstat white

* Variables in EW data Family Income
* idFamily income YearPtsInc USDincome_Pts


order idFamily iid age_17 age USDincome1 USDincome2 USDincome_29 USDincome_35 USDincome_Pts
* browse idFamily iid age_17 age USDincome1 USDincome2 USDincome2_fam USDincome_29 USDincome_35 USDincome_Pts

gen DataPGS = zPGS_education ~=.
egen zmale = std(male)
gen MaleIncomePts = zmale*zlogUSDincome_Pts

* browse idFamily iid type age_29 age_35 BDATE yob TDATE YearPtsInc YearAge_29 YearAge_35
gen AgeIncomePts = YearPtsInc - yob

gen AgeDiffParCh = AgeIncomePts - age_29
gen AgeDiffEdPts = AgeDiffParCh*zed_parents 

exit
*****************************************************************************
*****************************************************************************
*****************************************************************************
* Descriptive Statistics
*****************************************************************************
*****************************************************************************



*****************************************************************************
** Comparison of MTAG corrected and not
*****************************************************************************

twoway scatter zPGS_education zPGS_education_m

pwcorr zPGS_education zPGS_education_m, sig
* Mtag correction and bias


reg zPGS_education_m zPGS_education zIq
est store PGS_MTAG_IQ


estout  PGS_MTAG_IQ using "$pathOutputPGS/PGSMTAGIQ.tex", style(tex)/* 
*/ keep(zPGS_education zIq) /*
*/ order(zPGS_education zIq) replace ///
cells( b(star fmt(%9.3f)) se(par fmt(%9.3f)))  ///
msign(--) starlevels(* .1 ** .05 *** .01) stardetach substitute(_ \_) stats(N, fmt( %9.0f)) ///
title({\bf PGS and MTAG corrected PGS.}) ///
mlabels("" ,numbers)  ///
varlabels(zPGS_education "PGS" zIq "IQ score"_cons "Constant")  ///
prehead("\begin{table}[!hbp]" "\begin{footnotesize}" "\caption{@title The dependent variable is the MTAG corrected PGS score.  \label{Tab:PGSMTAGIQ}}" "\begin{center}" "\begin{tabular}{l* {@M}{r @{} l} }" "\hline \hline") ///
posthead(\hline) prefoot(\vspace{0.1in} \\) postfoot("\hline \hline" "\end{tabular}" "\end{center}" "\end{footnotesize}" "\end{table}")



* Prediction of EYears

reg zEduYears zPGS_education
reg zEduYears zPGS_education_m

* Unconditional on PGS parents
xtreg zEduYears                                                              zPGS_education if Twin ==1 & DataPGSPars1==1
xtreg zEduYears                                                        zmale zPGS_education if Twin ==1 & DataPGSPars1==1


* heritability

pwcorr zPGS_education zPGS_mother zPGS_father, sig
pwcorr zPGS_education_m zPGSm_mother zPGSm_father, sig


********************************************************************************


gen zPGS_parents = 0.5*(zPGS_father + zPGS_mother)

twoway scatter zPGS_education zPGS_parents

lowess zPGS_education zPGS_parents

reg zPGS_education zPGS_parents if type==0, r
reg zPGS_education zPGS_mother if type==0, r
reg zPGS_education zPGS_father if type==0, r

reg zPGS_education zPGS_father zPGS_mother zmale if type==0, r
test zPGS_father == zPGS_mother


pwcorr zIq zIq_mom zIq_dad, sig 


********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************
*********************** Income estimation Regression ***************************



* Unconditional IGE:

xtreg zlogUSDincome_29 zlogUSDincome_Pts  if Twin==1 & DataPGS==1

* Income Regression
set more off 

xtreg zlogUSDincome_29 zlogUSDincome_Pts                   AgeDiffParCh  AgeDiffEdPts zed_parents                                      if Twin==1 & DataPGS==1
est store CorrIncomeGPS1


xtreg zlogUSDincome_29 zlogUSDincome_Pts  zmale    MaleIncomePts      AgeDiffParCh  AgeDiffEdPts zed_parents                                   if Twin==1 & DataPGS==1
est store CorrIncomeGPS2


xtreg zlogUSDincome_29 zlogUSDincome_Pts  zPGS_education   zmale    MaleIncomePts      pc1 pc2 pc3 pc4 pc5 pc6 pc7 pc8 pc9 pc10 AgeDiffParCh  AgeDiffEdPts zed_parents   if Twin==1 & DataPGS==1
est store CorrIncomeGPS3


xtreg zlogUSDincome_29 zlogUSDincome_Pts  zPGS_education zmale MaleIncomePts zEduYears  zIq  zPa MzNa zCn MzExt zEffort_17 MzAcadprobs_17      pc1 pc2 pc3 pc4 pc5 pc6 pc7 pc8 pc9 pc10 AgeDiffParCh  AgeDiffEdPts zed_parents    if Twin==1 & DataPGS==1
est store CorrIncomeGPS4



estout  CorrIncomeGPS2 CorrIncomeGPS3 CorrIncomeGPS4  using "$pathOutputPGS/CorrIncomeGPSNm.tex", style(tex)/* 
*/ keep(zlogUSDincome_Pts   zPGS_education zmale MaleIncomePts zEduYears  zIq  zPa MzNa zCn MzExt zEffort_17 MzAcadprobs_17) /*
*/ order(zlogUSDincome_Pts zmale MaleIncomePts  zPGS_education zEduYears  zIq  zPa MzNa zCn MzExt zEffort_17 MzAcadprobs_17) replace ///
cells( b(star fmt(%9.3f)) se(par fmt(%9.3f)))  ///
msign(--) starlevels(* .1 ** .05 *** .01) stardetach substitute(_ \_) stats(N, fmt( %9.0f)) ///
title({\bf Income at the age 29 take, family income, PGS, and Personality.}) ///
mlabels("" "" "",numbers)  ///
varlabels(zlogUSDincome_Pts "Family Income" MaleIncomePts "Male $\times$ Family Income" zPGS_education "PGS" zPGS_father "PGS father" zPGS_mother "PGS mother" zIq "IQ" zEduYears "Education Years" zPa "MPQ PA" MzNa "MPQ NA" zCn "MPQ CN" MzExt "Externalizing" zed_parents "Education of parents" zcollege_parents  "College parents" zEffort_17 "Academic effort" MzAcadprobs_17 "Academic problems" zmale "Male" malePGS  "Male$\times$ PGS" _cons "Constant")  ///
prehead("\begin{table}[!hbp]" "\begin{footnotesize}" "\caption{@title All variables, including College of parents and Male, are standardized to mean zero and SD 1. The signs of MPQ variables NA, Externalizing and Academic problems are reversed. Controlled for PC's and the parents-child time difference in age at income data collection. \label{Tab:CorrIncomeGPSNm}}" "\begin{center}" "\begin{tabular}{l* {@M}{r @{} l} }" "\hline \hline") ///
posthead(\hline) prefoot(\vspace{0.1in} \\) postfoot("\hline \hline" "\end{tabular}" "\end{center}" "\end{footnotesize}" "\end{table}")

*** Additional variables
xtreg zlogUSDincome_29 zlogUSDincome_Pts  zPGS_education zmale MaleIncomePts zEduYears  zIq  zPa MzNa zCn MzExt zEffort_17 MzAcadprobs_17      pc1 pc2 pc3 pc4 pc5 pc6 pc7 pc8 pc9 pc10 AgeDiffParCh  AgeDiffEdPts   if Twin==1 & DataPGS==1

xtreg zlogUSDincome_29 zlogUSDincome_Pts  zPGS_education zmale MaleIncomePts zEduYears  zIq  zPa MzNa zCn MzExt zEffort_17 MzAcadprobs_17      pc1 pc2 pc3 pc4 pc5 pc6 pc7 pc8 pc9 pc10 AgeDiffParCh  AgeDiffEdPts zed_parents zPGS_mother zPGS_father   if Twin==1 & DataPGS==1


reg zPGS_education zPGS_mother if type==0, r
reg zPGS_education zPGS_father if type==0, r

**** * Income Regression Comparison with MTAG
set more off 

xtreg zlogUSDincome_29 zlogUSDincome_Pts                   AgeDiffParCh  AgeDiffEdPts zed_parents                                      if Twin==1 & DataPGS==1
est store CorrIncomeGPSMTCorr1


xtreg zlogUSDincome_29 zlogUSDincome_Pts  zmale    MaleIncomePts      AgeDiffParCh  AgeDiffEdPts zed_parents                                   if Twin==1 & DataPGS==1
est store CorrIncomeGPSMTCorr2


xtreg zlogUSDincome_29 zlogUSDincome_Pts  zPGS_education_m   zmale    MaleIncomePts      pc1 pc2 pc3 pc4 pc5 pc6 pc7 pc8 pc9 pc10 AgeDiffParCh  AgeDiffEdPts zed_parents   if Twin==1 & DataPGS==1
est store CorrIncomeGPSMTCorr3


xtreg zlogUSDincome_29 zlogUSDincome_Pts  zPGS_education_m zmale MaleIncomePts zEduYears  zIq  zPa MzNa zCn MzExt zEffort_17 MzAcadprobs_17      pc1 pc2 pc3 pc4 pc5 pc6 pc7 pc8 pc9 pc10 AgeDiffParCh  AgeDiffEdPts zed_parents    if Twin==1 & DataPGS==1
est store CorrIncomeGPSMTCorr4


estout   CorrIncomeGPSMTCorr3 CorrIncomeGPSMTCorr4 using "$pathOutputPGS/CorrIncomeGPSMTCorr.tex", style(tex)/* 
*/ keep(zlogUSDincome_Pts   zPGS_education_m zmale MaleIncomePts zEduYears  zIq  zPa MzNa zCn MzExt zEffort_17 MzAcadprobs_17) /*
*/ order(zlogUSDincome_Pts zmale MaleIncomePts  zPGS_education_m zEduYears  zIq  zPa MzNa zCn MzExt zEffort_17 MzAcadprobs_17) replace ///
cells( b(star fmt(%9.3f)) se(par fmt(%9.3f)))  ///
msign(--) starlevels(* .1 ** .05 *** .01) stardetach substitute(_ \_) stats(N, fmt( %9.0f)) ///
title({\bf Income at the age 29 take, family income, PGS, and Personality.}) ///
mlabels("" "" "",numbers)  ///
varlabels(zlogUSDincome_Pts "Family Income" MaleIncomePts "Male $\times$ Family Income" zPGS_education_m "PGS MTAG Corr" zPGS_father "PGS father" zPGS_mother "PGS mother" zIq "IQ" zEduYears "Education Years" zPa "MPQ PA" MzNa "MPQ NA" zCn "MPQ CN" MzExt "Externalizing" zed_parents "Education of parents" zcollege_parents  "College parents" zEffort_17 "Academic effort" MzAcadprobs_17 "Academic problems" zmale "Male" malePGS  "Male$\times$ PGS" _cons "Constant")  ///
prehead("\begin{table}[!hbp]" "\begin{footnotesize}" "\caption{@title The PGS is MTAG-corrected. All variables, including College of parents and Male, are standardized to mean zero and SD 1. The signs of MPQ variables NA, Externalizing and Academic problems are reversed. Controlled for PC's and the parents-child time difference in age at income data collection. \label{Tab:CorrIncomeGPSMTCorr}}" "\begin{center}" "\begin{tabular}{l* {@M}{r @{} l} }" "\hline \hline") ///
posthead(\hline) prefoot(\vspace{0.1in} \\) postfoot("\hline \hline" "\end{tabular}" "\end{center}" "\end{footnotesize}" "\end{table}")


exit





