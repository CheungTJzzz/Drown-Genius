%CREATEFIT(T,Z)
%  创建一个拟合。
%
%  要进行 '无标题拟合 1' 拟合的数据:
%      X 输入: t
%      Y 输出: z
%  输出:
%      fitresult: 表示拟合的拟合对象。
%      gof: 带有拟合优度信息的结构体。
%
%  另请参阅 FIT, CFIT, SFIT.

%  由 MATLAB 于 08-Jun-2024 11:30:58 自动生成


%% 拟合: '无标题拟合 1'。
% 设置 fittype 和选项。
ft = fittype( 'a+b*sin(c*x)', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Lower = [-Inf 0 0];
opts.StartPoint = [0.162611735194631 0.118997681558377 1];
opts.Upper = [Inf Inf 0.078];

% 对数据进行模型拟合。
[fitresult_z, gof] = fit( t1, z1, ft, opts );

% 绘制数据拟合图。
figure( 'Name', '拟合 z' );
h = plot( fitresult_z, t1, z1 );
legend( h, '真实数据', '拟合结果', 'Location', 'NorthEast', 'Interpreter', 'none' );
% 为坐标区加标签
xlabel( 't', 'Interpreter', 'none' );
ylabel( 'z', 'Interpreter', 'none' );
grid on


