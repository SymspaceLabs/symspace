//
//  UIMenuButton.m
//  TryOn-ObjectiveC
//
//  Created by Oleg Kalashnik on 04.06.2024.
//  Copyright © 2024 unity. All rights reserved.
//

#import "UIMenuButton.h"

@implementation UIMenuButton

@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _content = [[UIView alloc] initWithFrame:frame];
        _content.backgroundColor = [UIColor clearColor];
        [self addSubview:_content];
        self.backgroundColor = [UIColor clearColor];
        _isActive = false;
        _bgImage = [[UIImageView alloc] initWithFrame:_content.bounds];
        [_bgImage setContentMode:UIViewContentModeScaleAspectFit];
       [_content addSubview:_bgImage];
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setFrame:_content.bounds];
        [_button addTarget:self
                    action:@selector(press)
          forControlEvents:UIControlEventTouchUpInside];
       [_content addSubview:_button];
        [self updateState];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
   // [_content setFrame:self.bounds];
    [_bgImage setFrame:_content.bounds];
    [_button setFrame:_content.bounds];
}

- (void)press
{
    if(_delegate != NULL)
        [_delegate buttonPressed:self];
}

- (void)setSelected:(bool)isSelected
{
    _isActive = isSelected;
    [self updateState];
}

- (void)updateState
{
    //_bgImage.alpha = 0;
    [_bgImage setHidden:!_isActive];
    /*
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.25f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    _bgImage.alpha = 1.0f;
    [UIView commitAnimations];
     */
}

- (void)setBackgroundImage:(UIImage *)image
{
    [_bgImage setImage:image];
}

- (void)setButtonImage:(UIImage *)image
{
    [_button setImage:image forState:UIControlStateNormal];
}

- (void)setScale:(float)scale withAnim:(bool)isAnim
{
    CGAffineTransform scaleTrans  = CGAffineTransformMakeScale(scale, scale);
    
    if(isAnim)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.25f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        _content.transform = scaleTrans;
        [UIView commitAnimations];
    }
    else
    {
        _content.transform = scaleTrans;
    }
}
@end
