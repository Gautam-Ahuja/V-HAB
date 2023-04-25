classdef TiF4_Condenser < vsys
    properties (SetAccess = protected, GetAccess = public)

    end

    methods
        function this = TiF4_Condenser(oParent, sName)
            this@vsys(oParent, sName, 30);
            eval(this.oRoot.oCfgParams.configCode(this));
        end

        function createMatterStructure(this)
            createMatterStructure@vsys(this);
            % Store
            matter.store(this, 'TiF4_Condenser_Store', 1);

            % Phases
            matter.phases.gas(this.toStores.TiF4_Condenser_Store, 'TiF4_Condenser_Input', struct('O2', 0.1, 'F2', 0.1, 'SiF4', 0.1, 'TiF4', 0.1), 0.25, 293);
            matter.phases.gas(this.toStores.TiF4_Condenser_Store, 'TiF4_Condenser_Gas_Output', struct('O2', 0.1, 'F2', 0.1, 'SiF4', 0.1), 0.25, 293);
            matter.phases.solid(this.toStores.TiF4_Condenser_Store, 'TiF4_Condenser_Solid_Output', struct('TiF4', 1), 293);

            % Gaseous P2Ps
            ASEN6116.project.components.General_P2P(this.toStores.TiF4_Condenser_Store, 'O2_P2P', this.toStores.TiF4_Condenser_Store.toPhases.TiF4_Condenser_Input, this.toStores.TiF4_Condenser_Store.toPhases.TiF4_Condenser_Gas_Output, 'O2');
            ASEN6116.project.components.General_P2P(this.toStores.TiF4_Condenser_Store, 'F2_P2P', this.toStores.TiF4_Condenser_Store.toPhases.TiF4_Condenser_Input, this.toStores.TiF4_Condenser_Store.toPhases.TiF4_Condenser_Gas_Output, 'F2');
            ASEN6116.project.components.General_P2P(this.toStores.TiF4_Condenser_Store, 'SiF4_P2P', this.toStores.TiF4_Condenser_Store.toPhases.TiF4_Condenser_Input, this.toStores.TiF4_Condenser_Store.toPhases.TiF4_Condenser_Gas_Output, 'SiF4');

            % Solid P2P
            ASEN6116.project.components.General_P2P(this.toStores.TiF4_Condenser_Store, 'TiF4_P2P', this.toStores.TiF4_Condenser_Store.toPhases.TiF4_Condenser_Input, this.toStores.TiF4_Condenser_Store.toPhases.TiF4_Condenser_Solid_Output, 'TiF4');

            % Gas inlet pipes and pump
            fLength     = 1;    % Pipe length in m
            fDiameter   = 0.01; % Pipe Diameter in m
            components.matter.pipe(this, 'Pipe_1', fLength, fDiameter);

            % Inlet and outlet branches
            matter.branch(this, this.toStores.TiF4_Condenser_Store.toPhases.TiF4_Condenser_Gas_Output, {}, 'Gas_Outlet', 'Gas_to_SiF4_Condenser');
            matter.branch(this, this.toStores.TiF4_Condenser_Store.toPhases.TiF4_Condenser_Solid_Output, {}, 'Solid_Outlet', 'Solid_to_K_Furnace');
            matter.branch(this, this.toStores.TiF4_Condenser_Store.toPhases.TiF4_Condenser_Input, {'Pipe_1'}, 'TiF4_Condenser_Inlet', 'Inlet_to_TiF4_Condenser');
        end

        function createSolverStructure(this)
            createSolverStructure@vsys(this);
            solver.matter.residual.branch(this.toBranches.Gas_to_SiF4_Condenser);
            solver.matter.residual.branch(this.toBranches.Solid_to_K_Furnace);
            solver.matter_multibranch.iterative.branch(this.toBranches.Inlet_to_TiF4_Condenser);

            this.setThermalSolvers();
        end
    end

    methods (Access = protected)
        function exec(this, ~)
            exec@vsys(this);
        end
    end

    methods (Access = public)
        function setIfFlows(this, sCondenser_Inlet, sGas_Outlet, sSolid_Outlet)
            % This function connects the system and subsystem level branches with
            % each other. It uses the connectIF function provided by the
            % matter.container class
            this.connectIF('TiF4_Condenser_Inlet',  sCondenser_Inlet);
            this.connectIF('Gas_Outlet', sGas_Outlet);
            this.connectIF('Solid_Outlet', sSolid_Outlet);
        end
    end
end