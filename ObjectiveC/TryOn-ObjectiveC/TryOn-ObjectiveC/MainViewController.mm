#import <UIKit/UIKit.h>

#include <UnityFramework/UnityFramework.h>
#include <UnityFramework/NativeCallProxy.h>
#import "TOProtocols.h"
#import "TOBaseViewController.h"
#import "TONavigationController.h"
#import "UIScrollMenuView.h"
#import "UIMenuButton.h"
#import "UIFitRoomLeftSideMenuView.h"

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

struct ARRoomUi {
public:
    UIView * bottomUI;
    UIFitRoomLeftSideMenuView *leftSideUi;
    UIButton *cartButton;
    UIButton *addToCartButton;
    UIScrollMenuView *scrollMenu;
    
    
};

struct ARVisualsUi {
public:
    UIFitRoomLeftSideMenuView *leftSideUi;
    UIButton *switchCameraButton;
    UIButton *addToCartButton;
    UIScrollMenuView *scrollMenu;
};


@interface AppDelegate : UIResponder<UIApplicationDelegate, UnityFrameworkListener, NativeCallsProtocol, UITabBarControllerDelegate, UITabBarDelegate, TOTabBarProtocol, UIScrollMenuDelegate, UIFitRoomLeftSideMenuDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) UIButton *showUnityOffButton;
@property (nonatomic, strong) UIButton *btnSendMsg;
@property (nonatomic, strong) UINavigationController *navVC;
@property (nonatomic, strong) UIButton *unloadBtn;
@property (nonatomic, strong) UIButton *quitBtn;
@property (nonatomic, strong) TOTabBarController *viewController;
@property (nonatomic, assign) NSInteger selectedTabIndex;
@property (nonatomic, strong) UIViewController *unityViewController;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSNumber *activeCategory;
@property (nonatomic, strong) NSNumber *activeItem;
@property (nonatomic, assign) struct ARRoomUi arRoomUI;
@property (nonatomic, assign) struct ARVisualsUi arVisualsUI;
@property (nonatomic, assign) bool isSelectColor;


@property UnityFramework* ufw;
@property bool didQuit;

- (bool)initUnity;
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
    
    self.isSelectColor = false;
    self.activeCategory = @-1;
    self.activeItem = @0;
    
    NSDictionary * clothes = @{ @"icon"     : [UIImage imageNamed:@"btn_category_0"],
                                @"background" : [UIImage imageNamed:@"bg_circle"],
                                @"name" : @"Clothes",
                                @"id" : @1,
                                @"items" : @[
                                    @{
                                        @"icon": [UIImage imageNamed:@"tshirt0"],
                                        @"background" : [UIImage imageNamed:@"bg_circle"],
                                        @"colors": @[
                                            @{
                                               @"name":@"blue",
                                               @"icon":[UIImage imageNamed:@"img_color_blue"],
                                               @"background" : [UIImage imageNamed:@"bg_circle"],
                                               @"code" : @1,
                                           },
                                            @{
                                               @"name":@"Mint",
                                               @"icon":[UIImage imageNamed:@"img_color_mint"],
                                               @"background" : [UIImage imageNamed:@"bg_circle"],
                                               @"code" : @0,
                                           },
                                            @{
                                               @"name":@"black",
                                               @"icon":[UIImage imageNamed:@"img_color_black"],
                                               @"background" : [UIImage imageNamed:@"bg_circle"],
                                               @"code" : @2,
                                           }
                                           ]
                                    
                                    }
                                ],
                              };
    
    NSDictionary * accessoris = @{ @"icon"     : [UIImage imageNamed:@"btn_category_1"],
                                 @"background" : [UIImage imageNamed:@"bg_circle"],
                                 @"name" : @"Accessories",
                                 @"id" : @2,
                                 @"items" : @[
                                       @{
                                           @"icon": [UIImage imageNamed:@"img_bag"],
                                           @"background" : [UIImage imageNamed:@"bg_circle"],
                                           @"colors": @[
                                            @{
                                               @"name":@"blue",
                                               @"icon":[UIImage imageNamed:@"img_color_blue"],
                                               @"background" : [UIImage imageNamed:@"bg_circle"],
                                               @"code" : @1,
                                           }
                                           ]
                                       
                                       }
                                   ],
                              };
    
    NSDictionary * furniture = @{ @"icon"     : [UIImage imageNamed:@"btn_category_2"],
                                 @"background" : [UIImage imageNamed:@"bg_circle"],
                                 @"name" : @"Furniture",
                                 @"id" : @3,
                                  @"items" : @[
                                      @{
                                          @"icon": [UIImage imageNamed:@"img_desk"],
                                          @"background" : [UIImage imageNamed:@"bg_circle"],
                                          @"colors": @[
                                              @{
                                                 @"name":@"blue",
                                                 @"icon":[UIImage imageNamed:@"img_color_white"],
                                                 @"background" : [UIImage imageNamed:@"bg_circle"],
                                                 @"code" : @1,
                                             }
                                             ]
                                      
                                      }
                                  ],
                              };
    
    self.categories = @[clothes, accessoris, furniture];
    
    return YES;
}

