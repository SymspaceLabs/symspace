//
//  TONFTCodeViewController.h
//  TryOn-ObjectiveC
//
//  Created by Oleg Kalashnik on 07.02.2022.
//  Copyright © 2022 unity. All rights reserved.
//

#import "TOBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TONFTArtProtocol <NSObject>

- (void)artDidUnlocked:(NSMutableDictionary*)dictionary indexPath:(NSIndexPath*)indexPath;

@end

@interface TONFTCodeViewController : TOBaseViewController <UITextFieldDelegate>

@property(nonatomic, weak)id<TONFTArtProtocol> delegate;
@property(nonatomic, strong)NSIndexPath *indexPath;
@property(nonatomic, strong)NSMutableDictionary *artDict;
@property(nonatomic, weak)IBOutlet UITextField *number0;
@property(nonatomic, weak)IBOutlet UITextField *number1;
@property(nonatomic, weak)IBOutlet UITextField *number2;
@property(nonatomic, weak)IBOutlet UITextField *number3;
@property(nonatomic, weak)IBOutlet UITextField *number4;
@property(nonatomic, weak)IBOutlet UITextField *number5;
@property(nonatomic, weak)IBOutlet UILabel *error;

@end

NS_ASSUME_NONNULL_END
