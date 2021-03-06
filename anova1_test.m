function [p,anovatab]=anova1_test()

%get the data
global MultiColumnData;

x1 = MultiColumnData(:,1);
x2 = MultiColumnData(:,2);
x3 = MultiColumnData(:,3);

%clean data

x1(isnan(x1)) = [];
x2(isnan(x2)) = [];
x3(isnan(x3)) = [];

%check data

if ~isvector(x1) || ~isvector(x2) || ~isvector(x3)
    error('non vector entered')
end
if ~all(isfinite(x1)) || ~all(isnumeric(x1))
    error('colum 1 is bad')
end
if ~all(isfinite(x2)) || ~all(isnumeric(x2))
    error('colum 2 is bad')
end
if ~all(isfinite(x3)) || ~all(isnumeric(x3))
    error('colum 3 is bad')
end
    
%check if parametric

%assume non parametric
parametric = 0;

if (get(findobj(gcf,'Tag','para'),'Value') && get(findobj(gcf,'Tag','nonpara'),'Value'))
    disp('Is the data parametric or not?'); 
    return;
end 
if (not(get(findobj(gcf,'Tag','para'),'Value')) && not(get(findobj(gcf,'Tag','nonpara'),'Value')))
    disp('Pick something'); 
    return;
end
if (get(findobj(gcf,'Tag','para'),'Value'))
    parametric = 1;
end 
if (get(findobj(gcf,'Tag','nonpara'),'Value'))
    parametric = 0;
end 
x = [x1 x2 x3];

%ANOVA 

if parametric == 1      
    [n,r] = size(x);           
    xm = mean(x);             
    gm = mean(xm);             
    df1 = r-1;     %between            
    df2 = r*(n-1);   %within          
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
    nargs = 1;
    if nargs==1
        
        figure('pos',get(gcf,'pos') + [0,-200,0,0]);
        boxplot(x,'notch','on');
        
    else
        figure('pos',get(gcf,'pos') + [0,-200,0,0]);
        boxplot(x,group,'notch','on');
    end 
end    

%Kruskal-Wallis
if parametric == 0
    [p,tbl,stats] = kruskalwallis(x);
    if p
        disp(strcat('The null hypothesis was rejected with a p value of:', p, ',alpha value: 0.01 and stats of')); 
        disp(stats); 
    else
        disp(strcat('The null hypothesis was accepted with a p value of:', p, ',alpha value: 0.01 and stats of')); 
        disp(stats); 
    end
end

end
