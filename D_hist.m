function D_hist()
global ndata;

 subplot('Position',[0.33 0.06 .41 0.85],'color',[0 0 0],'XTick',[],'YTick',[],'Box','on','units','normalized'); hist(ndata,100);

return
