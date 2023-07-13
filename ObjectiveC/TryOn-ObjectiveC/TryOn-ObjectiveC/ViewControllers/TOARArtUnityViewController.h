//
//  TOARArtUnityViewController.h
//  TryOn-ObjectiveC
//
//  Created by Oleg Kalashnik on 08.02.2022.
//  Copyright © 2022 unity. All rights reserved.
//

#import "TOBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TOARArtUnityViewController : TOBaseViewController

@property(nonatomic, assign)NSInteger artIndex;
@property(nonatomic, weak)IBOutlet UIButton *closeButton;
@property(nonatomic, weak)IBOutlet UIButton *shareButton;

@end

NS_ASSUME_NONNULL_END
