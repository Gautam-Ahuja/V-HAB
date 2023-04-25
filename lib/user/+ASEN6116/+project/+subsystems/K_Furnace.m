classdef K_Furnace < vsys
    properties (SetAccess = protected, GetAccess = public)

    end

    methods
        function this = K_Furnace(oParent, sName)
            this@vsys(oParent, sName, 30);
            eval(this.oRoot.oCfgParams.configCode(this));
        end

        function createMatterStructure(this)
            createMatterStructure@vsys(this);
            % Store
            matter.store(this, 'K_Furnace_Store', 1);

            % Phases
            matter.phases.solid(this.toStores.K_Furnace_Store, 'K_Furnace_Regolith_Reactor_Input', struct('FeF3', 1, 'MgF2', 1, 'CaF2', 1, 'AlF3', 1, 'NaF', 1), 293);
            matter.phases.solid(this.toStores.K_Furnace_Store, 'K_Furnace_Fluorination_Reactor_Input', struct('FeF3', 1, 'MgF2', 1, 'CaF2', 1, 'AlF3', 1, 'NaF', 1), 293);
            matter.phases.solid(this.toStores.K_Furnace_Store, 'K_Furnace_TiF4_Condenser_Input', struct('TiF4', 1), 293);
            matter.phases.solid(this.toStores.K_Furnace_Store, 'K_Furnace_K_Input', struct('K', 1), 293);
            matter.phases.gas(this.toStores.K_Furnace_Store, 'K_Furnace_Oxygen_Input', struct('O2', 1), 0.5, 293);
            matter.phases.mixture(this.toStores.K_Furnace_Store, 'K_Furnace_Input', 'solid', struct('FeF3', 1, 'MgF2', 1, 'CaF2', 1, 'AlF3', 1, 'NaF', 1, 'TiF4', 1, 'O2', 1, 'K', 1), 293, 1e5);
            matter.phases.liquid(this.toStores.K_Furnace_Store, 'K_Furnace_Liquid_Output', struct('KF', 1), 293, 1e5);
            matter.phases.solid(this.toStores.K_Furnace_Store, 'K_Furnace_Solid_Output', struct('Fe', 1, 'MgO', 1, 'CaO', 1, 'Al', 1, 'Na2O', 1, 'TiO2', 1), 293);

            % Manip
            ASEN6116.project.components.K_Furnace_Manip('K_Furnace_Manip', this.toStores.K_Furnace_Store.toPhases.K_Furnace_Input);

            % Solid input P2Ps
            ASEN6116.project.components.General_P2P(this.toStores.K_Furnace_Store, 'Regolith_Reactor_FeF3_P2P', this.toStores.K_Furnace_Store.toPhases.K_Furnace_Regolith_Reactor_Input, this.toStores.K_Furnace_Store.toPhases.K_Furnace_Input, 'FeF3');
            ASEN6116.project.components.General_P2P(this.toStores.K_Furnace_Store, 'Regolith_Reactor_MgF2_P2P', this.toStores.K_Furnace_Store.toPhases.K_Furnace_Regolith_Reactor_Input, this.toStores.K_Furnace_Store.toPhases.K_Furnace_Input, 'MgF2');
            ASEN6116.project.components.General_P2P(this.toStores.K_Furnace_Store, 'Regolith_Reactor_CaF2_P2P', this.toStores.K_Furnace_Store.toPhases.K_Furnace_Regolith_Reactor_Input, this.toStores.K_Furnace_Store.toPhases.K_Furnace_Input, 'CaF2');
            ASEN6116.project.components.General_P2P(this.toStores.K_Furnace_Store, 'Regolith_Reactor_AlF3_P2P', this.toStores.K_Furnace_Store.toPhases.K_Furnace_Regolith_Reactor_Input, this.toStores.K_Furnace_Store.toPhases.K_Furnace_Input, 'AlF3');
            ASEN6116.project.components.General_P2P(this.toStores.K_Furnace_Store, 'Regolith_Reactor_NaF_P2P', this.toStores.K_Furnace_Store.toPhases.K_Furnace_Regolith_Reactor_Input, this.toStores.K_Furnace_Store.toPhases.K_Furnace_Input, 'NaF');
            ASEN6116.project.components.General_P2P(this.toStores.K_Furnace_Store, 'Fluorination_Reactor_FeF3_P2P', this.toStores.K_Furnace_Store.toPhases.K_Furnace_Fluorination_Reactor_Input, this.toStores.K_Furnace_Store.toPhases.K_Furnace_Input, 'FeF3');
            ASEN6116.project.components.General_P2P(this.toStores.K_Furnace_Store, 'Fluorination_Reactor_MgF2_P2P', this.toStores.K_Furnace_Store.toPhases.K_Furnace_Fluorination_Reactor_Input, this.toStores.K_Furnace_Store.toPhases.K_Furnace_Input, 'MgF2');
            ASEN6116.project.components.General_P2P(this.toStores.K_Furnace_Store, 'Fluorination_Reactor_CaF2_P2P', this.toStores.K_Furnace_Store.toPhases.K_Furnace_Fluorination_Reactor_Input, this.toStores.K_Furnace_Store.toPhases.K_Furnace_Input, 'CaF2');
            ASEN6116.project.components.General_P2P(this.toStores.K_Furnace_Store, 'Fluorination_Reactor_AlF3_P2P', this.toStores.K_Furnace_Store.toPhases.K_Furnace_Fluorination_Reactor_Input, this.toStores.K_Furnace_Store.toPhases.K_Furnace_Input, 'AlF3');
            ASEN6116.project.components.General_P2P(this.toStores.K_Furnace_Store, 'Fluorination_Reactor_NaF_P2P', this.toStores.K_Furnace_Store.toPhases.K_Furnace_Fluorination_Reactor_Input, this.toStores.K_Furnace_Store.toPhases.K_Furnace_Input, 'NaF');
            ASEN6116.project.components.General_P2P(this.toStores.K_Furnace_Store, 'TiF4_P2P', this.toStores.K_Furnace_Store.toPhases.K_Furnace_TiF4_Condenser_Input, this.toStores.K_Furnace_Store.toPhases.K_Furnace_Input, 'TiF4');
            ASEN6116.project.components.General_P2P(this.toStores.K_Furnace_Store, 'K_P2P', this.toStores.K_Furnace_Store.toPhases.K_Furnace_K_Input, this.toStores.K_Furnace_Store.toPhases.K_Furnace_Input, 'K');

            % Gaseous input P2P
            ASEN6116.project.components.General_P2P(this.toStores.K_Furance_Store, 'O2_P2P', this.toStores.K_Furnace_Store.toPhases.K_Furnace_Oxygen_Input, this.toStores.K_Furnace_Store.toPhases.K_Furnace_Input, 'O2');

            % Liquid output P2P
            ASEN6116.project.components.General_P2P(this.toStores.K_Furnace_Store, 'KF_P2P', this.toStores.K_Furnace_Store.toPhases.K_Furnace_Input, this.toStores.K_Furnace_Store.toPhases.K_Furnace_Liquid_Output, 'KF');

            % Solid output P2Ps
            ASEN6116.project.components.General_P2P(this.toStores.K_Furnace_Store, 'Fe_P2P', this.toStores.K_Furnace_Store.toPhases.K_Furnace_Input, this.toStores.K_Furnace_Store.toPhases.K_Furnace_Solid_Output, 'Fe');
            ASEN6116.project.components.General_P2P(this.toStores.K_Furnace_Store, 'MgO_P2P', this.toStores.K_Furnace_Store.toPhases.K_Furnace_Input, this.toStores.K_Furnace_Store.toPhases.K_Furnace_Solid_Output, 'MgO');
            ASEN6116.project.components.General_P2P(this.toStores.K_Furnace_Store, 'CaO_P2P', this.toStores.K_Furnace_Store.toPhases.K_Furnace_Input, this.toStores.K_Furnace_Store.toPhases.K_Furnace_Solid_Output, 'CaO');
            ASEN6116.project.components.General_P2P(this.toStores.K_Furnace_Store, 'Al_P2P', this.toStores.K_Furnace_Store.toPhases.K_Furnace_Input, this.toStores.K_Furnace_Store.toPhases.K_Furnace_Solid_Output, 'Al');
            ASEN6116.project.components.General_P2P(this.toStores.K_Furnace_Store, 'Na2O_P2P', this.toStores.K_Furnace_Store.toPhases.K_Furnace_Input, this.toStores.K_Furnace_Store.toPhases.K_Furnace_Solid_Output, 'Na2O');
            ASEN6116.project.components.General_P2P(this.toStores.K_Furnace_Store, 'TiO2_P2P', this.toStores.K_Furnace_Store.toPhases.K_Furnace_Input, this.toStores.K_Furnace_Store.toPhases.K_Furnace_Solid_Output, 'TiO2');

            % Inlet and outlet branches
            matter.branch(this, this.toStores.K_Furnace_Store.toPhases.K_Furnace_Liquid_Output, {}, 'Liquid_Outlet', 'Liquid_to_KF_Electrolyzer');
            matter.branch(this, this.toStores.K_Furnace_Store.toPhases.K_Furnace_Solid_Output, {}, 'Solid_Outlet', 'Solid_to_Metal_Output');
            matter.branch(this, this.toStores.K_Furnace_Store.toPhases.K_Furnace_Regolith_Reactor_Input, {}, 'K_Furnace_Regolith_Reactor_Inlet', 'Regolith_Reactor_to_K_Furnace');
            matter.branch(this, this.toStores.K_Furnace_Store.toPhases.K_Furnace_Fluorination_Reactor_Input, {}, 'K_Furnace_Fluorination_Reactor_Inlet', 'Fluorination_Reactor_to_K_Furnace');
            matter.branch(this, this.toStores.K_Furnace_Store.toPhases.K_Furnace_TiF4_Condenser_Input, {}, 'K_Furnace_TiF4_Condenser_Inlet', 'TiF4_Condenser_to_K_Furnace');
            matter.branch(this, this.toStores.K_Furnace_Store.toPhases.K_Furnace_K_Furnace_K_Input, {}, 'K_Furnace_KF_Electrolyzer_Outlet', 'KF_Electrolyzer_to_K_Furnace');
            matter.branch(this, this.toStores.K_Furnace_Store.toPhases.K_Furnace_Oxygen_Input, {}, 'K_Furnace_O2_Inlet', 'O2_to_K_Furnace');
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
        function setIfFlows(this, sRegolith_Reactor_Inlet, sFluorination_Reactor_Inlet, sTiF4_Condenser_Inlet, sKF_Electrolyzer_Inlet, sO2_Inlet, sLiquid_Outlet, sSolid_Outlet)
            % This function connects the system and subsystem level branches with
            % each other. It uses the connectIF function provided by the
            % matter.container class
            this.connectIF('K_Furnace_Regolith_Reactor_Inlet',  sRegolith_Reactor_Inlet);
            this.connectIF('K_Furnace_Fluorination_Reactor_Inlet',  sFluorination_Reactor_Inlet);
            this.connectIF('K_Furnace_TiF4_Condenser_Inlet', sTiF4_Condenser_Inlet);
            this.connectIF('K_Furnace_KF_Electrolyzer_Outlet', sKF_Electrolyzer_Inlet);
            this.connectIF('K_Furnace_O2_Inlet', sO2_Inlet);
            this.connectIF('Liquid_Outlet', sLiquid_Outlet);
            this.connectIF('Solid_Outlet', sSolid_Outlet);
        end
    end
end