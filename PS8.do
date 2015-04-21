
*PROBLEM SET 8
clear all
cd "/Users/vrangbaek/Dropbox/KU/Polit/Oekonometri B/F15/Undervisningsnoter/9 (PS7, PS8"

cap log close
log using PS8, replace text

*QUESTION 1: LOAD DATA ON MEN AND CONSTRUCT VARIABLES
use engel
keep if dmale==1

generate lnrxtot=log(xtot/price)
generate lninc=log(nety/price)

*QUESTION 2: RELEVANCE OF IV
regress lnrxtot lninc

*QUESTION 3: IV ESTIMATION
ivregress 2sls wfath (lnrxtot=lninc), small
outreg2 IV using results, replace tex(frag) ctitle(IV)

*OLS RESULTS
regress wfath lnrxtot
outreg2 OLS using results, append tex(frag) ctitle(OLS)

*QUESTION 4: IV ESTIMATION IN MATA
mata 
// INPUT DATA //
y = st_data(.,"wfath")
x = st_data(.,"lnrxtot")
z = st_data(.,"lninc")

// DEFINE CONSTANT AND X AND Z MATRICES //
cons = J(rows(x),1,1)
X = (cons,x)
Z = (cons,z)

// CALCULATE OLS ESTIMATES //
beta_ols=(invsym(X'*X))*(X'*y)

// CALCULATE IV ESTIMATES //
beta_iv= qrinv(Z'*X)*(Z'*y)
beta_iv_general= invsym((X'*Z)*invsym(Z'*Z)*(Z'*X))*(X'*Z)*invsym(Z'*Z)*(Z'*y)

// PRINT RESULTS //
(beta_ols, beta_iv, beta_iv_general)
end

*CLOSE STATA LOG FILE
log close

*CLOSE ALL GRAPHS
window manage close graph _all
