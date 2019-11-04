%% Limpia la memoria de variables
clear all
close all
clc

%% Cierra y elimina cualquier objeto de tipo serial 
if ~isempty(instrfind)
    fclose(instrfind);
    delete(instrfind);
end

%% Creación de un objeto tipo serial
arduino = serial('COM16','BaudRate',9600);
fopen(arduino);
if arduino.status == 'open'
    disp('Arduino conectado correctamente \n');
else
    disp('No se ha conectado el arduino \n');
    return
end
prompt = 'Introducir el valor L1:';
L1 = input (prompt);
%% Se establece el número de muestras y el contador para pder utilizarlos
% en el blucle principal 
numero_muestras = 1000;
y = zeros(1,numero_muestras); 
contador_muestras = 1; 

figure('Name','Serial communication: Matlab + Arduino. TESE-Robótica')
title('SERIAL COMMUNICATION MATLAB + ARDUINO');
xlabel('Número de muestra');
ylabel('Valor');
grid on;
hold on;

p1 =[0 0 0];

while 1
    clf
    printAxis();
    valor_con_offset = fscanf(arduino,'%d');
    theta1_deg = ((valor_con_offset(1))-512)*130/512;
    theta1_rad = deg2rad(theta1_deg);
    TRz1 = [cos(theta1_rad) -sin(theta1_rad) 0 0; sin(theta1_rad) cos(theta1_rad) 0 0; 0 0 1 0; 0 0 0 1];
    TTx1 = [1 0 0 L1; 0 1 0 0; 0 0 1 0; 0 0 0 1];
    T1 = TRz1*TTx1;
    p2 = T1(1:3,4);
    line([p1(1) p2(1)],[p1(2) p2(2)],[p1(3) p2(3)],'color',[1 1 0],'linewidth',3)
    pause(0.01);
    
    %ylim([-150 150]);
    %xlim([contador_muestras-20 contador_muestras+5]);
    %valor_con_offset = fscanf(arduino,'%d');
    %y(contador_muestras) = ((valor_con_offset(1))-512)*130/512;
    %plot(contador_muestras,y(contador_muestras),'X-r');
    %drawnow
    %contador_muestras = contador_muestras + 1;
end

%% Cierre de puertos 
fclose(arduino);
delete(arduino);
clear all; 


