*** |  (C) 2008-2024 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de


if(m_year(t) <= sm_fix_SSP2,

 v21_trade.up(i_ex,i_im,k_trade)  = i21_trade_hist_bilat_qt(i_ex,i_im,k_trade) ;

 else 

 v21_trade.up(i_ex,i_im,k_trade) = 5000 ;
 
*' (i21_trade_hist_bilat_qt(i_ex,i_im,k_trade) * 1.02**(m_year(t) - sm_fix_SSP2)) / 
*'                                      i21_trade_bal_reduction(t,k_trade)    ;

