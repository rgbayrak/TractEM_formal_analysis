
close all;
clear all;
clc;

%%% Checking if the data is missing or corrupt
% Author: roza.g.bayrak@vanderbilt.edu
% For tractem data 


% % Via Dropbox my laptop
% exDir = '/Users/RGBayrak/Dropbox*VUMC*/complete_BLSA_subjects'; % only the dir address
% subjectDir = dir('/Users/RGBayrak/Dropbox*VUMC*/complete_BLSA_subjects'); % the dir with the subfolders
% disp('Dropbox pulled data errors')

% Via Dropbox my desktop
exDir = '/home-local/bayrakrg/Dropbox*VUMC*/complete_HCP_subjects'; % only the dir address
subjectDir = dir(['/home-local/bayrakrg/Dropbox*VUMC*/complete_HCP_subjects', '/*']); % the dir with the subfolders
disp('Dropbox pulled data errors')

% abbList = {'ac'; 'acr'; 'aic'; 'bcc'; 'cp'; 'cgc'; 'cgh'; 'cst'; 'fx'; 'fxst'; 'fl'; 'gcc'; 'icp'; 'ifo'; 'ilf'; 'ml'; 'm'; 'mcp'; 'ol'; 'olfr'; ...
%             'opt'; 'pl'; 'pct'; 'pcr'; 'pic'; 'ptr'; 'ss'; 'scc'; 'scp'; 'scr'; 'sfo'; 'slf'; 'tap'; 'tl'; 'unc'};
%         

%numFilesLits = [1;2;2;1;2;2;2;2;2;2;2;1;2;2;2;2;1;1;2;2;1;2;1;2;2;2;2;1;1;2;2;2;1;2;1];

%from the qa_analysis script
%---------------------------
filenames = cellstr(char(subjectDir.name));
dropfiles = false(length(subjectDir),1);
dropfiles(ismember(filenames,{'.','..','.DS_Store','README.rtf', 'README.txt', 'QA', 'tracking_parameters.ini', 'density', '.dropbox.attr', '.dropbox', 'postproc','filelist.txt'})) = true;
dropfiles(~cellfun(@isempty,strfind(filenames,'tal_fib.gz'))) = true;
dropfiles(~cellfun(@isempty,strfind(filenames, 'tal_fib_qa.nii.gz'))) = true;
subjectDir = subjectDir(~dropfiles);
%----------------------------

for i = 1:length(subjectDir)
    trackFolder = dir(fullfile(exDir, subjectDir(i).name, '/postproc')); % 
%     abb_pos = 1;
    %from the qa_analysis script
    %---------------------------
    filenames = cellstr(char(trackFolder.name));
    dropfiles = false(length(trackFolder),1);
    dropfiles(ismember(filenames,{'.','..','.DS_Store','README.rtf', 'README.txt', 'QA', 'tracking_parameters.ini', 'density', '.dropbox.attr', 'postproc', 'filelist.txt'})) = true;
    dropfiles(~cellfun(@isempty,strfind(filenames,'_fib.gz'))) = true;
    dropfiles(~cellfun(@isempty,strfind(filenames, '_fib_qa.nii.gz'))) = true;
    trackFolder = trackFolder(~dropfiles);
    %---------------------------- 
     
    for j = 1:length(trackFolder)
        if trackFolder(j).isdir && ...
               ~strcmp(trackFolder(j).name,'__MACOSX') && ...
               ~strcmp(trackFolder(j).name,subjectDir(i).name)
             
            fileDir_dens = dir(fullfile(exDir, subjectDir(i).name, '/postproc', trackFolder(j).name, '*_density.nii.gz'));
            if length(fileDir_dens) == 0
               disp(['For: ' fullfile(subjectDir(i).name, '/postproc', trackFolder(j).name), ' no density files found!'])
            end
            fileDir_tract = dir(fullfile(exDir, subjectDir(i).name, '/postproc', trackFolder(j).name, '*_tract.trk.gz'));
            if length(fileDir_tract) == 0
               disp(['For: ' fullfile(subjectDir(i).name, '/postproc', trackFolder(j).name), ' no tract files found!'])
            end

            % DENSITY FILES-----------------------------------------------------------------------------------------------------------------------------------------------
            % Checks if the folder has the right abbreviation with the
            % right number of density files

%             if abb_pos <= length(abbList)
                for q = 1:length(fileDir_dens)
%                     name = fileDir_dens(q).name;
%                     underscore_pos = find(name=='_');
%                     
%                     if length(name(1:underscore_pos(1)-1)) ~= length(abbList{abb_pos}) || ~strcmp(name(1:underscore_pos(1)-1), abbList{abb_pos})
%                         disp([fileDir_dens(q).folder '/' fileDir_dens(q).name ' file naming is wrong!']);
%                     end
                    
                    % Check the DENSITY files for missing files
                    if length(fileDir_dens) == 1 
