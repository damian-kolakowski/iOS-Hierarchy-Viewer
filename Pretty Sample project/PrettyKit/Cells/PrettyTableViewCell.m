//
//  PrettyTableViewCell.m
//  PrettyExample
//
//  Created by Víctor on 28/02/12.

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


#import "PrettyTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "PrettyDrawing.h"

#define shadow_margin           4
#define default_shadow_opacity  0.7

#define contentView_margin      2

#define default_radius          10

#define default_border_color                    [UIColor colorWithHex:0xBCBCBC]
#define default_separator_color                 [UIColor colorWithHex:0xCDCDCD] 

#define default_selection_gradient_start_color  [UIColor colorWithHex:0x0089F9]
#define default_selection_gradient_end_color    [UIColor colorWithHex:0x0054EA]


typedef enum {
    CellBackgroundBehaviorNormal = 0,
    CellBackgroundBehaviorSelected,
} CellBackgroundBehavior;

typedef enum {
    CellBackgroundGradientNormal = 0,
    CellBackgroundGradientSelected,
} CellBackgroundGradient;



@interface PrettyTableViewCell (Private)

- (float) shadowMargin;
- (BOOL) tableViewIsGrouped;

@end

@implementation PrettyTableViewCell (Private)
- (BOOL) tableViewIsGrouped {
    return _tableViewStyle == UITableViewStyleGrouped;
}

- (float) shadowMargin {
    return [self tableViewIsGrouped] ? shadow_margin : 0;
}

@end



// http://www.raywenderlich.com/2033/core-graphics-101-lines-rectangles-and-gradients
// https://developer.apple.com/library/mac/documentation/graphicsimaging/reference/CGContext/Reference/reference.html

@interface PrettyTableViewCellBackground : UIView

@property (nonatomic, assign) PrettyTableViewCell *cell;
@property (nonatomic, assign) CellBackgroundBehavior behavior;

- (id) initWithFrame:(CGRect)frame behavior:(CellBackgroundBehavior)behavior;

@end

@implementation PrettyTableViewCellBackground
@synthesize cell;
@synthesize behavior;


- (CGPathRef) createRoundedPath:(CGRect)rect 
{
    UIRectCorner corners;

    switch (self.cell.position) {
        case PrettyTableViewCellPositionTop:
            corners = UIRectCornerTopLeft | UIRectCornerTopRight;
            break;
        case PrettyTableViewCellPositionMiddle:
            corners = 0;
            break;
        case PrettyTableViewCellPositionBottom:
            corners = UIRectCornerBottomLeft | UIRectCornerBottomRight;
            break;
        default:
            corners = UIRectCornerAllCorners;
            break;
    }

    UIBezierPath *thePath = [UIBezierPath bezierPathWithRoundedRect:rect
                                                  byRoundingCorners:corners
                                                        cornerRadii:CGSizeMake(self.cell.cornerRadius, self.cell.cornerRadius)];    
    return thePath.CGPath;
}


- (CGGradientRef) createGradientFromType:(CellBackgroundGradient)type
{
    switch (type) 
    {
        case CellBackgroundGradientSelected:
            return [self.cell createSelectionGradient];
        default:
            return [self.cell createNormalGradient];
    }
}

- (void) drawGradient:(CGRect)rect type:(CellBackgroundGradient)type 
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    
    CGPathRef path;
    path = [self createRoundedPath:rect];
    
    CGContextAddPath(ctx, path);
        
    CGGradientRef gradient = [self createGradientFromType:type];
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextClip(ctx);
    CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, 0);
    CGGradientRelease(gradient);
    
    CGContextRestoreGState(ctx);
}

- (void) drawBackground:(CGRect)rect
{
    if (self.behavior == CellBackgroundBehaviorSelected 
        && self.cell.selectionStyle != UITableViewCellSelectionStyleNone)
    {
        [self drawGradient:rect type:CellBackgroundGradientSelected];
        return;
    }
    
    if (self.cell.gradientStartColor && self.cell.gradientEndColor)
    {
        [self drawGradient:rect type:CellBackgroundGradientNormal];
        return;
    }
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    
    // draws body
    CGPathRef path;
    path = [self createRoundedPath:rect];

    CGContextAddPath(ctx, path);

    CGContextSetFillColorWithColor(ctx, self.cell.backgroundColor.CGColor);
    CGContextFillPath(ctx);

    CGContextRestoreGState(ctx);
}

