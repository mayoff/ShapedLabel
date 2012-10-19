#import <UIKit/UIKit.h>

@class ShapedLabel;

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet ShapedLabel *shapedLabel;
@property (weak, nonatomic) IBOutlet UISlider *fontSizeSlider;
@property (weak, nonatomic) IBOutlet UISegmentedControl *textAlignmentControl;

@end
