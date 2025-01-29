classdef LoadBankController
    properties
        PortNumber % Port number for communication
        LoadBank   % Modbus object for communication
    end
    
    methods
        % Constructor
        function obj = LoadBankController(portNumber)
            % LoadBankController Constructor
            % Syntax:
            %   obj = LoadBankController(portNumber)
            % 
            % Description:
            %   Initializes the LoadBankController object and establishes 
            %   communication using the specified port number.
            % 
            % Input:
            %   portNumber - String specifying the COM port (e.g., 'COM4').
            %
            % Output:
            %   obj - Instance of the LoadBankController class.
            % Initialize the modbus communication
            fprintf('Initializing communication on port: %s\n', portNumber);
            obj.PortNumber = portNumber;
            obj.LoadBank = modbus('serialrtu', portNumber); % Create modbus object
            obj.LoadBank.Timeout = 3; % Set timeout
            fprintf('Communication established successfully.\n');
        end
%         function testFunction(~)
%             [a,b] = findCombination_AR(5500);
%             disp(a)
%             disp(b)
%         end

        %perform sanity check 


        %perform status check

%         function status = checkStatus(~)
%             status = true;
%         end
        function setRealPower(obj,Phase,RealPower)
            RealPower=round((120^2/101^2)*RealPower);
            %This function Sets the RealPower on selected Phase
            %Syntax
            %   setRealPower(2,5500)
            valueArray=zeros(1,8);
            if ~isnumeric(Phase) && (Phase==1 || Phase == 2 || Phase ==3)
               errordlg('Phase parameter must be 1, 2 or 3', 'Error');
            end
            

            switch Phase
                case 1
                    [slave_id,combination]=findCombination_AR(RealPower);
                    for i=1:length(combination)
                        valueArray(combination(i))=1;
                    end
                    write(obj.LoadBank,"coils",1,valueArray,slave_id)
                    disp("Turned ON the following Loads on Phase 1")
                    disp(valueArray)


                case 2
                    [slave_id,combination]=findCombination_BR(RealPower);
                    for i=1:length(combination)
                        valueArray(combination(i))=1;
                    end
                    write(obj.LoadBank,"coils",25,valueArray,slave_id)
                    disp("Turned ON the following Loads on Phase 2")
                    disp(valueArray)

                case 3
                    [slave_id,combination]=findCombination_CR(RealPower);
                    for i=1:length(combination)
                        valueArray(combination(i))=1;
                    end
                    write(obj.LoadBank,"coils",17,valueArray,slave_id)
                    disp("Turned ON the following Loads on Phase 3")
                    disp(valueArray)
            end

        end

        function resetLoad(obj)
            %resetting
            %write(obj.LoadBank,"coils",startingAddres,values,slaveID)
            write(obj.LoadBank,"coils",1,zeros(1,8),1)
            write(obj.LoadBank,"coils",25,zeros(1,8),1)
            write(obj.LoadBank,"coils",16,zeros(1,8),2)



       

        end
        %turn on Load
        function turnOnLoad(obj)
            % This function turns on the load by setting the coil 15 of
            % slave-3 to high
            %Syntax
            %   write(obj,"coils",address,value,slaveID)
            write(obj.LoadBank,"coils",15,1,3);
        end
        function turnOnPower(obj)
            % This function turns on the load by setting the coil 14 of
            % slave-3 to high
            %Syntax
            %   write(obj,"coils",address,value,slaveID)
            write(obj.LoadBank,"coils",14,1,3);
        end
        function selectVoltageLevel(obj,select)
            %This function will switch voltage level between 120V and 240V
            %Syntax
            %   obj.selectVoltageLevel(X)  
            %   X:
            %   1 = select 120V
            %   2 = select 240V
            %
            if(select==120)
                %select 120V
                write(obj.LoadBank,"coils",9,1,3);
            elseif(select==240)
                %select 240
                write(obj.LoadBank,"coils",10,1,3);
            else
                %throw error
                beep
                errordlg('Wrong voltage selection. Please select 120V or 240V.', 'Error');
            end

        end
        
        % Method: findCombination_AL
        function [ID, combination] = findCombination_AL(~, varargin)
            [ID, combination] = findCombination_AL(varargin{:}); % Call the external function
        end

        % Method: findCombination_BR
        function [ID, combination] = findCombination_BR(~, varargin)
            [ID, combination] = findCombination_BR(varargin{:}); % Call the external function
        end

        % Method: findCombination_AR
        function [ID, combination] = findCombination_AR(~, RealPower)
            [ID, combination] = findCombination_AR(RealPower); % Call the external function
        end

        % Method: findCombination_CC
        function [ID, combination] = findCombination_CC(~, varargin)
            [ID, combination] = findCombination_CC(varargin{:}); % Call the external function
        end

        % Method: findCombination_BC
        function [ID, combination] = findCombination_BC(~, varargin)
            [ID, combination] = findCombination_BC(varargin{:}); % Call the external function
        end

        % Method: findCombination_CL
        function [ID, combination] = findCombination_CL(~, varargin)
            [ID, combination] = findCombination_CL(varargin{:}); % Call the external function
        end

        % Method: findCombination_AC
        function [ID, combination] = findCombination_AC(~, varargin)
            [ID, combination] = findCombination_AC(varargin{:}); % Call the external function
        end

        % Method: findCombination_BL
        function [ID, combination] = findCombination_BL(~, varargin)
            [ID, combination] = findCombination_BL(varargin{:}); % Call the external function
        end

        % Method: findCombination_CR
        function [ID, combination] = findCombination_CR(~, varargin)
            [ID, combination] = findCombination_CR(varargin{:}); % Call the external function
        end
    end
end
