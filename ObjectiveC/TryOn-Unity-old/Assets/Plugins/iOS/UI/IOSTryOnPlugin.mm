#import "IOSTryOnPlugin.h"

@implementation IOSTryOnPlugin

+ (void)alertView:(NSString*)title message:(NSString*)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action){}];
    [alert addAction:defaultAction];
    [UnityGetGLViewController() presentViewController: alert animated:TRUE completion:nil];
}

+ (void)callUnityObject:(const char*)object Method:(const char*)method Parameter:(const char*)parameter {
    UnitySendMessage(object, method, parameter);
}

@end

extern "C"
{
    void _ShowAlert(const char *title, const char *message)
    {
        [IOSTryOnPlugin alertView:[NSString stringWithUTF8String:title] message: [NSString stringWithUTF8String:message]];
    }
}


