//
//  DialView.m
//  DashboardDemo
//
//  Created by WXQ on 2017/5/22.
//  Copyright © 2017年 WXQ. All rights reserved.
//

#import "DialView.h"

#define FULL_SCALE(x,y)    (x)*self.bounds.size.width, (y)*self.bounds.size.height

@implementation DialView
{
    /* Drawing rects */
    CGRect fullRect;
    CGRect innerRimRect;
    CGRect innerRimBorderRect;
    CGRect faceRect;
    CGRect rangeLabelsRect;
    CGRect scaleRect;
    
    /* View center */
    CGPoint center;
    
    /* Scale variables */
    CGFloat scaleRotation;
    CGFloat divisionValue;
    CGFloat subdivisionValue;
    CGFloat subdivisionAngle;
    
    /* Background image */
    UIImage *background;
    
    /* Needle layer */
    CALayer *rootNeedleLayer;
    
    /* Annimation completion */
    void (^animationCompletion)(BOOL);
}

#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initialize];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initialize];
}

/**
 *  Set all properties to default values
 *  Set all private variables to default values
 */
- (void)initialize;
{
    _style = nil;
    _showInnerRim = NO;
    _showInnerBackground = YES;
    _innerRimWidth = 0.05;
    _innerRimBorderWidth = 0.005;
    
    _scalePosition = 0.045;
    
    _scaleStartAngle = 30.0;
    _scaleEndAngle = 330.0;
    
    _scaleStartDense = 0.0;
    _scaleEndDense = 0.0;
    
    _scaleDivisions = 4.0;
    _scaleMiddivisions = 1.0;
    _scaleSubdivisions = 2.0;
    _showScale = YES;
    _showScaleShadow = NO;
    
    
    _scalesubdivisionsAligment = WMGaugeViewSubdivisionsAlignmentTop;
    _scaleDivisionsLength = 0.055;
    _scaleDivisionsWidth = 0.01;
    _scaleMiddivisionsLength = 0.040;
    _scaleMiddivisionsWidth = 0.01;
    _scaleSubdivisionsLength = 0.025;
    _scaleSubdivisionsWidth = 0.01;
    
    
    _value = 0.0;
    _minValue = 0.0;
    _maxValue = 240.0;
    
    background = nil;
    
    _showRangeLabels = NO;
    _rangeLabelsWidth = 0.05;
    _rangeLabelsFont = [UIFont fontWithName:@"Helvetica" size:0.06];
    _rangeLabelsFontColor = [UIColor whiteColor];
    _rangeLabelsFontKerning = 1.0;
    _rangeValues = nil;
    _rangeColors = nil;
    _rangeLabels = nil;
    
    _scaleDivisionColor = RGB(245, 245, 245);
    _scaleMiddivisionColor = RGB(245, 245, 245);
    _scaleSubdivisionColor = RGB(245, 245, 245);
    _scaleColor = RGB(30, 144, 255);
    //_scaleAllSubDivisionColor = RGB(217, 217, 217);
    
    _scaleFont = nil;
    
    _unitOfMeasurementVerticalOffset = 0.65;
    _unitOfMeasurementColor = [UIColor whiteColor];
    _unitOfMeasurementFont = [UIFont fontWithName:@"Helvetica" size:0.06];
    _unitOfMeasurement = @"";
    _unitShowUnitOfMeasurement = YES;
    
    _themeOfMeasurementVerticalOffset = 0.3;
    _themeOfMeasurementColor = [UIColor whiteColor];
    _themeOfMeasurementFont = [UIFont fontWithName:@"Helvetica-Bold" size:0.07];
    _themeOfMeasurement = @"";
    _themeShowUnitOfMeasurement = YES;
    
    
    _currentVerticalOffset = 0.85;
    _currentColor = RGB(30, 144, 255);
    _currentFont = [UIFont fontWithName:@"Helvetica-Bold" size:0.07];
    _currentValue = _value;
    _currentValueShow = YES;
    
    animationCompletion = nil;
    
    [self initDrawingRects];
    [self initScale];
}

/**
 *  Initialize all drawing rects and center point
 */
