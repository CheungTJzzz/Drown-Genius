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

fitted_x = a + b*t1 + A*cos(w1*t1);
fitted_y = c + d*t1 + 350*sin(w2*t1);
fitted_z = e + C*sin(w3*t1);
figure;
plot3(x1, y1, z1, 'r.', fitted_x, fitted_y, fitted_z, 'b-');
xlabel('x'); ylabel('y'); zlabel('z');
title('运动轨迹拟合');
legend('原始数据', '拟合曲线', 'Location', 'best');
grid on;


% 计算速度
speed_fit = sqrt((b-A*w1*sin(w1*t1)).^2 + (d+B*w2*cos(w2*t1)).^2 + ((C*w3*cos(w3*t1)).^2));

% 绘制速度图
figure;
plot(t1, speed_fit, 'b-');
xlabel('时间 (秒)');
ylabel('速度 (米/秒)');
title('速度图');
grid on;


% 最大和最小速度
max_speed_fit = max(speed_fit);
min_speed_fit = min(speed_fit);

fprintf('拟合最大速度: %f 米/秒\n', max_speed_fit);
fprintf('拟合最小速度: %f 米/秒\n', min_speed_fit);
