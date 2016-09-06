//
//  AppDelegate.m
//  UI(新华字典)
//
//  Created by Ibokan2 on 16/7/18.
//  Copyright © 2016年 ibokan. All rights reserved.
//

#import "AppDelegate.h"
#import <iflyMSC/IFlySpeechUtility.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <WXApi.h>
@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize startImageView;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //发音
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=5796bd48"];
    [IFlySpeechUtility createUtility:initString];
    
    //分享
    [ShareSDK registerApp:@"1585fc4e36d70" activePlatforms:@[@(SSDKPlatformTypeQQ),@(SSDKPlatformTypeWechat)] onImport:^(SSDKPlatformType platformType) {
        switch (platformType) {
            case SSDKPlatformTypeQQ:{
                [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
            }
                break;
            case SSDKPlatformTypeWechat:{
                [ShareSDKConnector connectWeChat:[WXApi class]];
            }
            default:
                break;
        }
    } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
        switch (platformType) {
            case SSDKPlatformTypeQQ:{
                [appInfo SSDKSetupQQByAppId:@"123456789" appKey:@"2423532123" authType:SSDKAuthTypeBoth];
            }
                break;
            case SSDKPlatformTypeWechat:{
                [appInfo SSDKSetupWeChatByAppId:@"987654321" appSecret:@"423246342412"];
            }
            default:
                break;
        }
    }];
    
    [self.window makeKeyAndVisible];
    startImageView = [[UIImageView alloc]initWithFrame:self.window.frame];
    [startImageView setImage:[UIImage imageNamed:@"startup-interface"]];
    [self.window addSubview:startImageView];
    [self.window bringSubviewToFront:startImageView];
    [self performSelector:@selector(animation) withObject:nil afterDelay:0.2];
    
    return YES;
}
-(void)animation{
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
       
    } completion:^(BOOL finished) {
        [NSThread sleepForTimeInterval:1];
        [startImageView removeFromSuperview];
    }];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
