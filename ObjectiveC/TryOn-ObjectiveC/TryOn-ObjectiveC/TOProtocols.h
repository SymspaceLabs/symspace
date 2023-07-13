//
//  TOProtocols.h
//  TryOn-ObjectiveC
//
//  Created by Oleg Kalashnik on 07.02.2022.
//  Copyright © 2022 unity. All rights reserved.
//

#ifndef TOProtocols_h
#define TOProtocols_h

@protocol TOTabBarProtocol <NSObject>

- (void)showArtUnityScene:(NSString*)art viewController:(UIViewController*)vc closeButton:(UIButton*)closeButton shareButton:(UIButton*)shareButton;

@end

#endif /* TOProtocols_h */
