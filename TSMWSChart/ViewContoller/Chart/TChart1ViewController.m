//
//  TChart1ViewController.m
//  test
//
//  Created by ways on 16/4/14.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TChart1ViewController.h"

#import "ZCharsManager.h"

// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface TChart1ViewController ()<ZCharsManagerDelegate,ZCharsDataSource>
{
    NSArray *_dataArray;
    UILabel *_dataLabel;
}
@end

@implementation TChart1ViewController

/////////////////////////////////////////////////
/////////////////////////////////////////////////   TChart1ViewController        pods 导入的ZCharts框架
//////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////
/////////////////////////////////////////////////

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSNumber *num1 = [[NSNumber alloc] initWithInt:123456789];
    NSString *num1St = [NSNumberFormatter localizedStringFromNumber:num1 numberStyle:NSNumberFormatterCurrencyStyle];
    NSLog(@"num1St:%@",num1St);
    NSString *num2St = [NSNumberFormatter localizedStringFromNumber:num1 numberStyle:NSNumberFormatterDecimalStyle];
    NSLog(@"num2St:%@",num2St);
    NSString *num3St = [NSNumberFormatter localizedStringFromNumber:num1 numberStyle:NSNumberFormatterPercentStyle];
    NSLog(@"num3St:%@",num3St);
    NSString *num4St = [NSNumberFormatter localizedStringFromNumber:num1 numberStyle:NSNumberFormatterScientificStyle];
    NSLog(@"num4St:%@",num4St);
    
    [self initChartView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)initChartView{
    _dataArray = @[
                   @{
                       @"data": @[@(120), @(132), @(101), @(134), @(90), @(230), @(210)],
                       @"unit": @"°C",
                       @"xAxis": @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"]
                       },
                   @{
                       @"data": @[@(-1), @(182), @(191), @(234), @(290), @(330), @(310)],
                       @"unit": @"°C",
                       @"xAxis": @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"]
                       }
                   ];
    
    //
    ZCharsManager *zcharsManager = [[ZCharsManager alloc] initWithFrame:CGRectMake(0, 200, self.view.frame
                                                                                   .size.width, 200)];
    
    // 设置代理
    zcharsManager.delegate = self;
    zcharsManager.dataSource = self;
    [self.view addSubview:zcharsManager];
    
    // 选择绘制类型为曲线图
    zcharsManager.zcharsType = ZCharsTypeLine;
    
    // 设置左侧刻度样式
    zcharsManager.leftView.backgroundColor = [UIColor whiteColor];
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSTextAlignmentRight;
    NSDictionary *fontDict = @{
                               NSFontAttributeName :            [UIFont systemFontOfSize:10.0],
                               NSForegroundColorAttributeName : UIColorFromRGB(0xa0a0a0),
                               NSParagraphStyleAttributeName:    paragraph
                               };
    zcharsManager.leftView.fontDict = fontDict;
    //    zcharsManager.leftView.width = 35;
    
    zcharsManager.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ZCharsBg"]];
    //    zcharsManager.leftView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ZCharsBg"]];
    
    NSMutableParagraphStyle *paragraph2 = [[NSMutableParagraphStyle alloc] init];
    paragraph2.alignment = NSTextAlignmentLeft;
    NSDictionary *fontDict2 = @{
                                NSFontAttributeName :            [UIFont systemFontOfSize:10.0],
                                NSForegroundColorAttributeName : UIColorFromRGB(0xa0a0a0),
                                NSParagraphStyleAttributeName:    paragraph2
                                };
    zcharsManager.rightView.XAxisFont = fontDict2;
}


#pragma mark - ZCharsDataSource

//*********** lineDelegate ***************

/**
 *  每个 cell 绘制几条线
 *
 *  @param zcharsManager
 *
 *  @return
 */
- (NSInteger)lineNumberOfInZCharsManager:(ZCharsManager *)zcharsManager{
    return _dataArray.count;
}

/**
 *  数据条数
 *
 *  @param collectionView
 *  @param section
 *
 *  @return
 */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_dataArray[section][@"data"] count];
}


/**
 *  曲线图代理方法
 *
 *  @param cell
 *  @param lineNumber
 *
 *  @return
 */
- (CGFloat)dataOflineNumberZCharsManager:(NSIndexPath *)indexPath lineNumber:(NSInteger)lineNumber{
    NSNumber *num = _dataArray[lineNumber][@"data"][indexPath.row];
    NSLog(@"%@",num);
    return [num floatValue];
}

/**
 *  线条颜色
 *
 *  @param lineNumber <#lineNumber description#>
 *
 *  @return <#return value description#>
 */
- (UIColor *)lineColorOflineNumber:(NSInteger)lineNumber{
    if (lineNumber == 0) {
        return UIColorFromRGB(0xff6600);
    } else {
        return UIColorFromRGB(0x0099ff);
    }
}

/**
 *  X轴绘制文字
 *
 *  @param cell
 *  @param lineNumber
 *
 *  @return
 */
- (NSString *)xAxisOflineNumberZCharsManager:(ZCharsLineViewCell *)cell lineNumber:(NSInteger)lineNumber{
    return _dataArray[lineNumber][@"xAxis"][cell.indexPath.row];
}
#pragma mark - ZCharsDataSource

- (void)didScrollViewDidScroll:(NSIndexPath *)indexPath paopaoView:(UIImageView *)paopaoView{
    if (_dataLabel == nil) {
        _dataLabel = [[UILabel alloc] initWithFrame:CGRectMake(6, 0, paopaoView.frame.size.width, 21)];
        _dataLabel.font = [UIFont systemFontOfSize:12.0];
        _dataLabel.textColor = UIColorFromRGB(0xffffff);
        [paopaoView addSubview:_dataLabel];
    }
    _dataLabel.text = [NSString stringWithFormat:@"%@   %@%@",
                       _dataArray[1][@"xAxis"][indexPath.row],
                       _dataArray[1][@"data"][indexPath.row],
                       _dataArray[1][@"unit"]];
}

/**
 *  行数
 *
 *  @param zcharsManager
 *  @param rowCount
 *
 *  @return
 */
- (NSInteger)rowContInZCharsManager:(ZCharsManager *)zcharsManager{
    
    return 5;
}

/**
 *  每列宽度
 *
 *  @param zcharsManager
 *
 *  @return
 */
- (CGFloat)columnWidthInZCharsManager:(ZCharsManager *)zcharsManager{
    return 60;
}


/**
 *  刻度区间, 最大值,最小值, 不设置则自动计算
 *
 *  @param zcharsManager
 *
 *  @return
 */
- (ZChasValue)valueSectionInZCharsManager:(ZCharsManager *)zcharsManager{
    
    return ZChasValueMake(0, 400);
}


/**
 *  间距
 *
 *  @param zcharsManager
 *
 *  @return
 */
- (UIEdgeInsets)rightInsetsInZCharsManager:(ZCharsManager *)zcharsManager{
    return UIEdgeInsetsMake(0, 70, 45, 45);
}

/**
 *  滑块 view
 *  只可改变 paopaoview 的width 和 Y. 属性
 *
 *  @param zcharsManager
 *
 *  @return
 */
- (UIImageView *)paopaoViewInZCharsManager:(ZCharsManager *)zcharsManager{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ZcharsPaopao"]];
    return imageView;
}

/**
 *  collectionView header
 *
 *  @param zcharsManager
 *
 *  @return
 */
- (NSString *)headerViewInZCharsManager:(ZCharsManager *)zcharsManager{
    return @"ZCharsHeaderView";
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
