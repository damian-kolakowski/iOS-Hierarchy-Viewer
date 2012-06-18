//
//  PrettyShadowPlainTableview.h
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


#import <UIKit/UIKit.h>

typedef enum {
    PrettyShadowPlainTableviewPositionHeader = 0,
    PrettyShadowPlainTableviewPositionFooter
} PrettyShadowPlainTableviewPosition;

/** `PrettyShadowPlainTableview` is a subclass of `UIView` that drops a top
 or bottom shadow to use with plain tables.
 
 Just call `setUpTableView:` and everything will be done for you.
 */

@interface PrettyShadowPlainTableview : UIView {
@private
    PrettyShadowPlainTableviewPosition _position;
}

/** Returns an autoreleased instance of PrettyShadowPlainTableview configured
 to the specified position on the table view. 
 
 Position can be:
 
 - `PrettyShadowPlainTableviewPositionHeader`: the view will be used on the 
 tableView's header.
 - `PrettyShadowPlainTableviewPositionFooter`: the view will be used on the 
 tableView's footer.
 */
+ (id) shadowForPosition:(PrettyShadowPlainTableviewPosition)position;

/** Configures automatically the given tableView by dropping a shadow in both
 header and footer. It will also change the tableView `contentInset` according
 to the shadows' height. */
+ (void) setUpTableView:(UITableView *)tableView;

/** Returns the view's height. */
+ (float) height;

@end


/** This category adds a shortcut to drop shadows in both header and footer of
 a `UITableView`. */
@interface UITableView (PrettyKitTableViewShadows)

/** Configures automatically the receiver tableView by dropping a shadow in both
 header and footer. It will also change the tableView's `contentInset` according
 to the shadows' height. 
 
 Shadows will be included __only__ if the tableView's style is plain.
 */
- (void) dropShadows;

@end
