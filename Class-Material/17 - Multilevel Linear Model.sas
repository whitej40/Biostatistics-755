libname multi "C:\Users\mclaina\OneDrive - University of South Carolina\Classes\755_Spring_2019\Examples";

data MATHACH;
set multi.Hsb12;
run;

ods rtf file="C:\Users\mclaina\OneDrive - University of South Carolina\Classes\755_Spring_2019\Examples\22 - Multilevel Linear Model.rtf";

proc print data=MATHACH (obs=5);
run;

proc mixed data = MATHACH covtest noclprint;
   class school;
   model mathach = / solution;
   random intercept / subject = school;
run;

proc mixed data = MATHACH covtest noclprint;
   class school;
   model mathach = meanses / solution ddfm = bw;
   random intercept / subject = school;
run;

data MATHACH2;
  set MATHACH;
    cses = ses - meanses;
run;
proc mixed data = MATHACH2 noclprint covtest noitprint;
  class school;
  model mathach = cses / solution ddfm = bw notest;
  random intercept cses / subject = school type = un gcorr;
run;

proc mixed data = MATHACH2 noclprint covtest noitprint;
  class school;
  model mathach = meanses sector cses meanses*cses sector*cses 
                  / solution ddfm = bw notest;
  random intercept cses / subject = school type = un;
run;


data toplot;
  set MATHACH2;
  if meanses <= -0.317 then do;
		ms = -0.317;
 		strata = "Low";   end;
  else if meanses >= 0.333 then do;
		ms = 0.333;
		strata = "Hig";   end;
  else do; ms = 0.038; strata = "Med" ; end;
  predicted = 12.1136 + 5.3391*ms + 1.2167*sector + 2.9388*cses +
              1.0389*ms*cses - 1.6426*sector*cses;
run;
proc sort data = toplot;
   by strata;
run;
goptions reset = all;
symbol1 v = none i = join c = red ;
symbol2 v = none i = join c = blue  ;
axis1 order = (-4 to 3 by 1) minor = none label=("Group Centered SES");
axis2 order = (0 to 22 by 2) minor = none label=(a = 90 "Math Achievement Score");
proc gplot data = toplot;
   by strata;
   plot predicted*cses = sector / vaxis = axis2 haxis = axis1; 
run;
quit; 


proc mixed data = MATHACH2 noclprint covtest noitprint;
  class school;
  model mathach = meanses sector cses meanses*sector 
                  meanses*cses sector*cses meanses*sector*cses 
                  / solution ddfm = bw notest;
  random intercept cses / subject = school type = un;
run;

proc mixed data = MATHACH2 noclprint covtest noitprint;
  class school;
  model mathach = meanses sector cses meanses*cses sector*cses / solution ddfm = bw notest;
  random intercept / subject = school;
run;


data pvalue;
  df = 2; chisq = 46504.8 - 46503.7;
  pvalue = 1 - probchi(chisq, df);
run;
proc print data = pvalue noobs;
run;

ods rtf close;
