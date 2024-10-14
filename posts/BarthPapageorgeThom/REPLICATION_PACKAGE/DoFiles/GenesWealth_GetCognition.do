clear all
infile using "$CrossWaveCogDir/COGIMP9214A_R.dct" , using("$CrossWaveCogDir/COGIMP9214A_R.da")

keep HHID PN *FLAG *COGTOT *SLFMEM *PSTMEM *VOCAB *IMRC *DLRC *SER7 *TR20 *BWC20 *SCIS *CACT *PRES *VP *MO *DY *YR *DW


***********************************************
* Now, actually work with the Cognition Data
***********************************************

* First, duplicate each observation 12 times to create a panel:
expand 11

* Create a Counter to keep track of successive waves of cognition data
bys HHID PN: gen CogCounter=_n

* Now, each wave corresponds to a different year.
* CogCounter  1 = 1994, 2 = 1996, 3 = 1998, 4 = 2000,
*             5 = 2002, 6 = 2004, 7 = 2006, 8 = 2008,
*             9 = 2010, 10 = 2012, 11 = 2014		 
			 
		
* First, create a time-varying measure CogScoreTot that keeps
* track of the person-specific cognition score over time:
gen CogScoreTot=.
replace CogScoreTot=R2ACOGTOT       if CogCounter==1
replace CogScoreTot=R3COGTOT        if CogCounter==2
replace CogScoreTot=R4COGTOT        if CogCounter==3
replace CogScoreTot=R5COGTOT        if CogCounter==4
replace CogScoreTot=R6COGTOT        if CogCounter==5
replace CogScoreTot=R7COGTOT        if CogCounter==6
replace CogScoreTot=R8COGTOT        if CogCounter==7
replace CogScoreTot=R9COGTOT        if CogCounter==8
replace CogScoreTot=R10COGTOT       if CogCounter==9
replace CogScoreTot=R11COGTOT       if CogCounter==10
replace CogScoreTot=R12COGTOT       if CogCounter==11

gen RecallScore=.
replace RecallScore=R3TR20         if CogCounter==2
replace RecallScore=R4TR20         if CogCounter==3
replace RecallScore=R5TR20         if CogCounter==4
replace RecallScore=R6TR20         if CogCounter==5
replace RecallScore=R7TR20         if CogCounter==6
replace RecallScore=R8TR20         if CogCounter==7
replace RecallScore=R9TR20         if CogCounter==8
replace RecallScore=R10TR20        if CogCounter==9
replace RecallScore=R11TR20        if CogCounter==10
replace RecallScore=R12TR20        if CogCounter==11

gen VocabScore=.
replace VocabScore=R3VOCAB          if CogCounter==2
replace VocabScore=R4VOCAB          if CogCounter==3
replace VocabScore=R5VOCAB          if CogCounter==4
replace VocabScore=R6VOCAB          if CogCounter==5
replace VocabScore=R7VOCAB          if CogCounter==6
replace VocabScore=R8VOCAB          if CogCounter==7
replace VocabScore=R9VOCAB          if CogCounter==8
replace VocabScore=R10VOCAB         if CogCounter==9
replace VocabScore=R11VOCAB         if CogCounter==10
replace VocabScore=R12VOCAB         if CogCounter==11

gen VocabFlag=.
replace VocabFlag=R3FVOCAB          if CogCounter==2
replace VocabFlag=R4FVOCAB          if CogCounter==3
replace VocabFlag=R5FVOCAB          if CogCounter==4
replace VocabFlag=R6FVOCAB          if CogCounter==5
replace VocabFlag=R7FVOCAB          if CogCounter==6
replace VocabFlag=R8FVOCAB          if CogCounter==7
replace VocabFlag=R9FVOCAB          if CogCounter==8
replace VocabFlag=R10FVOCAB         if CogCounter==9
replace VocabFlag=R11FVOCAB         if CogCounter==10
replace VocabFlag=R12FVOCAB         if CogCounter==11

foreach var in IMRC DLRC SER7 BWC20 SCIS CACT PRES VP MO DY YR DW {
	gen FLAG_`var'=.
	forvalues Ind=3(1)12{
		replace FLAG_`var'=R`Ind'F`var' if CogCounter==(`Ind'-1)
	}
}

gen CogScoreNumImp=0
foreach var in IMRC DLRC SER7 BWC20 SCIS CACT PRES VP MO DY YR DW {
	replace CogScoreNumImp=(CogScoreNumImp+1) if FLAG_`var'==1
}

* Fill in the year based on the above guide.  NOTE THE EXCEPTIONS
* for waves 1 and 2, some individuals from the AHEAD cohorts were asked
* in 1993 and 1995, not 1994 and 1996 (part of AHEAD cohort) We will
* account for this later when creating the "CogAge" variable
gen YEAR=.
replace YEAR=1994 if CogCounter==1
replace YEAR=1996 if CogCounter==2
replace YEAR=1998 if CogCounter==3
replace YEAR=2000 if CogCounter==4
replace YEAR=2002 if CogCounter==5
replace YEAR=2004 if CogCounter==6
replace YEAR=2006 if CogCounter==7
replace YEAR=2008 if CogCounter==8
replace YEAR=2010 if CogCounter==9
replace YEAR=2012 if CogCounter==10
replace YEAR=2014 if CogCounter==11

* Create CogAge variable ... which will allow us to correct for the fact that some 
* people's 1994 data was really collected in 1993, and some people's
* 1996 data was really collected in 1995

gen CogYEAR=YEAR
replace CogYEAR=YEAR-1 if YEAR==1994 & R2FLAG==93
replace CogYEAR=YEAR-1 if YEAR==1996 & R3FLAG==95


replace YEAR=CogYEAR if YEAR~=CogYEAR

* Keep a subset of variables to be the main cognition measure:
keep HHID PN CogYEAR CogScoreTot RecallScore VocabScore VocabFlag *FLAG* YEAR CogScoreNumImp CogCounter

save "$CleanData\HRS_CleanCogFullPanel.dta", replace 