- (void) drawLineSeparator:(CGRect)rect 
{
    if (!self.cell.showsCustomSeparator) {
        return;
    }
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);

    // draws body

    CGContextMoveToPoint(ctx, CGRectGetMinX(rect), CGRectGetMaxY(rect));
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
 
    CGContextSetStrokeColorWithColor(ctx, self.cell.customSeparatorColor.CGColor);
    CGContextSetLineWidth(ctx, 1);
    CGContextStrokePath(ctx);
    
    CGContextRestoreGState(ctx);
}

- (void) fixShadow:(CGContextRef)ctx rect:(CGRect)rect
{
    if (self.cell.position == PrettyTableViewCellPositionTop || self.cell.position == PrettyTableViewCellPositionAlone)
    {
        return;
    }
    
    CGContextSaveGState(ctx);
    CGContextMoveToPoint(ctx, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMinY(rect));
    CGContextSetStrokeColorWithColor(ctx, self.cell.borderColor.CGColor);
    CGContextSetLineWidth(ctx, 5);

    UIColor *shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:self.cell.shadowOpacity];
    CGContextSetShadowWithColor(ctx, CGSizeMake(0, -1), 3, shadowColor.CGColor);

    CGContextStrokePath(ctx);
    
    CGContextRestoreGState(ctx);

}

- (void) drawBorder:(CGRect)rect shadow:(BOOL)shadow 
{
    float shadowShift = 0.5 * self.cell.dropsShadow;
    
    CGRect innerRect = CGRectMake(rect.origin.x+shadowShift, rect.origin.y+shadowShift,
                                  rect.size.width-shadowShift*2, rect.size.height-shadowShift*2);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    if (shadow) 
    {
        [self fixShadow:ctx rect:innerRect];
    }

    
    CGContextSaveGState(ctx);

    // draws body
    
    CGPathRef path = [self createRoundedPath:innerRect];
    CGContextAddPath(ctx, path);

    if (shadow) {
        UIColor *shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:self.cell.shadowOpacity];
        CGContextSetShadowWithColor(ctx, CGSizeMake(0, 1), 3, shadowColor.CGColor);
    }   
    CGContextSetStrokeColorWithColor(ctx, self.cell.borderColor.CGColor);
    CGContextSetLineWidth(ctx, 2 - shadowShift);
    CGContextStrokePath(ctx);
    
    CGContextRestoreGState(ctx);
}

- (CGRect) innerFrame:(CGRect)frame 
{
    float y = 0;
    float h = 0;
    
    float shadowMargin = [self.cell shadowMargin];
    
    switch (self.cell.position) 
    {
        case PrettyTableViewCellPositionAlone:
            h += shadowMargin;
        case PrettyTableViewCellPositionTop:
            y = shadowMargin;
            h += shadowMargin;
            break;
        case PrettyTableViewCellPositionBottom:
            h = shadowMargin;
            break;
        default:
            break;
    }
    
    return CGRectMake(frame.origin.x + shadowMargin, 
                      frame.origin.y + y, 
                      frame.size.width - shadowMargin*2, 
                      frame.size.height - h);
}


- (void) drawRect:(CGRect)initialRect 
{
    CGRect rect = [self innerFrame:initialRect];
    
    [self drawBorder:rect shadow:self.cell.dropsShadow];
    
    [self drawBackground:rect];
    
    if (self.cell.position == PrettyTableViewCellPositionTop
        || self.cell.position == PrettyTableViewCellPositionMiddle)
    {
        [self drawLineSeparator:CGRectMake(rect.origin.x, rect.origin.y,
                                           rect.size.width, rect.size.height)];
    } 
}




- (void) dealloc 
{
    self.cell = nil;
    
    [super dealloc];
}

