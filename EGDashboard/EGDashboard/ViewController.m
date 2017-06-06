//
//  ViewController.m
//  DashboardDemo
//
//  Created by WXQ on 2017/5/22.
//  Copyright © 2017年 WXQ. All rights reserved.
//

#import "ViewController.h"
#import "DialView.h"

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

#define GAWIDTH (self.view.frame.size.width-30)/2

@interface ViewController ()

@property (nonatomic, strong)  DialView *gaugeView;

@property (nonatomic, strong)  DialView *gaugeView1;

@property (nonatomic, strong)  DialView *gaugeView2;

@property (nonatomic, strong)  DialView *gaugeView3;

@property (nonatomic, strong) UISlider *slider;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.slider];
    
    [self.view addSubview:self.gaugeView];
    
    [self.view addSubview:self.gaugeView1];
    
    [self.view addSubview:self.gaugeView2];
    
    [self.view addSubview:self.gaugeView3];
}

-(DialView *)gaugeView3
{
    if (!_gaugeView3) {
        _gaugeView3 = [[DialView alloc] initWithFrame:CGRectMake(10 + CGRectGetMaxX(_gaugeView2.frame) , 70 + CGRectGetMaxY(_gaugeView.frame), GAWIDTH, GAWIDTH)];
        _gaugeView3.backgroundColor = [UIColor clearColor];
        _gaugeView3.style = [DialViewStyleFlatThin new];
        
        _gaugeView3.maxValue = 240;
        
        _gaugeView3.unitOfMeasurement = @"公里／小时";
        
        _gaugeView3.themeOfMeasurement = @"公里";
        
        _gaugeView3.currentValue = _gaugeView1.value;
        _gaugeView3.currentColor = RGB(128, 128, 128);
        _gaugeView3.scaleDivisions = 6;
        _gaugeView3.scaleMiddivisions = 1;
        _gaugeView3.scaleSubdivisions = 5;
        
        _gaugeView3.scalePosition = 0.025;
        
        _gaugeView3.showScaleShadow = NO;
        _gaugeView3.scaleFont = [UIFont fontWithName:@"AvenirNext-UltraLight" size:0.065];
        _gaugeView3.scalesubdivisionsAligment = WMGaugeViewSubdivisionsAlignmentCenter;
        _gaugeView3.scaleSubdivisionsWidth = 0.002;
        _gaugeView3.scaleSubdivisionsLength = 0.04;
        _gaugeView3.scaleDivisionsWidth = 0.007;
        _gaugeView3.scaleDivisionsLength = 0.07;
        
    }
    return _gaugeView3;
}

-(DialView *)gaugeView2
{
    if (!_gaugeView2) {
        _gaugeView2 = [[DialView alloc] initWithFrame:CGRectMake(10 , 70 + CGRectGetMaxY(_gaugeView.frame), GAWIDTH, GAWIDTH)];
        _gaugeView2.backgroundColor = RGB(32, 32, 32);
        //圆外部控件颜色属性
        DialViewStyle3D *style3D = [[DialViewStyle3D alloc] init];
        _gaugeView2.style = style3D;
        style3D.hiddenBlackInner = YES;
        
        _gaugeView2.maxValue = 240;
        _gaugeView2.scaleStartAngle = 90;
        _gaugeView2.scaleEndAngle = 270;
        
        _gaugeView2.unitOfMeasurement = @"公里／小时";
        
        _gaugeView2.themeOfMeasurement = @"公里";
        
        _gaugeView2.pointImage = [UIImage imageNamed:@"pointerV2"];
        
        _gaugeView2.currentValue = _gaugeView1.value;
        _gaugeView2.currentFont = [UIFont fontWithName:@"Helvetica-Bold" size:0.10];
        _gaugeView2.scaleDivisions = 6;
        _gaugeView2.scaleMiddivisions = 1;
        _gaugeView2.scaleSubdivisions = 2;
        _gaugeView2.scaleFont = [UIFont fontWithName:@"Helvetica-Bold" size:0.08];
    }
    return _gaugeView2;
}

