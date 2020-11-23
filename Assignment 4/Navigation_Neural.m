clear; close all; clc;

%% Data import
% get all file names
filenames = dir('data_dir\*');
filenames = {filenames.name};
% leave only matlab file names
not_match = cellfun(@isempty, regexp(filenames,'.mat'));
filenames = filenames(~not_match);

% allocate data structure
Data = struct();

% boolean variable
q = 0;

% allocate titled figure for each type of plot
hPaths = figure('units','normalized', 'Position', [0 0.2 1 0.6]);
sgtitle("Rat's path and AP track");

hHeat = figure('units','normalized', 'Position', [0 0.2 1 0.6]);
sgtitle("Rat's AP heatmap");

hDirect = figure('units','normalized', 'Position', [0 0.1 1 0.8]);
sgtitle("Rat's AP as a function of head direction");

for n = 1:length(filenames)
    % load data
    Data.(sprintf('Sub%d',n)) = load(['data_dir\' filenames{n}]);
    % extract frequency sample
    fs = Data.(sprintf('Sub%d',n)).sampleRate;
    
    %% paragraph 4 - set random data
    % the first condition is elaborated, the second isn't, similar method.
    % the method is used in order to keep the randomized time distribution
    % similar to original data.
    if ismember('spiketrain', fieldnames(Data.(sprintf('Sub%d',n))))
        % get the location of all APs
        AP = find(Data.(sprintf('Sub%d',n)).spiketrain == 1);
        % allocate an arry for randomized data
        newAP = zeros(size(Data.(sprintf('Sub%d',n)).spiketrain));
        % extract the diffrences between each AP
        intSpkInterval = diff(AP);
        % sum up the amount of total APs
        amountAP = sum(Data.(sprintf('Sub%d',n)).spiketrain == 1);
        % permutate the order of gaps
        gaps = randperm(length(intSpkInterval));
        gaps = intSpkInterval(gaps);
        % return gaps into indices vector
        gaps = cumsum(gaps);
        % put APs in those locations
        newAP(gaps) = 1;
    else
        AP1 = find(Data.(sprintf('Sub%d',n)).spiketrain1 == 1);
        newAP1 = zeros(size(Data.(sprintf('Sub%d',n)).spiketrain1));
        intSpkInterval1 = diff(AP1);
        amountAP1 = sum(Data.(sprintf('Sub%d',n)).spiketrain1 == 1);
        gaps1 = randperm(length(intSpkInterval1));
        gaps1 = intSpkInterval(gaps1);
        gaps1 = cumsum(gaps1);
        newAP1(gaps1) = 1;
        
        AP2 = find(Data.(sprintf('Sub%d',n)).spiketrain2 == 1);
        newAP2 = zeros(size(Data.(sprintf('Sub%d',n)).spiketrain2));
        intSpkInterval2 = diff(AP2);
        amountAP2 = sum(Data.(sprintf('Sub%d',n)).spiketrain2 == 1);
        gaps2 = randperm(length(intSpkInterval2));
        gaps2 = intSpkInterval2(gaps2);
        gaps2 = cumsum(gaps2);
        newAP2(gaps2) = 1;
    end
    
    %% paragraph 1
    % in the first condition, we plot the location of the rat in each
    % time-stamp, and scatter the location of the APs on its track for the
    % first four actual and randomized data. in the second condition we do
    % so also, it is separated because we use the variable names, and they
    % are different.
    if ismember('spiketrain', fieldnames(Data.(sprintf('Sub%d',n))))
        figure(hPaths); hold on;
        subplot(2,6,n);
        plot(Data.(sprintf('Sub%d',n)).posx,Data.(sprintf('Sub%d',n)).posy);hold on;
        scatter(Data.(sprintf('Sub%d',n)).posx(Data.(sprintf('Sub%d',n)).spiketrain == 1), ...
            Data.(sprintf('Sub%d',n)).posy(Data.(sprintf('Sub%d',n)).spiketrain == 1), ...
            3, 'filled');
        xticks([]);
        yticks([]);
        if n == 1
            ylabel('Original Data', 'FontSize', 14);
        end
        title(['cell #' num2str(n)], 'FontSize', 13);
        
        subplot(2,6,n+6);
        plot(Data.(sprintf('Sub%d',n)).posx,Data.(sprintf('Sub%d',n)).posy);hold on;
        scatter(Data.(sprintf('Sub%d',n)).posx(newAP == 1), ...
            Data.(sprintf('Sub%d',n)).posy(newAP == 1), ...
            3, 'filled');
        xticks([]);
        yticks([]);
        if n == 1
            ylabel('Randomized Data', 'FontSize', 14);
        end
        
    else
        % second condition
        figure(hPaths);hold on;
        subplot(2,6,n);
        plot(Data.(sprintf('Sub%d',n)).posx,Data.(sprintf('Sub%d',n)).posy);hold on;
        scatter(Data.(sprintf('Sub%d',n)).posx(Data.(sprintf('Sub%d',n)).spiketrain1 == 1), ...
            Data.(sprintf('Sub%d',n)).posy(Data.(sprintf('Sub%d',n)).spiketrain1 == 1), ...
            3, 'filled');
        xticks([]);
        yticks([]);
        title(['cell #' num2str(n)], 'FontSize', 13);
        
        subplot(2,6,n+6);
        plot(Data.(sprintf('Sub%d',n)).posx,Data.(sprintf('Sub%d',n)).posy);hold on;
        scatter(Data.(sprintf('Sub%d',n)).posx(newAP1 == 1), ...
            Data.(sprintf('Sub%d',n)).posy(newAP1 == 1), ...
            3, 'filled');
        xticks([]);
        yticks([]);
        
        
        subplot(2,6,n+1);
        plot(Data.(sprintf('Sub%d',n)).posx,Data.(sprintf('Sub%d',n)).posy);hold on;
        scatter(Data.(sprintf('Sub%d',n)).posx(Data.(sprintf('Sub%d',n)).spiketrain2 == 1), ...
            Data.(sprintf('Sub%d',n)).posy(Data.(sprintf('Sub%d',n)).spiketrain2 == 1), ...
            3, 'filled');
        xticks([]);
        yticks([]);
        title(['cell #' num2str(n+1)], 'FontSize', 13);
        
        subplot(2,6,n+7);
        plot(Data.(sprintf('Sub%d',n)).posx,Data.(sprintf('Sub%d',n)).posy);hold on;
        scatter(Data.(sprintf('Sub%d',n)).posx(newAP2 == 1), ...
            Data.(sprintf('Sub%d',n)).posy(newAP2 == 1), ...
            3, 'filled');
        xticks([]);
        yticks([]);
    end
    
    %% paragraph 2
    
    % the first condition is elaborated, the second isn't, similar method.
    
    if ismember('spiketrain', fieldnames(Data.(sprintf('Sub%d',n))))
        % we find the locations of actual and randomized APs
        Loc1 = find(Data.(sprintf('Sub%d',n)).spiketrain == 1);
        randLoc1 = find(newAP == 1);
        % we collect the location of the rat during those APs, in fifth the
        % size of original experiment field, in order the enlarge the
        % effect of each AP.
        X = round(Data.(sprintf('Sub%d',n)).posx(Loc1)/5);
        Y = round(Data.(sprintf('Sub%d',n)).posy(Loc1)/5);
        
        Xtime = round(Data.(sprintf('Sub%d',n)).posx/5);
        Ytime = round(Data.(sprintf('Sub%d',n)).posy/5);
        
        randX = round(Data.(sprintf('Sub%d',n)).posx(randLoc1)/5);
        randY = round(Data.(sprintf('Sub%d',n)).posy(randLoc1)/5);
        
        % allocate arraies for spatial sum up
        totSpace = zeros(max(Y),max(X));
        randTotSpace = zeros(max(Y),max(X));
        
        % save number of APs in each spatial location (fifth the size of
        % original size)
        for x = 1:max(X)
            placeX = X == x;
            
            randPlaceX = randX == x;
            for y = 1:max(Y)
                placeY = Y == y;
                places = placeX + placeY;
                
                placeTime = sum(Xtime == x & Ytime == y)/fs;
                if placeTime > 0
                    totSpace(y,x) = sum(places == 2)./placeTime;
                else
                    totSpace(y,x) = 0;
                end
                
                
                randPlaceY = randY == y;
                randPlaces = randPlaceX + randPlaceY;

                if placeTime > 0
                    randTotSpace(y,x) = sum(randPlaces == 2)/placeTime;
                else
                    randTotSpace(y,x) = 0;
                end
            end
        end
        
        % Define data
        data = totSpace;
        % Define integer grid of coordinates for the above data
        [Xdat,Ydat] = meshgrid(1:size(data,2), 1:size(data,1));
        % Define a finer grid of points
        [Xdat2,Ydat2] = meshgrid(1:0.01:size(data,2), 1:0.01:size(data,1));
        % Interpolate the data and show the output
        outData = interp2(Xdat, Ydat, data, Xdat2, Ydat2, 'linear');
        
        figure(hHeat);hold on;
        subplot(2,6,n);
        imagesc(outData);
        g = gca;
        g.YDir = 'normal';
        xticks([]);
        yticks([]);
        caxis([0 25]);
        if n == 1
            ylabel('Original Data', 'FontSize', 14);
        end
        title(['cell #' num2str(n)], 'FontSize', 13);
        
        % Random
        % Define your data
        data = randTotSpace;
        % Define integer grid of coordinates for the above data
        [Xdat,Ydat] = meshgrid(1:size(data,2), 1:size(data,1));
        % Define a finer grid of points
        [Xdat2,Ydat2] = meshgrid(1:0.01:size(data,2), 1:0.01:size(data,1));
        % Interpolate the data and show the output
        outData = interp2(Xdat, Ydat, data, Xdat2, Ydat2, 'linear');
        
        subplot(2,6,n+6);
        imagesc(outData);
        g = gca;
        g.YDir = 'normal';
        xticks([]);
        yticks([]);
        caxis([0 25]);
        if n == 1
            ylabel('Randomized Data', 'FontSize', 14);
        end
        grid off;
        %END RANDOM
        
    else
        % second condition
        Loc1 = find(Data.(sprintf('Sub%d',n)).spiketrain1 == 1);
        Loc2 = find(Data.(sprintf('Sub%d',n)).spiketrain2 == 1);
        
        randLoc1 = find(newAP == 1);
        randLoc2 = find(newAP2 == 1);
        
        X = round(Data.(sprintf('Sub%d',n)).posx(Loc1)/5);
        Y = round(Data.(sprintf('Sub%d',n)).posy(Loc1)/5);
        X2 = round(Data.(sprintf('Sub%d',n)).posx(Loc2)/5);
        Y2 = round(Data.(sprintf('Sub%d',n)).posy(Loc2)/5);
        
        Xtime = round(Data.(sprintf('Sub%d',n)).posx/5);
        Ytime = round(Data.(sprintf('Sub%d',n)).posy/5);
        
        randX = round(Data.(sprintf('Sub%d',n)).posx(randLoc1)/5);
        randY = round(Data.(sprintf('Sub%d',n)).posy(randLoc1)/5);
        randX2 = round(Data.(sprintf('Sub%d',n)).posx(randLoc2)/5);
        randY2 = round(Data.(sprintf('Sub%d',n)).posy(randLoc2)/5);
        
        totSpace = zeros(20,20);
        totSpace2 = zeros(20,20);
        
        randTotSpace = zeros(20,20);
        randTotSpace2 = zeros(20,20);
        
        for x = 1:max(X)
            placeX = X == x;
            placeX2 = X2 == x;
            
            randPlaceX = randX == x;
            randPlaceX2 = randX2 == x;
            for y = 1:max(Y)
                placeY = Y == y;
                places = placeX + placeY;
                
                placeTime = sum(Xtime == x & Ytime == y)/fs;
                if placeTime > 0
                    totSpace(y,x) = sum(places == 2)./placeTime;
                else
                    totSpace(y,x) = 0;
                end
                
                placeY2 = Y2 == y;
                places2 = placeX2 + placeY2;
                
                placeTime = sum(Xtime == x & Ytime == y)/fs;
                if placeTime > 0
                    totSpace2(y,x) = sum(places2 == 2)./placeTime;
                else
                    totSpace2(y,x) = 0;
                end
                
                randPlaceY = randY == y;
                randPlaces = randPlaceX + randPlaceY;
                
                placeTime = sum(Xtime == x & Ytime == y)/fs;
                if placeTime > 0
                    randTotSpace(y,x) = sum(randPlaces == 2)./placeTime;
                else
                    randTotSpace(y,x) = 0;
                end
                
                randPlaceY2 = randY2 == y;
                randPlaces2 = randPlaceX2 + randPlaceY2;
                
                placeTime = sum(Xtime == x & Ytime == y)/fs;
                if placeTime > 0
                    randTotSpace2(y,x) = sum(randPlaces2 == 2)./placeTime;
                else
                    randTotSpace2(y,x) = 0;
                end
            end
        end
        
        data = totSpace;
        [Xdat,Ydat] = meshgrid(1:size(data,2), 1:size(data,1));
        [Xdat2,Ydat2] = meshgrid(1:0.01:size(data,2), 1:0.01:size(data,1));
        outData = interp2(Xdat, Ydat, data, Xdat2, Ydat2, 'linear');
        
        figure(hHeat);
        subplot(2,6,n);
        imagesc(outData);
        g = gca;
        g.YDir = 'normal';
        axis off;
        grid off;
        caxis([0 25]);
        title(['cell #' num2str(n)], 'FontSize', 13);
        
        data = totSpace2;
        [Xdat,Ydat] = meshgrid(1:size(data,2), 1:size(data,1));
        [Xdat2,Ydat2] = meshgrid(1:0.01:size(data,2), 1:0.01:size(data,1));
        outData = interp2(Xdat, Ydat, data, Xdat2, Ydat2, 'linear');
        
        subplot(2,6,n+1);
        imagesc(outData);
        g = gca;
        g.YDir = 'normal';
        axis off;
        grid off;
        caxis([0 25]);
        title(['cell #' num2str(n+1)], 'FontSize', 13);
        
        %RANDOM
        data = randTotSpace;
        [Xdat,Ydat] = meshgrid(1:size(data,2), 1:size(data,1));
        [Xdat2,Ydat2] = meshgrid(1:0.01:size(data,2), 1:0.01:size(data,1));
        outData = interp2(Xdat, Ydat, data, Xdat2, Ydat2, 'linear');
        
        subplot(2,6,n+6);
        imagesc(outData);
        g = gca;
        g.YDir = 'normal';
        axis off;
        grid off;
        caxis([0 25]);
        
        data = randTotSpace2;
        [Xdat,Ydat] = meshgrid(1:size(data,2), 1:size(data,1));
        [Xdat2,Ydat2] = meshgrid(1:0.01:size(data,2), 1:0.01:size(data,1));
        outData = interp2(Xdat, Ydat, data, Xdat2, Ydat2, 'linear');
        
        subplot(2,6,n+7);
        imagesc(outData);
        g = gca;
        g.YDir = 'normal';
        axis off;
        grid off;
        caxis([0 25]);
        %END RANDOM
    end
    
    %% paragraph 3
    % set degree and radian parameters
    degrees = 0:360;
    radians = deg2rad(degrees);
    % extract head direction data
    degVec = round(rad2deg(Data.(sprintf('Sub%d',n)).headDirection));
    % allocate arraies for spike count by head direction
    vals = zeros(1,361);
    extravals = zeros(1,361);
    
    randvals = zeros(1,361);
    randextravals = zeros(1,361);
    % sum up spike counts for each type of data variables
    if ismember('spiketrain', fieldnames(Data.(sprintf('Sub%d',n))))
        for a = 0:360
            direcTime = sum(degVec == a)/fs;
            
            vals(a+1) = sum(Data.(sprintf('Sub%d',n)).spiketrain(degVec == a))/direcTime;
            
            randvals(a+1) = sum(newAP(degVec == a))/direcTime;
        end
    else
        for a = 0:360
            direcTime = sum(degVec == a)/fs;
            
            vals(a+1) = sum(Data.(sprintf('Sub%d',n)).spiketrain1(degVec == a))/direcTime;
            extravals(a+1) = sum(Data.(sprintf('Sub%d',n)).spiketrain2(degVec == a))/direcTime;
            
            randvals(a+1) = sum(newAP1(degVec == a))/direcTime;
            randextravals(a+1) = sum(newAP2(degVec == a))/direcTime;
        end
        q = 1;
    end
    
    %% Von-Mises fitting
    % code documented for section 1 out of 4. similar method
    
    % set function and function parameters
    VM_drct =  fittype('A * exp (k * cos (x - PO))',...
        'coefficients', {'A', 'k', 'PO'},...
        'independent', 'x');
    % set bounderies
    fitOD = fitoptions(VM_drct);
    fitOD.Lower = [0    , 0,    -pi];
    fitOD.Upper = [inf  , inf,   pi];
    % calculate start point
    A_start = max(vals(:));
    k_start = 1/var(vals(:));
    PO_start = (find(max(vals(:)))-1);
    % set start point
    fitOD.Startpoint = [A_start,  k_start,   PO_start];
    % calculate the fit
    [fitResult_drct, GoF_drct] = ...
        fit(radians', vals(:), VM_drct, fitOD);
    
    % section 2
    % RANDOM
    AR_start = max(randvals(:));
    kR_start = 1/var(randvals(:));
    POR_start = (find(max(randvals(:)))-1);
    
    fitOD.Startpoint = [AR_start,  kR_start,   POR_start];
    
    [fitResultR_drct, GoFR_drct] = ...
        fit(radians', randvals(:), VM_drct, fitOD);
    % END RANDOM
    
    if q
        % section 3
        A_start = max(extravals(:));
        k_start = 1/var(extravals(:));
        PO_start = (find(max(extravals(:)))-1);
        
        fitOD.Startpoint = [A_start,  k_start,   PO_start];
        
        [fitResultE_drct, GoFE_drct] = ...
            fit(radians', extravals(:), VM_drct, fitOD);
        
        % section 4
        % RANDOM
        A_start = max(randextravals(:));
        k_start = 1/var(randextravals(:));
        PO_start = (find(max(randextravals(:)))-1);
        
        fitOD.Startpoint = [A_start,  k_start,   PO_start];
        
        [fitResultRE_drct, GoFRE_drct] = ...
            fit(radians', randextravals(:), VM_drct, fitOD);
        %END RANDOM
    end
    %% plot
    
    figure(hDirect);
    subplot(3,6,n);
    bar(0:360, vals(:));hold on;
    plot(degrees, fitResult_drct(radians), 'r');
    title(['cell #' num2str(n)], 'FontSize', 13);
    x_tick = [0 90 180 270 360];
    xticks(x_tick);
    if n == 1
        ylabel('Original Data', 'FontSize', 14);
    end
    
    subplot(3,6,n+6);
    polarplot(radians, fitResult_drct(radians));
    
    %RANDOM
    subplot(3,6,n+12);
    bar(0:360, randvals(:));hold on;
    plot(degrees, fitResultR_drct(radians), 'r');
    title(['cell #' num2str(n)], 'FontSize', 13);
    x_tick = [0 90 180 270 360];
    xticks(x_tick);
    if n == 1
        ylabel('Randomized Data', 'FontSize', 14);
    end
    %END RANDOM
    
    if q
        figure(hDirect);
        subplot(3,6,n+1);
        bar(0:360, extravals(:));hold on;
        plot(degrees, fitResultE_drct(radians), 'r');
        title(['cell #' num2str(n+1)], 'FontSize', 13);
        x_tick = [0 90 180 270 360];
        xticks(x_tick);
        legend('count', 'VM-fit');
        
        subplot(3,6,n+7);
        polarplot(radians, fitResultE_drct(radians));
        
        %Random
        subplot(3,6,n+13);
        bar(0:360, randextravals(:));hold on;
        plot(degrees, fitResultRE_drct(radians), 'r');
        title(['cell #' num2str(n+1)], 'FontSize', 13);
        x_tick = [0 90 180 270 360];
        xticks(x_tick);
        %END RANDOM
        
        q=0;
    end
    
end