- (id) initWithFrame:(CGRect)frame behavior:(CellBackgroundBehavior)bbehavior 
{
    if (self = [super initWithFrame:frame]) 
    {
        self.contentMode = UIViewContentModeRedraw;
        self.behavior = bbehavior;
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}


@end






@implementation PrettyTableViewCell
@synthesize position, dropsShadow, borderColor, tableViewBackgroundColor;
@synthesize customSeparatorColor, selectionGradientStartColor, selectionGradientEndColor;
@synthesize cornerRadius, showsCustomSeparator;
@synthesize customBackgroundColor, gradientStartColor, gradientEndColor;
@synthesize shadowOpacity;


- (void) dealloc
{
    [self.contentView removeObserver:self forKeyPath:@"frame"];
    self.borderColor = nil;
    self.tableViewBackgroundColor = nil;
    self.customSeparatorColor = nil;
    self.selectionGradientStartColor = nil;
    self.selectionGradientEndColor = nil;
    self.customBackgroundColor = nil;
    self.gradientStartColor = nil;
    self.gradientEndColor = nil;
    
    [super dealloc];
}

- (void)initializeVars
{
    // default values
    self.position = PrettyTableViewCellPositionMiddle;
    self.dropsShadow = YES;
    self.borderColor = default_border_color;
    self.tableViewBackgroundColor = [UIColor clearColor];
    self.customSeparatorColor = default_separator_color;
    self.showsCustomSeparator = YES;
    self.selectionGradientStartColor = default_selection_gradient_start_color;
    self.selectionGradientEndColor = default_selection_gradient_end_color;
    self.cornerRadius = default_radius;
    self.shadowOpacity = default_shadow_opacity;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        [self.contentView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionOld context:nil];

        
        PrettyTableViewCellBackground *bg = [[PrettyTableViewCellBackground alloc] initWithFrame:self.frame 
                                                                                  behavior:CellBackgroundBehaviorNormal];
        bg.cell = self;
        self.backgroundView = bg;
        [bg release];
        
        bg = [[PrettyTableViewCellBackground alloc] initWithFrame:self.frame
                                                      behavior:CellBackgroundBehaviorSelected];
        bg.cell = self;
        self.selectedBackgroundView = bg;
        [bg release];
        
        [self initializeVars];
    }
    return self;
}


+ (PrettyTableViewCellPosition) positionForTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    
    if ([tableView.dataSource tableView:tableView numberOfRowsInSection:indexPath.section] == 1) {
        return PrettyTableViewCellPositionAlone;
    }
    if (indexPath.row == 0) {
        return PrettyTableViewCellPositionTop;
    }
    if (indexPath.row+1 == [tableView.dataSource tableView:tableView numberOfRowsInSection:indexPath.section])
    {
        return PrettyTableViewCellPositionBottom;
    }

    return PrettyTableViewCellPositionMiddle;
}

+ (CGFloat) neededHeightForPosition:(PrettyTableViewCellPosition)position tableStyle:(UITableViewStyle)style 
{
    if (style == UITableViewStylePlain)
    {
        return 0;
    }
    
    switch (position) 
    {
        case PrettyTableViewCellPositionBottom:
        case PrettyTableViewCellPositionTop:
            return shadow_margin;
        case PrettyTableViewCellPositionAlone:
            return shadow_margin*2;
        default:
            return 0;
    }    
}

+ (CGFloat) tableView:(UITableView *)tableView neededHeightForIndexPath:(NSIndexPath *)indexPath
{
    PrettyTableViewCellPosition position = [PrettyTableViewCell positionForTableView:tableView indexPath:indexPath];
    return [PrettyTableViewCell neededHeightForPosition:position tableStyle:tableView.style];
}

- (void) prepareForTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath 
{
    _tableViewStyle = tableView.style;
    self.position = [PrettyTableViewCell positionForTableView:tableView indexPath:indexPath];
}

// Avoids contentView's frame auto-updating. It calculates the best size, taking
// into account the cell's margin and so.
- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context 
{
    if ([keyPath isEqualToString:@"frame"]) 
    {        
        UIView *contentView = (UIView *) object;
        CGRect originalFrame = contentView.frame;

        float shadowMargin = [self shadowMargin];
        
        float y = contentView_margin;
        switch (self.position) {
            case PrettyTableViewCellPositionTop:
            case PrettyTableViewCellPositionAlone:
                y += shadowMargin;
                break;
            default:
                break;
        }
        float diffY = y - originalFrame.origin.y;
        
        if (diffY != 0)
        {
            CGRect rect = CGRectMake(originalFrame.origin.x+shadowMargin,
                                     originalFrame.origin.y+diffY,
                                     originalFrame.size.width - shadowMargin*2,
                                     originalFrame.size.height- contentView_margin*2 - [PrettyTableViewCell neededHeightForPosition:self.position tableStyle:_tableViewStyle]);
            contentView.frame = rect;
        }
    }
}

