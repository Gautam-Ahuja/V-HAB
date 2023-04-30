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
            this.fSimTime = 1800; % 30 mins in seconds
            this.bUseTime = true;
        end

        function configureMonitors(this)
            %% Logging
            oLogger = this.toMonitors.oLogger;

            oLogger.addValue('Habitat.toStores.SiF4_Solid_Output.toPhases.SiF4_Solid_Out', 'fMass', 'kg', 'Total Solid Input (SiF4)');
%             oLogger.addValue('Habitat.toStores.Plasma_Gas_Output.toPhases.Plasma_Gas_Out', 'fMass', 'kg', 'Total Gaseous Output (F2)');
            oLogger.addValue('Habitat.toStores.F2_Storage.toPhases.Feed_F2', 'fMass', 'kg', 'Total Gaseous Output (F2)');
            oLogger.addValue('Habitat.toStores.Plasma_Solid_Output.toPhases.Plasma_Solid_Out', 'fMass', 'kg', 'Total Solid Output (Si)');
            oLogger.addValue('Habitat.toStores.Plasma_Gas_Output.toPhases.Plasma_Gas_Out', 'fPressure', 'Pa', 'Total Output Pressure');
            
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

            coPlot1{1,1} = oPlotter.definePlot({'"Total Solid Input (SiF4)"'},'Plasma Reactor Mass Inputs');
            coPlot1{1,2} = oPlotter.definePlot({'"Total Gaseous Output (F2)"', '"Total Solid Output (Si)"'}, 'Plasma Reactor Mass Outputs');
            coPlot1{1,3} = oPlotter.definePlot({'"Total Output Pressure"'}, 'Plasma Reactor Pressures Outputs');
%             coPlot1{2,1} = oPlotter.definePlot({'"Regolith Gas Out"'}, 'Regolith Gas Out');
%             coPlot1{2,2} = oPlotter.definePlot({'"Regolith Solid Out"'}, 'Regolith Solid Out');
%             coPlot1{3,1} = oPlotter.definePlot({'"TiF4 Gas Out"'}, 'TiF4 Gas Out');
%             coPlot1{3,2} = oPlotter.definePlot({'"TiF4 Solid Out"'}, 'TiF4 Solid Out');
%             coPlot1{4,1} = oPlotter.definePlot({'"SiF4 Gas Out"'}, 'SiF4 Gas Out');
%             coPlot1{4,2} = oPlotter.definePlot({'"SiF4 Solid Out"'}, 'SiF4 Solid Out');
% 
%             coPlot2{1,1} = oPlotter.definePlot({'"Fluorination Gas Out"'},'Fluorination Gas Out');
%             coPlot2{1,2} = oPlotter.definePlot({'"Fluorination Solid Out"'}, 'Fluorination Solid Out');
%             coPlot2{2,1} = oPlotter.definePlot({'"K Furnace Liquid Out"'}, 'K Furnace Liquid Out');
%             coPlot2{2,2} = oPlotter.definePlot({'"K Furnace Solid Out"'}, 'K Furnace Solid Out');
%             coPlot2{3,1} = oPlotter.definePlot({'"Plasma Gas Out"'}, 'Plasma Gas Out');
%             coPlot2{3,2} = oPlotter.definePlot({'"Plasma Solid Out"'}, 'Plasma Solid Out');
%             coPlot2{4,1} = oPlotter.definePlot({'"Electrolyzer Gas Out"'}, 'Electrolyzer Gas Out');
%             coPlot2{4,2} = oPlotter.definePlot({'"Electrolyzer Solid Out"'}, 'Electrolyzer Solid Out');
% 
%             coPlot3{1,1} = oPlotter.definePlot({'"Total Regolith In"'}, 'Input Regolith Store Mass');
%             coPlot3{2,1} = oPlotter.definePlot({'"Fluorination Gas Out"'}, 'Output Oxygen Store Mass');

            % Define a single figure for I/O data
            oPlotter.defineFigure(coPlot1, 'Reactor Plot 1');
%             oPlotter.defineFigure(coPlot2, 'Reactor Plot 2');
%             oPlotter.defineFigure(coPlot3, 'Reactor Plot 3');

            oPlotter.plot();
        end
    end
end