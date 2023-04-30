classdef KF_Electrolyzer < vsys
    properties (SetAccess = protected, GetAccess = public)

    end

    methods
        function this = KF_Electrolyzer(oParent, sName)
            this@vsys(oParent, sName, 30);
            eval(this.oRoot.oCfgParams.configCode(this));
        end

        function createMatterStructure(this)
            createMatterStructure@vsys(this);
            % Store
            matter.store(this, 'KF_Electrolyzer_Store', 1);

            % Phases
            matter.phases.liquid(this.toStores.KF_Electrolyzer_Store, 'KF_Electrolyzer_Input', struct('KF', 1), 293, 1e5);
            matter.phases.gas(this.toStores.KF_Electrolyzer_Store, 'KF_Electrolyzer_Gas_Output', struct('F2', 0.1), 0.25, 293);
            matter.phases.solid(this.toStores.KF_Electrolyzer_Store, 'KF_Electrolyzer_Solid_Output', struct('K', 0.1), 293);

            % Manip
            ASEN6116.project.components.KF_Electrolyzer_Manip('KF_Electrolyzer_Manip', this.toStores.KF_Electrolyzer_Store.toPhases.KF_Electrolyzer_Input);

            % Gaseous P2P
            ASEN6116.project.components.KF_Electrolyzer_P2P(this.toStores.KF_Electrolyzer_Store, 'F2_P2P', this.toStores.KF_Electrolyzer_Store.toPhases.KF_Electrolyzer_Input, this.toStores.KF_Electrolyzer_Store.toPhases.KF_Electrolyzer_Gas_Output, 'F2');

            % Solid P2P
            ASEN6116.project.components.KF_Electrolyzer_P2P(this.toStores.KF_Electrolyzer_Store, 'K_P2P', this.toStores.KF_Electrolyzer_Store.toPhases.KF_Electrolyzer_Input, this.toStores.KF_Electrolyzer_Store.toPhases.KF_Electrolyzer_Solid_Output, 'K');

            % Pipes
            fLength     = 1;    % Pipe length in m
            fDiameter   = 0.01; % Pipe Diameter in m
            components.matter.pipe(this, 'Pipe_1', fLength, fDiameter);
            components.matter.pipe(this, 'Pipe_2', fLength, fDiameter);
            components.matter.pipe(this, 'Pipe_3', fLength, fDiameter);


            % Inlet and outlet branches
            matter.branch(this, this.toStores.KF_Electrolyzer_Store.toPhases.KF_Electrolyzer_Gas_Output, {'Pipe_1'}, 'Gas_Outlet', 'Gas_to_Regolith_Reactor');
            matter.branch(this, this.toStores.KF_Electrolyzer_Store.toPhases.KF_Electrolyzer_Solid_Output, {'Pipe_2'}, 'Solid_Outlet', 'Solid_to_K_Furnace');
            matter.branch(this, this.toStores.KF_Electrolyzer_Store.toPhases.KF_Electrolyzer_Input, {'Pipe_3'}, 'KF_Electrolyzer_Inlet', 'Inlet_to_KF_Electrolyzer');
        end

        function createSolverStructure(this)
            createSolverStructure@vsys(this);

            solver.matter.interval.branch(this.toBranches.Gas_to_Regolith_Reactor);
            solver.matter.residual.branch(this.toBranches.Solid_to_K_Furnace);
            solver.matter.manual.branch(this.toBranches.Inlet_to_KF_Electrolyzer);
            this.toBranches.Inlet_to_KF_Electrolyzer.oHandler.setFlowRate(-2.4e-3);

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
            this.connectIF('KF_Electrolyzer_Inlet',  sReactor_Inlet);
            this.connectIF('Gas_Outlet', sGas_Outlet);
            this.connectIF('Solid_Outlet', sSolid_Outlet);
        end
    end
end