- (void) prepareForReuse 
{
    [super prepareForReuse];
    [self.backgroundView setNeedsDisplay];
    [self.selectedBackgroundView setNeedsDisplay];
}

- (void) setTableViewBackgroundColor:(UIColor *)aBackgroundColor 
{
    [aBackgroundColor retain];
    if (tableViewBackgroundColor != nil) {
        [tableViewBackgroundColor release];
    }
    tableViewBackgroundColor = aBackgroundColor;
    
    self.backgroundView.backgroundColor = aBackgroundColor;
    self.selectedBackgroundView.backgroundColor = aBackgroundColor;
}


- (CGRect) innerFrame 
{
    float topMargin = 0;
    float bottomMargin = 0;
    float shadowMargin = [self shadowMargin];
    
    switch (self.position) {
        case PrettyTableViewCellPositionTop:
            topMargin = shadowMargin;
        case PrettyTableViewCellPositionMiddle:
            // let the separator to be painted, but separator is only painted
            // in grouped table views
            bottomMargin = [self tableViewIsGrouped] ? 1 : 0; 
            break;
        case PrettyTableViewCellPositionAlone:
            topMargin = shadowMargin;
            bottomMargin = shadowMargin;
            break;
        case PrettyTableViewCellPositionBottom:
            bottomMargin = shadowMargin;
            break;
        default:
            break;
    }
    
    
    CGRect frame = CGRectMake(self.backgroundView.frame.origin.x+shadowMargin, 
                              self.backgroundView.frame.origin.y+topMargin, 
                              self.backgroundView.frame.size.width-shadowMargin*2,
                              self.backgroundView.frame.size.height-topMargin-bottomMargin);
    
    return frame;
}


- (CAShapeLayer *) mask 
{
    UIRectCorner corners = 0;
    
    switch (self.position)
    {
        case PrettyTableViewCellPositionTop:
            corners = UIRectCornerTopLeft | UIRectCornerTopRight;
            break;
        case PrettyTableViewCellPositionAlone:
            corners = UIRectCornerAllCorners;
            break;
        case PrettyTableViewCellPositionBottom:
            corners = UIRectCornerBottomLeft | UIRectCornerBottomRight;
            break;
        default:
            break;
    }
    
    CGRect maskRect = CGRectMake(0, 0, 
                                 self.innerFrame.size.width, 
                                 self.innerFrame.size.height);
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:maskRect
                                                   byRoundingCorners:corners
                                                         cornerRadii:CGSizeMake(self.cornerRadius, self.cornerRadius)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = maskRect;
    maskLayer.path = maskPath.CGPath;

    return [maskLayer autorelease];
}

- (BOOL) dropsShadow 
{
    return dropsShadow && [self tableViewIsGrouped];
}

- (float) cornerRadius
{
    return [self tableViewIsGrouped] ? cornerRadius : 0;
}

- (UIColor *) backgroundColor 
{
    return customBackgroundColor ? customBackgroundColor : [super backgroundColor];
}

- (CGGradientRef) createSelectionGradient
{
    CGFloat locations[] = { 0, 1 };    
    
    NSArray *colors = [NSArray arrayWithObjects:(id)self.selectionGradientStartColor.CGColor, (id)self.selectionGradientEndColor.CGColor, nil];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, 
                                                        (CFArrayRef) colors, locations);
    CGColorSpaceRelease(colorSpace);
    
    return gradient;
}

- (CGGradientRef) createNormalGradient
{
    CGFloat locations[] = { 0, 1 };    
    
    NSArray *colors = [NSArray arrayWithObjects:(id)self.gradientStartColor.CGColor, (id)self.gradientEndColor.CGColor, nil];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, 
                                                        (CFArrayRef) colors, locations);
    CGColorSpaceRelease(colorSpace);
    
    return gradient;
}



@end
