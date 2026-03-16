*** |  (C) 2008-2025 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de

*' Global production must be at least as large as global supply plus balance flows
 q21_trade_glo(k_trade)..
  sum(i2, vm_prod_reg(i2,k_trade)) =g=
  sum(i2, vm_supply(i2,k_trade)) + sum((ct, i2), f21_trade_regional_balanceflow(ct, i2, k_trade));


*' Amount produced superregionally must be equal to supply + net trade
q21_trade_bilat(h2,k_trade)..
 sum(supreg(h2, i2), vm_prod_reg(i2, k_trade)) =g= sum(supreg(h2,i2), vm_supply(i2, k_trade) -
                              sum(i_ex, v21_trade(i_ex, i2, k_trade))  + sum(i_im, v21_trade(i2, i_im, k_trade)) +
                              sum(ct, f21_trade_export_balanceflow(ct, i2, k_trade)) +
                              sum(ct, f21_trade_regional_balanceflow(ct, i2, k_trade)));

*' For non-tradable commodities, the regional supply should be larger or equal to the regional demand.
 q21_notrade(h2,k_notrade)..
  sum(supreg(h2,i2),vm_prod_reg(i2,k_notrade)) =g= sum(supreg(h2,i2), vm_supply(i2,k_notrade));


*' Lower bound on bilateral trade based on historical patterns.
*' Trade flow must be at least the historical share minus a relaxation term.
*' The relaxation is controlled by standard deviation and the liberalization factor.
q21_trade_lower(i_ex,i_im,k_trade)..
 v21_trade(i_ex,i_im,k_trade) =g=
    vm_supply(i_im,k_trade)
    * sum(ct, i21_import_supply_historical(i_ex,i_im,ct,k_trade) * i21_import_supply_scenario(ct)
       - i21_stddev_lib_factor(ct) * i21_trade_bilat_stddev(ct,i_ex,i_im,k_trade));


*' Upper bound on bilateral trade based on historical patterns.
*' Trade flow must be at most the historical share plus a relaxation term.
q21_trade_upper(i_ex,i_im,k_trade)..
 v21_trade(i_ex,i_im,k_trade) =l=
    vm_supply(i_im,k_trade)
    * sum(ct, i21_import_supply_historical(i_ex,i_im,ct,k_trade)
       + i21_stddev_lib_factor(ct) * i21_trade_bilat_stddev(ct,i_ex,i_im,k_trade));


*' Tariff costs are calculated based on trade volume and tariff rates.
q21_costs_tariffs(i2,k_trade)..
 v21_cost_tariff_reg(i2,k_trade) =e= sum((ct,i_im), v21_trade(i2,i_im,k_trade) * i21_trade_tariff(ct,i2,i_im,k_trade));


*' Trade margins costs assigned currently to exporting region. Margins at region level
q21_costs_margins(i2,k_trade)..
 v21_cost_margin_reg(i2,k_trade) =g=
  sum(i_im, i21_trade_margin(i2,i_im,k_trade) * v21_trade(i2,i_im,k_trade));

*' Regional trade costs are the sum of transport margin and tariff costs
q21_cost_trade_reg(i2,k_trade)..
  v21_cost_trade_reg(i2,k_trade) =g=
  v21_cost_tariff_reg(i2,k_trade) + v21_cost_margin_reg(i2,k_trade);

*' Total trade costs are the costs for each region aggregated over all the tradable commodities.
 q21_cost_trade(i2)..
 vm_cost_trade(i2) =e= sum(k_trade, v21_cost_trade_reg(i2,k_trade));
