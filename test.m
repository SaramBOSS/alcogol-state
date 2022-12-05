function T2 = test(data, Data)
   
% 
% data = readtable(gyroCsvPath);
% Data = readtable(accCsvPath);

try
time  = table2array(data(end,1));
gyr  = table2array(data(:,[1,3:5]));
accel = table2array(Data(:,[1,3:5])); 
catch
    a = data(end, 1)
end




                            %ÓÄÀËÅÍÈÅ ÂÛÁÐÎÑÎÂ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            
%äëèíà âûáîðêè 
length_accel = length(accel); 
length_gyr = length(gyr);

%10 ïðîöåíò óäàëåíèÿ
del_accel = ceil(length_accel*(10/100)); 
del_gyr = ceil(length_gyr*(10/100));

%óäàëåíèå ïîñëåäíèõ ñòðîê 
accel(length_accel - del_accel:length_accel,:) = [];
gyr(length_gyr - del_gyr:length_gyr,:) = []; 

%óäàëåíèå ïåðâûõ ñòðîê
accel(1:del_accel,:) = []; 
gyr(1:del_gyr,:) = [];



                            %ÓÄÀËÅÍÈÅ ÏÎ X
%ñîðòèðîâêà ïî x
accel_sx = sortrows(accel,2); 
gyr_sx = sortrows(gyr,2);

%äëèíà âûáîðêè 
length_accel = length(accel_sx); 
length_gyr = length(gyr_sx);

%1 ïðîöåíò óäàëåíèÿ
del_accel = ceil(length_accel*(1/100)); %(158) 
del_gyr = ceil(length_gyr*(1/100));

%óäàëåíèå ïîñëåäíèõ ñòðîê 
accel_sx(length_accel - del_accel:length_accel,:) = [];
gyr_sx(length_gyr - del_gyr:length_gyr,:) = []; 

%óäàëåíèå ïåðâûõ ñòðîê
accel_sx(1:del_accel,:) = []; 
gyr_sx(1:del_gyr,:) = [];



                           %ÓÄÀËÅÍÈÅ ÏÎ Y
accel_sy = sortrows(accel_sx,3); 
gyr_sy = sortrows(gyr_sx,3);

length_accel = length(accel_sy); 
length_gyr = length(gyr_sy);

del_accel = ceil(length_accel*(1/100));  
del_gyr = ceil(length_gyr*(1/100));

accel_sy(length_accel - del_accel:length_accel,:) = [];
gyr_sy(length_gyr - del_gyr:length_gyr,:) = []; 

accel_sy(1:del_accel,:) = []; 
gyr_sy(1:del_gyr,:) = [];


                           %ÓÄÀËÅÍÈÅ ÏÎ Z
accel_sz = sortrows(accel_sy,4); 
gyr_sz = sortrows(gyr_sy,4);

length_accel = length(accel_sz); 
length_gyr = length(gyr_sz);

del_accel = ceil(length_accel*(1/100));  
del_gyr = ceil(length_gyr*(1/100));

accel_sz(length_accel - del_accel:length_accel,:) = [];
gyr_sz(length_gyr - del_gyr:length_gyr,:) = [];

accel_sz(1:del_accel,:) = []; 
gyr_sz(1:del_gyr,:) = [];


accel_new = sortrows(accel_sz,1);  %<- äàííûå àêñåëåðîìåòðà áåç âûáðîñîâ
gyr_new = sortrows(gyr_sz,1);      %<- äàííûå ãèðîñêîïà áåç âûáðîñîâ






                             %ÍÎÐÌÀËÈÇÀÖÈß 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                            

%Ïëîùàäè ðàñêà÷èâàíèÿ ïî äàííûì ãèðîñêîïà 

% norm = table2
% norm2 = readtabarray(norm2);
load('Norm.mat');
normArr = table2array(normkoef);
try
r1 = max(gyr_new(:,2));
r2 = max(gyr_new(:,3));
r3 = max(gyr_new(:,4));
catch
   gyr_new = cell2mar(gyr_new);
   r1 = max(gyr_new(:,2));
   r2 = max(gyr_new(:,3));
   r3 = max(gyr_new(:,4));
end
r_xy = [r1,r2];
r_xz = [r1,r3];
r_yz = [r2,r3];

