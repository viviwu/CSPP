//
//  AppDelegate.m
//  CSInvest
//
//  Created by vivi wu on 2018/3/8.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import "AppDelegate.h"
//#import "CSFTabBarController.h"

#import "VENTouchLock.h"
#import "SampleLockSplashViewController.h"

#import <Bugly/Bugly.h>
#define BUGLY_APP_ID @"29bb454154"

#import "IFlyMSC/IFlyMSC.h"
#import "Definition.h"

@interface AppDelegate ()<BuglyDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Init the Bugly sdk
//    [self setupBugly];
//    NSLog(@"Bugly Version:%@",[Bugly sdkVersion]);
    
    [self setUpTTSiFly];
    
    [self setUpRootViewController];
    
    [[VENTouchLock sharedInstance] setKeychainService:@"testService2"
                                      keychainAccount:@"testAccount2"
                                        touchIDReason:@"Scan your fingerprint to use the app."
                                 passcodeAttemptLimit:5
                            splashViewControllerClass:[SampleLockSplashViewController class]];
    
    // Override point for customization after application launch.
    return YES;
}

-(void)setUpRootViewController{
    /*
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    CSFTabBarController * tabCtr=[[CSFTabBarController alloc]init];
    self.window.rootViewController = tabCtr;
    
    self.window.backgroundColor = [UIColor whiteColor];
     */
    [self.window makeKeyAndVisible];
}

- (UIInterfaceOrientationMask )application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if (self.allowRotation) {
        return UIInterfaceOrientationMaskAll;
    }
    if (self.settingModel.recording) {
        return UIInterfaceOrientationMaskLandscapeRight;
    }
    return UIInterfaceOrientationMaskPortrait;
}

- (SettingModel *)settingModel {
    if (!_settingModel) {
        _settingModel = [SettingModel defaultSetting];
    }
    
#if TARGET_IPHONE_SIMULATOR
#define WITH_FREE_RDP           NOT_BUILD_IN    // 模拟器不支持RDP
    _settingModel.videoDecoderMode = MPMovieVideoDecoderMode_Software;
#elif TARGET_OS_IPHONE
#define WITH_FREE_RDP           BUILD_IN        // 支持RDP
    _settingModel.videoDecoderMode = MPMovieVideoDecoderMode_Hardware;
#endif
    
    return _settingModel;
}

-(void)setUpTTSiFly{
    //Set log level
    [IFlySetting setLogFile:LVL_ALL];
    
    //Set whether to output log messages in Xcode console
    [IFlySetting showLogcat:YES];
    
    //Set the local storage path of SDK
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    [IFlySetting setLogFilePath:cachePath];
    
    //Set APPID
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",APPID_VALUE];
    
    //Configure and initialize iflytek services.(This interface must been invoked in application:didFinishLaunchingWithOptions:)
    [IFlySpeechUtility createUtility:initString];
}

- (void)setupBugly {
    // Get the default config
    BuglyConfig * config = [[BuglyConfig alloc] init];
    
    // Open the debug mode to print the sdk log message.
    // Default value is NO, please DISABLE it in your RELEASE version.
    //#if DEBUG
    config.debugMode = YES;
    //#endif
    
    // Open the customized log record and report, BuglyLogLevelWarn will report Warn, Error log message.
    // Default value is BuglyLogLevelSilent that means DISABLE it.
    // You could change the value according to you need.
    //    config.reportLogLevel = BuglyLogLevelWarn;
    
    // Open the STUCK scene data in MAIN thread record and report.
    // Default value is NO
    config.blockMonitorEnable = YES;
    
    // Set the STUCK THRESHOLD time, when STUCK time > THRESHOLD it will record an event and report data when the app launched next time.
    // Default value is 3.5 second.
    config.blockMonitorTimeout = 1.5;
    
    // Set the app channel to deployment
    config.channel = @"Bugly";
    
    config.delegate = self;
    
    config.consolelogEnable = NO;
    config.viewControllerTrackingEnable = NO;
    
    // NOTE:Required
    // Start the Bugly sdk with APP_ID and your config
    [Bugly startWithAppId:BUGLY_APP_ID
#if DEBUG
        developmentDevice:YES
#endif
                   config:config];
    
    // Set the customizd tag thats config in your APP registerd on the  bugly.qq.com
    // [Bugly setTag:1799];
    
    [Bugly setUserIdentifier:[NSString stringWithFormat:@"User: %@", [UIDevice currentDevice].name]];
    
    [Bugly setUserValue:[NSProcessInfo processInfo].processName forKey:@"Process"];
    
    // NOTE: This is only TEST code for BuglyLog , please UNCOMMENT it in your code.
    [self performSelectorInBackground:@selector(testLogOnBackground) withObject:nil];
}

/**
 *    @brief TEST method for BuglyLog
 */
- (void)testLogOnBackground {
    int cnt = 0;
    while (1) {
        cnt++;
        
        switch (cnt % 5) {
            case 0:
                BLYLogError(@"Test Log Print %d", cnt);
                break;
            case 4:
                BLYLogWarn(@"Test Log Print %d", cnt);
                break;
            case 3:
                BLYLogInfo(@"Test Log Print %d", cnt);
                BLYLogv(BuglyLogLevelWarn, @"BLLogv: Test", NULL);
                break;
            case 2:
                BLYLogDebug(@"Test Log Print %d", cnt);
                BLYLog(BuglyLogLevelError, @"BLLog : %@", @"Test BLLog");
                break;
            case 1:
            default:
                BLYLogVerbose(@"Test Log Print %d", cnt);
                break;
        }
        
        // print log interval 1 sec.
        sleep(1);
    }
}

#pragma mark - BuglyDelegate
- (NSString *)attachmentForException:(NSException *)exception {
    NSLog(@"(%@:%d) %s %@",[[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __PRETTY_FUNCTION__,exception);
    
    return @"This is an attachment";
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end

