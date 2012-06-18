# PrettyKit

`PrettyKit` is a small set of new widgets and UIKit subclasses that 
gives you a deeper UIKit customization. You will be able to change 
their background color, add gradients, shadows, etc.

At the time of writing these docs, there are subclasses for 
`UITableViewCell`, `UINavigationBar` and `UITabBar`, and several custom
cells.

Here are some examples of what you can achieve:

![](https://github.com/vicpenap/PrettyKit/raw/master/Screenshots/grouped_table.png)

![](https://github.com/vicpenap/PrettyKit/raw/master/Screenshots/plain_table.png)

## Documentation

Full documentation can be found here: http://vicpenap.github.com/PrettyKit

## Using it

Using this framework is really easy.

First:

- Copy all files under the `PrettyKit` folder. 
- `#import "PrettyKit.h"` where you need it.

Then, just change all your references to UI classes to Pretty classes, 
and you're done.

You'll find further information on how to use the classes in the docs.

## Customization

All Pretty objects' properties have default values, but you can freely
change them.

#### Pretty Cell

##### Grouped tables

You can change the cell's appearance as follows:

- cell's shadow (border will be disabled when the shadow is enabled).
- cell's background color or gradient.
- cell's border color (border will be disabled when the shadow is enabled).
- cell's corner radius.
- cell's separator.
- cell's selection gradient.

##### Plain tables

You can change the cell's appearance as follows:

- cell's background color or gradient.
- cell's separator.
- cell's selection gradient.

#### Pretty Navigation Bar

 You can change the navigation bar appearance as follows:
 
 - shadow opacity
 - gradient start color
 - gradient end color
 - top line volor
 - bottom line color


#### Pretty Tab Bar

 You can change the tab bar appearance as follows:
 
 - gradient start color
 - gradient end color
 - separator line volor

## Performance

Everything is drawn using Core Graphics, so you can expect a nice 
performance. Particular attention has been paid to non opaque areas,
trying to reduce them as much as possible.

![](https://github.com/vicpenap/PrettyKit/raw/master/Screenshots/blended_layers.png)

## Current status

This framework is currently under active development. It is compatible 
with iOS 4.0 or higher.

## F.A.Q.

**Q. I'm stuck with this error: [UINavigationBar setTopLineColor:]: unrecognized selector sent to instance 0x6c5dd50**

A. Make sure the navigation bar is an instance of PrettyNavigationBar. There are two possibilities:

- Interface Builder

If you're building your interface with Interface Builder, select the navigationBar, go to the Identity inspector and change the class to `PrettyNavigationBar`.

- Programmatically

If you're creating the NavigationController programmatically, create a subclass of `UINavigationController`, override `initWithRootViewController` (or the constructors you want), and add this line:
		
	[self setValue:[[[PrettyNavigationBar alloc] init] autorelease] forKeyPath:@"navigationBar"];

Take into account that this approach is a bit hackish, so it might be a reason for Apple to reject your app. That shouldn't happen, though.

Also take a look at [this stack overflow thread](http://stackoverflow.com/questions/1869331/set-programmatically-a-custom-subclass-of-uinavigationbar-in-uinavigationcontrol), where other approaches are shown.

**Q. Is there a way to use the same PrettyNavigationBar customization in the entire app?**

A. There is, indeed. You can either create a subclass or a category on PrettyNavigationBar, and override the properties you want to change. 

For example, if you want to have a red navigationBar, you can create a `RedNavigationBar` subclass of `PrettyNavigationBar`, and override the properties `topLineColor`, `gradientStartColor`, `gradientEndColor`, `bottomLineColor` and `tintColor`. Then, wherever you want to use the navigation bar, add an `#import "RedNavigationBar.h"` at the top of the code.


## Contribution

Please, please contribute with this project! Fork it, improve it and make 
me a pull request.

## Changelog

- 2012/06/03: Created a UITableView category to add a shortcut to dropping 
the top and bottom shadows.
- 2012/05/25: Fixed a bug with cell shadow and borders.
- 2012/04/30: Added PrettyNavigationBar round corners.
- 2012/04/26: New widget PrettyToolbar
- 2012/04/12 (v0.1.0): Initial release
