classdef Regolith_Reactor < vsys
    properties (SetAccess = protected, GetAccess = public)

    end

    methods
        function this = Regolith_Reactor(oParent, sName)
            this@vsys(oParent, sName, 30);
            eval(this.oRoot.oCfgParams.configCode(this));
        end

        function createMatterStructure(this)
            createMatterStructure@vsys(this);
            % Store
            matter.store(this, 'Regolith_Reactor_Store', 1);

            % Phases
            matter.phases.mixture(this.toStores.Regolith_Reactor_Store, 'Regolith_Reactor_Input', 'solid', struct('Regolith', 1, 'F2', 1), 293, 1e5);
            matter.phases.gas(this.toStores.Regolith_Reactor_Store, 'Regolith_Reactor_Gas_Output', struct('O2', 0.1, 'F2', 0.1, 'SiF4', 0.1, 'TiF4', 0.1), 0.25, 293);
            matter.phases.solid(this.toStores.Regolith_Reactor_Store, 'Regolith_Reactor_Solid_Output', struct('FeF3', 1, 'MgF2', 1, 'CaF2', 1, 'AlF3', 1, 'NaF', 1), 293);

            % Manip
            ASEN6116.project.components.Regolith_Reactor_Manip('Regolith_Reactor_Manip', this.toStores.Regolith_Reactor_Store.toPhases.Regolith_Reactor_Input);

            % Gaseous output P2Ps
            ASEN6116.project.components.Regolith_Reactor_P2P(this.toStores.Regolith_Reactor_Store, 'O2_P2P', this.toStores.Regolith_Reactor_Store.toPhases.Regolith_Reactor_Input, this.toStores.Regolith_Reactor_Store.toPhases.Regolith_Reactor_Gas_Output, 'O2');
            ASEN6116.project.components.Regolith_Reactor_P2P(this.toStores.Regolith_Reactor_Store, 'F2_P2P', this.toStores.Regolith_Reactor_Store.toPhases.Regolith_Reactor_Input, this.toStores.Regolith_Reactor_Store.toPhases.Regolith_Reactor_Gas_Output, 'F2');
            ASEN6116.project.components.Regolith_Reactor_P2P(this.toStores.Regolith_Reactor_Store, 'SiF4_P2P', this.toStores.Regolith_Reactor_Store.toPhases.Regolith_Reactor_Input, this.toStores.Regolith_Reactor_Store.toPhases.Regolith_Reactor_Gas_Output, 'SiF4');
            ASEN6116.project.components.Regolith_Reactor_P2P(this.toStores.Regolith_Reactor_Store, 'TiF4_P2P', this.toStores.Regolith_Reactor_Store.toPhases.Regolith_Reactor_Input, this.toStores.Regolith_Reactor_Store.toPhases.Regolith_Reactor_Gas_Output, 'TiF4');

            % Solid output P2Ps
            ASEN6116.project.components.Regolith_Reactor_P2P(this.toStores.Regolith_Reactor_Store, 'FeF3_P2P', this.toStores.Regolith_Reactor_Store.toPhases.Regolith_Reactor_Input, this.toStores.Regolith_Reactor_Store.toPhases.Regolith_Reactor_Solid_Output, 'FeF3');
            ASEN6116.project.components.Regolith_Reactor_P2P(this.toStores.Regolith_Reactor_Store, 'MgF2_P2P', this.toStores.Regolith_Reactor_Store.toPhases.Regolith_Reactor_Input, this.toStores.Regolith_Reactor_Store.toPhases.Regolith_Reactor_Solid_Output, 'MgF2');
            ASEN6116.project.components.Regolith_Reactor_P2P(this.toStores.Regolith_Reactor_Store, 'CaF2_P2P', this.toStores.Regolith_Reactor_Store.toPhases.Regolith_Reactor_Input, this.toStores.Regolith_Reactor_Store.toPhases.Regolith_Reactor_Solid_Output, 'CaF2');
            ASEN6116.project.components.Regolith_Reactor_P2P(this.toStores.Regolith_Reactor_Store, 'AlF3_P2P', this.toStores.Regolith_Reactor_Store.toPhases.Regolith_Reactor_Input, this.toStores.Regolith_Reactor_Store.toPhases.Regolith_Reactor_Solid_Output, 'AlF3');
            ASEN6116.project.components.Regolith_Reactor_P2P(this.toStores.Regolith_Reactor_Store, 'NaF_P2P', this.toStores.Regolith_Reactor_Store.toPhases.Regolith_Reactor_Input, this.toStores.Regolith_Reactor_Store.toPhases.Regolith_Reactor_Solid_Output, 'NaF');

            % Inlet and outlet branches
            matter.branch(this, this.toStores.Regolith_Reactor_Store.toPhases.Regolith_Reactor_Gas_Output, {}, 'Gas_Outlet', 'RR_Gas_Branch');
            matter.branch(this, this.toStores.Regolith_Reactor_Store.toPhases.Regolith_Reactor_Solid_Output, {}, 'Solid_Outlet', 'RR_Solid_Branch');
            matter.branch(this, this.toStores.Regolith_Reactor_Store.toPhases.Regolith_Reactor_Input, {}, 'Gas_Inlet', 'RR_Fluorine_Branch');
            matter.branch(this, this.toStores.Regolith_Reactor_Store.toPhases.Regolith_Reactor_Input, {}, 'Solid_Inlet', 'RR_Regolith_Branch');
        end

        function createSolverStructure(this)
            createSolverStructure@vsys(this);

            

            solver.matter.manual.branch(this.toBranches.RR_Fluorine_Branch);
            this.toBranches.RR_Fluorine_Branch.oHandler.setFlowRate(-3e-3);

            solver.matter.manual.branch(this.toBranches.RR_Regolith_Branch);
            this.toBranches.RR_Regolith_Branch.oHandler.setFlowRate(-1.5e-3);

            solver.matter.residual.branch(this.toBranches.RR_Solid_Branch);

            solver.matter.residual.branch(this.toBranches.RR_Gas_Branch);

            this.setThermalSolvers();
        end
    end

    methods (Access = protected)
        function exec(this, ~)
            exec@vsys(this);
        end
    end

    methods (Access = public)
        function setIfFlows(this, sGas_Inlet, sSolid_Inlet, sGas_Outlet, sSolid_Outlet)
            % This function connects the system and subsystem level branches with
            % each other. It uses the connectIF function provided by the
            % matter.container class
            this.connectIF('Gas_Inlet',  sGas_Inlet);
            this.connectIF('Solid_Inlet', sSolid_Inlet);
            this.connectIF('Gas_Outlet', sGas_Outlet);
            this.connectIF('Solid_Outlet', sSolid_Outlet);
        end
    end
end