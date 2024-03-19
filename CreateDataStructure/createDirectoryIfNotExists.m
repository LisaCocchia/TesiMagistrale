function createDirectoryIfNotExists(directoryPath)
    % Check if the directory exists
    if ~exist(directoryPath, 'dir')
        % If the directory doesn't exist, create it
        mkdir(directoryPath);
        disp(['Directory created: ' directoryPath]);
    end
end
