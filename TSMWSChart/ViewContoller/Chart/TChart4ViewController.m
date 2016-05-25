//
//  TChart4ViewController.m
//  TSMWSChart
//
//  Created by ways on 16/5/20.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TChart4ViewController.h"

@interface CubicLineSampleFillFormatter : NSObject <ChartFillFormatter>
{
}
@end

@implementation CubicLineSampleFillFormatter

- (CGFloat)getFillLinePositionWithDataSet:(LineChartDataSet *)dataSet dataProvider:(id<LineChartDataProvider>)dataProvider
{
    return -10.f;
}

@end



@interface TChart4ViewController ()<ChartViewDelegate,PieChartAnimationStopDelegate>

@property (weak, nonatomic) IBOutlet LineChartView *lineChartView;

@property (strong, nonatomic) IBOutlet BarChartView *barChartView;



@property (strong, nonatomic) IBOutlet PieChartView *pieChartView;

@end

@implementation TChart4ViewController
/////////////////////////////////////////////////   TChart4ViewController
/////////////////////////////////////////////////     导入Charts组件 使用swift语言实现的 类型相对来说比较全
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////
/////////////////////////////////////////////////
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    [self setLineChartView];
    
    [self setLineChartData];
    
    
    ////
    [self setupBarChartView];
    [self setBarChartData];
    
    
    ////
    [self setupPieChartView];
    [self setPieChartData];
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

///////LineChartView

- (void)setLineChartView{
    _lineChartView.delegate = self;
    
    _lineChartView.noDataTextDescription = @"";
    _lineChartView.descriptionText = @"";
    _lineChartView.rightAxis.enabled = NO;
    _lineChartView.leftAxis.enabled = NO;
    _lineChartView.doubleTapToZoomEnabled = NO;
    _lineChartView.pinchZoomEnabled = NO;
    _lineChartView.legend.enabled = NO;
    _lineChartView.gridBackgroundColor = [UIColor whiteColor];
    
    ChartXAxis *xAxis = _lineChartView.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    xAxis.labelFont = [UIFont systemFontOfSize:12.f];
    xAxis.spaceBetweenLabels = 50.f;
    xAxis.drawLabelsEnabled = NO;

}

- (void)setLineChartData
{
    
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    int totalNum = 10;
    for (int i = 0; i < totalNum; i++)
    {
        [xVals addObject:[@(i) stringValue]];
    }
    
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < totalNum; i++)
    {
        NSString *saleStr = [@(i < totalNum/2 ? i : totalNum - i) stringValue];
        
        NSNumberFormatter *numDecimal = [[NSNumberFormatter alloc] init];
        [numDecimal setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber *saleNum = [numDecimal numberFromString:saleStr];
        NSString *tempSaleStr = [NSString stringWithFormat:@"%.1f", [saleNum floatValue]];
        CGFloat saleValue = [tempSaleStr floatValue];
        
        [yVals addObject:[[BarChartDataEntry alloc] initWithValue:saleValue xIndex:i]];
    }
    
    LineChartDataSet *set1 = [[LineChartDataSet alloc] initWithYVals:yVals label:@"DataSet 1"];
    set1.drawCubicEnabled = NO;
    set1.drawFilledEnabled = YES;
    set1.cubicIntensity = 0.2;
    set1.drawCirclesEnabled = NO;
    set1.lineWidth = 1.0;
    set1.circleRadius = 4.0;
    [set1 setCircleColor:UIColor.whiteColor];
    set1.highlightColor = [UIColor colorWithRed:244/255.f green:117/255.f blue:117/255.f alpha:1.f];
    [set1 setColor:[UIColor colorWithRed:31/255.0f green:114/255.0f blue:214/255.0f alpha:1.0f]];
    set1.fillColor = [UIColor colorWithRed:31/255.0f green:114/255.0f blue:214/255.0f alpha:1.0f];
    set1.fillAlpha = .5f;
    set1.drawHorizontalHighlightIndicatorEnabled = NO;
    set1.fillFormatter = [[CubicLineSampleFillFormatter alloc] init];
    set1.highlightColor = [UIColor colorWithRed:108/255.0f green:108/255.0f blue:108/255.0f alpha:1.0f];
    
    LineChartData *data = [[LineChartData alloc] initWithXVals:xVals dataSet:set1];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:9.f]];
    [data setDrawValues:NO];
    
    _lineChartView.data = data;
    
    [_lineChartView animateWithXAxisDuration:0.5 yAxisDuration:0.5];
    
    
}

///////BarChartView

- (void)setupBarChartView
{
    self.barChartView.delegate = self;
    
    _barChartView.noDataTextDescription = @"";
    _barChartView.drawBarShadowEnabled = NO;
    _barChartView.drawValueAboveBarEnabled = NO;
    _barChartView.descriptionText = @"";
    _barChartView.rightAxis.enabled = NO;
    _barChartView.leftAxis.enabled = NO;
    _barChartView.doubleTapToZoomEnabled = NO;
    _barChartView.pinchZoomEnabled = NO;
    _barChartView.legend.enabled = NO;
    _barChartView.gridBackgroundColor = [UIColor whiteColor];
    
    ChartXAxis *xAxis = _barChartView.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    xAxis.labelFont = [UIFont systemFontOfSize:12.f];
    xAxis.spaceBetweenLabels = 50.f;
    xAxis.drawLabelsEnabled = NO;

}


