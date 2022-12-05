function [] = main(accCsvPath, gyroCsvPath, resultPath)

%way = 'C:\Users\VSYakunin\Desktop\Alcoholic';
fs = 50;  %50Hz iphone 6s
isTrained = true; %true = модель уже обучена, false = модель не обучена


if(isTrained == false)
    
    delete 'sober.csv'
    delete 'alchogolic.csv'
    
    Getting_signs(fs, way, 3, 24, 'Data')
    Getting_signs(fs, way, 4, 4, 'My_Data' )
    
    cd (way);
    
    soberData = readtable('sober.csv');
    alchogolicData = readtable('alchogolic.csv');
    Training_data = [soberData; alchogolicData];
    
    [trainedClassifier, validationAccuracy] = trainClassifier(Training_data);
   
    save('trainedClassifierSave.mat', 'trainedClassifier');
    
else
    delete 'Test.csv'
    
    load('trainedClassifierSave.mat', 'trainedClassifier');
    
    norm(gyroCsvPath);
    test(accCsvPath, gyroCsvPath, resultPath);
    
    test = readtable('Test.csv');
    yfit = trainedClassifier.predictFcn(test);
    
    
    yfit
end
