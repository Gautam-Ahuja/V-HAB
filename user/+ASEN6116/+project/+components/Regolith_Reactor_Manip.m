classdef Regolith_Reactor_Manip < matter.manips.substance.stationary
    methods
        function this = Regolith_Reactor_Manip(sName, oPhase)
            this@matter.manips.substance.stationary(sName, oPhase);
 
        end
    end
     
    methods (Access = protected)
        function update(this)
            [afFlowRate, mrPartials] = this.getInFlows();
            if isempty(afFlowRate)
                afFlowRateIn = zeros(1, this.oPhase.oMT.iSubstances);
            else
                afFlowRateIn = sum(afFlowRate .* mrPartials(1,:),1);
            end

            % Stoichiometric reaction for production
            fSiF4Production = this.oMT.afMolarMass(this.oMT.tiN2I.SiF4)/this.oMT.afMolarMass(this.oMT.tiN2I.SiO2)*afFlowRateIn(this.oMT.tiN2I.SiO2);
            fTiF4Production = this.oMT.afMolarMass(this.oMT.tiN2I.TiF4)/this.oMT.afMolarMass(this.oMT.tiN2I.TiO2)*afFlowRateIn(this.oMT.tiN2I.TiO2);
            fFeF3Production = this.oMT.afMolarMass(this.oMT.tiN2I.FeF3)/this.oMT.afMolarMass(this.oMT.tiN2I.FeO)*afFlowRateIn(this.oMT.tiN2I.FeO);
            fMgF2Production = this.oMT.afMolarMass(this.oMT.tiN2I.MgF2)/this.oMT.afMolarMass(this.oMT.tiN2I.MgO)*afFlowRateIn(this.oMT.tiN2I.MgO);
            fCaF2Production = this.oMT.afMolarMass(this.oMT.tiN2I.CaF2)/this.oMT.afMolarMass(this.oMT.tiN2I.CaO)*afFlowRateIn(this.oMT.tiN2I.CaO);
            fAlF3Production = 2*this.oMT.afMolarMass(this.oMT.tiN2I.AlF3)/this.oMT.afMolarMass(this.oMT.tiN2I.Al2O3)*afFlowRateIn(this.oMT.tiN2I.Al2O3);
            fNaFProduction = 2*this.oMT.afMolarMass(this.oMT.tiN2I.NaF)/this.oMT.afMolarMass(this.oMT.tiN2I.Na2O)*afFlowRateIn(this.oMT.tiN2I.Na2O);

            % Stoichiometric consumption of F2
            fF2Consumption = this.oMT.afMolarMass(this.oMT.tiN2I.F2)*(...
                2*fSiF4Production/this.oMT.afMolarMass(this.oMT.tiN2I.SiF4)+...
                2*fTiF4Production/this.oMT.afMolarMass(this.oMT.tiN2I.TiF4)+...
                1.5*fFeF3Production/this.oMT.afMolarMass(this.oMT.tiN2I.FeF3)+...
                fMgF2Production/this.oMT.afMolarMass(this.oMT.tiN2I.MgF2)+...
                fCaF2Production/this.oMT.afMolarMass(this.oMT.tiN2I.CaF2)+...
                1.5*fAlF3Production/this.oMT.afMolarMass(this.oMT.tiN2I.AlF3)+...
                0.5*fNaFProduction/this.oMT.afMolarMass(this.oMT.tiN2I.NaF));

            % Set output flows
            afPartialFlowRates = zeros(1, this.oPhase.oMT.iSubstances);
            afPartialFlowRates(this.oMT.tiN2I.SiF4) = fSiF4Production;
            afPartialFlowRates(this.oMT.tiN2I.TiF4) = fTiF4Production;
            afPartialFlowRates(this.oMT.tiN2I.FeF3) = fFeF3Production;
            afPartialFlowRates(this.oMT.tiN2I.MgF2) = fMgF2Production;
            afPartialFlowRates(this.oMT.tiN2I.CaF2) = fCaF2Production;
            afPartialFlowRates(this.oMT.tiN2I.AlF3) = fAlF3Production;
            afPartialFlowRates(this.oMT.tiN2I.NaF) = fNaFProduction;

            % Account for excess fluorine
            afPartialFlowRates(this.oMT.tiN2I.F2) = afFlowRateIn(this.oMt.tiN2I.F2) - fF2Consumption;

            % Any unaccounted mass is oxygen
            afPartialFlowRates(this.oMT.tiN2I.O2) = -sum(afPartialFlowRates);

            update@matter.manips.substance.stationary(this, afPartialFlowRates);
        end
    end
end