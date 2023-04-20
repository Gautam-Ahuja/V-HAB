classdef Fluorination_Reactor_Manip < matter.manips.substance.stationary & event.source
    methods
        function this = Fluorination_Reactor_Manip(sName, oPhase)
            this@matter.manips.substance.stationary(sName, oPhase);
 
        end
    end
     
    methods (Access = protected)
        function update(this)
            [afFlowRate, mrPartials] = this.getInFlows();
            if isempty(afFlowRate)
                afFlowRateIn = zeros(1, this.oPhase.oMT.iSubstances);
            else
                afFlowRateIn = sum(afFlowRate .* mrPartials(1,:),1);
            end

            % Set output flows
            afPartialFlowRates = zeros(1, this.oPhase.oMT.iSubstances);
            fRemainingFluorine = afFlowRateIn(this.oMT.tiN2I.F2);
            fO2Production = afFlowRateIn(this.oMT.tiN2I.O2);

            if fRemainingFluorine - (this.oMT.afMolarMass(this.oMT.tiN2I.F2)/this.oMT.afMolarMass(this.oMT.tiN2I.Na2O)*afFlowRateIn(this.oMT.tiN2I.Na2O)) <= 0
                % Incomplete reaction of Na2O fully consumes fluorine
                fNaFProduction = 2*this.oMT.afMolarMass(this.oMT.tiN2I.NaF)/this.oMT.afMolarMass(this.oMT.tiN2I.F2)*fRemainingFluorine;
                fO2Production = fO2Production + 0.5*this.oMT.afMolarMass(this.oMT.tiN2I.O2)/this.oMT.afMolarMass(this.oMT.tiN2I.F2)*fRemainingFluorine;
                afPartialFlowRates(this.oMT.tiN2I.NaF) = fNaFProduction;
                afPartialFlowRates(this.oMT.tiN2I.O2) = fO2Production;
                afPartialFlowRates(this.oMT.tiN2I.CaO) = afFlowRateIn(this.oMT.tiN2I.CaO);
                afPartialFlowRates(this.oMT.tiN2I.MgO) = afFlowRateIn(this.oMT.tiN2I.MgO);
                afPartialFlowRates(this.oMT.tiN2I.Al) = afFlowRateIn(this.oMT.tiN2I.Al);
                afPartialFlowRates(this.oMT.tiN2I.Ti) = afFlowRateIn(this.oMT.tiN2I.Ti);
                afPartialFlowRates(this.oMT.tiN2I.Fe) = afFlowRateIn(this.oMT.tiN2I.Fe);
                afPartialFlowRates(this.oMT.tiN2I.F2) = -afFlowRateIn(this.oMT.tiN2I.F2);
                afPartialFlowRates(this.oMT.tiN2I.Na2O) = -sum(afPartialFlowRates);
                update@matter.manips.substance.stationary(this, afPartialFlowRates);
                this.trigger('Fluorination_Reactor_Manip_Update');
                return;
            else
                % Complete reaction of Na2O
                fNaFProduction = 2*this.oMT.afMolarMass(this.oMT.tiN2I.NaF)/this.oMT.afMolarMass(this.oMT.tiN2I.Na2O)*afFlowRateIn(this.oMT.tiN2I.Na2O);
                fO2Production = fO2Production + 0.5*this.oMT.afMolarMass(this.oMT.tiN2I.O2)/this.oMT.afMolarMass(this.oMT.tiN2I.Na2O)*afFlowRateIn(this.oMT.tiN2I.Na2O);
                fNa2OProduction = -afFlowRateIn(this.oMT.tiN2I.Na2O);
                afPartialFlowRates(this.oMT.tiN2I.NaF) = fNaFProduction;
                afPartialFlowRates(this.oMT.tiN2I.Na2O) = fNa2OProduction;
                fRemainingFluorine = fRemainingFluorine - this.oMT.afMolarMass(this.oMT.tiN2I.F2)/this.oMT.afMolarMass(this.oMT.tiN2I.Na2O).afFlowRateIn(this.oMT.tiN2I.Na2O);
            end

            if fRemainingFluorine - (this.oMT.afMolarMass(this.oMT.tiN2I.F2)/this.oMT.afMolarMass(this.oMT.tiN2I.CaO)*afFlowRateIn(this.oMT.tiN2I.CaO)) <= 0
                % Incomplete reaction of CaO fully consumes fluorine
                fCaF2Production = this.oMT.afMolarMass(this.oMT.tiN2I.CaF2)/this.oMT.afMolarMass(this.oMT.tiN2I.F2)*fRemainingFluorine;
                fO2Production = fO2Production + 0.5*this.oMT.afMolarMass(this.oMT.tiN2I.O2)/this.oMT.afMolarMass(this.oMT.tiN2I.F2)*fRemainingFluorine;
                afPartialFlowRates(this.oMT.tiN2I.CaF2) = fCaF2Production;
                afPartialFlowRates(this.oMT.tiN2I.O2) = fO2Production;
                afPartialFlowRates(this.oMT.tiN2I.MgO) = afFlowRateIn(this.oMT.tiN2I.MgO);
                afPartialFlowRates(this.oMT.tiN2I.Al) = afFlowRateIn(this.oMT.tiN2I.Al);
                afPartialFlowRates(this.oMT.tiN2I.Ti) = afFlowRateIn(this.oMT.tiN2I.Ti);
                afPartialFlowRates(this.oMT.tiN2I.Fe) = afFlowRateIn(this.oMT.tiN2I.Fe);
                afPartialFlowRates(this.oMT.tiN2I.F2) = -afFlowRateIn(this.oMT.tiN2I.F2);
                afPartialFlowRates(this.oMT.tiN2I.CaO) = -sum(afPartialFlowRates);
                update@matter.manips.substance.stationary(this, afPartialFlowRates);
                this.trigger('Fluorination_Reactor_Manip_Update');
                return;
            else
                % Complete reaction of CaO
                fCaF2Production = this.oMT.afMolarMass(this.oMT.tiN2I.CaF2)/this.oMT.afMolarMass(this.oMT.tiN2I.CaO)*afFlowRateIn(this.oMT.tiN2I.CaO);
                fO2Production = fO2Production + 0.5*this.oMT.afMolarMass(this.oMT.tiN2I.O2)/this.oMT.afMolarMass(this.oMT.tiN2I.CaO)*afFlowRateIn(this.oMT.tiN2I.CaO);
                fCaOProduction = -afFlowRateIn(this.oMT.tiN2I.CaO);
                afPartialFlowRates(this.oMT.tiN2I.CaF2) = fCaF2Production;
                afPartialFlowRates(this.oMT.tiN2I.CaO) = fCaOProduction;
                fRemainingFluorine = fRemainingFluorine - this.oMT.afMolarMass(this.oMT.tiN2I.F2)/this.oMT.afMolarMass(this.oMT.tiN2I.CaO).afFlowRateIn(this.oMT.tiN2I.CaO);
            end

            if fRemainingFluorine - (this.oMT.afMolarMass(this.oMT.tiN2I.F2)/this.oMT.afMolarMass(this.oMT.tiN2I.MgO)*afFlowRateIn(this.oMT.tiN2I.MgO)) <= 0
                % Incomplete reaction of MgO fully consumes fluorine
                fMgF2Production = this.oMT.afMolarMass(this.oMT.tiN2I.MgF2)/this.oMT.afMolarMass(this.oMT.tiN2I.F2)*fRemainingFluorine;
                fO2Production = fO2Production + 0.5*this.oMT.afMolarMass(this.oMT.tiN2I.O2)/this.oMT.afMolarMass(this.oMT.tiN2I.F2)*fRemainingFluorine;
                afPartialFlowRates(this.oMT.tiN2I.MgF2) = fMgF2Production;
                afPartialFlowRates(this.oMT.tiN2I.O2) = fO2Production;
                afPartialFlowRates(this.oMT.tiN2I.Al) = afFlowRateIn(this.oMT.tiN2I.Al);
                afPartialFlowRates(this.oMT.tiN2I.Ti) = afFlowRateIn(this.oMT.tiN2I.Ti);
                afPartialFlowRates(this.oMT.tiN2I.Fe) = afFlowRateIn(this.oMT.tiN2I.Fe);
                afPartialFlowRates(this.oMT.tiN2I.F2) = -afFlowRateIn(this.oMT.tiN2I.F2);
                afPartialFlowRates(this.oMT.tiN2I.MgO) = -sum(afPartialFlowRates);
                update@matter.manips.substance.stationary(this, afPartialFlowRates);
                this.trigger('Fluorination_Reactor_Manip_Update');
                return;
            else
                % Complete reaction of MgO
                fMgF2Production = this.oMT.afMolarMass(this.oMT.tiN2I.MgF2)/this.oMT.afMolarMass(this.oMT.tiN2I.MgO)*afFlowRateIn(this.oMT.tiN2I.MgO);
                fO2Production = fO2Production + 0.5*this.oMT.afMolarMass(this.oMT.tiN2I.O2)/this.oMT.afMolarMass(this.oMT.tiN2I.MgO)*afFlowRateIn(this.oMT.tiN2I.MgO);
                fMgOProduction = -afFlowRateIn(this.oMT.tiN2I.MgO);
                afPartialFlowRates(this.oMT.tiN2I.MgF2) = fMgF2Production;
                afPartialFlowRates(this.oMT.tiN2I.MgO) = fMgOProduction;
                fRemainingFluorine = fRemainingFluorine - this.oMT.afMolarMass(this.oMT.tiN2I.F2)/this.oMT.afMolarMass(this.oMT.tiN2I.MgO).afFlowRateIn(this.oMT.tiN2I.MgO);
            end

            if fRemainingFluorine - (this.oMT.afMolarMass(this.oMT.tiN2I.F2)/this.oMT.afMolarMass(this.oMT.tiN2I.Al)*afFlowRateIn(this.oMT.tiN2I.Al)) <= 0
                % Incomplete reaction of Al fully consumes fluorine
                fAlF3Production = 2/3*this.oMT.afMolarMass(this.oMT.tiN2I.AlF3)/this.oMT.afMolarMass(this.oMT.tiN2I.F2)*fRemainingFluorine;
                afPartialFlowRates(this.oMT.tiN2I.AlF3) = fAlF3Production;
                afPartialFlowRates(this.oMT.tiN2I.O2) = fO2Production;
                afPartialFlowRates(this.oMT.tiN2I.Ti) = afFlowRateIn(this.oMT.tiN2I.Ti);
                afPartialFlowRates(this.oMT.tiN2I.Fe) = afFlowRateIn(this.oMT.tiN2I.Fe);
                afPartialFlowRates(this.oMT.tiN2I.F2) = -afFlowRateIn(this.oMT.tiN2I.F2);
                afPartialFlowRates(this.oMT.tiN2I.Al) = -sum(afPartialFlowRates);
                update@matter.manips.substance.stationary(this, afPartialFlowRates);
                this.trigger('Fluorination_Reactor_Manip_Update');
                return;
            else
                % Complete reaction of Al
                fAlF3Production = this.oMT.afMolarMass(this.oMT.tiN2I.AlF3)/this.oMT.afMolarMass(this.oMT.tiN2I.Al)*afFlowRateIn(this.oMT.tiN2I.Al);
                fAlProduction = -afFlowRateIn(this.oMT.tiN2I.Al);
                afPartialFlowRates(this.oMT.tiN2I.AlF3) = fAlF3Production;
                afPartialFlowRates(this.oMT.tiN2I.Al) = fAlProduction;
                fRemainingFluorine = fRemainingFluorine - 1.5*this.oMT.afMolarMass(this.oMT.tiN2I.F2)/this.oMT.afMolarMass(this.oMT.tiN2I.Al).afFlowRateIn(this.oMT.tiN2I.Al);
            end

            if fRemainingFluorine - (this.oMT.afMolarMass(this.oMT.tiN2I.F2)/this.oMT.afMolarMass(this.oMT.tiN2I.TiO2)*afFlowRateIn(this.oMT.tiN2I.TiO2)) <= 0
                % Incomplete reaction of TiO2 fully consumes fluorine
                fTiF4Production = 0.5*this.oMT.afMolarMass(this.oMT.tiN2I.TiF4)/this.oMT.afMolarMass(this.oMT.tiN2I.F2)*fRemainingFluorine;
                fO2Production = fO2Production + this.oMT.afMolarMass(this.oMT.tiN2I.O2)/this.oMT.afMolarMass(this.oMT.tiN2I.F2)*fRemainingFluorine;
                afPartialFlowRates(this.oMT.tiN2I.TiF4) = fTiF4Production;
                afPartialFlowRates(this.oMT.tiN2I.O2) = fO2Production;
                afPartialFlowRates(this.oMT.tiN2I.Fe) = afFlowRateIn(this.oMT.tiN2I.Fe);
                afPartialFlowRates(this.oMT.tiN2I.F2) = -afFlowRateIn(this.oMT.tiN2I.F2);
                afPartialFlowRates(this.oMT.tiN2I.Ti) = -sum(afPartialFlowRates);
                update@matter.manips.substance.stationary(this, afPartialFlowRates);
                this.trigger('Fluorination_Reactor_Manip_Update');
                return;
            else
                % Complete reaction of TiO2
                fTiF4Production = this.oMT.afMolarMass(this.oMT.tiN2I.TiF4)/this.oMT.afMolarMass(this.oMT.tiN2I.TiO2)*afFlowRateIn(this.oMT.tiN2I.TiO2);
                fTiO2Production = -afFlowRateIn(this.oMT.tiN2I.TiO2);
                afPartialFlowRates(this.oMT.tiN2I.TiF4) = fTiF4Production;
                afPartialFlowRates(this.oMT.tiN2I.TiO2) = fTiO2Production;
                fRemainingFluorine = fRemainingFluorine - 0.5*this.oMT.afMolarMass(this.oMT.tiN2I.F2)/this.oMT.afMolarMass(this.oMT.tiN2I.TiO2).afFlowRateIn(this.oMT.tiN2I.TiO2);
            end

            if fRemainingFluorine - (this.oMT.afMolarMass(this.oMT.tiN2I.F2)/this.oMT.afMolarMass(this.oMT.tiN2I.Fe)*afFlowRateIn(this.oMT.tiN2I.Fe)) <= 0
                % Incomplete reaction of Fe fully consumes fluorine
                fFeF3Production = 2/3*this.oMT.afMolarMass(this.oMT.tiN2I.FeF3)/this.oMT.afMolarMass(this.oMT.tiN2I.F2)*fRemainingFluorine;
                afPartialFlowRates(this.oMT.tiN2I.FeF3) = fFeF3Production;
                afPartialFlowRates(this.oMT.tiN2I.O2) = fO2Production;
                afPartialFlowRates(this.oMT.tiN2I.F2) = -afFlowRateIn(this.oMT.tiN2I.F2);
                afPartialFlowRates(this.oMT.tiN2I.Fe) = -sum(afPartialFlowRates);
                update@matter.manips.substance.stationary(this, afPartialFlowRates);
                this.trigger('Fluorination_Reactor_Manip_Update');
                return;
            else
                % Complete reaction of Fe
                fFeF3Production = this.oMT.afMolarMass(this.oMT.tiN2I.FeF3)/this.oMT.afMolarMass(this.oMT.tiN2I.Fe)*afFlowRateIn(this.oMT.tiN2I.Fe);
                fFeProduction = -afFlowRateIn(this.oMT.tiN2I.Fe);
                afPartialFlowRates(this.oMT.tiN2I.FeF3) = fFeF3Production;
                afPartialFlowRates(this.oMT.tiN2I.Fe) = fFeProduction;
            end

            % Fluorine is leftover after reacting all metal inputs
            afPartialFlowRates(this.oMT.tiN2I.O2) = fO2Production;
            afPartialFlowRates(this.oMT.tiN2I.F2) = -sum(afPartialFlowRates);
            update@matter.manips.substance.stationary(this, afPartialFlowRates);
            this.trigger('Fluorination_Reactor_Manip_Update');
        end
    end
end