- (bool)initUnity
{
    if([self unityIsInitialized]) {
        showAlert(@"Unity already initialized", @"Unload Unity first");
        return false;
    }
    if([self didQuit]) {
        showAlert(@"Unity cannot be initialized after quit", @"Use unload instead");
        return false;
    }
    
    [self setUfw: UnityFrameworkLoad()];
    // Set UnityFramework target for Unity-iPhone/Data folder to make Data part of a UnityFramework.framework and uncomment call to setDataBundleId
    // ODR is not supported in this case, ( if you need embedded and ODR you need to copy data )
    [[self ufw] setDataBundleId: "com.unity3d.framework"];
    [[self ufw] registerFrameworkListener: self];
    [NSClassFromString(@"FrameworkLibAPI") registerAPIforNativeCalls:self];
    [[self ufw] appController].quitHandler = ^(){ NSLog(@"###AppController.quitHandler called"); [[self ufw] unregisterFrameworkListener: self];
        [self setUfw: nil];
        [self showHostMainWindow:@""]; };
    
    [[self ufw] runEmbeddedWithArgc: gArgc argv: gArgv appLaunchOpts: appLaunchOpts];
    
    return true;
}

- (void)addTabbarMenu
{
    NSInteger selectedIndex = self.viewController.selectedIndex;
    UITabBar *tabBar = [[UITabBar alloc] initWithFrame:CGRectMake(self.viewController.tabBar.frame.origin.x, self.viewController.tabBar.frame.origin.y, self.viewController.tabBar.frame.size.width, self.viewController.tabBar.frame.size.height)];
    [tabBar setTag:20];
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
    [view addSubview:tabBar];
}

- (bool)isInsideCatagory
{
    return ([self.activeCategory intValue] >= 0)? true: false;
}

