//
//  TChart3ViewController.m
//  TSMWSChart
//
//  Created by ways on 16/5/19.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TChart3ViewController.h"

#import "PYEchartsView.h"
#import "PYOption.h"


@interface TChart3ViewController ()

@property (strong, nonatomic) IBOutlet PYEchartsView *echartsView;

@end

@implementation TChart3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    PYOption *option = [[PYOption alloc] init];
    ////标题
    PYTitle *title = [[PYTitle alloc] init];
    title.text = @"未来一周气温变化";
    title.subtext = @"纯属虚构";
    
    option.title = title;
    ////气泡提示试图 点击或者移动到某一点的信息提示视图
    PYTooltip *tooltip = [[PYTooltip alloc] init];
    tooltip.trigger = @"axis";// item:显示单一点的信息 axis：显示该点刻度上所有的信息
    
    option.tooltip = tooltip;
    ////设置直角坐标系整体的配置信息
    PYGrid *grid = [[PYGrid alloc] init];
    grid.x = @(40);// 整体坐标系到左边的边距
    grid.x2 = @(50);//整体坐标系到右边的边距
    
    option.grid = grid;
    ////图例，表述数据和图形的关联 头部按钮，点击隐藏，显示
    PYLegend *legend = [[PYLegend alloc] init];
    legend.data = @[@"最高温度",@"最低温度"];//头部按钮显示的文字
    
    option.legend = legend;
    ////辅助工具箱，辅助功能，如添加标线，框选缩放等
    PYToolbox *toolbox = [[PYToolbox alloc] init];
    toolbox.show = YES;
    toolbox.x = @"right";
    toolbox.y = @"top";
    toolbox.z = @(100);
    
    toolbox.feature.mark.show = YES;//是否显示一支笔的按钮，用于标记
    
    toolbox.feature.dataView.show = YES;//是否显示按钮 点击按钮可以显示详细的数据信息 //是否可以编辑数据信息
    toolbox.feature.dataView.readOnly = NO;//是否可以编辑数据信息
    
    toolbox.feature.magicType.show = YES;//是否显示折线和柱状图的类型按钮 点击按钮可以将当前坐标的数据以折线或者柱状图的形式显示 相互切换 //显示折线和柱状图按钮
    toolbox.feature.magicType.type = @[@"line", @"bar"];//需要显示的 折线 或 柱状图  或其他 按钮 类型
    
    toolbox.feature.restore.show = YES;//是否显示刷选按钮
    toolbox.feature.saveAsImage.show = YES;//是否保存按钮
    
    option.toolbox = toolbox;
    //    option.calculable = YES;
    
    /////直角坐标系中的横轴，通常并默认为 类目型！
    PYAxis *xAxis = [[PYAxis  alloc] init];
    xAxis.type = @"category";//category:类目型 value:数值型 time：时间型 log:指数型
    xAxis.boundaryGap = @(NO);
    xAxis.data = @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
    
    option.xAxis = [[NSMutableArray alloc] initWithObjects:xAxis, nil];
    
    /////直角坐标系中的纵轴，通常并默认为 数值型！
    PYAxis *yAxis = [[PYAxis alloc] init];
    yAxis.type = @"value";//category:类目型 value:数值型 time：时间型 log:指数型
    yAxis.axisLabel.formatter = @"{value} ℃";//显示格式 如拼接字符串等
    option.yAxis = [[NSMutableArray alloc] initWithObjects:yAxis, nil];
    
    ////////数据系列，一个图表可能包含多个系列，每一个系列可能包含多个数据
    PYSeries *series1 = [[PYSeries alloc] init];
    series1.name = @"最高温度";//该值 对应于气泡显示的格式PYMarkPoint的data的数据字典的键name显示的文字
    series1.type = @"line";//类型[NSArray arrayWithObjects:@"bar", @"chord", @"force", @"k", @"line", @"map", @"pie", @"radar", @"scatter", nil]
    series1.data = @[@(11),@(11),@(15),@(13),@(12),@(13),@(10)];
    
    ///气泡显示的格式
    PYMarkPoint *markPoint = [[PYMarkPoint alloc] init];
    markPoint.data = @[@{@"type" : @"max", @"name": @"最大值"},@{@"type" : @"min", @"name": @"最小值"}];
    series1.markPoint = markPoint;
    ///设置对某一系列的数据的平均数据线
    PYMarkLine *markLine = [[PYMarkLine alloc] init];
    markLine.data = @[@{@"type" : @"average", @"name": @"平均值"}];
    series1.markLine = markLine;
    
    //////////数据系列，一个图表可能包含多个系列，每一个系列可能包含多个数据
    PYSeries *series2 = [[PYSeries alloc] init];
    series2.name = @"最低温度";//该值 对应于气泡显示的格式PYMarkPoint的data的数据字典的键name显示的文字
    series2.type = @"line";
    series2.data = @[@(1),@(-2),@(2),@(5),@(3),@(2),@(0)];
    
    ///气泡显示的格式
    PYMarkPoint *markPoint2 = [[PYMarkPoint alloc] init];
    markPoint2.data = @[@{@"value" : @(2), @"name": @"周最低", @"xAxis":@(1), @"yAxis" : @(-1.5)}];
    series2.markPoint = markPoint2;
    
    ///设置对某一系列的数据的平均数据线
    PYMarkLine *markLine2 = [[PYMarkLine alloc] init];
    markLine2.data = @[@{@"type" : @"average", @"name": @"平均值"}];
    series2.markLine = markLine2;
    option.series = [[NSMutableArray alloc] initWithObjects:series1, series2, nil];
    
/////////////////////////////////////////////////////
    [self.echartsView setOption:option];
    
    [self.echartsView loadEcharts];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
