function [E,D,NewData] = PCA()
global MultiColumnData;
lastEig = size(MultiColumnData,1); 
firstEig = 1; 
Dim_Depart = size (MultiColumnData, 2);
MultiColumnData=zscore(MultiColumnData);
disp('covariances calculation in process...\n'); 
covarianceMatrix = cov(MultiColumnData);
[E, D] = eig (covarianceMatrix);
Tolerance = 1e-6;
maxLastEig = sum (diag (D) > Tolerance);
if maxLastEig == 0
  fprinf('Eigenvalues of the covariance matrix are small against the tolerency [ %g ].\n', Tolerance);
end
eigenvalues = sort(diag(D),'descend');
     
     
if (get(findobj(gcf,'Tag','2DPCACheckbox'),'Value') && get(findobj(gcf,'Tag','3DPCACheckbox'),'Value'))
    disp('Please choose a single dimension'); 
    return;
end 

if (not(get(findobj(gcf,'Tag','2DPCACheckbox'),'Value')) && not(get(findobj(gcf,'Tag','3DPCACheckbox'),'Value')))
    disp('Please choose a dimension'); 
    return;
end 

if (get(findobj(gcf,'Tag','2DPCACheckbox'),'Value'))
    firstEig = 1;
    lastEig = 2;
end 

if (get(findobj(gcf,'Tag','3DPCACheckbox'),'Value'))
    firstEig = 1;
    lastEig = 3;
end 

if Dim_Depart < (lastEig - firstEig + 1)
    fprintf ('Data does not have enough dimensions.\n');
    return;
elseif Dim_Depart == (lastEig - firstEig + 1)
    fprintf ('Dimension not reduced.\n');
else
    fprintf ('Dimension reduced...\n');
end

if lastEig < Dim_Depart
  Val_inf = eigenvalues(lastEig) ;
else
  Val_inf = eigenvalues(Dim_Depart) - 1;
end
col_inf = (diag(D) >= Val_inf);
if firstEig > 1
  Val_sup = (eigenvalues(firstEig - 1) + eigenvalues(firstEig)) / 2;
else
  Val_sup = eigenvalues(1);
end
col_sup = diag(D) <= Val_sup;
col_select = col_inf & col_sup;
fprintf ('Selection of  [ %d ] dimensions.\n', sum (col_select));
if sum (col_select) ~= (lastEig - firstEig + 1),
  error ('The number of selected dimension is wrong.');
end
sumAll=sum(eigenvalues);
fprintf ('Percentage of largest eigenvalue held back [ %g ]%%\n',( eigenvalues(firstEig)/sumAll)*100);
fprintf ('Percentage of smallest eigenvalue held back[ %g ]%%\n', (eigenvalues(lastEig)/sumAll)*100);  

%information retenu
  sumUsed=sum(diag(D) .* (~col_select));
  retained = (100-(sumUsed / sumAll) * 100);
  fprintf('[ %g ] %% total eigenvalues hold back.\n', retained);  
E=E(:,col_select);
D=D';
%D=D(:,col_select);
D=D(col_select,:);
NewData=MultiColumnData*E;

%Create variable for use in save function
global PCADataToSave;
PCADataToSave = NewData;

if size(NewData,2)==1
 figure,
 plot(NewData);
elseif size(NewData,2)==2
    figure, hold on;
    plot(-1*NewData(1:193,1),-1*NewData(1:193,2),'ro','linewidth',3);
    plot(-1*NewData(194:625,1),-1*NewData(194:625,2),'go','linewidth',3);
    plot(-1*NewData(626:701,1),-1*NewData(626:701,2),'bo','linewidth',3);
elseif size(NewData,2)==3
    figure, hold on;
    scatter3(NewData(1:193,1),NewData(1:193,2),NewData(1:193,3),'r','filled');
    scatter3(NewData(194:625,1),NewData(194:625,2),NewData(194:625,3),'g','filled');
    scatter3(NewData(626:701,1),NewData(626:701,2),NewData(626:701,3),'b','filled');
    view(-30,10)
else
    disp('We''re not able to plot Data exceeding 3D\n');
end
        
    




