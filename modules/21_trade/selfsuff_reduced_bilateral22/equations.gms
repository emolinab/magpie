*** |  (C) 2008-2023 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: mag*** |  (C) 2008-2024 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de

*' @equations
*' In the comparative advantage pool, the active constraint ensures that superregional and thus global supply is larger or equal to demand.
*' This means that production can be freely allocated globally based on comparative advantages.

 q21_trade_glo(k_trade)..
  sum(i2 ,vm_prod_reg(i2,k_trade)) =g=
 sum(i2, vm_supply(i2,k_trade)) + sum(ct,f21_trade_balanceflow(ct,k_trade));

*' amount produced superregionally must be equal to supply + net trade
q21_trade_bilat(h2,k_trade)..
 sum(supreg(h2, i2), vm_prod_reg(i2, k_trade)) =g= sum(supreg(h2,i2), vm_supply(i2, k_trade) -
                              sum(i_ex, v21_trade(i_ex, i2, k_trade))  + sum(i_im, v21_trade(i2, i_im, k_trade)));
*' 
*' For non-tradable commodites, the regional supply should be larger or equal to the regional demand.
 q21_notrade(h2,k_notrade)..
  sum(supreg(h2,i2),vm_prod_reg(i2,k_notrade)) =g= sum(supreg(h2,i2), vm_supply(i2,k_notrade));

*' Amount traded is based on historic ratio of imports to domestic supply, bounded by historically observed standard deviations

q21_trade_lower(i_ex, i_im, k_trade)..
   v21_trade(i_ex, i_im, k_trade) =g= 
   vm_supply(i2, k_trade) * i21_import_supply_ratio(i_ex, i2, k_trade) * s21_import_supply_ratio_factor -
   vm_supply(i2, k_trade) * sum(ct, i21_trade_bilat_stddev(ct, i_ex, i2, k_trade)) * s21_bilateral_lib_factor
 ;


q21_trade_upper(i_ex, i_im, k_trade)..
v21_trade(i_ex, i_im, k_trade) =l= 
 vm_supply(i2, k_trade) * i21_import_supply_ratio(i_ex, i_im, k_trade) * s21_import_supply_ratio_factor +
 vm_supply(i2, k_trade) * sum(ct, i21_trade_bilat_stddev(ct, i_ex, i_im, k_trade)) * s21_bilateral_lib_factor
 ;




*' Trade tariffs are associated with exporting regions. They are dependent on net exports and tariff levels.
 q21_costs_tariffs(i2,k_trade)..
 v21_cost_tariff_reg(i2,k_trade) =g=
  sum(i_im, sum(ct, i21_trade_tariff(ct, i2,i_im,k_trade)) * v21_trade(i2,i_im,k_trade));
 
*' Trade margins costs assigned currently to exporting region. Margins at region level 
q21_costs_margins(i2,k_trade)..
 v21_cost_margin_reg(i2,k_trade) =g=
  sum(i_im, i21_trade_margin(i2,i_im,k_trade) * v21_trade(i2,i_im,k_trade));

*' regional trade costs are the sum of transport margin and tariff costs
q21_cost_trade_reg(i2,k_trade)..
  v21_cost_trade_reg(i2,k_trade) =g=
  v21_cost_tariff_reg(i2,k_trade) + v21_cost_margin_reg(i2,k_trade);

*' Total trade costs are the costs for each region aggregated over all the tradable commodities.
 q21_cost_trade(i2)..
 vm_cost_trade(i2) =e= sum(k_trade, v21_cost_trade_reg(i2,k_trade));
