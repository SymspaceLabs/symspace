//
//  IOSTryOnPlugin.h
//  Unity-iPhone
//
//  Created by Oleg Kalashnik on 28.11.2021.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern UIViewController *UnityGetGLViewController();

@interface IOSTryOnPlugin : NSObject

+ (void)callUnityObject:(const char*)object Method:(const char*)method Parameter:(const char*)parameter;

@end
