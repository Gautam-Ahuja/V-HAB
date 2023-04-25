classdef General_P2P < matter.procs.p2ps.stationary & event.source
    properties (SetAccess = public, GetAccess = public)
        arExtractPartials;
        sSubstance;
    end
    methods
        function this = General_P2P(oStore, sName, sPhaseIn, sPhaseOut, sSubstance)
            this@matter.procs.p2ps.stationary(oStore, sName, sPhaseIn, sPhaseOut);
            
            this.arExtractPartials = zeros(1, this.oMT.iSubstances);
            this.arExtractPartials(this.oMT.tiN2I.(sSubstance)) = 1;
            this.sSubstance = sSubstance;
        end
    end
    methods (Access = protected)
        function update(this)
            [ afFlowRate, mrPartials ] = this.getInFlows();
            afInFlows = afFlowRate .* mrPartials(:, this.oMT.tiN2I.(this.sSubstance));
            this.setMatterProperties(sum(afInFlows), this.arExtractPartials);
        end
    end
end