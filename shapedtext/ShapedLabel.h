    #import <UIKit/UIKit.h>

    @interface ShapedLabel : UIView

    @property (nonatomic, copy) NSString *text;
    @property (nonatomic) UITextAlignment textAlignment;
    @property (nonatomic, copy) NSString *fontName;
    @property (nonatomic) CGFloat fontSize;
    @property (nonatomic, strong) UIColor *textColor;
    @property (nonatomic, strong) UIColor *shapeColor;
    @property (nonatomic, copy) UIBezierPath *path;

    @end
