
*PROBLEM SET 5
clear all
cd "/Users/vrangbaek/Dropbox/KU/Polit/Oekonometri B/F15/Undervisningsnoter/6 (PS4, A1, PS5)/"
cap log close
log using PS5, replace text

*QUESTION 1.A: LOAD AND SET UP DATA
use pwt
describe

list country if grade=="D"
drop if grade=="D"
generate ly60=log(y60)
generate strucK=log(sk)-log(n+0.075)
generate strucH=log(sh)-log(n+0.075)
summarize

list country if strucH==.

drop if strucH==.
summarize 

*QUESTION 1.B: ESTIMATE MODEL
regress gy ly60 strucK strucH
generate SSR_ur=e(rss)

*CRITICAL VALUE FOR ONE-SIDED T-TEST
display invttail(77,.05)

*QUESTION 1.C: 
regress gy ly60
generate SSR_r=e(rss)

*QUESTION 1.D: TEST IF STRUCTURAL CHARACTERISTICS CAN BE JOINTLY OMITTED 
*i) MANUALLY
generate Ftest=((SSR_r-SSR_ur)/2)/(SSR_ur/(77-3-1))
di Ftest

*CRITICAL VALUE FOR F-TEST
display invFtail(2,77-3-1,0.05)

*ii) USING STATA's TEST COMMAND
quietly regress gy ly60 strucK strucH
test strucK=strucH=0

*QUESTION 2: OLS ESTIMATION IN MATA 

mata 
// INPUT DATA //
y = st_data(.,"gy")
x = st_data(.,"ly60 strucK strucH")
x

// DEFINE CONSTANT AND X-MATRIX //
cons = J(rows(x),1,1)
X = (x,cons)
X

// CALCULATE OLS ESTIMATES //
beta_hat=(invsym(X'*X))*(X'*y)

// CALCULATE OLS STD ERRORS //
u_hat=y-X*beta_hat
s2=(1/(rows(X)-cols(X)))*(u_hat'*u_hat)
V_ols=s2*invsym(X'*X)
se_ols=sqrt(diagonal(V_ols))

// CALCULATE T TEST STATISTICS //
ttest=beta_hat:/se_ols

// PRINT RESULTS //
(beta_hat, se_ols, ttest)
end


log close


