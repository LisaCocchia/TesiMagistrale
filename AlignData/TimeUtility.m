classdef TimeUtility

    methods(Static)
        function samples = millisecondsToSamples(milliseconds, sampleFrequency) 
            samples = (milliseconds / 1000 * sampleFrequency);
        end

        function modifiedDateTime = addMilliseconds(originalDateTime, millisecondsToAdd)
            if ~isdatetime(originalDateTime)
                error('Input must be a datetime object.');
            end
            modifiedDateTime = originalDateTime + milliseconds(millisecondsToAdd);
        end
        
        function differenceInSeconds = calculateTimeDifference(datetime1, datetime2)
            if ~isdatetime(datetime1) || ~isdatetime(datetime2)
                error('Both inputs must be datetime objects.');
            end
            differenceInSeconds = seconds(datetime2 - datetime1);
        end
        
        function timeDifferenceInMinutes = calculateTimeDifferenceInMinutes(initialDateTime, finalDateTime, print)
            if nargin < 3 || isempty(print)
                print = false;  % Imposta il valore predefinito
            end
            initialDateTime.TimeZone = "local";
            finalDateTime.TimeZone = "local";
            % Check that the inputs are datetime objects
            if ~isdatetime(initialDateTime) || ~isdatetime(finalDateTime)
                error('Both inputs must be datetime objects.');
            end
        
            % Calculate the time difference in seconds
            timeDifferenceInSeconds = seconds(finalDateTime - initialDateTime);
        
            % Convert the difference to minutes
            timeDifferenceInMinutes = timeDifferenceInSeconds / 60;
        
            % Display the result
            if(print)
                disp(['The time difference is ', num2str(timeDifferenceInMinutes), ' minutes.']);
            end
        end
        
        function modifiedDatetime = subtractMinutes(originalDatetime, minutesToSubtract)
            if ~isdatetime(originalDatetime)
                error('Input must be a datetime object.');
            end
            modifiedDatetime = originalDatetime - minutes(minutesToSubtract);
        end
    
    end
end

