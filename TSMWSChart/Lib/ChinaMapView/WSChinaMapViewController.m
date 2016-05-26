//
//  WSChinaMapViewController.m
//  SgmTest
//
//  Created by Ansonyc on 14-5-22.
//  Copyright (c) 2014年 T. All rights reserved.
//

#import "WSChinaMapViewController.h"
#import "JSONKit.h"
#import "OBShapedButton.h"

@interface WSChinaMapViewController ()
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UISegmentedControl *navigationSegment;
@end

@implementation WSChinaMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    //
    NSString *regionJsonPath = [[NSBundle mainBundle] pathForResource:@"AreaInfoJson" ofType:@"geojson"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:regionJsonPath];
    if (!data) {
        return;
    }
    NSError *error;
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];

//    NSString *result = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AreaInfoJson"
//                                                                                        ofType:@"geojson"]
//                                               encoding:NSUTF8StringEncoding
//                                                  error:NULL];
//    NSArray *datas = [result objectFromJSONString][@"data"];
    
    NSArray *datas = result[@"data"][@"data"];
    NSMutableArray *areaList = [[NSMutableArray alloc] init];
    for (int i = 0; i < [datas count]; i++)
    {
        WSAreaInfo *area = [WSAreaInfo areaFromDictionary:datas[i] with:Analysis_SalesWholeMarket];
        if (area)
        {
            [areaList addObject:area];
        }
    }

    [self setAreaList:areaList];
    [self setAreaInfo:areaList[0]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Private Methods

- (void)SGM_buildProvinceMap
{
    NSString *mapFileName = [NSString stringWithFormat:@"%@ - %@",
                             [[self areaInfo] areaName],
                             [[self areaInfo] areaID]];
    NSArray *cities =
    [[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:mapFileName
                                                                        ofType:@"json"]
                               encoding:NSUTF8StringEncoding
                                  error:nil] objectFromJSONString];

    for (NSDictionary *city in cities)
    {
        OBShapedButton *cityButton = [[OBShapedButton alloc] init];
        [cityButton setTag:[city[@"id"] intValue]];
        [cityButton setImageName:city[@"imageName"]];
//        [cityButton setImage:[UIImage imageNamed:
//                              [[cityButton imageName] stringByReplacingOccurrencesOfString:@".png"
//                                                                                withString:@"_red.png"]]
//                        forState:UIControlStateHighlighted];
//        [cityButton setImage:[UIImage imageNamed:
//                              [[cityButton imageName] stringByReplacingOccurrencesOfString:@".png"
//                                                                                withString:@"_red.png"]]
//                    forState:UIControlStateDisabled];
        [cityButton setImage:[UIImage imageNamed:[cityButton imageName]]
                    forState:UIControlStateNormal];
        [cityButton sizeToFit];
        [cityButton setFrame:CGRectMake([city[@"x"] intValue],
                                        [city[@"y"] intValue],
                                        (int)(cityButton.frame.size.width/2),
                                        (int)(cityButton.frame.size.height/2))];
        
        if (self.mapType == Analysis_ModelMapType) {
            [cityButton setEnabled:YES];
            [cityButton setUserInteractionEnabled:YES];
            [cityButton addTarget:self
                           action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];

        }else
            [cityButton setUserInteractionEnabled:NO];
        
        //add by tikeyc
        [cityButton setEnabled:YES];
        [cityButton setUserInteractionEnabled:YES];
        [cityButton addTarget:self
                       action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [[self contentView] addSubview:cityButton];
    }
}

- (void)SGM_buildDistrictMap
{
    NSString *fileName = nil;
    switch ([[self areaInfo] areaType])
    {
        case Buick_SalesWholeMarket:
            fileName = [NSString stringWithFormat:@"buick-%@",
                        [[self areaInfo] areaID]];
            break;
        case Chevrolet_SalesWholeMarket:
            fileName = [NSString stringWithFormat:@"chervolet-%@",
                        [[self areaInfo] areaID]];
            break;
        case Cadillac_SalesWholeMarket:
            fileName = [NSString stringWithFormat:@"cadillac-%@",
                        [[self areaInfo] areaID]];
            break;
        default:
            break;
    }
    NSMutableArray *provinces =
    [[[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName
                                                                         ofType:@"json"]
                                encoding:NSUTF8StringEncoding
                                   error:nil] objectFromJSONString] mutableCopy];

    for (WSAreaInfo *province in [[self areaInfo] children])
    {
        NSDictionary *provinceDictionary = nil;
        for (NSDictionary *dictionary in provinces)
        {
            if ([dictionary[@"id"] isEqual:[province areaID]])
            {
                provinceDictionary = dictionary;
                break;
            }
        }
        [provinces removeObject:provinceDictionary];

        OBShapedButton *provinceButton = [[OBShapedButton alloc] init];
        [provinceButton setTag:[provinceDictionary[@"id"] intValue]];
        [provinceButton setImageName:provinceDictionary[@"imageName"]];

//        [provinceButton setImage:[UIImage imageNamed:
//                                  [[provinceButton imageName] stringByReplacingOccurrencesOfString:@".png"
//                                                                                        withString:@"_red.png"]]
//                        forState:UIControlStateHighlighted];
//        [provinceButton setImage:[UIImage imageNamed:
//                                  [[provinceButton imageName] stringByReplacingOccurrencesOfString:@".png"
//                                                                                        withString:@"_red.png"]]
//                        forState:UIControlStateDisabled];
        [provinceButton setImage:[UIImage imageNamed:[provinceButton imageName]]
                        forState:UIControlStateNormal];
        [provinceButton setFrame:CGRectMake([provinceDictionary[@"x"] intValue],
                                            [provinceDictionary[@"y"] intValue],
                                            [provinceDictionary[@"width"] intValue],
                                            [provinceDictionary[@"height"] intValue])];
        [provinceButton addTarget:self
                           action:@selector(clickButton:)
                 forControlEvents:UIControlEventTouchUpInside];
        [[self contentView] addSubview:provinceButton];
    }
}

