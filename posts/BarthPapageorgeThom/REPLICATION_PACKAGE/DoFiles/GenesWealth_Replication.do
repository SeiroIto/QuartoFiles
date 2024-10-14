
clear all

global GENXDoFiles     "<INSERT DIRECTORY PATH>"
global CleanData       "<INSERT DIRECTORY PATH>"
global TableDir        "<INSERT DIRECTORY PATH>"
global Tracker16       "<INSERT DIRECTORY PATH>"
global EA3ScoreDir     "<INSERT DIRECTORY PATH>"
global HRSPGS3Dir      "<INSERT DIRECTORY PATH>"
global RandFamDir      "<INSERT DIRECTORY PATH>"
global RandDetailDir   "<INSERT DIRECTORY PATH>"
global RandLongDir     "<INSERT DIRECTORY PATH>"
global CrossWaveCogDir "<INSERT DIRECTORY PATH>"

global HRSSurveys92 "<INSERT DIRECTORY PATH>"
global HRSSurveys94 "<INSERT DIRECTORY PATH>"
global HRSSurveys96 "<INSERT DIRECTORY PATH>"
global HRSSurveys98 "<INSERT DIRECTORY PATH>"
global HRSSurveys00 "<INSERT DIRECTORY PATH>"
global HRSSurveys02 "<INSERT DIRECTORY PATH>"
global HRSSurveys04 "<INSERT DIRECTORY PATH>"
global HRSSurveys06 "<INSERT DIRECTORY PATH>"
global HRSSurveys08 "<INSERT DIRECTORY PATH>"
global HRSSurveys10 "<INSERT DIRECTORY PATH>"
global HRSSurveys12 "<INSERT DIRECTORY PATH>"

global LifeTablesData  "<INSERT DIRECTORY PATH>"
global ExternalDir     "<INSERT DIRECTORY PATH>"
global CPSDecades      "<INSERT DIRECTORY PATH>"
global CPIDir          "<INSERT DIRECTORY PATH>"


global GENXDoFilesEnclave "<INSERT DIRECTORY PATH>"
global CleanDataEnclave   "<INSERT DIRECTORY PATH>"
global OutputDirEnclave   "<INSERT DIRECTORY PATH>" 
global EnclaveTracker     "<INSERT DIRECTORY PATH>"
global SSAIncDirResp      "<INSERT DIRECTORY PATH>"
global SSAIncDirSpouse    "<INSERT DIRECTORY PATH>"
global ExtDataEnclave     "<INSERT DIRECTORY PATH>"


* Get Earnings and Business / Self-Employment Income Averages from the Employment Files.
* This will create the following cleaned files in the $CleanData directory:
* HRSEmpInc`yr'.dta (11 files, with yr = 92, 94, ... 10, 12), HRSEmpIncPanel.dta
* HRSEmpIncMeasures.dta, HRS_YearRetired.dta
do "$GENXDoFiles\GenesWealth_GetHRSEmpInc.do"

* Get Parental Education:
* This will create the following cleaned files in the $CleanData directory:
* HRSDemo`yr'.dta (11 files, with yr = 92, 94, ... 10, 12), HRSParentsEduc.dta
do "$GENXDoFiles\GenesWealth_GetDemographics.do"

* Get Cross-Sectional Characteristics, including merge with the genetic data:
* This file creates several intermediate data sets that are saved in the 
* $CleanData directory, but ultimately creates a consolidated file 
* GenesWealth_CrossSectionVars.dta
do "$GENXDoFiles\GenesWealth_GetCrossSectionVars.do"

* Get Cognition Panel from the Cross-Wave Imputation of Cognitive Functioning Measures:
do "$GENXDoFiles\GenesWealth_GetCognition.do"

* Get Pre-Load Files
do "$GENXDoFiles\GenesWealth_GetPreLoad.do"

* This file creates the factors that are used to determine the 
* present discounted value of future flows from annuities 
* or defined-benefit pension income: 

do "$GENXDoFiles\BuildLifeTables.do"

clear all