- (void)initDrawingRects
{
    center = CGPointMake(0.5, 0.5);
    fullRect = CGRectMake(0.0, 0.0, 1.0, 1.0);
    
    _innerRimBorderWidth = _showInnerRim ? _innerRimBorderWidth : 0.0;
    _innerRimWidth = _showInnerRim ? _innerRimWidth : 0.0;
    
    innerRimRect = fullRect;
    innerRimBorderRect = CGRectMake(innerRimRect.origin.x + _innerRimBorderWidth,
                                    innerRimRect.origin.y + _innerRimBorderWidth,
                                    innerRimRect.size.width - 2 * _innerRimBorderWidth,
                                    innerRimRect.size.height - 2 * _innerRimBorderWidth);
    faceRect = CGRectMake(innerRimRect.origin.x + _innerRimWidth,
                          innerRimRect.origin.y + _innerRimWidth,
                          innerRimRect.size.width - 2 * _innerRimWidth,
                          innerRimRect.size.height - 2 * _innerRimWidth);
    rangeLabelsRect = CGRectMake(faceRect.origin.x + (_showRangeLabels ? _rangeLabelsWidth : 0.0),
                                 faceRect.origin.y + (_showRangeLabels ? _rangeLabelsWidth : 0.0),
                                 faceRect.size.width - 2 * (_showRangeLabels ? _rangeLabelsWidth : 0.0),
                                 faceRect.size.height - 2 * (_showRangeLabels ? _rangeLabelsWidth : 0.0));
    scaleRect = CGRectMake(rangeLabelsRect.origin.x + _scalePosition,
                           rangeLabelsRect.origin.y + _scalePosition,
                           rangeLabelsRect.size.width - 2 * _scalePosition,
                           rangeLabelsRect.size.height - 2 * _scalePosition);
}

#pragma mark - Drawing

/**
 * Main drawing entry point
 */
