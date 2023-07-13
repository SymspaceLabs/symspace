#import <UIKit/UIKit.h>

#include <UnityFramework/UnityFramework.h>
#include <UnityFramework/NativeCallProxy.h>
#import "TOProtocols.h"
#import "TOBaseViewController.h"
#import "TONavigationController.h"

UnityFramework* UnityFrameworkLoad()
{
    NSString* bundlePath = nil;
    bundlePath = [[NSBundle mainBundle] bundlePath];
    bundlePath = [bundlePath stringByAppendingString: @"/Frameworks/UnityFramework.framework"];
    
    NSBundle* bundle = [NSBundle bundleWithPath: bundlePath];
    if ([bundle isLoaded] == false) [bundle load];
    
    UnityFramework* ufw = [bundle.principalClass getInstance];
    if (![ufw appController])
    {
        // unity is not initialized
        [ufw setExecuteHeader: &_mh_execute_header];
    }
    return ufw;
}

void showAlert(NSString* title, NSString* msg) {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:msg                                                         preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    auto delegate = [[UIApplication sharedApplication] delegate];
    [delegate.window.rootViewController presentViewController:alert animated:YES completion:nil];
}
@interface TOTabBarController : UITabBarController 
@end

@interface AppDelegate : UIResponder<UIApplicationDelegate, UnityFrameworkListener, NativeCallsProtocol, UITabBarControllerDelegate, UITabBarDelegate, TOTabBarProtocol>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) UIButton *showUnityOffButton;
@property (nonatomic, strong) UIButton *btnSendMsg;
@property (nonatomic, strong) UINavigationController *navVC;
@property (nonatomic, strong) UIButton *unloadBtn;
@property (nonatomic, strong) UIButton *quitBtn;
@property (nonatomic, strong) TOTabBarController *viewController;
@property (nonatomic, assign) NSInteger selectedTabIndex;
@property (nonatomic, strong) UIViewController *unityViewController;


@property UnityFramework* ufw;
@property bool didQuit;

- (void)initUnity;
- (void)ShowMainView;

- (void)didFinishLaunching:(NSNotification*)notification;
- (void)didBecomeActive:(NSNotification*)notification;
- (void)willResignActive:(NSNotification*)notification;
- (void)didEnterBackground:(NSNotification*)notification;
- (void)willEnterForeground:(NSNotification*)notification;
- (void)willTerminate:(NSNotification*)notification;
- (void)unityDidUnloaded:(NSNotification*)notification;

@end

AppDelegate* hostDelegate = NULL;

// -------------------------------
// -------------------------------
// -------------------------------


@interface TOTabBarController () 
@property (nonatomic, strong) UIButton *unityInitBtn;
@property (nonatomic, strong) UIButton *unpauseBtn;
@property (nonatomic, strong) UIButton *unloadBtn;
@property (nonatomic, strong) UIButton *quitBtn;
@property (nonatomic, strong) id<TOTabBarProtocol> applicationDelegate;

@end

