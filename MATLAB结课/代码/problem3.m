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
plot3(x1, y1, z1, 'r-', y_sol_3(:, 1), y_sol_3(:, 2), y_sol_3(:, 3), 'b-');
xlabel('x');
ylabel('y');
zlabel('z');
title('移动目标和跟踪器的轨迹');
legend('目标轨迹', '跟踪器轨迹');
grid on;