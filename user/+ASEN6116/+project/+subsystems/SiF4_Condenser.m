classdef SiF4_Condenser < vsys
    properties (SetAccess = protected, GetAccess = public)

    end

    methods
        function this = SiF4_Condenser(oParent, sName)
            this@vsys(oParent, sName, 30);
            eval(this.oRoot.oCfgParams.configCode(this));
        end

        function createMatterStructure(this)
            createMatterStructure@vsys(this);
            % Store
            matter.store(this, 'SiF4_Condenser_Store', 1);

            % Phases
            matter.phases.gas(this.toStores.SiF4_Condenser_Store, 'SiF4_Condenser_Input', struct('O2', 0.1, 'F2', 0.1, 'SiF4', 0.1), 0.25, 293);
            matter.phases.gas(this.toStores.SiF4_Condenser_Store, 'SiF4_Condenser_Gas_Output', struct('O2', 0.1, 'F2', 0.1), 0.25, 293);
            matter.phases.solid(this.toStores.SiF4_Condenser_Store, 'SiF4_Condenser_Solid_Output', struct('SiF4', 1), 293);

            % Gaseous P2Ps
            ASEN6116.project.components.General_P2P(this.toStores.SiF4_Condenser_Store, 'O2_P2P', this.toStores.SiF4_Condenser_Store.toPhases.SiF4_Condenser_Input, this.toStores.SiF4_Condenser_Store.toPhases.SiF4_Condenser_Gas_Output, 'O2');
            ASEN6116.project.components.General_P2P(this.toStores.SiF4_Condenser_Store, 'F2_P2P', this.toStores.SiF4_Condenser_Store.toPhases.SiF4_Condenser_Input, this.toStores.SiF4_Condenser_Store.toPhases.SiF4_Condenser_Gas_Output, 'F2');

            % Solid P2P
            ASEN6116.project.components.General_P2P(this.toStores.SiF4_Condenser_Store, 'SiF4_P2P', this.toStores.SiF4_Condenser_Store.toPhases.SiF4_Condenser_Input, this.toStores.SiF4_Condenser_Store.toPhases.SiF4_Condenser_Solid_Output, 'SiF4');

            % Inlet and outlet branches
            matter.branch(this, this.toStores.SiF4_Condenser_Store.toPhases.SiF4_Condenser_Gas_Output, {}, 'Gas_Outlet', 'Gas_to_Fluorination_Reactor');
            matter.branch(this, this.toStores.SiF4_Condenser_Store.toPhases.SiF4_Condenser_Solid_Output, {}, 'Solid_Outlet', 'Solid_to_Plasma_Reactor');
            matter.branch(this, this.toStores.SiF4_Condenser_Store.toPhases.SiF4_Condenser_Input, {}, 'SiF4_Condenser_Inlet', 'Inlet_to_SiF4_Condenser');
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
        function setIfFlows(this, sCondenser_Inlet, sGas_Outlet, sSolid_Outlet)
            % This function connects the system and subsystem level branches with
            % each other. It uses the connectIF function provided by the
            % matter.container class
            this.connectIF('SiF4_Condenser_Inlet',  sCondenser_Inlet);
            this.connectIF('Gas_Outlet', sGas_Outlet);
            this.connectIF('Solid_Outlet', sSolid_Outlet);
        end
    end
end