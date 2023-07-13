//
//  TOArtCollectionViewCell.m
//  TryOn-ObjectiveC
//
//  Created by Oleg Kalashnik on 04.02.2022.
//  Copyright © 2022 unity. All rights reserved.
//

#import "TOArtCollectionViewCell.h"

@implementation TOArtCollectionViewCell

-(void)setIsLocked:(bool)isLocked
{
    _isLocked = isLocked;
    [_shadowView setHidden:!_isLocked];
}

@end
