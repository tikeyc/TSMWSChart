//
//  WSBaseGraphView.m
//  AnalysisGraph
//
//  Created by Ansonyc on 13-9-3.
//  Copyright (c) 2013年 Ways.cn. All rights reserved.
//

#import "TSMWSBaseGraphView.h"
#import <QuartzCore/QuartzCore.h>

@interface TSMWSBaseGraphView ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) NSMutableArray *elements;
@property (nonatomic, strong) CALayer *contentLayer;
@property (nonatomic, strong) CALayer *fullSizeAxisLayer;
@property (nonatomic, assign) CGFloat maxWidth;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, strong) CALayer *xLayer;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableSet *hiddenIndexs;
@property (nonatomic, strong) CALayer *backgroudLayer;
@end

@implementation TSMWSBaseGraphView
@synthesize backgroudLayer = _backgroudLayer;

- (void)setDefaultMargins
{
    [self setLeftMargin:75];
    [self setBottomMargin:50];
    [self setTopMargin:50];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setBackgroundColor:[UIColor clearColor]];
    [self setDefaultMargins];
}

- (id)init
{
    if (self = [super init])
    {
        [self setDefaultMargins];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setDefaultMargins];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self setDefaultMargins];
    }

    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [[UIColor colorWithWhite:144.0/255.0 alpha:1] setStroke];
    [[UIColor colorWithWhite:144.0/255.0 alpha:1] setFill];

    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(contextRef, [self leftMargin], rect.size.height-[self bottomMargin]+2);
    CGContextAddLineToPoint(contextRef,
                            rect.size.width,
                            rect.size.height-[self bottomMargin]+2);
    CGContextStrokePath(contextRef);
    
    CGContextMoveToPoint(contextRef, rect.size.width, rect.size.height-[self bottomMargin]+2);
    CGContextAddLineToPoint(contextRef, rect.size.width-5, rect.size.height-[self bottomMargin]+2-5);
    CGContextAddLineToPoint(contextRef, rect.size.width-5, rect.size.height-[self bottomMargin]+2+5);
    CGContextClosePath(contextRef);
    CGContextFillPath(contextRef);
    
}