- (void)SGM_buildChinaMap
{
    NSMutableArray *provinces =
    [[[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"china"
                                                                         ofType:@"json"]
                                encoding:NSUTF8StringEncoding
                                   error:nil] objectFromJSONString] mutableCopy];

    NSMutableArray *stack = [[NSMutableArray alloc] init];
    [stack addObject:[self areaInfo]];
    NSMutableSet *areas = [[NSMutableSet alloc] init];
    while ([stack count] > 0)
    {
        WSAreaInfo *top = [stack objectAtIndex:0];
        [stack removeObjectAtIndex:0];
        if ([top areaType]==Province_SalesWholeMarket && [top parent])
        {
            [areas addObject:top];
        }
        else
        {
            [stack addObjectsFromArray:[top children]];
        }
    }

    for (WSAreaInfo *province in areas)
    {
        NSDictionary *provinceDictionary = nil;
        for (NSDictionary *dictionary in provinces)
        {
            if ([dictionary[@"id"] isEqual:[province areaID]])
            {
                provinceDictionary = dictionary;
                break;
            }
        }
        [provinces removeObject:provinceDictionary];
        
        OBShapedButton *provinceButton = [[OBShapedButton alloc] init];
        [provinceButton setTag:[provinceDictionary[@"id"] intValue]];
        [provinceButton setImageName:provinceDictionary[@"imageName"]];
//        [provinceButton setImage:[UIImage imageNamed:
//                                  [[provinceButton imageName] stringByReplacingOccurrencesOfString:@".png"
//                                                                                        withString:@"_red.png"]]
//                        forState:UIControlStateHighlighted];
//        [provinceButton setImage:[UIImage imageNamed:
//                                  [[provinceButton imageName] stringByReplacingOccurrencesOfString:@".png"
//                                                                                        withString:@"_red.png"]]
//                        forState:UIControlStateDisabled];
        [provinceButton setImage:[UIImage imageNamed:[provinceButton imageName]]
                        forState:UIControlStateNormal];
        [provinceButton sizeToFit];
        [provinceButton setFrame:CGRectMake([provinceDictionary[@"x"] intValue],
                                            [provinceDictionary[@"y"] intValue],
                                            (int)(provinceButton.frame.size.width/2),
                                            (int)(provinceButton.frame.size.height/2))];
        [provinceButton addTarget:self
                           action:@selector(clickButton:)
                 forControlEvents:UIControlEventTouchUpInside];
        [[self contentView] addSubview:provinceButton];
    }
}

