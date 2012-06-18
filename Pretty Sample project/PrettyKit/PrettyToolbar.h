//
//  PrettyToolbar.h
//  PrettyExample
//
//  Created by Seth Gholson on 4/25/12.

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

/** `PrettyToolbar` is a subclass of `UIToolbar` that removes the
 glossy effect and lets you customize its colors.
 
 You can change the toolbar appearance as follows:
 
 - shadow opacity
 - gradient start color
 - gradient end color
 - top line volor
 - bottom line color
*/

@interface PrettyToolbar : UIToolbar

/** Specifies the toolbar shadow's opacity.
 
 By default is `0.5`. */
@property (nonatomic, assign) float shadowOpacity;

/** Specifies the gradient's start color.
 
 By default is a blue tone. */
@property (nonatomic, retain) UIColor *gradientStartColor;

/** Specifies the gradient's end color.
 
 By default is a blue tone. */
@property (nonatomic, retain) UIColor *gradientEndColor;

/** Specifies the gradient's top line color.
 
 By default is a blue tone. */
@property (nonatomic, retain) UIColor *topLineColor;

/** Specifies the gradient's bottom line color.
 
 By default is a blue tone. */
@property (nonatomic, retain) UIColor *bottomLineColor;

@end
