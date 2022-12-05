function [] =  (fs, way, exp_num, pers_num, folder_name)


for k = 1 : exp_num
    
    for j = 1 : pers_num
        
        if folder_name == "Data"
            
            wayin = [way '\' folder_name '\wlk_'];
            cd (wayin + string(k));
            
            name = ['sub_' num2str(j) '.csv'];
            data = readtable(name);
            
            time  = table2array(data(end,1))/fs;
            Time = 0:(1/fs):time;
            accel = table2array(data(:,[1,11:13]));
            gyr  = table2array(data(:,[1,8:10]));
            
        elseif folder_name == "My_Data"
            
            wayin = [way '\My_data\wlk_'];
            cd (wayin + string(k));
            
            name = ['Gyr_sub_' num2str(j) '.csv']; %Гироскоп
            Name = ['Accel_sub_' num2str(j) '.csv']; %Акселерометр
            
            data = readtable(name);
            Data = readtable(Name);
            
            time  = table2array(data(end,1));
            Time = 0:(1/fs):time;
            gyr  = table2array(data(:,[1,2:4]));
            accel = table2array(Data(:,[1,2:4]));
        else
            disp('Error');
            return;
        end
        
        %УДАЛЕНИЕ ВЫБРОСОВ
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %длина выборки
        length_accel = length(accel);
        length_gyr = length(gyr);
        
        %10 процент удаления
        del_accel = ceil(length_accel*(10/100));
        del_gyr = ceil(length_gyr*(10/100));
        
        %удаление последних строк
        accel(length_accel - del_accel:length_accel,:) = [];
        gyr(length_gyr - del_gyr:length_gyr,:) = [];
        
        %удаление первых строк
        accel(1:del_accel,:) = [];
        gyr(1:del_gyr,:) = [];
        
        
        
        %УДАЛЕНИЕ ПО X
        
        %сортировка по x
        accel_sx = sortrows(accel,2);
        gyr_sx = sortrows(gyr,2);
        
        %длина выборки
        length_accel = length(accel_sx);
        length_gyr = length(gyr_sx);
        
        %1 процент удаления
        del_accel = ceil(length_accel*(1/100)); %(158)
        del_gyr = ceil(length_gyr*(1/100));
        
        %удаление последних строк
        accel_sx(length_accel - del_accel:length_accel,:) = [];
        gyr_sx(length_gyr - del_gyr:length_gyr,:) = [];
        
        %удаление первых строк
        accel_sx(1:del_accel,:) = [];
        gyr_sx(1:del_gyr,:) = [];
        
        
        
        %УДАЛЕНИЕ ПО Y
        
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
        
        
        %УДАЛЕНИЕ ПО Z
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
        
        
        accel_new = sortrows(accel_sz,1);  %<- данные акселерометра без выбросов
        gyr_new = sortrows(gyr_sz,1);      %<- данные гироскопа без выбросов
        
        
        
        
        
        
        
        
        %НОРМАЛИЗАЦИЯ
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %Площади раскачивания по данным гироскопа
        
        S = [0,0,0];
        
        if k == 1
            
            r1 = max(gyr_new(:,2));
            r2 = max(gyr_new(:,3));
            r3 = max(gyr_new(:,4));
            
            r_xy = [r1,r2];
            r_xz = [r1,r3];
            r_yz = [r2,r3];
            
            S_xy(j) = max(3.1415*(r_xy - [mean(gyr_new(:,2)),mean(gyr_new(:,3))]).^2);
            S_xz(j) = max(3.1415*(r_xz - [mean(gyr_new(:,2)),mean(gyr_new(:,4))]).^2);
            S_yz(j) = max(3.1415*(r_yz - [mean(gyr_new(:,3)),mean(gyr_new(:,4))]).^2);
            
        end
        
        if k > 1
            
            r12 = max(gyr_new(:,2));
            r22 = max(gyr_new(:,3));
            r32 = max(gyr_new(:,4));
            
            r_xy2 = [r12,r22];
            r_xz2 = [r12,r32];
            r_yz2 = [r22,r32];
            
            S_xy2(j) = max(3.1415*(r_xy2 - [mean(gyr_new(:,2)),mean(gyr_new(:,3))]).^2);
            S_xz2(j) = max(3.1415*(r_xz2 - [mean(gyr_new(:,2)),mean(gyr_new(:,4))]).^2);
            S_yz2(j) = max(3.1415*(r_yz2 - [mean(gyr_new(:,3)),mean(gyr_new(:,4))]).^2);
            
            S_xynor = S_xy2(j)/S_xy(j);
            S_xznor = S_xz2(j)/S_xz(j);
            S_yznor = S_yz2(j)/S_yz(j);
            
            S=[S_xynor,S_xznor,S_yznor];
            
        end
        
        
        
        
        %КОЛИЧЕСТВО ШАГОВ И КАДЕНС
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        x = accel_new(:,2);
        y = accel_new(:,3);
        z = accel_new(:,4);
        
        mag = sqrt(sum(x.^2 + y.^2 + z.^2, 2));        %-9.8
        
        magNoG = mag - mean(mag);
        
        minPeakHeight = std(magNoG);
        
        [pks,locs] = findpeaks(magNoG,'MINPEAKHEIGHT',minPeakHeight, 'MinPeakDistance', 10);  % 'MinPeakDistance', 27 - honor 10i
        
        numSteps = numel(pks);
        
        Cadence = numSteps/(time/60);
        
        
        
        
        
        %ВЫЧИСЛЕНИЕ СКОРОСТИ, РАССТОЯНИЯ И ДЛИНЫ ШАГА
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %Среднее ускорение
        mu_x = sum(accel_new(:,2))/length(accel_new(:,2));
        mu_y = sum(accel_new(:,3))/length(accel_new(:,3));
        mu_z = sum(accel_new(:,4))/length(accel_new(:,4));
        mu = sqrt(mu_x.^2+mu_y.^2+mu_z.^2); %-9.8 если измерения вместе g
        
        
        % velocity = 0; % On start
        % distance = 0; % On start
        % v(1) = 0;
        % s(1) = 0;
        %
        % for f = 2:length(z)
        %     % Integration
        %     v(f) = v(f-1) - mag(f-1)-(mag(f)+mag(f-1))/2;
        %     %Check if we stopped
        %     if(mag(f-1)==0 && mag(f)==0)
        %         v(f)=0;
        %     end
        %     %Check if velocity is under 0 (Not allowed)
        %     if(v(f) < 0)
        %         v(f)=0;
        %     end
        %     velocity = velocity + v(f);
        %     %Integration
        %     s(f) = s(f-1) + v(f-1)+(v(f)+v(f-1))/2;
        %     distance = distance + s(f);
        % end
        
        % gait_velocity = cumtrapz(accel_new(:,1), accel_new(:,2))
        % distance = cumtrapz(accel_new(:,1), gait_velocity)
        
        
        % distance = (velocity * time);
        % step_length = distance/ numSteps
        % gait_velocity
        
        %ВЫЧИСЛЕНИЕ СКОСА, ЭКСЦЕССА
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
        for dim = 1:3
            
            for i = 1:length(accel_new)
                
                first_sum_sk =  sum((accel_new(i,dim+1)- mu).^3);
                first_sum_ku = sum((accel_new(i,dim+1)- mu).^4);
                second_sum = sum((accel_new(i,dim+1)- mu).^2);
                
            end
            
            Skew(dim) = ((1/length(accel_new))* first_sum_sk)/((1/length(accel_new)*second_sum)^(3/2));
            Kurtosis(dim) = ((1/length(accel_new))* first_sum_ku)/((1/length(accel_new)*second_sum)^(2));
        end
        
        
        %ЗАПИСЬ В ТАБЛИЦУ SOBER.CSV
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        cd (way)
        
        shapka   = {'Cadence', 'XZ Swey Area', 'YZ Swey Area', 'XY Swey Area', 'Skew_z', 'Kurtosis_z', 'class'};
        
        if folder_name == "Data"
            
            fileName = 'sober.csv';
            
            if k ~= 1
                T2 = table(Cadence, S(:,1), S(:,2), S(:,3), Skew(:,3),Kurtosis(:,3), 1, 'VariableNames', shapka);
                writetable(T2,fileName,'WriteMode','append');
            end
            
        elseif folder_name == "My_Data"
            
            
            fileName = 'alchogolic.csv';
            
            if k ~= 1
                T2 = table(Cadence, S(:,1), S(:,2), S(:,3), Skew(:,3), Kurtosis(:,3), 0, 'VariableNames', shapka);
                writetable(T2,fileName,'WriteMode','append')
            end
        end
        
    end
    
end

end


