iOS-Hierarchy-Viewer
====================

iOS Hierarchy Viewer allows developers to debug their user interfaces. If there are problems with layout calculations, it will catch them by giving a real time preview of the UIViews hierarchy.

![](http://androiddev.vipserv.org/wordpress/wp-content/uploads/2012/04/Screen-Shot-2012-04-24-at-9.09.20-PM.png)

Features
====================

+ the client is implemented in HTML/JS/CSS. Additional software is not required
+ preview of device/simulator screen. Can be scaled and/or rotated on demand
+ debug frames shows the exact UIViews frames
+ property list shows obj-c properties and their values for selected UIView

Installation
====================

+ download the static library and header for it (latest build: [LIB][],[HEADER][])
+ add these files to your project (drag&drop into xCode project)
+ make sure that you have added “-ObjC -all_load” to “other linker flags” (click at project root element, select “Build settings” tab, search for “other linker flags”)
+ if you already have JSONKit.m file in your project, please remove it because of linker conflict
+ launch hierarchy viewer in your code by calling [iOSHierarchyViewer start];. The best place for it is AppDelegate::applicationDidBecomeActive callback
+ find or get from logs device/simulator ip address and go to ‘http://[ip_address]:9449′ address (Chrome/Firefox only)

```objc
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // your stuff
    [iOSHierarchyViewer start];    
}
```
License
====================

Copyright (c) 2012 Damian Kolakowski
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
1. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.
3. All advertising materials mentioning features or use of this software
   must display the following acknowledgement:
   This product includes software developed by the Damian Kolakowski.
4. Neither the name of the Damian Kolakowski nor the
   names of its contributors may be used to endorse or promote products
   derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY DAMIAN KOLAKOWSKI ''AS IS'' AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

[LIB]: http://dl.dropbox.com/u/858551/iOS%20Hierarchy%20Viewer/libiOSHierarchyViewer_fat.a
[HEADER]: http://dl.dropbox.com/u/858551/iOS%20Hierarchy%20Viewer/iOSHierarchyViewer.h