- (void)drawRect:(CGRect)rect
{
    if (background == nil)
    {
        // Create image context
        UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        // Scale context for [0-1] drawings
        CGContextScaleCTM(context, rect.size.width , rect.size.height);
        
        // Draw gauge background in image context
        [self drawGauge:context];
        
        // Save background
        background = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    // Drawing background in view
    [background drawInRect:rect];
    
    
    if (rootNeedleLayer == nil)
    {
        // Initialize needle layer
        rootNeedleLayer = [CALayer new];
        
        // For performance puporse, the needle layer is not scaled to [0-1] range
        rootNeedleLayer.frame = self.bounds;
        [self.layer addSublayer:rootNeedleLayer];
        
        // Draw needle
        [self drawNeedle];
        
        // Set needle current value
        [self setValue:_value animated:NO];
    }
}

/**
 *  Gauge background drawing
 */
- (void)drawGauge:(CGContextRef)context
{
    [self drawRim:context];
    
    if (_showInnerBackground)
        [self drawFace:context];
    
    if (_unitShowUnitOfMeasurement)
        [self drawUinitText:context];
    
    if (_themeShowUnitOfMeasurement)
        [self drawThemeText:context];
    
    if (_currentValueShow)
        [self drawCurrentValueText:context];
    
    
    if (_showScale)
        [self drawScale:context];
    
    if (_showRangeLabels)
        [self drawRangeLabels:context];
}

/**
 *  Gauge external rim drawing
 */
- (void)drawRim:(CGContextRef)context
{
    // TODO
    
}

/**
 *  Gauge inner background drawing
 */
- (void)drawFace:(CGContextRef)context
{
    if ([_style conformsToProtocol:@protocol(DialViewStyle)]) {
        [_style drawFaceWithContext:context inRect:faceRect];
    }
}

/**
 *  Unit of measurement drawing
 */
- (void)drawUinitText:(CGContextRef)context
{
    CGContextSetShadow(context, CGSizeMake(0.05, 0.05), 2.0);
    UIFont* font = _unitOfMeasurementFont ? _unitOfMeasurementFont : [UIFont fontWithName:@"Helvetica" size:0.04];
    UIColor* color = _unitOfMeasurementColor ? _unitOfMeasurementColor : [UIColor whiteColor];
    NSDictionary* stringAttrs = @{ NSFontAttributeName : font, NSForegroundColorAttributeName : color };
    NSAttributedString* attrStr = [[NSAttributedString alloc] initWithString:_unitOfMeasurement attributes:stringAttrs];
    CGSize fontWidth;
    fontWidth = [_unitOfMeasurement sizeWithAttributes:stringAttrs];
    
    [attrStr drawAtPoint:CGPointMake(0.5 - fontWidth.width / 2.0, _unitOfMeasurementVerticalOffset)];
}

/**
 *  theme of measurement drawing
 */
- (void)drawThemeText:(CGContextRef)context
{
    CGContextSetShadow(context, CGSizeMake(0.05, 0.05), 2.0);
    UIFont* font = _themeOfMeasurementFont ? _themeOfMeasurementFont : [UIFont fontWithName:@"Helvetica-Bold" size:0.06];
    UIColor* color = _themeOfMeasurementColor ? _themeOfMeasurementColor : [UIColor whiteColor];
    NSDictionary* stringAttrs = @{ NSFontAttributeName : font, NSForegroundColorAttributeName : color };
    NSAttributedString* attrStr = [[NSAttributedString alloc] initWithString:_themeOfMeasurement attributes:stringAttrs];
    CGSize fontWidth;
    fontWidth = [_themeOfMeasurement sizeWithAttributes:stringAttrs];
    
    [attrStr drawAtPoint:CGPointMake(0.5 - fontWidth.width / 2.0, _themeOfMeasurementVerticalOffset)];
}

/**
 *  currentValue of measurement drawing
 */
- (void)drawCurrentValueText:(CGContextRef)context
{
    CGContextSetShadow(context, CGSizeMake(0.05, 0.05), 2.0);
    UIFont* font = _currentFont ? _currentFont : [UIFont fontWithName:@"Helvetica" size:0.06];
    UIColor* color = _currentColor ? _currentColor : RGB(30, 144, 255);
    NSDictionary* stringAttrs = @{ NSFontAttributeName : font, NSForegroundColorAttributeName : color };
    NSString *current = [NSString stringWithFormat:@"%.2f",_currentValue];
    NSAttributedString* attrStr = [[NSAttributedString alloc] initWithString:current attributes:stringAttrs];
    CGSize fontWidth;
    fontWidth = [current sizeWithAttributes:stringAttrs];
    
    [attrStr drawAtPoint:CGPointMake(0.5 - fontWidth.width / 2.0, _currentVerticalOffset)];
}

/**
 * Scale drawing
 */
- (void)drawScale:(CGContextRef)context
{
    CGContextSaveGState(context);
    [self rotateContext:context fromCenter:center withAngle:DEGREES_TO_RADIANS(180 + _scaleStartAngle)];
    
    int totalTicks = _scaleDivisions * _scaleSubdivisions*(1 + _scaleMiddivisions) + 1;
    for (int i = 0; i < totalTicks; i++)
    {
        CGFloat offset = 0.0;
        if (_scalesubdivisionsAligment == WMGaugeViewSubdivisionsAlignmentCenter) offset = (_scaleDivisionsLength - _scaleSubdivisionsLength) / 2.0;
        if (_scalesubdivisionsAligment == WMGaugeViewSubdivisionsAlignmentBottom) offset = _scaleDivisionsLength - _scaleSubdivisionsLength;
        
        CGFloat y1 = scaleRect.origin.y;
        
        CGFloat y2 = y1 + _scaleSubdivisionsLength;
        
        CGFloat y32 = y1 + _scaleMiddivisionsLength;
        
        CGFloat y3 = y1 + _scaleDivisionsLength;
        
        float value = [self valueForTick:i];
        
        if (i%(int)(_scaleSubdivisions*(1 + _scaleMiddivisions)) == 0)
        {
            // Initialize Core Graphics settings
            UIColor *colorOne = (_rangeValues && _rangeColors) ? [self rangeColorForValue:value] : _scaleDivisionColor;
            UIColor *colorTwo = _scaleAllSubDivisionColor ? _scaleAllSubDivisionColor : colorOne;
            CGContextSetStrokeColorWithColor(context, colorTwo.CGColor);
            CGContextSetLineWidth(context, _scaleDivisionsWidth);
            CGContextSetShadow(context, CGSizeMake(0.05, 0.05), _showScaleShadow ? 2.0 : 0.0);
            
            // Draw tick
            CGContextMoveToPoint(context, 0.5, y1);
            CGContextAddLineToPoint(context, 0.5, y3);
            CGContextStrokePath(context);
            
            // Draw label
            NSString *valueString = [NSString stringWithFormat:@"%0.0f",value];
            UIFont* font = _scaleFont ? _scaleFont : [UIFont fontWithName:@"Helvetica-Bold" size:0.06];
            NSDictionary* stringAttrs = @{ NSFontAttributeName : font, NSForegroundColorAttributeName : _scaleColor};
            NSAttributedString* attrStr = [[NSAttributedString alloc] initWithString:valueString attributes:stringAttrs];
            CGSize fontWidth;
            fontWidth = [valueString sizeWithAttributes:stringAttrs];
            
            [attrStr drawAtPoint:CGPointMake(0.5 - fontWidth.width / 2.0, y3 + 0.005)];
        }
        // Division middle
        else if(i%(int)(_scaleSubdivisions) == 0 && i%(int)(_scaleSubdivisions*(1 + _scaleMiddivisions)) != 0){
            // Initialize Core Graphics settings
            UIColor *colorOne = (_rangeValues && _rangeColors) ? [self rangeColorForValue:value] : _scaleMiddivisionColor;
            UIColor *colorTwo = _scaleAllSubDivisionColor ? _scaleAllSubDivisionColor : colorOne;
            CGContextSetStrokeColorWithColor(context, colorTwo.CGColor);
            
            CGContextSetLineWidth(context, _scaleMiddivisionsWidth);
            CGContextMoveToPoint(context, 0.5, y1);
            if (_showScaleShadow) CGContextSetShadow(context, CGSizeMake(0.05, 0.05), 2.0);
            
            // Draw tick
            CGContextMoveToPoint(context, 0.5, y1 + offset);
            CGContextAddLineToPoint(context, 0.5, y32 + offset);
            CGContextStrokePath(context);
        }
        // Division small
        else{
            // Initialize Core Graphics settings
            if (i < _scaleStartDense * _scaleSubdivisions*(1 + _scaleMiddivisions) || i > _scaleEndDense * _scaleSubdivisions*(1 + _scaleMiddivisions)) {
                UIColor *colorOne = (_rangeValues && _rangeColors) ? [self rangeColorForValue:value] : _scaleSubdivisionColor;
                UIColor *colorTwo = _scaleAllSubDivisionColor ? _scaleAllSubDivisionColor : colorOne;
                CGContextSetStrokeColorWithColor(context, colorTwo.CGColor);
                CGContextSetLineWidth(context, _scaleSubdivisionsWidth);
                CGContextMoveToPoint(context, 0.5, y1);
                if (_showScaleShadow) CGContextSetShadow(context, CGSizeMake(0.05, 0.05), 2.0);
                // Draw tick
                CGContextMoveToPoint(context, 0.5, y1 + offset);
                CGContextAddLineToPoint(context, 0.5, y2 + offset);
                CGContextStrokePath(context);
            }
            
        }
        // Rotate to next tick
        [self rotateContext:context fromCenter:center withAngle:DEGREES_TO_RADIANS(subdivisionAngle)];
    }
    
    CGContextRestoreGState(context);
}

/**
 * scale range labels drawing
 */
- (void)drawRangeLabels:(CGContextRef)context
{
    CGContextSaveGState(context);
    [self rotateContext:context fromCenter:center withAngle:DEGREES_TO_RADIANS(90 + _scaleStartAngle)];
    CGContextSetShadow(context, CGSizeMake(0.0, 0.0), 0.0);
    
    CGFloat maxAngle = _scaleEndAngle - _scaleStartAngle;
    CGFloat lastStartAngle = 0.0f;
    
    for (int i = 0; i < _rangeValues.count; i ++)
    {
        // Range value
        float value = ((NSNumber*)[_rangeValues objectAtIndex:i]).floatValue;
        float valueAngle = (value - _minValue) / (_maxValue - _minValue) * maxAngle;
        
        // Range curved shape
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path addArcWithCenter:center radius:rangeLabelsRect.size.width / 2.0 startAngle:DEGREES_TO_RADIANS(lastStartAngle) endAngle:DEGREES_TO_RADIANS(valueAngle) - 0.01 clockwise:YES];
        
        UIColor *color = _rangeColors[i];
        [color setStroke];
        path.lineWidth = _rangeLabelsWidth;
        [path stroke];
        
        // Range curved label
        [self drawStringAtContext:context string:(NSString*)_rangeLabels[i] withCenter:center radius:rangeLabelsRect.size.width / 2.0 startAngle:DEGREES_TO_RADIANS(lastStartAngle) endAngle:DEGREES_TO_RADIANS(valueAngle)];
        
        lastStartAngle = valueAngle;
    }
    
    CGContextRestoreGState(context);
}

