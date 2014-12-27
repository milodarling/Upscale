Upscale
=======

Change your device's resolution!

This is my own version of Upscale by [@bd452](https://github.com/bd452). It changes your device's resolution, and my build allows for the saving of resolutions for future use. I still need to figure out deleting buttons. Maybe tomorrow...

I open-sourced this because I thought it was kind of interesting how I created all of the specifiers at runtime rather than in a plist and then had to make a dynamic number of methods, linked to button cells, at runtime with different values for each method. I ended up using the name of the method as the way to get those values. It's licensed under the MIT lincense, so do whatever you want with it!

To compile it, you may need to explicitly set the instance variables `keyboardType` and `action` as public in your PSSpecifier interface. I know you shouldn't normally just change headers all willy-nilly, but you *can* change these ivars, and you need to mark themas public to appease the compiler. You may also need [PSTextFieldSpecifier.h](http://developer.limneos.net/headers/8.0/Preferences.framework/Headers/PSTextFieldSpecifier.h), as many people's headers may not include them.

Enjoy!
