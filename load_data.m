function load_data()
global ndata;
global text;
global dim;
[FILENAME, PATHNAME] = uigetfile('*.xlsx', 'load your file');
[ndata,text] = xlsread([PATHNAME,FILENAME]);

c=size(ndata,2);
if c>1
    x = inputdlg('Select a column number starting from 1:',...
             'Column number', [1 50]);
end
ndata = ndata(:,str2num(cell2mat(x))); % Get all elements from column number

dim=size(ndata,2);
return;