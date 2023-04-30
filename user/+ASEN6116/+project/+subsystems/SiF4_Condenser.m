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
            matter.phases.gas(this.toStores.SiF4_Condenser_Store, 'SiF4_Condenser_Input', struct('O2', 0.252, 'F2', 0.245, 'SiF4', 0.503), 0.25, 293);
            matter.phases.gas(this.toStores.SiF4_Condenser_Store, 'SiF4_Condenser_Gas_Output', struct('O2', 0.252, 'F2', 0.245), 0.25, 293);
            matter.phases.solid(this.toStores.SiF4_Condenser_Store, 'SiF4_Condenser_Solid_Output', struct('SiF4', 0.503), 293);

            % Gaseous P2Ps
            ASEN6116.project.components.General_P2P(this.toStores.SiF4_Condenser_Store, 'O2_P2P', this.toStores.SiF4_Condenser_Store.toPhases.SiF4_Condenser_Input, this.toStores.SiF4_Condenser_Store.toPhases.SiF4_Condenser_Gas_Output, 'O2');
            ASEN6116.project.components.General_P2P(this.toStores.SiF4_Condenser_Store, 'F2_P2P', this.toStores.SiF4_Condenser_Store.toPhases.SiF4_Condenser_Input, this.toStores.SiF4_Condenser_Store.toPhases.SiF4_Condenser_Gas_Output, 'F2');

            % Solid P2P
            ASEN6116.project.components.General_P2P(this.toStores.SiF4_Condenser_Store, 'SiF4_P2P', this.toStores.SiF4_Condenser_Store.toPhases.SiF4_Condenser_Input, this.toStores.SiF4_Condenser_Store.toPhases.SiF4_Condenser_Solid_Output, 'SiF4');

            % Gas inlet pipes and pump
            fLength     = 1;    % Pipe length in m
            fDiameter   = 0.01; % Pipe Diameter in m
            components.matter.pipe(this, 'Pipe_1', fLength, fDiameter);
            components.matter.pipe(this, 'Pipe_2', fLength, fDiameter);
            components.matter.pipe(this, 'Pipe_3', fLength, fDiameter);

            % Inlet and outlet branches
            matter.branch(this, this.toStores.SiF4_Condenser_Store.toPhases.SiF4_Condenser_Gas_Output, {'Pipe_1'}, 'Gas_Outlet', 'Gas_to_Fluorination_Reactor');
            matter.branch(this, this.toStores.SiF4_Condenser_Store.toPhases.SiF4_Condenser_Solid_Output, {'Pipe_2'}, 'Solid_Outlet', 'Solid_to_Plasma_Reactor');
            matter.branch(this, this.toStores.SiF4_Condenser_Store.toPhases.SiF4_Condenser_Input, {'Pipe_3'}, 'SiF4_Condenser_Inlets', 'Inlet_to_SiF4_Condenser');
        end

        function createSolverStructure(this)
            createSolverStructure@vsys(this);
%             solver.matter_multibranch.iterative.branch(this.toBranches.Gas_to_Fluorination_Reactor);
%             solver.matter_multibranch.iterative.branch(this.toBranches.Solid_to_Plasma_Reactor);
%             solver.matter_multibranch.iterative.branch(this.toBranches.Inlet_to_SiF4_Condenser);
            solver.matter.interval.branch(this.toBranches.Gas_to_Fluorination_Reactor);
            solver.matter.residual.branch(this.toBranches.Solid_to_Plasma_Reactor);
            solver.matter.manual.branch(this.toBranches.Inlet_to_SiF4_Condenser);
            this.toBranches.Inlet_to_SiF4_Condenser.oHandler.setFlowRate(-1.65e-3);

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
            this.connectIF('SiF4_Condenser_Inlets',  sCondenser_Inlet);
            this.connectIF('Gas_Outlet', sGas_Outlet);
            this.connectIF('Solid_Outlet', sSolid_Outlet);
        end
    end
end