classdef Habitat < vsys
    properties (SetAccess = protected, GetAccess = public)

    end

    methods
        function this = Habitat(oParent, sName)
            this@vsys(oParent, sName, 30);
            eval(this.oRoot.oCfgParams.configCode(this));

            ASEN6116.project.subsystems.Fluorination_Reactor(this, 'Fluorination_Reactor');
            ASEN6116.project.subsystems.K_Furnace(this, 'K_Furnace');
            ASEN6116.project.subsystems.KF_Electrolyzer(this, 'KF_Electrolyzer');
            ASEN6116.project.subsystems.Plasma_Reactor(this, 'Plasma_Reactor');
            ASEN6116.project.subsystems.Regolith_Reactor(this, 'Regolith_Reactor');
            ASEN6116.project.subsystems.SiF4_Condenser(this, 'SiF4_Condenser');
            ASEN6116.project.subsystems.TiF4_Condenser(this, 'TiF4_Condenser');
        end

        function createMatterStructure(this)
            createMatterStructure@vsys(this);

            % Cabin - not yet needed
            % matter.store(this, 'Cabin', 38);
            % this.toStores.Cabin.createPhase('gas', 'CabinAir', 38, struct('O2', 34473.8), 293, 0.5);    % 5 psia

            % O2 storage
            matter.store(this, 'O2_Storage', 10);
            matter.phases.gas(this.toStores.O2_Storage, 'O2_Output', struct('O2', .01), 10, 293);

            % Metal output
            matter.store(this, 'Metal_Storage', 10);
            matter.phases.solid(this.toStores.Metal_Storage, 'Metal_Output', struct('Si', 0.01, 'Fe', 0.01, 'Al', 0.01, 'CaO', 0.01, 'MgO', 0.01, 'Na2O', 0.01, 'TiO2', 0.01));

            % Regolith supply
            matter.store(this, 'Regolith_Supply', 10);
            matter.phases.mixture(this.toStores.Regolith_Supply, 'Feed_Regolith', 'solid', struct('Regolith', 100), this.oMT.Standard.Temperature, this.oMT.Standard.Pressure);

            % F2 supply
            matter.store(this, 'F2_Storage', 10);
            matter.phases.gas(this.toStores.F2_Storage, 'Feed_F2', struct('F2', 1), 0.5, 293);
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