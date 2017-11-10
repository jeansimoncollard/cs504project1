function [p,anovatab]=anova1_test(x, group)
nargs=nargin;
if isempty(nargs)|| nargs==0 
    error('Data are required for the anovva test');
elseif nargs==1
    if ~ismatrix(x)
     error('2D data is requared for the test')
    end
    if ~all(isnumeric(x))||~any(all(isfinite(x)))|| all(isnan(x(:)))
     error('Data must be numerci and finite');
    end
    group=[];
end
 %ANOVA
   [n,r] = size(x);           
   xm = mean(x);             
   gm = mean(xm);             
   df1 = r-1;                 
   df2 = r*(n-1);             
   RSS = n*(xm - gm)*(xm-gm)';        
   TSS = (x(:) - gm)'*(x(:) - gm);  
   SSE = TSS - RSS;                   
   if (df2 > 0)
   mse = SSE/df2;
   else
   mse = NaN;
   end
    if (SSE~=0)
      F = (RSS/df1) / mse;
      p = fpval(F,df1,df2);    
    end


 %*********************************************************************
Table=zeros(3,5);               %Formatting for ANOVA Table printout
Table(:,1)=[ RSS SSE TSS]';
Table(:,2)=[df1 df2 df1+df2]';
Table(:,3)=[ RSS/df1 mse Inf ]';
Table(:,4)=[ F Inf Inf ]';
Table(:,5)=[ p Inf Inf ]';
rowheads = {getString(message('stats:anova1:RowHeadColumns')), getString(message('stats:anova1:RowHeadError')), getString(message('stats:anova1:RowHeadTotal'))};
colheads = {getString(message('stats:anova1:ColHeadSource')), getString(message('stats:anova1:ColHeadSS')), getString(message('stats:anova1:ColHeadDf')), getString(message('stats:anova1:ColHeadMS')), getString(message('stats:anova1:ColHeadF')), getString(message('stats:anova1:ColHeadProbGtF'))};

atab = num2cell(Table);
for i=1:size(atab,1)
   for j=1:size(atab,2)
      if (isinf(atab{i,j}))
         atab{i,j} = [];
      end
   end
end
atab = [rowheads' atab];
atab = [colheads; atab];
if (nargout > 1)
   anovatab = atab;
end

%Display results
wtitle = getString(message('stats:anova1:OnewayANOVA'));
ttitle = getString(message('stats:anova1:ANOVATable'));
statdisptable(atab, wtitle, ttitle);
if nargs==1

    figure('pos',get(gcf,'pos') + [0,-200,0,0]);
    boxplot(x,'notch','on');
    
else
    figure('pos',get(gcf,'pos') + [0,-200,0,0]);
    boxplot(x,group,'notch','on');
end

end
