clear all

use "$RandLongDir\randhrs1992_2016v1.dta"

keep hhidpn h*atotb

expand 9

bys hhidpn: gen TempCounter=_n

gen YEAR=.
replace YEAR=1992 if TempCounter==1
replace YEAR=1994 if TempCounter==2
replace YEAR=1998 if TempCounter==3
replace YEAR=2000 if TempCounter==4
replace YEAR=2002 if TempCounter==5
replace YEAR=2004 if TempCounter==6
replace YEAR=2006 if TempCounter==7
replace YEAR=2008 if TempCounter==8
replace YEAR=2010 if TempCounter==9

drop TempCounter

gen RANDWealth=.

replace RANDWealth=h1atotb if YEAR==1992
replace RANDWealth=h2atotb if YEAR==1994
replace RANDWealth=h4atotb if YEAR==1998
replace RANDWealth=h5atotb if YEAR==2000
replace RANDWealth=h6atotb if YEAR==2002
replace RANDWealth=h7atotb if YEAR==2004
replace RANDWealth=h8atotb if YEAR==2006
replace RANDWealth=h9atotb if YEAR==2008
replace RANDWealth=h10atotb if YEAR==2010

drop if RANDWealth==.

rename hhidpn HHIDPNNum
keep HHIDPNNum YEAR RANDWealth

save "$CleanData\RANDTotWealthPanel.dta", replace


