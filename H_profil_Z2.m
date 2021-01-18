function [Z] = H_profil_Z2()
% 2021, Vidar Hårding & Andrey Zhakulin
% function [R,RTH] = Hastighetsprofil4(DXC,DTH,SYNK)

%Parametrar:

StartPos = 0;
% Acceleration for Z
MaxAcc = 6; 
%Top hastighet for Z
MaxSpeed = 50;

% End Position
EndPos = 61.1;  
% SampleTime
h = 0.002; 

% Init
Position = 0;
Speed = 0;
OldSpeed = 0;
n = 0;

% Funktion for Z
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
end

% Store all DATA in a vector to be imported into Simulink -> Z
t = 0:h:(length(Pos)+50)*h;
Z = [t;[Sp zeros(1,51)]]; % Extra zeros migth be needed
% Start and end time
[t(1) t(end)];
end

