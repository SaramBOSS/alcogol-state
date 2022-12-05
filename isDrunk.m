function I = isDrunk(accCsvPath,gyroCsvPath, resultPath)

%addpath('./Alcoholic');

%addpath('./Alcoholic/Test/');

I = 'res';
%wd '/home/lab/Рабочий стол/amalthea_server/amalthea_server/amalthea/libs/drunk_state_recognition/Alcoholic'
%accTable = readtableaccCsvPath)
%gyroTable = readtable(gyroCsvPath)

%  accCsvPath = '/home/lab/Рабочий стол/amalthea_server/amalthea_server/amalthea/libs/drunk_state_recognition/data_acc.csv';
% % accCsvPath = '/home/lab/Рабочий стол/amalthea_server/amalthea_server/amalthea/libs/drunk_state_recognition/data_acc_1663314881.csv';
% gyroCsvPath = '/home/lab/Рабочий стол/amalthea_server/amalthea_server/amalthea/libs/drunk_state_recognition/data_gyro_1663314881.csv';
% gyroCsvPath = '/home/lab/Рабочий стол/amalthea_server/amalthea_server/amalthea/libs/drunk_state_recognition/data_gyro.csv';
%  resultPath = '/home/lab/Рабочий стол/amalthea_server/amalthea_server/amalthea/libs/drunk_state_recognition/Test.txt';

isTrained = true; %true = модель уже обучена, false = модель не обучена

warning('off');
rmpath('ModifiedAndSavedVarnames');

if(isTrained == false)
    
    fs = 50;
    way = '/home/lab/Рабочий стол/amalthea_server/amalthea_server/amalthea/libs/drunk_state_recognition/Alcoholic';
    delete 'sober.csv'
    delete 'alchogolic.csv'
    
    Getting_signs(fs, way, 3, 24, 'Data')
    Getting_signs(fs, way, 4, 4, 'My_Data')
    
    soberData = readtable('sober.csv');
    alchogolicData = readtable('alchogolic.csv');
    Training_data = [soberData; alchogolicData];
    
    [trainedClassifier, validationAccuracy] = trainClassifier(Training_data);
    
    save('trainedClassifierSave.mat', 'trainedClassifier');
    
else
    
   
    
    load('trainedClassifiersave.mat', 'trainedClassifier');
    
    dataGyr= readtable(gyroCsvPath);
    dataAcc= readtable(accCsvPath);
    flag = 0;
    if (exist('Norm.mat','file') == 0)
        for n = 1:table2array(dataGyr(end,1))
            if (table2array(dataGyr(n,2)) - table2array(dataGyr(2,2))) > 10000
                normalization(dataGyr(1:n,:));
                dataGyr(1:n,:) = [];
                flag =  1;
                break;
            end
        end
        if(flag == 0)
            I = 2;
             return;
        end
    end

    try
    load('Length.mat', 'len');
    catch
    len = dataGyr(end, 1);
    save('Length.mat', 'len');
    I = 3;
    return;
    end
    
    lena = dataGyr(end, 1);
    sizeOfPack = table2array(lena) - table2array(len); 
    
    if(table2array(len) ~= NaN && sizeOfPack > 0)
        
        GyrPack = dataGyr((end - sizeOfPack):end, 1:5);
        AccPack = dataAcc((end - sizeOfPack):end, 1:5);     

    else
        I = 4;
        return;
    end
    
    Test = test(AccPack, GyrPack);
    len = GyrPack(end, 1);
    save('Length.mat', 'len');
    
    yfit = trainedClassifier.predictFcn(Test);
    
    yfit = 1 - yfit;
    
    I = num2str(yfit);
    fid = fopen(resultPath, 'w');
    fwrite(fid,I);
    fclose(fid);
end