* Clean the Main Wealth variables from the RAND HRS Files:
do "$GENXDoFiles\RAND_Wealth1992.do"
do "$GENXDoFiles\RAND_Wealth1994.do"
do "$GENXDoFiles\RAND_Wealth1996.do"
do "$GENXDoFiles\RAND_Wealth1998.do"
do "$GENXDoFiles\RAND_Wealth2000.do"
do "$GENXDoFiles\RAND_Wealth2002.do"
do "$GENXDoFiles\RAND_Wealth2004.do"
do "$GENXDoFiles\RAND_Wealth2006.do"
do "$GENXDoFiles\RAND_Wealth2008.do"
do "$GENXDoFiles\RAND_Wealth2010.do"
do "$GENXDoFiles\RAND_Wealth2012.do"

clear all

* Clean data on Pensions (HRS):
do "$GENXDoFiles\Pension_1992.do"
do "$GENXDoFiles\Pension_1994.do"
do "$GENXDoFiles\Pension_1996.do"
do "$GENXDoFiles\Pension_1998.do"
do "$GENXDoFiles\Pension_2000.do"
do "$GENXDoFiles\Pension_2002.do"
do "$GENXDoFiles\Pension_2004.do"
do "$GENXDoFiles\Pension_2006.do"
do "$GENXDoFiles\Pension_2008.do"
do "$GENXDoFiles\Pension_2010.do"

clear all

* Clean Data on Expectations:
do "$GENXDoFiles\Expectations_1992.do"
do "$GENXDoFiles\Expectations_1994.do"
do "$GENXDoFiles\Expectations_1996.do"
do "$GENXDoFiles\Expectations_1998.do"
do "$GENXDoFiles\Expectations_2000.do"
do "$GENXDoFiles\Expectations_2002.do"
do "$GENXDoFiles\Expectations_2004.do"
do "$GENXDoFiles\Expectations_2006.do"
do "$GENXDoFiles\Expectations_2008.do"
do "$GENXDoFiles\Expectations_2010.do"
do "$GENXDoFiles\Expectations_2012.do"

clear all

* Get the off-the-shelf imputed RAND Wealth data (without adding Pension Accounts
* and defined benefit flows:
do "$GENXDoFiles\GenesWealth_GetRANDWealth.do"

clear all

* This is the main file that assembles the pieces from the previous files and 
* creates the main wealth panel that is the base for almost all of the 
* subsequent analyses.  This file creates the file GenesWealth_CleanPanel.dta,
* which must be exported to the MiCDA Enclave.
do "$GENXDoFiles\GenesWealth_PrepDataForPanel.do"


clear all

* Load Expectations related to Mortality
do "$GENXDoFiles\GenesWealth_GetExpectations.do"

clear all

* This performs the Regressions related to mortality contained
* in Table 7 of the Paper - the Enclave is not needed for this. 
do  "$GENXDoFiles\GenesWealth_Mortality.do"

clear all

* Get average values of income conditional on incomes exceeding the top
* coded amounts: 
do "$GENXDoFiles\GenesWealth_GetCPSTopCodeStats.do"

clear all

* Note that at this stage, you one will have to work with the Enclave.  This
* will mean transfering the following files to the following directories:
*  1) Transfer GenesWealth_CleanPanel.dta to $ExtDataEnclave
*  2) Transfer all files of the type SurvivalExpectations`yr'.dta (`yr' = 1992, 1994, etc ... )
*      to $CleanDataEnclave.  These were created in the GenesWealth_GetExpectations.do file
*  3) Transfer CPI_U_1913_2016_2k10.dta to $ExtDataEnclave
*  4) Transfer TopCodeStatsComplete.dta to $ExtDataEnclave.  This .dta file was
*      created as an output in the GenesWealth_GetCPSTopCodeStats.do file.  

* Clean the SSA Income data to get income totals for each household:
do "$GENXDoFilesEnclave\GenesWealth_CleanSSAIncData.do" 


clear all

* Generate Descriptive Statistics
do "$GENXDoFilesEnclave\GenesWealth_Descriptives.do"

clear all

* Main Analyses in Paper:
do "$GENXDoFilesEnclave\GenesWealth_Regressions.do"


clear all
* Appendix Results:
do "$GENXDoFilesEnclave\GenesWealth_Appendix.do"