/**
 * Needle drawing
 */
- (void)drawNeedle
{
    if (_pointImage) {
        [self addSubview:self.pointerView];
    }else{
        if ([_style conformsToProtocol:@protocol(DialViewStyle)]) {
            
            [_style drawNeedleOnLayer:rootNeedleLayer inRect:self.bounds];
        }
        
    }
}

- (UIImageView *)pointerView {
    if (!_pointerView) {
        _pointerView = [[UIImageView alloc] initWithImage:_pointImage];
        center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
        _pointerView.frame =  CGRectMake(center.x - 7, center.y - self.bounds.size.width/4, 14, self.bounds.size.width/2);
        _pointerView.contentMode = UIViewContentModeScaleAspectFit;
        _pointerView.layer.anchorPoint = CGPointMake(0.5f, 0.9f);
        _pointerView.transform = CGAffineTransformMakeRotation(-(M_PI-DEGREES_TO_RADIANS(_scaleStartAngle)));
    }
    return _pointerView;
}

#pragma mark - Tools

/**
 * Core Graphics rotation in context
 */
- (void)rotateContext:(CGContextRef)context fromCenter:(CGPoint)center_ withAngle:(CGFloat)angle
{
    CGContextTranslateCTM(context, center_.x, center_.y);
    CGContextRotateCTM(context, angle);
    CGContextTranslateCTM(context, -center_.x, -center_.y);
}

