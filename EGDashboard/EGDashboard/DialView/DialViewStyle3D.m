//
//  DialViewStyle3D.m
//  DashboardDemo
//
//  Created by WXQ on 2017/5/22.
//  Copyright © 2017年 WXQ. All rights reserved.
//

#import "DialViewStyle3D.h"

//#define kNeedleWidth        0.035
//#define kNeedleHeight       0.34
//#define kNeedleScrewRadius  0.04

#define kNeedleWidth        0.012
#define kNeedleHeight       0.4
#define kNeedleScrewRadius  0.05
#define defaultNeedFillColor RGB(220, 20, 60)
#define defauleScrewFillColor RGB(171, 171, 171)
#define defauletInnerCircleColor RGB(32, 32, 32)
#define defaultFaceColorArray @[iCGRGB(169, 169, 169), iCGRGB(92, 92, 92), iCGRGB(95, 158, 160)]
#define defaultShowColorArray @[iCGRGBA(15, 34, 98, 80), iCGRGBA(0, 0, 0, 120)]

#define INTERNAL_RING_RADIUS    0.30


@implementation DialViewStyle3D


#pragma mark --赋值
-(void)setNeedleLayerFillColor:(UIColor *)needleLayerFillColor
{
    _needleLayerFillColor = needleLayerFillColor;
}

-(void)setScrewLayerFillColor:(UIColor *)screwLayerFillColor
{
    _screwLayerFillColor = screwLayerFillColor;
}

-(void)setInnerCircleColor:(UIColor *)innerCircleColor
{
    _innerCircleColor = innerCircleColor;
}

-(void)setDefaultFaceArray:(NSArray *)defaultFaceArray
{
    _defaultFaceArray = defaultFaceArray;
}

-(void)setShadowArray:(NSArray *)shadowArray
{
    _shadowArray = shadowArray;
}

-(void)setHiddenBlackInner:(BOOL)hiddenBlackInner
{
    _hiddenBlackInner = hiddenBlackInner;
}

