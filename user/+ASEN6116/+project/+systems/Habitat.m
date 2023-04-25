classdef Habitat < vsys
    properties (SetAccess = protected, GetAccess = public)

    end

    methods
        function this = Habitat(oParent, sName)
            this@vsys(oParent, sName, 30);
            eval(this.oRoot.oCfgParams.configCode(this));

            ASEN6116.project.subsystems.Fluorination_Reactor(this, 'Fluorination_Reactor');             ASEN6116.project.subsystems.K_Furnace(this, 'K_Furnace');
            ASEN6116.project.subsystems.KF_Electrolyzer(this, 'KF_Electrolyzer');
            ASEN6116.project.subsystems.Plasma_Reactor(this, 'Plasma_Reactor');
            ASEN6116.project.subsystems.Regolith_Reactor(this, 'Regolith_Reactor');
            ASEN6116.project.subsystems.SiF4_Condenser(this, 'SiF4_Condenser');
            ASEN6116.project.subsystems.TiF4_Condenser(this, 'TiF4_Condenser');
        end

        function createMatterStructure(this)
            createMatterStructure@vsys(this);

            % Regolith Reactor Gas Output and TiF4 Condenser Input
            matter.store(this, 'Regolith_Gas_Output', 10);
            matter.phases.gas(this.toStores.Regolith_Gas_Output, 'Reg_Gas_Out', struct('SiF4', 0.1, 'TiF4', 0.1, 'O2', 0.1,'F2', 0.1), 1, 293);
            matter.phases.gas(this.toStores.Regolith_Gas_Output, 'TiF4_Gas_In', struct('SiF4', 0.1, 'TiF4', 0.1, 'O2', 0.1, 'F2', 0.1), 1, 293);
            ASEN6116.project.components.General_P2P(this.toStores.Regolith_Gas_Output, 'Reg_SiF4_P2P', this.toStores.Regolith_Gas_Output.toPhases.Reg_Gas_Out, this.toStores.Regolith_Gas_Output.toPhases.TiF4_Gas_In, 'SiF4');
            ASEN6116.project.components.General_P2P(this.toStores.Regolith_Gas_Output, 'Reg_TiF4_P2P', this.toStores.Regolith_Gas_Output.toPhases.Reg_Gas_Out, this.toStores.Regolith_Gas_Output.toPhases.TiF4_Gas_In, 'TiF4');
            ASEN6116.project.components.General_P2P(this.toStores.Regolith_Gas_Output, 'Reg_F2_P2P', this.toStores.Regolith_Gas_Output.toPhases.Reg_Gas_Out, this.toStores.Regolith_Gas_Output.toPhases.TiF4_Gas_In, 'F2');
            ASEN6116.project.components.General_P2P(this.toStores.Regolith_Gas_Output, 'Reg_O2_P2P', this.toStores.Regolith_Gas_Output.toPhases.Reg_Gas_Out, this.toStores.Regolith_Gas_Output.toPhases.TiF4_Gas_In, 'O2');

            % Regolith Reactor Solid Output -> K Furnace Input
            matter.store(this, 'Regolith_Solid_Output', 10);
            matter.phases.solid(this.toStores.Regolith_Solid_Output, 'Reg_Solid_Out', struct('FeF3', 0.1, 'MgF2', 0.1, 'CaF2', 0.1, 'AlF3', 0.1, 'NaF', 0.1), 293);
            matter.phases.solid(this.toStores.Regolith_Solid_Output, 'K_Furnace_Solid_In', struct('FeF3', 0.1, 'MgF2', 0.1, 'CaF2', 0.1, 'AlF3', 0.1, 'NaF', 0.1, 'TiF4', 0.1, 'K', 0.1), 293);
            ASEN6116.project.components.General_P2P(this.toStores.Regolith_Solid_Output, 'Reg_FeF3_P2P', this.toStores.Regolith_Solid_Output.toPhases.Reg_Solid_Out, this.toStores.Regolith_Solid_Output.toPhases.K_Furnace_Solid_In, 'FeF3');
            ASEN6116.project.components.General_P2P(this.toStores.Regolith_Solid_Output, 'Reg_MgF2_P2P', this.toStores.Regolith_Solid_Output.toPhases.Reg_Solid_Out, this.toStores.Regolith_Solid_Output.toPhases.K_Furnace_Solid_In, 'MgF2');
            ASEN6116.project.components.General_P2P(this.toStores.Regolith_Solid_Output, 'Reg_CaF2_P2P', this.toStores.Regolith_Solid_Output.toPhases.Reg_Solid_Out, this.toStores.Regolith_Solid_Output.toPhases.K_Furnace_Solid_In, 'CaF2');
            ASEN6116.project.components.General_P2P(this.toStores.Regolith_Solid_Output, 'Reg_AlF3_P2P', this.toStores.Regolith_Solid_Output.toPhases.Reg_Solid_Out, this.toStores.Regolith_Solid_Output.toPhases.K_Furnace_Solid_In, 'AlF3');
            ASEN6116.project.components.General_P2P(this.toStores.Regolith_Solid_Output, 'Reg_NaF_P2P', this.toStores.Regolith_Solid_Output.toPhases.Reg_Solid_Out, this.toStores.Regolith_Solid_Output.toPhases.K_Furnace_Solid_In, 'NaF');

            % Regolith supply
            matter.store(this, 'Regolith_Supply', 10);
            matter.phases.mixture(this.toStores.Regolith_Supply, 'Feed_Regolith', 'solid', struct('Regolith', 100), this.oMT.Standard.Temperature, this.oMT.Standard.Pressure);

            % F2 supply
            matter.store(this, 'F2_Storage', 10);
            matter.phases.gas(this.toStores.F2_Storage, 'Feed_F2', struct('F2', 100), 0.5, 293);

            % TiF4 Condenser Solid Output and Potassium Furnace Input
            matter.store(this, 'TiF4_Solid_Output', 10);
            matter.phases.solid(this.toStores.TiF4_Solid_Output, 'TiF4_Solid_Out', struct('TiF4', 0.1), 293);
            matter.phases.solid(this.toStores.TiF4_Solid_Output, 'K_Furnace_TiF4_In', struct('TiF4', 0.1), 293);
            ASEN6116.project.components.General_P2P(this.toStores.TiF4_Solid_Output, 'K_Furnace_TiF4_P2P', this.toStores.TiF4_Solid_Output.toPhases.TiF4_Solid_Out, this.toStores.TiF4_Solid_Output.toPhases.K_Furnace_TiF4_In, 'TiF4');

            % TiF4 Condenser Gas Output and SiF4 Condenser Input
            matter.store(this, 'TiF4_Gas_Output', 10);
            matter.phases.gas(this.toStores.TiF4_Gas_Output, 'TiF4_Gas_Out', struct('SiF4', 0.1, 'O2', 0.1, 'F2', 0.1), 1, 293);
            matter.phases.gas(this.toStores.TiF4_Gas_Output, 'SiF4_Gas_In', struct('SiF4', 0.1, 'O2', 0.1, 'F2', 0.1), 1, 293);
            ASEN6116.project.components.General_P2P(this.toStores.TiF4_Gas_Output, 'Ti2Si_Condenser_SiF4_P2P', this.toStores.TiF4_Gas_Output.toPhases.TiF4_Gas_Out, this.toStores.TiF4_Gas_Output.toPhases.SiF4_Gas_In, 'SiF4');
            ASEN6116.project.components.General_P2P(this.toStores.TiF4_Gas_Output, 'Ti2Si_Condenser_O2_P2P', this.toStores.TiF4_Gas_Output.toPhases.TiF4_Gas_Out, this.toStores.TiF4_Gas_Output.toPhases.SiF4_Gas_In, 'O2');
            ASEN6116.project.components.General_P2P(this.toStores.TiF4_Gas_Output, 'Ti2Si_Condenser_F2_P2P', this.toStores.TiF4_Gas_Output.toPhases.TiF4_Gas_Out, this.toStores.TiF4_Gas_Output.toPhases.SiF4_Gas_In, 'F2');

            % SiF4 Condenser Solid Output and Plasma Reactor Input
            matter.store(this, 'SiF4_Solid_Output', 10);
            matter.phases.solid(this.toStores.SiF4_Solid_Output, 'SiF4_Solid_Out', struct('SiF4', 0.1), 293);
            matter.phases.solid(this.toStores.SiF4_Solid_Output, 'Plasma_Solid_In', struct('SiF4', 0.1), 293);
            ASEN6116.project.components.General_P2P(this.toStores.SiF4_Solid_Output, 'Plasma_Reactor_SiF4_P2P', this.toStores.SiF4_Solid_Output.toPhases.SiF4_Solid_Out, this.toStores.SiF4_Solid_Output.toPhases.Plasma_Solid_In, 'SiF4');

            % SiF4 Condenser Gas Output and Fluorination Reactor Input
            matter.store(this, 'SiF4_Gas_Output', 10);
            matter.phases.gas(this.toStores.SiF4_Gas_Output, 'SiF4_Gas_Out', struct('O2', 0.1, 'F2', 0.1), 1, 293);
            matter.phases.gas(this.toStores.SiF4_Gas_Output, 'Fluorination_Gas_In', struct('O2', 0.1, 'F2', 0.1), 1, 293);
            ASEN6116.project.components.General_P2P(this.toStores.SiF4_Gas_Output, 'Fluorination_O2_P2P', this.toStores.SiF4_Gas_Output.toPhases.SiF4_Gas_Out, this.toStores.SiF4_Gas_Output.toPhases.Fluorination_Gas_In, 'O2');
            ASEN6116.project.components.General_P2P(this.toStores.SiF4_Gas_Output, 'Fluorination_F2_P2P', this.toStores.SiF4_Gas_Output.toPhases.SiF4_Gas_Out, this.toStores.SiF4_Gas_Output.toPhases.Fluorination_Gas_In, 'F2');

            % Fluorination Reactor Solid Output and Potassium Furnace Input
            matter.store(this, 'Fluorination_Solid_Output', 10);
            matter.phases.solid(this.toStores.Fluorination_Solid_Output, 'Fluorination_Solid_Out', struct('FeF3', 0.1, 'MgF2', 0.1, 'CaF2', 0.1, 'AlF3', 0.1, 'NaF', 0.1), 293);
            matter.phases.solid(this.toStores.Fluorination_Solid_Output, 'Fluorination_to_K_Furnace_In', struct('FeF3', 0.1, 'MgF2', 0.1, 'CaF2', 0.1, 'AlF3', 0.1, 'NaF', 0.1), 293);
            ASEN6116.project.components.General_P2P(this.toStores.Fluorination_Solid_Output, 'Fluorination_to_K_Furnace_FeF3_P2P', this.toStores.Fluorination_Solid_Output.toPhases.Fluorination_Solid_Out, this.toStores.Fluorination_Solid_Output.toPhases.Fluorination_to_K_Furnace_In, 'FeF3');
            ASEN6116.project.components.General_P2P(this.toStores.Fluorination_Solid_Output, 'Fluorination_to_K_Furnace_MgF2_P2P', this.toStores.Fluorination_Solid_Output.toPhases.Fluorination_Solid_Out, this.toStores.Fluorination_Solid_Output.toPhases.Fluorination_to_K_Furnace_In, 'MgF2');
            ASEN6116.project.components.General_P2P(this.toStores.Fluorination_Solid_Output, 'Fluorination_to_K_Furnace_CaF2_P2P', this.toStores.Fluorination_Solid_Output.toPhases.Fluorination_Solid_Out, this.toStores.Fluorination_Solid_Output.toPhases.Fluorination_to_K_Furnace_In, 'CaF2');
            ASEN6116.project.components.General_P2P(this.toStores.Fluorination_Solid_Output, 'Fluorination_to_K_Furnace_AlF3_P2P', this.toStores.Fluorination_Solid_Output.toPhases.Fluorination_Solid_Out, this.toStores.Fluorination_Solid_Output.toPhases.Fluorination_to_K_Furnace_In, 'AlF3');
            ASEN6116.project.components.General_P2P(this.toStores.Fluorination_Solid_Output, 'Fluorination_to_K_Furnace_NaF_P2P', this.toStores.Fluorination_Solid_Output.toPhases.Fluorination_Solid_Out, this.toStores.Fluorination_Solid_Output.toPhases.Fluorination_to_K_Furnace_In, 'NaF');

            % Fluorination Reactor Gas Output and Oxygen Storage Input
            matter.store(this, 'Fluorination_Gas_Output', 10);
            matter.phases.gas(this.toStores.Fluorination_Gas_Output, 'Fluorination_Gas_Out', struct('O2', 0.1), 1, 293);
            matter.phases.gas(this.toStores.Fluorination_Gas_Output, 'O2_Storage_In', struct('O2', 0.1), 1, 293);
            ASEN6116.project.components.General_P2P(this.toStores.Fluorination_Gas_Output, 'O2_Storage_P2P', this.toStores.Fluorination_Gas_Output.toPhases.Fluorination_Gas_Out, this.toStores.Fluorination_Gas_Output.toPhases.O2_Storage_In, 'O2');

            % Plasma Reactor Solid Output and Silicon Storage Input
            matter.store(this, 'Plasma_Solid_Output', 10);
            matter.phases.solid(this.toStores.Plasma_Solid_Output, 'Plasma_Solid_Out', struct('Si', 0.1), 293);
            matter.phases.solid(this.toStores.Plasma_Solid_Output, 'Si_Storage_In', struct('Si', 0.1), 293);
            ASEN6116.project.components.General_P2P(this.toStores.Plasma_Solid_Output, 'Plasma_Reactor_Si_P2P', this.toStores.Plasma_Solid_Output.toPhases.Plasma_Solid_Out, this.toStores.Plasma_Solid_Output.toPhases.Si_Storage_In, 'Si');

            % Plasma Reactor Gas Output and Fluorine Storage Input
            matter.store(this, 'Plasma_Gas_Output', 10);
            matter.phases.gas(this.toStores.Plasma_Gas_Output, 'Plasma_Gas_Out', struct('F2', 0.1), 1, 293);
            matter.phases.gas(this.toStores.Plasma_Gas_Output, 'F2_Storage_In', struct('F2', 0.1), 1, 293);
            ASEN6116.project.components.General_P2P(this.toStores.Plasma_Gas_Output, 'F2_Storage_P2P', this.toStores.Plasma_Gas_Output.toPhases.Plasma_Gas_Out, this.toStores.Plasma_Gas_Output.toPhases.F2_Storage_In, 'F2');

            % Electrolyzer Solid Output to K Furnace
            matter.store(this, 'Electrolyzer_Solid_Output', 10);
            matter.phases.solid(this.toStores.Electrolyzer_Solid_Output, 'Electrolyzer_Solid_Out', struct('K', 0.1), 293);
            matter.phases.solid(this.toStores.Electrolyzer_Solid_Output, 'K_Furnace_Solid_In', struct('K', 0.1), 293);
            ASEN6116.project.components.General_P2P(this.toStores.Electrolyzer_Solid_Output, 'K_P2P', this.toStores.Electrolyzer_Solid_Output.toPhases.Electrolyzer_Solid_Out, this.toStores.Electrolyzer_Solid_Output.toPhases.K_Furnace_Solid_In, 'K');

            % Electrolyzer Gas Output to F2 Storage
            matter.store(this, 'Electrolyzer_Gas_Output', 10);
            matter.phases.gas(this.toStores.Electrolyzer_Gas_Output, 'Electrolyzer_Gas_Out', struct('F2', 0.1), 1, 293);
            matter.phases.gas(this.toStores.Electrolyzer_Gas_Output, 'Electrolyzer_to_F2', struct('F2', 0.1), 1, 293);
            ASEN6116.project.components.General_P2P(this.toStores.Electrolyzer_Gas_Output, 'Electrolyzer_to_F2_P2P', this.toStores.Electrolyzer_Gas_Output.toPhases.Electrolyzer_Gas_Out, this.toStores.Electrolyzer_Gas_Output.toPhases.Electrolyzer_to_F2, 'F2');

            % K Furnace Solid Output to Metals Output
            matter.store(this, 'K_Furnace_Solid_Output', 10);
            matter.phases.solid(this.toStores.K_Furnace_Solid_Output, 'K_Furnace_Solid_Out', struct('Fe', 0.1, 'Al', 0.1, 'CaO', 0.1, 'MgO', 0.1, 'Na2O', 0.1, 'TiO2', 0.1), 293);
            matter.phases.solid(this.toStores.K_Furnace_Solid_Output, 'Metal_Storage_In', struct('Fe', 0.1, 'Al', 0.1, 'CaO', 0.1, 'MgO', 0.1, 'Na2O', 0.1, 'TiO2', 0.1), 293);
            ASEN6116.project.components.General_P2P(this.toStores.K_Furnace_Solid_Output, 'Fe_Storage_P2P', this.toStores.K_Furnace_Solid_Output.toPhases.K_Furnace_Solid_Out, this.toStores.K_Furnace_Solid_Output.toPhases.Metal_Storage_In, 'Fe');
            ASEN6116.project.components.General_P2P(this.toStores.K_Furnace_Solid_Output, 'Al_Storage_P2P', this.toStores.K_Furnace_Solid_Output.toPhases.K_Furnace_Solid_Out, this.toStores.K_Furnace_Solid_Output.toPhases.Metal_Storage_In, 'Al');
            ASEN6116.project.components.General_P2P(this.toStores.K_Furnace_Solid_Output, 'CaO_Storage_P2P', this.toStores.K_Furnace_Solid_Output.toPhases.K_Furnace_Solid_Out, this.toStores.K_Furnace_Solid_Output.toPhases.Metal_Storage_In, 'CaO');
            ASEN6116.project.components.General_P2P(this.toStores.K_Furnace_Solid_Output, 'MgO_Storage_P2P', this.toStores.K_Furnace_Solid_Output.toPhases.K_Furnace_Solid_Out, this.toStores.K_Furnace_Solid_Output.toPhases.Metal_Storage_In, 'MgO');
            ASEN6116.project.components.General_P2P(this.toStores.K_Furnace_Solid_Output, 'Na2O_Storage_P2P', this.toStores.K_Furnace_Solid_Output.toPhases.K_Furnace_Solid_Out, this.toStores.K_Furnace_Solid_Output.toPhases.Metal_Storage_In, 'Na2O');
            ASEN6116.project.components.General_P2P(this.toStores.K_Furnace_Solid_Output, 'TiO2_Storage_P2P', this.toStores.K_Furnace_Solid_Output.toPhases.K_Furnace_Solid_Out, this.toStores.K_Furnace_Solid_Output.toPhases.Metal_Storage_In, 'TiO2');

            % K Furnace Liquid Output to Electrolyzer
            matter.store(this, 'K_Furnace_Liquid_Output', 10);
            matter.phases.liquid(this.toStores.K_Furnace_Liquid_Output, 'K_Furnace_Liquid_Out', struct('KF', 0.1), 293, 1e5);
            matter.phases.liquid(this.toStores.K_Furnace_Liquid_Output, 'Electrolyzer_Liquid_In', struct('KF', 0.1), 293, 1e5);
            ASEN6116.project.components.General_P2P(this.toStores.K_Furnace_Liquid_Output, 'KF_P2P', this.toStores.K_Furnace_Liquid_Output.toPhases.K_Furnace_Liquid_Out, this.toStores.K_Furnace_Liquid_Output.toPhases.Electrolyzer_Liquid_In, 'KF');

            % External Stores-> Regolith Reactor
            matter.branch(this, 'Regolith_Reactor_Gas_Inlet',  {}, this.toStores.F2_Storage.toPhases.Feed_F2);
            matter.branch(this, 'Regolith_Reactor_Solid_Inlet',  {}, this.toStores.Regolith_Supply.toPhases.Feed_Regolith);
            % Regolith Reactor -> Regolith Reactor Output Stores
            matter.branch(this, 'Regolith_Reactor_Solid_Outlet',  {}, this.toStores.Regolith_Solid_Output.toPhases.Reg_Solid_Out);
            matter.branch(this, 'Regolith_Reactor_Gas_Outlet',  {},this.toStores.Regolith_Gas_Output.toPhases.Reg_Gas_Out); 
            % Connect IF Flows
            this.toChildren.Regolith_Reactor.setIfFlows('Regolith_Reactor_Gas_Inlet','Regolith_Reactor_Solid_Inlet','Regolith_Reactor_Gas_Outlet','Regolith_Reactor_Solid_Outlet');
                       
            % TiF4 Condenser Input Stores -> TiF4 Condenser
            matter.branch(this, 'TiF4_Condenser_Inlet', {}, this.toStores.Regolith_Gas_Output.toPhases.TiF4_Gas_In);
            % TiF4 Condenser -> TiF4 Condenser Output Stores
            matter.branch(this, 'TiF4_Condenser_Solid_Outlet', {}, this.toStores.TiF4_Solid_Output.toPhases.TiF4_Solid_Out);
            matter.branch(this, 'TiF4_Condenser_Gas_Outlet', {}, this.toStores.TiF4_Gas_Output.toPhases.TiF4_Gas_Out);
            % Connect IF Flows
            this.toChildren.TiF4_Condenser.setIfFlows('TiF4_Condenser_Inlet', 'TiF4_Condenser_Gas_Outlet', 'TiF4_Condenser_Solid_Outlet');

            % SiF4 Condenser Input Stores -> SiF4 Condenser
            matter.branch(this, 'SiF4_Condenser_Inlet', {}, this.toStores.TiF4_Gas_Output.toPhases.SiF4_Gas_In);
            % SiF4 Condenser -> SiF4 Condenser Output Stores
            matter.branch(this, 'SiF4_Condenser_Solid_Outlet', {}, this.toStores.SiF4_Solid_Output.toPhases.SiF4_Solid_Out);
            matter.branch(this, 'SiF4_Condenser_Gas_Outlet', {}, this.toStores.SiF4_Gas_Output.toPhases.SiF4_Gas_Out);
            % Connect IF Flows
            this.toChildren.SiF4_Condenser.setIfFlows('SiF4_Condenser_Inlet', 'SiF4_Condenser_Gas_Outlet', 'SiF4_Condenser_Solid_Outlet');

            % Fluorination Reactor Input Stores -> Fluorination Reactor
            matter.branch(this, 'Fluorination_Reactor_Inlet', {}, this.toStores.SiF4_Gas_Output.toPhases.Fluorination_Gas_In);
            % Fluorination Reactor -> Fluorination Reactor Output Stores
            matter.branch(this, 'Fluorination_Reactor_Solid_Outlet', {}, this.toStores.Fluorination_Solid_Output.toPhases.Fluorination_Solid_Out);
            matter.branch(this, 'Fluorination_Reactor_Gas_Outlet', {}, this.toStores.Fluorination_Gas_Output.toPhases.Fluorination_Gas_Out);
            % Connect IF Flows
            this.toChildren.Fluorination_Reactor.setIfFlows('Fluorination_Reactor_Inlet', 'Fluorination_Reactor_Gas_Outlet', 'Fluorination_Reactor_Solid_Outlet');

            % Plasma Reactor Input Stores -> Plasma Reactor
            matter.branch(this, 'Plasma_Reactor_Inlet', {}, this.toStores.SiF4_Solid_Output.toPhases.Plasma_Solid_In);
            % Plasma Reactor -> Plasma Reactor Output Stores
            matter.branch(this, 'Plasma_Reactor_Solid_Outlet', {}, this.toStores.Plasma_Solid_Output.toPhases.Plasma_Solid_Out);
            matter.branch(this, 'Plasma_Reactor_Gas_Outlet', {}, this.toStores.Plasma_Gas_Output.toPhases.Plasma_Gas_Out);
            % Connect IF Flows
            this.toChildren.Plasma_Reactor.setIfFlows('Plasma_Reactor_Inlet', 'Plasma_Reactor_Gas_Outlet', 'Plasma_Reactor_Solid_Outlet');

            % Electrolyzer Input Stores -> Electrolyzer
            matter.branch(this, 'KF_In', {}, this.toStores.K_Furnace_Liquid_Output.toPhases.Electrolyzer_Liquid_In);
            % Electrolyzer -> Electrolyzer Output Stores
            matter.branch(this, 'Electrolyzer_F2_Out', {}, this.toStores.Electrolyzer_Gas_Output.toPhases.Electrolyzer_Gas_Out);
            matter.branch(this, 'Electrolyzer_to_K_Loopback', {}, this.toStores.Electrolyzer_Solid_Output.toPhases.Electrolyzer_Solid_Out);
            this.toChildren.KF_Electrolyzer.setIfFlows('KF_In', 'Electrolyzer_F2_Out', 'Electrolyzer_to_K_Loopback');

            % Potassium Furnace Input Stores -> Potassium Furnace
            matter.branch(this, 'RR_to_K_Furnace', {}, this.toStores.Regolith_Solid_Output.toPhases.K_Furnace_Solid_In);
            matter.branch(this, 'O2_Feed_to_K_Furnace', {}, this.toStores.Fluorination_Gas_Output.toPhases.O2_Storage_In);
            matter.branch(this, 'TiF4_to_K_Furnace', {}, this.toStores.TiF4_Solid_Output.toPhases.K_Furnace_TiF4_In);
            matter.branch(this, 'Fluorination_to_K_Furnace', {}, this.toStores.Fluorination_Solid_Output.toPhases.Fluorination_to_K_Furnace_In);
            matter.branch(this, 'Electrolyzer_to_K_Furnace', {}, this.toStores.Electrolyzer_Solid_Output.toPhases.K_Furnace_Solid_In);
            % Potassium Furnace -> Potassium Furnace Output Stores
            matter.branch(this, 'K_Furnace_to_Metal_Output', {}, this.toStores.K_Furnace_Solid_Output.toPhases.K_Furnace_Solid_Out);
            matter.branch(this, 'K_Furnace_to_Electrolyzer', {}, this.toStores.K_Furnace_Liquid_Output.toPhases.K_Furnace_Liquid_Out);
            this.toChildren.K_Furnace.setIfFlows('RR_to_K_Furnace', 'Fluorination_to_K_Furnace', 'TiF4_to_K_Furnace', 'Electrolyzer_to_K_Furnace', 'O2_Feed_to_K_Furnace', 'K_Furnace_to_Electrolyzer', 'K_Furnace_to_Metal_Output');

            % Branch plasma reactor fluorine output back to fluorine storage
            matter.branch(this, this.toStores.Plasma_Gas_Output.toPhases.F2_Storage_In, {}, this.toStores.F2_Storage.toPhases.Feed_F2, 'Plasma_Reactor_to_F2_Storage');
            matter.branch(this, this.toStores.Electrolyzer_Gas_Output.toPhases.Electrolyzer_to_F2, {}, this.toStores.F2_Storage.toPhases.Feed_F2, 'Electrolyzer_to_F2_Storage');        
        end

        function createSolverStructure(this)
            createSolverStructure@vsys(this);

            % Return fluorine from plasma reactor to F2 storage
            solver.matter.residual.branch(this.toBranches.Plasma_Reactor_to_F2_Storage);
            solver.matter.residual.branch(this.toBranches.Electrolyzer_to_F2_Storage);

            this.setThermalSolvers();
        end
    end



    methods (Access = protected)
        function exec(this, ~)
            exec@vsys(this);

        end
    end
end