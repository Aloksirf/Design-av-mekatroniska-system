(* ::Package:: *)

function [R,RTH] = H_profil(DXC,DTH,SYNK)
% 2021, Vidar H\:5ca4ing & Andrey Zhakulin
% function [R,RTH] = H_profil(DXC,DTH,SYNK)
% Choose SYNK = 1 for sykronized velocity curves

% Parametrar
StartPos = 0;
StartPosTH= 0;
% Acceleration for slide
MaxAcc = 350; 
% Top hastighet for slide
MaxSpeed = 2000;

% Acceleration for rotation
MaxAccTH = 20;
% Top hastighet for rotation
MaxSpeedTH = 70;

% End Positions
EndPos = DXC;   % Slide
EndPosTH = DTH; % Rotation
% SampleTime
h = 0.002; 
[timeXC, timeTH, OldSpXc ,OldSpTH]= H_profil _test(DXC,DTH);
% If only one velocityprofile is needed
if OldSpXc == 0
   OldSpXc = zeros(1,length(OldSpTH));
end
if OldSpTH == 0
   OldSpTH= zeros(1,length(OldSpXc));
end

% Remove null bug
RoundDXC=0;
RoundDTH=0;
    if(DXC==0)
        DXC=0.1;
        RoundDXC=1;
        SYNK=0;
    end
    if(DTH==0)
        DTH=0.1;
        RoundDTH=1;
        SYNK=0;
    end
t=1;
% Makes curves synkronized if SYNK == 1
if(SYNK == 1&&DXC~=0&&DTH~=0)
    if abs(timeXC) < abs(timeTH)        
                    while abs(OldSpXc(t+1))>abs(OldSpXc(t))
                        t=t+1;
                        PeakValue=OldSpXc(t+1);
                    end
                    if PeakValue<MaxSpeed
                        MaxSpeed=abs(PeakValue*(timeXC/timeTH));
                    else
                        MaxSpeed = abs(MaxSpeed*(timeXC/timeTH));
                    end
            NewAccTime = t*h*(timeXC/timeTH); 
            MaxAcc = (MaxSpeed/NewAccTime)* 1/((timeTH/timeXC)*timeTH/timeXC);

    else

                    while abs(OldSpTH(t+1))>abs(OldSpTH(t))
                        t=t+1;                        
                        PeakValueTH=OldSpTH(t+1);
                    end
                    if PeakValueTH<MaxSpeedTH
                        MaxSpeedTH=abs(PeakValueTH*(timeTH/timeXC));
                    else
                        MaxSpeedTH = abs(MaxSpeedTH*(timeTH/timeXC));
                    end
            NewAccTimeTH = t*h*(timeTH/timeXC);            
            MaxAccTH = (MaxSpeedTH/NewAccTimeTH) * 1/((timeXC/timeTH)*timeXC/timeTH);
    end
end

% Init
Position = StartPos;
PositionTH = StartPosTH;
Speed = 0;
SpeedTH = 0;
OldSpeed = 0;
OldSpeedTH = 0;
n = 0;
Sp= 0;
SpTH = 0;

% Funktion for Slide
if EndPos > StartPos
    dXc = EndPos - Position;
    dXmin = Speed*Speed/(2*MaxAcc);
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
        dXmin = Speed*Speed/(2*MaxAcc);
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
        dXmin = -Speed*Speed/(2*MaxAcc);
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
    dTHmin = SpeedTH*SpeedTH/(2*MaxAccTH);
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
if RoundDXC == 1 || (DXC>0 && DXC <0.001)
    DXC = zeros(1, length(DTH));
    Sp = zeros(1, length(DTH));
end
if RoundDTH == 1 || (DTH>0 && DTH <0.001)
    DTH = zeros(1, length(DXC));
    SpTH = zeros(1, length(DXC));
end
% Store all DATA in a vector to be imported into Simulink -> R
t = 0:h:(length(Sp)+50)*h;
R = [t;[Sp zeros(1,51)]]; % Extra zeros migth be needed
% Start and end time
[t(1) t(end)]

% Store all DATA in a vector to be imported into Simulink -> RTH
tTH = 0:h:(length(SpTH)+50)*h;
RTH = [tTH;[SpTH zeros(1,51)]]; % Extra zeros migth be needed
% Start and end time
[tTH(1) tTH(end)]
end