#pragma mark --绘制指针箭头
- (void)drawNeedleOnLayer:(CALayer*)layer inRect:(CGRect)rect
{
    //    // Left Needle
    //    CAShapeLayer *leftNeedleLayer = [CAShapeLayer layer];
    //    UIBezierPath *leftNeedlePath = [UIBezierPath bezierPath];
    //    [leftNeedlePath moveToPoint:CGPointMake(FULLSCALE(kCenterX, kCenterY))];
    //    [leftNeedlePath addLineToPoint:CGPointMake(FULLSCALE(kCenterX - kNeedleWidth, kCenterY))];
    //    [leftNeedlePath addLineToPoint:CGPointMake(FULLSCALE(kCenterX, kCenterY - kNeedleHeight))];
    //    [leftNeedlePath closePath];
    //
    //    leftNeedleLayer.path = leftNeedlePath.CGPath;
    //    leftNeedleLayer.backgroundColor = [[UIColor clearColor] CGColor];
    //    leftNeedleLayer.fillColor = CGRGB(176, 10, 19);
    //
    //    [layer addSublayer:leftNeedleLayer];
    //
    //    // Right Needle
    //    CAShapeLayer *rightNeedleLayer = [CAShapeLayer layer];
    //    UIBezierPath *rightNeedlePath = [UIBezierPath bezierPath];
    //    [rightNeedlePath moveToPoint:CGPointMake(FULLSCALE(kCenterX, kCenterY))];
    //    [rightNeedlePath addLineToPoint:CGPointMake(FULLSCALE(kCenterX + kNeedleWidth, kCenterY))];
    //    [rightNeedlePath addLineToPoint:CGPointMake(FULLSCALE(kCenterX, kCenterY - kNeedleHeight))];
    //    [rightNeedlePath closePath];
    //
    //    rightNeedleLayer.path = rightNeedlePath.CGPath;
    //    rightNeedleLayer.backgroundColor = [[UIColor clearColor] CGColor];
    //    rightNeedleLayer.fillColor = CGRGB(252, 18, 30);
    //
    //    [layer addSublayer:rightNeedleLayer];
    
    
    CAShapeLayer *needleLayer = [CAShapeLayer layer];
    UIBezierPath *needlePath = [UIBezierPath bezierPath];
    [needlePath moveToPoint:CGPointMake(FULLSCALE(kCenterX - kNeedleWidth, kCenterY))];
    [needlePath addLineToPoint:CGPointMake(FULLSCALE(kCenterX + kNeedleWidth, kCenterY))];
    [needlePath addLineToPoint:CGPointMake(FULLSCALE(kCenterX, kCenterY - kNeedleHeight))];
    [needlePath closePath];
    
    needleLayer.path = needlePath.CGPath;
    needleLayer.backgroundColor = [[UIColor clearColor] CGColor];
    UIColor *needColor = _needleLayerFillColor ? _needleLayerFillColor : defaultNeedFillColor;
    needleLayer.fillColor = needColor.CGColor;
    needleLayer.strokeColor = needColor.CGColor;
    needleLayer.lineWidth = 1.1;
    [layer addSublayer:needleLayer];
    
    // Needle shadow
    [layer setShadowColor:[[UIColor blackColor] CGColor]];
    [layer setShadowOffset:CGSizeMake(0, 0)];
    [layer setShadowOpacity:0.5];
    [layer setShadowRadius:2.0];
    
    // Screw drawing
    CAShapeLayer *screwLayer = [CAShapeLayer layer];
    //screwLayer.bounds = CGRectMake(FULLSCALE(kCenterX - kNeedleScrewRadius, kCenterY - kNeedleScrewRadius), FULLSCALE(kNeedleScrewRadius * 2.0, kNeedleScrewRadius * 2.0));
    screwLayer.bounds = CGRectMake(FULLSCALE(kCenterX - kNeedleScrewRadius, kCenterY - kNeedleScrewRadius), FULLSCALE(kNeedleScrewRadius * 1.0, kNeedleScrewRadius * 1.0));
    
    screwLayer.position = CGPointMake(FULLSCALE(kCenterX, kCenterY));
    screwLayer.path = [UIBezierPath bezierPathWithOvalInRect:screwLayer.bounds].CGPath;
    UIColor *screwColor = _screwLayerFillColor ? _screwLayerFillColor : defauleScrewFillColor;
    screwLayer.fillColor = screwColor.CGColor;
    screwLayer.strokeColor = CGRGBA(255, 20, 147, 90);
    screwLayer.lineWidth = 5;
    
    // Screw shadow
    screwLayer.shadowColor = [[UIColor blackColor] CGColor];
    screwLayer.shadowOffset = CGSizeMake(0.0, 0.0);
    screwLayer.shadowOpacity = 0.1;
    screwLayer.shadowRadius = 2.0;
    
    [layer addSublayer:screwLayer];
}
#pragma mark --绘制表盘背景色彩
- (void)drawFaceWithContext:(CGContextRef)context inRect:(CGRect)rect
{
    // Default Face
    CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
    NSArray *defaultFaceArray = _defaultFaceArray ? _defaultFaceArray : defaultFaceColorArray;
    CGGradientRef gradient = CGGradientCreateWithColors(baseSpace, (CFArrayRef)defaultFaceArray, (const CGFloat[]){0.2, 0.9, 1.0});
    CGColorSpaceRelease(baseSpace), baseSpace = NULL;
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    CGContextDrawRadialGradient(context, gradient, kCenterPoint, 0, kCenterPoint, rect.size.width / 2.0, kCGGradientDrawsAfterEndLocation);
    CGGradientRelease(gradient), gradient = NULL;
    
    // Shadow
    baseSpace = CGColorSpaceCreateDeviceRGB();
    NSArray *shadowArray = _shadowArray ? _shadowArray : defaultShowColorArray;
    gradient = CGGradientCreateWithColors(baseSpace, (CFArrayRef)shadowArray, (const CGFloat[]){0.0, 1.0});
    CGColorSpaceRelease(baseSpace), baseSpace = NULL;
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    CGContextDrawRadialGradient(context, gradient, kCenterPoint, 0, kCenterPoint, rect.size.width / 2.0, kCGGradientDrawsAfterEndLocation);
    CGGradientRelease(gradient), gradient = NULL;
    
    // Border
    CGContextSetLineWidth(context, 0.005);
    CGContextSetStrokeColorWithColor(context, CGRGBA(81, 84, 89, 80));
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    
    // Inner circle
    if (_hiddenBlackInner) {
        return;
    }else{
        CGContextAddEllipseInRect(context, CGRectMake(kCenterX - INTERNAL_RING_RADIUS, kCenterY - INTERNAL_RING_RADIUS, INTERNAL_RING_RADIUS * 2.0, INTERNAL_RING_RADIUS * 2.0));
        UIColor *innerColor = _innerCircleColor ? _innerCircleColor: defauletInnerCircleColor;
        CGContextSetFillColorWithColor(context, innerColor.CGColor);
        CGContextFillPath(context);
    }
}


- (BOOL)needleLayer:(CALayer*)layer willMoveAnimated:(BOOL)animated duration:(NSTimeInterval)duration animation:(CAKeyframeAnimation*)animation
{
    return NO;
}

@end
