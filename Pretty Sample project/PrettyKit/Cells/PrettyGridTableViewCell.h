//
//  PrettyGridTableViewCell.h
//  PrettyExample
//
//  Created by Víctor on 12/03/12.

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
#import "PrettyCustomViewTableViewCell.h"



/** `PrettyGridTableViewCell` is a `PrettyCustomTableViewCell` customization
 that creates and manages several elements inside the same cell, displayed as a
 grid. 
  
 First of all, change numberOfElements property to match your needs. Then, call 
 setText:atIndex: for each element. You can also set detail texts with
 setDetailText:atIndex:.
 
 Finally, to receive a notification when an element is selected, change the
 actionBlock property.
 
 
 ### Customization

 #### Labels
 
 It currently presents a text label and a detailText label. All displayed 
 information, except the text alignment, is obtained from the properties 
 textLabel and detailTextLabel, inherited from `UITableViewCell` class. Text
 Alignment should be customized through the `textAlignment` property.
 
 Take into account that `textLabel` and `detailTextLabel` may change dpending on the
 cell's style. For example, if the cell's style is `UITableViewCellStyleSubtitle`,
 `detailTextLabel.textColor` would be gray, but if the style is `UITableViewCellStyleValue1`,
 the color would be blue.
 
 You can change the texts or detail texts of a given index through setText:atIndex:, 
 textAtIndex:, setDetailText:AtIndex:, detailTextAtIndex:.
 
 #### Selection
 
 You can enable or disable selection highlighting. set elementSelectionStyle to
 `UITableViewCellSelectionStyleNone` to disable highlighting, or any other 
 value to enable it. Use `selectionGradientStartColor` and `selectionGradientEndColor`
 properties from `PrettyTableViewCell` to change the gradient appearance. 
 
 You can manually select a given index through selectIndex:. You can 
 manually deselect the currently selected index through deselectAnimated:.

 You can get notified when an element is selected by setting the `actionBlock`
 property to your needs.
 
 ### Performance
 
 This cell is entirely drawn with CoreGraphics, so you will have a nice scrolling
 performance.
 
 ### Example
 
 ![](../docs/Screenshots/grid.png)
 
    [gridCell setText:@"One" atIndex:0];
    [gridCell setDetailText:@"Detail Text" atIndex:0];
    [gridCell setText:@"Two" atIndex:1];            
    [gridCell setDetailText:@"Detail Text" atIndex:1];
    [gridCell setText:@"Three" atIndex:2];
    [gridCell setDetailText:@"Detail Text" atIndex:2];            

 
 */

@interface PrettyGridTableViewCell : PrettyCustomViewTableViewCell {
@package
    UITableViewCellStyle _style;
    NSIndexPath *_indexPath;    

@private
    NSMutableDictionary *_texts;
    NSMutableDictionary *_detailTexts;
}

/** @name Basic information */

/** Specifies the number of elements in the grid. 
 
 Each time this property is modified, all set up texts and detailTexts are 
 erased. */
@property (nonatomic, assign) int numberOfElements;



/** @name Managing the labels */

/** Specifies the text alignment used in the grids. */
@property (nonatomic, assign) UITextAlignment textAlignment;

/** Returns an array with all the texts in the grid. */
@property (nonatomic, readonly) NSArray *texts;

/** Returns an array with all the detail texts in the grid. */
@property (nonatomic, readonly) NSArray *detailTexts;

/** Specifies if the shadow should be shown only on the selected element.
 
 By default it is set to NO. */
@property (nonatomic, assign) BOOL shadowOnlyOnSelected;

/** Inserts a text in the given index. */
- (void) setText:(NSString *)text atIndex:(int)index;

/** Returns the text in the given index. */
- (NSString *) textAtIndex:(int)index;

/** Inserts a detail text in the given index. */
- (void) setDetailText:(NSString *)detailText atIndex:(int)index;

/** Returns the detail text in the given index. */
- (NSString *) detailTextAtIndex:(int)index;


/** @name Managing selection */

/** Selects the element in the given index, drawing (if necessary) a blue 
 gradient in the background. */
- (void) selectIndex:(int)index;

/** Deselects the currently selected element.
 
 @params
 - animated: Specifies if the deselection should be animated or not. */
- (void) deselectAnimated:(BOOL)animated;

/** Deselects the currently selected element and performs the given block
 when the animation is completed.
 
 @params
 - animated: Specifies if the deselection should be animated or not.
 - block: the completion block. This block will be performed **only** if 
 animated is YES. */
- (void) deselectAnimated:(BOOL)animated completion:(void (^) (void))block;


/** Specifies the selection style used in the grids. */
@property (nonatomic, assign) UITableViewCellSelectionStyle elementSelectionStyle;

/** Speficies the action to be performed when an element is selected. 
 
 It can be nil. */
@property (nonatomic, copy) void(^actionBlock)(NSIndexPath *indexPath, int selectedIndex);



@end
