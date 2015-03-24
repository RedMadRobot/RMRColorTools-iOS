#RMRColorTools-iOS
It’s very important to have all your project resources organized and consistent, thus you won’t have to spend hours of time changing a single wide-spread color in your app.

Working together with our designers, who supply us with handy theme style sheets, we wanted to have a single access point to a list of colors used in the app in order to maintain them all at once.

So we developed a few easy to use utils that help us to keep our code clean and up to date without any overhead.

You may find two targets in the main project: **RMRHexColorGen** and **RMRRefreshColorPanelPlugin**.

**RMRHexColorGen** generates a UIColor class category with all the colors you declare and `.CLR` file with color palette used within the standard OS X Color Panel component in Xcode and other desktop apps.
We’ve faced a non-obvious caveat during our investigation: in order to refresh the list of Color Panel palettes one must restart the app that uses it.

So here’s the **RMRRefreshColorPanelPlugin** comes on stage. 
This plugin simply forces Xcode to refresh its instance of Color Panel after every build.

Thus, in case you’ve updated your color list file — **RMRHexColorGen** will generate a new `.CLR` file AND **RMRRefreshColorPanelPlugin** will refresh Color Panel for you.



##RMRHexColorGen

Small utility that generates UIColor category from colors list:
```
#AARRGGBB ColorName
#AARRGGBB ColorName
#AARRGGBB ColorName
#AARRGGBB ColorName
```

Use `-clr` option to generate and install Color Palette.

###Usage:
```
RMRHexColorGen [-i <path>] [-o <path>] [-p <prefix>] [-clr]
```

###Options:
```
-o <path>    Output files at <path>

-i <path>    Path to txt colors list file

-p <prefix>  Use <prefix> as the class prefix in the generated code

-clr         Use this flag if you need to generate and install CLR file

-h           Print this help and exit
```



##RMRRefreshColorPanelPlugin

Xcode plugin that force Color Panel to reload custom Color Palettes after every build.

###Install

Just clone this repo, run `RMRRefreshColorPanelPlugin` target and restart Xcode.

###Usage

RMRRefreshColorPanelPlugin will refresh Color Panel after every build end.
Select `Reload color lists` from the `Edit` menu to force refresh.

##Contact

* http://www.redmadrobot.com
* rc@redmadrobot.com



##License

RMRColorTools-iOS is available under the MIT license.
