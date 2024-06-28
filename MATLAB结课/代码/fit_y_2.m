%CREATEFIT(T1,Y1)
%  创建一个拟合。
%
%  要进行 '无标题拟合 1' 拟合的数据:
%      X 输入: t1
%      Y 输出: y1
%  输出:
%      fitresult: 表示拟合的拟合对象。
%      gof: 带有拟合优度信息的结构体。
%
%  另请参阅 FIT, CFIT, SFIT.

%  由 MATLAB 于 08-Jun-2024 11:46:19 自动生成


%% 拟合: '无标题拟合 1'。
% 设置 fittype 和选项。
ft = fittype( 'a+b*x+c*sin(d*x)', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Lower = [-Inf -Inf 300 0.75];
opts.StartPoint = [0.890903252535798 0.959291425205444 0.547215529963803 0.138624442828679];
opts.Upper = [Inf Inf 500 1.5];

% 对数据进行模型拟合。
[fitresult_y, gof] = fit( t1, y1, ft, opts );

% 绘制数据拟合图。
figure( 'Name', '拟合 y' );
h = plot( fitresult_y, t1, y1 );
legend( h, '原始数据', '拟合结果', 'Location', 'NorthEast', 'Interpreter', 'none' );
% 为坐标区加标签
xlabel( 't1', 'Interpreter', 'none' );
ylabel( 'y1', 'Interpreter', 'none' );
grid on


