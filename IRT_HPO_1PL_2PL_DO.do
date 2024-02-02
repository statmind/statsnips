* IRT 30/01/2024


* 1PL / HPO

use hpo_sample1000_ci_cid_ci4.dta, clear
keep ci_d*
fre  ci*

irt 1pl ci_d*

estat report

irtgraph icc
irtgraph icc, blocation range(-3 3)
irtgraph icc, plocation blocation range(-2 3) xlabel(-2 0 .8 1.3 2 3, format(%4.2f) ///
         labsize(vsmall)) scheme(s1mono) ///
		 legend(rows(2) size(vsmall)) ylabel(,format(%4.2f) labsize(vsmall))

irtgraph iif
irtgraph tif
irtgraph tif, se
predict raschscore, latent
summ r*
egen sumscore = rowmean(ci_d_*)
pwcorr raschscore sumscore

save "hpo_sample1000_ci_cid.dta", replace

irtgraph tif, se data(tif_1pl_hpo, replace) n(7) range(-3 3) nodraw
use tif_1pl_hpo, clear
gen rel_irt_1pl = 1-(1/tif)
format rel_irt_1pl %4.2f
save "tif_1pl_hpo.dta", replace

use hpo_sample1000_ci_cid.dta, clear
alpha ci*

use tif_1pl_hpo.dta, clear
twoway line rel_irt_1pl theta, yline(.70 .86) xline(-2 -1 0 1 2)

* 2PL / HPO

use hpo_sample1000_ci_cid_ci4.dta, clear
keep ci_d*
fre  ci*

* Test if 2PL better fits the data than 1PL
irt 1pl ci*
estimates store rasch
irt 2pl ci*
lrtest rasch

irt 2pl ci*

irtgraph icc, plocation blocation range(-2 3) xlabel(-2 0 1 2 3, format(%4.2f) ///
         labsize(vsmall)) scheme(s1mono) ///
		 legend(rows(2) size(vsmall)) ylabel(,format(%4.2f) labsize(vsmall))

irtgraph iif
irtgraph tif, se

predict raschscore2pl, latent
summ r*
egen sumscore = rowmean(ci_d_*)
pwcorr raschscore2pl sumscore

irtgraph tif, se data(tif_2pl_hpo, replace) n(7) range(-3 3) nodraw
use tif_2pl_hpo, clear
gen rel_irt_2pl = 1-(1/tif)
format rel_irt_2pl %4.2f
save "tif_2pl_hpo.dta", replace

use hpo_sample1000_ci_cid.dta, clear
alpha ci*

use tif_2pl_hpo.dta, clear
twoway line rel_irt_2pl theta, yline(.70 .86) xline(-2 -1 0 1 2)
twoway area rel_irt_2pl theta, sort base(.86) xlabel(-3 -2 -1 .25 1.35 2 3) xline(0.25 1.35)
twoway area rel_irt_2pl theta, sort base(.70) yline(.70) xlabel(-3 -2 -1 -.27 0 1 2.05 3) xline(-.27 2.05)
