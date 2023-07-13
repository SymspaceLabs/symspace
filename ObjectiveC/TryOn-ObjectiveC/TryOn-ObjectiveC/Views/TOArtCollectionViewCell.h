//
//  TOArtCollectionViewCell.h
//  TryOn-ObjectiveC
//
//  Created by Oleg Kalashnik on 04.02.2022.
//  Copyright © 2022 unity. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TOArtCollectionViewCell : UICollectionViewCell

@property(nonatomic, weak) IBOutlet UIImageView *icon;
@property(nonatomic, weak) IBOutlet UIView *shadowView;
@property(nonatomic, weak) IBOutlet UILabel *title;
@property(nonatomic, weak) IBOutlet UILabel *author;
@property(nonatomic, assign) bool isLocked;

@end

NS_ASSUME_NONNULL_END