- (void)SGM_rebuildAxisAndHeaderElements
{
    [[self backgroudLayer] setContents:nil];
    for (int i = 0; i < [[self axisRenderers] count]; i++)
    {
        TSMWSBaseAxisRenderer *axisRenderer = [self axisRenderers][i];
        [axisRenderer setGapBetweenXGroups:[self WS_gapBetweenXGroups]];
        [axisRenderer setGroupWidth:[self WS_widthForXGroupAtIndex:0]];
        [axisRenderer setLeftMargin:[self leftMargin]];
        [axisRenderer setTopMargin:[self topMargin]];
        [axisRenderer setBottomMargin:[self bottomMargin]];
        [axisRenderer renderBackgroundLayer:[self backgroudLayer] view:self];
        [axisRenderer renderAxisX:[self xLayer] size:[self bounds].size];
    }

    for (UIButton *button in [self subviews])
    {
        if ([button isKindOfClass:[UIButton class]])
        {
            [button addTarget:self
                       action:@selector(clickOnHeaderElement:)
             forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
}

- (void)SGM_reloadData
{
    [self SGM_reloadData:YES];
}

- (void)SGM_reloadData:(BOOL)animated
{
    CAShapeLayer *reuseLayer = nil;
    for (CAShapeLayer *shapeLayer in [self elements])
    {
        if ([shapeLayer isKindOfClass:[CAShapeLayer class]])
        {
            reuseLayer = shapeLayer;
        }
    }
 
    id<TSMWSDrawingStrategy> drawing = [[self drawingStrategys] lastObject];
    
    if ([self groupWidth]==0)
    {
        if (drawing && [[drawing dataSource] numberOfXGroups:drawing] > 0)
        {
            NSInteger groups = [[drawing dataSource] numberOfXGroups:drawing];
            NSInteger items = [[drawing dataSource] drawingStrategy:drawing
                                               numberOfItemsInGroup:0];
            if (groups*40*items < self.frame.size.width * .8)
            {
                [self setGroupWidth:self.frame.size.width*.8/groups];
            }
            else
            {
                [self setGroupWidth:[[drawing dataSource] drawingStrategy:drawing
                                                     numberOfItemsInGroup:0]*40];
            }
        }
        else
        {
            [self setGroupWidth:0];
        }
    }

    [CATransaction setAnimationDuration:0];
    [[self backgroudLayer] setBounds:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];

    while ([[[self fullSizeAxisLayer] sublayers] count] > 0)
    {
        [[[[self fullSizeAxisLayer] sublayers] lastObject] removeFromSuperlayer];
    }
    [[self fullSizeAxisLayer] setContents:nil];
    
    while ([[[self xLayer] sublayers] count] > 0)
    {
        [[[[self xLayer] sublayers] lastObject] removeFromSuperlayer];
    }
    [[self xLayer] setContents:nil];
    
    for (int i = [[self subviews] count]-1; i >= 0; i--)
    {
        if ([[self subviews][i] isKindOfClass:[UIButton class]])
        {
            [[self subviews][i] removeFromSuperview];
        }
    }

    while ([[[self backgroudLayer] sublayers] count] > 0)
    {
        [[[[self backgroudLayer] sublayers] lastObject] removeFromSuperlayer];
    }
    [[self backgroudLayer] setContents:nil];

    [self SGM_rebuildAxisAndHeaderElements];

    // remove
    for (CALayer *layer in [self elements])
    {
        [layer removeFromSuperlayer];
    }
    [[self elements] removeAllObjects];

    CGSize contentSize = [self bounds].size;

    [self setMaxWidth:0];
    contentSize.width -= ([self leftMargin]+[self rightMargin]);
    contentSize.height -= [self topMargin]+[self bottomMargin];
    
    for (id<TSMWSDrawingStrategy> drawing in [self drawingStrategys])
    {
        [drawing setGapBetweenGroups:[self WS_gapBetweenXGroups]];
        [drawing setGroupWidth:[self WS_widthForXGroupAtIndex:0]];
        [drawing setHiddenIndexs:[self hiddenIndexs]];
        [drawing setAnimated:animated];

        CALayer *layer = nil;
        if ([drawing respondsToSelector:@selector(contentLayerForSize:
                                                  reuseLayer:)])
        {
            layer = [drawing contentLayerForSize:contentSize
                              reuseLayer:reuseLayer];
        }
        else
        {
            layer = [drawing contentLayerForSize:contentSize];
        }

        if (layer)
        {
            [[self contentLayer] addSublayer:layer];
            [[self elements] addObject:layer];
            [layer setAnchorPoint:CGPointMake(0, 1)];
            [layer setPosition:CGPointMake(0, [self topMargin]+contentSize.height)];
            self.maxWidth = MAX(self.maxWidth, layer.bounds.size.width);
        }
    }
    
    BOOL hasVersusRenderer = NO;
    for (TSMWSBaseAxisRenderer *renderer  in [self axisRenderers])
    {
        hasVersusRenderer = [renderer isKindOfClass:NSClassFromString(@"WSVersusAxisRenderer")];
        if (hasVersusRenderer)
        {
            break;
        }
    }

    CGFloat fullContentWidth = [self bounds].size.width-[self leftMargin]-[self rightMargin];
    if (hasVersusRenderer)
    {
        fullContentWidth *= .925;
    }

    [[self scrollView] setFrame:CGRectMake([self leftMargin],
                                           0,
                                           fullContentWidth,
                                           self.bounds.size.height)];
    [[self scrollView] setContentSize:CGSizeMake([self maxWidth],
                                                 [[self scrollView] bounds].size.height)];
    [[self contentLayer] setBounds:CGRectMake(0,
                                              0,
                                              [self maxWidth],
                                              [self bounds].size.height)];
    [[self xLayer] setPosition:CGPointMake(0, [self contentLayer].bounds.size.height)];
}

- (void)reloadData
{
    [[self hiddenIndexs] removeAllObjects];
    [self SGM_reloadData];
}

- (void)scrollToRight
{
    [[self scrollView] setContentOffset:CGPointMake(MAX(0,self.scrollView.contentSize.width-
                                                        self.scrollView.frame.size.width), 0)
                               animated:YES];
}

#pragma mark - Properties
- (void)setBackgroudLayer:(CALayer *)backgroudLayer
{
    if (_backgroudLayer != backgroudLayer)
    {
        _backgroudLayer = backgroudLayer;
    }
}

- (CALayer *)backgroudLayer
{
    if (!_backgroudLayer)
    {
        _backgroudLayer = [CALayer layer];
        [_backgroudLayer setPosition:CGPointMake(0, 0)];
        [_backgroudLayer setAnchorPoint:CGPointMake(0, 0)];
        [[self layer] insertSublayer:_backgroudLayer atIndex:0];
    }
    
    return _backgroudLayer;
}

- (NSMutableSet *)hiddenIndexs
{
    if (!_hiddenIndexs)
    {
        _hiddenIndexs = [[NSMutableSet alloc] init];
    }
    
    return _hiddenIndexs;
}

- (CALayer *)xLayer
{
    if (!_xLayer)
    {
        _xLayer = [CALayer layer];
        [_xLayer setAnchorPoint:CGPointMake(0, 1)];
        [[self contentLayer] addSublayer:_xLayer];
    }

    return _xLayer;
}

- (CALayer *)fullSizeAxisLayer
{
    if (!_fullSizeAxisLayer)
    {
        _fullSizeAxisLayer = [CALayer layer];
        [[self layer] insertSublayer:_fullSizeAxisLayer atIndex:0];
        [_fullSizeAxisLayer setAnchorPoint:CGPointMake(0, 1)];
        [_fullSizeAxisLayer setPosition:CGPointMake(0, self.frame.size.height)];
        [_fullSizeAxisLayer setBounds:CGRectMake(0,
                                                 0,
                                                 self.frame.size.width,
                                                 self.frame.size.height)];
    }

    return _fullSizeAxisLayer;
}

- (CALayer *)contentLayer
{
    if (!_contentLayer)
    {
        _contentLayer = [CALayer layer];
        [_contentLayer setAnchorPoint:CGPointMake(0, 0)];
        [[[self scrollView] layer] addSublayer:_contentLayer];
        [_contentLayer setPosition:CGPointMake(0, 0)];
    }

    return _contentLayer;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView)
    {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
//        [_scrollView setBounces:YES];
//        [_scrollView setAlwaysBounceHorizontal:YES];
//        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [_scrollView setScrollEnabled:NO];
        [self addSubview:_scrollView];
    }

    return _scrollView;
}

- (NSMutableArray *)elements
{
    if (!_elements)
    {
        _elements = [[NSMutableArray alloc] init];
    }

    return _elements;
}

- (CGFloat)WS_widthForXGroupAtIndex:(NSUInteger)groupIndex
{
    return [self groupWidth] > 0 ? [self groupWidth] : 120;
}

- (CGFloat)WS_gapBetweenXGroups
{
    return 5;
}

#pragma mark - Delegate Pin Gesture
- (void)clickOnHeaderElement:(UIButton *)button
{
    if ([[self hiddenIndexs] containsObject:@([button tag])])
    {
        [[self hiddenIndexs] removeObject:@([button tag])];
    }
    else
    {
        [[self hiddenIndexs] addObject:@([button tag])];
    }

    [self SGM_reloadData:NO];

    for (NSNumber *selectedTag in [self hiddenIndexs])
    {
        [(UIButton *)[self viewWithTag:[selectedTag integerValue]] setSelected:YES];
    }
}

@end
