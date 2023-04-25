classdef Pump < matter.procs.f2f
    properties (SetAccess = protected, GetAccess = public)
         
    end
    methods
        function this = Pump(oContainer, sName, fDeltaPressure)
            this@matter.procs.f2f(oContainer, sName);        
            this.supportSolver('callback',  @this.solverDeltas);
            this.fDeltaPressure = fDeltaPressure;
            this.bActive = true;
        end
 
        function fDeltaPress = solverDeltas(this, ~)
            fDeltaPress = this.fDeltaPressure;
        end
    end
end