function STATS=student_t()
global MultiColumnData;

%IMPORTANT NOTE: My system uses comma as decimal separator. This is why I
%changed the points to commas in the excel file. To run the paired test on
%another PC' the commas might need to be changed back to points.

%Check if nonparemetric or parametric test checkbox is checked
if (get(findobj(gcf,'Tag','NonParametricCheckBox'),'Value') && get(findobj(gcf,'Tag','ParametricCheckBox'),'Value'))
    disp('Please choose a single checkbox'); 
    return;
end 

if (not(get(findobj(gcf,'Tag','NonParametricCheckBox'),'Value')) && not(get(findobj(gcf,'Tag','ParametricCheckBox'),'Value')))
    disp('Please choose a checkbox'); 
    return;
end 

x1 = MultiColumnData(:,1);
x2 = MultiColumnData(:,2);

%Remove nans
x2(isnan(x2)) = [];
x1(isnan(x1)) = [];

isPairedTest = inputdlg('Enter 1 for a paired test and 0 for an unpaired test',...
             'Paired Test', [1 50]);

PunP = str2num(cell2mat(isPairedTest));

alphaInput = inputdlg('Enter significance level between 0 and 1',...
             'Significance Level', [1 50]);
         
alpha = str2num(cell2mat(alphaInput));

tailInput = inputdlg('Enter 1 for one-tailed test and 2 for two-tail test',...
             'Tail', [1 50]);
         
tail = str2num(cell2mat(tailInput));

if ~isvector(x1) || ~isvector(x2)
   error('The student test requires vector rather than matrix data.');
   
end 
if ~all(isfinite(x1)) || ~all(isnumeric(x1)) || ~all(isfinite(x2)) || ~all(isnumeric(x2))
    error('Warning: all vector1 and vector2 values must be numeric and finite')
end
if ~isscalar(PunP) || ~isfinite(PunP) || ~isnumeric(PunP) || isempty(PunP)
    error('Warning: it is required a scalar, numeric and finite Paired/unpaired value.')
end
if PunP ~= 0 && PunP ~= 1 %check if PunP is 0 or 1
    error('Warning: PunP must be 0 for unpaired test or 1 for paired test.')
end
if PunP==1
    if ((numel(x1) ~= numel(x2))),
        error('Warning: for paired t_test requires the data vectors to have the same number of elements.');
    end
end
if ~isscalar(alpha) || ~isnumeric(alpha) || ~isfinite(alpha) || isempty(alpha)
    error('Warning: it is required a numeric, finite and scalar ALPHA value.');
end
if alpha <= 0 || alpha >= 1 %check if alpha is between 0 and 1
    error('Warning: ALPHA must be comprised between 0 and 1.')
end
if ~isscalar(tail) || ~isfinite(tail) || ~isnumeric(tail) || isempty(tail)
    error('Warning: it is required a scalar, numeric and finite TAIL value.')
end
if tail ~= 2 && tail ~= 1 %check if tail is 1 or 2
    error('Warning: TAIL must be 1 or 2.')
end
clear args  nu
tr=repmat('-',1,60);

%We do the parametric test
if (get(findobj(gcf,'Tag','ParametricCheckBox'),'Value'))
    switch PunP
        case 0 %unpaired test
            n=[length(x1) length(x2)]; %samples sizes
            m=[mean(x1) mean(x2)]; %samples means
            v=[var(x1) var(x2)]; %samples variances
            %Fisher-Snedecor F-test
            if v(2)>v(1) 
                v=fliplr(v);
                m=fliplr(m);
                n=fliplr(n);
            end
            F=v(1)/v(2); %variances ratio
            DF=n-1;
            p = fcdf(F,DF(1),DF(2)); %p-value
            p = 2*min(p,1-p);
            if nargout
                STATS.Fvalue=F;
                STATS.DFn=DF(1);
                STATS.DFd=DF(2);
                STATS.FPvalue=p;
            end
            %display results
            disp('F-TEST FOR EQUALITY OF VARIANCES')
            disp(' ')
            disp(tr)
            fprintf('F\t\t\t\tDFn\t\t\tDFd\t\t\tp-value\n')
            disp(tr)
            fprintf('%0.5f\t\t\t%d\t\t\t%d\t\t\t%0.5f\n',F,DF,p)
            disp(tr)
            if   p>alpha %equal variances
                fprintf('Variances are equal\n')
                disp(tr)
                disp(' ')
                dfs=sum(n)-2; %degrees of freedom
                s=sum((n-1).*v)/(sum(n)-2); %combined variance
                denom=sqrt(sum(s./n));
                disp('STUDENT''S T-TEST FOR UNPAIRED SAMPLES')
                disp(' ')
                disp(tr)
             else  %unequal variances (Behrens-Welch problem)
                fprintf('Variances are different\n')
                disp(tr)
                disp(' ')
                %Satterthwaite's approximate t test
                a=v./n; b=sum(a);
                denom=sqrt(b);
                dfs=b^2/sum(a.^2./(n-1));
                disp('SATTERTHWAITE''S APPROXIMATE T-TEST FOR UNPAIRED SAMPLES')
                disp(' ')
                disp(tr)

            end
            dm=diff(m); %Difference of means
            clear H n m v a b s %clear unnecessary variables
        case 1 %paired test
            disp('STUDENT''S T-TEST FOR PAIRED SAMPLES')
            disp(' ')
            disp(tr)
            n=length(x1); %samples size
            dfs=n-1; %degrees of freedom
            d=x1-x2; %samples difference
            dm=mean(d); %mean of difference
            vc=tinv(1-(alpha/tail),dfs); %critical value
            ic=[dm-(vc*sqrt(var(d)/n)) dm+(vc*sqrt(var(d)/n))];  %Confidence interval
            denom=sqrt((sum((d-dm).^2))/(n*(n-1))); %standard error of difference
            clear n d %clear unnecessary variables
            fprintf('Mean of difference\t\t\t\t')
            str=[num2str((1-alpha)*100) '%% C.I.\n'];
            fprintf(str)
            disp(tr)
            fprintf('%0.4f\t\t\t\t\t%0.4f\t\t\t%0.4f\n',abs(dm),ic)
            disp(tr)
    end
    t=abs(dm)/denom; %t value
    p=(1-tcdf(t,dfs))*tail; %t-value associated p-value
    %display results
    fprintf('t\t\t\t\tDF\t\t\t  tail\t\t\tp-value\n')
    disp(tr)
    fprintf('%0.5f\t\t\t%0.4f\t\t\t%d\t\t\t%0.5f\n',t,dfs,tail,p)
    disp(tr)
    if nargout
        STATS.tvalue=t;
        STATS.tdf=dfs;
        STATS.ttail=tail;
        STATS.tpvalue=p;
    end    
%We do the non parametric test. For this, we chose the implemented matlab
%Wilcoxon rank sum test which is equivalent to Mann-Whitney U-test, the non
%parametric t-test equivalent

    

elseif (get(findobj(gcf,'Tag','NonParametricCheckBox'),'Value'))
    
    if tail == 1
       [p,h,stats] = ranksum(x1,x2,'alpha',alpha,...
        'tail','left');
    end
    if tail == 2
        [p,h,stats] = ranksum(x1,x2,'alpha',alpha,...
        'tail','both');
    end
    
    if h
        disp(strcat('The null hypothesis was rejected with a p value of:', p, 'and stats of'));
        disp(stats);
    else
        disp(strcat('The null hypothesis was accepted with a p value of:', p, 'and stats of'));
        disp(stats);
    end
    
end 





return