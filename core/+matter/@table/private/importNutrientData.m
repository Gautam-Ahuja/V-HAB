function importNutrientData(this)
% this function reads nutrient data that was downloaded from the US Food
% Composition Database (https://ndb.nal.usda.gov/ndb/search/list) if you
% want to add additional food to V-HAB search for it in the database,
% download the corresponding CSV and add it to the folder
% core/+matter/+data/+NutrientData
% 
% Unfortuntly the complete structure of the above mentioned database was
% changed and therefore it is currently not possible to add new foods this
% way. It is possible to access data using the descritpion provided here:
% https://fdc.nal.usda.gov/api-guide.html and for our purposes the demo API
% key would be sufficient. However, since the whole format of the received
% data changes, a completly new import script is required to import the
% data!
%
% The skript is able to import both the base and the full data file,
% however it is recommended to import the full data file. In the base file
% some parts of the composition are neglected, resulting in the mass not
% summing up to 100 g (or after the import 1 kg). For the full import the
% mass balance is correct, however some parts are considered in multiple
% quantities. A correct mass balance can be achieved by summing water,
% protein, fat, ash and carbohydrates and neglecting everything else
%
% For data that is provided by the manufacturer, errors are likely because
% they rarely report substances that sum up to 1 in their mass composition!
    
    % get the file names for the available nutrient data
    csFiles = dir(strrep('core/+matter/+data/+NutrientData','/',filesep));
    csFiles = {csFiles.name};
    
    % remove non csv files
    cfCSV = regexp(csFiles, '.csv');
    mbCSV = true(1, length(cfCSV));
    for iFile = 1:length(cfCSV)
        if isempty(cfCSV{iFile})
            mbCSV(iFile) = false;
        end
    end
    csFiles = csFiles(mbCSV);
    
    % To convert the units in which the database provides information into
    % SI units we create a conversion struct:
    tConversion.g       = 1e-3;
    tConversion.mg      = 1e-6;
    tConversion.microg  = 1e-9;
    tConversion.kcal    = 4184;
    tConversion.kJ      = 1000;
    tConversion.IU      = 1;
    
    ttxImportNutrientData = struct();
    
    % Add lines with the unique part of the Nutrient Data for: row from the
    % downloaded CSV file and provide a custom name if you want custom food
    % names
    csCustomFoodNames           = {'Beans, snap'; 'SnapBeans'};
    csCustomFoodNames(:,end+1)  = {'Onions, young green'; 'GreenOnions'};
    csCustomFoodNames(:,end+1)  = {'ORGANIC WHOLE GROUND TIGERNUT'; 'Chufa'};
    
    % Renamings that are necessary to provide consistency to the plant
    % model
    csCustomFoodNames(:,end+1)  = {'Beans, kidney'; 'Drybean'};
    csCustomFoodNames(:,end+1)  = {'Potatoes';      'Whitepotato'};
    csCustomFoodNames(:,end+1)  = {'Soybeans';      'Soybean'};
    csCustomFoodNames(:,end+1)  = {'Tomatoes';      'Tomato'};
    csCustomFoodNames(:,end+1)  = {'Peanuts';       'Peanut'};
    csCustomFoodNames(:,end+1)  = {'Wild rice';     'Rice'};
    csCustomFoodNames(:,end+1)  = {'Sweet potato';  'Sweetpotato'};
    
    % now loop through the files
    for iFile = 1:length(csFiles)
        %% Open File and load the data
        iFileID = fopen(strrep(['core/+matter/+data/+NutrientData/', csFiles{iFile}],'/',filesep), 'r');
        
        % This is a cell array of cells, so we 'unpack' one level to get the
        % actual string.
        csImport = textscan(iFileID, '%s', 'Delimiter', '\n');
        csImport = csImport{1};
        
        % Now we get the type of food for which this data file contains
        % information
        acData = cell(length(csImport),1);
        iHeaderRows = [];
        iEndRow = [];
        for iRow = 1:length(csImport)
            if ~isempty(regexp(csImport{iRow}, 'Nutrient data for:', 'once'))
                sInitialSplitString = regexp(csImport{iRow}, ': ','split');
                
                bCustomFoodName = false;
                for iCustomFoodName = 1:length(csCustomFoodNames)
                    if ~isempty(regexp(sInitialSplitString{2}, csCustomFoodNames{1,iCustomFoodName}, 'once'))
                        bCustomFoodName = true;
                        sFoodName = csCustomFoodNames{2,iCustomFoodName};
                    end
                end
                if ~bCustomFoodName
                    splitStr = regexp(sInitialSplitString{2}, ',','split');
                    sFoodName = splitStr{1};
                    sFoodName = tools.normalizePath(sFoodName);
                    if isfield(ttxImportNutrientData, sFoodName)
                        sFoodName = tools.normalizePath(sInitialSplitString{2});
                    end
                end
            elseif ~isempty(regexp(csImport{iRow}, 'per 100 g', 'once'))
                sColumnString = regexp(csImport{iRow}, ',','split');
                for iColumn = 1:length(sColumnString)
                    if ~isempty(regexp(sColumnString{iColumn}, 'per 100 g', 'once'))
                        iDataColumn = iColumn;
                    end
                end
            elseif ~isempty(regexp(csImport{iRow}, 'Proximates', 'once'))
                iHeaderRows = iRow;
            end
            
            if ~isempty(iHeaderRows) && iRow > iHeaderRows
                cData = cell(1,0);
                % Unfortunatly the data is not exactly formatted
                % identically from the database, sometimes there are empty
                % lines before sources, sometimes there is the term sources
                % of data and sometimes the sources just start (1,"
                % identifies this case)
                if ~isempty(regexp(csImport{iRow}, '1,"', 'once')) || ~isempty(regexp(csImport{iRow}, 'Sources of Data', 'once')) || isempty(csImport{iRow})
                    iEndRow = iRow - 1;
                    break
                end
                cTempData = regexp(csImport{iRow}, '"','split');
                if isempty(cTempData{1})
                    iEntry = 2;
                else
                    iEntry = 1;
                end
                cData{1, end+1} = cTempData{iEntry}; %#ok<AGROW>
                if length(cTempData) > 2
                    cTempData = regexp(cTempData{3}, ',','split');
                    cData(1, end+1:end+length(cTempData)-1) = cTempData(2:end);
                end
                acData{iRow} = cData;
            end
        end
        
        % Close the text file.
        fclose(iFileID);
        
        %% create a easy to access and read struct array from the data
        ttxImportNutrientData.(sFoodName) = struct();
        
        if isempty(iEndRow)
            iEndRow = length(acData);
        end
        sSubHeader = [];
        for iRow = (iHeaderRows + 1):iEndRow
            % First get the name of the row
            sRowName = acData{iRow};
            sRowName = sRowName{1};
            sRowName = regexprep(sRowName, '"', '');
            sRowName = tools.normalizePath(sRowName);
            if strcmp(sRowName, 'Footnotes')
                break
            end
            
            cData = acData{iRow};
            % Then check if a new "subheader" line is present (e.g.
            % Minerals or Vitamins)
            if length(cData) == 1
                sSubHeader = sRowName;
            else
                % since the data is given with different units, we have to
                % convert them to standard SI units to be compatible with
                % V-HAB
                sUnit = cData{2};
                
                if strcmp(sUnit, '�g')
                    sUnit = 'microg';
                end
                
                % Times 10 because the data is per 100 g and we want it to
                % be per kg
                fData = tConversion.(sUnit) * 10 * str2double(cData{iDataColumn});
                
                if strcmp(sUnit, 'IU')
                    sUnitHeader = 'IU';
                elseif strcmp(sUnit, 'kcal') || strcmp(sUnit, 'kJ')
                    sUnitHeader = 'Energy';
                else
                    sUnitHeader = 'Mass';
                end
                
                if ~isfield(ttxImportNutrientData.(sFoodName), sUnitHeader)
                    ttxImportNutrientData.(sFoodName).(sUnitHeader) = struct();
                end
                
                if isempty(sSubHeader)
                    ttxImportNutrientData.(sFoodName).(sUnitHeader).(sRowName) = fData;
                else
                    ttxImportNutrientData.(sFoodName).(sUnitHeader).(sSubHeader).(sRowName) = fData;
                end
            end
        end
    end
    
    % add a general entry for food as it is assumed in the BVAD and HDIH:
    ttxImportNutrientData.Food.Mass.Water                       = 0.4636; % 0.7 kg / 1.51 see table 3-33 in BVAD
    % The following values are based on the 12.59 MJ of energy content
    % mentioned in the BVAD food and the general percentages metioned in
    % HDIH Marcunutrient Guidelines for Spaceflight (Table 7.2-2 and 7.2-3)
    ttxImportNutrientData.Food.Mass.Protein                     = ((0.175 * 12.59 * 10^6) / (this.ttxMatter.C4H5ON.fNutritionalEnergy)) / 1.51;
    ttxImportNutrientData.Food.Mass.Carbohydrate__by_difference	= ((0.525 * 12.59 * 10^6) / (this.ttxMatter.C6H12O6.fNutritionalEnergy)) / 1.51;
    ttxImportNutrientData.Food.Mass.Total_lipid__fat_           = ((0.3 * 12.59 * 10^6)   / (this.ttxMatter.C16H32O2.fNutritionalEnergy)) / 1.51;
    ttxImportNutrientData.Food.Mass.Ash                         =  1 - (ttxImportNutrientData.Food.Mass.Water + ttxImportNutrientData.Food.Mass.Protein + ttxImportNutrientData.Food.Mass.Carbohydrate__by_difference + ttxImportNutrientData.Food.Mass.Total_lipid__fat_ );
    ttxImportNutrientData.Food.Mass.Fiber__total_dietary        = (12e-3 * 4187e3 / 12.59e6);
    ttxImportNutrientData.Food.Mass.Minerals.Calcium__Ca        = 2e-3      / 1.51;
    ttxImportNutrientData.Food.Mass.Minerals.Phosphorus__P     	= 0.7e-3    / 1.51;
    ttxImportNutrientData.Food.Mass.Minerals.Magnesmium__Mg   	= 0.42e-3   / 1.51;
    ttxImportNutrientData.Food.Mass.Minerals.Sodium__Na        	= 1.9e-3    / 1.51;
    ttxImportNutrientData.Food.Mass.Minerals.Potassium__K       = 4.7e-3    / 1.51;
    ttxImportNutrientData.Food.Mass.Minerals.Iron__Fe           = 9e-6      / 1.51;
    ttxImportNutrientData.Food.Mass.Minerals.Copper__Cu         = 4.65e-6   / 1.51;
    ttxImportNutrientData.Food.Mass.Minerals.Manganese__Mn     	= 2.3e-6    / 1.51;
    ttxImportNutrientData.Food.Mass.Minerals.Zinc__Zn           = 11e-6     / 1.51;
    ttxImportNutrientData.Food.Mass.Minerals.Selenium__Se     	= 227.5e-9  / 1.51;
    
    ttxImportNutrientData.Food.Mass.Vitamins.Vitamin_A          = 800e-9    / 1.51;
    ttxImportNutrientData.Food.Mass.Vitamins.Vitamin_D          = 25e-9    	/ 1.51;
    ttxImportNutrientData.Food.Mass.Vitamins.Vitamin_K          = 120e-9   	/ 1.51;
    ttxImportNutrientData.Food.Mass.Vitamins.Vitamin_E          = 15e-6    	/ 1.51;
    ttxImportNutrientData.Food.Mass.Vitamins.Vitamin_C          = 90e-6     / 1.51;
    ttxImportNutrientData.Food.Mass.Vitamins.Vitamin_B_12       = 2.4e-9    / 1.51;
    ttxImportNutrientData.Food.Mass.Vitamins.Vitamin_B_6        = 1.7e-6    / 1.51;
    ttxImportNutrientData.Food.Mass.Vitamins.Thiamin            = 1.2e-9 * 0.33727    / 1.51; % value is given in micromol, therefore multiplied with molar mass
    ttxImportNutrientData.Food.Mass.Vitamins.Riboflavin         = 1.3e-6    / 1.51;
    ttxImportNutrientData.Food.Mass.Vitamins.Folate             = 400e-9    / 1.51;
    ttxImportNutrientData.Food.Mass.Vitamins.Niacin             = 16e-6     / 1.51;
    ttxImportNutrientData.Food.Mass.Vitamins.Biotin             = 30e-9     / 1.51;
    ttxImportNutrientData.Food.Mass.Vitamins.Pantothenic_acid  	= 30e-6     / 1.51;
    
    % Add chlorella as food, since the food data central only provides a
    % branded chlorella food, the values from DOI: 10.1016/j.actaastro.2014.04.023
    % "Physicochemical and biological technologies for future exploration
    % missions", S. Belz et al 2014 are used here:
    ttxImportNutrientData.Chlorella.Mass.Water                       = 0;
    ttxImportNutrientData.Chlorella.Mass.Protein                     = 0.240;
    ttxImportNutrientData.Chlorella.Mass.Carbohydrate__by_difference = 0.570;
    ttxImportNutrientData.Chlorella.Mass.Total_lipid__fat_           = 0.190;
    ttxImportNutrientData.Chlorella.Mass.Ash                         =  1 - (ttxImportNutrientData.Food.Mass.Water + ttxImportNutrientData.Food.Mass.Protein + ttxImportNutrientData.Food.Mass.Carbohydrate__by_difference + ttxImportNutrientData.Food.Mass.Total_lipid__fat_ );
    ttxImportNutrientData.Chlorella.Mass.Fiber__total_dietary        = 0;
    ttxImportNutrientData.Chlorella.Mass.Minerals.Calcium__Ca        = 0;
    ttxImportNutrientData.Chlorella.Mass.Minerals.Phosphorus__P      = 0;
    ttxImportNutrientData.Chlorella.Mass.Minerals.Magnesmium__Mg   	 = 0;
    ttxImportNutrientData.Chlorella.Mass.Minerals.Sodium__Na         = 0;
    ttxImportNutrientData.Chlorella.Mass.Minerals.Potassium__K       = 0;
    ttxImportNutrientData.Chlorella.Mass.Minerals.Iron__Fe           = 0;
    ttxImportNutrientData.Chlorella.Mass.Minerals.Copper__Cu         = 0;
    ttxImportNutrientData.Chlorella.Mass.Minerals.Manganese__Mn      = 0;
    ttxImportNutrientData.Chlorella.Mass.Minerals.Zinc__Zn           = 0;
    ttxImportNutrientData.Chlorella.Mass.Minerals.Selenium__Se     	 = 0;
    
    ttxImportNutrientData.Chlorella.Mass.Vitamins.Vitamin_A          = 0;
    ttxImportNutrientData.Chlorella.Mass.Vitamins.Vitamin_D          = 0;
    ttxImportNutrientData.Chlorella.Mass.Vitamins.Vitamin_K          = 0;
    ttxImportNutrientData.Chlorella.Mass.Vitamins.Vitamin_E          = 0;
    ttxImportNutrientData.Chlorella.Mass.Vitamins.Vitamin_C          = 0;
    ttxImportNutrientData.Chlorella.Mass.Vitamins.Vitamin_B_12       = 0;
    ttxImportNutrientData.Chlorella.Mass.Vitamins.Vitamin_B_6        = 0;
    ttxImportNutrientData.Chlorella.Mass.Vitamins.Thiamin            = 0;
    ttxImportNutrientData.Chlorella.Mass.Vitamins.Riboflavin         = 0;
    ttxImportNutrientData.Chlorella.Mass.Vitamins.Folate             = 0;
    ttxImportNutrientData.Chlorella.Mass.Vitamins.Niacin             = 0;
    ttxImportNutrientData.Chlorella.Mass.Vitamins.Biotin             = 0;
    ttxImportNutrientData.Chlorella.Mass.Vitamins.Pantothenic_acid   = 0;
    
    this.ttxNutrientData = ttxImportNutrientData;
    
    %% Create Compound Matter Data entries based on imported nutrient data!
    this.csEdibleSubstances = fieldnames(ttxImportNutrientData);
    
    % loop over all edible substances
    for iJ = 1:length(this.csEdibleSubstances)
        % Currently food is simplified to only consist of Water, Carbohydrates,
        % Proteins, Fats and Ash (basically the rest e.g. Minerals). From
        % the database entries the values:
        % Water, Carbohydrate__by_difference, Protein, Total_lipid__fat_
        % and Ash sum up to exactly 1! Fibers seem to be included in the
        % Carbohydrate__by_difference value, therefore we subtract them
        % here and add them individually
        trBaseComposition           = struct();
        
        trBaseComposition.H2O       = ttxImportNutrientData.(this.csEdibleSubstances{iJ}).Mass.Water;
        trBaseComposition.C6H12O6   = ttxImportNutrientData.(this.csEdibleSubstances{iJ}).Mass.Carbohydrate__by_difference - ttxImportNutrientData.(this.csEdibleSubstances{iJ}).Mass.Fiber__total_dietary;
        trBaseComposition.C3H7NO2   = ttxImportNutrientData.(this.csEdibleSubstances{iJ}).Mass.Protein;
        trBaseComposition.C51H98O6  = ttxImportNutrientData.(this.csEdibleSubstances{iJ}).Mass.Total_lipid__fat_;
        
        % unfortunatly it is not certain that all mineral fields are always
        % present and contain zero if they are not. Therefore, to only add
        % which minerals are present we first check which are there
        csMinerals = fieldnames(ttxImportNutrientData.(this.csEdibleSubstances{iJ}).Mass.Minerals);
        % now we have to derive the V-HAB name for these minerals and add
        % them to the struct
        for iMineral = 1:length(csMinerals)
            csSplitString = strsplit(csMinerals{iMineral}, '__');
            % the second part of the split string is the element of the
            % mineral and can be used by V-HAB
            trBaseComposition.(csSplitString{2}) = ttxImportNutrientData.(this.csEdibleSubstances{iJ}).Mass.Minerals.(csMinerals{iMineral});
        end
        
        % unfortunatly it is not certain that all vitamin fields are always
        % present and contain zero if they are not. Therefore, to only add
        % which minerals are present we first check which are there
        csVitamins = fieldnames(ttxImportNutrientData.(this.csEdibleSubstances{iJ}).Mass.Vitamins);
        % now we have to derive the V-HAB name for these minerals and add
        % them to the struct
        for iVitamin = 1:length(csVitamins)
            % since a folate total value exists, we skip the partial folate
            % values
            if strcmp(csVitamins{iVitamin}, 'Folate__food') || strcmp(csVitamins{iVitamin}, 'Folate__DFE')
                continue
            end
            csSplitString = strsplit(csVitamins{iVitamin}, '__');
            % the second part of the split string is the element of the
            % mineral and can be used by V-HAB
            this.ttxNutrientData.(this.csEdibleSubstances{iJ}).trVitaminMass.(csSplitString{1}) = ttxImportNutrientData.(this.csEdibleSubstances{iJ}).Mass.Vitamins.(csVitamins{iMineral});
        end
        
        trBaseComposition.DietaryFiber	= ttxImportNutrientData.(this.csEdibleSubstances{iJ}).Mass.Fiber__total_dietary;
       
        csFields = fieldnames(trBaseComposition);
        rTotal = 0;
        for iField = 1:length(csFields)
            rTotal = rTotal + trBaseComposition.(csFields{iField});
        end
        trBaseComposition.C	= 1 - rTotal;
        if trBaseComposition.C < 0
            if trBaseComposition.C < -0.05
                error(['in the food composition of food stuff ', this.csEdibleSubstances{iJ}, ' an error occured'])
            else
                trBaseComposition.H2O   = trBaseComposition.H2O + trBaseComposition.C;
                trBaseComposition.C     = 0;
            end
        end
        % Now we define a compound mass in the matter table with the
        % corresponding composition. Note that the base composition can be
        % adjusted within a simulation, but for defining matter of this
        % type, the base composition is used
        this.defineCompoundMass(this, this.csEdibleSubstances{iJ}, trBaseComposition, true);
        
    end
end