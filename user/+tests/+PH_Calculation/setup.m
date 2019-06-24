classdef setup < simulation.infrastructure
    %SETUP This class is used to setup a simulation
    %   There should always be a setup file present for each project. It is
    %   used for the following:
    %   - instantiate the root object
    %   - determine which items are logged
    %   - set the simulation duration
    %   - provide methods for plotting the results
    
    properties
        % This class does not have any properties.
    end
    
    methods
        % Constructor function
        function this = setup(ptConfigParams, tSolverParams, ttMonitorConfig) % Constructor function
            % First we call the parent constructor and tell it the name of
            % this simulation we are creating.
            this@simulation.infrastructure('Test_PH_Calculation', ptConfigParams, tSolverParams, ttMonitorConfig);
            
            % Creating the 'Example' system as a child of the root system
            % of this simulation. 
            examples.PH_Calculation.systems.Example(this.oSimulationContainer, 'Example');
            
            % Setting the simulation duration to one hour. Time is always
            % in units of seconds in V-HAB.
            this.fSimTime = 10*3600;
            
        end
        
        % Logging function
        function configureMonitors(this)
            % To make the code more legible, we create a local variable for
            % the logger object.
            oLogger = this.toMonitors.oLogger;

            % Adding the tank temperatures to the log
            oLogger.addValue('Example:s:Tank_1:p:Water.toManips.substance.oChemicalReactions', 'fCurrentTotalPhosphate',                        'kg/m^3', 'Concentration Phosphate');
            oLogger.addValue('Example:s:Tank_1:p:Water.toManips.substance.oChemicalReactions', 'mfCurrentConcentrationAll(this.oMT.tiN2I.OHminus)',  'kg/m^3', 'Concentration OH-');
            oLogger.addValue('Example:s:Tank_1:p:Water.toManips.substance.oChemicalReactions', 'mfCurrentConcentrationAll(this.oMT.tiN2I.Naplus)',   'kg/m^3', 'Concentration Naplus');
            oLogger.addValue('Example:s:Tank_1:p:Water.toManips.substance.oChemicalReactions', 'fCurrentCalculatedPH',                          '-',     'PH');
            oLogger.addValue('Example:s:Tank_1:p:Water.toManips.substance.oChemicalReactions', 'fCurrentVolume',                                'm^3',   'Volume');
            
            oLogger.addVirtualValue('"Concentration Naplus" ./ "Concentration Phosphate"', '-', 'OH- to Phosphate');
        end
        
        % Plotting function
        function plot(this) 
            % First we get a handle to the plotter object associated with
            % this simulation.
            oPlotter = plot@simulation.infrastructure(this);
            
            tPlotOptions = struct('sAlternativeXAxisValue', '"OH- to Phosphate"', 'sXLabel', 'n(OH-)/n(H3PO4) in [-]');
            tPlotOptions.yLabel = 'PH in [-]';
            coPlots{1,1} = oPlotter.definePlot({'"PH"'}, 'Titration Curve', tPlotOptions);
            
            tPlotOptions = struct();
            coPlots{1,2} = oPlotter.definePlot({'"Concentration Phosphate"', '"Concentration Naplus"'}, 'Concentrations', tPlotOptions);
            coPlots{2,1} = oPlotter.definePlot({'"PH"'}, 'PH', tPlotOptions);
            
            oPlotter.defineFigure(coPlots, 'Plots');
            
            % Plotting all figures (in this case just one). 
            oPlotter.plot();
            
             %% Get Test Data:
             % Data is from "Allgemeine und Anorganische Chemie", 3rd
             % Edition, Michael Binnewies, Maik Finze, Manfred J�ckel, Peer
             % Schmidt, Helge Willner, Geoff Rayner-Canham page 262
            iFileID = fopen(strrep('+examples/+PH_Calculation/Titration Curve.csv','/',filesep), 'r');
            
            [FilePath,~,~,~] = fopen(iFileID);
            
            mfTestData = csvread(FilePath);
            
            oLogger = this.toMonitors.oLogger;
            
            for iVirtualLog = 1:length(oLogger.tVirtualValues)
                if strcmp(oLogger.tVirtualValues(iVirtualLog).sLabel, 'OH- to Phosphate')
                    calculationHandle = oLogger.tVirtualValues(iVirtualLog).calculationHandle;
                end
            end
            mfOHtoPhosphate = calculationHandle(oLogger.mfLog);
            mfOHtoPhosphate(isnan(mfOHtoPhosphate)) = [];
            
            for iLog = 1:length(oLogger.tLogValues)
                if strcmp(oLogger.tLogValues(iLog).sLabel, 'PH')
                    iPH = oLogger.tLogValues(iLog).iIndex;
                end
            end
            
            mfPH = oLogger.mfLog(:,iPH);
            mfPH(isnan(mfPH)) = [];
            
            % Plot overlay with test data:
            figure()
            plot(mfTestData(:,1), mfTestData(:,2));
            grid on
            xlabel('n(OH-)/n(H3PO4)');
            ylabel('PH in [-]');
            hold on
            plot(mfOHtoPhosphate, mfPH);
            legend('Literature', 'V-HAB')
            
            [afXDataUnique, ia, ~] = unique(mfTestData(:,1));
            afYDataUnique = mfTestData(ia,2);
            
            InterpolatedTestData = interp1(afXDataUnique, afYDataUnique, mfOHtoPhosphate);
            
            % There will be some nan values because the simulation has data
            % before the simulation data, these are removed here
            mfPH(isnan(InterpolatedTestData)) = [];
            %mfOHtoPhosphate(isnan(InterpolatedTestData)) = [];
            InterpolatedTestData(isnan(InterpolatedTestData)) = [];
            
            fMaxDiff  = max(abs(mfPH - InterpolatedTestData));
            fMinDiff  = min(abs(mfPH - InterpolatedTestData));
            fMeanDiff = mean(mfPH - InterpolatedTestData);
            rMeanPercentualError = 100 * mean((mfPH - InterpolatedTestData)./InterpolatedTestData);
            
            disp(['Maximum   Difference between Simulation and Test:     ', num2str(fMaxDiff), ''])
            disp(['Minimum   Difference between Simulation and Test:     ', num2str(fMinDiff), ''])
            disp(['Mean      Difference between Simulation and Test:     ', num2str(fMeanDiff), ''])
            disp(['Percent   Difference between Simulation and Test:     ', num2str(rMeanPercentualError), ' %'])
        end
        
    end
    
end