/**
 * Needle angle computation
 */
- (CGFloat)needleAngleForValue:(double)value
{
    return DEGREES_TO_RADIANS(_scaleStartAngle + (value - _minValue) / (_maxValue - _minValue) * (_scaleEndAngle - _scaleStartAngle)) + M_PI;
}

/**
 * Initialize scale helper values
 */
- (void)initScale
{
    scaleRotation = (int)(_scaleStartAngle + 180) % 360;
    divisionValue = (_maxValue - _minValue) / _scaleDivisions;
    subdivisionValue = divisionValue / (_scaleSubdivisions*(1 + _scaleMiddivisions));
    subdivisionAngle = (_scaleEndAngle - _scaleStartAngle) / (_scaleDivisions * _scaleSubdivisions*(1 + _scaleMiddivisions));
}

/**
 * Scale tick value computation
 */
- (float)valueForTick:(int)tick
{
    return tick * (divisionValue / (_scaleSubdivisions*(1 + _scaleMiddivisions))) + _minValue;
}

/**
 * Scale range label color for value
 */
- (UIColor*)rangeColorForValue:(float)value
{
    NSInteger length = _rangeValues.count;
    for (int i = 0; i < length - 1; i++)
    {
        if (value < [_rangeValues[i] floatValue])
            return _rangeColors[i];
    }
    if (value <= [_rangeValues[length - 1] floatValue])
        return _rangeColors[length - 1];
    return nil;
}

/**
 * Draw curved NSSring in context
 */
- (void)drawStringAtContext:(CGContextRef) context string:(NSString*)text withCenter:(CGPoint)center_ radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle
{
    CGContextSaveGState(context);
    
    UIFont* font = _rangeLabelsFont ? _rangeLabelsFont : [UIFont fontWithName:@"Helvetica" size:0.05];
    UIColor* color = _rangeLabelsFontColor ? _rangeLabelsFontColor : [UIColor whiteColor];
    NSDictionary* stringAttrs = @{ NSFontAttributeName : font, NSForegroundColorAttributeName : color };
    CGSize textSize;
    textSize = [text sizeWithAttributes:stringAttrs];
    
    float perimeter = 2 * M_PI * radius;
    float textAngle = textSize.width / perimeter * 2 * M_PI * _rangeLabelsFontKerning;
    float offset = ((endAngle - startAngle) - textAngle) / 2.0;
    
    float letterPosition = 0;
    NSString *lastLetter = @"";
    
    [self rotateContext:context fromCenter:center withAngle:startAngle + offset];
    for (int index = 0; index < [text length]; index++)
    {
        NSRange range = {index, 1};
        NSString* letter = [text substringWithRange:range];
        NSAttributedString* attrStr = [[NSAttributedString alloc] initWithString:letter attributes:stringAttrs];
        CGSize charSize = [letter sizeWithAttributes:stringAttrs];
        float totalWidth = [[NSString stringWithFormat:@"%@%@",lastLetter, letter] sizeWithAttributes:stringAttrs].width;
        float currentLetterWidth = [letter sizeWithAttributes:stringAttrs].width;
        float lastLetterWidth = [lastLetter sizeWithAttributes:stringAttrs].width;
        float kerning = (lastLetterWidth) ? 0.0 : ((currentLetterWidth + lastLetterWidth) - totalWidth);
        
        letterPosition += (charSize.width / 2) - kerning;
        float angle = (letterPosition / perimeter * 2 * M_PI) * _rangeLabelsFontKerning;
        CGPoint letterPoint = CGPointMake((radius - charSize.height / 2.0) * cos(angle) + center_.x, (radius - charSize.height / 2.0) * sin(angle) + center_.y);
        
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, letterPoint.x, letterPoint.y);
        CGAffineTransform rotationTransform = CGAffineTransformMakeRotation(angle + M_PI_2);
        CGContextConcatCTM(context, rotationTransform);
        CGContextTranslateCTM(context, -letterPoint.x, -letterPoint.y);
        
        [attrStr drawAtPoint:CGPointMake(letterPoint.x - charSize.width/2 , letterPoint.y - charSize.height)];
        
        CGContextRestoreGState(context);
        
        letterPosition += charSize.width / 2;
        lastLetter = letter;
    }
    CGContextRestoreGState(context);
}

