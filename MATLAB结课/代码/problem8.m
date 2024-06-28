%% 第一题
% 加载数据
data = readmatrix('data2.txt');
t2 = data(:, 1);  % 时间
x = data(:, 2);  % x坐标
y = data(:, 3);  % y坐标
z = data(:, 4);  % z坐标

% 数据去噪处理，可以使用平滑方法，如移动平均滤波
x2 = smooth(t, x, 0.1, 'rloess');  % 使用局部加权回归平滑
y2 = smooth(t, y, 0.1, 'rloess');
z2 = smooth(t, z, 0.1, 'rloess');

% 计算速度
dt = diff(t2);
dx = diff(x2);
dy = diff(y2);
dz = diff(z2);
speed = sqrt((dx./dt).^2 + (dy./dt).^2 + (dz./dt).^2);

% 找到最大和最小速度
max_speed = max(speed);
min_speed = min(speed);

fprintf('最大速度: %f 米/秒\n', max_speed);
fprintf('最小速度: %f 米/秒\n', min_speed);

%% 第二题
% 设置 fittype 和选项。
ft = fittype( 'a+b*x+c*cos(d*x)', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Lower = [-Inf -Inf 150 0.75];
opts.StartPoint = [0.149294005559057 0.257508254123736 0.840717255983663 0.254282178971531];
opts.Upper = [Inf Inf 300 1.5];

% 对数据进行模型拟合。
[fitresult_x, gof_x] = fit( t2, x2, ft, opts );

% 绘制数据拟合图。
figure( 'Name', '拟合 x' );
h = plot( fitresult_x, t2, x2 );
legend( h, '处理后数据', '拟合结果', 'Location', 'NorthEast', 'Interpreter', 'none' );
% 为坐标区加标签
xlabel( 't', 'Interpreter', 'none' );
ylabel( 'x', 'Interpreter', 'none' );
grid on

% 设置 fittype 和选项。
ft = fittype( 'a+b*x+c*sin(d*x)', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Lower = [-Inf -Inf 300 0.75];
opts.StartPoint = [0.890903252535798 0.959291425205444 0.547215529963803 0.138624442828679];
opts.Upper = [Inf Inf 500 1.5];

% 对数据进行模型拟合。
[fitresult_y, gof_y] = fit( t2, y2, ft, opts );

% 绘制数据拟合图。
figure( 'Name', '拟合 y' );
h = plot( fitresult_y, t2, y2 );
legend( h, '处理后数据', '拟合结果', 'Location', 'NorthEast', 'Interpreter', 'none' );
% 为坐标区加标签
xlabel( 't', 'Interpreter', 'none' );
ylabel( 'y', 'Interpreter', 'none' );
grid on

% 设置 fittype 和选项。
ft = fittype( 'a+b*sin(c*x)', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Lower = [-Inf 0 0];
opts.StartPoint = [0.162611735194631 0.118997681558377 1];
opts.Upper = [Inf Inf 0.078];

% 对数据进行模型拟合。
[fitresult_z, gof_z] = fit( t2, z2, ft, opts );

% 绘制数据拟合图。
figure( 'Name', '拟合 z' );
h = plot( fitresult_z, t2, z2 );
legend( h, '处理后数据', '拟合结果', 'Location', 'NorthEast', 'Interpreter', 'none' );
% 为坐标区加标签
xlabel( 't', 'Interpreter', 'none' );
ylabel( 'z', 'Interpreter', 'none' );
grid on

a = fitresult_x.a;
b = fitresult_x.b;
A = fitresult_x.c;
w1 = fitresult_x.d;
c = fitresult_y.a;
d = fitresult_y.b;
B = fitresult_y.c;
w2 = fitresult_y.d;
e = fitresult_z.a;
C = fitresult_z.b;
w3 = fitresult_z.c;

fitted_x = a + b*t2 + A*cos(w1*t2);
fitted_y = c + d*t2 + 350*sin(w2*t2);
fitted_z = e + C*sin(w3*t2);
figure;
plot3(x2, y2, z2, 'r.', fitted_x, fitted_y, fitted_z, 'b-');
xlabel('x'); ylabel('y'); zlabel('z');
title('运动轨迹拟合');
legend('处理后数据', '拟合曲线', 'Location', 'best');
grid on;


% 计算速度
speed_fit = sqrt((b-A*w1*sin(w1*t2)).^2 + (d+B*w2*cos(w2*t2)).^2 + ((C*w3*cos(w3*t2)).^2));

% 绘制速度图
figure;
plot(t2, speed_fit, 'b-');
xlabel('时间 (秒)');
ylabel('速度 (米/秒)');
title('速度图');
grid on;


% 最大和最小速度
max_speed_fit = max(speed_fit);
min_speed_fit = min(speed_fit);

fprintf('拟合最大速度: %f 米/秒\n', max_speed_fit);
fprintf('拟合最小速度: %f 米/秒\n', min_speed_fit);





%% 第三题
% 微分方程的初值问题
v_3 = 300; % 跟踪器速度

% 建立微分方程组
% target_trajectory = @(t)[a + b*t+A*cos(w1*t); c + d*t+B*sin(w2*t); e + C*sin(w3*t)];

tracker_ode_3 = @(t, y)[
    v_3*(a + b*t+A*cos(w1*t) - y(1)) / sqrt((a + b*t+A*cos(w1*t) - y(1)).^2+(c + d*t+B*sin(w2*t)- y(2)).^2+(e + C*sin(w3*t) - y(3)).^2);
    v_3*(c + d*t+B*sin(w2*t)- y(2)) / sqrt((a + b*t+A*cos(w1*t) - y(1)).^2+(c + d*t+B*sin(w2*t)- y(2)).^2+(e + C*sin(w3*t) - y(3)).^2);
    v_3*(e + C*sin(w3*t) - y(3)) / sqrt((a + b*t+A*cos(w1*t) - y(1)).^2+(c + d*t+B*sin(w2*t)- y(2)).^2+(e + C*sin(w3*t) - y(3)).^2)
];


% 初始条件
y0 = [0; 0; 0];

% 时间跨度
tspan = [0 20];

% 求解微分方程
[t_sol_3, y_sol_3] = ode45(tracker_ode_3, tspan, y0);

% 绘制跟踪器和目标的轨迹图
figure;
plot3(x2, y2, z2, 'r-', y_sol_3(:, 1), y_sol_3(:, 2), y_sol_3(:, 3), 'b-');
xlabel('x');
ylabel('y');
zlabel('z');
title('移动目标和跟踪器的轨迹');
legend('目标轨迹', '跟踪器轨迹');
grid on;
%% 第四题
% 跟踪器速度
v_4 = 330; % 米/秒

% 求解微分方程
tracker_ode_4 = @(t, y)[
    v_4*(a + b*t+A*cos(w1*t) - y(1)) / sqrt((a + b*t+A*cos(w1*t) - y(1)).^2+(c + d*t+B*sin(w2*t)- y(2)).^2+(e + C*sin(w3*t) - y(3)).^2);
    v_4*(c + d*t+B*sin(w2*t)- y(2)) / sqrt((a + b*t+A*cos(w1*t) - y(1)).^2+(c + d*t+B*sin(w2*t)- y(2)).^2+(e + C*sin(w3*t) - y(3)).^2);
    v_4*(e + C*sin(w3*t) - y(3)) / sqrt((a + b*t+A*cos(w1*t) - y(1)).^2+(c + d*t+B*sin(w2*t)- y(2)).^2+(e + C*sin(w3*t) - y(3)).^2)
];


[t_sol_4, y_sol_4] = ode45(tracker_ode_4, [0 30], [0;0;0]);

% 计算距离
distance_4 = sqrt((y_sol_4(:, 1) - a - b*t_sol_4-A*cos(w1*t_sol_4)).^2 + ...
                (y_sol_4(:, 2) - c - d*t_sol_4-B*sin(w2*t_sol_4)).^2 + ...
                (y_sol_4(:, 3) - e - C*sin(w3*t_sol_4)).^2);

% 判断是否追上
if any(distance_4 < 1) % 假设追上条件为距离小于1米
    fprintf('跟踪器在 %f 秒时追上目标\n', t_sol_4(find(distance_4 < 1, 1)));
else
    fprintf('跟踪器在 30 秒内未能追上目标\n');
end

% 绘制轨迹图
figure;
plot3(x2, y2, z2, 'r-', y_sol_4(:, 1), y_sol_4(:, 2), y_sol_4(:, 3), 'b-');
xlabel('x');
ylabel('y');
zlabel('z');
title('移动目标和跟踪器的轨迹');
legend('目标轨迹', '跟踪器轨迹');
grid on;
%% 第五题
% 跟踪器速度
v_5 = 200; % 米/秒

% 求解微分方程
tracker_ode_4 = @(t, y)[
    v_5*(a + b*t+A*cos(w1*t) - y(1)) / sqrt((a + b*t+A*cos(w1*t) - y(1)).^2+(c + d*t+B*sin(w2*t)- y(2)).^2+(e + C*sin(w3*t) - y(3)).^2);
    v_5*(c + d*t+B*sin(w2*t)- y(2)) / sqrt((a + b*t+A*cos(w1*t) - y(1)).^2+(c + d*t+B*sin(w2*t)- y(2)).^2+(e + C*sin(w3*t) - y(3)).^2);
    v_5*(e + C*sin(w3*t) - y(3)) / sqrt((a + b*t+A*cos(w1*t) - y(1)).^2+(c + d*t+B*sin(w2*t)- y(2)).^2+(e + C*sin(w3*t) - y(3)).^2)
];


[t_sol_5, y_sol_5] = ode45(tracker_ode_4, [0 30], [0;0;0]);

% 计算距离
distance_5 = sqrt((y_sol_5(:, 1) - a - b*t_sol_5-A*cos(w1*t_sol_5)).^2 + ...
                (y_sol_5(:, 2) - c - d*t_sol_5-B*sin(w2*t_sol_5)).^2 + ...
                (y_sol_5(:, 3) - e - C*sin(w3*t_sol_5)).^2);

% 判断是否追上
if any(distance_5 < 1) % 假设追上条件为距离小于1米
    fprintf('跟踪器在 %f 秒时追上目标\n', t_sol_5(find(distance_5 < 1, 1)));
else
    fprintf('跟踪器在 30 秒内未能追上目标\n');
end

% 绘制轨迹图
figure;
plot3(x2, y2, z2, 'r-', y_sol_5(:, 1), y_sol_5(:, 2), y_sol_5(:, 3), 'b-');
xlabel('x');
ylabel('y');
zlabel('z');
title('移动目标和跟踪器的轨迹');
legend('目标轨迹', '跟踪器轨迹');
grid on;


%% 第六题第一阶段
% 目标位置的函数，假设从问题二中得到的参数已定义
targetX = @(t) a + b*t + A*cos(w1*t);
targetY = @(t) c + d*t + B*sin(w2*t);
targetZ = @(t) e + C*sin(w3*t);
% 设置初始速度范围
v_min = 0; % 初始速度
v_max = 400; % 假设最大速度为400米/秒
v_increment = 1; % 每次增加1米/秒

% 初始条件和时间区间
w0 = [0; 0; 0];
tspan = [0 30];

% 迭代寻找最小速度
for v = v_min:v_increment:v_max
    odefun = @(t, w) [v * (targetX(t) - w(1)) / sqrt((targetX(t) - w(1))^2 + (targetY(t) - w(2))^2 + (targetZ(t) - w(3))^2);
                      v * (targetY(t) - w(2)) / sqrt((targetX(t) - w(1))^2 + (targetY(t) - w(2))^2 + (targetZ(t) - w(3))^2);
                      v * (targetZ(t) - w(3)) / sqrt((targetX(t) - w(1))^2 + (targetY(t) - w(2))^2 + (targetZ(t) - w(3))^2)];
    
    [t, w] = ode45(odefun, tspan, w0);
    
    % 计算每一时间点上的距离
    distances = sqrt((targetX(t) - w(:,1)).^2 + (targetY(t) - w(:,2)).^2 + (targetZ(t) - w(:,3)).^2);
    
    % 检查是否追上
    if any(distances < 1) % 假设追上的条件是距离小于1米
        idx = find(distances < 1, 1, 'first');
        catch_time = t(idx);
        fprintf('最小追击速度: %.2f 米/秒\n', v);
        fprintf('追踪器在 %.2f 秒内追上了目标。\n', catch_time);
        break; % 找到最小速度后跳出循环
    end
end

if v == v_max
    fprintf('在最大速度 %d 米/秒内追踪器未能在30秒内追上目标。\n', v_max);
end

%% 第六题进一步搜索

v_min = 292; 
v_max = 294; 
v_increment = 0.01; % 每次增加0.01米/秒

% 初始条件和时间区间
w0 = [0; 0; 0];
tspan = [0 30];

% 迭代寻找最小速度
for v = v_min:v_increment:v_max
    odefun = @(t, w) [v * (targetX(t) - w(1)) / sqrt((targetX(t) - w(1))^2 + (targetY(t) - w(2))^2 + (targetZ(t) - w(3))^2);
                      v * (targetY(t) - w(2)) / sqrt((targetX(t) - w(1))^2 + (targetY(t) - w(2))^2 + (targetZ(t) - w(3))^2);
                      v * (targetZ(t) - w(3)) / sqrt((targetX(t) - w(1))^2 + (targetY(t) - w(2))^2 + (targetZ(t) - w(3))^2)];
    
    [t, w] = ode45(odefun, tspan, w0);
    
    % 计算每一时间点上的距离
    distances = sqrt((targetX(t) - w(:,1)).^2 + (targetY(t) - w(:,2)).^2 + (targetZ(t) - w(:,3)).^2);
    
    % 检查是否追上
    if any(distances < 1) % 假设追上的条件是距离小于1米
        idx = find(distances < 1, 1, 'first');
        catch_time = t(idx);
        fprintf('最小追击速度: %.2f 米/秒\n', v);
        fprintf('追踪器在 %.2f 秒内追上了目标。\n', catch_time);
        
        % 计算轨迹长度
        tracker_path_length = sum(sqrt(diff(w(:,1)).^2 + diff(w(:,2)).^2 + diff(w(:,3)).^2));
        target_path_length = sum(sqrt(diff(targetX(t)).^2 + diff(targetY(t)).^2 + diff(targetZ(t)).^2));
        fprintf('追踪器行进的轨迹长度: %.2f 米\n', tracker_path_length);
        fprintf('目标行进的轨迹长度: %.2f 米\n', target_path_length);
        
        % 绘制轨迹图
        figure;
        hold on;
        fplot3(targetX, targetY, targetZ, [0 30], 'r');
        plot3(w(:,1), w(:,2), w(:,3), 'b');
        title('目标和追踪器的轨迹');
        xlabel('X');
        ylabel('Y');
        zlabel('Z');
        legend('目标', '追踪器');
        grid on;
        
        break; % 找到最小速度后跳出循环
    end
end

if v == v_max
    fprintf('在最大速度 %d 米/秒内追踪器未能在30秒内追上目标。\n', v_max);
end

%% 第七题
% 目标位置的函数，假设从问题二中得到的参数已定义
targetX = @(t) a + b*t + A*cos(w1*t);
targetY = @(t) c + d*t + B*sin(w2*t);
targetZ = @(t) e + C*sin(w3*t);

% 设置初始速度范围
v_min = 0; % 初始速度
v_max = 400; % 最大速度
v_increment = 1; % 每次增加1米/秒

% 初始条件和时间区间
w0 = [0, 0, 0];
tspan = [0 30];

% 初始化最短时间变量
min_time = inf;
optimal_v = 0;

% 迭代寻找最小追击时间的速度
for v = v_min:v_increment:v_max
    odefun = @(t, w) [v * (targetX(t) - w(1)) / sqrt((targetX(t) - w(1))^2 + (targetY(t) - w(2))^2 + (targetZ(t) - w(3))^2);
                      v * (targetY(t) - w(2)) / sqrt((targetX(t) - w(1))^2 + (targetY(t) - w(2))^2 + (targetZ(t) - w(3))^2);
                      v * (targetZ(t) - w(3)) / sqrt((targetX(t) - w(1))^2 + (targetY(t) - w(2))^2 + (targetZ(t) - w(3))^2)];
    
    [t, w] = ode45(odefun, tspan, w0);
    
    % 计算每一时间点上的距离
    distances = sqrt((targetX(t) - w(:,1)).^2 + (targetY(t) - w(:,2)).^2 + (targetZ(t) - w(:,3)).^2);
    
    % 检查是否追上并计算追上时间
    if any(distances < 1) % 假设追上的条件是距离小于1米
        idx = find(distances < 1, 1, 'first');
        catch_time = t(idx);
        fprintf('追击时间: %.2f 秒\n', catch_time);
        % 更新最短时间和最优速度
        if catch_time < min_time
            min_time = catch_time;
            optimal_v = v;
        end
    end
end

% 输出结果
if min_time < inf
    fprintf('最优追击速度: %.2f 米/秒\n', optimal_v);
    fprintf('最短追击时间: %.2f 秒\n', min_time);
    
    % 以最优速度绘制轨迹图
    odefun = @(t, w) [optimal_v * (targetX(t) - w(1)) / sqrt((targetX(t) - w(1))^2 + (targetY(t) - w(2))^2 + (targetZ(t) - w(3))^2);
                      optimal_v * (targetY(t) - w(2)) / sqrt((targetX(t) - w(1))^2 + (targetY(t) - w(2))^2 + (targetZ(t) - w(3))^2);
                      optimal_v * (targetZ(t) - w(3)) / sqrt((targetX(t) - w(1))^2 + (targetY(t) - w(2))^2 + (targetZ(t) - w(3))^2)];
    
    [t, w] = ode45(odefun, tspan, w0);
    
    figure;
    hold on;
    fplot3(targetX, targetY, targetZ, [0 30], 'r');
    plot3(w(:,1), w(:,2), w(:,3), 'b');
    title('目标和追踪器的轨迹');
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    legend('目标', '追踪器');
    grid on;
else
    fprintf('在最大速度 %d 米/秒内追踪器未能在30秒内追上目标。\n', v_max);
end
