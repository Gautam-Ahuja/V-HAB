classdef Regolith_Reactor_Manip < matter.manips.substance.stationary & event.source
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
                afFlowRateIn = sum(afFlowRate .* mrPartials,1);
            end

            % Stoichiometric reaction for production
            fSiF4Production = this.oMT.afMolarMass(this.oMT.tiN2I.SiF4)/this.oMT.afMolarMass(this.oMT.tiN2I.SiO2)*0.474*afFlowRateIn(this.oMT.tiN2I.Regolith);
            fTiF4Production = this.oMT.afMolarMass(this.oMT.tiN2I.TiF4)/this.oMT.afMolarMass(this.oMT.tiN2I.TiO2)*0.031*afFlowRateIn(this.oMT.tiN2I.Regolith);
            fFeF3Production = this.oMT.afMolarMass(this.oMT.tiN2I.FeF3)/this.oMT.afMolarMass(this.oMT.tiN2I.FeO)*0.123*afFlowRateIn(this.oMT.tiN2I.Regolith);
            fMgF2Production = this.oMT.afMolarMass(this.oMT.tiN2I.MgF2)/this.oMT.afMolarMass(this.oMT.tiN2I.MgO)*0.143*afFlowRateIn(this.oMT.tiN2I.Regolith);
            fCaF2Production = this.oMT.afMolarMass(this.oMT.tiN2I.CaF2)/this.oMT.afMolarMass(this.oMT.tiN2I.CaO)*0.132*afFlowRateIn(this.oMT.tiN2I.Regolith);
            fAlF3Production = 2*this.oMT.afMolarMass(this.oMT.tiN2I.AlF3)/this.oMT.afMolarMass(this.oMT.tiN2I.Al2O3)*0.091*afFlowRateIn(this.oMT.tiN2I.Regolith);
            fNaFProduction = 2*this.oMT.afMolarMass(this.oMT.tiN2I.NaF)/this.oMT.afMolarMass(this.oMT.tiN2I.Na2O)*0.006*afFlowRateIn(this.oMT.tiN2I.Regolith);

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

            % Set consumption flows
            afPartialFlowRates(this.oMT.tiN2I.F2) = -fF2Consumption;
            afPartialFlowRates(this.oMT.tiN2I.Regolith) = -afFlowRateIn(this.oMT.tiN2I.Regolith);

            % Any unaccounted mass is oxygen
            afPartialFlowRates(this.oMT.tiN2I.O2) = -sum(afPartialFlowRates);

            update@matter.manips.substance.stationary(this, afPartialFlowRates);
            this.trigger('Regolith_Reactor_Manip_Update')
        end
    end
end