- (void)addARRoomUI
{
    auto view = [[[self ufw] appController] rootView];
    int tabBarHeight = [view viewWithTag:20].frame.size.height;
    int tabBarWidth = [view viewWithTag:20].frame.size.width;
    int widthSideMenu = 44;
    int xSideMenu = 16;
    int space = 20;
    int ySideMenu = (view.frame.size.height - widthSideMenu - tabBarHeight) / 2;
    int height = widthSideMenu * 3 + space * 2;
    self.activeCategory = @-1;
    self.isSelectColor = false;
    
    if(!self.arRoomUI.leftSideUi)
    {
        ARRoomUi ui = self.arRoomUI;
        ui.leftSideUi = [[UIFitRoomLeftSideMenuView alloc] initWithFrame:CGRectMake(xSideMenu, ySideMenu, widthSideMenu, height)];
        [ui.leftSideUi setTag:111];
        ui.leftSideUi.isInsideCategory = [self isInsideCatagory];
        ui.leftSideUi.delegate = self;
        self.arRoomUI = ui;
        [view addSubview:self.arRoomUI.leftSideUi];
    }
    else
    {
        self.arRoomUI.leftSideUi.frame = CGRectMake(xSideMenu, ySideMenu, widthSideMenu, height);
        [self.arRoomUI.leftSideUi setHidden:false];
        [view bringSubviewToFront:self.arRoomUI.leftSideUi];
    }
    
    
    if(!self.arRoomUI.cartButton)
    {
        ARRoomUi ui = self.arRoomUI;
        ui.cartButton = [UIButton buttonWithType:UIButtonTypeCustom];
        ui.cartButton.frame = CGRectMake(325, 49, 34, 34);
        [ui.cartButton setImage:[UIImage imageNamed:@"btn_cart"] forState:UIControlStateNormal];
        [ui.cartButton setHidden:false];
        self.arRoomUI = ui;
        [view addSubview:self.arRoomUI.cartButton];
    }
    else
    {
        self.arRoomUI.cartButton.frame = CGRectMake(325, 49, 34, 34);
        [self.arRoomUI.cartButton setHidden:false];
    }
    
    
    int bottomFitRoomUIWidth = view.bounds.size.width;
    int bottomFitRoomUIHeight = 138;
    int bottomFitRoomUIY = view.bounds.size.height - tabBarHeight - bottomFitRoomUIHeight;
    
    if(!self.arRoomUI.bottomUI)
    {
        ARRoomUi ui = self.arRoomUI;
        ui.bottomUI = [[UIView alloc] initWithFrame:CGRectMake(0, bottomFitRoomUIY, bottomFitRoomUIWidth, bottomFitRoomUIHeight)];
        ui.bottomUI.backgroundColor = [UIColor clearColor];
        
        int menuY = 0;
        int menuHeight = 72;
        ui.scrollMenu = [self categoriesMenu:CGRectMake(0, menuY, ui.bottomUI.bounds.size.width, menuHeight)];
        [ui.scrollMenu update];
        [ui.bottomUI addSubview:ui.scrollMenu];
        
        int cartButtonWidth = ui.bottomUI.bounds.size.width - 16 * 2;
        int cartButtonHeight = 44;
        int cartButtonY = ui.bottomUI.bounds.size.height - cartButtonHeight - 16;
        
        ui.addToCartButton = [UIButton buttonWithType:UIButtonTypeCustom];
        ui.addToCartButton.frame = CGRectMake(16, cartButtonY, cartButtonWidth, cartButtonHeight);
        ui.addToCartButton.tag = 21;
        [ui.addToCartButton setImage:[UIImage imageNamed:@"btn_addcart_2"] forState:UIControlStateDisabled];
        [ui.addToCartButton setImage:[UIImage imageNamed:@"btn_addcart_1"] forState:UIControlStateNormal];
        [ui.bottomUI addSubview:ui.addToCartButton];
        [ui.bottomUI setHidden:false];
        self.arRoomUI = ui;
        [view addSubview:self.arRoomUI.bottomUI];
    }
    else
    {
        self.arRoomUI.bottomUI.frame = CGRectMake(0, bottomFitRoomUIY, bottomFitRoomUIWidth, bottomFitRoomUIHeight);
        [self.arRoomUI.bottomUI setHidden:false];
        [view bringSubviewToFront:self.arRoomUI.bottomUI];
    }
    
    if([self isInsideCatagory])
    {
        self.arRoomUI.addToCartButton.enabled = true;
    }
    else
    {
        self.arRoomUI.addToCartButton.enabled = false;
    }
}

- (void)addARVisualsUI
{
    
}

- (UIScrollMenuView*)categoriesMenu:(CGRect)frame
{
    if(self.arRoomUI.scrollMenu)
    {
        [self.arRoomUI.scrollMenu setHidden:false];
    }
    else
    {
        ARRoomUi ui = self.arRoomUI;
        
        ui.scrollMenu = [[UIScrollMenuView alloc] initWithFrame:frame];
        ui.scrollMenu.delegateCustom = self;
        self.arRoomUI = ui;
    }
    
    return self.arRoomUI.scrollMenu;
}

- (void)hideArRoomUI
{
    if(self.arRoomUI.leftSideUi)
    {
        [self.arRoomUI.leftSideUi setHidden:true];
    }
    
    if(self.arRoomUI.cartButton)
    {
        [self.arRoomUI.cartButton setHidden:true];
    }
    
    if(self.arRoomUI.bottomUI)
    {
        [self.arRoomUI.bottomUI setHidden:true];
    }
}


