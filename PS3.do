set more off, perm
*PROBLEM SET 3
clear all
cd "/Users/vrangbaek/Dropbox/KU/Polit/Oekonometri B/F15/Ugesedler/3"
cap log close
log using PS3, replace text

*QUESTION 1: LOAD AND DESCRIBE DATA
use pwt
describe
summarize
summarize if grade!="D"
drop if grade=="D"

*QUESTION 2: CONSTRUCT LOG INCOME AND MAKE PLOT
generate ly60=log(y60)
cap scatter gy ly60, name(fig1, replace)
graph export PS3.png, replace

*QUESTION 3: ESTIMATE GROWTH MODEL
regress gy ly60
	* The following test procedure is found on: http://www.stata.com/support/faqs/statistics/one-sided-tests-for-coefficients/
	* Wald test for the null hypothesis that this coefficient is equal to zero
	test _b[ly60]=0 
	* Determine whether the fitted coefficient is positive or negative
	local sign_ly60 = sign(_b[ly60])
	* Calculate the p-values for the one-sided tests
	display "Ho: coef <= 0  p-value = " ttail(r(df_r), `sign_ly60'*sqrt(r(F)))

*QUESTION 4: SPECIFY INCOME IN ABSOLUTE TERMS AND RE-ESTIMATE MODEL
generate ly60abs=log(y60*31691)
regress gy ly60abs

*QUESTION 5: TEST THE HYPOTHESIS OF CONDITIONAL CONVERGENCE
generate struc=log(sk)-log(n+0.075)
regress gy ly60 struc

*QUESTION 6: OMITTED VARIABLES BIAS 
correlate ly60 struc
su if e(sample)==1

*BIAS ACCORDING TO FORMULAE
di .0156729*0.5324*(.6320516/1.061958)

*DIFFERNCE IN SLR AND MLR ESTIMATES
di -.0005696-(-.0055361)

log close