/**
 * Invalidate background
 * Background will be regenerated during next draw rect
 */
- (void)invalidateBackground
{
    background = nil;
    [self initDrawingRects];
    [self initScale];
    [self setNeedsDisplay];
}


/**
 * Invalidate Needle
 * Needle will be regenerated during next draw rect
 */
- (void)invalidateNeedle
{
    [rootNeedleLayer removeAllAnimations];
    rootNeedleLayer.sublayers = nil;
    rootNeedleLayer = nil;
    
    [self setNeedsDisplay];
}

#pragma mark - Value update

/**
 * Update gauge value
 */
- (void)updateValue:(float)value
{
    // Clamp value if out of range
    if (value > _maxValue)
        value = _maxValue;
    else if (value < _minValue)
        value = _minValue;
    else
        value = value;
    
    // Set value
    _value = value;
}

/**
 * Update gauge value with animation
 */
- (void)setValue:(float)value animated:(BOOL)animated
{
    [self setValue:value animated:animated duration:0.8];
}

/**
 * Update gauge value with animation and fire a completion block
 */
- (void)setValue:(float)value animated:(BOOL)animated completion:(void (^)(BOOL finished))completion
{
    [self setValue:value animated:animated duration:0.8 completion:completion];
}

/**
 * Update gauge value with animation and duration
 */
- (void)setValue:(float)value animated:(BOOL)animated duration:(NSTimeInterval)duration
{
    [self setValue:value animated:animated duration:duration completion:nil];
}

/**
 * Update gauge value with animation, duration and fire a completion block
 */
- (void)setValue:(float)value animated:(BOOL)animated duration:(NSTimeInterval)duration completion:(void (^)(BOOL finished))completion
{
    animationCompletion = completion;
    
    double lastValue = _value;
    
    [self updateValue:value];
    
    double middleValue = lastValue + (((lastValue + (_value - lastValue) / 2.0) >= 0) ? (_value - lastValue) / 2.0 : (lastValue - _value) / 2.0);
    if (_pointImage) {
        _pointerView.transform = CGAffineTransformMakeRotation([self needleAngleForValue:lastValue]);
    }else{
        // Needle animation to target value
        // An intermediate "middle" value is used to make sure the needle will follow the right rotation direction
        CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.removedOnCompletion = YES;
        animation.duration = animated ? duration : 0.0;
        animation.delegate = self;
        animation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeRotation([self needleAngleForValue:lastValue]  , 0, 0, 1.0)],
                             [NSValue valueWithCATransform3D:CATransform3DMakeRotation([self needleAngleForValue:middleValue], 0, 0, 1.0)],
                             [NSValue valueWithCATransform3D:CATransform3DMakeRotation([self needleAngleForValue:_value]     , 0, 0, 1.0)]];
        
        if ([_style conformsToProtocol:@protocol(DialViewStyle)] == NO || [_style needleLayer:rootNeedleLayer willMoveAnimated:animated duration:duration animation:animation] == NO)
        {
            rootNeedleLayer.transform = [[animation.values lastObject] CATransform3DValue];
            [rootNeedleLayer addAnimation:animation forKey:kCATransition];
        }
    }
    
}

#pragma mark - CAAnimation delegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (animationCompletion)
        animationCompletion(flag);
    
    animationCompletion = nil;
}

#pragma mark - Properties

- (void)setValue:(float)value
{
    [self setValue:value animated:YES];
}

- (void)setShowInnerBackground:(bool)showInnerBackground
{
    _showInnerBackground = showInnerBackground;
    [self invalidateBackground];
}

- (void)setShowInnerRim:(bool)showInnerRim
{
    _showInnerRim = showInnerRim;
    [self invalidateBackground];
}

- (void)setInnerRimWidth:(CGFloat)innerRimWidth
{
    _innerRimWidth = innerRimWidth;
    [self invalidateBackground];
}

