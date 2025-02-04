classdef ChromaController
    properties
        Instrument
        ResourceName = '';
    end
    
    methods
        function obj = ChromaController(resourceName)
            if nargin > 0
                obj.ResourceName = resourceName;
            end
        end
        
        function obj = connect(obj)
            % Find existing instrument object
            obj.Instrument = instrfind('Type', 'visa-usb', 'RsrcName', obj.ResourceName, 'Tag', '');
            
            % Create the instrument object if it does not exist
            if isempty(obj.Instrument)
                obj.Instrument = visa('NI', obj.ResourceName);
            else
                fclose(obj.Instrument);
                obj.Instrument = obj.Instrument(1);
            end
            
            % Open connection
            fopen(obj.Instrument);
            fprintf('Connected to %s\n', obj.ResourceName);
        end
        
        function disconnect(obj)
            if ~isempty(obj.Instrument) && strcmp(obj.Instrument.Status, 'open')
                fclose(obj.Instrument);
                fprintf('Disconnected from %s\n', obj.ResourceName);
            end
        end
        
        function setPower(obj, Pmp)
            if isempty(obj.Instrument) || ~strcmp(obj.Instrument.Status, 'open')
                error('Instrument not connected. Call connect() first.');
            end
            if(Pmp==0)      % cannot set zeros therefore set to 50W
                Pmp=50;
            elseif(Pmp>3300)
                Pmp=3300;   % sanity check saturate at channel limit
            end

            [Voc, Isc, Vmp, Imp]=calculateParameters(obj,Pmp);

            try
            
                fprintf(obj.Instrument, ['SAS:VOC  ', char(string(Voc))]);
                fprintf(obj.Instrument, ['SAS:ISC  ', char(string(Isc))]);
                fprintf(obj.Instrument, ['SAS:VMPp  ', char(string(Vmp))]);
                fprintf(obj.Instrument, ['SAS:IMPp  ', char(string(Imp))]);
                fprintf(obj.Instrument, 'TRIG');
               % fprintf('Power parameters set.\n');
            catch
                obj.connect();
                pause(1)
                fprintf(obj.Instrument, ['SAS:VOC  ', char(string(Voc))]);
                fprintf(obj.Instrument, ['SAS:ISC  ', char(string(Isc))]);
                fprintf(obj.Instrument, ['SAS:VMPp  ', char(string(Vmp))]);
                fprintf(obj.Instrument, ['SAS:IMPp  ', char(string(Imp))]);
                fprintf(obj.Instrument, 'TRIG');
                %fprintf('Power parameters set.\n');

            end
        end
        
        function turnOn(obj)
            if isempty(obj.Instrument) || ~strcmp(obj.Instrument.Status, 'open')
                error('Instrument not connected. Call connect() first.');
            end
            fprintf(obj.Instrument, 'CONFigure:OUTPut ON');
            fprintf('Equipment turned ON.\n');
        end
        
        function turnOff(obj)
            if isempty(obj.Instrument) || ~strcmp(obj.Instrument.Status, 'open')
                error('Instrument not connected. Call connect() first.');
            end
            fprintf(obj.Instrument, 'CONFigure:OUTPut OFF');
            fprintf('Equipment turned OFF.\n');
        end
        
        function obj = chooseEquipment(obj, newResourceName)
            obj.ResourceName = newResourceName;
            fprintf('Equipment selected: %s\n', newResourceName);
        end
        
        function delete(obj)
            if ~isempty(obj.Instrument) && strcmp(obj.Instrument.Status, 'open')
                fclose(obj.Instrument);
            end
        end
        
        function [Voc, Isc, Vmp, Imp] = calculateParameters(~, Pmp)
            % Define max values
            maxVoc = 350;
            maxIsc = 13;
            
            % Estimate Vmp and Imp based on Pmp
            Vmp = 0.8 * maxVoc;
            Imp = Pmp / Vmp;
            
            % Ensure Imp does not exceed maxIsc
            if Imp > maxIsc
                Imp = maxIsc;
                Vmp = Pmp / Imp;
            end
            
            % Estimate Voc and Isc
            Voc = 1.1 * Vmp;
            Isc = 1.1 * Imp;
            
            % Ensure limits
            Voc = min(Voc, maxVoc);
            Isc = min(Isc, maxIsc);
            
            %fprintf('Calculated Parameters - Voc: %.2f V, Isc: %.2f A, Vmp: %.2f V, Imp: %.2f A\n', Voc, Isc, Vmp, Imp);
        end
    end
end
