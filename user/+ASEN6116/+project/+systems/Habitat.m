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

            % Regolith Reactor Solid Output -> K Furnace Input
            matter.store(this, 'Regolith_Solid_Output', 10);
            matter.phases.solid(this.toStores.Regolith_Solid_Output, 'Reg_Solid_Out', struct('FeF3', 0.1, 'MgF2', 0.1, 'CaF2', 0.1, 'AlF3', 0.1, 'NaF', 0.1), 293);

            % Regolith supply
            matter.store(this, 'Regolith_Supply', 10);
            matter.phases.mixture(this.toStores.Regolith_Supply, 'Feed_Regolith', 'solid', struct('Regolith', 100), this.oMT.Standard.Temperature, this.oMT.Standard.Pressure);

            % F2 supply
            matter.store(this, 'F2_Storage', 10);
            matter.phases.gas(this.toStores.F2_Storage, 'Feed_F2', struct('F2', 100), 0.5, 293);

            % TiF4 Condenser Solid Output and Potassium Furnace Input
            matter.store(this, 'TiF4_Solid_Output', 10);
            matter.phases.solid(this.toStores.TiF4_Solid_Output, 'TiF4_Solid_Out', struct('TiF4', 0.1), 293);

            % TiF4 Condenser Gas Output and SiF4 Condenser Input
            matter.store(this, 'TiF4_Gas_Output', 10);
            matter.phases.gas(this.toStores.TiF4_Gas_Output, 'TiF4_Gas_Out', struct('SiF4', 0.1, 'O2', 0.1, 'F2', 0.1), 1, 293);

            % SiF4 Condenser Solid Output and Plasma Reactor Input
            matter.store(this, 'SiF4_Solid_Output', 10);
            matter.phases.solid(this.toStores.SiF4_Solid_Output, 'SiF4_Solid_Out', struct('SiF4', 0.1), 293);

            % SiF4 Condenser Gas Output and Fluorination Reactor Input
            matter.store(this, 'SiF4_Gas_Output', 10);
            matter.phases.gas(this.toStores.SiF4_Gas_Output, 'SiF4_Gas_Out', struct('O2', 0.1, 'F2', 0.1), 1, 293);

            % Fluorination Reactor Solid Output and Potassium Furnace Input
            matter.store(this, 'Fluorination_Solid_Output', 10);
            matter.phases.solid(this.toStores.Fluorination_Solid_Output, 'Fluorination_Solid_Out', struct('FeF3', 0.1, 'MgF2', 0.1, 'CaF2', 0.1, 'AlF3', 0.1, 'NaF', 0.1), 293);

            % Fluorination Reactor Gas Output and Oxygen Storage Input
            matter.store(this, 'Fluorination_Gas_Output', 10);
            matter.phases.gas(this.toStores.Fluorination_Gas_Output, 'Fluorination_Gas_Out', struct('O2', 0.1), 1, 293);

            % Plasma Reactor Solid Output and Silicon Storage Input
            matter.store(this, 'Plasma_Solid_Output', 10);
            matter.phases.solid(this.toStores.Plasma_Solid_Output, 'Plasma_Solid_Out', struct('Si', 0.1), 293);

            % Plasma Reactor Gas Output and Fluorine Storage Input
            matter.store(this, 'Plasma_Gas_Output', 10);
            matter.phases.gas(this.toStores.Plasma_Gas_Output, 'Plasma_Gas_Out', struct('F2', 0.1), 1, 293);

            % Electrolyzer Solid Output to K Furnace
            matter.store(this, 'Electrolyzer_Solid_Output', 10);
            matter.phases.solid(this.toStores.Electrolyzer_Solid_Output, 'Electrolyzer_Solid_Out', struct('K', 0.1), 293);

            % Electrolyzer Gas Output to F2 Storage
            matter.store(this, 'Electrolyzer_Gas_Output', 10);
            matter.phases.gas(this.toStores.Electrolyzer_Gas_Output, 'Electrolyzer_Gas_Out', struct('F2', 0.1), 1, 293);

            % K Furnace Solid Output to Metals Output
            matter.store(this, 'K_Furnace_Solid_Output', 10);
            matter.phases.solid(this.toStores.K_Furnace_Solid_Output, 'K_Furnace_Solid_Out', struct('Fe', 0.1, 'Al', 0.1, 'CaO', 0.1, 'MgO', 0.1, 'Na2O', 0.1, 'TiO2', 0.1), 293);

            % K Furnace Liquid Output to Electrolyzer
            matter.store(this, 'K_Furnace_Liquid_Output', 10);
            matter.phases.liquid(this.toStores.K_Furnace_Liquid_Output, 'K_Furnace_Liquid_Out', struct('KF', 0.1), 293, 1e5);

            % External Stores-> Regolith Reactor
            matter.branch(this, 'Regolith_Reactor_Gas_Inlet',  {}, this.toStores.F2_Storage.toPhases.Feed_F2);
            matter.branch(this, 'Regolith_Reactor_Solid_Inlet',  {}, this.toStores.Regolith_Supply.toPhases.Feed_Regolith);
            % Regolith Reactor -> Regolith Reactor Output Stores
            matter.branch(this, 'Regolith_Reactor_Solid_Outlet',  {}, this.toStores.Regolith_Solid_Output.toPhases.Reg_Solid_Out);
            matter.branch(this, 'Regolith_Reactor_Gas_Outlet',  {},this.toStores.Regolith_Gas_Output.toPhases.Reg_Gas_Out); 
            % Connect IF Flows
            this.toChildren.Regolith_Reactor.setIfFlows('Regolith_Reactor_Gas_Inlet','Regolith_Reactor_Solid_Inlet','Regolith_Reactor_Gas_Outlet','Regolith_Reactor_Solid_Outlet');
                       
            % TiF4 Condenser Input Stores -> TiF4 Condenser
            matter.branch(this, 'TiF4_Condenser_Inlet', {}, this.toStores.Regolith_Gas_Output.toPhases.Reg_Gas_Out);
            % TiF4 Condenser -> TiF4 Condenser Output Stores
            matter.branch(this, 'TiF4_Condenser_Solid_Outlet', {}, this.toStores.TiF4_Solid_Output.toPhases.TiF4_Solid_Out);
            matter.branch(this, 'TiF4_Condenser_Gas_Outlet', {}, this.toStores.TiF4_Gas_Output.toPhases.TiF4_Gas_Out);
            % Connect IF Flows
            this.toChildren.TiF4_Condenser.setIfFlows('TiF4_Condenser_Inlet', 'TiF4_Condenser_Gas_Outlet', 'TiF4_Condenser_Solid_Outlet');

            % SiF4 Condenser Input Stores -> SiF4 Condenser
            matter.branch(this, 'SiF4_Condenser_Inlet', {}, this.toStores.TiF4_Gas_Output.toPhases.TiF4_Gas_Out);
            % SiF4 Condenser -> SiF4 Condenser Output Stores
            matter.branch(this, 'SiF4_Condenser_Solid_Outlet', {}, this.toStores.SiF4_Solid_Output.toPhases.SiF4_Solid_Out);
            matter.branch(this, 'SiF4_Condenser_Gas_Outlet', {}, this.toStores.SiF4_Gas_Output.toPhases.SiF4_Gas_Out);
            % Connect IF Flows
            this.toChildren.SiF4_Condenser.setIfFlows('SiF4_Condenser_Inlet', 'SiF4_Condenser_Gas_Outlet', 'SiF4_Condenser_Solid_Outlet');

            % Fluorination Reactor Input Stores -> Fluorination Reactor
            matter.branch(this, 'Fluorination_Reactor_Inlet', {}, this.toStores.SiF4_Gas_Output.toPhases.SiF4_Gas_Out);
            % Fluorination Reactor -> Fluorination Reactor Output Stores
            matter.branch(this, 'Fluorination_Reactor_Solid_Outlet', {}, this.toStores.Fluorination_Solid_Output.toPhases.Fluorination_Solid_Out);
            matter.branch(this, 'Fluorination_Reactor_Gas_Outlet', {}, this.toStores.Fluorination_Gas_Output.toPhases.Fluorination_Gas_Out);
            % Connect IF Flows
            this.toChildren.Fluorination_Reactor.setIfFlows('Fluorination_Reactor_Inlet', 'Fluorination_Reactor_Gas_Outlet', 'Fluorination_Reactor_Solid_Outlet');

            % Plasma Reactor Input Stores -> Plasma Reactor
            matter.branch(this, 'Plasma_Reactor_Inlet', {}, this.toStores.SiF4_Solid_Output.toPhases.SiF4_Solid_Out);
            % Plasma Reactor -> Plasma Reactor Output Stores
            matter.branch(this, 'Plasma_Reactor_Solid_Outlet', {}, this.toStores.Plasma_Solid_Output.toPhases.Plasma_Solid_Out);
            matter.branch(this, 'Plasma_Reactor_Gas_Outlet', {}, this.toStores.Plasma_Gas_Output.toPhases.Plasma_Gas_Out);
            % Connect IF Flows
            this.toChildren.Plasma_Reactor.setIfFlows('Plasma_Reactor_Inlet', 'Plasma_Reactor_Gas_Outlet', 'Plasma_Reactor_Solid_Outlet');

            % Electrolyzer Input Stores -> Electrolyzer
            matter.branch(this, 'KF_In', {}, this.toStores.K_Furnace_Liquid_Output.toPhases.K_Furnace_Liquid_Out);
            % Electrolyzer -> Electrolyzer Output Stores
            matter.branch(this, 'Electrolyzer_F2_Out', {}, this.toStores.Electrolyzer_Gas_Output.toPhases.Electrolyzer_Gas_Out);
            matter.branch(this, 'Electrolyzer_to_K_Loopback', {}, this.toStores.Electrolyzer_Solid_Output.toPhases.Electrolyzer_Solid_Out);
            this.toChildren.KF_Electrolyzer.setIfFlows('KF_In', 'Electrolyzer_F2_Out', 'Electrolyzer_to_K_Loopback');

            % Potassium Furnace Input Stores -> Potassium Furnace
            matter.branch(this, 'RR_to_K_Furnace', {}, this.toStores.Regolith_Solid_Output.toPhases.Reg_Solid_Out);
            matter.branch(this, 'O2_Feed_to_K_Furnace', {}, this.toStores.Fluorination_Gas_Output.toPhases.Fluorination_Gas_Out);
            matter.branch(this, 'TiF4_to_K_Furnace', {}, this.toStores.TiF4_Solid_Output.toPhases.TiF4_Solid_Out);
            matter.branch(this, 'Fluorination_to_K_Furnace', {}, this.toStores.Fluorination_Solid_Output.toPhases.Fluorination_Solid_Out);
            matter.branch(this, 'Electrolyzer_to_K_Furnace', {}, this.toStores.Electrolyzer_Solid_Output.toPhases.Electrolyzer_Solid_Out);
            % Potassium Furnace -> Potassium Furnace Output Stores
            matter.branch(this, 'K_Furnace_to_Metal_Output', {}, this.toStores.K_Furnace_Solid_Output.toPhases.K_Furnace_Solid_Out);
            matter.branch(this, 'K_Furnace_to_Electrolyzer', {}, this.toStores.K_Furnace_Liquid_Output.toPhases.K_Furnace_Liquid_Out);
            this.toChildren.K_Furnace.setIfFlows('RR_to_K_Furnace', 'Fluorination_to_K_Furnace', 'TiF4_to_K_Furnace', 'Electrolyzer_to_K_Furnace', 'O2_Feed_to_K_Furnace', 'K_Furnace_to_Electrolyzer', 'K_Furnace_to_Metal_Output');

            % Branch plasma reactor fluorine output back to fluorine storage
            matter.branch(this, this.toStores.Plasma_Gas_Output.toPhases.Plasma_Gas_Out, {}, this.toStores.F2_Storage.toPhases.Feed_F2, 'Plasma_Reactor_to_F2_Storage');
            matter.branch(this, this.toStores.Electrolyzer_Gas_Output.toPhases.Electrolyzer_Gas_Out, {}, this.toStores.F2_Storage.toPhases.Feed_F2, 'Electrolyzer_to_F2_Storage');        
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