S_xy = max(3.1415*(r_xy - [mean(gyr_new(:,2)),mean(gyr_new(:,3))]).^2);
S_xz = max(3.1415*(r_xz - [mean(gyr_new(:,2)),mean(gyr_new(:,4))]).^2);
S_yz = max(3.1415*(r_yz - [mean(gyr_new(:,3)),mean(gyr_new(:,4))]).^2);

S_xynor = S_xy/normArr(:,1);
S_xznor = S_xz/normArr(:,2);
S_yznor = S_yz/normArr(:,3);

S=[S_xynor,S_xznor,S_yznor];






                         %ÊÎËÈ×ÅÑÒÂÎ ØÀÃÎÂ È ÊÀÄÅÍÑ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x = accel_new(:,2); 
y = accel_new(:,3); 
z = accel_new(:,4); 

mag = sqrt(sum(x.^2 + y.^2 + z.^2, 2));        %-9.8 

magNoG = mag - mean(mag);

minPeakHeight = std(magNoG);   

[pks,locs] = findpeaks(magNoG,'MINPEAKHEIGHT',minPeakHeight,'MinPeakDistance', 10);  % 'MinPeakDistance', 27 - honor 10i

numSteps = numel(pks);

Cadence = numSteps/(time/60);





               %ÂÛ×ÈÑËÅÍÈÅ ÑÊÎÐÎÑÒÈ, ÐÀÑÑÒÎßÍÈß È ÄËÈÍÛ ØÀÃÀ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%Ñðåäíåå óñêîðåíèå 
mu_x = sum(accel_new(:,2))/length(accel_new(:,2));
mu_y = sum(accel_new(:,3))/length(accel_new(:,3));
mu_z = sum(accel_new(:,4))/length(accel_new(:,4));
mu = sqrt(mu_x.^2+mu_y.^2+mu_z.^2); %-9.8 åñëè èçìåðåíèÿ âìåñòå g 




%velocity = 0; % On start
%distance = 0; % On start
%v(1) = 0;
%s(1) = 0;

%for f = 2:length(z) 
%    % Integration
%   v(f) = v(f-1) - mag(f-1)-(mag(f)+mag(f-1))/2;
%    %Check if we stopped
%    if(mag(f-1)==0 && mag(f)==0)
%        v(f)=0;
%    end
%    %Check if velocity is under 0 (Not allowed)
%    if(v(f) < 0)
%        v(f)=0;
%    end
%    velocity = velocity + v(f);
%    %Integration
%    s(f) = s(f-1) + v(f-1)+(v(f)+v(f-1))/2;
%    distance = distance + s(f);
%end

% gait_velocity = cumtrapz(accel_new(:,1), accel_new(:,2))
% distance = cumtrapz(accel_new(:,1), gait_velocity)


% distance = (velocity * time); 
% step_length = distance/ numSteps
% velocity
% gait_velocity = velocity(end);




                      %ÂÛ×ÈÑËÅÍÈÅ ÑÊÎÑÀ, ÝÊÑÖÅÑÑÀ 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


for dim = 1:3
    
    for i = 1:length(accel_new)
        
        first_sum_sk =  sum((accel_new(i,dim+1)- mu)^3);
        first_sum_ku = sum((accel_new(i,dim+1)- mu)^4);
        second_sum = sum((accel_new(i,dim+1)- mu)^2);
        
    end
    
    Skew(dim) = ((1/length(accel_new))* first_sum_sk)/((1/length(accel_new)*second_sum)^(3/2));
    Kurtosis(dim) = ((1/length(accel_new))* first_sum_ku)/((1/length(accel_new)*second_sum)^(2));
end


                          %ÇÀÏÈÑÜ Â ÒÀÁËÈÖÓ alchogolic.CSV  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

shapka   = {'Cadence', 'XZSweyArea', 'YZSweyArea', 'XYSweyArea', 'Skew_z', 'Kurtosis_z', 'class'};
%fileName = 'Test.csv';


T2 = table(Cadence, S(:,1), S(:,2), S(:,3), Skew(:,3), Kurtosis(:,3), NaN, 'VariableNames', shapka);
%writetable(T2,fileName,'WriteMode','append')



end
   


