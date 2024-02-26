classdef UtilityClass

    methods(Static)
        function folderNames = getFolderList(path)
            files = dir(path);
            folderNames = {files([files.isdir]).name};
            folderNames= folderNames(~ismember(folderNames ,{'.','..'}));
        end

        function fileNames = getFileList(path)
            files = dir(path);
            fileNames = {files(~[files.isdir]).name};
            fileNames = fileNames(~ismember(fileNames ,{'.','..','desktop.ini'}));
        end
    end
end

