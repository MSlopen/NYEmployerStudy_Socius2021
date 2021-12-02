
***START ANALYSIS***
cap cd "C:\Users\mered\Dropbox\Family Leave\COVID Brief\Dataset and Code" /*change to github*/
cap cd "C:\Users\mes2004\Dropbox\Family Leave\COVID Brief\Dataset and Code" /*change to github*/
use CovidDataBrief.dta, clear


*************************************
****************Figure 1*************
*************************************

*Data for Figure 1

*3 level category
tab support3cat yyear [aweight=allweight], col m
bysort fmla: tab support3cat yyear [aweight=allweight], col m

tab support3cat yyear, col m
bysort fmla: tab support3cat yyear, col m

*Table A2: Firm FE Regressions for Co-efficients and p-values

cd "C:\Users\mered\Dropbox\Family Leave\Meredith_Workspace\Tables"

eststo clear

eststo: quietly areg support2cat Year5 q02_employees per_pt per_f per_1year per_quit per_absent flag_pt flag_f flag_1year flag_quit flag_absent i.sector, absorb(id) robust
eststo: quietly areg oppose2cat Year5 q02_employees per_pt per_f per_1year per_quit per_absent flag_pt flag_f flag_1year flag_quit flag_absent i.sector, absorb(id) robust
eststo: quietly areg support2cat Year5 q02_employees per_pt per_f per_1year per_quit per_absent flag_pt flag_f flag_1year flag_quit flag_absent i.sector if fmla==0, absorb(id) robust
eststo: quietly areg oppose2cat Year5 q02_employees per_pt per_f per_1year per_quit per_absent flag_pt flag_f flag_1year flag_quit flag_absent i.sector if fmla==0, absorb(id) robust
eststo: quietly areg support2cat Year5 q02_employees per_pt per_f per_1year per_quit per_absent flag_pt flag_f flag_1year flag_quit flag_absent i.sector if fmla==1, absorb(id) robust
eststo: quietly areg oppose2cat Year5 q02_employees per_pt per_f per_1year per_quit per_absent flag_pt flag_f flag_1year flag_quit flag_absent i.sector if fmla==1, absorb(id) robust

esttab using " Change in Policy Support Firm FE.csv", replace keep (Year5 _cons) ///
b(3) se stats(dv N, fmt(%9.3f %9.0g)) ///
mtitles ("Support - All Firms"  ///
"Opposed - All Firms" "Support - Small Firms"  "Opposed - Small Firms" "Support - Medium Firms"  ///
"Opposed - Medium Firms"   ) ///
star( * 0.1 ** 0.05 *** 0.01) wrap label varwidth(20) brackets

*Create Figure 2 coefficient plot
quietly reg support2cat Year5 q02_employees per_pt per_f per_1year per_quit per_absent flag_pt flag_f flag_1year flag_quit flag_absent i.sector, absorb(id) robust
estimates store allsupport1
quietly reg support2cat Year5 q02_employees per_pt per_f per_1year per_quit per_absent flag_pt flag_f flag_1year flag_quit flag_absent i.sector if fmla==0, absorb(id) robust
estimates store smallsupport1
quietly reg support2cat Year5 q02_employees per_pt per_f per_1year per_quit per_absent flag_pt flag_f flag_1year flag_quit flag_absent i.sector if fmla==1, absorb(id) robust
estimates store medsupport1

coefplot (allsupport1, msymbol(D) label(All Firms))  ///
(smallsupport1, msymbol(S) label (Firms with 10-49 Employees))  ///
(medsupport1, label (Firms with 50-99 Employees))  ///
, keep (Year5) drop(_cons) xscale(range(-0.1 0.3)) xline(0) format(%9.1f) ///



*************************************************************************
***************Impact of Policy Analysis Regressions*********************
*************************************************************************

drop if sup4==. |sup5==.

*keep only year 5
keep if yyear==5

cd "C:\Users\mered\Dropbox\Family Leave\Meredith_Workspace\Tables"

gen FFCRAxStatePolicy=FFCRA*statepol

*Create Table A3
eststo clear
eststo:  reg support5 FFCRA statepol NY i.sup4 q02_employees per_pt per_f per_1year per_quit per_absent flag_pt flag_f flag_1year flag_quit flag_absent i.sector, r
eststo:  reg oppose5 FFCRA statepol NY i.sup4 q02_employees per_pt per_f per_1year per_quit per_absent flag_pt flag_f flag_1year flag_quit flag_absent i.sector, r
eststo:  reg support5 FFCRA statepol NY i.sup4 q02_employees per_pt per_f per_1year per_quit per_absent flag_pt flag_f flag_1year flag_quit flag_absent i.sector if fmla==0, r
eststo:  reg oppose5 FFCRA statepol NY i.sup4 q02_employees per_pt per_f per_1year per_quit per_absent flag_pt flag_f flag_1year flag_quit flag_absent i.sector if fmla==0, r
eststo:  reg support5 FFCRA statepol NY i.sup4 q02_employees per_pt per_f per_1year per_quit per_absent flag_pt flag_f flag_1year flag_quit flag_absent i.sector if fmla==1, r
eststo:  reg oppose5 FFCRA statepol NY i.sup4 q02_employees per_pt per_f per_1year per_quit per_absent flag_pt flag_f flag_1year flag_quit flag_absent i.sector if fmla==1, r

esttab using "Used Policy Support Regs.csv", replace keep (FFCRA statepol NY _cons) ///
b(3) se stats(dv N, fmt(%9.3f %9.0g)) ///
mtitles ("Support - All Firms"  ///
"Opposed - All Firms" "Support - Small Firms"  "Opposed - Small Firms" "Support - Medium Firms"  ///
"Opposed - Medium Firms") ///
star( * 0.1 ** 0.05 *** 0.01) wrap label varwidth(20) brackets

*Create Figure 3 coefficient plot
quietly reg support5 FFCRA statepol NY i.sup4 q02_employees per_pt per_f per_1year per_quit per_absent flag_pt flag_f flag_1year flag_quit flag_absent i.sector, r
estimates store allsupport
quietly reg support5 FFCRA statepol NY i.sup4 q02_employees per_pt per_f per_1year per_quit per_absent flag_pt flag_f flag_1year flag_quit flag_absent i.sector if fmla==0, r
estimates store smallsupport
quietly reg support5 FFCRA statepol NY i.sup4 q02_employees per_pt per_f per_1year per_quit per_absent flag_pt flag_f flag_1year flag_quit flag_absent i.sector if fmla==1, r
estimates store medsupport

coefplot (allsupport, msymbol(D) label(All Firms))  ///
(smallsupport, msymbol(S) label (Firms with 10-49 Employees))  ///
(medsupport, label (Firms with 50-99 Employees))  ///
, keep (FFCRA statepol) drop(_cons) xline(0) format(%9.1f) ///
title("Relationship between Use of Leave Policies on Change in Support for State PFL", size(small)) 
