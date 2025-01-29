%inverter class 2.0 added a method to store offset data that are send only
%one time upon connection
classdef InverterClient < WebSocketClient
    properties (Access = private)
        latestMessage % Property to store the latest message
        offsetData  % Property to store the first message
    end
    
    methods
        function obj = InverterClient(varargin)
            % Constructor
            obj@WebSocketClient(varargin{:});
            obj.latestMessage = ''; % Initialize latest message
            obj.offsetData = '';  % Initialize first message
        end
        
        function message = getLatestMessage(obj)
            % Method to return the latest message
            message = obj.latestMessage;
        end
        
        function message = getoffsetData(obj)
            % Method to return the first message
            message = obj.offsetData;
        end
    end
    
    methods (Access = protected)
        function onOpen(obj, message)
            % This function simply displays the message received
            fprintf('%s\n', message);
        end
        
        function onTextMessage(obj, message)
            % This function displays the message received and updates the messages
            disp("Inverter stats received.")
            obj.latestMessage = message; % Update latest message
            
            if isempty(obj.offsetData)
                obj.offsetData = message; % Update first message only if it's not set
            end
        end
        
        function onBinaryMessage(obj, bytearray)
            % This function simply displays the message received
            fprintf('Binary message received:\n');
            fprintf('Array length: %d\n', length(bytearray));
        end
        
        function onError(obj, message)
            % This function simply displays the message received
            fprintf('Error: %s\n', message);
        end
        
        function onClose(obj, message)
            % This function simply displays the message received
            fprintf('%s\n', message);
        end
    end
end
