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
