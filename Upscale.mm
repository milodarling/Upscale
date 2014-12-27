#import <Preferences/Preferences.h>
#import <objc/runtime.h>

#define DEBUG

#ifdef DEBUG
#define DebugLog(s, ...) \
NSLog(@"[Upscale] >> %@", \
[NSString stringWithFormat:(s), ##__VA_ARGS__] \
)
#else
#define DebugLog(s, ...)
#endif
#define SYSTEM_TINT [UIColor colorWithRed:0 green:0.478431 blue:1 alpha:1]

@interface PSMagnifyController : PSListController <UIScrollViewDelegate, UIWebViewDelegate>

+(void)commitMagnifyMode:(id)mode;
@end
@interface PSMagnifyMode : NSObject <NSCopying>

+(id)magnifyModeWithSize:(CGSize)arg1 name:(id)arg2 localizedName:(id)arg3 isZoomed:(BOOL)arg4 ;
@end
@interface UpscaleListController: PSEditableListController <UIAlertViewDelegate> {
//    UIColor *systemTint;
}
@end

@implementation UpscaleListController
int height;
int width;
NSDictionary *prefs;
extern NSString* PSDeletionActionKey;
- (id)specifiers {
	if(_specifiers == nil) {
        DebugLog(@"Making Initial Specifiers");
        PSSpecifier* spec4 = [PSSpecifier preferenceSpecifierNamed:@"iPhone 4/4s"
                                                            target:self
                                                               set:NULL
                                                               get:NULL
                                                            detail:Nil
                                                              cell:PSButtonCell
                                                              edit:Nil];
        spec4->action = @selector(go_4);
        //systemTint = spec4.textLabel.textColor;
        PSSpecifier* spec5 = [PSSpecifier preferenceSpecifierNamed:@"iPhone 5/5s"
                                                            target:self
                                                               set:NULL
                                                               get:NULL
                                                            detail:Nil
                                                              cell:PSButtonCell
                                                              edit:Nil];
        spec5->action = @selector(go_5);
        PSSpecifier* spec6 = [PSSpecifier preferenceSpecifierNamed:@"iPhone 6"
                                                            target:self
                                                               set:NULL
                                                               get:NULL
                                                            detail:Nil
                                                              cell:PSButtonCell
                                                              edit:Nil];
        spec6->action = @selector(go_6);
        PSSpecifier* spec6plus = [PSSpecifier preferenceSpecifierNamed:@"iPhone 6+"
                                                            target:self
                                                               set:NULL
                                                               get:NULL
                                                            detail:Nil
                                                              cell:PSButtonCell
                                                              edit:Nil];
        spec6plus->action = @selector(go_6plus);
        PSSpecifier *groupCell = [PSSpecifier groupSpecifierWithHeader:@"Custom (use at your own risk)" footer:@"Saving the custom resolution will create a new button for you to use"];
        [groupCell setProperty:@"PSGroupCell" forKey:@"cell"];
        PSTextFieldSpecifier* customX = [PSTextFieldSpecifier preferenceSpecifierNamed:@""
                                                                target:self
                                                                   set:@selector(setXValue:)
                                                                   get:@selector(getXValue:)
                                                                detail:Nil
                                                                  cell:PSEditTextCell
                                                                  edit:Nil];
        [customX setPlaceholder:@"X"];
        customX->keyboardType = UIKeyboardTypeNumberPad;
        PSTextFieldSpecifier* customY = [PSTextFieldSpecifier preferenceSpecifierNamed:@""
                                                                                target:self
                                                                                   set:@selector(setYValue:)
                                                                                   get:@selector(getYValue:)
                                                                                detail:Nil
                                                                                  cell:PSEditTextCell
                                                                                  edit:Nil];
        [customY setPlaceholder:@"Y"];
        customY->keyboardType = UIKeyboardTypeNumberPad;
        PSSpecifier* specCustomTry = [PSSpecifier preferenceSpecifierNamed:@"Apply Custom Resolution"
                                                                target:self
                                                                   set:NULL
                                                                   get:NULL
                                                                detail:Nil
                                                                  cell:PSButtonCell
                                                                  edit:Nil];
        specCustomTry->action = @selector(go);
        PSSpecifier* specCustomSave = [PSSpecifier preferenceSpecifierNamed:@"Save Custom Resolution"
                                                                    target:self
                                                                       set:NULL
                                                                       get:NULL
                                                                    detail:Nil
                                                                      cell:PSButtonCell
                                                                      edit:Nil];
        specCustomSave->action = @selector(createNew);
        DebugLog(@"Making specifiers");
        NSMutableArray *specifiers = [NSMutableArray arrayWithObjects:spec4, spec5, spec6, spec6plus, groupCell, customX, customY, specCustomTry, specCustomSave, nil];
        DebugLog(@"Getting appID");
        CFStringRef appID = CFSTR("com.bd452.upscale");
        DebugLog(@"Getting keyList");
        CFArrayRef keyList = CFPreferencesCopyKeyList(appID, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
        if (keyList) {
            DebugLog(@"KeyList exists, doing stuff");
            prefs = (NSDictionary *)CFPreferencesCopyMultiple(keyList, appID, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
            int numCustoms = [prefs[@"count"] intValue];
            int index = 4;
            for (int i=1; i<=numCustoms; i++) {
                DebugLog(@"We're in the for loop");
                SEL newMethod = NSSelectorFromString([NSString stringWithFormat:@"custom%d", i]);
                class_addMethod([self class], newMethod, (IMP) customGo, "v@:");
                NSString *name = [NSString stringWithFormat:@"%@ x %@", [prefs objectForKey:[NSString stringWithFormat:@"custom%d-x", i]], [prefs objectForKey:[NSString stringWithFormat:@"custom%d-y", i]]];
                PSSpecifier* specCustomNew = [PSSpecifier preferenceSpecifierNamed:name
                                                                        target:self
                                                                           set:NULL
                                                                           get:NULL
                                                                        detail:Nil
                                                                          cell:PSLinkCell
                                                                          edit:Nil];
                specCustomNew->action = newMethod;
                [specCustomNew setProperty:NSClassFromString(@"UpscaleButton") forKey:@"cellClass"];
                [specCustomNew setProperty:NSStringFromSelector(@selector(removedSpecifier:)) forKey:PSDeletionActionKey];
                [specifiers insertObject:specCustomNew atIndex:index];
                index++;
            }
            DebugLog(@"Done with keyList, releasing");
            CFRelease(keyList);
        }
        DebugLog(@"Creating _specifiers");
        _specifiers = [[NSArray arrayWithArray:specifiers] retain];
        DebugLog(@"Donezo");
	}
	return _specifiers;
}
-(void)go_4 {
    width = 640;
    height = 960;
    [self showAlert];
}
-(void)go_5 {
    width = 640;
    height = 1136;
    [self showAlert];
}
-(void)go_6 {
    width = 750;
    height = 1334;
    [self showAlert];
}
-(void)go_6plus {
    width = 850;
    height = 1511;
    [self showAlert];
}
-(void)showAlert {
    [self.view endEditing:YES];
    if (width == 0 || height == 0 || !height || !width) {
        UIAlertView* alert_Dialog = [[UIAlertView alloc] initWithTitle:@"Upscale"
                                                               message:@"Please set both values (and not to 0)"
                                                              delegate:nil
                                                     cancelButtonTitle:@"Ok"
                                                     otherButtonTitles:nil];
        [alert_Dialog show];
        [alert_Dialog release];
        return;
    }
    UIAlertView* alert_Dialog = [[UIAlertView alloc] initWithTitle:@"Upscale"
                                                           message:[NSString stringWithFormat:@"Resolution will be set to %d x %d", width, height]
                                                          delegate:self
                                                 cancelButtonTitle:@"Cancel"
                                                 otherButtonTitles:nil];
    [alert_Dialog addButtonWithTitle:@"Proceed"];
    [alert_Dialog show];
    [alert_Dialog release];
    
}
-(void)setYValue:(id)value {
    height = [value intValue];
}
-(id)getYValue {
    return height ? [NSNumber numberWithInt:height] : nil;
}
-(void)setXValue:(id)value {
    width = [value intValue];
}
-(id)getXValue {
    return width ? [NSNumber numberWithInt:width] : nil;
}
-(void)go {
    [self showAlert];
}

void customGo(id self, SEL _cmd) {
    NSString *methodName = NSStringFromSelector(_cmd);
    width = [[prefs objectForKey:[NSString stringWithFormat:@"%@-x", methodName]] intValue];
    height = [[prefs objectForKey:[NSString stringWithFormat:@"%@-y", methodName]] intValue];
    [self showAlert];
}

-(void)createNew {
    [self.view endEditing:YES];
    if (width == 0 || height == 0 || !height || !width) {
        UIAlertView* alert_Dialog = [[UIAlertView alloc] initWithTitle:@"Upscale"
                                                               message:@"Please set both values (and not to 0)"
                                                              delegate:nil
                                                     cancelButtonTitle:@"Ok"
                                                     otherButtonTitles:nil];
        [alert_Dialog show];
        [alert_Dialog release];
        return;
    }
    int count = [[prefs objectForKey:@"count"] intValue];
    count++;
    NSString *customVal = [NSString stringWithFormat:@"custom%d-x", count];
    CFPreferencesSetAppValue ( (__bridge CFStringRef)customVal, (__bridge CFNumberRef)[NSNumber numberWithInt:width], CFSTR("com.bd452.upscale") );
    customVal = [NSString stringWithFormat:@"custom%d-y", count];
    CFPreferencesSetAppValue ( (__bridge CFStringRef)customVal, (__bridge CFNumberRef)[NSNumber numberWithInt:height], CFSTR("com.bd452.upscale") );
    CFPreferencesSetAppValue ( CFSTR("count"), (__bridge CFNumberRef)[NSNumber numberWithInt:count], CFSTR("com.bd452.upscale") );
    height = 0;
    width = 0;
    [self reloadSpecifiers];
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        CGSize size = CGSizeMake(width, height);
        [PSMagnifyController commitMagnifyMode:[PSMagnifyMode magnifyModeWithSize:size name:@"" localizedName:@"" isZoomed:1]];
    }
}

-(void)removedSpecifier:(PSSpecifier*)specifier{
    int count = [[prefs objectForKey:@"count"] intValue];
    NSString *name = NSStringFromSelector(specifier->action);
    int number;
    number = [[name substringFromIndex:6] intValue];
    for (int i=number+1; i<=count; i++) {
        NSString *customVal = [NSString stringWithFormat:@"custom%d-x", i];
        int resNumber = [[prefs objectForKey:customVal] intValue];
        customVal = [NSString stringWithFormat:@"custom%d-x", i-1];
        CFPreferencesSetAppValue ( (__bridge CFStringRef)customVal, (__bridge CFNumberRef)[NSNumber numberWithInt:resNumber], CFSTR("com.bd452.upscale") );
        customVal = [NSString stringWithFormat:@"custom%d-y", i];
        resNumber = [[prefs objectForKey:customVal] intValue];
        customVal = [NSString stringWithFormat:@"custom%d-y", i-1];
        CFPreferencesSetAppValue ( (__bridge CFStringRef)customVal, (__bridge CFNumberRef)[NSNumber numberWithInt:resNumber], CFSTR("com.bd452.upscale") );
    }
    count--;
    CFPreferencesSetAppValue ( CFSTR("count"), (__bridge CFNumberRef)[NSNumber numberWithInt:count], CFSTR("com.bd452.upscale") );
    CFStringRef appID = CFSTR("com.bd452.upscale");
    DebugLog(@"Getting keyList");
    CFArrayRef keyList = CFPreferencesCopyKeyList(appID, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
    DebugLog(@"KeyList exists, doing stuff");
    prefs = (NSDictionary *)CFPreferencesCopyMultiple(keyList, appID, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
    CFRelease(keyList);
}
@end

@interface UpscaleButton : PSTableCell {
    
}
@end

@implementation UpscaleButton

-(void)layoutSubviews {
    [super layoutSubviews];
    static UIColor *systemTintColor;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIView* view = [[UIView alloc] init];
        systemTintColor = view.tintColor;
    });
    self.textLabel.textColor = systemTintColor;
    self.accessoryType = UITableViewCellAccessoryNone;
}

@end

// vim:ft=objc
