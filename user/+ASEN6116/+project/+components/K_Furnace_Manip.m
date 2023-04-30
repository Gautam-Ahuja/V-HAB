classdef K_Furnace_Manip < matter.manips.substance.stationary
    methods
        function this = K_Furnace_Manip(sName, oPhase)
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
            fFeProduction = this.oMT.afMolarMass(this.oMT.tiN2I.Fe)/this.oMT.afMolarMass(this.oMT.tiN2I.FeF3)*afFlowRateIn(this.oMT.tiN2I.FeF3);
            fMgOProduction = this.oMT.afMolarMass(this.oMT.tiN2I.MgO)/this.oMT.afMolarMass(this.oMT.tiN2I.MgF2)*afFlowRateIn(this.oMT.tiN2I.MgF2);
            fCaOProduction = this.oMT.afMolarMass(this.oMT.tiN2I.CaO)/this.oMT.afMolarMass(this.oMT.tiN2I.CaF2)*afFlowRateIn(this.oMT.tiN2I.CaF2);
            fAlProduction = this.oMT.afMolarMass(this.oMT.tiN2I.Al)/this.oMT.afMolarMass(this.oMT.tiN2I.AlF3)*afFlowRateIn(this.oMT.tiN2I.AlF3);
            fNa2OProduction = 0.5*this.oMT.afMolarMass(this.oMT.tiN2I.Na2O)/this.oMT.afMolarMass(this.oMT.tiN2I.NaF)*afFlowRateIn(this.oMT.tiN2I.NaF);
            fTiO2Production = this.oMT.afMolarMass(this.oMT.tiN2I.TiO2)/this.oMT.afMolarMass(this.oMT.tiN2I.TiF4)*afFlowRateIn(this.oMT.tiN2I.TiF4);


            % Stoichiometric consumption of K and O2
            fKConsumption = this.oMT.afMolarMass(this.oMT.tiN2I.K)*...
                (3*afFlowRateIn(this.oMT.tiN2I.FeF3)/this.oMT.afMolarMass(this.oMT.tiN2I.FeF3)+...
                2*afFlowRateIn(this.oMT.tiN2I.MgF2)/this.oMT.afMolarMass(this.oMT.tiN2I.MgF2)+...
                2*afFlowRateIn(this.oMT.tiN2I.CaF2)/this.oMT.afMolarMass(this.oMT.tiN2I.CaF2)+...
                3*afFlowRateIn(this.oMT.tiN2I.AlF3)/this.oMT.afMolarMass(this.oMT.tiN2I.AlF3)+...
                1*afFlowRateIn(this.oMT.tiN2I.NaF)/this.oMT.afMolarMass(this.oMT.tiN2I.NaF)+...
                4*afFlowRateIn(this.oMT.tiN2I.TiF4)/this.oMT.afMolarMass(this.oMT.tiN2I.TiF4));

            fO2Consumption = this.oMT.afMolarMass(this.oMT.tiN2I.O2)*...
                (.5*fMgOProduction/this.oMT.afMolarMass(this.oMT.tiN2I.MgO)+...
                .5*fCaOProduction/this.oMT.afMolarMass(this.oMT.tiN2I.CaO)+...
                .5*fNa2OProduction/this.oMT.afMolarMass(this.oMT.tiN2I.Na2O)+...
                fTiO2Production/this.oMT.afMolarMass(this.oMT.tiN2I.TiO2));

            % Set output flows
            afPartialFlowRates = zeros(1, this.oPhase.oMT.iSubstances);
            afPartialFlowRates(this.oMT.tiN2I.Fe) = fFeProduction;
            afPartialFlowRates(this.oMT.tiN2I.MgO) = fMgOProduction;
            afPartialFlowRates(this.oMT.tiN2I.CaO) = fCaOProduction;
            afPartialFlowRates(this.oMT.tiN2I.Al) = fAlProduction;
            afPartialFlowRates(this.oMT.tiN2I.Na2O) = fNa2OProduction;
            afPartialFlowRates(this.oMT.tiN2I.TiO2) = fTiO2Production;

            afPartialFlowRates(this.oMT.tiN2I.FeF3) = -afFlowRateIn(this.oMT.tiN2I.FeF3);
            afPartialFlowRates(this.oMT.tiN2I.MgF2) = -afFlowRateIn(this.oMT.tiN2I.MgF2);
            afPartialFlowRates(this.oMT.tiN2I.CaF2) = -afFlowRateIn(this.oMT.tiN2I.CaF2);
            afPartialFlowRates(this.oMT.tiN2I.AlF3) = -afFlowRateIn(this.oMT.tiN2I.AlF3);
            afPartialFlowRates(this.oMT.tiN2I.NaF) = -afFlowRateIn(this.oMT.tiN2I.NaF);
            afPartialFlowRates(this.oMT.tiN2I.TiF4) = -afFlowRateIn(this.oMT.tiN2I.TiF4);
            afPartialFlowRates(this.oMT.tiN2I.K) = -fKConsumption;
            afPartialFlowRates(this.oMT.tiN2I.O2) = -fO2Consumption;

            % Any unaccounted mass is KF
            afPartialFlowRates(this.oMT.tiN2I.KF) = -sum(afPartialFlowRates);

            update@matter.manips.substance.stationary(this, afPartialFlowRates);
            this.trigger('K_Furnace_Manip_Update');
        end
    end
end