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

%% 进一步搜索

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
        hold off;
        break; % 找到最小速度后跳出循环
    end
end

if v == v_max
    fprintf('在最大速度 %d 米/秒内追踪器未能在30秒内追上目标。\n', v_max);
end