-(DialView *)gaugeView1
{
    if (!_gaugeView1) {
        _gaugeView1 = [[DialView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_gaugeView.frame) + 10 , 50, GAWIDTH, GAWIDTH)];
        _gaugeView1.backgroundColor = [UIColor clearColor];
        //圆外部控件颜色属性
        DialViewStyle3D *style3D = [[DialViewStyle3D alloc] init];
        _gaugeView1.style = style3D;
        style3D.needleLayerFillColor = RGB(199, 21, 133);
        style3D.screwLayerFillColor = RGB(100, 20, 60);
        style3D.innerCircleColor = RGB(200, 80, 80);
        
        _gaugeView1.maxValue = 240;
        _gaugeView1.unitOfMeasurement = @"公里／小时";
        
        _gaugeView1.themeOfMeasurement = @"公里";
        
        _gaugeView1.currentValue = _gaugeView1.value;
        _gaugeView1.currentColor = RGB(231, 50, 60);
        _gaugeView1.scaleDivisions = 4;
        _gaugeView1.scaleMiddivisions = 0;
        _gaugeView1.scaleSubdivisions = 5;
        
        _gaugeView1.showRangeLabels = YES;
        _gaugeView1.rangeValues = @[@60, @120, @180, @240.0];
        _gaugeView1.rangeColors = @[RGB(232, 111, 33), RGB(232, 231, 33), RGB(27, 202, 33), RGB(231, 32, 43)    ];
        _gaugeView1.rangeLabels = @[ @"VERY LOW", @"LOW", @"OK", @"OVER FILL"];
        
        _gaugeView1.rangeLabelsFontColor = [UIColor blackColor];
        _gaugeView1.rangeLabelsWidth = 0.05;
        _gaugeView1.rangeLabelsFont = [UIFont fontWithName:@"Helvetica" size:0.04];
    }
    return _gaugeView1;
}

-(DialView *)gaugeView
{
    if (!_gaugeView) {
        _gaugeView = [[DialView alloc] initWithFrame:CGRectMake(10, 50, GAWIDTH, GAWIDTH)];
        _gaugeView.backgroundColor = [UIColor clearColor];
        //圆外部控件颜色属性
        _gaugeView.style = [DialViewStyle3D new];
        _gaugeView.maxValue = 600;
        //        _gaugeView.showInnerBackground = YES;
        //        _gaugeView.showScaleShadow = NO;
        //        _gaugeView.scaleDivisionsWidth = 0.008;
        //        _gaugeView.scaleSubdivisionsWidth = 0.006;
        _gaugeView.unitOfMeasurement = @"转／分钟";
        _gaugeView.themeOfMeasurement = @"转速";
        _gaugeView.currentValue = _gaugeView.value;
        _gaugeView.scaleDivisions = 4;
        _gaugeView.scaleMiddivisions = 2;
        _gaugeView.scaleSubdivisions = 5;
        _gaugeView.scaleStartDense = 1;
        _gaugeView.scaleEndDense = 2;
        _gaugeView.scaleSubdivisionColor = RGB(220, 20, 60);
        //_gaugeView.scaleAllSubDivisionColor = [UIColor redColor];
    }
    return _gaugeView;
}

- (UISlider *)slider
{
    if (!_slider) {
        _slider = [[UISlider alloc] initWithFrame:CGRectMake(20, self.view.bounds.size.height - 100, self.view.bounds.size.width - 40, 20)];
        _slider.minimumTrackTintColor = [UIColor greenColor];
        _slider.maximumTrackTintColor = [UIColor redColor];
        _slider.value = 0;
        [_slider addTarget:self action:@selector(sliderChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _slider;
}

- (void)animateWithProgress:(CGFloat)progress {
    _gaugeView.value = _gaugeView.maxValue*progress;
    _gaugeView.currentValue = self.gaugeView.value;
    //__weak typeof(self) weakSelf = self;
    [_gaugeView setValue:_gaugeView.value animated:YES duration:1.6 completion:^(BOOL finished) {
        NSLog(@"gaugeView animation complete");
    }];
    
    _gaugeView1.value = _gaugeView1.maxValue*progress;
    _gaugeView1.currentValue = self.gaugeView1.value;
    
    _gaugeView2.value = _gaugeView2.maxValue*progress;
    _gaugeView2.currentValue = self.gaugeView2.value;
    
    _gaugeView3.value = _gaugeView3.maxValue*progress;
    _gaugeView3.currentValue = self.gaugeView3.value;
}

- (void)sliderChange:(UISlider *)slider {
    [self animateWithProgress:slider.value];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
