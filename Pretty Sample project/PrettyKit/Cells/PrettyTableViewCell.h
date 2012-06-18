//
//  PrettyTableViewCell.h
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


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum {
    PrettyTableViewCellPositionTop = 0,
    PrettyTableViewCellPositionMiddle,
    PrettyTableViewCellPositionBottom,
    PrettyTableViewCellPositionAlone
} PrettyTableViewCellPosition;



/** `PrettyTableViewCell` is a subclass of `UITableViewCell`, so it
 is fully compatible with any `UITableView`.
 
 `PrettyTableViewCell` adds a set of customizations such as corner radius, 
 shadow, background gradient, selection gradient customization...
 
 It only uses `CoreGraphics` under the hood, so you can expect a nice
 performance.
 
 ### Using it
 
 In your `dataSource` `tableView:cellForRowAtIndexPath:` body, change all
 references to `UITableViewCell` to `PrettyTableViewCell`, and add this call:
 
    [cell prepareForTableView:tableView indexPath:indexPath];
 
 Just by doing that you'll have a nice cell, like the cells below:
 
 ![](../docs/Screenshots/cells.png)
 
 ### Customizing appearance
 
 PrettyCells are compatible with both grouped and plain tables. 
 
 #### Grouped tables
 
 You can change the cell's appearance as follows:
 
 - cell's shadow (border will be disabled when the shadow is enabled).
 - cell's background color or gradient.
 - cell's border color (border will be disabled when the shadow is enabled).
 - cell's corner radius.
 - cell's separator.
 - cell's selection gradient.
 
 #### Plain tables
 
 You can change the cell's appearance as follows:
 
 - cell's background color or gradient.
 - cell's separator.
 - cell's selection gradient.
 
 ![](../docs/Screenshots/plain_cells.png)

 
 ### Performance
 
 It only uses `CoreGraphics` under the hood, so you can expect a nice
 performance. 
 
 Anyway, you should select the Color Blended Layers option and check how it looks.
 Furthermore, to even reduce more the transparent regions, you can set the 
 `tableViewBackgroundColor` property to the table's background color
 (`tableView.backgroundColor`).
 
 Be aware that although the cell is drawn with CoreGraphics, its contents might
 not. In fact, if you use the properties textLabel, detailTextLabel and so, 
 the performance will be limited by them. So if you need to improve it, take a 
 look at this Twitter article: http://engineering.twitter.com/2012/02/simple-strategies-for-smooth-animation.html
 and draw the contents by yourself.
 
 */


@interface PrettyTableViewCell : UITableViewCell {
@private
    UITableViewStyle _tableViewStyle;
}



/** @name Customizing appearance */

/** Indicates if the cell should drop a shadow or not.
 
 Its value is YES by default. */
@property (nonatomic, assign) BOOL dropsShadow;

/** Indicates the shadow opacity to use.
 
 Its value is 0.7 by default. */
@property (nonatomic, assign) float shadowOpacity;

/** Specifies the background color to use. 
 
 By default is set to `nil`, so the background color will be the UITableViewCell's 
 `backgroundColor` property.
 
 Change this property to override the background color in plain table views. */
@property (nonatomic, retain) UIColor *customBackgroundColor;

/** Specifies the background gradient start color to use. */
@property (nonatomic, retain) UIColor *gradientStartColor;

/** Specifies the background gradient end color to use. */
@property (nonatomic, retain) UIColor *gradientEndColor;

/** Specifies the color used for the cell's border. 
 
 If dropsShadow is set to `YES`, borderColor will be ignored. This property
 has a gray color by default. */
@property (nonatomic, retain) UIColor *borderColor;

/** Specifies the radio used for the cell's corners. 
 
 By default it is set to 10. */
@property (nonatomic, assign) float cornerRadius;

/** Specifies the color used for the tableView's background. 
 
 This property has a clearColor by default.  */
@property (nonatomic, retain) UIColor *tableViewBackgroundColor;

/** Specifies if a custom separator should be drawn. 
 
 By default it's set to `YES`.*/
@property (nonatomic, assign) BOOL showsCustomSeparator;


/** Specifies the color used for the cell's separator line.
 
 This property has a light gray color by default. */
@property (nonatomic, retain) UIColor *customSeparatorColor;


/** Specifies the start color for the selection gradient. 
 
 This property has a blue color by default.
 
 If UITableViewCell's `selectionStyle` property is set to 
 `UITableViewCellSelectionStyleNone`, no gradient will be shown. */
@property (nonatomic, retain) UIColor *selectionGradientStartColor;

/** Specifies the end color for the selection gradient. 
 
 This property has a blue color by default.
 
 If UITableViewCell's `selectionStyle` property is set to 
 `UITableViewCellSelectionStyleNone`, no gradient will be shown. */
@property (nonatomic, retain) UIColor *selectionGradientEndColor;


/** @name Cell configuration */



/** Tells the cell how it should draw the background shape. 
 
 This call is mandatory. Include it in your tableView dataSource's 
 `tableView:cellForRowAtIndexPath:`. */
- (void) prepareForTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;


/** Returns the needed height for a cell placed in the given indexPath.
 
 You should always implement `tableView:heightForRowAtIndexPath:` method of 
 your tableView's delegate. Inside get your cell's normal height, add the 
 result of calling `tableView:neededHeightForIndexPath:` and return the resulting
 value.
 
 You should always add the result of calling it, even if you set dropShadow 
 property to NO. */
+ (CGFloat) tableView:(UITableView *)tableView neededHeightForIndexPath:(NSIndexPath *)indexPath;



/** @name Cell status */

/** Sets the cell's position to help the background drawing. 
 
 You can change this property manually, but you should preferably use 
 `prepareForTableView:indexPath:` instead.
 
 Possible values are:
 - `PrettyTableViewCellPositionTop`
 - `PrettyTableViewCellPositionMiddle`
 - `PrettyTableViewCellPositionBottom`
 - `PrettyTableViewCellPositionAlone`
 */
@property (nonatomic, assign) PrettyTableViewCellPosition position;

/** Returns the shadows' innerFrame. */
@property (nonatomic, readonly) CGRect innerFrame;

/** Returns a mask with the rounded corners. */
@property (nonatomic, readonly) CAShapeLayer *mask;

/** Returns a new gradient with the configured selection gradient colors. 
 
 You don't have to release it after using it.
 */
- (CGGradientRef) createSelectionGradient;

/** Returns a new gradient with the configured normal gradient colors. 
 
 You don't have to release it after using it.
 */
- (CGGradientRef) createNormalGradient;

@end