- (void)setBarChartData
{
    
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    int totalNum = 20;
    for (int i = 0; i < totalNum; i++)
    {
        [xVals addObject:[@(i) stringValue]];
    }
    
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < totalNum; i++)
    {
        NSString *saleStr = [@(i < totalNum/2 ? i : totalNum - i) stringValue];
        
        NSNumberFormatter *numDecimal = [[NSNumberFormatter alloc] init];
        [numDecimal setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber *saleNum = [numDecimal numberFromString:saleStr];
        NSString *tempSaleStr = [NSString stringWithFormat:@"%.1f", [saleNum floatValue]];
        CGFloat saleValue = [tempSaleStr floatValue];
        
        [yVals addObject:[[BarChartDataEntry alloc] initWithValue:saleValue xIndex:i]];
    }
    
    BarChartDataSet *set1 = [[BarChartDataSet alloc] initWithYVals:yVals label:@"DataSet"];
    set1.barSpace = 0.35;
    set1.drawValuesEnabled = NO;
    set1.colors = @[[UIColor colorWithRed:31/255.0f green:114/255.0f blue:214/255.0f alpha:1.0f]];
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
    
    BarChartData *data = [[BarChartData alloc] initWithXVals:xVals dataSets:dataSets];
    //    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10.f]];
    
    _barChartView.data = data;
    
    [_barChartView animateWithYAxisDuration:0.5];
    
    
}




//////_pieChartView

- (void)setupPieChartView
{
    _pieChartView.delegate = self;
    _pieChartView.stopDelegate = self;
    
    _pieChartView.usePercentValuesEnabled = YES;
    _pieChartView.holeTransparent = YES;
    _pieChartView.holeRadiusPercent = 0.58;
    _pieChartView.transparentCircleRadiusPercent = 0.61;
    [_pieChartView setExtraOffsetsWithLeft:5.f top:10.f right:5.f bottom:5.f];
    _pieChartView.drawCenterTextEnabled = YES;
    _pieChartView.drawHoleEnabled = NO;
    _pieChartView.rotationAngle = 0.f;
    _pieChartView.rotationEnabled = YES;
    _pieChartView.highlightEnabled = YES;
    _pieChartView.backgroundColor = [UIColor clearColor];
    _pieChartView.legend.enabled = NO;
    _pieChartView.descriptionText = @"";
}


- (void)setPieChartData
{
    NSMutableArray *yVals1 = [[NSMutableArray alloc] init];
    int totalNum = 5;
    for (NSInteger i = 0; i < totalNum; i++) {
        [yVals1 addObject:[[BarChartDataEntry alloc] initWithValue:[@(i < totalNum/2 ? i : totalNum - i) floatValue] xIndex:i]];
    }
    
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < totalNum; i++) {
        [xVals addObject:[@(i) stringValue]];
    }
    
    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithYVals:yVals1 label:@""];
    dataSet.sliceSpace = 0.f;
    
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    [colors addObjectsFromArray:ChartColorTemplates.colorful];
    [colors addObjectsFromArray:ChartColorTemplates.joyful];
    [colors addObjectsFromArray:ChartColorTemplates.joyful];
    [colors addObjectsFromArray:ChartColorTemplates.liberty];
    [colors addObjectsFromArray:ChartColorTemplates.pastel];
    [colors addObject:[UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f]];
    
    dataSet.colors = colors;
    
    PieChartData *data = [[PieChartData alloc] initWithXVals:xVals dataSet:dataSet];
    NSNumberFormatter *pFormatter = [[NSNumberFormatter alloc] init];
    pFormatter.numberStyle = NSNumberFormatterPercentStyle;
    pFormatter.maximumFractionDigits = 1;
    pFormatter.multiplier = @1.f;
    pFormatter.percentSymbol = @" %";
    [data setValueFormatter:pFormatter];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11.f]];
    [data setValueTextColor:UIColor.blackColor];
    
    _pieChartView.data = data;
    [_pieChartView highlightValues:nil];
    
    [_pieChartView animateWithYAxisDuration:1.f easingOption:ChartEasingOptionEaseOutBack];
    
}


#pragma MARK - ChartViewDelegate

- (void)chartValueSelected:(ChartViewBase * _Nonnull)chartView entry:(ChartDataEntry * _Nonnull)entry dataSetIndex:(NSInteger)dataSetIndex highlight:(ChartHighlight * _Nonnull)highlight{
    NSLog(@"value:%f---index:%ld",entry.value,(long)entry.xIndex);
    
    NSLog(@"dataSetIndex:%ld",(long)dataSetIndex);
    
    
    
    if (chartView == _pieChartView) {
        CGFloat pieAngle;
         pieAngle = 84;//84 75
        CGPoint p = [chartView getMarkerPositionWithEntry:entry highlight:highlight];
        CGFloat toAngle = [_pieChartView angleForPointWithX:p.x y:p.y];
        
        CGPoint p0 = [_pieChartView getMarkerPositionWithEntry:[_pieChartView.data.dataSets[dataSetIndex] entryForXIndex:0] highlight:highlight];
        CGFloat toAngle0 = [_pieChartView angleForPointWithX:p0.x y:p0.y];
        
        [_pieChartView spinWithDuration:1.f fromAngle:_pieChartView.rotationAngle toAngle:(pieAngle-(toAngle-toAngle0))];

    }
}

- (void)chartValueNothingSelected:(ChartViewBase * _Nonnull)chartView{
    
}

- (void)chartScaled:(ChartViewBase * _Nonnull)chartView scaleX:(CGFloat)scaleX scaleY:(CGFloat)scaleY{
    
}

- (void)chartTranslated:(ChartViewBase * _Nonnull)chartView dX:(CGFloat)dX dY:(CGFloat)dY{
    
}



#pragma mark - PieChartAnimationStopDelegate


- (void)pieChartAnimationStop:(CGFloat)rotationAngle{
    NSLog(@"pieChartAnimationStop:%lf",rotationAngle);
    
}

- (void)pieChartRotating{
    NSLog(@"pieChartRotating");
    
}

@end
















