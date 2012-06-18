//
//  RotableTabBarController.m
//  PrettyExample
//
//  Created by Víctor on 10/04/12.
//  Copyright (c) 2012 Victor Pena Placer. All rights reserved.
//

#import "RotableTabBarController.h"

@implementation RotableTabBarController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

@end
