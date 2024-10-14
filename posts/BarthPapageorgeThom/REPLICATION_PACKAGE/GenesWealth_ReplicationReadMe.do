/*

Replication Instructions for 
Barth, Papageorge and Thom, "Genetic Endowments and Wealth Inequality". 

Please read this file to set up directories, and then continue on to read
the comments in GenesWealth_Replication.do.

All of the replication files here are for Stata.  There are many .do files
associated with this project, but once all of the directories and raw data
files are properly set up, one should only need to run GenesWealth_Replication.do,
since this .do file calls all other do files.  However, in order for that to run
properly, you will need the following directories set up, with the following 
files available in those directories.  Note that in the GenesWealth_Replication.do 
file, you will need to fill in the exact path on your machine(s) to each of the 
following global directory names - the name after global is simply a name
in the code assigned to the path that you fill in at the top of the 
GenesWealth_Replication.do file.

Since this paper makes use of the restricted access SSA Income files for the HRS,
some of the files here can be run locally (those that do not use the restricted
access data, and some must be run on the data Enclave run by
MiCDA (Michigan Center on the Demography of Aging).  The MiCDA Enclave contains 
the SSA income data, and separate registration and approval processes must be 
followed to gain access to this data.  Because of this, we will specify two sets 
of directories: Local Directories, and Enclave Directories.  Much of the data
cleaning for this project can be done on local computers with publicly available
data, generating a set of cleaned data files that are ready to export to the 
Enclave where regressions can be performed.  The main cleaned data file is named
GenesWealth_CleanPanel.dta.  

The Health and Retirement Study does not authorize the distribution of its primary
data files (or cleaned versions of them) apart from websites that they maintain
or sanction.  The files that should be contained in local directories below
are publicly available and can be downloaded from the HRS after registration
here:  https://hrs.isr.umich.edu/data-products

Before continuing on to the GenesWealth_Replication.do file, make sure that
the following directories are set up locally and in the Enclave.  At the 
start of the GenesWealth_Replication.do file, you will need to fill in 
the specific path you will assign for each global variable specified below.


Local Directories (25 Directories):  

1. Directory containing all do files: global GENXDoFiles

2. Directory containing cleaned and intermediate data files: global CleanData

3. Directory containing Tables (local - not Enclave): global TableDir

4. Directory containing the HRS Cross-Wave Tracker File (2016): global Tracker16
	Must contain:
	HRS_Tacker16.dta  (From HRS Website)

5. Directory containing the SSGAC's Polygenic Score for Educational Attainment 
	based on the Lee et al (2018) GWAS: global EA3ScoreDir
	Must contain:
	Lee_et_al_(2018)_PGS_HRS.txt (From HRS Website)

6. Directory containing HRS Polygenic Score File (Version 3): global HRSPGS3Dir
	Must contain:
	GENSCORE3E_R.dta  (From HRS Website)

7. Directory containing the latest HRS RAND Family file: global RandFamDir
	Must contain:
	randhrsfamr1992_2014v1.dta
	randhrsfamk1992_2014v1.dta  (From HRS / RAND Website)

8. Directory containing the latest HRS RAND Detail / Imputations File: global RandDetailDir
	Must contain:
	randhrsimp1992_2014v2.dta  (From HRS / RAND Website)

9. Directory containing the latest HRS RAND Longitudinal File: global RandLongDir
	Must contain:
	randhrs1992_2016v1.dta     (From HRS / RAND Website)

10. Directory containing the Cross-Wave Cognition File: global CrossWaveCogDir 
	Must contain:
	COGIMP9214A_R.dct          (From HRS Website)

11. 1992 HRS Survey Files:  global HRSSurveys92
	Must contain:
	HEALTH.dct, HEALTH.da
	EMPLOYER.dct, EMPLOYER.da
	KIDS.dct  , KIDS.da
	HHList.dct, HHList.da       (From HRS Website)

12. 1994 HRS Survey Files:  global HRSSurveys94
	Must contain:
	W2CS.dct, W2CS.da
	W2A.dct, W2A.da
	W2C.dct, W2C.da
	W2FA.dct, W2FA.da
	W2FB.dct, W2FB.da           (From HRS Website)

13. 1996 HRS Survey Files:  global HRSSurveys96
	Must contain:
	H96CS_R.dct, H96CS_R.da
	H96A_R.dct,  H96A_R.da
	H96B_R.dct,  H96B_R.da
	H96G_R.dct,  H96G_R.da
	H96H_R.dct, H96H_R.da
	H96PR_R.dct, H96PR_R.da     (From HRS Website)

14. 1998 HRS Survey Files:  global HRSSurveys98
	Must contain:
	H98A_R.dct, H98A_R.da
	H98G_R.dct, H98G_R.da
	H98H_R.dct, H98H_R.da
	H98J_R.dct, H98J_R.da
	H98PR_R.dct, H98PR_R.da     (From HRS Website)

15. 2000 HRS Survey Files:  global HRSSurveys00
	Must contain:
	H00A_R.dct, H00A_R.da
	H00G_R.dct, H00G_R.da
	H00H_R.dct, H00H_R.da
	H00PR_R.dct, H00PR_R.da     (From HRS Website)

16. 2002 HRS Survey Files:  global HRSSurveys02
	Must contain:
	H02A_R.dct, H02A_R.da
	H02B_R.dct, H02B_R.da
	H02J_R.dct, H02J_R.da
	H02P_R.dct, H02P_R.da
	H02PR_R.dct, H02PR_R.da     (From HRS Website)

17. 2004 HRS Survey Files:  global HRSSurveys04
	Must contain:
	H04A_R.dct, H04A_R.da
	H04B_R.dct, H04B_R.da
	H04J_R.dct, H04J_R.da
	H04P_R.dct, H04P_R.da
	H04PR_R.dct, H04PR_R.da      (From HRS Website)

18. 2006 HRS Survey Files:  global HRSSurveys06
	Must contain:
	H06A_R.dct, H06A_R.da
	H06B_R.dct, H06B_R.da
	H06J_R.dct, H06J_R.da
	H06P_R.dct, H06P_R.da
	H06PR_R.dct, H06PR_R.da      (From HRS Website)

19. 2008 HRS Survey Files:  global HRSSurveys08
	Must contain:
	H08A_R.dct, H08A_R.da
	H08B_R.dct, H08B_R.da
	H08J_R.dct, H08J_R.da
	H08P_R.dct, H08P_R.da
	H08PR_R.dct, H08PR_R.da      (From HRS Website)

20. 2010 HRS Survey Files:  global HRSSurveys10
	Must contain:
	H10A_R.dct, H10A_R.da
	H10B_R.dct, H10B_R.da
	H10J_R.dct, H10J_R.da
	H10P_R.dct, H10P_R.da
	H10PR_R.dct, H10PR_R.da      (From HRS Website)

21. 2012 HRS Survey Files:  global HRSSurveys12
	Must contain:
	H12A_R.dct, H12A_R.da
	H12B_R.dct, H12B_R.da
	H12J_R.dct, H12J_R.da
	H12P_R.dct, H12P_R.da
	H12PR_R.dct, H12PR_R.da     (From HRS Website)

22. Directory containing the Lifetables used to discount future streams of income:
	global LifeTablesData  
	Must contain:
	LifeTables.xlsx  (included in replication package
	                  Available at https://www.ssa.gov/oact/NOTES/as120/LifeTables_Tbl_7.html)

23. Directory containing the SSA Taxable Maxima for each year: global ExternalDir  
	Must contain:
	SSATopCodeLevels.dta (included in replication package - data entered from 
	 table available at https://www.ssa.gov/OACT/COLA/cbb.html)
 
24. Directory containing CPS data (March waves, available from IPUMS packaged by decades):
	global CPSDecades
	Must contain:
	CPS_1960s.dta
	CPS_1970s.dta
	CPS_1980s.dta
	CPS_1990s.dta
	CPS_2000s.dta
	CPS_2010s.dta  (Available from IPUMS CPS: https://cps.ipums.org/cps/index.shtml)

25. Directory containing CPI used to convert to real 2010 dollars (From BLS):
	global: CPIDir
	Must contain:
	CPI_U_1913_2016_2k10.dta (included in replication package)


Enclave Directories (7 Directories):

1. Directory containing do files on Enclave: global GENXDoFilesEnclave

2. Directory containing cleaned and intermediate data files on Enclave: global CleanDataEnclave

3. Directory containing Tables and other output on Enclave: global OutputDirEnclave

4. Directory containing 2016 Cross Wave Tracker File on the Enclave: global EnclaveTracker 
   Must contain (from MiCDA Enclave):
   TRK2016TR_R.dta

5. Directory containing the SSA Income Data for Respondents: global SSAIncDirResp
	Must contain (from MiCDA Enclave):
	xyrsumern.dta

6. Directory containing the SSA Income Data for Deceased Spouses: global SSAIncDirSpouse
	Must contain (from MiCDA Enclave):
	xdspsumern.dta

7. Directory on the MiCDA Enclave that contains data that is uploaded: global ExtDataEnclave
	Must contain:
	CPI_U_1913_2016_2k10.dta  (CPI File from BLS, referenced above)
	TopCodeStatsComplete.dta  (Created by the GenesWealth_GetCPSTopCodeStats.do file)

  
*/ 


