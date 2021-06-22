*** |  (C) 2008-2021 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de

table fm_carbon_density(t_all,j,land,c_pools) LPJmL carbon density for land and carbon pools (tC per ha)
$ondelim
$include "./modules/52_carbon/input/lpj_carbon_stocks.cs3"
$offdelim
;

fm_carbon_density(t_all,j,land,c_pools)$(m_year(t_all) > sm_fix_cc) = fm_carbon_density(t_all,j,land,c_pools)$(m_year(t_all) = sm_fix_cc);
m_fillmissingyears(fm_carbon_density,"j,land,c_pools");
