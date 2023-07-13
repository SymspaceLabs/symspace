//
//  TOARArtViewController.m
//  TryOn-ObjectiveC
//
//  Created by Oleg Kalashnik on 03.02.2022.
//  Copyright © 2022 unity. All rights reserved.
//

#import "TOARArtViewController.h"
#import "TOArtCollectionViewCell.h"
#import "TONFTNavigationViewController.h"
#import "TONFTCodeViewController.h"
#import "TOARArtUnityViewController.h"

@interface TOARArtViewController () <TONFTArtProtocol>

@end

@implementation TOARArtViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"AR Art";
    // Do any additional setup after loading the view.
    artList = [[NSMutableArray alloc] init];
    NSMutableDictionary *art0 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[UIImage imageNamed:@"AdamBombSquad"], @"Icon", @"Adam Bomb", @"Title", @"by The Hundreds", @"Author", [NSNumber numberWithBool:false], @"IsLocked", @"qwerty", @"nft", nil];
    NSMutableDictionary *art1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[UIImage imageNamed:@"DarkCloud"], @"Icon", @"Dark Cloud", @"Title", @"by Interfaces", @"Author", [NSNumber numberWithBool:false], @"IsLocked", @"qwertf", @"nft", nil];
    NSMutableDictionary *art2 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[UIImage imageNamed:@"WhiteCloud"], @"Icon", @"White Cloud", @"Title", @"by Interfaces", @"Author", [NSNumber numberWithBool:false], @"IsLocked", @"qwertv", @"nft", nil];
    NSMutableDictionary *art3 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[UIImage imageNamed:@"TranslucentDaftDavid"], @"Icon", @"Translucent Daft David", @"Title", @"by SHADOW", @"Author", [NSNumber numberWithBool:true], @"IsLocked", @"qwertb", @"nft", nil];
    NSMutableDictionary *art4 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[UIImage imageNamed:@"ChromeDaftDavid"], @"Icon", @"Chrome Daft David", @"Title", @"by SHADOW", @"Author", [NSNumber numberWithBool:true], @"IsLocked", @"qwertg", @"nft", nil];
    NSMutableDictionary *art5 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[UIImage imageNamed:@"ObsidianDaftDavid"], @"Icon", @"Obsidian Daft David", @"Title", @"by SHADOW", @"Author", [NSNumber numberWithBool:true], @"IsLocked", @"qwertt", @"nft", nil];
    NSMutableDictionary *art6 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[UIImage imageNamed:@"MarbleDaftDavid"], @"Icon", @"Marble Daft David", @"Title", @"by SHADOW", @"Author", [NSNumber numberWithBool:false], @"IsLocked", @"qwerth", @"nft", nil];
    NSMutableDictionary *art7 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[UIImage imageNamed:@"PlatinumDistortedDavid"], @"Icon", @"Platinum Distorted David", @"Title", @"by SHADOW", @"Author", [NSNumber numberWithBool:false], @"IsLocked", @"qwertn", @"nft", nil];
    NSMutableDictionary *art8 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[UIImage imageNamed:@"ObsidianDistortedDavid"], @"Icon", @"Obsidian Distorted David", @"Title", @"by SHADOW", @"Author", [NSNumber numberWithBool:false], @"IsLocked", @"qwertn", @"nft", nil];
    NSMutableDictionary *art9 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[UIImage imageNamed:@"GoldDistortedDavid"], @"Icon", @"Gold Distorted David", @"Title", @"by SHADOW", @"Author", [NSNumber numberWithBool:false], @"IsLocked", @"qwertm", @"nft", nil];
    
    [artList addObject:art0];
    [artList addObject:art1];
    [artList addObject:art2];
    [artList addObject:art3];
    [artList addObject:art4];
    [artList addObject:art5];
    [artList addObject:art6];
    [artList addObject:art7];
    [artList addObject:art8];
    [artList addObject:art9];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return [artList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //TOArtCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ArtCollectionViewCell" forIndexPath:indexPath];
    TOArtCollectionViewCell *cell = (TOArtCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"ArtCollectionViewCell" forIndexPath:indexPath];

    cell.icon.image = [artList[indexPath.row] objectForKey:@"Icon"];
    cell.title.text = [artList[indexPath.row] objectForKey:@"Title"];
    cell.author.text = [artList[indexPath.row] objectForKey:@"Author"];
    cell.isLocked = [[artList[indexPath.row] objectForKey:@"IsLocked"] boolValue];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *art = artList[indexPath.row];
    
    if([[art objectForKey:@"IsLocked"] boolValue])
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        TONFTNavigationViewController * navController = [storyboard instantiateViewControllerWithIdentifier:@"NFTCodeViewController"];
        navController.modalPresentationStyle = UIModalPresentationFullScreen;
        [(TONFTCodeViewController*)[navController.viewControllers objectAtIndex:0] setArtDict:art];
        [(TONFTCodeViewController*)[navController.viewControllers objectAtIndex:0] setIndexPath:indexPath];
        [(TONFTCodeViewController*)[navController.viewControllers objectAtIndex:0] setDelegate:self];
        [self.navigationController.tabBarController presentViewController:navController animated:true completion:^{
            
        }];
    }
    else
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        TOARArtUnityViewController * unityViewController = [storyboard instantiateViewControllerWithIdentifier:@"ArtUnityViewController"];
        unityViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        unityViewController.tabBarDelegate = self.tabBarDelegate;
        unityViewController.artIndex = indexPath.row;
        [self.navigationController.tabBarController presentViewController:unityViewController animated:true completion:^{
            
        }];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((collectionView.bounds.size.width - 14*2 - 14) * 0.5f, (collectionView.bounds.size.width - 14*2 - 14) * 0.5f * 1.3f);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(14, 14, 14, 14); //UIEdgeInsetsMake(0.0, 7.0, 0.0, 0.0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 14.0f;
}

#pragma  mark - TONFTArtProtocol

- (void)artDidUnlocked:(NSMutableDictionary*)dictionary indexPath:(NSIndexPath*)indexPath
{
    
    [[artList objectAtIndex:indexPath.row] setObject:[NSNumber numberWithBool:false] forKey:@"IsLocked"];
    [_collectionView reloadData];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TOARArtUnityViewController * unityViewController = [storyboard instantiateViewControllerWithIdentifier:@"ArtUnityViewController"];
    unityViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    unityViewController.tabBarDelegate = self.tabBarDelegate;
    unityViewController.artIndex = indexPath.row;
    [self.navigationController.tabBarController presentViewController:unityViewController animated:true completion:^{
        
    }];
}

@end
