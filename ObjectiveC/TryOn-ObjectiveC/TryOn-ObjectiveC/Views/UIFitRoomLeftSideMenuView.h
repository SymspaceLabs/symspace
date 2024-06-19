//
//  UIFitRoomLeftSideMenuView.h
//  TryOn-ObjectiveC
//
//  Created by Oleg Kalashnik on 15.06.2024.
//  Copyright © 2024 unity. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol UIFitRoomLeftSideMenuDelegate
@required
- (void)colorButtonPressed;
- (void)menuButtonPressed;
- (void)activeCategoryPressed;
@end

@interface UIFitRoomLeftSideMenuView : UIView
{
    bool _isInsideCategory;
}

@property (nonatomic, assign) bool isInsideCategory;
@property (nonatomic, weak) id <UIFitRoomLeftSideMenuDelegate> delegate;
@property (nonatomic, strong) UIButton *categoryButton;
@property (nonatomic, strong) UIButton *activeCategoryButton;
@property (nonatomic, strong) UIButton *colorButton;

- (void)setActiveCategoryImage:(UIImage*)image;

@end

NS_ASSUME_NONNULL_END
