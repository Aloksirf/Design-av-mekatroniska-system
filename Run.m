% 2021, Vidar H�rding & Andrey Zhakulin
close all; clear all; 
%Startpos
xc2  = [300 0 0 0 0 0 0];%275.480768092719 % 324.519231907281
thl2 = [90*pi/180 0 0 0 0 0 0];            %2.2783 %0.8633

%Mellan tv� punkter fem g�nger 5*(F-J)
%
BX2 = [113 487 113 487 113 487 300];  % f 113
BY2 = [440 440 440 440 440 440 440];  %  f 440

%Mellan tv� punkter A B
%BX2 = [113 206 300];
%BY2 = [60 170 500];

%Mellan tv� andra punkter en g�ng G -H
%BX2 = [206 300 300];
%BY2 = [330 440 500];

% Andra sidan sliden J & E
%BX2 = [487 487 300];
%BY2 = [440 60 500];

%Fels�ka
%BX2 = [394 113 301];
%BY2 = [170 60 500];

%BX2 = [300 300 300];
%BY2 = [500 500 500];
%BX2 = [116 490 300]; % 115,490
%BY2 = [500 500 500];


%BX2 = [150 200 500 200 400 300]; 
%BY2 = [100 400 100 350 350 500];
%funktion f�r ban �kning
%Framm�t
%BX2 = [500 500 100 100 300]; 
%BY2 = [400 100 100 400 500];
%0.9273    1.2870    1.8546    1.2870    0.9273

%Bak�t
%BX2 = [100 100 500 500 300]; 
%BY2 = [400 100 100 400 500];
%-0.9273    -1.2870    -1.8546    -1.2870    -0.9273

%Vart vi ska �ka
R   = [0 ; 0];
RTH = [0 ; 0];
Z   = [0 ; 0];

%Vart vi ska �ka
R   = 0;
RTH = 0;
h = 0.002;

    %HinderPosition
    HX = 0;
    HY = 0;
    
    %H�gerpunkt
    HX1 = HX + 10;
    HY1 = HY + 10;
    %V�nsterpunkt
    HX2 = HX - 10;
    HY2 = HY - 10;
    
    z = 40;        % higth
    yc1 = 250;     % Start y pose of crane
    r = 250;       % arm lenght
    
s = length(BX2)-1;
for c=1:s+1
    
  %If satt som avg�r ifall karnen �ker mot ett hinder. L�ser upp ett meddelande ifall s� �r fallet   
if BX2(c) >= HX2 && BX2(c) <= HX1 && BY2(c) >= HY2 && BY2(c) <= HY1 
         
        msgbox('Invalid Coordinates, Obstacle in Way, Obstacle will be skipet' , 'Error','error');
       
else 
   
 if c == 1
     % End effector position
    x1 = xc2(c) + r*cos(thl2(c));
    y1 = yc1    + r*sin(thl2(c));
     %MoveAB ber�knar v�rden f�r kranens f�rflyttelse  
    [DX,DTH,XC] = Move([xc2(c),thl2(c),r,yc1],x1,y1,BX2(c),BY2(c),[115,490]);
 else
     %MoveAB ber�knar v�rden f�r kranens f�rflyttelse  
    [DX,DTH,XC] = Move([xc2(c),thl2(c),r,yc1],BX2(c-1),BY2(c-1),BX2(c),BY2(c),[115,490]);
 end
     
%MoveAB ber�knar v�rden f�r kranens f�rflyttelse  
[DX,DTH,XC] = Move([xc2(c),thl2(c),r,yc1],x1,y1,BX2(c),BY2(c),[115,490]);
%Sparar vinkeln som cranen ska rotera till
v = -DTH(1);
%Konverterar MoveAB str�ck till ett motsvarande v�rde i slidern
DX = DX(1) * 86.6667; 
%Konverterar MoveAB vinkel till ett motsvarnde v�rde p� motorn
DTH = DTH(1) * -410;
[R2,RTH2] = H_profil(DX,DTH,1);%15000(Halvv�gs),2662(Helt varv)

