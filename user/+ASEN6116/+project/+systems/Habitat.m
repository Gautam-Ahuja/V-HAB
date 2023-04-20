classdef Habitat < vsys
    properties (SetAccess = protected, GetAccess = public)

    end

    methods
        function this = Habitat(oParent, sName)
            this@vsys(oParent, sName, 30);
            eval(this.oRoot.oCfgParams.configCode(this));

            ASEN6116.project.subsystems.Fluorination_Reactor(this, 'Fluorination_Reactor');
%             ASEN6116.project.subsystems.K_Furnace(this, 'K_Furnace');
%             ASEN6116.project.subsystems.KF_Electrolyzer(this, 'KF_Electrolyzer');
%             ASEN6116.project.subsystems.Plasma_Reactor(this, 'Plasma_Reactor');
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

            % Regolith Reactor Solid Output
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
            matter.phases.solid(this.toStores.SiF4_Solid_Output, 'Plasma_Reactor_SiF4_In', struct('SiF4', 0.1), 293);
            ASEN6116.project.components.General_P2P(this.toStores.SiF4_Solid_Output, 'Plasma_Reactor_SiF4_P2P', this.toStores.SiF4_Solid_Output.toPhases.SiF4_Solid_Out, this.toStores.SiF4_Solid_Output.toPhases.Plasma_Reactor_SiF4_In, 'SiF4');

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

            % Fluorination Reactor Gas Output and Oxygen Output Storage Input
            matter.store(this, 'Fluorination_Gas_Output', 10);
            matter.phases.gas(this.toStores.Fluorination_Gas_Output, 'Fluorination_Gas_Out', struct('O2', 0.1), 1, 293);
            matter.phases.gas(this.toStores.Fluorination_Gas_Output, 'Oxygen_Output_In', struct('O2', 0.1), 1, 293);
            ASEN6116.project.components.General_P2P(this.toStores.Fluorination_Gas_Output, 'O2_Storage_P2P', this.toStores.Fluorination_Gas_Output.toPhases.Fluorination_Gas_Out, this.toStores.Fluorination_Gas_Output.toPhases.Oxygen_Output_In, 'O2');

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

%             % Metal output
%             matter.store(this, 'Metal_Storage', 10);
%             matter.phases.solid(this.toStores.Metal_Storage, 'Metal_Output', struct('Si', 0.01, 'Fe', 0.01, 'Al', 0.01, 'CaO', 0.01, 'MgO', 0.01, 'Na2O', 0.01, 'TiO2', 0.01));
% 
%             % Silicon output
%             matter.store(this, 'Si_Storage', 10);
%             matter.phases.solid(this.toStores.Si_Storage, 'Si_Output', struct('Si',.01),293);
%         
%             % Branches %
%             % TiF4 Condensor -> Potassium Furnace & SiF4 Furnace
%             matter.branch(this, 'TiF4_Condenser_Solid_Outlet',  {},'K_Furnace_TiF4_Inlet'); 
%             matter.branch(this, 'TiF4_Condenser_Gas_Outlet',  {},'SiF4_Condenser_Gas_Inlet');
%             % SiF4 Condensor -> Flourination Reactor & Plasma Reactor
%             matter.branch(this, 'SiF4_Condenser_Gas_Outlet',  {},'Flourination_Reactor_Gas_Inlet'); 
%             matter.branch(this, 'SiF4_Condenser_Solid_Outlet',  {},'Plasma_Reactor_Solid_Input');
%             % Plasma Reactor -> F2 Store & Si Store
%             matter.branch(this, 'Plasma_Reactor_Solid_Outlet',  {},this.toStores.Si_Storage.toPhases.Si_Output);
%             matter.branch(this, 'Plasma_Reactor_Gas_Outlet',  {},this.toStores.F2_Storage.toPhases.Feed_F2);
%             % Metal Output -> Fluroination Reactor -> K Potassium Furnace & O2 Store
%             matter.branch(this, this.toStores.Metal_Storage.toPhases.Metal_Output,  {},'Flourination_Reactor_Solid_Inlet'); 
%             matter.branch(this, 'Flourination_Reactor_Gas_Outlet',  {},this.toStores.O2_Storage.toPhases.O2_Output); 
%             matter.branch(this, 'Flourination_Reactor_Solid_Outlet',  {},'K_Furnace_Metal_Fluorides_Inlet'); 
%             % O2 &K-> Potassium Furnace -> Electrolyzer & Metal output
%             matter.branch(this, this.toStores.O2_Storage.toPhases.O2_Output,  {},'K_Furnace_StoreO2_Inlet'); 
%             matter.branch(this, 'KF_Electro_K_Inlet',  {},'K_Furnace_StoreO2_Inlet');
%             matter.branch(this, 'K_Furnace_Solid_Outlet',  {},this.toStores.Metal_Storage.toPhases.Metal_Output);
%             matter.branch(this, 'K_Furnace_Liquid_Outlet',  {},'KF_Electrolyzer_Liquid_Inlet');
%             % KF Electrolyzer-> F2
%             matter.branch(this, 'KF_Electrolyzer_F2_Outlet',  {},this.toStores.F2_Storage.toPhases.Feed_F2);
% 
%           
%             % Child Linkage of the System Input/Outputs to the subsystems %
%             this.toChildren.TiF4_Condenser.setIfFlows('TiF4_Condenser_Gas_Inlet','TiF4_Condenser_Gas_Outlet','TiF4_Condenser_Solid_Outlet');
%             this.toChildren.SiF4_Condenser.setIfFlows('SiF4_Condenser_Gas_Inlet','SiF4_Condenser_Gas_Outlet','SiF4_Condenser_Solid_Outlet');
%             this.toChildren.Flourination_Reactor.setIfFlows('Flourination_Reactor_Gas_Inlet','Flourination_Reactor_Solid_Inlet','Flourination_Reactor_Gas_Outlet',solid);
%             this.toChildren.Plasma_Reactor.setIfFlows('Plasma_Reactor_Solid_Input', 'Plasma_Reactor_Gas_Outlet', 'Plasma_Reactor_Solid_Outlet');
%             this.toChildren.K_Furnace.setIfFlows('K_Furnace_Solid_Inlet', 'K_Furnace_Metal_Fluorides_Inlet', 'K_Furnace_TiF4_Inlet', 'KF_Electro_K_Inlet', 'K_Furnace_StoreO2_Inlet', 'K_Furnace_Liquid_Outlet', 'K_Furnace_Solid_Outlet');
%             this.toChildren.KF_Electrolyzer.setIfFlows('KF_Electrolyzer_Liquid_Inlet', 'KF_Electrolyzer_F2_Outlet', 'KF_Electro_K_Inlet');

        
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
end