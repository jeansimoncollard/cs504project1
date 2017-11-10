function x = power_test(t,df,tail,alpha)

if nargin < 4, 
    alpha = 0.05; %default
end 

if ~isscalar(alpha)
   error('POWERSTUDENT requires a scalar ALPHA value.');
end

if ~isnumeric(alpha) || isnan(alpha) || (alpha <= 0) || (alpha >= 1)
   error('POWERSTUDENT requires 0 < ALPHA < 1.');
end

if nargin < 3,
    tail = 1;
end

if nargin < 2, 
    error('Requires at least two input arguments.'); 
end 

t = abs(t);

if tail == 1;
   disp('It is a one-tailed hypothesis test.');
   a = alpha;
   P = 1-tcdf(t,df);
   if P >= a;
      disp('(The null hypothesis was not statistically significative.)');
      tp = tinv(1-a,df) - t;  %Power estimation.
      x = 1-tcdf(tp,df);
      fprintf('Power is: %2.4f\n\n', x)
   else
      disp('(The null hypothesis was statistically significative.)');
      tb = t - tinv(1-a,df);  %Power estimation.
      x = tcdf(tb,df);
      fprintf('Power is: %2.4f\n\n', x)
   end
elseif tail == 2;
   disp('It is a two-tailed hypothesis test.');
   a = alpha/2;
   P = 1-tcdf(t,df);
   if P >= a;
      disp('(The null hypothesis was not statistically significative.)');
      tp1 = tinv(1-a,df) - t;  %Power estimation.
      Power1 = 1-tcdf(tp1,df);
      tp2 = t + tinv(1-a,df);
      Power2 = 1-tcdf(tp2,df);
      x = Power1 + Power2;
      fprintf('Power is: %2.4f\n\n', x)
   else      
      disp('(The null hypothesis was statistically significative.)');
      tb1 = t - tinv(1-a,df);  %Power estimation.
      b1 = 1-tcdf(tb1,df);
      tb2 = t + tinv(1-a,df);
      b2 = 1-tcdf(tb2,df);
      x = 1 - (b1 - b2);
      fprintf('Power is: %2.4f\n\n', x)
   end
end

return,