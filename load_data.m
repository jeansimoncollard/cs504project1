function load_data()
global ndata;
global text;
global dim;
[FILENAME, PATHNAME] = uigetfile('*.xlsx', 'load your file');
[ndata,text] = xlsread([PATHNAME,FILENAME]);
dim=size(ndata,2);
return;