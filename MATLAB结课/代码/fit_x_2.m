%CREATEFIT(T1,X1)
%  创建一个拟合。
%
%  要进行 '无标题拟合 1' 拟合的数据:
%      X 输入: t1
%      Y 输出: x1
%  输出:
%      fitresult: 表示拟合的拟合对象。
%      gof: 带有拟合优度信息的结构体。
%
%  另请参阅 FIT, CFIT, SFIT.

%  由 MATLAB 于 08-Jun-2024 11:52:15 自动生成


%% 拟合: '无标题拟合 1'。
% 设置 fittype 和选项。
ft = fittype( 'a+b*x+c*cos(d*x)', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Lower = [-Inf -Inf 150 0.75];
opts.StartPoint = [0.149294005559057 0.257508254123736 0.840717255983663 0.254282178971531];
opts.Upper = [Inf Inf 300 1.5];

% 对数据进行模型拟合。
[fitresult_x, gof] = fit( t1, x1, ft, opts );

% 绘制数据拟合图。
figure( 'Name', 'x 拟合' );
h = plot( fitresult_x, t1, x1 );
legend( h, '原始数据', '拟合结果', 'Location', 'NorthEast', 'Interpreter', 'none' );
% 为坐标区加标签
xlabel( 't1', 'Interpreter', 'none' );
ylabel( 'x1', 'Interpreter', 'none' );
grid on


