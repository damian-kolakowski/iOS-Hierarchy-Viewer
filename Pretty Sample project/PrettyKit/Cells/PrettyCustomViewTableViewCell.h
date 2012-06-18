//
//  DetailPrettyTableViewCell.h
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


#import <UIKit/UIKit.h>
#import "PrettyTableViewCell.h"

/** `PrettyCustomViewTableViewCell` is a subclass of `PrettyTableViewCell`.
 
 `PrettyCustomViewTableViewCell` adds a custom view inside the cell (*not 
 inside the contentView!*), and masks it to the cell's shape. So you can add
 an image, for example, and it will get masked to the cell's shape, with the
 rounded corners.
*/

@interface PrettyCustomViewTableViewCell : PrettyTableViewCell

/** Holds a reference to the custom view. */
@property (nonatomic, retain) UIView *customView;

@end
