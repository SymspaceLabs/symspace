//
//  UIFitRoomLeftSideMenuView.m
//  TryOn-ObjectiveC
//
//  Created by Oleg Kalashnik on 15.06.2024.
//  Copyright © 2024 unity. All rights reserved.
//

#import "UIFitRoomLeftSideMenuView.h"

@implementation UIFitRoomLeftSideMenuView

@synthesize isInsideCategory = _isInsideCategory;
@synthesize delegate = _delegate;

- (void)setIsInsideCategory:(bool)isInsideCategory
{
    _isInsideCategory = isInsideCategory;
    [self updateState];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _isInsideCategory = false;
        [self initButtons];
        [self updateState];
    }
    return self;
}

- (void)initButtons
{
    int y = 0;
    int x = 0;
    int width = self.bounds.size.width;
    int height = width;
    int space = 20;
    
    self.categoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.categoryButton.frame = CGRectMake(x, y, width, height);
    [self.categoryButton setImage:[UIImage imageNamed:@"btn_category"] forState:UIControlStateNormal];
    [self.categoryButton addTarget:self action:@selector(categoryButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.categoryButton];
    y += (height + space);
    self.activeCategoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.activeCategoryButton.frame = CGRectMake(x, y, width, height);
    [self.activeCategoryButton setImage:[UIImage imageNamed:@"btn_category_0"] forState:UIControlStateNormal];
    [self.activeCategoryButton addTarget:self action:@selector(activeCategoryButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.activeCategoryButton];
    y += (height + space);
    self.colorButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.colorButton.frame = CGRectMake(x, y, width, height);
    [self.colorButton setImage:[UIImage imageNamed:@"btn_color"] forState:UIControlStateNormal];
    [self.colorButton addTarget:self action:@selector(colorButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.colorButton];
}

- (void)updateState
{
    if(_isInsideCategory)
    {
        int y = 0;
        int x = 0;
        int width = self.bounds.size.width;
        int height = width;
        int space = 20;
        self.categoryButton.frame = CGRectMake(x, y, width, height);
        y += (height + space);
        self.activeCategoryButton.frame = CGRectMake(x, y, width, height);
        [self.activeCategoryButton setHidden:false];
        y += (height + space);
        self.colorButton.frame = CGRectMake(x, y, width, height);
        [self.colorButton setHidden:false];
    }
    else
    {
        int x = 0;
        int width = self.bounds.size.width;
        int height = width;
        int y = self.bounds.size.height * 0.5f - height * 0.5f;
        self.categoryButton.frame = CGRectMake(x, y, width, height);
        [self.activeCategoryButton setHidden:true];
        [self.colorButton setHidden:true];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self updateState];
}

- (void)categoryButtonAction
{
    if(_delegate)
    {
        [_delegate menuButtonPressed];
    }
}

- (void)activeCategoryButtonAction
{
    if(_delegate)
    {
        [_delegate activeCategoryPressed];
    }
}

- (void)colorButtonAction
{
    if(_delegate)
    {
        [_delegate colorButtonPressed];
    }
}

- (void)setActiveCategoryImage:(UIImage*)image
{
    [self.activeCategoryButton setImage:image forState:UIControlStateNormal];
}
/*
 
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
