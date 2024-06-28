%% 第一题
% 读取数据
data1 = load('data1.txt'); % 假设文件格式为 [t, x, y, z]
t1 = data1(:, 1);
x1 = data1(:, 2);
y1 = data1(:, 3);
z1 = data1(:, 4);

% 计算速度
dt = diff(t1);
dx = diff(x1);
dy = diff(y1);
dz = diff(z1);
speed = sqrt((dx./dt).^2 + (dy./dt).^2 + (dz./dt).^2);

% 找到最大和最小速度
max_speed = max(speed);
min_speed = min(speed);

fprintf('最大速度: %f 米/秒\n', max_speed);
fprintf('最小速度: %f 米/秒\n', min_speed);
