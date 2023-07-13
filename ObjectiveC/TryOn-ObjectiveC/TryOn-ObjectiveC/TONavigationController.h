//
//  TONavigationController.h
//  TryOn-ObjectiveC
//
//  Created by Oleg Kalashnik on 03.02.2022.
//  Copyright © 2022 unity. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "TOProtocols.h"

#ifndef TONavigationController_h
#define TONavigationController_h
@interface TONavigationController : UINavigationController

@property (nonatomic, strong) id<TOTabBarProtocol> applicationDelegate;
@end

#endif /* TONavigationController_h */
