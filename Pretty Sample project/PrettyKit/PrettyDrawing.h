//
//  Drawing.h
//  PrettyExample
//
//  Created by Víctor on 01/03/12.

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


#import <Foundation/Foundation.h>

typedef enum {
    LinePositionTop = 0,
    LinePositionBottom,
} LinePosition;

/** 
 This class contains a set of methods to perform common drawing tasks.
 */

@interface PrettyDrawing : NSObject

/** 
 Draws a gradient with the given colors into the given rect.
 */
+ (void) drawGradient:(CGRect)rect fromColor:(UIColor *)from toColor:(UIColor *)to;

/** 
 Draws a gradient with the given gradient reference into the given rect.
 */
+ (void) drawGradient:(CGGradientRef)gradient rect:(CGRect)rect;

/** 
 Draws a line in the given position, with the given color into the given rect.
 
 position can be:
 
 - `LinePositionTop`: the rect's min height.
 - `LinePositionBottom`: the rect's max height.

 */
+ (void) drawLineAtPosition:(LinePosition)position rect:(CGRect)rect color:(UIColor *)color;

/** 
 Draws a line at the given rect's height, with the given color into the given rect.
 */
+ (void) drawLineAtHeight:(float)height rect:(CGRect)rect color:(UIColor *)color width:(float)width;

@end


/** This category adds a set of methods to UIView class. */
@interface UIView (PrettyKit)


/** Drops a shadow with the given opacity.
 
 @warning This method uses the UILayer shadow properties.
 */
- (void) dropShadowWithOpacity:(float)opacity;

@end


/** This category adds a set of methods to UIColor class. */
@interface UIColor (PrettyKit)

/** Returns an autoreleased UIColor instance with the hexadecimal color.
 
 @param hex A color in hexadecimal notation: `0xCCCCCC`, `0xF7F7F7`, etc.
 
 @return A new autoreleased UIColor instance. */
+ (UIColor *) colorWithHex:(int)hex;

@end