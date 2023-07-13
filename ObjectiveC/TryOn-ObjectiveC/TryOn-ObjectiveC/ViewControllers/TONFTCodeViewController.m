//
//  TONFTCodeViewController.m
//  TryOn-ObjectiveC
//
//  Created by Oleg Kalashnik on 07.02.2022.
//  Copyright © 2022 unity. All rights reserved.
//

#import "TONFTCodeViewController.h"

@interface TONFTCodeViewController ()
{
    NSInteger activeNumber;
    NSMutableArray *numbers;
}
@end

@implementation TONFTCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"NFT Code";
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"CloseButton"] style:UIBarButtonItemStylePlain target:self action:@selector(closeAction)];
    [self.navigationItem setLeftBarButtonItem:menuItem];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    activeNumber = 0;
    numbers = [[NSMutableArray alloc] initWithObjects:_number0, _number1, _number2, _number3, _number4, _number5, nil];
    [[numbers objectAtIndex:activeNumber] becomeFirstResponder];
}

- (void)closeAction
{
    [self.navigationController dismissViewControllerAnimated:true completion:^{
        
    }];
}

- (bool)unlockArt:(NSString*)nft
{
    if([[[_artDict objectForKey:@"nft"] lowercaseString] isEqualToString:[nft lowercaseString]])
    {
        return true;
    }
    else
    {
        _error.text = @"Wrong code";
        
        for(NSInteger i = 0; i < [numbers count]; i++)
        {
            UITextField* num = [numbers objectAtIndex:i];
            num.text = @"";
        }
        
        activeNumber = 0;
        [[numbers objectAtIndex:activeNumber] becomeFirstResponder];
    }
    
    return false;
}

- (void)doneAction
{
    NSString *nft = @"";
    
    for(NSInteger i = 0; i < [numbers count]; i++)
    {
        UITextField* num = [numbers objectAtIndex:i];
        nft = [NSString stringWithFormat:@"%@%@", nft, num.text];
    }
    
    bool result = [self unlockArt:nft];
    
    if(result)
    {
        if(_delegate)
        {
            [_delegate artDidUnlocked:_artDict indexPath:_indexPath];
        }
        
        [self.navigationController dismissViewControllerAnimated:true completion:^{
            
        }];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma  mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField.tag == 5)
    {
        [self  doneAction];
    }
    else
    {
        _error.text = @"";
        activeNumber = textField.tag + 1;
        [[numbers objectAtIndex:activeNumber] becomeFirstResponder];
    }
    
    return true;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length < 1 && textField.text.length >= 0){
        
        if(string.length == 1)
        {
            textField.text = string;
            
            if(textField.tag == 5)
            {
                [self  doneAction];
            }
            else
            {
                _error.text = @"";
                activeNumber = textField.tag + 1;
                [[numbers objectAtIndex:activeNumber] becomeFirstResponder];
            }
            
        }
        return YES;
    }
    else{
        return NO;
    }
    
    
    
}

@end
