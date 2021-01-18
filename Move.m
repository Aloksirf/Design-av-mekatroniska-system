% 2021, Vidar Hårding & Andrey Zhakulin
% function [DX,DTH] = MoveAB(x_start,y_start,x_end,y_end,X)
% DX = vector of crane movment's (up to two possibility's)
% DTH = vector of crane rotation's (up to two possibility's)
% XC = vector of crane end positions
% PoseCrane = [x th r y] % r = crane radius from x
% x_start,y_start,x_end,y_end = start and stop positions
% X = [x_min x_max] maximum values of x, i.e. crane limits

function [DX,DTH,XC] = Move(PoseCrane,x_start,y_start,x_end,y_end,X),
% fix this later
xc1 = PoseCrane(1);
th1 = PoseCrane(2);
r = PoseCrane(3);
yc1 = PoseCrane(4);
x2 = x_end;
y2 = y_end;
x1 = x_start; 
y1 = y_start;
Xprim = sqrt(r*r-(y2-yc1)*(y2-yc1));
v1 = atan2((y2-yc1),(Xprim)); %%%% 1 & 3 
v2 = atan2((y2-yc1),(-Xprim));%%%% 2 & 4

% The two possible positions for the cranes position
XC1 = x2 + Xprim; 
XC2 = x2 - Xprim; 

DX1 = XC1-xc1; %DX(1) Rot
DX2 = XC2-xc1; %DX(2) Slide
DX(1)=DX1;
DX(2)=DX2;
MinXC= X(1);
MaxXC= X(2);
% Remove alternativ that is out of bounds
if XC1 < MinXC || XC1 > MaxXC
    XC1 = XC2;
elseif XC2 < MinXC || XC2 > MaxXC
    XC2= XC1;
end

%Combine second position with correct angle
if XC2 < x2
    DTH(2) = v1-th1;
    if DTH(2) < -pi || DTH(2) > pi
        DTH(2)= 2*pi- abs(DTH(2));
    end
else
    DTH(2) = v2-th1;
    if DTH(2) < -pi || DTH(2) > pi
        DTH(2)= -(2*pi- abs(DTH(2)));
        DTH(2)= 2*pi- abs(DTH(2));
    end
end

%Combine first position with correct angle
if XC1 < x2
    DTH(1) = v1-th1;
    if DTH(1) < -pi || DTH(1) > pi
        DTH(1)= 2*pi- abs(DTH(1));
    end
else
    DTH(1) = v2-th1;
    if DTH(1) < -pi || DTH(1) > pi
         % Bug fix for Bottom left to Top left /Top right
        if x1 < 300 && y1 < 250 &&  x2 <= 300 && y2 >= 250
        DTH(1)= -(2*pi- abs(DTH(1)));    
        else
        DTH(1)= (2*pi- abs(DTH(1))); %(2*pi- abs(DTH(1)));----------
        end
        
    end
end

XC(1) = XC1;
XC(2) = XC2;
CXC(1)= XC(1);    %Copy
CXC(2)= XC(2);    %Copy
CDX(1)= DX1;      %Copy
CDX(2)= DX2;      %Copy
CDTH(1) = DTH(1); %Copy 
CDTH(2) = DTH(2); %Copy


%-------------------------------------------------------------------- Logic
% [Min rotation Min Sliding]
% Min Slide and (if not OOF)
if abs(CDX(2))>abs(CDX(1))&&(XC(1)>=MinXC&&XC(1)<=MaxXC),
    DX(2)=CDX(1);
    XC(2)=CXC(1);
    DTH(2)=CDTH(1);
end
% Min rotation
% 1.If other direction has shorter rotation and (if not OOF)
if abs(CDTH(2))<abs(CDTH(1))&&CXC(2)>=MinXC&&CXC(2)<=MaxXC,
    DX(1)=CDX(2);
    XC(1)=CXC(2);
    DTH(1)=CDTH(2);
% 2. If same rotation in min slide Rot= min slide (if not OOF)
elseif abs(CDTH(2))== abs(CDTH(1)),
    if abs(CDX(2))<=abs(CDX(1))&&(CXC(2)>=MinXC&&CXC(2)<=MaxXC),
    DX(1)=CDX(2);
    XC(1)=CXC(2);
    DTH(1)=CDTH(2);
    CDTH(1)=DTH(1);
    end
end
% If crane is out of bounds
if (CXC(1)<0||CXC(1)>600)&&(CXC(2)>=MinXC&&CXC(2)<=MaxXC),
    DX(1)=CDX(2);
    XC(1)=CXC(2);
    DTH(1)=CDTH(2);
end
% Final check of values
if DX(1) + xc1 > MaxXC || DX(1) + xc1 < MinXC
DX(1)=CDX(2)
XC(1)=CXC(2);
DTH(1)=CDTH(2);
end