- (void)initArtUnityScene
{
    bool unityIntResult = [self initUnity];
    
    [self hideArRoomUI];
    
    if(unityIntResult)
    {
        NSLog(@"###Unity art did init");
    }
    else
    {
        NSLog(@"###ERROR art Unity didn't init");
    }
}

- (void)initVisualsUnityScene
{
    bool unityIntResult = [self initUnity];
    
    [self hideArRoomUI];
    
    if(unityIntResult)
    {
        NSLog(@"###Unity visual did init");
        [self addTabbarMenu];
    }
    else
    {
        NSLog(@"###ERROR Unity visual didn't init");
    }
    
    [self changeUnityScene:@"ARVisuals"];
}

- (void)initFittingRoomUnityScene
{
    bool unityIntResult = [self initUnity];
    
    if(unityIntResult)
    {
        NSLog(@"###Unity fitting room did init");
        [self addTabbarMenu];
    }
    else
    {
        NSLog(@"###ERROR Unity fitting room didn't init");
    }
    
    [self addARRoomUI];
    [self changeUnityScene:@"ARFittingRoom"];
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

- (void)quitUnity
{
    if(![self unityIsInitialized]) {
        showAlert(@"Unity is not initialized", @"Initialize Unity first");
    } else {
        [UnityFrameworkLoad() quitApplication:0];
    }
}

- (void)hideUnity
{
    if([self unityIsInitialized]) {
        [[self ufw] unloadApplication];
        [[self ufw] unregisterFrameworkListener: self];
        [self setUfw: nil];
        [self showHostMainWindow:@""];
    }
}

- (void)changeUnityScene:(NSString*)scene
{
    [[self ufw] sendMessageToGOWithName: "SceneManager" functionName: "LoadScene" message:[scene UTF8String]];
}

- (void)changeUnitySceneColor:(NSString*)colorCode
{
    [[self ufw] sendMessageToGOWithName: "SceneManager" functionName: "SwitchColor" message:[colorCode UTF8String]];
}


- (void)unityDidUnload:(NSNotification*)notification
{
    NSLog(@"###unityDidUnload");
    
    [[self ufw] unregisterFrameworkListener: self];
    [self setUfw: nil];
    [self showHostMainWindow:@""];
}

- (void)unityDidQuit:(NSNotification*)notification
{
    NSLog(@"###unityDidQuit");
    
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
    
    if(tabBarController.selectedIndex == 1)
    {
        [self initFittingRoomUnityScene];
    }
    else if(tabBarController.selectedIndex == 2)
    {
        [self initVisualsUnityScene];
    }
    else
    {
        [self hideUnity];
    }
}

#pragma  mark - UITabBarDelegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    self.selectedTabIndex = item.tag;
    
    if(item.tag != 1 && item.tag != 2)
    {
        self.viewController.selectedIndex = (int)item.tag;
        [self hideUnity];
    }
    else if(item.tag == 1)
    {
        [self initFittingRoomUnityScene];
    }
    else if(item.tag == 2)
    {
        [self initVisualsUnityScene];
    }
}

#pragma  mark - TOTabBarProtocol

- (void)sendArtIndex:(NSString*)art
{
    [[self ufw] sendMessageToGOWithName: "AR Session Origin" functionName: "SetActiveIndex" message:[art UTF8String]];
}


- (void)showArtUnityScene:(NSString*)art viewController:(UIViewController*)vc closeButton:(UIButton*)closeButton shareButton:(UIButton*)shareButton
{
    [self initUnity];
    [self changeUnityScene:@"ARArts"];
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
    _unityViewController = vc;
    auto view = [[[self ufw] appController] rootView];
    [view addSubview:close];
    [view addSubview:share];
    [self sendArtIndex:art];
}

 - (void)closeArtUnity
{
    NSLog(@"AppController.quitHandler called"); [[self ufw] unregisterFrameworkListener: self];
    [self hideUnity];
    [_unityViewController dismissViewControllerAnimated:true completion:^{
        
    }];
}

-(void)shareArtUnity
{
    
}

#pragma mark - UIScrollMenuDelegate

