*** |  (C) 2008-2021 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de

$ifthen "%c38_sticky_mode%" == "free" f38_capital_cost_share(i) = 0;
$endif

p38_capital_cost_share(i) = 0;

if (ord(t)<5,
$ifthen "%c38_sticky_mode%" == "dynamic" p38_capital_cost_share(i2) = f38_historical_share(i2,t);
$endif
elseif (ord(t)>=5),
$ifthen "%c38_sticky_mode%" == "dynamic" p38_capital_cost_share(i2) = 0.1870421*log10(sum(i_to_iso(i,iso),im_gdp_pc_ppp_iso(t,iso)))-0.4917691+f38_share_error2010(i2);
$endif
);




$ifthen "%c38_sticky_mode%" == "free" i38_capital_need(i,kcr,"mobile") = f38_fac_req(kcr) * f38_capital_cost_share(i) / (pm_interest(t,i)+s38_depreciation_rate) * (1-s38_immobile);
*$elseif "%c38_sticky_mode%" == "regional" i38_capital_need(i,kcr,"mobile") = f38_fac_req(kcr) * f38_capital_cost_share(i) / (pm_interest(t,i)+s38_depreciation_rate) * (1-s38_immobile);
$elseif "%c38_sticky_mode%" == "dynamic" i38_capital_need(i,kcr,"mobile") = f38_fac_req(kcr)  * p38_capital_cost_share(i) / (pm_interest(t,i)+s38_depreciation_rate) * (1-s38_immobile);
$endif

$ifthen "%c38_sticky_mode%" == "free" i38_capital_need(i,kcr,"immobile") = f38_fac_req(kcr)  * f38_capital_cost_share(i) / (pm_interest(t,i)+s38_depreciation_rate) * s38_immobile;
*$elseif "%c38_sticky_mode%" == "regional" i38_capital_need(i,kcr,"immobile") = f38_fac_req(kcr)  * f38_capital_cost_share(i) / (pm_interest(t,i)+s38_depreciation_rate) * s38_immobile;
$elseif "%c38_sticky_mode%" == "dynamic" i38_capital_need(i,kcr,"immobile") = f38_fac_req(kcr) *p38_capital_cost_share(i) / (pm_interest(t,i)+s38_depreciation_rate) * s38_immobile;
$endif


if (ord(t) = 1,

$ifthen "%c38_sticky_mode%" == "free" i38_variable_costs(i2,kcr) = f38_fac_req(kcr)  * (1-f38_capital_cost_share(i2)) * (1-s38_mi_start);
*$elseif "%c38_sticky_mode%" == "regional" i38_variable_costs(i2,kcr) = f38_fac_req(kcr)  * (1-f38_capital_cost_share(i2)) * (1-s38_mi_start);
$elseif "%c38_sticky_mode%" == "dynamic"  i38_variable_costs(i2,kcr) = f38_fac_req(kcr)  * (1-p38_capital_cost_share(i2)) * (1-s38_mi_start);
$endif

*' Estimate capital stock based on capital remuneration
  p38_capital_immobile(t,j,kcr)   = sum(cell(i,j), i38_capital_need(i,kcr,"immobile")*pm_croparea_start(j,kcr)*f38_region_yield(i,kcr)* fm_tau1995(i));
  p38_capital_mobile(t,j)   = sum((cell(i,j),kcr), i38_capital_need(i,kcr,"mobile")*pm_croparea_start(j,kcr)*f38_region_yield(i,kcr)* fm_tau1995(i));

  vm_prod.l(j,kcr)=sum(cell(i,j),pm_croparea_start(j,kcr)*f38_region_yield(i,kcr)* fm_tau1995(i));
    );


*' The maximum allocation of mobile and immobile capital is equal to the existing capital
vm_cost_inv.up(i)=im_gdp_pc_mer(t,i)*im_pop(t,i)*s38_fraction_gdp;
*$offtext
