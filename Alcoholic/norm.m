function [] = normalization(gyroCsvPath)




data = readtable(gyroCsvPath);

gyr  = table2array(data(:,[1,3:5]));
 




                            %ÓÄÀËÅÍÈÅ ÂÛÁÐÎÑÎÂ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            
%äëèíà âûáîðêè 
length_gyr = length(gyr);

%10 ïðîöåíò óäàëåíèÿ

del_gyr = ceil(length_gyr*(10/100));

%óäàëåíèå ïîñëåäíèõ ñòðîê 

gyr(length_gyr - del_gyr:length_gyr,:) = []; 

%óäàëåíèå ïåðâûõ ñòðîê

gyr(1:del_gyr,:) = [];



                            %ÓÄÀËÅÍÈÅ ÏÎ X
%ñîðòèðîâêà ïî x
 
gyr_sx = sortrows(gyr,2);

%äëèíà âûáîðêè 

length_gyr = length(gyr_sx);

%1 ïðîöåíò óäàëåíèÿ

del_gyr = ceil(length_gyr*(1/100));

%óäàëåíèå ïîñëåäíèõ ñòðîê 

gyr_sx(length_gyr - del_gyr:length_gyr,:) = []; 

%óäàëåíèå ïåðâûõ ñòðîê

gyr_sx(1:del_gyr,:) = [];



                           %ÓÄÀËÅÍÈÅ ÏÎ Y

gyr_sy = sortrows(gyr_sx,3);

length_gyr = length(gyr_sy);

del_gyr = ceil(length_gyr*(1/100));

gyr_sy(length_gyr - del_gyr:length_gyr,:) = []; 

gyr_sy(1:del_gyr,:) = [];


                           %ÓÄÀËÅÍÈÅ ÏÎ Z

gyr_sz = sortrows(gyr_sy,4);

length_gyr = length(gyr_sz);

del_gyr = ceil(length_gyr*(1/100));

gyr_sz(length_gyr - del_gyr:length_gyr,:) = [];

gyr_sz(1:del_gyr,:) = [];

gyr_new = sortrows(gyr_sz,1);      %<- äàííûå ãèðîñêîïà áåç âûáðîñîâ






                             %ÍÎÐÌÀËÈÇÀÖÈß 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                            

%Ïëîùàäè ðàñêà÷èâàíèÿ ïî äàííûì ãèðîñêîïà 
 

r1 = max(gyr_new(:,2));
r2 = max(gyr_new(:,3));
r3 = max(gyr_new(:,4));

r_xy = [r1,r2];
r_xz = [r1,r3];
r_yz = [r2,r3];

S_xy = max(3.1415*(r_xy - [mean(gyr_new(:,2)),mean(gyr_new(:,3))]).^2);
S_xz = max(3.1415*(r_xz - [mean(gyr_new(:,2)),mean(gyr_new(:,3))]).^2);
S_yz = max(3.1415*(r_yz - [mean(gyr_new(:,3)),mean(gyr_new(:,4))]).^2);







                          %ÇÀÏÈÑÜ Â ÒÀÁËÈÖÓ alchogolic.CSV  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

shapka   = {'XZ Swey Area', 'YZ Swey Area', 'XY Swey Area'};
fileName = 'Norm.csv';


T2 = table(S_xy, S_xz, S_yz, 'VariableNames', shapka);
writetable(T2,fileName)


end
   


