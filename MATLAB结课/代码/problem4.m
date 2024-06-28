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
plot3(x1, y1, z1, 'r-', y_sol_4(:, 1), y_sol_4(:, 2), y_sol_4(:, 3), 'b-');
xlabel('x');
ylabel('y');
zlabel('z');
title('移动目标和跟踪器的轨迹');
legend('目标轨迹', '跟踪器轨迹');
grid on;