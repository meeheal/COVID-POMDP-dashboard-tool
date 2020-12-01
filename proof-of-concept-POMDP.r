##############setup
require(pomdp)
require(igraph)
require(visNetwork)
require(colorspace)
#It is assumed COVID is going around (there is a breakout)
numCont <- 10
pContTrace <- 0.5
pFalseSym <- 0.02
rwdIsolate1 <- 0
rwdTest1 <- 18
rwdPost1 <- 20
rwdPost2 <- 0
rwdTest2 <- 3
rwdIsolate2 <- 20
pInf <- 0.0086
pPosE <- 0.6  #what probability do you have a positive Test result for someone who has 
              #recently been exposed and not yet started incubation?
pPosI <- 0.97 #what probability do you have a positive Test result for someone who has
              #COVID-19 for 2 or more days?
pFalsePosS <- 0.01 #what probability do you have a (false) positive Test result 
                    #for someone who 
              #does not have COVID-19 but has also never had COVID-19?
pFalsePosR <- 0.25 #what probability do you have a (false) positive Test result 
                    #for someone who
                   #has had COVID-19 but has recovered?
############# Likely   Often   Sometimes   Seldom    Unlikely
#Note this is made up
#To make a better POMDP, collection of regional data would be completed 
#The POMDP tool could collect its own data 
#PE would be the most difficult to collect as it depends on the Contact tracing effort
#level, success and prevalence.
Likely <- 0.85
Often <- 0.55
Sometimes <- 0.3
Seldom <- 0.15
Unlikely <- 0.025
O_S_NA <- Likely             
O_S_PE <- 1 - pContTrace 
O_S_LS <- pFalseSym
O_S_PS <- pFalseSym   
O_S_DS <- pFalseSym
O_S_WS <- pFalseSym/2
O_PE_NA <- 1 - pContTrace
O_PE_PE <- Likely
O_PE_LS <- pFalseSym
O_PE_PS <- pFalseSym   
O_PE_DS <- pFalseSym
O_PE_WS <- pFalseSym/2
O_E_NA <- Often                                 
O_E_PE <- pContTrace  
O_E_LS <- pFalseSym
O_E_PS <- pFalseSym
O_E_DS <- Unlikely
O_E_WS <- pFalseSym/2
O_Inc1_NA <- Often                    
O_Inc1_PE <- pContTrace
O_Inc1_LS <- pFalseSym
O_Inc1_PS <- pFalseSym
O_Inc1_DS <- Unlikely
O_Inc1_WS <- pFalseSym/2
O_Inc2_NA <- Often
O_Inc2_PE <- pContTrace
O_Inc2_LS <- pFalseSym
O_Inc2_PS <- pFalseSym
O_Inc2_DS <- Unlikely
O_Inc2_WS <- pFalseSym/2
O_InfP_NA <- Often
O_InfP_PE <- (1 - (1 - pInf)^numCont + pContTrace)/2
O_InfP_LS <- pFalseSym
O_InfP_PS <- pFalseSym
O_InfP_DS <- Seldom
O_InfP_WS <- pFalseSym/2
#After presymptomatic period (Exposed, Incubation1 & 2 and Infectious-Presymptomatic)
#The basic tendency is people start to feel symptoms so the NA becomes rare 
O_InfS1_NA <- Sometimes
O_InfS1_PE <- 1 - (1 - pInf)^numCont  
O_InfS1_LS <- Unlikely
O_InfS1_PS <- Unlikely
O_InfS1_DS <- Often
O_InfS1_WS <- Seldom
O_InfS2_NA <- Sometimes 
O_InfS2_PE <- 1 - (1 - pInf)^numCont 
O_InfS2_LS <- Unlikely
O_InfS2_PS <- Often
O_InfS2_DS <- Seldom
O_InfS2_WS <- Seldom
O_InfS3_NA <- Sometimes  
O_InfS3_PE <- 1 - (1 - pInf)^numCont 
O_InfS3_LS <- Unlikely
O_InfS3_PS <- Often
O_InfS3_DS <- Unlikely
O_InfS3_WS <- Sometimes
O_InfS4_NA <- Sometimes
O_InfS4_PE <- 1 - (1 - pInf)^numCont 
O_InfS4_LS <- Sometimes
O_InfS4_PS <- Often
O_InfS4_DS <- Unlikely
O_InfS4_WS <- Seldom
O_R_NA <- Likely
O_R_PE <- 1 - pContTrace  
O_R_LS <- (Often + pFalseSym)/2
O_R_PS <- pFalseSym   # 
O_R_DS <- pFalseSym
O_R_WS <- pFalseSym/2
#There's one observation vector for every state
#c("NA", "DS", "PS", "WS", "LS", "CPos", "Pos", "Neg"),
ObsS <- round_stochastic(c(O_S_NA, O_S_DS, O_S_PS, O_S_WS, O_S_LS, O_S_PE, 0, 0)/sum(
  c(O_S_NA, O_S_DS, O_S_PS, O_S_WS, O_S_LS, O_S_PE, 0, 0)), digits = 3)