- (void)setInnerRimBordeWidth:(CGFloat)innerRimBorderWidth
{
    _innerRimBorderWidth = innerRimBorderWidth;
    [self invalidateBackground];
}

- (void)setScalePosition:(CGFloat)scalePosition
{
    _scalePosition = scalePosition;
    [self invalidateBackground];
}

- (void)setScaleStartAngle:(CGFloat)scaleStartAngle
{
    _scaleStartAngle = scaleStartAngle;
    [self invalidateBackground];
}

- (void)setScaleEndAngle:(CGFloat)scaleEndAngle
{
    _scaleEndAngle = scaleEndAngle;
    [self invalidateBackground];
}

- (void)setScaleStartDense:(CGFloat)scaleStartDense
{
    _scaleEndDense = scaleStartDense;
    [self invalidateBackground];
}

- (void)setScaleEndDense:(CGFloat)scaleEndDens
{
    _scaleEndDense = scaleEndDens;
    [self invalidateBackground];
}

- (void)setScaleDivisions:(CGFloat)scaleDivisions
{
    _scaleDivisions = scaleDivisions;
    [self invalidateBackground];
}

- (void)setScaleSubdivisions:(CGFloat)scaleSubdivisions
{
    _scaleSubdivisions = scaleSubdivisions;
    [self invalidateBackground];
}

- (void)setShowScaleShadow:(bool)showScaleShadow
{
    _showScaleShadow = showScaleShadow;
    [self invalidateBackground];
}

- (void)setShowScale:(bool)showScale
{
    _showScale = showScale;
    [self invalidateBackground];
}

- (void)setScalesubdivisionsAligment:(WMGaugeViewSubdivisionsAlignment)scalesubdivisionsAligment
{
    _scalesubdivisionsAligment = scalesubdivisionsAligment;
    [self invalidateBackground];
}

- (void)setScaleDivisionsLength:(CGFloat)scaleDivisionsLength
{
    _scaleDivisionsLength = scaleDivisionsLength;
    [self invalidateBackground];
}

- (void)setScaleDivisionsWidth:(CGFloat)scaleDivisionsWidth
{
    _scaleDivisionsWidth = scaleDivisionsWidth;
    [self invalidateBackground];
}

-(void)setScaleMiddivisionsWidth:(CGFloat)scaleMiddivisionsWidth
{
    _scaleMiddivisionsWidth = scaleMiddivisionsWidth;
    [self invalidateBackground];
}

-(void)setScaleMiddivisions:(CGFloat)scaleMiddivisions
{
    _scaleMiddivisions = scaleMiddivisions;
    [self invalidateBackground];
}

-(void)setScaleMiddivisionsLength:(CGFloat)scaleMiddivisionsLength
{
    _scaleMiddivisionsLength = scaleMiddivisionsLength;
    [self invalidateBackground];
}

- (void)setScaleSubdivisionsLength:(CGFloat)scaleSubdivisionsLength
{
    _scaleSubdivisionsLength = scaleSubdivisionsLength;
    [self invalidateBackground];
}

- (void)setScaleSubdivisionsWidth:(CGFloat)scaleSubdivisionsWidth
{
    _scaleSubdivisionsWidth = scaleSubdivisionsWidth;
    [self invalidateBackground];
}

- (void)setScaleDivisionColor:(UIColor *)scaleDivisionColor
{
    _scaleDivisionColor = scaleDivisionColor;
    [self invalidateBackground];
}

- (void)setScaleColor:(UIColor *)scaleColor
{
    _scaleColor = scaleColor;
    [self invalidateBackground];
}

- (void)setScaleMiddivisionColor:(UIColor *)scaleMiddivisionColor
{
    _scaleMiddivisionColor = scaleMiddivisionColor;
    [self invalidateBackground];
}

-(void)setScaleSubdivisionColor:(UIColor *)scaleSubdivisionColor{
    _scaleSubdivisionColor = scaleSubdivisionColor;
    [self invalidateBackground];
}

- (void)setScaleAllSubDivisionColor:(UIColor *)scaleAllSubDivisionColor
{
    _scaleAllSubDivisionColor = scaleAllSubDivisionColor;
    [self invalidateBackground];
}

- (void)setScaleFont:(UIFont *)scaleFont
{
    _scaleFont = scaleFont;
    [self invalidateBackground];
}

- (void)setRangeLabelsWidth:(CGFloat)rangeLabelsWidth
{
    _rangeLabelsWidth = rangeLabelsWidth;
    [self invalidateBackground];
}

