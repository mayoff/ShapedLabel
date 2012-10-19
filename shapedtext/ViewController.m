#import "ViewController.h"
#import "ShapedLabel.h"

@implementation ViewController

@synthesize shapedLabel = _shapedLabel;
@synthesize fontSizeSlider = _fontSizeSlider;
@synthesize textAlignmentControl = _textAlignmentControl;

- (IBAction)updateFontSize:(id)sender {
    _shapedLabel.fontSize = _fontSizeSlider.value;
}

- (IBAction)updateTextAlignment:(id)sender {
    // Note: the segment indexes must match the UITextAlignment constants!
    _shapedLabel.textAlignment = _textAlignmentControl.selectedSegmentIndex;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _shapedLabel.text = @"We the People of the United States, in Order to form a more perfect Union, establish Justice, ensure domestic Tranquility, provide for the common defence, promote the general Welfare, and secure the Blessing of Liberty to ourselves and our Posterity, do ordain and establish this Constitution for the United States of America.";
    _shapedLabel.fontName = @"SnellRoundhand";
    _textAlignmentControl.selectedSegmentIndex = UITextAlignmentCenter;
    [self updateFontSize:self];
    [self updateTextAlignment:self];
    _shapedLabel.textColor = UIColor.blueColor;
    _shapedLabel.shapeColor = [UIColor colorWithHue:.1 saturation:.5 brightness:1 alpha:1];
}

static UIBezierPath *pathWithReverseRect(CGRect rect) {
    CGMutablePathRef cgPath = CGPathCreateMutable();
    CGPathMoveToPoint (cgPath, NULL, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGPathAddLineToPoint (cgPath, NULL, CGRectGetMinX(rect), CGRectGetMaxY(rect));
    CGPathAddLineToPoint (cgPath, NULL, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    CGPathAddLineToPoint (cgPath, NULL, CGRectGetMaxX(rect), CGRectGetMinY(rect));
    CGPathCloseSubpath (cgPath);
    UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:cgPath];
    CGPathRelease(cgPath);
    return path;
}

- (void)viewDidLayoutSubviews {
    CGRect bounds = _shapedLabel.bounds;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:_shapedLabel.bounds];
    CGRect cutout = CGRectMake(CGRectGetMaxX(bounds) - bounds.size.width / 4, bounds.origin.y, bounds.size.width / 4, bounds.size.height / 4);
    [path appendPath:pathWithReverseRect(cutout)];
    cutout.origin.y = CGRectGetMaxY(bounds) - cutout.size.height;
    [path appendPath:pathWithReverseRect(cutout)];
    _shapedLabel.path = path;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
