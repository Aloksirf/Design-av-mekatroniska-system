function [time1,time2,Sp,SpTH] = H_profil_test(DXC,DTH),
% 2021, Vidar Hårding & Andrey Zhakulin
% function [R,RTH] = H_profil_test(DXC,DTH,SYNK)


%Parametrar
StartPos = 0;
StartPosTH= 0;
% Acceleration for slide
MaxAcc = 350; 
%Top hastighet for slide
MaxSpeed = 2000;

%Acceleration for rotation
MaxAccTH = 20;
%Top hastighet for rotation
MaxSpeedTH = 70;

% End Positions
EndPos = DXC;   % Slide
EndPosTH = DTH; % Rotation
% SampleTime
h = 0.002; 

%Remove null bug
RoundDXC=0;
RoundDTH=0;
    if(DXC==0)
        DXC=0.1;
        RoundDXC=1;
    end
    if(DTH==0)
        DTH=0.1;
        RoundDTH=1;
    end

timeTH = 10.8800*(2*pi)/(DTH);
timeXC = 9.8400 * 325/DXC;

% Init
Position = StartPos;
PositionTH = StartPosTH;
BreakPosTH = 1;
BreakPos = 1;
Speed = 0;
SpeedTH = 0;
OldSpeed = 0;
OldSpeedTH = 0;
n = 0;

% Funktion for Slide
if EndPos > StartPos
    dXc = EndPos - Position;
    dXmin = BreakPos*Speed*Speed/(2*MaxAcc);
    while dXmin < dXc
        if Speed < (MaxSpeed - MaxAcc * h)
        % Acceleration
            Speed = OldSpeed + MaxAcc * h;
        else
        % Keep constant speed
            Speed = MaxSpeed;
        end
        Position = Position + Speed * h;
        dXc = EndPos - Position;
        dXmin = BreakPos*Speed*Speed/(2*MaxAcc);
        % save variable for plotting
        n = n + 1; 
        Pos(n) = Position;
        Sp(n) = Speed;
        Acc(n) = (Speed-OldSpeed)/h;
        OldSpeed = Speed;
    end
    % Deacceleration
    while Speed>0
        Speed = OldSpeed - MaxAcc * h; 
        Position = Position + Speed * h;
        % save variable for plotting
        n = n + 1; 
        Pos(n) = Position;
        Sp(n) = Speed;
        Acc(n) = (Speed-OldSpeed)/h;
        OldSpeed = Speed;
    end
else
    % Negative velocity profile for Slide
    dXc = EndPos - Position;
    dXmin = Speed*Speed/(2*MaxAcc);
    while dXmin > dXc
        if Speed > (-MaxSpeed + MaxAcc * h)
        % Acceleration
            Speed = OldSpeed - MaxAcc * h;
        else
        % Keep constant speed
            Speed = - MaxSpeed;
        end
        Position = Position + Speed * h;
        dXc = EndPos - Position;
        dXmin = -BreakPos*Speed*Speed/(2*MaxAcc);
        % save variable for plotting
        n = n + 1; 
        Pos(n) = Position;
        Sp(n) = Speed;
        Acc(n) = (Speed-OldSpeed)/h;
        OldSpeed = Speed;
    end
    % Deacceleration
    while Speed<0
        Speed = OldSpeed + MaxAcc * h; 
        Position = Position + Speed * h;
        % save variable for plotting
        n = n + 1; 
        Pos(n) = Position;
        Sp(n) = Speed;
        Acc(n) = (Speed-OldSpeed)/h;
        OldSpeed = Speed;
    end         
end

% Funktion for Rotation
n=0;
if EndPosTH > StartPosTH
    dTH = EndPosTH - PositionTH;
    dTHmin = BreakPosTH*SpeedTH*SpeedTH/(2*MaxAccTH);
    while dTHmin < dTH
        if SpeedTH < (MaxSpeedTH - MaxAccTH * h)
        % Acceleration
            SpeedTH = OldSpeedTH + MaxAccTH * h;
        else
        % Keep constant speed
            SpeedTH = MaxSpeedTH;
        end
        PositionTH = PositionTH + SpeedTH * h;
        dTH = EndPosTH - PositionTH;
        dTHmin = SpeedTH*SpeedTH/(2*MaxAccTH);
        % save variable for plotting
        n = n + 1; 
        PosTH(n) = PositionTH;
        SpTH(n) = SpeedTH;
        AccTH(n) = (SpeedTH-OldSpeedTH)/h;
        OldSpeedTH = SpeedTH;
    end
    % Deacceleration
    while SpeedTH>0
        SpeedTH = OldSpeedTH - MaxAccTH * h; 
        PositionTH = PositionTH + SpeedTH * h;
        % save variable for plotting
        n = n + 1; 
        PosTH(n) = PositionTH;
        SpTH(n) = SpeedTH;
        AccTH(n) = (SpeedTH-OldSpeedTH)/h;
        OldSpeedTH = SpeedTH;
    end
else
    % Negative velocity profile for Rotation
    dTH = EndPosTH - PositionTH;
    dTHmin = SpeedTH*SpeedTH/(2*MaxAccTH);
    while dTHmin > dTH
        if SpeedTH > (-MaxSpeedTH + MaxAccTH * h)
        % Acceleration
            SpeedTH = OldSpeedTH - MaxAccTH * h;
        else
        % Keep constant speed
            SpeedTH = - MaxSpeedTH;
        end
        PositionTH = PositionTH + SpeedTH * h;
        dTH = EndPosTH - PositionTH;
        dTHmin = -SpeedTH*SpeedTH/(2*MaxAccTH);
        % save variable for plotting
        n = n + 1; 
        PosTH(n) = PositionTH;
        SpTH(n) = SpeedTH;
        AccTH(n) = (SpeedTH-OldSpeedTH)/h;
        OldSpeedTH = SpeedTH;
    end
    % Deacceleration
    while SpeedTH<0
        SpeedTH = OldSpeedTH + MaxAccTH * h; 
        PositionTH = PositionTH + SpeedTH * h;
        % save variable for plotting
        n = n + 1; 
        PosTH(n) = PositionTH;
        SpTH(n) = SpeedTH;
        AccTH(n) = (SpeedTH-OldSpeedTH)/h;
        OldSpeedTH = SpeedTH;
    end         
end
% Eliminate zero bug
if RoundDXC == 1
    DXC = zeros(1, length(DTH));
    Sp = zeros(1, length(DTH));
end
if RoundDTH == 1
    DTH = zeros(1, length(DXC));
    SpTH = zeros(1, length(DXC));
end

%Store all DATA in a vector to be imported into Simulink -> R
t = 0:h:(length(Sp)+10)*h;
R = [t;[Sp zeros(1,11)]]; % Extra zeros migth be needed
% Start and end time
[t(1) t(end)]

% Store all DATA in a vector to be imported into Simulink -> RTH
tTH = 0:h:(length(SpTH)+10)*h;
RTH = [tTH;[SpTH zeros(1,11)]]; % Extra zeros migth be needed
% Start and end time
[tTH(1) tTH(end)]
time1=length(Sp)*h;
time2=length(SpTH)*h;
end