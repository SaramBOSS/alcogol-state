function table = parseCsvString(csvString)

%csvStr = ['timestamp,acc1,acc2,acc3,gyro1,gyro2,gyro3', newline, ..

lines = split(csvString, '\n');
data = [];
for i = 1:length(lines)
    line = lines(i);
    cellStrNum = split(line, ',')';
    %cellStrNum = str2num(cellStrNum)
    stringArr = string(cellStrNum);
    numArr = str2double(stringArr);
    numArr2 = [{numArr(1)}, {numArr(5)}, {numArr(6)}, {numArr(7)}]
    %dataStr = [cellStrNum(1), cellStrNum(5), cellStrNum(6), cellStrNum(7)];
    %dataStr = [numArr2(1), numArr2(5), numArr2(6), numArr2(7)];
    data = [data; numArr2];
    %nums = str2num(strNum)
end
%HeaderFmt = '%s%s%s%s%s%s%s';
%DataFmt = '%f%f%f%f%f%f%f';
%Fields = cellfun(@(x) x{1}, textscan(csvStr, HeaderFmt, 1, 'Delimiter', ','), 'un', 0);
%Data = textscan(csvStr, DataFmt, 'EndOfLine', '\r\n', 'Delimiter', ',');
%Data2 = textscan(csvStr, DataFmt, 'EndOfLine', '\r\n', 'Delimiter', ',');
%textscan(csvStr, DataFmt, 'Headerlines', 1, 'EndOfLine', newline, 'Delimiter', ',');
%textscan(csvStr, DataFmt, 'Headerlines', 1, 'EndOfLine', newline, 'Delimiter', ',');

varNames = {'timestamp','gyro1','gyro2','gyro3'};
table = cell2table(data, 'VariableNames', varNames)
%Table = table(data, 'VariableNames', varNames);


% HeaderFmt = '%s%s%s%s%s%s';
% DataFmt = '%D%f%f%f%f%f';
% Fields = cellfun(@(x) x{1}, textscan(TextStr, HeaderFmt, 1, 'Delimiter', ','), 'un', 0);
% Data = textscan(TextStr, DataFmt, 'Headerlines', 1, 'EndOfLine', newline, 'Delimiter', ',');
% Table = table(Data{:}, 'VariableNames', Fields);

end