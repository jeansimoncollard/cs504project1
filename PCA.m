function [E,D,NewData] = PCA(Data)
lastEig = size(Data,1); 
firstEig = 1; 
Dim_Depart = size (Data, 2);
Data=zscore(Data);
disp('covariances calculation in process...\n'); 
covarianceMatrix = cov(Data);
[E, D] = eig (covarianceMatrix);
Tolerance = 1e-6;
maxLastEig = sum (diag (D) > Tolerance);
if maxLastEig == 0,
  fprinf('Eigenvalues of the covariance matrix are small against the tolerency [ %g ].\n', Tolerance);
end
eigenvalues = sort(diag(D),'descend');
      graphe_VP = figure;
      bar(eigenvalues);
      title('Eigenvalues');
      
     test_VP=0;
     
       while test_VP == 0
          firstEig = input('index of the great eigenvalue to hold back? (1) ');
          lastEig = input(['index of the small eigenvalue to hold back.? (' ...
                    int2str(Dim_Depart) ') ']);
         if isempty(firstEig), firstEig = 1;end
         if isempty(lastEig), lastEig = Dim_Depart;end
         test_VP = 1;
         if lastEig < 1 || lastEig > Dim_Depart
            fprintf('Illegal number for the last eigenvalue.\n');
            test_VP= 0;
         end
          if firstEig < 1 || firstEig > lastEig
          fprintf('Illegal number for the first eigenvalue.\n');
          test_VP = 0;
          end
       end
 close(graphe_VP)
 
      if Dim_Depart == (lastEig - firstEig + 1)
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
NewData=Data*E;
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
        
    




