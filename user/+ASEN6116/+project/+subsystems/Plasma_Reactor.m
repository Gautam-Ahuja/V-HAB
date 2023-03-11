classdef Plasma_Reactor < vsys
    properties (SetAccess = protected, GetAccess = public)

    end

    methods
        function this = Plasma_Reactor(oParent, sName)
            this@vsys(oParent, sName, 30);
            eval(this.oRoot.oCfgParams.configCode(this));
        end

        function createMatterStructure(this)
            createMatterStructure@vsys(this);
            % Store
            matter.store(this, 'Plasma_Reactor_Store', 1);

            % Phases
            matter.phases.solid(this.toStores.Plasma_Reactor_Store, 'Plasma_Reactor_Input', struct('SiF4', 1), 293);
            matter.phases.gas(this.toStores.Plasma_Reactor_Store, 'Plasma_Reactor_Gas_Output', struct('F2', 0.1), 0.25, 293);
            matter.phases.solid(this.toStores.Plasma_Reactor_Store, 'Plasma_Reactor_Solid_Output', struct('Si', 1), 293);

            % Manip
            ASEN6116.project.components.Plasma_Reactor_Manip('Plasma_Reactor_Manip', this.toStores.Plasma_Reactor_Store.toPhases.Plasma_Reactor_Input);

            % Gaseous P2P
            ASEN6116.project.components.General_P2P(this.toStores.Plasma_Reactor_Store, 'F2_P2P', this.toStores.Plasma_Reactor_Store.toPhases.Plasma_Reactor_Input, this.toStores.Plasma_Reactor_Store.toPhases.Plasma_Reactor_Gas_Output, 'F2');

            % Solid P2P
            ASEN6116.project.components.General_P2P(this.toStores.Plasma_Reactor_Store, 'Si_P2P', this.toStores.Plasma_Reactor_Store.toPhases.Plasma_Reactor_Input, this.toStores.Plasma_Reactor_Store.toPhases.Plasma_Reactor_Solid_Output, 'Si');

            % Inlet and outlet branches
            matter.branch(this, this.toStores.Plasma_Reactor_Store.toPhases.Plasma_Reactor_Gas_Output, {}, 'Gas_Outlet', 'Gas_to_Regolith_Reactor');
            matter.branch(this, this.toStores.Plasma_Reactor_Store.toPhases.Plasma_Reactor_Solid_Output, {}, 'Solid_Outlet', 'Solid_to_Metal_Output');
            matter.branch(this, this.toStores.Plasma_Reactor_Store.toPhases.Plasma_Reactor_Input, {}, 'Plasma_Reactor_Inlet', 'Inlet_to_Plasma_Reactor');
        end

        function createSolverStructure(this)
            createSolverStructure@vsys(this);

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
            this.connectIF('Plasma_Reactor_Inlet',  sReactor_Inlet);
            this.connectIF('Gas_Outlet', sGas_Outlet);
            this.connectIF('Solid_Outlet', sSolid_Outlet);
        end
    end
end