%                         disp(abbList{abb_pos})
                        % Should only be 1 underscore:
                        if length(strfind(fileDir_dens.name,'_')) ~= 1
                            disp(['For: ' fullfile(subjectDir(i).name, '/postproc', trackFolder(j).name,fileDir_dens.name), ' a single density file found! File mislabeled or missing!'])
                        end

                    elseif length(fileDir_dens) == 2
%                         disp(abbList{abb_pos})
                        % Make sure first file has two underscores
                        if length(strfind(fileDir_dens(1).name,'_')) ~= 2
                            disp(['For: ' fullfile(subjectDir(i).name, '/postproc', trackFolder(j).name,fileDir_dens(1).name), ' two files found but something is not right!'])
                        end


                        % Make sure second file has two underscores
                        if length(strfind(fileDir_dens(2).name,'_')) ~= 2
                            disp(['For: ' fullfile(subjectDir(i).name, '/postproc', trackFolder(j).name,fileDir_dens(2).name), ' two files found but something is not right!'])
                        end
                    else
                        disp(['For: ' fullfile(subjectDir(i).name, '/postproc', trackFolder(j).name) ' not the right number of density!'])
                    end  
                end

                %TRACT FILES----------------------------------------------------------------------------------------------------------------------------------------------------------
                % Checks if the folder has the right abbreviation with the
                % right number of tract files

                for q = 1:length(fileDir_tract)
%                     name = fileDir_tract(q).name;
%                     underscore_pos = find(name=='_');
%                     if length(name(1:underscore_pos(1)-1)) ~= length(abbList{abb_pos}) || ~strcmp(name(1:underscore_pos(1)-1), abbList{abb_pos})
%                         disp([fileDir_tract(q).folder '/' fileDir_tract(q).name ' file naming is wrong!']);
%                     end
                    
                    % Check the TRACT files for missing files
                    if length(fileDir_tract) == 1
                        % Should only be 1 underscore:
                        if length(strfind(fileDir_tract.name,'_')) ~= 1
                            disp(['For: ' fullfile(subjectDir(i).name, '/postproc', trackFolder(j).name,fileDir_tract.name), ' only a single tract file found! File mislabeled or missing!'])
                        end

                    elseif length(fileDir_tract) == 2
                        % Make sure first file has two underscores
                        if length(strfind(fileDir_tract(1).name,'_')) ~= 2
                            disp(['For: ' fullfile(subjectDir(i).name, '/postproc', trackFolder(j).name,fileDir_tract(1).name), ' two tract files found but something is not right!'])
                        end

                        % Make sure second file has two underscores
                        if length(strfind(fileDir_tract(2).name,'_')) ~= 2
                            disp(['For: ' fullfile(subjectDir(i).name, '/postproc', trackFolder(j).name,fileDir_tract(2).name), ' two tract files found but something is not right!'])
                        end
                    else
                        disp(['For: ' fullfile(subjectDir(i).name, '/postproc', trackFolder(j).name) ' not the right number of tract files!'])
                    end
                end
%                 abb_pos = abb_pos+1;
%             end

            % ROA and seed check
            fileDir_ROA = dir(fullfile(exDir, subjectDir(i).name, '/postproc', trackFolder(j).name, '*ROA*.nii.gz'));
            for d = 1:length(fileDir_ROA)
                if isempty(fileDir_ROA)
                disp(['For: ' fullfile(subjectDir(i).name,'/postproc', trackFolder(j).name,fileDir_ROA(d).name), 'no ROA files found!'])
                end
            end
            
            fileDir_seed = dir(fullfile(exDir, subjectDir(i).name, '/postproc', trackFolder(j).name, '*seed*.nii.gz'));
            for d = 1:length(fileDir_seed)
                if isempty(fileDir_seed)
                disp(['For: ' fullfile(subjectDir(i).name, '/postproc', trackFolder(j).name,fileDir_seed(d).name), ' no seed files are found!'])
                end
            end
            
            
            % MISLABELED TRACT & DENSITY---------------------------------------------------------------------------------------------------------------------------
            % Checks for the mislabeled files
            fileDir_density_trk = dir(fullfile(exDir, subjectDir(i).name, '/postproc',  trackFolder(j).name, '*_density.trk.gz'));
            fileDir_track_trk = dir(fullfile(exDir, subjectDir(i).name, '/postproc',  trackFolder(j).name, '*_track.trk.gz'));

            % density.trk
            for d = 1:length(fileDir_density_trk)
                disp(['For: ' fullfile(subjectDir(i).name, '/postproc', trackFolder(j).name,fileDir_density_trk(d).name), ' density file saved as trk file, should be nii!'])
            end

            % track.trk
            for t = 1:length(fileDir_track_trk)
                disp(['For: ' fullfile(subjectDir(i).name, '/postproc', trackFolder(j).name,fileDir_track_trk(t).name), ' file saved as track file, should be tract!'])
            end
        end
    end
%     disp(['The : ' fullfile(subjectDir(i).name) ', subject folder is searched!'])
end
disp('The end!')