//
//  PrettySegmentedTableViewCell.h
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


#import <UIKit/UIKit.h>
#import "PrettyGridTableViewCell.h"

/** `PrettySegmentedControlTableViewCell` is a `PrettyGridTableViewCell` that
 behaves like a UISegmentedControl.

 ### Usage
 
 Just change the NSArray `titles` property, and the cell will be automatically 
 adapted to the array.
 
 You can manually select a given index by changing the `selectedIndex` property.
 
 ### Callback
 
 If you want to receive a notification when an element is selected, change the
 `actionBlock` property, inherited from `PrettyGridTableViewCell`.
 
 ### Example 
 
 ![](../docs/Screenshots/segmented_control.png)
 
    segmentedCell.titles = [NSArray arrayWithObjects:@"1", @"2", @"3", @"4", nil];
 
 
 */

@interface PrettySegmentedControlTableViewCell : PrettyGridTableViewCell


@property (nonatomic, retain) NSArray *titles;
@property (nonatomic, assign) NSInteger selectedIndex;

@end
