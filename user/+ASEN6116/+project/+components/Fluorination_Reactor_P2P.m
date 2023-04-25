classdef Fluorination_Reactor_P2P < matter.procs.p2ps.stationary & event.source
    properties (SetAccess = public, GetAccess = public)
        arExtractPartials;
        sSubstance;
        fSubstanceFlowRate = 0;
    end
    methods
        function this = Fluorination_Reactor_P2P(oStore, sName, sPhaseIn, sPhaseOut, sSubstance)
            this@matter.procs.p2ps.stationary(oStore, sName, sPhaseIn, sPhaseOut);
            
            this.arExtractPartials = zeros(1, this.oMT.iSubstances);
            this.arExtractPartials(this.oMT.tiN2I.(sSubstance)) = 1;
            this.sSubstance = sSubstance;

            oStore.toPhases.Fluorination_Reactor_Input.toManips.substance.bind('Fluorination_Reactor_Manip_Update', @this.calculateFlowRate);
        end
    end
    methods (Access = protected)
        function calculateFlowRate(this, ~)
            this.fSubstanceFlowRate = this.oStore.toPhases.Fluorination_Reactor_Input.toManips.substance.afPartialFlows(this.oMT.tiN2I.(this.sSubstance));
            this.oIn.oPhase.registerMassupdate();
            this.oOut.oPhase.registerMassupdate();
        end
        function update(this)
            this.setMatterProperties(this.fSubstanceFlowRate, this.arExtractPartials);
        end
    end
end