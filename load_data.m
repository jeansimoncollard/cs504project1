function load_data()
global ndata;
global text;
global MultiColumnData;
global dim;
[FILENAME, PATHNAME] = uigetfile('*.xlsx', 'load your file');
[ndata,text] = xlsread([PATHNAME,FILENAME]);
c=size(ndata,2);
if c>1
    columNumber1D = inputdlg('For 1D tests, input the column number starting from 1:',...
             'Column number', [1 50]);
         
    columNumberNDStart = inputdlg('For multiple dimension tests, please input the first column of the column range where the data is: (Input 4 if working with Data_for_PCA file)',...
             'Column number', [1 50]);
    columNumberNDEnd = inputdlg('For multiple dimension tests, please input the last column of the column range where the data is: (Input 8 if working with Data_for_PCA file)',...
             'Column number', [1 50]);
end

% We don't need all the columns to conduct our tests. For instance, with PCA, 
% we don't need the group number, condition and sex, so we specify range 4:8
MultiColumnData = ndata(:,str2num(cell2mat(columNumberNDStart)):str2num(cell2mat(columNumberNDEnd))); 

ndata = ndata(:,str2num(cell2mat(columNumber1D))); % Get all elements from column number


dim=size(ndata,2);
return;