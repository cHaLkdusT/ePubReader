//
//  AppDelegate.m
//  ePubReader
//
//  Created by Julius Lundang on 2/16/15.
//  Copyright (c) 2015 Cambridge University Press. All rights reserved.
//

#import "AppDelegate.h"
#import "PageViewController.h"
#import "ZipArchive.h"

@interface AppDelegate () <UISplitViewControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
    UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
    navigationController.topViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem;
    splitViewController.delegate = self;
    splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModePrimaryHidden;
    
//    [AppDelegate unzipAndSaveFile:@"Geography_9"];
    return YES;
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

#pragma mark - Split view

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    if ([secondaryViewController isKindOfClass:[UINavigationController class]] && [[(UINavigationController *)secondaryViewController topViewController] isKindOfClass:[PageViewController class]]) {
        // Return YES to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
        return YES;
    } else {
        return NO;
    }
}


/**
 Unzip epub and save to application's document directory
 @param epubName Name of EPUB file
 @returns void
 */
+ (void)unzipAndSaveFile:(NSString *)epubName
{
    ZipArchive* zipArchive = [[ZipArchive alloc] init];
    if([zipArchive UnzipOpenFile:[[NSBundle mainBundle] pathForResource:epubName ofType:@"epub"]]){
        NSString *strPath = [NSString stringWithFormat:@"%@/UnzippedGeography_9", [self applicationDocumentsDirectory]];
        
        [self deletePreviousFiles:strPath];
        [self unzip:zipArchive path:strPath];
        
        [zipArchive UnzipCloseFile];
    }
}

+ (void)deletePreviousFiles:(NSString *)path
{
    NSFileManager *filemanager = [[NSFileManager alloc] init];
    if ([filemanager fileExistsAtPath:path]) {
        NSError *error;
        
        [filemanager removeItemAtPath:path error:&error];
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        }
    }
    filemanager = nil;
}

+ (void)unzip:(ZipArchive *)zipArchive path:(NSString *)path
{
    if ([zipArchive UnzipFileTo:[NSString stringWithFormat:@"%@/",path] overWrite:YES]) {
        // error handler here
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error"
                                                      message:@"An unknown error occured"
                                                     delegate:self
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
        [alert show];
        alert = nil;
    }
}


/**
 To find the path path to documents directory
 @param nil
 @returns NSString - Returns the path to documents directory
 @exception nil
 */
+ (NSString *)applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
}
@end
