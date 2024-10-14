/* This file loads in data needed to for random assignment values for 
   questions where respondents are asked cascading questions and entry
   points are randomly assigned */

   
/*******************
 LOAD 1996 DATA
*******************/ 
clear all

local year "1996"
local smallyear="96"
local survey="$HRSSurveys96"

infile using "`survey'/h`smallyear'sta/H`smallyear'PR_R.dct" , using("`survey'/h`smallyear'da/H`smallyear'PR_R.da")

save "$CleanData/HRSPreLoad`year'.dta", replace

/*******************
 LOAD 1998 DATA
*******************/
clear all

local year "1998"
local smallyear="98"
local survey="$HRSSurveys98"

infile using "`survey'/h`smallyear'sta/H`smallyear'PR_R.dct" , using("`survey'/h`smallyear'da/H`smallyear'PR_R.da")

save "$CleanData/HRSPreLoad`year'.dta", replace

/*******************
 LOAD 2000 DATA
*******************/
clear all

local year "2000"
local smallyear="00"
local survey="$HRSSurveys00"

infile using "`survey'/h`smallyear'sta/H`smallyear'PR_R.dct" , using("`survey'/h`smallyear'da/H`smallyear'PR_R.da")

save "$CleanData/HRSPreLoad`year'.dta", replace

/*******************
 LOAD 2002 DATA
*******************/
clear all

local year "2002"
local smallyear="02"
local survey="$HRSSurveys02"

infile using "`survey'/h`smallyear'sta/H`smallyear'PR_R.dct" , using("`survey'/h`smallyear'da/H`smallyear'PR_R.da")

save "$CleanData/HRSPreLoad`year'.dta", replace

/*******************
 LOAD 2004 DATA
*******************/
clear all

local year "2004"
local smallyear="04"
local survey="$HRSSurveys04"

infile using "`survey'/h`smallyear'sta/H`smallyear'PR_R.dct" , using("`survey'/h`smallyear'da/H`smallyear'PR_R.da")

save "$CleanData/HRSPreLoad`year'.dta", replace

/*******************
 LOAD 2006 DATA
*******************/
clear all

local year "2006"
local smallyear="06"
local survey="$HRSSurveys06"

infile using "`survey'/h`smallyear'sta/H`smallyear'PR_R.dct" , using("`survey'/h`smallyear'da/H`smallyear'PR_R.da")

save "$CleanData/HRSPreLoad`year'.dta", replace

/*******************
 LOAD 2008 DATA
*******************/
clear all

local year "2008"
local smallyear="08"
local survey="$HRSSurveys08"

infile using "`survey'/h`smallyear'sta/H`smallyear'PR_R.dct" , using("`survey'/h`smallyear'da/H`smallyear'PR_R.da")

save "$CleanData/HRSPreLoad`year'.dta", replace

/*******************
 LOAD 2010 DATA
*******************/
clear all

local year "2010"
local smallyear="10"
local survey="$HRSSurveys10"

infile using "`survey'/h`smallyear'sta/H`smallyear'PR_R.dct" , using("`survey'/h`smallyear'da/H`smallyear'PR_R.da")

save "$CleanData/HRSPreLoad`year'.dta", replace

/*******************
 LOAD 2012 DATA
*******************/
clear all

local year "2012"
local smallyear="12"
local survey="$HRSSurveys12"

infile using "`survey'/h`smallyear'sta/H`smallyear'PR_R.dct" , using("`survey'/h`smallyear'da/H`smallyear'PR_R.da")

save "$CleanData/HRSPreLoad`year'.dta", replace

