proc import out=work.guatemala 
datafile='C:\Users\mclaina\OneDrive - University of South Carolina\Classes\755_Spring_2019\References\Multilevel course\guatemala.dta'
dbms=DTA replace;
run;


ods rtf file="C:\Users\mclaina\OneDrive - University of South Carolina\Classes\755_Spring_2019\Examples\24-Multilevel GLMM.rtf";

proc print data=guatemala (obs=10);
run;


proc freq data=guatemala noprint;
tables mom/  out=freq_ID;
run;

title "Frequency of mother-level observations";
proc freq data=freq_ID;
tables COUNT;
run;

proc freq data=guatemala noprint;
tables cluster/  out=freq_ID;
run;

title "Frequency of community-level observations";
proc freq data=freq_ID;
tables COUNT;
run;

 title "Three-level random intercept model";
proc glimmix data=guatemala noitprint NOCLPRINT method=LAPLACE;
class mom cluster;
model immun=kid2p mom25p order23 order46 order7p indNoSpa indSpa momEdPri momEdSec husEdPri husEdSec husEdDK momWork rural pcInd81/d=bin link=logit solution;
random intercept/subject=cluster G;
random intercept/subject=mom(cluster) G;
covtest 'var(cluster) = 0'          0  .;
covtest 'var(mom(cluster)) = 0' .  0;
run;
quit;


 title "Three-level random intercept model with a subset of covariates";
proc glimmix data=guatemala noitprint NOCLPRINT method=LAPLACE;
class mom cluster;
model immun=kid2p rural pcInd81/d=bin link=logit solution;
random intercept/subject=cluster G;
random intercept/subject=mom(cluster) G;
covtest 'var(cluster) = 0'          0  .;
covtest 'var(mom(cluster)) = 0' .  0;
run;
quit;


 title "Using random coefficients";
proc glimmix data=guatemala noitprint NOCLPRINT method=LAPLACE;
class mom cluster;
model immun=kid2p rural pcInd81/d=bin link=logit solution;
random intercept kid2p/subject=cluster type=UN G;
random intercept /subject=mom(cluster) G;
covtest 'var(cluster) = 0'          0  .;
covtest 'var(mom(cluster)) = 0' .  0;
run;
quit;



 title "Baseline Two-level model";
proc glimmix data=guatemala noitprint  NOCLPRINT method=LAPLACE;
class mom cluster;
model immun=kid2p/d=bin link=logit solution;
random intercept kid2p/subject=cluster type=UN G;
run;
quit;



 title "Adjusted Two-level model";
proc glimmix data=guatemala noitprint NOCLPRINT method=LAPLACE;
class mom cluster;
model immun=kid2p rural pcInd81/d=bin link=logit solution;
random intercept kid2p/subject=cluster type=UN G;
run;
quit;

ods rtf close;
