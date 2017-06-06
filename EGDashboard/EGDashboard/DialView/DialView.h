//
//  DialView.h
//  DashboardDemo
//
//  Created by WXQ on 2017/5/22.
//  Copyright © 2017年 WXQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DialViewStyle.h"
#import "DialViewStyle3D.h"
#import "DialViewStyleFlatThin.h"

/**
 * Styling enumerations
 */
typedef enum
{
    WMGaugeViewSubdivisionsAlignmentTop,
    WMGaugeViewSubdivisionsAlignmentCenter,
    WMGaugeViewSubdivisionsAlignmentBottom
}
WMGaugeViewSubdivisionsAlignment;


@interface DialView : UIView

/**
 *   内圈属性
 */
@property (nonatomic, readwrite, assign) bool showInnerBackground;
@property (nonatomic, readwrite, assign) bool showInnerRim;
@property (nonatomic, readwrite, assign) CGFloat innerRimWidth;
@property (nonatomic, readwrite, assign) CGFloat innerRimBorderWidth;
/**
 *   表与表盘中心大距离
 */
@property (nonatomic, readwrite, assign) CGFloat scalePosition;
/**
 *   表盘起停位置
 */
@property (nonatomic, readwrite, assign) CGFloat scaleStartAngle;
@property (nonatomic, readwrite, assign) CGFloat scaleEndAngle;
/**
 *   表盘指针非密集分布起始位置(0~scaleDivisions);
 */
@property (nonatomic, readwrite, assign) CGFloat scaleStartDense;
@property (nonatomic, readwrite, assign) CGFloat scaleEndDense;
/**
 *  是否显示表盘阴影
 */
@property (nonatomic, readwrite, assign) bool showScaleShadow;
/**
 *  是否显示表盘
 */
@property (nonatomic, readwrite, assign) bool showScale;
@property (nonatomic, readwrite, assign) WMGaugeViewSubdivisionsAlignment scalesubdivisionsAligment;
/**
 *  仪表大刻度属性
 */
@property (nonatomic, readwrite, strong) UIFont *scaleFont;
@property (nonatomic, readwrite, strong) UIColor *scaleColor;//大刻度值颜色

@property (nonatomic, readwrite, assign) CGFloat scaleDivisions;
@property (nonatomic, readwrite, strong) UIColor *scaleDivisionColor;
@property (nonatomic, readwrite, assign) CGFloat scaleDivisionsLength;
@property (nonatomic, readwrite, assign) CGFloat scaleDivisionsWidth;
/**
 *  仪表中刻度属性
 */
@property (nonatomic, readwrite, assign) CGFloat scaleMiddivisions;
@property (nonatomic, readwrite, strong) UIColor *scaleMiddivisionColor;
@property (nonatomic, readwrite, assign) CGFloat scaleMiddivisionsLength;
@property (nonatomic, readwrite, assign) CGFloat scaleMiddivisionsWidth;
/**
 *  仪表最小刻度属性
 */
@property (nonatomic, readwrite, assign) CGFloat scaleSubdivisions;
@property (nonatomic, readwrite, strong) UIColor *scaleSubdivisionColor;
@property (nonatomic, readwrite, assign) CGFloat scaleSubdivisionsLength;
@property (nonatomic, readwrite, assign) CGFloat scaleSubdivisionsWidth;
/**
 *  仪表全部刻度颜色
 */
@property (nonatomic, readwrite, strong) UIColor *scaleAllSubDivisionColor;
/**
 *  仪表计算值
 */
@property (nonatomic, readwrite, assign) float value;
@property (nonatomic, readwrite, assign) float minValue;
@property (nonatomic, readwrite, assign) float maxValue;
/**
 *  仪表边距属性
 */
@property (nonatomic, readwrite, assign) bool showRangeLabels;
@property (nonatomic, readwrite, assign) CGFloat rangeLabelsWidth;
@property (nonatomic, readwrite, strong) UIFont *rangeLabelsFont;
@property (nonatomic, readwrite, strong) UIColor *rangeLabelsFontColor;
@property (nonatomic, readwrite, assign) CGFloat rangeLabelsFontKerning;
/**
 *  仪表边距范围分组
 */
@property (nonatomic, readwrite, strong) NSArray *rangeValues;
@property (nonatomic, readwrite, strong) NSArray *rangeColors;
@property (nonatomic, readwrite, strong) NSArray *rangeLabels;
/**
 *  仪表单位属性
 */
@property (nonatomic, readwrite, strong) UIColor *unitOfMeasurementColor;
@property (nonatomic, readwrite, assign) CGFloat unitOfMeasurementVerticalOffset;
@property (nonatomic, readwrite, strong) UIFont *unitOfMeasurementFont;
@property (nonatomic, readwrite, strong) NSString *unitOfMeasurement;
@property (nonatomic, readwrite, assign) bool unitShowUnitOfMeasurement;
/**
 *  仪表标题属性
 */
@property (nonatomic, readwrite, strong) UIColor *themeOfMeasurementColor;
@property (nonatomic, readwrite, assign) CGFloat themeOfMeasurementVerticalOffset;
@property (nonatomic, readwrite, strong) UIFont *themeOfMeasurementFont;
@property (nonatomic, readwrite, strong) NSString *themeOfMeasurement;
@property (nonatomic, readwrite, assign) bool themeShowUnitOfMeasurement;
/**
 *  仪表值属性
 */
@property (nonatomic, readwrite, strong) UIColor *currentColor;
@property (nonatomic, readwrite, assign) CGFloat currentVerticalOffset;
@property (nonatomic, readwrite, strong) UIFont *currentFont;
@property (nonatomic, readwrite, assign) float currentValue;
@property (nonatomic, readwrite, assign) bool currentValueShow;

@property (nonatomic, readwrite, strong) UIImageView *pointerView;
@property (nonatomic, readwrite, strong) UIImage *pointImage;


@property (nonatomic, readwrite, strong) id<DialViewStyle> style;

/**
 * WMGaugeView public functions
 */
- (void)setValue:(float)value animated:(BOOL)animated;
- (void)setValue:(float)value animated:(BOOL)animated completion:(void (^)(BOOL finished))completion;
- (void)setValue:(float)value animated:(BOOL)animated duration:(NSTimeInterval)duration;
- (void)setValue:(float)value animated:(BOOL)animated duration:(NSTimeInterval)duration completion:(void (^)(BOOL finished))completion;

@end