- (void)SGM_buildWholeDistrictMap
{
    NSMutableArray *areas =
    [[[NSString stringWithContentsOfFile:
       [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"area-%@",
                                               [[self areaInfo] areaID]]
                                       ofType:@"json"]
                                encoding:NSUTF8StringEncoding
                                   error:nil] objectFromJSONString] mutableCopy];

    for (WSAreaInfo *child in [[self areaInfo] children])
    {
        NSDictionary *areaDictionary = nil;
        for (NSDictionary *dictionary in areas)
        {
            if ([dictionary[@"id"] isEqual:[child areaID]])
            {
                areaDictionary = dictionary;
                break;
            }
        }

        if (!areaDictionary)
        {
            continue;
        }

        OBShapedButton *areaButton = [[OBShapedButton alloc] init];
        [areaButton setTag:[areaDictionary[@"id"] intValue]];
        [areaButton setImageName:areaDictionary[@"imageName"]];
//        [areaButton setImage:[UIImage imageNamed:
//                              [[areaButton imageName] stringByReplacingOccurrencesOfString:@".png"
//                                                                                withString:@"_red.png"]]
//                    forState:UIControlStateHighlighted];
//        [areaButton setImage:[UIImage imageNamed:
//                              [[areaButton imageName] stringByReplacingOccurrencesOfString:@".png"
//                                                                                withString:@"_red.png"]]
//                    forState:UIControlStateDisabled];
        [areaButton setImage:[UIImage imageNamed:[areaButton imageName]]
                    forState:UIControlStateNormal];
        [areaButton addTarget:self
                       action:@selector(clickButton:)
             forControlEvents:UIControlEventTouchUpInside];
        [areaButton setFrame:CGRectMake([areaDictionary[@"x"] intValue],
                                        [areaDictionary[@"y"] intValue],
                                        [areaDictionary[@"width"] intValue],
                                        [areaDictionary[@"height"] intValue])];

        [[self contentView] addSubview:areaButton];
    }
}


#pragma mark - SGM_buildNavigationButtons

- (void)SGM_buildNavigationButtons
{
    [[self navigationSegment] removeAllSegments];

    if (![[self selectedArea] parent])
    {
        for (int i = 0; i < [[self areaList] count]; i++)
        {
            WSAreaInfo *area = [self areaList][i];
            [[self navigationSegment] insertSegmentWithTitle:[area areaName]
                                                     atIndex:i
                                                    animated:NO];
        }

        for (int i = 0; i < [[self areaList] count]; i++)
        {
            WSAreaInfo *area = [self areaList][i];
            if (area == [self selectedArea])
            {
                [[self navigationSegment] setSelectedSegmentIndex:i];
                break;
            }
        }
    }
    else
    {
        WSAreaInfo *area = [[self selectedArea] parent];
        NSMutableArray *temp = [[NSMutableArray alloc] init];
        while (area)
        {
            switch ([area areaType])
            {
                case Buick_SalesWholeMarket:
                case Chevrolet_SalesWholeMarket:
                case Cadillac_SalesWholeMarket:
                {
                    // 当前是在某个大区的某个分区中
                    if (![area parent])
                    {
                        [temp addObject:@"全国"];
                    }
                    else
                    {
                        // 当前是在省份地图中
                        [temp addObject:@"大区"];
                    }
                    break;
                }
                case Province_SalesWholeMarket:
                {
                    if (![area parent])
                    {
                        [temp addObject:@"全国"];
                    }
                    else
                    {
                        [temp addObject:@"省份"];
                    }
                    break;
                }
                default:
                    assert(false);
            }

            area = [area parent];
        }
        
        for (long i = [temp count]-1; i >= 0; i--)
        {
            [[self navigationSegment] insertSegmentWithTitle:temp[i]
                                                     atIndex:[[self navigationSegment] numberOfSegments]
                                                    animated:NO];
        }
    }
    
    CGRect frame = [[self navigationSegment] frame];
    frame.size.width = 65*[[self navigationSegment] numberOfSegments];
    [[self navigationSegment] setFrame:frame];
}