ObsPE <- round_stochastic(c(O_PE_NA, O_PE_DS, O_PE_PS, O_PE_WS, O_PE_LS, O_PE_PE, 0, 0)/sum(
  c(O_PE_NA, O_PE_DS, O_PE_PS, O_PE_WS, O_PE_LS, O_PE_PE, 0, 0)), digits = 3)
ObsE <- round_stochastic(c(O_E_NA, O_E_DS, O_E_PS, O_E_WS, O_E_LS, O_E_PE, 0, 0)/sum(
  c(O_E_NA, O_E_DS, O_E_PS, O_E_WS, O_E_LS, O_E_PE, 0, 0)), digits = 3)
ObsInc1 <- round_stochastic(c(O_Inc1_NA, O_Inc1_DS, O_Inc1_PS, 
                              O_Inc1_WS, O_Inc1_LS, O_Inc1_PE, 0, 0)/sum(
  c(O_Inc1_NA, O_Inc1_DS, O_Inc1_PS, O_Inc1_WS, O_Inc1_LS, O_Inc1_PE, 0, 0)), digits = 3)
ObsInc2 <- round_stochastic(c(O_Inc2_NA, O_Inc2_DS, O_Inc2_PS, 
                              O_Inc2_WS, O_Inc2_LS, O_Inc2_PE, 0, 0)/sum(
  c(O_Inc2_NA, O_Inc2_DS, O_Inc2_PS, O_Inc2_WS, O_Inc2_LS, O_Inc2_PE, 0, 0)), digits = 3)
ObsInfP <- round_stochastic(c(O_InfP_NA, O_InfP_DS, O_InfP_PS, 
                              O_InfP_WS, O_InfP_LS, O_InfP_PE, 0, 0)/sum(
  c(O_InfP_NA, O_InfP_DS, O_InfP_PS, O_InfP_WS, O_InfP_LS, O_InfP_PE, 0, 0)), digits = 3)
ObsInfS1 <- round_stochastic(c(O_InfS1_NA, O_InfS1_DS, O_InfS1_PS, 
                               O_InfS1_WS, O_InfS1_LS, O_InfS1_PE, 0, 0)/sum(
  c(O_InfS1_NA, O_InfS1_DS, O_InfS1_PS, O_InfS1_WS, O_InfS1_LS, O_InfS1_PE, 0, 0)), digits = 3)
ObsInfS2 <- round_stochastic(c(O_InfS2_NA, O_InfS2_DS, O_InfS2_PS, 
                               O_InfS2_WS, O_InfS2_LS, O_InfS2_PE, 0, 0)/sum(
  c(O_InfS2_NA, O_InfS2_DS, O_InfS2_PS, O_InfS2_WS, O_InfS2_LS, O_InfS2_PE, 0, 0)), digits = 3)
ObsInfS3 <- round_stochastic(c(O_InfS3_NA, O_InfS3_DS, O_InfS3_PS, 
                               O_InfS3_WS, O_InfS3_LS, O_InfS3_PE, 0, 0)/sum(
  c(O_InfS3_NA, O_InfS3_DS, O_InfS3_PS, O_InfS3_WS, O_InfS3_LS, O_InfS3_PE, 0, 0)), digits = 3)
ObsInfS4 <- round_stochastic(c(O_InfS4_NA, O_InfS4_DS, O_InfS4_PS, 
                               O_InfS4_WS, O_InfS4_LS, O_InfS4_PE, 0, 0)/sum(
  c(O_InfS4_NA, O_InfS4_DS, O_InfS4_PS, O_InfS4_WS, O_InfS4_LS, O_InfS4_PE, 0, 0)), digits = 3)
