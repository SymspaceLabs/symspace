//
//  UIScrollMenuView.h
//  TryOn-ObjectiveC
//
//  Created by Oleg Kalashnik on 07.06.2024.
//  Copyright © 2024 unity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIMenuButton.h"

NS_ASSUME_NONNULL_BEGIN
@class UIMenuButton;

@protocol UIScrollMenuDelegate
@required
- (UIMenuButton*)buttonAtIndex:(NSUInteger)index;
- (NSInteger)buttonsCount;
- (void)buttonsPressedAtIndex:(NSInteger)index;
- (void)buttonsScrollToIndex:(NSInteger)index;
@end

@interface UIScrollMenuView : UIScrollView<UIScrollViewDelegate, UIMenuButtonlDelegate>
{
    NSMutableArray *_buttons;
    NSInteger _activeIndex;
}

@property (nonatomic, weak) id <UIScrollMenuDelegate> delegateCustom;

- (void)addButton:(UIMenuButton*)button;
- (void)update;
@end

NS_ASSUME_NONNULL_END
