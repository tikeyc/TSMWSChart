//
//  TChart2ViewController.m
//  test
//
//  Created by ways on 16/4/14.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TChart2ViewController.h"


#import "TSMWSCommon.h"

#import "ZXPAutoLayout.h"


@interface TChart2ViewController ()
@property (strong, nonatomic) IBOutlet UIView *lineBaseView;
@property (strong, nonatomic) IBOutlet UIView *lineBaseView2;

//@property (strong, nonatomic) IBOutlet SMWSBaseGraphView *graphView;

@property (strong, nonatomic)TSMWSBaseGraphView *graphView;
@property (strong, nonatomic)TSMWSBaseGraphView *graphView2;

@property (nonatomic, strong) THistogramInfoDrawingDataSource *histogramDataSource;
@property (nonatomic, strong) TLinearInfoDrawingDataSource *linearDataSource;
@property (nonatomic, strong) TSecondLinearInfoDrawingDataSource *secondLinearDataSource;
@property (nonatomic, strong) TAxisXYInfoDrawingDataSource *axisDataSource;
@property (nonatomic, strong) TSecondAxisXYInfoDrawingDataSource *secondAxisDataSource;

@property (nonatomic, strong) TSMWSHistogramDrawing *histogramDrawing;
@property (nonatomic, strong) TSMWSLinearDrawing *linearDrawing;
@property (nonatomic, strong) TSMWSLinearDrawing *secondLinearDrawing;
@property (nonatomic, strong) TSMWSStandardAxisRenderer *axisRenderer;
@property (nonatomic, strong) TSMWSStandardAxisRenderer *secondAxisRenderer;

@end

@implementation TChart2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"%d",(1<<16));
    NSInteger index = 2 + (1<<16);
    NSLog(@"%ld",(long)index);
    
    
    [self addLineView];
    
    [self performSelector:@selector(setDatas) withObject:nil afterDelay:1];
    [self performSelector:@selector(setCircle) withObject:nil afterDelay:1];
    
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


#pragma mark - init 

/////// 折线
- (TSMWSLinearDrawing *)linearDrawing
{
    if (!_linearDrawing)
    {
        _linearDrawing = [[TSMWSLinearDrawing alloc] init];
        [_linearDrawing setDataSource:[self linearDataSource]];
    }
    
    return _linearDrawing;
}

- (TLinearInfoDrawingDataSource *)linearDataSource
{
    if (!_linearDataSource)
    {
        _linearDataSource = [[TLinearInfoDrawingDataSource alloc] init];
    }
    
    return _linearDataSource;
}

//
- (TSMWSStandardAxisRenderer *)axisRenderer
{
    if (!_axisRenderer)
    {
        _axisRenderer = [[TSMWSStandardAxisRenderer alloc] init];
        [_axisRenderer setDataSource:[self axisDataSource]];
        [_axisRenderer setHeaderHeight:30];
    }
    
    return _axisRenderer;
}

- (TAxisXYInfoDrawingDataSource *)axisDataSource
{
    if (!_axisDataSource)
    {
        _axisDataSource = [[TAxisXYInfoDrawingDataSource alloc] init];
    }
    
    return _axisDataSource;
}

////////////////////直方图 + 折线

//直方
- (TSMWSHistogramDrawing *)histogramDrawing
{
    if (!_histogramDrawing)
    {
        _histogramDrawing = [[TSMWSHistogramDrawing alloc] init];
        [_histogramDrawing setDataSource:[self histogramDataSource]];
    }
    
    return _histogramDrawing;
}

- (THistogramInfoDrawingDataSource *)histogramDataSource
{
    if (!_histogramDataSource)
    {
        _histogramDataSource = [[THistogramInfoDrawingDataSource alloc] init];
    }
    
    return _histogramDataSource;
}

//折线

- (TSMWSLinearDrawing *)secondLinearDrawing
{
    if (!_secondLinearDrawing)
    {
        _secondLinearDrawing = [[TSMWSLinearDrawing alloc] init];
        [_secondLinearDrawing setDataSource:[self secondLinearDataSource]];
    }
    
    return _secondLinearDrawing;
}

- (TSecondLinearInfoDrawingDataSource *)secondLinearDataSource
{
    if (!_secondLinearDataSource)
    {
        _secondLinearDataSource = [[TSecondLinearInfoDrawingDataSource alloc] init];
    }
    
    return _secondLinearDataSource;
}

- (TSMWSStandardAxisRenderer *)secondAxisRenderer
{
    if (!_secondAxisRenderer)
    {
        _secondAxisRenderer = [[TSMWSStandardAxisRenderer alloc] init];
        [_secondAxisRenderer setDataSource:[self secondAxisDataSource]];
        [_secondAxisRenderer setHeaderHeight:30];
    }
    
    return _secondAxisRenderer;
}

- (TSecondAxisXYInfoDrawingDataSource *)secondAxisDataSource
{
    if (!_secondAxisDataSource)
    {
        _secondAxisDataSource = [[TSecondAxisXYInfoDrawingDataSource alloc] init];
    }
    
    return _secondAxisDataSource;
}


#pragma mark - add