@implementation TOTabBarController
- (void)viewDidLoad
{
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor blueColor];
    
    
    // INIT UNITY
   /* self.unityInitBtn = [UIButton buttonWithType: UIButtonTypeSystem];
    [self.unityInitBtn setTitle: @"Init" forState: UIControlStateNormal];
    self.unityInitBtn.frame = CGRectMake(0, 0, 100, 44);
    self.unityInitBtn.center = CGPointMake(50, 120);
    self.unityInitBtn.backgroundColor = [UIColor greenColor];
    [self.unityInitBtn addTarget: hostDelegate action: @selector(initUnity) forControlEvents: UIControlEventPrimaryActionTriggered];
    [self.view addSubview: self.unityInitBtn];
    
    // SHOW UNITY
    self.unpauseBtn = [UIButton buttonWithType: UIButtonTypeSystem];
    [self.unpauseBtn setTitle: @"Show Unity" forState: UIControlStateNormal];
    self.unpauseBtn.frame = CGRectMake(100, 0, 100, 44);
    self.unpauseBtn.center = CGPointMake(150, 120);
    self.unpauseBtn.backgroundColor = [UIColor lightGrayColor];
    [self.unpauseBtn addTarget: hostDelegate action: @selector(ShowMainView) forControlEvents: UIControlEventPrimaryActionTriggered];
    [self.view addSubview: self.unpauseBtn];
    
    // UNLOAD UNITY
    self.unloadBtn = [UIButton buttonWithType: UIButtonTypeSystem];
    [self.unloadBtn setTitle: @"Unload" forState: UIControlStateNormal];
    self.unloadBtn.frame = CGRectMake(200, 0, 100, 44);
    self.unloadBtn.center = CGPointMake(250, 120);
    self.unloadBtn.backgroundColor = [UIColor redColor];
    [self.unloadBtn addTarget: hostDelegate action: @selector(unloadButtonTouched:) forControlEvents: UIControlEventPrimaryActionTriggered];
    [self.view addSubview: self.unloadBtn];
    
    // QUIT UNITY
    self.quitBtn = [UIButton buttonWithType: UIButtonTypeSystem];
    [self.quitBtn setTitle: @"Quit" forState: UIControlStateNormal];
    self.quitBtn.frame = CGRectMake(300, 0, 100, 44);
    self.quitBtn.center = CGPointMake(250, 170);
    self.quitBtn.backgroundColor = [UIColor redColor];
    [self.quitBtn addTarget: hostDelegate action: @selector(quitButtonTouched:) forControlEvents: UIControlEventPrimaryActionTriggered];
    [self.view addSubview: self.quitBtn];*/
    
    for(NSInteger i =0 ; i < [[self viewControllers] count]; i++)
    {
        TONavigationController *nc = [[self viewControllers] objectAtIndex:i];
        nc.applicationDelegate = _applicationDelegate;
        TOBaseViewController *vc = [[nc viewControllers] objectAtIndex:0];
        vc.tabBarDelegate = _applicationDelegate;
       
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end


// keep arg for unity init from non main
int gArgc = 0;
char** gArgv = nullptr;
NSDictionary* appLaunchOpts;


@implementation AppDelegate

- (bool)unityIsInitialized { return [self ufw] && [[self ufw] appController]; }

- (void)ShowMainView
{
    if(![self unityIsInitialized]) {
        showAlert(@"Unity is not initialized", @"Initialize Unity first");
    } else {
        [[self ufw] showUnityWindow];
    }
}

- (void)showHostMainWindow
{
    [self showHostMainWindow:@""];
}

- (void)showHostMainWindow:(NSString*)color
{
    if([color isEqualToString:@"blue"]) self.viewController.unpauseBtn.backgroundColor = UIColor.blueColor;
    else if([color isEqualToString:@"red"]) self.viewController.unpauseBtn.backgroundColor = UIColor.redColor;
    else if([color isEqualToString:@"yellow"]) self.viewController.unpauseBtn.backgroundColor = UIColor.yellowColor;
    [self.window makeKeyAndVisible];
}

- (void)sendMsgToUnity
{
    [[self ufw] sendMessageToGOWithName: "Cube" functionName: "ChangeColor" message: "yellow"];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    hostDelegate = self;
    appLaunchOpts = launchOptions;
    
    self.window = [[UIWindow alloc] initWithFrame: [UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor redColor];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.viewController = [storyboard instantiateViewControllerWithIdentifier:@"TOTabBarController"];
    self.viewController.delegate = self;
    self.viewController.applicationDelegate = self;
    //ViewController *viewcontroller = [[ViewController alloc] initWithNibName:nil Bundle:nil];
    //self.viewController = [[TOTabBarController alloc] init];
    /*self.navVC = [[UINavigationController alloc] initWithRootViewController: self.viewController];*/
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    [self initUnity];
    
    return YES;
}

- (void)initUnity
{
    if([self unityIsInitialized]) {
        showAlert(@"Unity already initialized", @"Unload Unity first");
        return;
    }
    if([self didQuit]) {
        showAlert(@"Unity cannot be initialized after quit", @"Use unload instead");
        return;
    }
    
    [self setUfw: UnityFrameworkLoad()];
    // Set UnityFramework target for Unity-iPhone/Data folder to make Data part of a UnityFramework.framework and uncomment call to setDataBundleId
    // ODR is not supported in this case, ( if you need embedded and ODR you need to copy data )
    [[self ufw] setDataBundleId: "com.unity3d.framework"];
    [[self ufw] registerFrameworkListener: self];
    [NSClassFromString(@"FrameworkLibAPI") registerAPIforNativeCalls:self];
    [[self ufw] appController].quitHandler = ^(){ NSLog(@"AppController.quitHandler called"); [[self ufw] unregisterFrameworkListener: self];
        [self setUfw: nil];
        [self showHostMainWindow:@""]; };
   // [[self ufw] appController].quitHandler = ^(){ NSLog(@"AppController.quitHandler called"); };
    
    [[self ufw] runEmbeddedWithArgc: gArgc argv: gArgv appLaunchOpts: appLaunchOpts];
    
    // set quit handler to change default behavior of exit app
   
    
    //NSData *tempArchiveView = [NSKeyedArchiver archivedDataWithRootObject:self.viewController.tabBar];
    //UITabBar *tabBar = [NSKeyedUnarchiver unarchiveObjectWithData:tempArchiveView];
   /* NSInteger selectedIndex = self.viewController.selectedIndex;
    UITabBar *tabBar = [[UITabBar alloc] initWithFrame:CGRectMake(self.viewController.tabBar.frame.origin.x, self.viewController.tabBar.frame.origin.y, self.viewController.tabBar.frame.size.width, self.viewController.tabBar.frame.size.height)];
    NSMutableArray *tabBarItems = [[NSMutableArray alloc] init];
    UITabBarItem *tabBarItem0 = [[UITabBarItem alloc] initWithTitle:@"Home" image:[UIImage imageNamed:@"HomeIcon"] tag:0];
    tabBarItem0.selectedImage = [UIImage imageNamed:@"HomeIconSelected"];
    UITabBarItem *tabBarItem1 = [[UITabBarItem alloc] initWithTitle:@"Fitting Room" image:[UIImage imageNamed:@"FittingRoomIcon"] tag:1];
    tabBarItem1.selectedImage = [UIImage imageNamed:@"FittingRoomSelected"];
    UITabBarItem *tabBarItem2 = [[UITabBarItem alloc] initWithTitle:@"AR Visuals" image:[UIImage imageNamed:@"ARVisualsIcon"] tag:2];
    tabBarItem2.selectedImage = [UIImage imageNamed:@"ARVisualsSelected"];
    UITabBarItem *tabBarItem3 = [[UITabBarItem alloc] initWithTitle:@"AR Art" image:[UIImage imageNamed:@"ARArtIcon"] tag:3];
    tabBarItem3.selectedImage = [UIImage imageNamed:@"ARArtSelected"];
    UITabBarItem *tabBarItem4 = [[UITabBarItem alloc] initWithTitle:@"Profile" image:[UIImage imageNamed:@"ProfileIcon"] tag:4];
    tabBarItem4.selectedImage = [UIImage imageNamed:@"ProfileSelected"];
    [tabBarItems addObject:tabBarItem0];
    [tabBarItems addObject:tabBarItem1];
    [tabBarItems addObject:tabBarItem2];
    [tabBarItems addObject:tabBarItem3];
    [tabBarItems addObject:tabBarItem4];
    tabBar.items = tabBarItems;
    tabBar.selectedItem = tabBarItems[selectedIndex];
    //tabBar.delegate=self;
    auto view = [[[self ufw] appController] rootView];
    tabBar.delegate=self;
    tabBar.backgroundColor = [UIColor blackColor];//self.viewController.tabBar.backgroundColor;
    tabBar.barTintColor = [UIColor blackColor];//self.viewController.tabBar.barTintColor;
    tabBar.tintColor = self.viewController.tabBar.tintColor;
    [view addSubview:tabBar];*/
   // [view addSubview:self.viewController.tabBar];
    /* if(self.showUnityOffButton == nil) {
        self.showUnityOffButton = [UIButton buttonWithType: UIButtonTypeSystem];
        [self.showUnityOffButton setTitle: @"Show Main" forState: UIControlStateNormal];
        self.showUnityOffButton.frame = CGRectMake(0, 0, 100, 44);
        self.showUnityOffButton.center = CGPointMake(50, 300);
        self.showUnityOffButton.backgroundColor = [UIColor greenColor];
        [view addSubview: self.showUnityOffButton];
        [self.showUnityOffButton addTarget: self action: @selector(showHostMainWindow) forControlEvents: UIControlEventPrimaryActionTriggered];
        
        self.btnSendMsg = [UIButton buttonWithType: UIButtonTypeSystem];
        [self.btnSendMsg setTitle: @"Send Msg" forState: UIControlStateNormal];
        self.btnSendMsg.frame = CGRectMake(0, 0, 100, 44);
        self.btnSendMsg.center = CGPointMake(150, 300);
        self.btnSendMsg.backgroundColor = [UIColor yellowColor];
        [view addSubview: self.btnSendMsg];
        [self.btnSendMsg addTarget: self action: @selector(sendMsgToUnity) forControlEvents: UIControlEventPrimaryActionTriggered];
        
        // Unload
        self.unloadBtn = [UIButton buttonWithType: UIButtonTypeSystem];
        [self.unloadBtn setTitle: @"Unload" forState: UIControlStateNormal];
        self.unloadBtn.frame = CGRectMake(250, 0, 100, 44);
        self.unloadBtn.center = CGPointMake(250, 300);
        self.unloadBtn.backgroundColor = [UIColor redColor];
        [self.unloadBtn addTarget: self action: @selector(unloadButtonTouched:) forControlEvents: UIControlEventPrimaryActionTriggered];
        [view addSubview: self.unloadBtn];
        
        // Quit
        self.quitBtn = [UIButton buttonWithType: UIButtonTypeSystem];
        [self.quitBtn setTitle: @"Quit" forState: UIControlStateNormal];
        self.quitBtn.frame = CGRectMake(250, 0, 100, 44);
        self.quitBtn.center = CGPointMake(250, 350);
        self.quitBtn.backgroundColor = [UIColor redColor];
        [self.quitBtn addTarget: self action: @selector(quitButtonTouched:) forControlEvents: UIControlEventPrimaryActionTriggered];
        [view addSubview: self.quitBtn];
    }*/
    /*
    UITabBar *tabBar = [[UITabBar alloc] initWithFrame:CGRectMake(0, view.bounds.size.height - 117, view.bounds.size.width, 117)];
    tabBar.delegate=self;   //here you need import the protocol <UITabBarDelegate>
    [view addSubview:tabBar];
    
    NSMutableArray *tabBarItems = [[NSMutableArray alloc] init];

    UITabBarItem *tabBarItem0 = [[UITabBarItem alloc] initWithTitle:@"Home" image:[UIImage imageNamed:@"HomeIcon"] tag:0];
    UITabBarItem *tabBarItem1 = [[UITabBarItem alloc] initWithTitle:@"Fitting Room" image:[UIImage imageNamed:@"FittingRoomIcon"] tag:1];
    UITabBarItem *tabBarItem2 = [[UITabBarItem alloc] initWithTitle:@"AR Visuals" image:[UIImage imageNamed:@"ARVisualsIcon"] tag:2];
    UITabBarItem *tabBarItem3 = [[UITabBarItem alloc] initWithTitle:@"AR Art" image:[UIImage imageNamed:@"ARArtIcon"] tag:3];
    UITabBarItem *tabBarItem4 = [[UITabBarItem alloc] initWithTitle:@"Profile" image:[UIImage imageNamed:@"ProfileIcon"] tag:4];

    [tabBarItems addObject:tabBarItem0];
    [tabBarItems addObject:tabBarItem1];
    [tabBarItems addObject:tabBarItem2];
    [tabBarItems addObject:tabBarItem3];
    [tabBarItems addObject:tabBarItem4];

    tabBar.items = tabBarItems;
    tabBar.selectedItem = [tabBarItems objectAtIndex:3];*/
}

- (void)unloadButtonTouched:(UIButton *)sender
{
    if(![self unityIsInitialized]) {
        showAlert(@"Unity is not initialized", @"Initialize Unity first");
    } else {
        [UnityFrameworkLoad() unloadApplication];
    }
}

- (void)quitButtonTouched:(UIButton *)sender
{
    if(![self unityIsInitialized]) {
        showAlert(@"Unity is not initialized", @"Initialize Unity first");
    } else {
        [UnityFrameworkLoad() quitApplication:0];
    }
}

- (void)unityDidUnload:(NSNotification*)notification
{
    NSLog(@"unityDidUnload called");
    
    [[self ufw] unregisterFrameworkListener: self];
    [self setUfw: nil];
    [self showHostMainWindow:@""];
}

- (void)unityDidQuit:(NSNotification*)notification
{
    NSLog(@"unityDidQuit called");
    
    [[self ufw] unregisterFrameworkListener: self];
    [self setUfw: nil];
    [self setDidQuit:true];
    [self showHostMainWindow:@""];
}

- (void)applicationWillResignActive:(UIApplication *)application { [[[self ufw] appController] applicationWillResignActive: application]; }
- (void)applicationDidEnterBackground:(UIApplication *)application { [[[self ufw] appController] applicationDidEnterBackground: application]; }
- (void)applicationWillEnterForeground:(UIApplication *)application { [[[self ufw] appController] applicationWillEnterForeground: application]; }
- (void)applicationDidBecomeActive:(UIApplication *)application { [[[self ufw] appController] applicationDidBecomeActive: application]; }
- (void)applicationWillTerminate:(UIApplication *)application { [[[self ufw] appController] applicationWillTerminate: application]; }

#pragma  mark - UITabBarControllerDelegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    self.selectedTabIndex = tabBarController.selectedIndex;
    /*if(tabBarController.selectedIndex == 1 || tabBarController.selectedIndex == 2)
    {
        [self initUnity];
    }*/
}

#pragma  mark - UITabBarDelegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    self.selectedTabIndex = item.tag;
   /* if(item.tag == 0 || item.tag == 4)
    {
        NSLog(@"Tag %li", (long)item.tag);
        self.viewController.selectedIndex = self.selectedTabIndex;
       // [_tabBar setSelectedItem:[_tabBar.items objectAtIndex:item.tag]];
        [[self ufw] unregisterFrameworkListener: self];
        [self setUfw: nil];
        [self showHostMainWindow:@""];
        
    }*/
    
}

