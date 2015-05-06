
*PROBLEM SET 10
clear all

*cd "/Users/rfjorgensen/Dropbox/Teaching/U Copenhagen/Metrics B 2014 Fall/Stata conversion"
cd "C:\Users\okoRJO\Dropbox\Teaching\U Copenhagen\Metrics B 2015 Spring\Class\PS10"

cap log close
log using PS10, replace text

use tbpanel

*QUESTION 1: SUMMARY STATISTICS
summarize
summarize if d2002==0
summarize if d2002==1

*QUESTION 2: POOLED OLS
generate kvindeXpension=kvinde*pension

regress tbalder enlig helbred dudd1 dudd2 erfar pension kpenbelob d2002 kvinde kvindeXpension, robust
test kvindeXpension=0
test pension+kvindeXpension=0
predict ehat, residuals
generate SSR=e(rss)

*MANUAL TEST FOR QUESTION 2.B
generate x = kvindeXpension-pension

regress tbalder enlig helbred dudd1 dudd2 erfar pension kpenbelob d2002 kvinde x, robust

*QUESTION 3: FD
sort lbnr d2002
by lbnr: generate diftbalder=tbalder[_n]-tbalder[_n-1]

foreach var in enlig helbred dudd1 dudd2 erfar pension kpenbelob d2002 kvinde kvindeXpension {
	by lbnr: generate dif`var'=`var'[_n]-`var'[_n-1]
}

summarize dif*

regress diftbalder difenlig difhelbred difdudd1 difdudd2 diferfar difpension difkpenbelob difd2002 difkvinde difkvindeXpension, robust
test difkvindeXpension=0
test difpension+difkvindeXpension=0

*QUESTION 4: FE
foreach var in tbalder enlig helbred dudd1 dudd2 erfar pension kpenbelob d2002 kvinde kvindeXpension {
	by lbnr: egen m_`var'=mean(`var')
	generate wt_`var'=`var'-m_`var'

}

regress wt_tbalder wt_enlig wt_helbred wt_dudd1 wt_dudd2 wt_erfar wt_pension wt_kpenbelob wt_d2002 wt_kvinde wt_kvindeXpension

xtset lbnr d2002
xtreg tbalder enlig helbred dudd1 dudd2 erfar pension kpenbelob d2002 kvinde kvindeXpension, fe

*QUESTION 5: RE
*CALCULATE THETA FOLLOWING WOOLDRIDGE PP. 475-476
by lbnr: gen ehat_1=ehat[_n-1]
egen sum_ehat=total(ehat*ehat_1)
gen sigma2_a = (1/(1268*0.5-11))*sum_ehat
gen sigma2_e = (1/(1268-11))*SSR
gen sigma2_u = sigma2_e-sigma2_a
gen theta = 1-(1/(1+2*(sigma2_a/sigma2_u)))^0.5

foreach var in tbalder enlig helbred dudd1 dudd2 erfar pension kpenbelob d2002 kvinde kvindeXpension {
	generate qwt_`var'=`var'-theta*m_`var'

}

regress qwt_tbalder qwt_enlig qwt_helbred qwt_dudd1 qwt_dudd2 qwt_erfar qwt_pension qwt_kpenbelob wt_d2002 qwt_kvinde qwt_kvindeXpension

xtreg tbalder enlig helbred dudd1 dudd2 erfar pension kpenbelob d2002 kvinde kvindeXpension, re

log close