- (void)addLineView{
    _graphView = [[TSMWSBaseGraphView alloc] initWithFrame:CGRectMake(10, 50, ScreenWidth - 80, 320)];
    [_graphView setBackgroundColor:[UIColor clearColor]];
    
    [_graphView setLeftMargin:30];
    [_graphView setRightMargin:20];
    [_graphView setBottomMargin:20];
    [_graphView setTopMargin:50];
    [_graphView setGroupWidth:(ScreenWidth - 80 - _graphView.leftMargin - _graphView.rightMargin - 25)/12];
    [self.lineBaseView addSubview:_graphView];
    [_graphView zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.edgeInsets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
//    [_graphView reloadData];//如果马上刷新 会出现线图错位问题，我猜是有些位置信息还没设置好就提前画折线了
    
    _graphView2 = [[TSMWSBaseGraphView alloc] initWithFrame:CGRectMake(10, 50, ScreenWidth - 80, 320)];
    [_graphView2 setBackgroundColor:[UIColor clearColor]];
    
    [_graphView2 setLeftMargin:30];
    [_graphView2 setRightMargin:20];
    [_graphView2 setBottomMargin:20];
    [_graphView2 setTopMargin:50];
    [_graphView2 setGroupWidth:(ScreenWidth - 80 - _graphView2.leftMargin - _graphView2.rightMargin - 25)/12];
    [self.lineBaseView2 addSubview:_graphView2];
    [_graphView2 zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.edgeInsets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)setDatas{
    //设置X,Y轴刻度
    self.axisDataSource.segmentsAtAxisXs = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"];
    self.axisDataSource.segmentsAtAxisYs = @[@"0",@"25",@"50",@"75",@"100"];
    self.axisDataSource.headerElements = @[
                                           @{headerElements_text_key:@"test1",
                                             headerElements_color_key:[UIColor purpleColor],
                                             headerElements_index_key:@(0),
                                             headerElements_type_key:@(TWSElementTypeLineSpot)},
                                          @{headerElements_text_key:@"test2",
                                            headerElements_color_key:[UIColor orangeColor],
                                            headerElements_index_key:@(1),
                                            headerElements_type_key:@(TWSElementTypeLineSpot)}
  ];
    [_graphView setAxisRenderers:@[[self axisRenderer]]];
    //设置坐标点数据
    self.linearDataSource.lineSectionDatas = [self setLineDataModelWithIndexNum:2];
    self.linearDataSource.lineIndexColors = @[[UIColor purpleColor],[UIColor orangeColor]];
    [_graphView setDrawingStrategys:@[[self linearDrawing]]];//单先
    //刷选标图
    [_graphView reloadData];
}

//TLineBaseModel
- (NSMutableArray *)setLineDataModelWithIndexNum:(NSInteger)indexNum{
    NSMutableArray *lineSectionDatas = [NSMutableArray array];
    for (int index = 0; index < indexNum; index++) {
        NSMutableArray *lineIndexDatas = [NSMutableArray array];
        [lineSectionDatas addObject:lineIndexDatas];
        for (int i = 0; i < 10; i++) {
            TLineBaseModel *lineModel = [[TLineBaseModel alloc] init];
            NSInteger ad = i < 5 ? i : 10 - i;
            lineModel.value = @(10*(ad + index)*(index + 1));
            [lineIndexDatas addObject:lineModel];
        }
    }
    
    return lineSectionDatas;
}

//////////////////////////折线图，直方图混合

- (void)setCircle{
    /////////////单线加柱状图
    ////设置X,Y轴刻度
    self.axisDataSource.segmentsAtAxisXs = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"];
    self.axisDataSource.segmentsAtAxisYs = @[@"0",@"25",@"50",@"75",@"100"];
//    self.axisDataSource.headerElements = //与第一个共用头部按钮
    //
    self.secondAxisDataSource.segmentsAtAxisXs = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8"];
    self.secondAxisDataSource.segmentsAtAxisYs = @[@"0",@"40",@"80",@"120",@"160",@"200"];
    self.secondAxisDataSource.headerElements = @[
                                                 @{headerElements_text_key:@"test1",
                                                   headerElements_color_key:[UIColor purpleColor],
                                                   headerElements_index_key:@(0),
                                                   headerElements_type_key:@(TWSElementTypeColorRect)},
                                                 @{headerElements_text_key:@"test2",
                                                   headerElements_color_key:[UIColor cyanColor],
                                                   headerElements_index_key:@(1),
                                                   headerElements_type_key:@(TWSElementTypeColorRect)},
                                                 
                                                 @{headerElements_text_key:@"test3",
                                                   headerElements_color_key:[UIColor orangeColor],
                                                   headerElements_index_key:@(0),
                                                   headerElements_type_key:@(TWSElementTypeLineSpot)},
                                                 @{headerElements_text_key:@"test4",
                                                   headerElements_color_key:[UIColor blueColor],
                                                   headerElements_index_key:@(1),
                                                   headerElements_type_key:@(TWSElementTypeLineSpot)}
                                                 ];//与第一个共用头部按钮
    [_graphView2 setAxisRenderers:@[[self axisRenderer],[self secondAxisRenderer]]];
//    [_graphView2 setAxisRenderers:@[[self secondAxisRenderer],[self axisRenderer]]];
    ////设置坐标点数据
    //直方图
    self.histogramDataSource.lineSectionDatas = [self setLineDataModelWithIndexNum:2];;
    self.histogramDataSource.lineIndexColors = @[[UIColor purpleColor],[UIColor cyanColor]];
    //折线
    self.secondLinearDataSource.lineSectionDatas = [self setLineDataModelWithIndexNum:2];;
    self.secondLinearDataSource.lineIndexColors = @[[UIColor orangeColor],[UIColor blueColor]];
    [_graphView2 setDrawingStrategys:@[[self histogramDrawing],
                                      [self secondLinearDrawing]]];
    //刷选标图
    [_graphView2 reloadData];
}

@end
