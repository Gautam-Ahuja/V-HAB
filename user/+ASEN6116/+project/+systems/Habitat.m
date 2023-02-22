classdef Habitat < vsys
    properties (SetAccess = protected, GetAccess = public)
        
    end
    
    methods
        function this = Habitat(oParent, sName)
            this@vsys(oParent, sName, 30);
            eval(this.oRoot.oCfgParams.configCode(this));
            
        end
        
        function createMatterStructure(this)
            createMatterStructure@vsys(this);

            % Cabin
            matter.store(this, 'Cabin', 38);
            this.toStores.Cabin.createPhase('gas', 'CabinAir', 38, struct('O2', 34473.8), 293, 0.5);    % 5 psia
        end
        
        function createSolverStructure(this)
            createSolverStructure@vsys(this);
            
        end
    end
    
     methods (Access = protected)
        function exec(this, ~)
            exec@vsys(this);
            
        end
     end
end