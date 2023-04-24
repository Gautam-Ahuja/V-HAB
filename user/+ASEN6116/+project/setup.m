classdef setup < simulation.infrastructure
    properties

    end

    methods
        function this = setup(ptConfigParams, tSolverParams)
            ttMonitorConfig = struct();
            ttMonitorConfig.oTimeStepObserver.sClass = 'simulation.monitors.timestepObserver';
            ttMonitorConfig.oTimeStepObserver.cParams = { 0 , 100 };
            this@simulation.infrastructure('Habitat_System', ptConfigParams, tSolverParams, ttMonitorConfig);

            % Marrae composition
            trMarraeComposition.SiO2 = 0.474;
            trMarraeComposition.MgO = 0.143;
            trMarraeComposition.Al2O3 = 0.091;
            trMarraeComposition.FeO = 0.123;
            trMarraeComposition.TiO2 = 0.031;
            trMarraeComposition.CaO = 0.132;
            trMarraeComposition.Na2O = 0.006;
            this.oSimulationContainer.oMT.defineCompoundMass(this, 'Regolith', trMarraeComposition);

            ASEN6116.project.systems.Habitat(this.oSimulationContainer,'Habitat');

            %% Simulation length
            this.fSimTime = 120; % 1 day in seconds
            this.bUseTime = true;
        end

        function configureMonitors(this)
            %% Logging
            oLogger = this.toMonitors.oLogger;
            %oLogger.addValue('Habitat.toStores.O2_Storage.toPhases.O2_Output', 'fMass', 'kg', 'Total Oxygen Output');
            %oLogger.addValue('Habitat.toStores.Metal_Storage.toPhases.Metal_Output', 'fMass', 'kg', 'Total Metals Output');
            oLogger.addValue('Habitat.toStores.Regolith_Supply.toPhases.Feed_Regolith', 'fMass', 'kg', 'Total Regolith Input');
            oLogger.addValue('Habitat.toStores.F2_Storage.toPhases.Feed_F2', 'fMass', 'kg', 'F2 Gas In');
            oLogger.addValue('Habitat.toStores.Regolith_Gas_Output.toPhases.TiF4_Gas_In', 'fMass', 'kg', 'RR Gas Out');
            oLogger.addValue('Habitat.toStores.Regolith_Solid_Output.toPhases.Reg_Solid_Out', 'fMass', 'kg', 'RR Solid Out');
            oLogger.addValue('Habitat.toChildren.Regolith_Reactor.toStores.Regolith_Reactor_Store.toPhases.Regolith_Reactor_Input', 'fMass', 'kg','Reactor Input Phase');
            oLogger.addValue('Habitat.toChildren.Regolith_Reactor.toStores.Regolith_Reactor_Store.toPhases.Regolith_Reactor_Input', 'this.afMass(this.oMT.tiN2I.F2)', 'kg','Reactor Input Fluorine');
            oLogger.addValue('Habitat.toStores.TiF4_Gas_Output.toPhases.TiF4_Gas_Out', 'fMass', 'kg', 'TiF4 Gas Out');
            oLogger.addValue('Habitat.toStores.TiF4_Solid_Output.toPhases.TiF4_Solid_Out', 'fMass', 'kg', 'TiF4 Solid Out');
            oLogger.addValue('Habitat.toChildren.TiF4_Condenser.toStores.TiF4_Condenser_Store.toPhases.TiF4_Condenser_Input', 'fMass', 'kg', 'TiF4 Condenser Input Phase');
        end

        function plot(this)
            % Plotting the results
            % See http://www.mathworks.de/de/help/matlab/ref/plot.html for
            % further information
            close all % closes all currently open figures

            % Tries to load stored data from the hard drive if that option
            % was activated (see ttMonitorConfig). Otherwise it only
            % displays that no data was found
            try
                this.toMonitors.oLogger.readDataFromMat;
            catch
                disp('no data outputted yet')
            end

            %% Define plots
            % Defines the plotter object
            oPlotter = plot@simulation.infrastructure(this);

            % Define major I/O plots
            %coPlot{1,1} = oPlotter.definePlot({'"Total Oxygen Output"'},'Total Oxygen Output');
            %coPlot{2,1} = oPlotter.definePlot({'"Total Metals Output"'},'Total Metals Output');
            coPlot{1,1} = oPlotter.definePlot({'"Total Regolith Input"'},'Total Regolith Input');
            coPlot{1,2} = oPlotter.definePlot({'"F2 Gas In"'}, 'F2 Gas In');
            coPlot{2,1} = oPlotter.definePlot({'"RR Gas Out"'}, 'RR Gas Out');
            coPlot{2,2} = oPlotter.definePlot({'"RR Solid Out"'}, 'RR Solid Out');
            coPlot{3,1} = oPlotter.definePlot({'"Reactor Input Phase"'}, 'Reactor Input Phase');
            coPlot{3,2} = oPlotter.definePlot({'"Reactor Input Fluorine"'}, 'Reactor Input Fluorine');
            coPlot{4,1} = oPlotter.definePlot({'"TiF4 Gas Out"'}, 'TiF4 Gas Out');
            coPlot{4,2} = oPlotter.definePlot({'"TiF4 Condenser Input Phase"'}, 'TiF4 Condenser Input Phase');


            % Define a single figure for I/O data
            oPlotter.defineFigure(coPlot,  'Regolith Reactor Major I/Os');

            oPlotter.plot();
        end
    end
end