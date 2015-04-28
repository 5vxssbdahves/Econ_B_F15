
*PROBLEM SET 9
clear all
cd "C:\Users\okoRJO\Dropbox\Teaching\U Copenhagen\Metrics B 2015 Spring\Class\PS9"
cap log close
log using PS9, replace text

use ivpwt
drop if grade=="D"
generate ly60=log(y60)
generate strucK=log(sk)-log(n+0.075)
generate strucH=log(sh)-log(n+0.075)
summarize

list country if strucH==.
drop if strucH==.
summarize 

*Q2: STEPS 3+4
regress ly60 alatitude strucK strucH
test alatitude
predict xhat, xb
predict ehat, residuals

*Q2: STEP 5
regress gy ly60 strucK strucH ehat

*Q2: STEP 6 (OLS VS IV)
regress gy ly60 strucK strucH
ivregress 2sls gy (ly60=alatitude) strucK strucH, small
drop xhat ehat

*Q3: STEPS 3+4
regress ly60 alatitude yrsopen strucK strucH
test alatitude yrsopen
predict xhat, xb
predict ehat, residuals

*Q3: STEP 5
regress gy ly60 strucK strucH ehat

*Q3: STEP 6 (OLS VS IV)
regress gy ly60 strucK strucH
ivregress 2sls gy (ly60=alatitude yrsopen) strucK strucH, small
predict uhat, residuals

*OI TEST
regress uhat alatitude yrsopen strucK strucH
di e(N)*e(r2)

log close