- (UIMenuButton*)buttonAtIndex:(NSUInteger)index
{
    UIMenuButton *button = NULL;
    
    if([self isInsideCatagory])
    {
        if(self.isSelectColor)
        {
            NSDictionary *colorData = [[[[[self.categories objectAtIndex:self.activeCategory.intValue] objectForKey:@"items"] objectAtIndex:self.activeItem.intValue] objectForKey:@"colors"] objectAtIndex:index];
            button = [[UIMenuButton alloc] initWithFrame:CGRectMake(0, 0, self.arRoomUI.scrollMenu.bounds.size.height, self.arRoomUI.scrollMenu.bounds.size.height)];
            [button setButtonImage:[colorData objectForKey:@"icon"]];
            [button setBackgroundImage:[colorData objectForKey:@"background"]];
        }
        else
        {
            NSDictionary *itemData = [[[self.categories objectAtIndex:self.activeCategory.intValue] objectForKey:@"items"] objectAtIndex:index];
            button = [[UIMenuButton alloc] initWithFrame:CGRectMake(0, 0, self.arRoomUI.scrollMenu.bounds.size.height, self.arRoomUI.scrollMenu.bounds.size.height)];
            [button setButtonImage:[itemData objectForKey:@"icon"]];
            [button setBackgroundImage:[itemData objectForKey:@"background"]];
        }
    }
    else
    {
        NSDictionary *categoryData = [self.categories objectAtIndex:index];
        button = [[UIMenuButton alloc] initWithFrame:CGRectMake(0, 0, self.arRoomUI.scrollMenu.bounds.size.height, self.arRoomUI.scrollMenu.bounds.size.height)];
        [button setButtonImage:[categoryData objectForKey:@"icon"]];
        [button setBackgroundImage:[categoryData objectForKey:@"background"]];
    }
    
    
    return button;
}

- (NSInteger)buttonsCount
{
    if([self isInsideCatagory])
    {
        if(self.isSelectColor)
        {
            return [[[[[self.categories objectAtIndex:self.activeCategory.intValue] objectForKey:@"items"] objectAtIndex:self.activeItem.intValue] objectForKey:@"colors"] count];
        }
        else
        {
            return [[[self.categories objectAtIndex:self.activeCategory.intValue] objectForKey:@"items"] count];
        }
    }
    else
    {
        return [self.categories count];
    }
}

- (void)buttonsPressedAtIndex:(NSInteger)index
{
    if([self isInsideCatagory]) return;
    
    NSLog(@"buttonsPressedAtIndex: %li", (long)index);
    self.activeCategory = [NSNumber numberWithInteger:index];
    
    if(self.arRoomUI.leftSideUi)
    {
        self.arRoomUI.leftSideUi.isInsideCategory = [self isInsideCatagory];
    }
    
    [self.arRoomUI.scrollMenu update];
    
    switch (index) {
        case 1:
            [self changeUnityScene:@"ARAccessorice"];
            break;
            
        case 2:
            [self changeUnityScene:@"ARFurniture"];
            break;
            
        default:
            [self changeUnityScene:@"ARFittingRoom"];
            break;
    }
}

- (void)buttonsScrollToIndex:(NSInteger)index
{
    if([self isInsideCatagory] && self.isSelectColor)
    {
        [self changeUnitySceneColor:[NSString stringWithFormat:@"%li", index]];
    }
}

#pragma mark - UIFitRoomLeftSideMenuDelegate

- (void)colorButtonPressed
{
    self.isSelectColor = !self.isSelectColor;
    [self.arRoomUI.scrollMenu update];
}

- (void)menuButtonPressed
{
    if(self.arRoomUI.leftSideUi)
    {
        if(self.arRoomUI.leftSideUi.isInsideCategory)
        {
            self.activeCategory = @-1;
        }
        
        self.arRoomUI.leftSideUi.isInsideCategory = [self isInsideCatagory];
        
        if(self.arRoomUI.addToCartButton)
        {
            [self.arRoomUI.addToCartButton setEnabled:[self isInsideCatagory]];
        }
        
        [self.arRoomUI.scrollMenu update];
    }
}

- (void)activeCategoryPressed
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
