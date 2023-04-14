classdef Habitat < vsys
    properties (SetAccess = protected, GetAccess = public)

    end

    methods
        function this = Habitat(oParent, sName)
            this@vsys(oParent, sName, 30);
            eval(this.oRoot.oCfgParams.configCode(this));

%             ASEN6116.project.subsystems.Fluorination_Reactor(this, 'Fluorination_Reactor');
%             ASEN6116.project.subsystems.K_Furnace(this, 'K_Furnace');
%             ASEN6116.project.subsystems.KF_Electrolyzer(this, 'KF_Electrolyzer');
%             ASEN6116.project.subsystems.Plasma_Reactor(this, 'Plasma_Reactor');
            ASEN6116.project.subsystems.Regolith_Reactor(this, 'Regolith_Reactor');
%             ASEN6116.project.subsystems.SiF4_Condenser(this, 'SiF4_Condenser');
%             ASEN6116.project.subsystems.TiF4_Condenser(this, 'TiF4_Condenser');
        end

        function createMatterStructure(this)
            createMatterStructure@vsys(this);

            % Cabin - not yet needed
            % matter.store(this, 'Cabin', 38);
            % this.toStores.Cabin.createPhase('gas', 'CabinAir', 38, struct('O2', 34473.8), 293, 0.5);    % 5 psia

            % O2 storage
            %matter.store(this, 'O2_Storage', 10);
            %matter.phases.gas(this.toStores.O2_Storage, 'O2_Output', struct('O2', .01), 10, 293);

            % Regolith Gas Output
            matter.store(this, 'Regolith_Gas_Output', 10);
            matter.phases.gas(this.toStores.Regolith_Gas_Output, 'Reg_Gas_Out', struct('SiF4', 0.01, 'TiF4', 0.01, 'O2', 0.01,'F2', 0.01), 1, 293);

            % Regolith Solid Output
            matter.store(this, 'Regolith_Solid_Output', 10);
            matter.phases.solid(this.toStores.Regolith_Solid_Output, 'Reg_Solid_Out', struct('FeF3', 0.01, 'MgF2', 0.01, 'CaF2', 0.01, 'AlF3', 0.01, 'NaF', 0.01), 293);

            % Regolith supply
            matter.store(this, 'Regolith_Supply', 10);
            matter.phases.mixture(this.toStores.Regolith_Supply, 'Feed_Regolith', 'solid', struct('Regolith', 100), this.oMT.Standard.Temperature, this.oMT.Standard.Pressure);

            % F2 supply
            matter.store(this, 'F2_Storage', 10);
            matter.phases.gas(this.toStores.F2_Storage, 'Feed_F2', struct('F2', 1), 0.5, 293);

            % Stores-> Regolith Reactor
            matter.branch(this, 'Regolith_Reactor_Gas_Inlet',  {}, this.toStores.F2_Storage.toPhases.Feed_F2);
            matter.branch(this, 'Regolith_Reactor_Solid_Inlet',  {}, this.toStores.Regolith_Supply.toPhases.Feed_Regolith);
            % Regolith Reactor -> Potassium Furnace & TiF4 Condensor
            matter.branch(this, 'Regolith_Reactor_Solid_Outlet',  {}, this.toStores.Regolith_Solid_Output.toPhases.Reg_Solid_Out);
            matter.branch(this, 'Regolith_Reactor_Gas_Outlet',  {},this.toStores.Regolith_Gas_Output.toPhases.Reg_Gas_Out); 

            this.toChildren.Regolith_Reactor.setIfFlows('Regolith_Reactor_Gas_Inlet','Regolith_Reactor_Solid_Inlet','Regolith_Reactor_Gas_Outlet','Regolith_Reactor_Solid_Outlet');



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