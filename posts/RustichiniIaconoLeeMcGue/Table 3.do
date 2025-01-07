* Creates Table 3 of the main text
	
clear

* Upload data Data_Table_3

	
* use "/Volumes/GoogleDrive/My Drive/AResearch/Polygenic Risk Score/FinalFiles/Replication Files/Data_Table_3.dta"
	
* Twins, richer, Family Environment
sem (zPGS_mother zPGS_father                          -> FE zed_parents zlogUSDincome_Pts) ///
    ( zPGS_education@slopePGS  malePGS@slopemalePG zed_parents@slopeHEdu zlogUSDincome_Pts@slopeHIn  zIq  mzNa  zPa  zCn FE@slopeF male pc1 pc2 pc3 pc4 pc5 pc6 pc7 pc8 pc9 pc10 _cons@c ->  zEduYears) ///
    (tzPGS_education@slopePGS maletpGS@slopemalePG zed_parents@slopeHEdu zlogUSDincome_Pts@slopeHIn tzIq tmzNa tzPa tzCn FE@slopeF tmale tpc1 tpc2 tpc3 tpc4 tpc5 tpc6 tpc7 tpc8 tpc9 tpc10 _cons@c -> tzEduYears) ///
	if type==1 & Twin==1
	
	

