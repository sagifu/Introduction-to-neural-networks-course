clear; clc; close all;

%% Constants setting
% according to data recieved from the book:
% "Biophysics of Computation: Information Processing in Single Neurons", by Christof Koch, 1999.

Cm=1; % membrane capcitance uF/cm^2
ENa=115; % mV Na reversal potential
EK=-12; % mV K reversal potential
El=10.613; % mV Leakage reversal potential
gbarNa=120; % mS/cm^2 Na conductance
gbarK=36; % mS/cm^2 K conductance
gbarl=0.3; % mS/cm^2 Leakage conductance

%% Setting time step, time vector and current vector

dt=0.001; % time step mS (= 1uS)
t=0:dt:100; % time array ms (= 100mS)
I=zeros(1,length(t)); % external current applied - uA/cm^2

%% Instructions:
% for each question, uncomment its parallel Assignment section
% it is recommended to comment the Assignment when finished using it
% each Assignment has a plotting set
% no need to comment or uncomment the plotting section

% PAY ATTENTION to Assignment 2#, extra instructions written
% PAY ATTENTION Assignment 6# is devided into two sections
%   before and after the calculating section
%   NO NEED to comment or uncomment the 2nd section

%% Assignment 1#

    % 1mS injection of 10 uA
I(4500:5500) = 10;
plotting = 'a';

%% Assignment 2#

%    % 1 mS injection period - activate both lines
% I(4000:5000) = 6.9;
% I(24000:25000) = 7;
% plotting = 'b';

%    % all trial injection - activate each block separately
% I(:) = 2.2;
% plotting = 'b';

% I(:) = 2.3;
% plotting = 'b';

%% Assignment 3#

%    % all trial injection
% I(:) = 8;
% plotting = 'b';

%% Assignment 4#

%     % part a - proof of refractory period
% I(1000:3000) = 8;
% I(8000:10000) = 8;
%     % part b - overcome that period
%     % greater current
% I(60000:62000) = 8;
% I(67000:69000) = 60;
% plotting = 'b';

%% Assignment 5#

% lambda = 40;
% for a = 1:1/dt:length(t)-1
%     I(a:a+(1/dt)-1) = ((lambda^((a-1)*dt))/(prod(1:(a-1)*dt)))*exp(-lambda);
% end
% I = I/dt;
% plotting = 'c';

%% Assignment 6# - part A

% t=0:dt:60000;           % time array mS (= 60 Sec)
% I=zeros(1,length(t));   % external current applied - uA/cm^2
% 
% batch_size = 300/dt;           % 300 mS - current injection cycle
% inj_batch = 1/3*batch_size;    % the current will be injected in the first 100mS of each cycle
% 
% 
% I(1:batch_size) = 1;
% for a = batch_size+1:batch_size:(length(t)-1)          % each interval current cycle lasts batch size
%     I(a:((a+inj_batch)-1)) = I(a-batch_size) + 0.1;    % current increases in 0.1uA in each cycle
%     I((a+inj_batch-1)+1:(a+batch_size)-1) = 0;    
% end
% plotting = 'd';

%% Calculating voltage and Ionic gates' activation
% according to "Forward Euler Method"

V(1)=0; % constants values were determined according to resting potential 0 mV - correction before plotting
n(1) = alphaCalc(V(1),'n')/(alphaCalc(V(1),'n')+betaCalc(V(1),'n')); % initial n-value
m(1) = alphaCalc(V(1),'m')/(alphaCalc(V(1),'m')+betaCalc(V(1),'m')); % initial m-value
h(1) = alphaCalc(V(1),'h')/(alphaCalc(V(1),'h')+betaCalc(V(1),'h')); % initial h-value

for i=1:length(t)-1
    
        % set the accurate conductance value
    gNa=gbarNa*m(i)^3*h(i);
    gK=gbarK*n(i)^4;
    gl=gbarl;
    
        % set the accurate current value
    INa=gNa*(V(i)-ENa);
    IK=gK*(V(i)-EK);
    Il=gl*(V(i)-El);
    
        % find the next step values
    V(i+1)=V(i)+((1/Cm)*(I(i)-(INa+IK+Il)))*dt;
    n(i+1)=n(i)+((alphaCalc(V(i),'n')*(1-n(i)))-(betaCalc(V(i),'n')*n(i)))*dt;
    m(i+1)=m(i)+((alphaCalc(V(i),'m')*(1-m(i)))-(betaCalc(V(i),'m')*m(i)))*dt;
    h(i+1)=h(i)+((alphaCalc(V(i),'h')*(1-h(i)))-(betaCalc(V(i),'h')*h(i)))*dt;
    
