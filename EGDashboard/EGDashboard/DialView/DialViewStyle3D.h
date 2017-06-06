//
//  DialViewStyle3D.h
//  DashboardDemo
//
//  Created by WXQ on 2017/5/22.
//  Copyright © 2017年 WXQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DialViewStyle.h"

@interface DialViewStyle3D : NSObject <DialViewStyle>

/**
 * 指针颜色
 **/
@property (nonatomic, strong) UIColor *needleLayerFillColor;
/**
 * 固点圆圈颜色
 **/
@property (nonatomic, strong) UIColor *screwLayerFillColor;
/**
 * 内圈颜色
 **/
@property (nonatomic, strong) UIColor *innerCircleColor;
/**
 * 默认主色渐变色数组
 **/
@property (nonatomic, strong) NSArray *defaultFaceArray;
/**
 * 阴影渐变色数组
 **/
@property (nonatomic, strong) NSArray *shadowArray;
/**
 * 隐藏内圈
 **/
@property (nonatomic, assign) BOOL hiddenBlackInner;



@end
