function save_pca()
global PCADataToSave;
%Save the last calculated PCA to excel
xlswrite('PCADimensionReductionResult.xls',PCADataToSave)
return;