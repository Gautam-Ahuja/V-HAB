classdef KF_Electrolyzer_Manip < matter.manips.substance.stationary
    methods
        function this = KF_Electrolyzer_Manip(sName, oPhase)
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
            fF2Production = 0.5*this.oMT.afMolarMass(this.oMT.tiN2I.F2)/this.oMT.afMolarMass(this.oMT.tiN2I.KF)*afFlowRateIn(this.oMT.tiN2I.KF);
            fKProduction = this.oMT.afMolarMass(this.oMT.tiN2I.K)/this.oMT.afMolarMass(this.oMT.tiN2I.KF)*afFlowRateIn(this.oMT.tiN2I.KF);

            afPartialFlowRates = zeros(1, this.oPhase.oMT.iSubstances);
            afPartialFlowRates(this.oMT.tiN2I.KF) = -(fF2Production + fKProduction);
            afPartialFlowRates(this.oMT.tiN2I.F2) = fF2Production;
            afPartialFlowRates(this.oMT.tiN2I.K) = fKProduction;

            update@matter.manips.substance.stationary(this, afPartialFlowRates);
            this.trigger('KF_Electrolyzer_Manip_Update');
        end
    end
end