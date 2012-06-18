//
//  PrettyShadowPlainTableview.m
//  PrettyExample
//
//  Created by Víctor on 02/04/12.

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


#import "PrettyShadowPlainTableview.h"

#define view_height 25
#define shadow_height 5

@implementation PrettyShadowPlainTableview


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentMode = UIViewContentModeRedraw;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

+ (id) shadowForPosition:(PrettyShadowPlainTableviewPosition)position
{
    PrettyShadowPlainTableview *view = [[PrettyShadowPlainTableview alloc] initWithFrame:CGRectMake(0, 0, 0, view_height)];
    view->_position = position;
    
    return [view autorelease];
}


- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    
    CGContextSetShadowWithColor(ctx, CGSizeMake(0, 0), 20, [UIColor colorWithRed:0 green:0 blue:0 alpha:1].CGColor);

    
    float position = _position == PrettyShadowPlainTableviewPositionHeader ? CGRectGetMaxY(rect)+shadow_height : CGRectGetMinY(rect)-shadow_height;
    
    CGContextMoveToPoint(ctx, CGRectGetMinX(rect), position);
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), position);
    
    CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(ctx, shadow_height);
    
    CGContextStrokePath(ctx);
    CGContextRestoreGState(ctx);    
}

+ (void) setUpTableView:(UITableView *)tableView 
{
    tableView.tableHeaderView = [PrettyShadowPlainTableview shadowForPosition:PrettyShadowPlainTableviewPositionHeader];
    tableView.tableFooterView = [PrettyShadowPlainTableview shadowForPosition:PrettyShadowPlainTableviewPositionFooter];
    tableView.contentInset = UIEdgeInsetsMake(-tableView.tableHeaderView.frame.size.height, 0, 
                                              -tableView.tableFooterView.frame.size.height, 0);
}

+ (float) height {
    return view_height;
}

@end


@implementation UITableView (PrettyKitTableViewShadows)

- (void) dropShadows
{
    if (self.style == UITableViewStylePlain)
    {
        [PrettyShadowPlainTableview setUpTableView:self];
    }
}

@end
