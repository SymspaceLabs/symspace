//
//  UIMenuButton.h
//  TryOn-ObjectiveC
//
//  Created by Oleg Kalashnik on 04.06.2024.
//  Copyright © 2024 unity. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class UIMenuButton;

@protocol UIMenuButtonlDelegate
@required
- (void)buttonPressed:(UIMenuButton*)button;
@end

@interface UIMenuButton : UIView
{
    UIView *_content;
    UIButton *_button;
    UIImageView *_bgImage;
    bool _isActive;
}

@property (nonatomic, weak) id <UIMenuButtonlDelegate> delegate;

- (void)setBackgroundImage:(UIImage*)image;
- (void)setButtonImage:(UIImage*)image;
- (void)press;
- (void)setSelected:(bool)isSelected;
- (void)setScale:(float)scale withAnim:(bool)isAnim;

@end

NS_ASSUME_NONNULL_END
