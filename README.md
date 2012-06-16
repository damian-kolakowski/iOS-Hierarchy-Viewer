iOS-Hierarchy-Viewer
====================

iOS Hierarchy Viewer allows developers to debug their user interfaces. If there are problems with layout calculations, it will catch them by giving a real time preview of the UIViews hierarchy.

Features

+ the client is implemented in HTML/JS/CSS. Additional software is not required
+ preview of device/simulator screen. Can be scaled and/or rotated on demand
+ debug frames shows the exact UIViews frames
+ property list shows obj-c properties and their values for selected UIView

Installation

+ download the static library and header for it (lib,header)
+ add these files to your project (drag&drop into xCode project)
+ make sure that you have added “-ObjC -all_load” to “other linker flags” (click at project root element, select “Build settings” tab, search for “other linker flags”)
+ if you already have JSONKit.m file in your project, please remove it because of linker conflict
+ launch hierarchy viewer in your code by calling [iOSHierarchyViewer start];. The best place for it is AppDelegate::applicationDidBecomeActive callback
+ find or get from logs device/simulator ip address and go to ‘http://[ip_address]:9449′ address (Chrome/Firefox only)