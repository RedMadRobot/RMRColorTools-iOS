# RMRColorTools-iOS

( https://github.com/horseshoe7/RMRColorTools-iOS )

**RMRHexColorGen** is a command line tool that *parses a human-readable text file* containing Color definitions (names and hex values) and can *generate useful code for your Xcode projects* in one of **4 output flavours**:

1.  An Objective-C category on UIColor
2.  A Swift Extension on UIColor
3.  A Swift enum with static members, so your colors are grouped.
4.  (Typical Option) An Assets catalog with Color Sets  (Introduced in Xcode 9), along with an enum which derives named UIColor objects from the assets catalog. 

(5.  In Addition it will also generate an .xml file that can be used by Android projects.   See 'format' below)

It’s very important to have all your project resources organized and consistent, thus you won’t have to spend hours of time changing a single wide-spread color in your app.

The addition of Colors to Assets catalogs in Xcode 9 provided a great solution to the issue of a common color palette being used and reduced the numbers of headaches associated with being completely in sync with the design team, and for the mostpart, you may see this source code as a bit dated and/or obsolete.  We would not entirely disagree.  That said, Named Colors via Assets catalogs are a feature that is only available to you if your deployment target OS is iOS 11 or later.

So you may be working on a mature project with some existing workflows and pipelines that you don't want to disrupt.  In this case, you may find some use out of this tool.  Especially if you use a design tool where you can export color definitions to a text file or your do not want to overburden your developers with boring but necessary (and time-consuming!) tasks.

RMRColorTools-iOS enables an efficient workflow where:

- Designers can define and name colors
- Designers can edit and update the color palettes without programmer support
- Developers don't need to concern themselves with the actual values of colors.  They just need to know "this element needs that color name", they set it once and it stays updated (assuming you use the new Colors Assets catalogs)
- You don't need to go fishing through Asset catalogs to find out which of your color assets matches a given HEX value provided by the designer.
- Designers can specify colors with esoteric names, and developers can create aliases to them for their intended purpose, e.g. primaryTextColor

## Other Features

### Color Aliases 
Using simple markup (outlined below), a designer can define a color by giving its `RGB` or `RGBA` hex value then providing it a name.  It also allows for *aliases* to be defined, which are just references to previously defined colors.  This makes sense for example if you name your colors in your color palette (such as `MyAppBlue`), then create aliases to those colors based on purpose (such as `MainAppTint` which references `MyAppBlue` )

### Support for Dark Mode on iOS

Sometimes you need 2 representations for one color, depending on whether the iOS device is in Dark Mode.  This is also possible with `RMRHexColorGen`.  The general syntax below is given in Usage.  

### Android Support
You can also specify an android output format, and it will generate an .xml file with the color definitions ready to be used in an Android project.

### Command line tool for Easy Build Automation

Because **RMRHexColorGen** is a command line tool, you can set up a Run Script in your Xcode build that will keep your generated colors up-to-date.

## Usage

### Create a Colors List

Small utility that generates UIColor category from colors list:
```
// MyAppColors.palette
//
// Lines beginning with // are ignored by the parser, so you can add comments for your team members.
//
// Or you can make comments be generated into the output file by adding them after the color name (see below)


// Define an opaque color in RRGGBB Hex Format. e.g. #FFEE24.   (# character is required!)
#RRGGBB ColorName Add some comments that should be generated into the output file.

// Or in RRGGBBAA format if you need transparency
#RRGGBBAA ColorNameTranslucent

// Perhaps you want to support Dark Mode.  Just add a second hex value after the first one.  The first is always 'Any' and the second is for dark mode.
#FF0000 #AA0000 Red You can see that the second value is darker than the first


// Create an Alias to an already defined color.  You can see the pattern: $ExistingColorname AliasName.  ($ character required!)
$ColorName MainTitleText

// You should ideally define your colors at the top, and all aliases below them!

```


### Important Change:  

This branch of the original project uses the RRGGBBAA Format.  Previous versions used AARRGGBB, which doesn't seem "conventional" to me, so please me aware of that!


### Command Line Tool Usage:
```
RMRHexColorGen [-i <path>] [-o <path>] [-p <prefix>] [-clr] [-f <format>] [-n <name>]
```

### Options:
```
-i <path>    Path to txt colors list file

-o <path>    Output files at <path>

-n <name>    The Name you want to use when generating.  It gets used differently depending on output format:

output format: objc; used in the output filename:  UIColor+<name>.h/m and in category name UIColor(<name>)
output format: swift-extension; used in the output filename: UIColor+<name>.swift
output format: swift-enum; used in the output filename: <name>.swift

output format: assets;  used in the output filename: <name>.swift and in assets catalog name: <name>.xcassets
                        and in the generated enum in <name>.swift
                        internal enum <name> { ... }
                        
output format: android;  used in the output filename: <name>.xml
            
-f <format>  The desired output format.  Valid values for <format> are: objc, swift-enum, swift-extension, assets, android

-p <prefix>  Use <prefix> as the class prefix in the generated code.  Only relevant for format: objc and swift

-osx         Generate for the OSX platform (i.e. NSColor instead of UIColor).  Ignored for Android format. 

-h           Print this help and exit
```


## Xcode Build Integration Examples

### Create Run Script

In your Xcode Project's Build Phases, add a "Run Script" that executes before "Compile Sources":

```bash
# Xcode Run Script
# SRCROOT is the location of your Xcode Project file
# You wrap the line below in quotes so that it correctly resolves paths 
# that have spaces in their name.

cd "${SRCROOT}/ColorTools"
echo "${SRCROOT}/ColorTools"


# We assume you have the following in the ColorTools folder:
# - The RMRHexColorGen command line tool (i.e. when you build this project in Xcode, 
#    in the Navigator's Products folder, right click to show in Finder, then copy that 
#    file into ColorTools folder)
# - A Colors definition file, explained above.  It's in text format and you can call 
#    it whatever you want.  We tend to prefer the .palette file extension.  So call it AppColors.palette
#
# Then it might make sense to reference a bash script that you manage separately, or you can put that 
# inline in this Run Script.  This script should also reside in the ColorTools folder (or wherever.  
# We're making this easier on the Noobs)

./update_colors.sh
```

Then we have various flavours on `update_colors.sh`  (below)

#### Objective-C

Output in Objective-C format to the ColorTools folder with a prefix of `ma` while also generating an Xcode color palette and installing it.   No name was specified, so it defaults to `MyAppColors`

```bash
./RMRHexColorGen -i AppColors.palette -o ./ -f objc -p my
echo "Updated Colors."
```

#### Swift

Output to a swift extension on UIColor with a prefix of `my` (i.e. `UIColor.myMainTitleText`, `UIColor.myOffWhite`, etc.) to a different folder relative to ColorTools:

```bash
./RMRHexColorGen -i AppColors.palette -o ./../Generated/Colors -f swift-extension -p my -n AppColors
echo "Updated Colors."
```

#### Asset Catalogs

Generate an Assets catalog that is only filled with Color Sets.  Also creates a Swift file so you can use these exact same colors in code with type safety.  `UIColor(named: String)` can be brittle if a string changes so we should avoid that.

```bash
./RMRHexColorGen -i AppColors.palette -o ./../Generated -f assets -n ColorAssets
echo "Updated Colors."
```



## Contact
* oconnor.freelance@gmail.com

(Original Authors)
* http://www.redmadrobot.com
* rc@redmadrobot.com



## License

RMRColorTools-iOS is available under the MIT license.