#pragma  mark - TOTabBarProtocol

- (void)sendArtIndex:(NSString*)art
{
    [[self ufw] sendMessageToGOWithName: "AR Session Origin" functionName: "SetActiveIndex" message:[art UTF8String]];
}


- (void)showArtUnityScene:(NSString*)art viewController:(UIViewController*)vc closeButton:(UIButton*)closeButton shareButton:(UIButton*)shareButton
{
    if([self unityIsInitialized]) {
        showAlert(@"Unity already initialized", @"Unload Unity first");
        return;
    }
    if([self didQuit]) {
        showAlert(@"Unity cannot be initialized after quit", @"Use unload instead");
        return;
    }
    
    [self setUfw: UnityFrameworkLoad()];
    // Set UnityFramework target for Unity-iPhone/Data folder to make Data part of a UnityFramework.framework and uncomment call to setDataBundleId
    // ODR is not supported in this case, ( if you need embedded and ODR you need to copy data )
    [[self ufw] setDataBundleId: "com.unity3d.framework"];
    [[self ufw] registerFrameworkListener: self];
    [NSClassFromString(@"FrameworkLibAPI") registerAPIforNativeCalls:self];
   // [[self ufw] appController].quitHandler = ^(){ NSLog(@"AppController.quitHandler called"); };
    
    [[self ufw] runEmbeddedWithArgc: gArgc argv: gArgv appLaunchOpts: appLaunchOpts];
    
    // set quit handler to change default behavior of exit app
    [[self ufw] appController].quitHandler = ^(){  };
    CGRect closeRect = closeButton.frame;
    CGRect shareRect = shareButton.frame;
    
    UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
    [close addTarget:self
               action:@selector(closeArtUnity)
     forControlEvents:UIControlEventTouchUpInside];
    //[button setTitle:@"" forState:UIControlStateNormal];
    [close setImage:[UIImage imageNamed:@"CloseButtonCircle"] forState:UIControlStateNormal];
    close.frame = closeRect;
    
    [closeButton addTarget:self
               action:@selector(closeArtUnity)
     forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *share = [UIButton buttonWithType:UIButtonTypeCustom];
    [share addTarget:self
               action:@selector(shareArtUnity)
     forControlEvents:UIControlEventTouchUpInside];
    //[button setTitle:@"" forState:UIControlStateNormal];
    [share setImage:[UIImage imageNamed:@"ShareButtonCircle"] forState:UIControlStateNormal];
    share.frame = shareRect;
    
    [closeButton addTarget:self
               action:@selector(closeArtUnity)
     forControlEvents:UIControlEventTouchUpInside];
    //NSData *tempArchiveView = [NSKeyedArchiver archivedDataWithRootObject:nc.navigationBar];
    //UITabBar *navBar = [NSKeyedUnarchiver unarchiveObjectWithData:tempArchiveView];
    //tabBar.delegate=self;
    _unityViewController = vc;
    auto view = [[[self ufw] appController] rootView];
    [view addSubview:close];
    [view addSubview:share];
    [self sendArtIndex:art];
}

 - (void)closeArtUnity
{
    NSLog(@"AppController.quitHandler called"); [[self ufw] unregisterFrameworkListener: self];
        [self setUfw: nil];
        [self showHostMainWindow:@""];
    [_unityViewController dismissViewControllerAnimated:true completion:^{
        
    }];
}

-(void)shareArtUnity
{
    
}

@end


int main(int argc, char* argv[])
{
    gArgc = argc;
    gArgv = argv;
    
    @autoreleasepool
    {
        if (false)
        {
            // run UnityFramework as main app
            id ufw = UnityFrameworkLoad();
            
            // Set UnityFramework target for Unity-iPhone/Data folder to make Data part of a UnityFramework.framework and call to setDataBundleId
            // ODR is not supported in this case, ( if you need embedded and ODR you need to copy data )
            [ufw setDataBundleId: "com.unity3d.framework"];
            [ufw runUIApplicationMainWithArgc: argc argv: argv];
        } else {
            // run host app first and then unity later
            UIApplicationMain(argc, argv, nil, [NSString stringWithUTF8String: "AppDelegate"]);
        }
    }
    
    return 0;
}
