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
            ASEN6116.project.components.Plasma_Reactor_P2P(this.toStores.Plasma_Reactor_Store, 'F2_P2P', this.toStores.Plasma_Reactor_Store.toPhases.Plasma_Reactor_Input, this.toStores.Plasma_Reactor_Store.toPhases.Plasma_Reactor_Gas_Output, 'F2');

            % Solid P2P
            ASEN6116.project.components.Plasma_Reactor_P2P(this.toStores.Plasma_Reactor_Store, 'Si_P2P', this.toStores.Plasma_Reactor_Store.toPhases.Plasma_Reactor_Input, this.toStores.Plasma_Reactor_Store.toPhases.Plasma_Reactor_Solid_Output, 'Si');

            % Pipes
            fLength     = 1;    % Pipe length in m
            fDiameter   = 0.01; % Pipe Diameter in m
            components.matter.pipe(this, 'Pipe_1', fLength, fDiameter);
            components.matter.pipe(this, 'Pipe_2', fLength, fDiameter);
            components.matter.pipe(this, 'Pipe_3', fLength, fDiameter);

            % Inlet and outlet branches
            matter.branch(this, this.toStores.Plasma_Reactor_Store.toPhases.Plasma_Reactor_Gas_Output, {'Pipe_1'}, 'Gas_Outlet', 'Gas_to_Regolith_Reactor');
            matter.branch(this, this.toStores.Plasma_Reactor_Store.toPhases.Plasma_Reactor_Solid_Output, {'Pipe_2'}, 'Solid_Outlet', 'Solid_to_Metal_Output');
            matter.branch(this, this.toStores.Plasma_Reactor_Store.toPhases.Plasma_Reactor_Input, {'Pipe_3'}, 'Plasma_Reactor_Inlets', 'Inlet_to_Plasma_Reactor');
        end

        function createSolverStructure(this)
            createSolverStructure@vsys(this);

            solver.matter_multibranch.iterative.branch(this.toBranches.Gas_to_Regolith_Reactor);
            solver.matter_multibranch.iterative.branch(this.toBranches.Solid_to_Metal_Output);
            solver.matter_multibranch.iterative.branch(this.toBranches.Inlet_to_Plasma_Reactor);
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
            this.connectIF('Plasma_Reactor_Inlets',  sReactor_Inlet);
            this.connectIF('Gas_Outlet', sGas_Outlet);
            this.connectIF('Solid_Outlet', sSolid_Outlet);
        end
    end
end