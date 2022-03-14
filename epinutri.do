use epinutri_ic
set more off

*usei o logaritmo da renda, pois a variável nao tinha distribuição normal. 


*Passo 1: Verificando o balanceamento inicial das variáveis preditoras. 
tab escolarmae bolsa, col chi2
ttest rendalog, by(bolsa)

*Passo 2: Calculando o escore de propensão 
logistic bolsa i.escolarmae rendalog
predict pbolsa, pr

*Passo 3: Verificando se há zona de suporte comum
graph box pbolsa, ytitle (Escore de propensão) by(bolsa)

*Passo 4: Estimando o efeito causal médio

*Realizando a ponderação pelo inverso da probabilidade de seleção para as variáveis desbalanceadas
gen ipbolsa= 1/pbolsa if bolsa==1
replace ipbolsa= 1/(1 - pbolsa) if bolsa==0
regress am bolsa [pw=ipbolsa]

*Realizando a ponderação pelo inverso da probabilidade de seleção para as variáveis desbalanceadas 
* pelo comando teffects
teffects ipw (am) (bolsa i.escolarmae rendalog)

*Passo 5: Verificando se o balanceamento foi obtido
tebalance summarize
tebalance density rendalog 