#pragma mark - UI Event Handler
- (void)navigationSegmentChanged:(UISegmentedControl *)segment
{
    NSInteger tag = [segment selectedSegmentIndex];

    if ([segment numberOfSegments]==4)
    {
        [self setSelectedArea:[self areaList][tag]];
        [self setAreaInfo:[self areaList][tag]];
/* 创建大区图片
        for (int i = 0; i < [[[self selectedArea] children] count]; i++)
        {
            WSAreaInfo *area = [[self selectedArea] children][i];
            CGRect frame = [[[self contentView] viewWithTag:[[[[area children] lastObject] areaID] intValue]] frame];
            for (int j = 0; j < [[area children] count]; j++)
            {
                WSAreaInfo *province = [area children][j];
                OBShapedButton *button = (OBShapedButton *)[[self contentView] viewWithTag:[[province areaID] intValue]];
                frame = CGRectUnion(frame, [button frame]);
            }

            if (!CGRectEqualToRect(frame, CGRectZero))
            {
                UIGraphicsBeginImageContext(CGSizeMake(2*frame.size.width,
                                                       2*frame.size.height));
                CGContextRef contextRef = UIGraphicsGetCurrentContext();
                CGContextScaleCTM(contextRef, 2, 2);
                CGContextTranslateCTM(contextRef, -frame.origin.x, -frame.origin.y);

                for (int j = 0; j < [[area children] count]; j++)
                {
                    WSAreaInfo *province = [area children][j];
                    OBShapedButton *button = (OBShapedButton *)[[self contentView] viewWithTag:[[province areaID] intValue]];
                    [[button imageForState:UIControlStateNormal] drawInRect:[button frame]];
                }
                
                UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
                [UIImagePNGRepresentation(image) writeToFile:[NSString stringWithFormat:@"/Users/ansonyc/Desktop/tmp/%d-%@.png",
                                                              [area areaType],
                                                              [area areaID]]
                                                  atomically:YES];
                
                UIGraphicsBeginImageContext(CGSizeMake(2*frame.size.width,
                                                       2*frame.size.height));
                contextRef = UIGraphicsGetCurrentContext();
                CGContextScaleCTM(contextRef, 2, 2);
                CGContextTranslateCTM(contextRef, -frame.origin.x, -frame.origin.y);

                for (int j = 0; j < [[area children] count]; j++)
                {
                    WSAreaInfo *province = [area children][j];
                    OBShapedButton *button = (OBShapedButton *)[[self contentView] viewWithTag:[[province areaID] intValue]];
                    [[button imageForState:UIControlStateDisabled] drawInRect:[button frame]];
                }
                
                image = UIGraphicsGetImageFromCurrentImageContext();
                [UIImagePNGRepresentation(image) writeToFile:[NSString stringWithFormat:@"/Users/ansonyc/Desktop/tmp/%d-%@_red.png",
                                                              [area areaType],
                                                              [area areaID]]
                                                  atomically:YES];
            }
        }
 */
    }
    else
    {
        tag = [segment numberOfSegments]-tag;
        WSAreaInfo *area = [self selectedArea];
        while (tag > 0)
        {
            tag--;
            area = [area parent];
        }
        if (area)
        {
            [self setSelectedArea:area];
            [self setAreaInfo:area];
        }
    }
}

- (void)clickButton:(UIButton *)button
{
    WSAreaInfo *selectedArea = nil;
//    NSMutableSet *areas = [[NSMutableSet alloc] init];
//    if (![[self areaInfo] parent])
//    {
////        NSMutableArray *stack = [[NSMutableArray alloc] init];
////        [stack addObject:[self areaInfo]];
////        while ([stack count] > 0)
////        {
////            WSAreaInfo *top = [stack objectAtIndex:0];
////            [stack removeObjectAtIndex:0];
////            if ([top areaType]==Province_SalesWholeMarket && [top parent])
////            {
////                [areas addObject:top];
////            }
////            else
////            {
////                [stack addObjectsFromArray:[top children]];
////            }
////        }
//        for (WSAreaInfo *area in [[self areaInfo] children])
//        {
//            if ([[area areaID] intValue]==[button tag])
//            {
//                selectedArea = area;
//                break;
//            }
//        }
//    }

    if (![[self areaInfo] parent])
    {
        // 全国地图
        for (WSAreaInfo *area in [[self areaInfo] children])
        {
            if ([[area areaID] intValue]==[button tag])
            {
                selectedArea = area;
                break;
            }
        }
    }
    else
    {
        // 省份地图||大区地图
        for (WSAreaInfo *area in [[self areaInfo] children])
        {
            if ([[area areaID] intValue]==[button tag])
            {
                selectedArea = area;
                break;
            }
        }
    }

    if ([[selectedArea children] count] > 0)
    {
        while ([selectedArea parent]!=[self areaInfo])
        {
            selectedArea = [selectedArea parent];
        }
        [self setAreaInfo:selectedArea];
    }else if(self.mapType == Predict_SalesWholeMarket)
        [self setAreaInfo:selectedArea];
    
    [self setSelectedArea:selectedArea];
}



#pragma mark - properties
- (void)setAreaList:(NSArray *)areaList
{
    if (_areaList != areaList)
    {
        _areaList = areaList;
        [self setAreaInfo:[self areaList][0]];
        [self setSelectedArea:[self areaList][0]];
        [self SGM_buildNavigationButtons];
//        [[self view] setBackgroundColor:[UIColor lightGrayColor]];
    }
}

