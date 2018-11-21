classdef setup < simulation.infrastructure
    %SETUP This class is used to setup a simulation
    %   There should always be a setup file present for each project. It is
    %   used for the following:
    %   - instantiate the root object
    %   - register branches to their appropriate solvers
    %   - determine which items are logged
    %   - set the simulation duration
    %   - provide methods for plotting the results
    
    properties
    end
    
    methods
        function this = setup(ptConfigParams, tSolverParams) % Constructor function
            
            % Possible to change the constructor paths and params for the
            % monitors
            ttMonitorConfig = struct();
            
            this@simulation.infrastructure('Example_Condensing_Heat_Exchanger', ptConfigParams, tSolverParams, ttMonitorConfig);
            
            % Creating the root object
            examples.condensing_heat_exchanger.systems.Example(this.oSimulationContainer, 'Example');

            %% Simulation length
            % Stop when specific time in simulation is reached or after 
            % specific amount of ticks (bUseTime true/false).
            this.fSimTime = 3600 * 1; % In seconds
            this.bUseTime = true;
        end
        
        function configureMonitors(this)
            
            %% Logging
            oLog = this.toMonitors.oLogger;
            
            oLog.addValue('Example', 'toProcsF2F.CondensingHeatExchanger_1.fHeatFlow', 'W', 'Heat Flow Air');
            oLog.addValue('Example', 'toProcsF2F.CondensingHeatExchanger_2.fHeatFlow', 'W', 'Heat Flow Coolant');
            
            oLog.addValue('Example:s:CHX.toProcsP2P.CondensingHX', 'fFlowRate', 'kg/s', 'Condensate Flow Rate');
            
            oLog.addValue('Example:s:Tank_1.toPhases.Air_1', 'rRelHumidity', '-', 'Relative Humidity Tank 1');
            oLog.addValue('Example:s:Tank_2.toPhases.Air_2', 'rRelHumidity', '-', 'Relative Humidity Tank 2');
            
            oLog.addValue('Example:s:Tank_1.toPhases.Air_1',            'fTemperature', 'K', 'Temperature Air Tank 1');
            oLog.addValue('Example:s:Tank_2.toPhases.Air_2',            'fTemperature', 'K', 'Temperature Air Tank 2');
            oLog.addValue('Example:s:Tank_3.toPhases.Coolant_Phase1',   'fTemperature', 'K', 'Temperature Coolant Tank 3');
            oLog.addValue('Example:s:Tank_4.toPhases.Coolant_Phase2',   'fTemperature', 'K', 'Temperature Coolant Tank 4');
        end
        
        function plot(this) % Plotting the results
            % See http://www.mathworks.de/de/help/matlab/ref/plot.html for
            % further information
            close all
            
            oPlotter = plot@simulation.infrastructure(this);
            
            % Define a single plot
            coPlot{1,1} = oPlotter.definePlot({'"Heat Flow Air"', '"Heat Flow Coolant"'}, 'Heat Flows');
            coPlot{1,2} = oPlotter.definePlot({'"Temperature Air Tank 1"','"Temperature Air Tank 2"', '"Temperature Coolant Tank 3"', '"Temperature Coolant Tank 4"'}, 'Temperatures');
            coPlot{2,1} = oPlotter.definePlot({'"Relative Humidity Tank 1"','"Relative Humidity Tank 2"'}, 'Relative Humidity');
            coPlot{2,2} = oPlotter.definePlot({'"Condensate Flow Rate"'}, 'Condensate Flowrate');

            % Define a single figure
            oPlotter.defineFigure(coPlot,  'Condensing Heat Exchanger');
            
            oPlotter.plot();
        end
    end
end

