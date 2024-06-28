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
