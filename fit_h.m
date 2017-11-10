function fit_h()
global ndata

subplot('Position',[0.33 0.06 .41 0.85],'color',[0 0 0],'XTick',[],'YTick',[],'Box','on','units','normalized'); histfit(ndata,100)

return

