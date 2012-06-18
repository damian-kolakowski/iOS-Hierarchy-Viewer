//
//  DetailPrettyTableViewCell.m
//  PrettyExample
//
//  Created by Víctor on 05/03/12.

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


#import "PrettyCustomViewTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation PrettyCustomViewTableViewCell
@synthesize customView;

#define shadow_margin 4 

- (void) dealloc 
{
    self.customView = nil;
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}


- (void) drawRect:(CGRect)rect 
{
    [super drawRect:rect];
    
    if (self.customView != nil) 
    {    
        self.customView.frame = self.innerFrame;
        
		self.customView.layer.mask = self.mask;
        self.customView.layer.masksToBounds = YES;
        
        if (![self.subviews containsObject:self.customView])
        {
            [self addSubview:self.customView];
        }
    }
}

- (void) setBackgroundColor:(UIColor *)backgroundColor 
{
    [super setBackgroundColor:backgroundColor];
    self.customView.backgroundColor = backgroundColor;
}

- (void) setCustomBackgroundColor:(UIColor *)customBackgroundColor 
{
    [super setCustomBackgroundColor:customBackgroundColor];
    self.customView.backgroundColor = customBackgroundColor;
}

@end
