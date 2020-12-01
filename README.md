# COVID-POMDP-dashboard-tool
The dashboard made with flexdashboard using package 'pomdp' in R

The dashboard is to assess the COVID-19 status of one individual.

The centre node represents the current belief. (hover over node for details)

A start node represents a generic individual in a population whom you should assume has a small likelihood of having COVID-19, for example, depending on the population prevalence.

Then moving along one edge represents one day's time. 

If the individual has developed symptoms three days ago, then allow for three observations, the first of which is developed symptoms (DS).

The observations can either increase your belief that the individual may have COVID-19.

The possible actions are Post, Test or Isolate. Post means do nothing, Test means the individual should get tested and Isolate means the individual should Isolate (test would then be administered in isolation).

Full details are included in the draft DRDC-RDDC publication: Uncertainty decision support for COVID-19 community spread with partially observable Markov decision process:
A proof-of-concept application with public health and military applications

sessionInfo()
R version 4.0.2 (2020-06-22)
Platform: x86_64-w64-mingw32/x64 (64-bit)
Running under: Windows 10 x64 (build 17763)

Matrix products: default

locale:
[1] LC_COLLATE=English_Canada.1252  LC_CTYPE=English_Canada.1252   
[3] LC_MONETARY=English_Canada.1252 LC_NUMERIC=C                   
[5] LC_TIME=English_Canada.1252    

attached base packages:
[1] stats     graphics  grDevices utils     datasets  methods   base     

other attached packages:
[1] colorspace_1.4-1 visNetwork_2.0.9 pomdp_0.99.0-1   igraph_1.2.5    

loaded via a namespace (and not attached):
 [1] viridisLite_0.3.0   digest_0.6.25       jsonlite_1.7.0      magrittr_1.5       
 [5] evaluate_0.14       highr_0.8           rlang_0.4.6         curl_4.3           
 [9] rmarkdown_2.3       flexdashboard_0.5.2 tools_4.0.2         htmlwidgets_1.5.1  
[13] tinytex_0.24        Ternary_1.1.4       xfun_0.15           yaml_2.2.1         
[17] rsconnect_0.8.16    compiler_4.0.2      pkgconfig_2.0.3     askpass_1.1        
[21] htmltools_0.5.0     openssl_1.4.2       knitr_1.29        
