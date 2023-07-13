//
//  TOARArtViewController.h
//  TryOn-ObjectiveC
//
//  Created by Oleg Kalashnik on 03.02.2022.
//  Copyright © 2022 unity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TOBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TOARArtViewController : TOBaseViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate>
{
    NSMutableArray *artList;
}
@property(nonatomic, weak)IBOutlet UICollectionView *collectionView;


@end

NS_ASSUME_NONNULL_END
