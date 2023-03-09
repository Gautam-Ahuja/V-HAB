classdef setup < simulation.infrastructure
    properties

    end

    methods
        function this = setup(ptConfigParams, tSolverParams)
            ttMonitorConfig = struct();
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
            this.fSimTime = 86400; % 1 day in seconds
            this.bUseTime = true;
        end

        function configureMonitors(this)
            %% Logging
            oLogger = this.toMonitors.oLogger;
            oLogger.addValue('Habitat.toStores.Cabin.toPhases.CabinAir', 'fPressure', 'Pa', 'Total Cabin Pressure');
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

            % Define a single plot
            oPlot{1} = oPlotter.definePlot({'"Total Cabin Pressure"'},'Total Cabin Pressure');

            % Define a single figure
            oPlotter.defineFigure(oPlot,  'Total Cabin Pressure');

            oPlotter.plot();
        end
    end
end