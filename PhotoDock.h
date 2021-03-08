#import <UIKit/UIKit.h>
@interface SBDockView : UIView
@property(nonatomic, retain) UIView *backgroundView;
@end
static BOOL isEnabled = YES;
static UIImage *dockImage;