- (void)setAreaInfo:(WSAreaInfo *)areaInfo
{
    if (_areaInfo != areaInfo)
    {
//        [UIView animateWithDuration:.3
//                         animations:^{
//                             for (UIView *subView in [[self contentView] subviews])
//                             {
//                                 [subView setTag:-1];
//                                 [subView setAlpha:0];
//                             }
//                         } completion:^(BOOL finished) {
//                             for (int i = [[[self contentView] subviews] count]-1;
//                                  i >= 0;
//                                  i--)
//                             {
//                                 UIView *subView = [[self contentView] subviews][i];
//                                 if ([subView tag]==-1)
//                                 {
//                                     [subView removeFromSuperview];
//                                 }
//                             }
//                         }];
        while ([[[self contentView] subviews] count] > 0)
        {
            [[[[self contentView] subviews] lastObject] removeFromSuperview];
        }

        _areaInfo = areaInfo;
        // 全国地图
        if (![areaInfo parent])
        {
            switch ([areaInfo areaType])
            {
                case Buick_SalesWholeMarket:
                case Chevrolet_SalesWholeMarket:
                case Cadillac_SalesWholeMarket:
                    [self SGM_buildWholeDistrictMap];  
                    break;
                case Province_SalesWholeMarket:
                    [self SGM_buildChinaMap];
                    break;
                default:
                    assert(false);
            }
        }
        else
        {
            switch ([areaInfo areaType])
            {
                case Buick_SalesWholeMarket:
                case Chevrolet_SalesWholeMarket:
                case Cadillac_SalesWholeMarket:
                    [self SGM_buildDistrictMap];
                    break;
                case Province_SalesWholeMarket:
                    [self SGM_buildProvinceMap];
                    break;
                default:
                    assert(false);
            }
        }

        if ([[[self contentView] subviews] count] > 0)
        {
            UIView *view = [[[self contentView] subviews] lastObject];
            CGRect bounds = [view frame];
            for (UIButton *button in [[self contentView] subviews])
            {
                bounds = CGRectUnion(bounds, [button frame]);
            }
            [[self contentView] setFrame:CGRectMake(0,
                                                    0,
                                                    bounds.size.width+bounds.origin.x,
                                                    bounds.size.height+bounds.origin.y)];
            CGPoint center = [[self view] center];
            center.x-=bounds.origin.x/2;
            center.y-=bounds.origin.y/2;
            [[self contentView] setCenter:center];
        }
    }
}

- (void)setSelectedArea:(WSAreaInfo *)selectedArea
{
    if (_selectedArea != selectedArea)
    {
        _selectedArea = selectedArea;
        [self SGM_buildNavigationButtons];

        for (UIButton *btn in [[self contentView] subviews])
        {
            [btn setEnabled:YES];
        }
        
        if ([[self selectedArea] areaType]==City_SalesWholeMarket)
        {
            UIButton *button = (UIButton *)[[self contentView] viewWithTag:[[[self selectedArea] areaID] intValue]];
            [button setEnabled:NO];
        }

        if (selectedArea &&
            [[self delegate] respondsToSelector:@selector(chinaMapView:didSelectArea:)])
        {
            [[self delegate] chinaMapView:self didSelectArea:selectedArea];
        }
    }
}

- (UIView *)contentView
{
    if (!_contentView)
    {
        _contentView = [[UIView alloc] initWithFrame:CGRectInset(CGRectMake(0, 0, 724, 560),20,40)];
        [[self view] addSubview:_contentView];
        [_contentView setAutoresizingMask:UIViewAutoresizingNone];
        [_contentView setBackgroundColor:[UIColor whiteColor]];
    }
    
    return _contentView;
}

- (UISegmentedControl *)navigationSegment
{
    if (!_navigationSegment)
    {
        _navigationSegment = [[UISegmentedControl alloc] init];
        _navigationSegment.segmentedControlStyle =  UISegmentedControlStyleBar;
        [_navigationSegment setFrame:CGRectMake(10, 100, 400, 29)];
        [[self view] addSubview:_navigationSegment];
        [_navigationSegment addTarget:self
                               action:@selector(navigationSegmentChanged:)
                     forControlEvents:UIControlEventValueChanged];
        [_navigationSegment setTintColor:[UIColor colorWithRed:60./255.
                                                         green:99./255.
                                                          blue:145./255.
                                                         alpha:1]];
    }
    
    return _navigationSegment;
}

@end