ObsR <- round_stochastic(c(O_R_NA, O_R_DS, O_R_PS, O_R_WS, O_R_LS, O_R_PE, 0, 0)/sum(
  c(O_R_NA, O_R_DS, O_R_PS, O_R_WS, O_R_LS, O_R_PE, 0, 0)), digits = 3)

COVID_POMDP <- POMDP(
  name = "Emile's COVID POMDP",
  discount = 0.94,
  observations = c("NA", "DS", "PS", "WS", "LS", "PE", "Pos", "Neg"),
  actions = c("Test", "Post", "Isolate"),
  states = c("Susceptible", "Potentially_Exposed", "Exposed", "Incubation_1_of_2", "Incubation_2_of_2", "Infectious_pre_symptomatic", "Infectious_asym_sym_1_of_4", "Infectious_asym_sym_2_of_4", "Infectious_asym_sym_3_of_4","Infectious_asym_sym_4_of_4", "Recovered"),
  horizon = Inf, 
  start = round_stochastic(
    c((1 - pInf)^5, (1 - (1 - pInf)^5)/12, (1 - (1 - pInf)^5)/6, (1 - (1 - pInf)^5)/6, 
      (1 - (1 - pInf)^5)/6, (1 - (1 - pInf)^5)/12, (1 - (1 - pInf)^5)/12, 
      (1 - (1 - pInf)^5)/12, (1 - (1 - pInf)^5)/12, (1 - (1 - pInf)^5)/12, 0)/
      sum(c((1 - pInf)^5, (1 - (1 - pInf)^5)/12, (1 - (1 - pInf)^5)/6, (1 - (1 - pInf)^5)/6, 
            (1 - (1 - pInf)^5)/6, (1 - (1 - pInf)^5)/12, (1 - (1 - pInf)^5)/12, 
            (1 - (1 - pInf)^5)/12, (1 - (1 - pInf)^5)/12, (1 - (1 - pInf)^5)/12)), digits = 3),
  #T_(action = "*", start.state = "*", end.state = "*", probability)
  transition_prob = list(
    "Test" = rbind(
      c((1 - pInf)^numCont - pInf,  1 - (1 - pInf)^numCont, pInf,    0,    0,    0,    0,    0,    0,    0,    0), #S
      c((1 - pInf)^numCont,  0, 1 - (1 - pInf)^numCont,    0,    0,    0,    0,    0,    0,    0,    0), #PE
      c(0,        0,     0,    1,    0,    0,    0,    0,    0,    0,    0), #E
      c(0,        0,     0, 0.49, 0.51,    0,    0,    0,    0,    0,    0), #Incubation1
      c(0,        0,     0,    0, 0.49, 0.51,    0,    0,    0,    0,    0), #Incubation2
      c(0,        0,     0,    0,    0, 0.49, 0.51,    0,    0,    0,    0), #Inf_presymptomatic
      c(0,        0,     0,    0,    0,    0, 0.25, 0.75,    0,    0,    0), #Inf_asym_sym1
      c(0,        0,     0,    0,    0,    0,    0, 0.25, 0.75,    0,    0), #Inf_asym_sym2
      c(0,        0,     0,    0,    0,    0,    0,    0, 0.25, 0.75,    0), #Inf_asym_sym3
      c(0,        0,     0,    0,    0,    0,    0,    0,    0, 0.25, 0.75), #Inf_asym_sym4
      c(0,        0,     0,    0,    0,    0,    0,    0,    0,    0,    1)),#R
    "Post" = rbind(
      c((1 - pInf)^numCont - pInf,  1 - (1 - pInf)^numCont, pInf,    0,    0,    0,    0,    0,    0,    0,    0), #S
      c((1 - pInf)^numCont,  0, 1 - (1 - pInf)^numCont,    0,    0,    0,    0,    0,    0,    0,    0), #PE
      c(0,        0,     0,    1,    0,    0,    0,    0,    0,    0,    0), #E
      c(0,        0,     0, 0.49, 0.51,    0,    0,    0,    0,    0,    0), #Incubation1
      c(0,        0,     0,    0, 0.49, 0.51,    0,    0,    0,    0,    0), #Incubation2
      c(0,        0,     0,    0,    0, 0.49, 0.51,    0,    0,    0,    0), #Inf_presymptomatic
      c(0,        0,     0,    0,    0,    0, 0.25, 0.75,    0,    0,    0), #Inf_asym_sym1
      c(0,        0,     0,    0,    0,    0,    0, 0.25, 0.75,    0,    0), #Inf_asym_sym2
      c(0,        0,     0,    0,    0,    0,    0,    0, 0.25, 0.75,    0), #Inf_asym_sym3
      c(0,        0,     0,    0,    0,    0,    0,    0,    0, 0.25, 0.75), #Inf_asym_sym4
      c(0,        0,     0,    0,    0,    0,    0,    0,    0,    0,    1)),#R
    "Isolate" = rbind(
      c(        1,     0,    0,    0,    0,    0,    0,    0,    0,    0,    0), #S
      c(        1,     0,    0,    0,    0,    0,    0,    0,    0,    0,    0), #PE
      c(0,        0,     0,    1,    0,    0,    0,    0,    0,    0,    0), #E
      c(0,        0,     0, 0.49, 0.51,    0,    0,    0,    0,    0,    0), #Incubation1
      c(0,        0,     0,    0, 0.49, 0.51,    0,    0,    0,    0,    0), #Incubation2
      c(0,        0,     0,    0,    0, 0.49, 0.51,    0,    0,    0,    0), #Inf_presymptomatic
      c(0,        0,     0,    0,    0,    0, 0.25, 0.75,    0,    0,    0), #Inf_asym_sym1
      c(0,        0,     0,    0,    0,    0,    0, 0.25, 0.75,    0,    0), #Inf_asym_sym2
      c(0,        0,     0,    0,    0,    0,    0,    0, 0.25, 0.75,    0), #Inf_asym_sym3
      c(0,        0,     0,    0,    0,    0,    0,    0,    0, 0.25, 0.75), #Inf_asym_sym4
      c(0,        0,     0,    0,    0,    0,    0,    0,    0,    0,    1)) #R
    
  ),
  #R_(action = "*", start.state = "*", end.state = "*", observation = "*", value)
  reward = rbind(
    R_("Test", 0, v = rwdTest1),
    R_("Post", 0, v = rwdPost1),
    R_("Isolate", 0, v = rwdIsolate1),
    R_("Test", 1, v = rwdTest1),
    R_("Post", 1, v = rwdPost1),
    R_("Isolate", 1, v = rwdIsolate1),
    R_("Test", 2, v = -100),
    R_("Post", 2, v = -100),
    R_("Isolate", 2, v = -100),
    R_("Test", 3, v = rwdTest2),
    R_("Post", 3, v = rwdPost2),
    R_("Isolate", 3, v = rwdIsolate2),
    R_("Test", 4, v = rwdTest2),
    R_("Post", 4, v = rwdPost2),
    R_("Isolate", 4, v = rwdIsolate2),
    R_("Test", 5, v = rwdTest2),
    R_("Post", 5, v = rwdPost2),
    R_("Isolate", 5, v = rwdIsolate2),
    R_("Test", 6, v = rwdTest2),
    R_("Post", 6, v = rwdPost2),
    R_("Isolate", 6, v = rwdIsolate2),
    R_("Test", 7, v = rwdTest2),
    R_("Post", 7, v = rwdPost2),
    R_("Isolate", 7, v = rwdIsolate2),
    R_("Test", 8, v = rwdTest2),
    R_("Post", 8, v = rwdPost2),
    R_("Isolate", 8, v = rwdIsolate2),
    R_("Test", 9, v = rwdTest2),
    R_("Post", 9, v = rwdPost2),
    R_("Isolate", 9, v = rwdIsolate2),
    R_("Test", 10, v = rwdTest1),
    R_("Post", 10, v = rwdPost1),
    R_("Isolate", 10, v = rwdIsolate1)
  ),
  #O_(action = "*", end.state = "*", observation = "*", probability)
  observation_prob = list(
    "Test" = rbind( round_stochastic(c(ObsS[1:6]/10, 0.9*pFalsePosS, 0.9 - 0.9*pFalsePosS)),
                    round_stochastic(c(ObsPE[1:6]/10, 0.9*pFalsePosS, 0.9 - 0.9*pFalsePosS)),
                    round_stochastic(c(ObsE[1:6]/10, 0.9*pPosE, 0.9 - 0.9*pPosE)),
                    round_stochastic(c(ObsInc1[1:6]/10, 0.9*pPosI, 0.9 - 0.9*pPosI)),
                    round_stochastic(c(ObsInc2[1:6]/10, 0.9*pPosI, 0.9 - 0.9*pPosI)),
                    round_stochastic(c(ObsInfP[1:6]/10, 0.9*pPosI, 0.9 - 0.9*pPosI)),
                    round_stochastic(c(ObsInfS1[1:6]/10, 0.9*pPosI, 0.9 - 0.9*pPosI)),
                    round_stochastic(c(ObsInfS2[1:6]/10, 0.9*pPosI, 0.9 - 0.9*pPosI)),
                    round_stochastic(c(ObsInfS3[1:6]/10, 0.9*pPosI, 0.9 - 0.9*pPosI)),
                    round_stochastic(c(ObsInfS4[1:6]/10, 0.9*pPosI, 0.9 - 0.9*pPosI)),
                    round_stochastic(c(ObsR[1:6]/10, 0.9*pFalsePosR, 0.9 - 0.9*pFalsePosR))),
    "Isolate" = rbind( round_stochastic(c(ObsS[1:6]*0.9, pFalsePosS/10, 0.1 - 0.1*pFalsePosS)),
                       round_stochastic(c(ObsPE[1:6]*0.9, pFalsePosS/10, 0.1 - 0.1*pFalsePosS)),
                       round_stochastic(c(ObsE[1:6]*0.9, pPosE/10, 0.1 - 0.1*pPosE)),
                       round_stochastic(c(ObsInc1[1:6]*0.9, pPosI/10, 0.1 - 0.1*pPosI)),
                       round_stochastic(c(ObsInc2[1:6]*0.9, pPosI/10, 0.1 - 0.1*pPosI)),
                       round_stochastic(c(ObsInfP[1:6]*0.9, pPosI/10, 0.1 - 0.1*pPosI)),
                       round_stochastic(c(ObsInfS1[1:6]*0.9, pPosI/10, 0.1 - 0.1*pPosI)),
                       round_stochastic(c(ObsInfS2[1:6]*0.9, pPosI/10, 0.1 - 0.1*pPosI)),
                       round_stochastic(c(ObsInfS3[1:6]*0.9, pPosI/10, 0.1 - 0.1*pPosI)),
                       round_stochastic(c(ObsInfS4[1:6]*0.9, pPosI/10, 0.1 - 0.1*pPosI)),
                       round_stochastic(c(ObsR[1:6]*0.9, pFalsePosR/10, 0.1 - 0.1*pFalsePosR))),
    "Post" = rbind( round_stochastic(c(ObsS[1:6]*0.9, pFalsePosS/10, 0.1 - 0.1*pFalsePosS)),
                    round_stochastic(c(ObsPE[1:6]*0.9, pFalsePosS/10, 0.1 - 0.1*pFalsePosS)),
                    round_stochastic(c(ObsE[1:6]*0.9, pPosE/10, 0.1 - 0.1*pPosE)),
                    round_stochastic(c(ObsInc1[1:6]*0.9, pPosI/10, 0.1 - 0.1*pPosI)),
                    round_stochastic(c(ObsInc2[1:6]*0.9, pPosI/10, 0.1 - 0.1*pPosI)),
                    round_stochastic(c(ObsInfP[1:6]*0.9, pPosI/10, 0.1 - 0.1*pPosI)),
                    round_stochastic(c(ObsInfS1[1:6]*0.9, pPosI/10, 0.1 - 0.1*pPosI)),
                    round_stochastic(c(ObsInfS2[1:6]*0.9, pPosI/10, 0.1 - 0.1*pPosI)),
                    round_stochastic(c(ObsInfS3[1:6]*0.9, pPosI/10, 0.1 - 0.1*pPosI)),
                    round_stochastic(c(ObsInfS4[1:6]*0.9, pPosI/10, 0.1 - 0.1*pPosI)),
                    round_stochastic(c(ObsR[1:6]*0.9, pFalsePosR/10, 0.1 - 0.1*pFalsePosR)))
  )  
)
