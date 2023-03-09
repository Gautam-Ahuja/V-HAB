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

            % O2 storage
            matter.store(this, 'O2_Storage', 10);

            % Metals output
            matter.store(this, 'Metals_Output', 10);

            % Input regolith
            matter.store(this, 'Regolith_Supply', 10);
            matter.phases.mixture(this.toStores.Regolith_Supply, 'FeedRegolith', 'solid', struct('Regolith', 100), this.oMT.Standard.Temperature, this.oMT.Standard.Pressure);

            % Regolith reactor manipulator
            ASEN6116.project.components.Regolith_Reactor_Manip('Regolith_Reactor', this.toStores.Regolith_Supply.toPhases.FeedRegolith);
        end

        function createSolverStructure(this)
            createSolverStructure@vsys(this);

        end

        function createThermalStructure(this)
            createThermalStructure@vsys(this);
        end
    end



    methods (Access = protected)
        function exec(this, ~)
            exec@vsys(this);

        end
    end
end