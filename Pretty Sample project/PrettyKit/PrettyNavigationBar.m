//
//  PrettyNavigationBar.m
//  PrettyExample
//
//  Created by Víctor on 01/03/12.

// Copyright (c) 2012 Victor Pena Placer (@vicpenap)
// http://www.victorpena.es/
// 
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the "Software"), to deal in
// the Software without restriction, including without limitation the rights to
// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
// the Software, and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.


#import "PrettyNavigationBar.h"
#import <QuartzCore/QuartzCore.h>
#import "PrettyDrawing.h"
#import <math.h>

@implementation PrettyNavigationBar
@synthesize shadowOpacity, gradientEndColor, gradientStartColor, topLineColor, bottomLineColor, roundedCornerRadius, roundedCornerColor;


#define default_shadow_opacity 0.5
#define default_gradient_end_color      [UIColor colorWithHex:0x297CB7]
#define default_gradient_start_color    [UIColor colorWithHex:0x53A4DE]
#define default_top_line_color          [UIColor colorWithHex:0x84B7D5]
#define default_bottom_line_color       [UIColor colorWithHex:0x186399]
#define default_tint_color              [UIColor colorWithHex:0x3D89BF]
#define default_roundedcorner_color     [UIColor blackColor]

- (void)dealloc {
    self.gradientStartColor = nil;
    self.gradientEndColor = nil;
    self.topLineColor = nil;
    self.bottomLineColor = nil;
    self.roundedCornerColor = nil;    
    
    [super dealloc];
}

- (void) initializeVars 
{
    self.contentMode = UIViewContentModeRedraw;
    self.shadowOpacity = default_shadow_opacity;
    self.gradientStartColor = default_gradient_start_color;
    self.gradientEndColor = default_gradient_end_color;
    self.topLineColor = default_top_line_color;
    self.bottomLineColor = default_bottom_line_color;
    self.tintColor = default_tint_color;
    self.roundedCornerColor = default_roundedcorner_color;
    self.roundedCornerRadius = 0.0;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self initializeVars];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeVars];
    }
    return self;
}


- (id)init {
    self = [super init];
    if (self) {
        [self initializeVars];
    }
    return self;
}


-(void) drawLeftRoundedCornerAtPoint:(CGPoint)point withRadius:(CGFloat)radius withTransformation:(CGAffineTransform)transform {
    
    // create the path. has to be done this way to allow use of the transform
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, &transform, point.x, point.y);
    CGPathAddLineToPoint(path, &transform, point.x, point.y + radius);
    CGPathAddArc(path, &transform, point.x + radius, point.y + radius, radius, (180) * M_PI/180, (-90) * M_PI/180, 0);
    CGPathAddLineToPoint(path, &transform, point.x, point.y);
    
    // fill the path to create the illusion that the corner is rounded
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddPath(context, path);
    CGContextSetFillColorWithColor(context, [self.roundedCornerColor CGColor]);
    CGContextFillPath(context);

    // appropriate memory management
    CGPathRelease(path);
}

- (void) drawTopLine:(CGRect)rect {
    [PrettyDrawing drawLineAtPosition:LinePositionTop rect:rect color:self.topLineColor];
}


- (void) drawBottomLine:(CGRect)rect {
    [PrettyDrawing drawLineAtPosition:LinePositionBottom rect:rect color:self.bottomLineColor];
}

- (void) drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    [self dropShadowWithOpacity:self.shadowOpacity];
    [PrettyDrawing drawGradient:rect fromColor:self.gradientStartColor toColor:self.gradientEndColor];
    [self drawTopLine:rect];        
    [self drawBottomLine:rect];
    
    if (self.roundedCornerRadius > 0) {
        // draw the left rounded corner with a transform of 0 because nothing should be changed
        [self drawLeftRoundedCornerAtPoint:CGPointMake(0, 0) withRadius:self.roundedCornerRadius withTransformation:CGAffineTransformMakeRotation(0)];
        
        // draw the right rounded corner with a 90degree transform. this means the x and y coords are flipped which means the point must also flip
        [self drawLeftRoundedCornerAtPoint:CGPointMake(0, -self.frame.size.width) withRadius:self.roundedCornerRadius withTransformation:CGAffineTransformMakeRotation((90) * M_PI/180)];
    }
}


@end
