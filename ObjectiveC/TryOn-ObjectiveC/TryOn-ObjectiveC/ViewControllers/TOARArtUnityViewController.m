//
//  TOARArtUnityViewController.m
//  TryOn-ObjectiveC
//
//  Created by Oleg Kalashnik on 08.02.2022.
//  Copyright © 2022 unity. All rights reserved.
//

#import "TOARArtUnityViewController.h"


@interface TOARArtUnityViewController ()

@end

@implementation TOARArtUnityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"AR Art";
    
    [_closeButton.titleLabel removeFromSuperview];
    [_shareButton.titleLabel removeFromSuperview];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSString *art = [NSString stringWithFormat:@"%ld",_artIndex];
    [self.tabBarDelegate  showArtUnityScene:art viewController:self closeButton:self.closeButton shareButton:self.shareButton];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