%Ber�knar k�rstr�cka f�r Z axeln. Hissar upp
[Z1] = H_profil_Z();

%Inverterar k�rstr�ckan flr Z axeln. Hissar ner
[Z2] = H_profil_Z2();%[Z1(1,:);(-1*Z1(2,:))];
[Z2] = [Z2(1,:);(-1*Z2(2,:))];
%Kombinerar matriserna f�r att dela upp k�rstr�ckan s� att Z matrisen
%inleder och avslutar prcessen f�r f�rsta koordinat
if c == 1

    Rt = 0:h:(length(R2)+ length(Z1) + length(Z2)-1)*h;
    R = [Rt;[ zeros(1,length(Z1)) R2(2,:) zeros(1,length(Z2))]];
    
    RTHt = 0:h:(length(RTH2)+ length(Z1) + length(Z2)-1)*h;
    RTH = [RTHt;[ zeros(1,length(Z1)) RTH2(2,:) zeros(1,length(Z2))]];
    
    if(length(R2)>length(RTH2))
    zt1 = 0:h:(length(R2)+ length(Z1) + length(Z2)-1)*h;
    Z = [zt1;[Z1(2,:) zeros(1,length(R2)) Z2(2,:)]];
    else
    zt1 = 0:h:(length(RTH2)+ length(Z1) + length(Z2)-1)*h;
    Z = [zt1;[Z1(2,:) zeros(1,length(RTH2)) Z2(2,:)]];
    end
end

%Kombinerar matriserna beroende p� hur m�nga koordinater kranen ska �ka till.
%Dela upp k�rstr�ckan s� att Z matrisen inleder och avslutar prcessen f�r alla resterande koordinater.     
if  c >= 2
      
    %Skapar en 1x1 Matris f�r tid, L�ngden av R Den f�reg�ende R2 den nya
    %och l�ngderna av b�da Z matriserna
    Rt = 0:h:(length(R)+ length(R2) + length(Z1) + length(Z2)-1)*h;
    
    %Stoppar in v�rderna i rad 2 i matrisen. F�rst den f�reg�ende R
    %sen f�ljs den av Z upp. R2 placeras in och avslutas med Z2 f�r ner.
    %Resultatet blir en 2x2 matris av banplneringen.
    R = [Rt;[ R(2,:) zeros(1,length(Z1)) R2(2,:) zeros(1,length(Z2))]];
    
    RTHt = 0:h:( length(RTH)+ length(RTH2)+ length(Z1) + length(Z2)-1)*h;
    RTH = [RTHt;[ RTH(2,:) zeros(1,length(Z1)) RTH2(2,:) zeros(1,length(Z2))]];
 
    %Kontrollerar vilken av matris �r l�ngst. Anpssar Z l�ngden efter den
    if(length(R2)>length(RTH2))
    zt1 = 0:h:( length(Z)+ length(R2)+ length(Z1) + length(Z2)-1)*h;
    Z = [zt1;[ Z(2,:) Z1(2,:) zeros(1,length(R2)) Z2(2,:)]];
    else
    zt1 = 0:h:( length(Z)+ length(RTH2)+ length(Z1) + length(Z2)-1)*h;
    Z = [zt1;[ Z(2,:) Z1(2,:) zeros(1,length(RTH2)) Z2(2,:)]];
    end
end
  
    %positionen av kranen i x-led vid slut destenation
    xc2(c+1) = XC(1)
    %v�rdet p� kranens vinkel vid slut destenation
    thl2(c+1) = thl2(c) - v;
    RadPos(c) = (thl2(c) - v)
    RadDis(c) = v
    GraderPos(c) = (thl2(c) - v)* 180/pi
    GraderDis(c) = v* 180/pi
    
 end
end