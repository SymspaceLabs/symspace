//
//  UIScrollMenuView.m
//  TryOn-ObjectiveC
//
//  Created by Oleg Kalashnik on 07.06.2024.
//  Copyright © 2024 unity. All rights reserved.
//

#import "UIScrollMenuView.h"
#import "UIMenuButton.h"
#import "CoreGraphics/CoreGraphics.h"

@implementation UIScrollMenuView
@synthesize delegateCustom = _delegateCustom;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _activeIndex = 0;
        _buttons = [[NSMutableArray alloc] init];
        self.delegate = self;
        self.backgroundColor = [UIColor clearColor];
        [self setShowsHorizontalScrollIndicator:false];
        [self setShowsVerticalScrollIndicator:false];
        [self updateActiveIndex];
    }
    return self;
}

- (void)update
{
    [self removeAllButtons];
    
    NSInteger count = 0;
    _activeIndex = 0;
    [self setContentSize:CGSizeMake(0, 0)];
    
    if(self.delegateCustom != NULL)
        count = [_delegateCustom buttonsCount];
    
    for(NSInteger i = 0; i < count; i++)
    {
        if(self.delegateCustom != NULL)
        {
            UIMenuButton *button = [_delegateCustom buttonAtIndex:i];
            [self addButton:button];
        }
    }
}

- (void)addButton:(UIMenuButton*)button
{
    [self  addSubview:button];
    button.delegate = self;
    [_buttons addObject:button];
    [self updateButtonsLayout];
    [self updateActiveIndex];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)updateButtonsLayout
{
    float y = 0;
    float space = 5;
    float width = self.frame.size.height;
    float height = self.frame.size.height;
    float x = 0;
    
    for(NSInteger i = 0; i < [_buttons count]; i++)
    {
        x = self.frame.size.width * 0.5f - width * 0.5f + (width * i + space * i);
        
        UIMenuButton *button =[_buttons objectAtIndex:i];
        [button setFrame:CGRectMake(x, y, width, height)];
    
        if(_activeIndex == i)
        {
            [button setScale:1.0f withAnim:false];
        }
        else
        {
            [button setScale:0.75f withAnim:false];
        }
    }
    
    [self setContentSize:CGSizeMake(width * [_buttons count] + space * [_buttons count] + self.frame.size.width - width, self.frame.size.height)];
}

- (void)removeAllButtons
{
    for(NSInteger i = 0; i < [_buttons count]; i++)
    {
        UIMenuButton *button =[_buttons objectAtIndex:i];
        [button removeFromSuperview];
    }
    
    [_buttons removeAllObjects];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (float)distanceToPoint:(CGPoint)point0 toPoint:(CGPoint)point1
{
    return sqrt(pow(point1.x - point0.x, 2) + pow(point1.y - point0.y, 2));
}

- (CGPoint)activeButtonPoint
{
    if(_activeIndex < 0 || _activeIndex >= [_buttons count]) return CGPointMake(0, 0);
    
    UIMenuButton *button =[_buttons objectAtIndex:_activeIndex];
    float x = button.frame.origin.x + button.frame.size.width * 0.5f;
    float y = button.frame.origin.y + button.frame.size.height * 0.5f;
    
    return CGPointMake(x, y);
}

- (void)updateActiveIndex
{
    CGPoint center = CGPointMake(self.frame.size.width * 0.5f, self.frame.size.height * 0.5f);
    
    for(NSInteger i = 0; i < [_buttons count]; i++)
    {
        UIMenuButton *button =[_buttons objectAtIndex:i];
        CGPoint buttonCenter = CGPointMake(button.frame.origin.x + button.frame.size.width * 0.5f, button.frame.origin.y + button.frame.size.height * 0.5f) ;
        buttonCenter.x -= self.contentOffset.x;
        buttonCenter.y -= self.contentOffset.y;
        float distance = [self distanceToPoint:buttonCenter toPoint:center];
        
        if(distance <= button.frame.size.width * 0.5f)
        {
            _activeIndex = i;
            break;
        }
    }
    
    for(NSInteger i = 0; i < [_buttons count]; i++)
    {
        UIMenuButton *button =[_buttons objectAtIndex:i];
        
        if(_activeIndex == i)
        {
            [button setScale:1.0f withAnim:true];
            [button setSelected:true];
        }
        else
        {
            [button setScale:0.75f withAnim:true];
            [button setSelected:false];
        }
    }
}

- (void)scrollToIndex:(NSInteger)index withAnim:(BOOL)isAnim
{
    UIMenuButton *button =[_buttons objectAtIndex:_activeIndex];
    CGPoint buttonCenter = CGPointMake(button.frame.origin.x + button.frame.size.width * 0.5f, button.frame.origin.y + button.frame.size.height * 0.5f);
    [self setContentOffset:CGPointMake(buttonCenter.x - self.bounds.size.width * 0.5f, 0) animated:isAnim];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self updateActiveIndex];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self updateActiveIndex];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self updateActiveIndex];
    
    if(!decelerate)
    {
        [self scrollToIndex:_activeIndex withAnim:true];
    }
    
    if(_delegateCustom)
    {
        [_delegateCustom buttonsScrollToIndex:_activeIndex];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [self updateActiveIndex];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self updateActiveIndex];
    
    [self scrollToIndex:_activeIndex withAnim:true];
    
    if(_delegateCustom)
    {
        [_delegateCustom buttonsScrollToIndex:_activeIndex];
    }
}

#pragma mark - UIMenuButtonlDelegate

- (void)buttonPressed:(UIMenuButton*)button
{
    if(_delegateCustom)
    {
        NSInteger index = [_buttons indexOfObject:button];
        
        if(index != _activeIndex)
        {
            _activeIndex = index;
            [self scrollToIndex:_activeIndex withAnim:true];
        }
        
        [_delegateCustom buttonsPressedAtIndex:index];
    }
}
@end
