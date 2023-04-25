classdef Fluorination_Reactor < vsys
    properties (SetAccess = protected, GetAccess = public)

    end

    methods
        function this = Fluorination_Reactor(oParent, sName)
            this@vsys(oParent, sName, 30);
            eval(this.oRoot.oCfgParams.configCode(this));
        end

        function createMatterStructure(this)
            createMatterStructure@vsys(this);
            % Store
            matter.store(this, 'Fluorination_Reactor_Store', 1);

            % Phases
            matter.phases.mixture(this.toStores.Fluorination_Reactor_Store, 'Fluorination_Reactor_Input','solid', struct('O2', 0.1, 'F2', 0.1, 'Fe', 1, 'MgO', 1, 'CaO', 1, 'Al', 1, 'Na2O', 1, 'TiO2', 1), 293, 1e5);
            matter.phases.gas(this.toStores.Fluorination_Reactor_Store, 'Fluorination_Reactor_Gas_Output', struct('O2', 0.1) , 0.25, 293);
            matter.phases.solid(this.toStores.Fluorination_Reactor_Store, 'Fluorination_Reactor_Solid_Output', struct('FeF3', 1, 'MgF2', 1, 'CaF2', 1, 'AlF3', 1, 'NaF', 1), 293);

            % Manip
            ASEN6116.project.components.Fluorination_Reactor_Manip('Fluorination_Reactor_Manip', this.toStores.Fluorination_Reactor_Store.toPhases.Fluorination_Reactor_Input);

            % Gaseous P2Ps
            ASEN6116.project.components.Fluorination_Reactor_P2P(this.toStores.Fluorination_Reactor_Store, 'O2_P2P', this.toStores.Fluorination_Reactor_Store.toPhases.Fluorination_Reactor_Input, this.toStores.Fluorination_Reactor_Store.toPhases.Fluorination_Reactor_Gas_Output, 'O2');

            % Solid P2Ps
            ASEN6116.project.components.Fluorination_Reactor_P2P(this.toStores.Fluorination_Reactor_Store, 'FeF3_P2P', this.toStores.Fluorination_Reactor_Store.toPhases.Fluorination_Reactor_Input, this.toStores.Fluorination_Reactor_Store.toPhases.Fluorination_Reactor_Solid_Output, 'FeF3');
            ASEN6116.project.components.Fluorination_Reactor_P2P(this.toStores.Fluorination_Reactor_Store, 'MgF2_P2P', this.toStores.Fluorination_Reactor_Store.toPhases.Fluorination_Reactor_Input, this.toStores.Fluorination_Reactor_Store.toPhases.Fluorination_Reactor_Solid_Output, 'MgF2');
            ASEN6116.project.components.Fluorination_Reactor_P2P(this.toStores.Fluorination_Reactor_Store, 'CaF2_P2P', this.toStores.Fluorination_Reactor_Store.toPhases.Fluorination_Reactor_Input, this.toStores.Fluorination_Reactor_Store.toPhases.Fluorination_Reactor_Solid_Output, 'CaF2');
            ASEN6116.project.components.Fluorination_Reactor_P2P(this.toStores.Fluorination_Reactor_Store, 'AlF3_P2P', this.toStores.Fluorination_Reactor_Store.toPhases.Fluorination_Reactor_Input, this.toStores.Fluorination_Reactor_Store.toPhases.Fluorination_Reactor_Solid_Output, 'AlF3');
            ASEN6116.project.components.Fluorination_Reactor_P2P(this.toStores.Fluorination_Reactor_Store, 'NaF_P2P', this.toStores.Fluorination_Reactor_Store.toPhases.Fluorination_Reactor_Input, this.toStores.Fluorination_Reactor_Store.toPhases.Fluorination_Reactor_Solid_Output, 'NaF');

            % Gas inlet pipes and pump
            fLength     = 1;    % Pipe length in m
            fDiameter   = 0.01; % Pipe Diameter in m
            components.matter.pipe(this, 'Pipe_1', fLength, fDiameter);

            % Inlet and outlet branches
            matter.branch(this, this.toStores.Fluorination_Reactor_Store.toPhases.Fluorination_Reactor_Gas_Output, {}, 'Gas_Outlet', 'Gas_to_O2_Storage');
            matter.branch(this, this.toStores.Fluorination_Reactor_Store.toPhases.Fluorination_Reactor_Solid_Output, {}, 'Solid_Outlet', 'Solid_to_K_Furnace');
            matter.branch(this, this.toStores.Fluorination_Reactor_Store.toPhases.Fluorination_Reactor_Input, {'Pipe_1'}, 'Fluorination_Reactor_Inlet', 'Inlet_to_Fluorination_Reactor');

        end

        function createSolverStructure(this)
            createSolverStructure@vsys(this);
            solver.matter.residual.branch(this.toBranches.Gas_to_O2_Storage);
            solver.matter.residual.branch(this.toBranches.Solid_to_K_Furnace);
            solver.matter.residual.branch(this.toBranches.Inlet_to_Fluorination_Reactor);
            %solver.toBranches.Inlet_to_Fluorination_Reactor.oHandler.setFlowRate(-0.001);

            this.setThermalSolvers();
        end
    end

    methods (Access = protected)
        function exec(this, ~)
            exec@vsys(this);
        end
    end

    methods (Access = public)
        function setIfFlows(this, sReactor_Inlet, sGas_Outlet, sSolid_Outlet)
            % This function connects the system and subsystem level branches with
            % each other. It uses the connectIF function provided by the
            % matter.container class
            this.connectIF('Fluorination_Reactor_Inlet',  sReactor_Inlet);
            this.connectIF('Gas_Outlet', sGas_Outlet);
            this.connectIF('Solid_Outlet', sSolid_Outlet);
        end
    end
end