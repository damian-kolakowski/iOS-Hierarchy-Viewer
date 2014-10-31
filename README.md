iOS Hierarchy Viewer for UI and CoreData
====================

iOS Hierarchy Viewer allows developers to debug their hierarchies for both UIView's and CoreData models. 
- If there are problems with layout calculations, you can find them with ease by introspecting real-time preview of your views inside a browser.
- If your data is behaving weirdly, you can easily navigate through it via a browser.
- This tool predates commercial tools like Reveal and Spark Inspector, and it's available for free.

**since 1.4.6 version, we also give you debugging Core Data API in your project (if you use it). See 'Instruction' section to set it up.**

![](http://i.stack.imgur.com/ynqvG.png)
![](http://dl.dropbox.com/u/858551/core_data.png)

Features
====================

+ the client is implemented in HTML/JS/CSS. Additional software is not required
+ preview of device/simulator screen. Can be scaled and/or rotated on demand
+ debug frames shows the exact UIViews frames
+ property list shows obj-c properties and their values for selected UIView

Installation
====================

+ download newest version of library from releases section [Lib] or use it as cocoapods spec
+ add these files to your project (drag&drop into xCode project)
+ make sure that you have added “-ObjC -all_load” to “other linker flags” (click at project root element, select “Build settings” tab, search for “other linker flags”)
+ <del>if you already have JSONKit.m file in your project, please remove it because of linker conflict</del> We switched to Apple's NSJSONSerialization so skip this step.
+ add QuartzCore to frameworks list
+ launch hierarchy viewer in your code by calling [iOSHierarchyViewer start];. The best place for it is AppDelegate::applicationDidBecomeActive callback
+ find or get from logs device/simulator ip address and go to ‘http://[ip_address]:9449′ address (Chrome/Firefox only)

```objc
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // your stuff
    [iOSHierarchyViewer start];    
}
```

If you would like to see data from Core Data API:
+ add CoreData to frameworks list
+ go to 'http://[ip_address]:9449/core.html' and add NSManagedContext object to iOSHierarchyViewer library

```objc
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // your stuff
    
    setup persistent store coordinator for _managedObjectContext
    
    [iOSHierarchyViewer addContext:_managedObjectContext name:@"Root managed context"];    
}
```

You can always look at sample project, there is only 1 line of code needed for iOSHierarchyViewer to work with your project.
We really like PrettyKit ( https://github.com/vicpenap/PrettyKit ), so we just enabled our hierarchy viewer in their sample project. If you don't know what PrettyKit is you need to check it out!

Changelog:
====================

Version 1.3:
+ fixed crashes at UITextView:
+ some properties can be read only from UI thread
+ some properties ( like 'autocapitalizationType' ) are not KVC compliant.

Version 1.4:
+ Accesibility labels are used when set, making it easier to read hierarchy
+ All scaning now takes place on main thread.

Roadmap and Contributing:
====================
- Coloring non-opaque and misaligned view's similar to CoreAnimation instruments
- Selected views from HTML side highlight in tree navigator
- Support for cocos2d nodes visualisation and debugging

Did you find a bug ? Do you have feature request ? Do you want to merge a feature ?
Send us a pull request or add an issue in the tracker!

[LIB]: https://github.com/glock45/iOS-Hierarchy-Viewer/releases

License
====================
MIT. Full license in LICENSE.txt file.

Authors:
====================
[Damian Kołakowski](https://twitter.com/kolakowski)

[Krzysztof Zabłocki](http://twitter.com/merowing_)
