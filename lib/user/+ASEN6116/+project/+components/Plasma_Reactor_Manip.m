classdef Plasma_Reactor_Manip < matter.manips.substance.stationary & event.source
    methods
        function this = Plasma_Reactor_Manip(sName, oPhase)
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
            fF2Production = 2*this.oMT.afMolarMass(this.oMT.tiN2I.F2)/this.oMT.afMolarMass(this.oMT.tiN2I.SiF4)*afFlowRateIn(this.oMT.tiN2I.SiF4);
            fSiProduction = (1-(2*this.oMT.afMolarMass(this.oMT.tiN2I.F2)/this.oMT.afMolarMass(this.oMT.tiN2I.SiF4))) * afFlowRateIn(this.oMT.tiN2I.SiF4);

            afPartialFlowRates = zeros(1, this.oPhase.oMT.iSubstances);
            afPartialFlowRates(this.oMT.tiN2I.SiF4) = -(fF2Production + fSiProduction);
            afPartialFlowRates(this.oMT.tiN2I.F2) = fF2Production;
            afPartialFlowRates(this.oMT.tiN2I.Si) = fSiProduction;

            update@matter.manips.substance.stationary(this, afPartialFlowRates);
            this.trigger('Plasma_Reactor_Manip_Update')
        end
    end
end