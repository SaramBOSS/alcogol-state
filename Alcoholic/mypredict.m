function ypred = mypredict(tbl)
%#function fitctree
load mymodel.m;
ypred = trainedModel.predictFcn(tbl);
end