- (void)setMinValue:(float)minValue
{
    _minValue = minValue;
    [self invalidateBackground];
}

- (void)setMaxValue:(float)maxValue
{
    _maxValue = maxValue;
    [self invalidateBackground];
}

- (void)setRangeValues:(NSArray *)rangeValues
{
    _rangeValues = rangeValues;
    [self invalidateBackground];
}

- (void)setRangeColors:(NSArray *)rangeColors
{
    _rangeColors = rangeColors;
    [self invalidateBackground];
}

- (void)setRangeLabels:(NSArray *)rangeLabels
{
    _rangeLabels = rangeLabels;
    [self invalidateBackground];
}

- (void)setUnitOfMeasurement:(NSString *)unitOfMeasurement
{
    _unitOfMeasurement = unitOfMeasurement;
    [self invalidateBackground];
}

- (void)setUnitShowUnitOfMeasurement:(bool)unitShowUnitOfMeasurement
{
    _unitShowUnitOfMeasurement = unitShowUnitOfMeasurement;
    [self invalidateBackground];
}

- (void)setShowRangeLabels:(bool)showRangeLabels
{
    _showRangeLabels = showRangeLabels;
    [self invalidateBackground];
}

- (void)setRangeLabelsFontKerning:(CGFloat)rangeLabelsFontKerning
{
    _rangeLabelsFontKerning = rangeLabelsFontKerning;
    [self invalidateBackground];
}

- (void)setUnitOfMeasurementFont:(UIFont *)unitOfMeasurementFont
{
    _unitOfMeasurementFont = unitOfMeasurementFont;
    [self invalidateBackground];
}

- (void)setRangeLabelsFont:(UIFont *)rangeLabelsFont
{
    _rangeLabelsFont = rangeLabelsFont;
    [self invalidateBackground];
}

- (void)setUnitOfMeasurementVerticalOffset:(CGFloat)unitOfMeasurementVerticalOffset
{
    _unitOfMeasurementVerticalOffset = unitOfMeasurementVerticalOffset;
    [self invalidateBackground];
}

- (void)setUnitOfMeasurementColor:(UIColor *)unitOfMeasurementColor
{
    _unitOfMeasurementColor = unitOfMeasurementColor;
    [self invalidateBackground];
}

- (void)setRangeLabelsFontColor:(UIColor *)rangeLabelsFontColor
{
    _rangeLabelsFontColor = rangeLabelsFontColor;
    [self invalidateBackground];
}

-(void)setThemeOfMeasurement:(NSString *)themeOfMeasurement
{
    _themeOfMeasurement = themeOfMeasurement;
    [self invalidateBackground];
}

-(void)setThemeOfMeasurementFont:(UIFont *)themeOfMeasurementFont
{
    _themeOfMeasurementFont = themeOfMeasurementFont;
    [self invalidateBackground];
}

-(void)setThemeOfMeasurementColor:(UIColor *)themeOfMeasurementColor
{
    _themeOfMeasurementColor = themeOfMeasurementColor;
    [self invalidateBackground];
}

-(void)setThemeShowUnitOfMeasurement:(bool)themeShowUnitOfMeasurement
{
    _themeShowUnitOfMeasurement = themeShowUnitOfMeasurement;
    [self invalidateBackground];
}

-(void)setThemeOfMeasurementVerticalOffset:(CGFloat)themeOfMeasurementVerticalOffset
{
    _themeOfMeasurementVerticalOffset = themeOfMeasurementVerticalOffset;
    [self invalidateBackground];
}

-(void)setCurrentValue:(float )currentValue
{
    _currentValue = currentValue;
    [self invalidateBackground];
}

-(void)setCurrentFont:(UIFont *)currentFont
{
    _currentFont = currentFont;
    [self invalidateBackground];
}

-(void)setCurrentColor:(UIColor *)currentColor
{
    _currentColor = currentColor;
    [self invalidateBackground];
}

-(void)setCurrentValueShow:(bool)currentValueShow
{
    _currentValueShow = currentValueShow;
    [self invalidateBackground];
}

-(void)setCurrentVerticalOffset:(CGFloat)currentVerticalOffset
{
    _currentVerticalOffset = currentVerticalOffset;
    [self invalidateBackground];
}

-(void)setPointImage:(UIImage *)pointImage
{
    _pointImage = pointImage;
    [self invalidateBackground];
}

- (void)setStyle:(id<DialViewStyle>)style {
    _style = style;
    [self invalidateBackground];
    [self invalidateNeedle];
}


@end
