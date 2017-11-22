function S_desc()
global ndata;

% The script to get the column number is in load_data

X = ndata
mi=mean(X);
edithandle=findobj(gcf,'Tag','mean');% findobj: locate graphics objects with specific properties
set(edithandle,'visible','on')
edithandle=findobj(gcf,'Tag','textmean');
set(edithandle,'string',num2str(mi));
pause (0.3);

mi=std(X)/sqrt(length(X));
edithandle=findobj(gcf,'Tag','stdE');
set(edithandle,'visible','on')
edithandle=findobj(gcf,'Tag','textstdE');
set(edithandle,'string',num2str(mi));
pause (0.3);

ci=[(mean(X)-1.96*(std(X)/sqrt(length(X)))), (mean(X)+1.96*(std(X)/sqrt(length(X))))];

edithandle=findobj(gcf,'Tag','CI');
set(edithandle,'visible','on')
edithandle=findobj(gcf,'Tag','textCI1');
set(edithandle,'string',num2str(ci(1)));
edithandle=findobj(gcf,'Tag','CI');
set(edithandle,'visible','on')
edithandle=findobj(gcf,'Tag','textCI2');
set(edithandle,'string',num2str(ci(2)));
pause (0.3);

mi=median(X);
edithandle=findobj(gcf,'Tag','Median');
set(edithandle,'visible','on')
edithandle=findobj(gcf,'Tag','textmedian');
set(edithandle,'string',num2str(mi));
pause (0.3);


mi=mode(X);
edithandle=findobj(gcf,'Tag','Mode');
set(edithandle,'visible','on')
edithandle=findobj(gcf,'Tag','textmode');
set(edithandle,'string',num2str(mi));
pause (0.3);


mi=std(X);
edithandle=findobj(gcf,'Tag','std');
set(edithandle,'visible','on')
edithandle=findobj(gcf,'Tag','textstd');
set(edithandle,'string',num2str(mi));
pause (0.3);


mi=var(X);
edithandle=findobj(gcf,'Tag','var');
set(edithandle,'visible','on')
edithandle=findobj(gcf,'Tag','textvar');
set(edithandle,'string',num2str(mi));
pause (0.3);


mi=kurtosis(X);
edithandle=findobj(gcf,'Tag','ku');
set(edithandle,'visible','on')
edithandle=findobj(gcf,'Tag','textku');
set(edithandle,'string',num2str(mi));
pause (0.3);


mi=skewness(X);
edithandle=findobj(gcf,'Tag','sk');
set(edithandle,'visible','on')
edithandle=findobj(gcf,'Tag','textsk');
set(edithandle,'string',num2str(mi));
pause (0.3);


mi=range(X);
edithandle=findobj(gcf,'Tag','range');
set(edithandle,'visible','on')
edithandle=findobj(gcf,'Tag','textrange');
set(edithandle,'string',num2str(mi));
pause (0.3);


mi=min(X);
edithandle=findobj(gcf,'Tag','Min');
set(edithandle,'visible','on')
edithandle=findobj(gcf,'Tag','textmin');
set(edithandle,'string',num2str(mi));
pause (0.3);


mi=max(X);
edithandle=findobj(gcf,'Tag','Max');
set(edithandle,'visible','on')
edithandle=findobj(gcf,'Tag','textmax');
set(edithandle,'string',num2str(mi));
pause (0.3);


mi=sum(X);
edithandle=findobj(gcf,'Tag','Sum');
set(edithandle,'visible','on')
edithandle=findobj(gcf,'Tag','textsum');
set(edithandle,'string',num2str(mi));
pause (0.3);


mi=length(X);
edithandle=findobj(gcf,'Tag','Count');
set(edithandle,'visible','on')
edithandle=findobj(gcf,'Tag','textcount');
set(edithandle,'string',num2str(mi))
