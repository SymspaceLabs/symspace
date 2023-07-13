//
//  TOBaseViewController.h
//  TryOn-ObjectiveC
//
//  Created by Oleg Kalashnik on 07.02.2022.
//  Copyright © 2022 unity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TOProtocols.h"

NS_ASSUME_NONNULL_BEGIN

@interface TOBaseViewController : UIViewController

@property(nonatomic,weak)IBOutlet id<TOTabBarProtocol> tabBarDelegate;
@end

NS_ASSUME_NONNULL_END
