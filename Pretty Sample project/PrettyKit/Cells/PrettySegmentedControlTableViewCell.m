//
//  PrettySegmentedTableViewCell.m
//  PrettyExample
//
//  Created by Víctor on 13/03/12.

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


#import "PrettySegmentedControlTableViewCell.h"


@implementation PrettySegmentedControlTableViewCell
@synthesize selectedIndex;

- (void) updateButtonActions 
{
    /* a bit of hacking. In this case, we don't care if the user drags the finger
     or not, we still want te segment to be selected. */
    [(UIButton *)self.customView removeTarget:self.customView
                                       action:@selector(hardDeselect) 
                             forControlEvents:UIControlEventTouchDragInside | UIControlEventTouchDragOutside | UIControlEventTouchUpOutside];
    [(UIButton *)self.customView addTarget:self.customView action:@selector(fireButtonAction:event:) forControlEvents:UIControlEventTouchUpOutside];           
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        selectedIndex = -1;
        
        UIColor *tmp = [self.selectionGradientStartColor retain];
        self.selectionGradientStartColor = self.selectionGradientEndColor;
        self.selectionGradientEndColor = tmp;
        [tmp release];
        
        self.textLabel.shadowColor = [UIColor blackColor];
        self.textLabel.shadowOffset = CGSizeMake(0, 1);

        self.shadowOnlyOnSelected = YES;
        
        [self updateButtonActions];
    }
    return self;
}


- (void) _setSelectedIndex:(NSInteger)sselectedIndex {
    selectedIndex = sselectedIndex;
    
    [super selectIndex:selectedIndex];
}

- (void) restartSelectedIndex {
    [self _setSelectedIndex:0];
}


- (NSArray *) titles {
    return self.texts;
}

- (void) setTitles:(NSArray *)titles {
    self.numberOfElements = [titles count];
    for (int i = 0; i < self.numberOfElements; i++) {
        [self setText:[titles objectAtIndex:i] atIndex:i];
    }
    [self restartSelectedIndex];
}


- (void) setSelectedIndex:(NSInteger)sselectedIndex {
    [self _setSelectedIndex:sselectedIndex];
}

- (void) setActionBlock:(void (^)(NSIndexPath *indexPath, int sselectedIndex))actionBlock {
    [super setActionBlock:^(NSIndexPath *indexPath, int sselectedIndex) {
        selectedIndex = sselectedIndex;
        actionBlock(indexPath, sselectedIndex);
    }];
}


@end