end

V = V-65;   % correcting voltage value

%% Assignment 6# - part B - calculating firing rate
if plotting == 'd'
    TH = -40;       % threshold value
    binVolt = V>TH; % creating binary vector indicating if the voltage is above/below threshold
    
    % the next vector's length is the number of spikes in the whole trial
    % each value indicates the time (in uS) in which the spike is occurring
    AP_start = find(diff(binVolt)==1); 
    
    
    IPlot = zeros(1,(length(I)-1)/batch_size);  % short display current vector
    
    SC = cell(1,length(IPlot));    % will save the spikes' time per cycle
    T = zeros(1, length(SC));      % will save spikes' cycle time in each injection iteration
    
    % creating the current vector for calculatiing and plotting
    for a = 1:length(IPlot)
        IPlot(a) = I(round((a-0.9)*batch_size));             % in cell 'a' , save the current of equivalent current cycle
    end
    
    B_start = 1;            % batch (cycle) start time in uS
    B_end = batch_size;     % batch (cycle) end time in uS
    
    % count spikes per current interval
    for b = 1:length(IPlot)
        if B_end<min(AP_start)                     % if the cycle number is smaller than the minimum value of the spikes' cycle occurrence
            B_start = B_start + batch_size;           
            B_end = B_end + batch_size;               
            continue;                                 % skip to next iteration
        else
            if B_start>max(AP_start)                 % if the cycle number is greater than the maximum value of the spikes' cycle occurrence
                break;                                % stop calculating
            else
                for a = 1:length(AP_start)
                    if AP_start(a)<=B_end && AP_start(a)>=B_start  
                        SC{b} = [SC{b} AP_start(a)];                % in each cycle (b) save the time in which the voltage passes threshold
                    end
                    if length(SC{b}) == 2                           % no more than twice
                        break;
                    end
                end
            end
        end
        if length(SC{b}) == 2
            T(b) = SC{b}(2) - SC{b}(1);         % calculate the time of a complete cycle for each injection cycle
        end
        B_start = B_start + batch_size;
        B_end = B_end + batch_size;
    end
    
    % calculating rate
T = (T*dt)/1000;
forInf = find(T==0);
f = 1./T;
f(forInf) = 0;
end
%% Plotting

% 1st plot
if plotting == 'a'
    subplot(2,1,1);plot(t,V); title('Membrane voltage'); xlabel('Time [mSec]'); ylabel('Volts [mV]');
    set(gca,'XLim',[0 (length(t)*dt)],'YLim', [-80 60]);
    subplot(2,1,2);plot(t,n); title("Channels gates' activity"); xlabel('Time [mSec]'); ylabel('activation/inactivation');
    hold on
    subplot(2,1,2);plot(t,m);
    subplot(2,1,2);plot(t,h);
    subplot(2,1,2);legend('n','m','h');
    set(gca,'XLim',[0 (length(t)*dt)],'YLim', [0 1]);
    hold off
end

% 2nd 3rd 4th plot
if plotting == 'b'
    subplot(2,1,1);plot(t,V); title('Membrane voltage'); xlabel('Time [mSec]'); ylabel('Volts [mV]');
    set(gca,'XLim',[0 (length(t)*dt)],'YLim', [-80 60]);
    subplot(2,1,2);plot(t,I); title('Injected DC current'); xlabel('Time [mSec]'); ylabel('Ampere [\muA]');
end

% 5th plot
if plotting == 'c'
    subplot(2,1,1);plot(t,V); title('Membrane voltage'); xlabel('Time [mSec]'); ylabel('Volts [mV]');
    set(gca,'XLim',[0 (length(t)*dt)],'YLim', [-80 60]);
    subplot(2,1,2);plot(t,I); title(['Poison distribution current - lambda = ', num2str(lambda)]); xlabel('Time [mSec]'); ylabel('Ampere [\muA]');
end

% 6th plot
if plotting == 'd'
    subplot(3,1,1);plot(t,V); title('Membrane voltage'); xlabel('Time [mSec]'); ylabel('Volts [mV]');
    set(gca,'XLim',[0 (length(t)*dt)],'YLim', [-80 60]);
    subplot(3,1,2);plot(t,I); title('Injected interval current'); xlabel('Time [mSec]'); ylabel('Ampere [\muA]');
    subplot(3,1,3);plot(IPlot,f);title('Firing rate');xlabel('Ampere [\muA]');ylabel('Firing rate [Hz]');
    set(gca,'XLim',[(min(IPlot)) (max(IPlot))],'YLim', [min(f) max(f)+10]);
end