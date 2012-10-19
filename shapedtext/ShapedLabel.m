    #import "ShapedLabel.h"
    #import <CoreText/CoreText.h>

    @implementation ShapedLabel

    @synthesize fontName = _fontName;
    @synthesize fontSize = _fontSize;
    @synthesize path = _path;
    @synthesize text = _text;
    @synthesize textColor = _textColor;
    @synthesize shapeColor = _shapeColor;
    @synthesize textAlignment = _textAlignment;

    - (void)commonInit {
        _text = @"";
        _fontSize = UIFont.systemFontSize;
        // There is no API for just getting the system font name, grr...
        UIFont *uiFont = [UIFont systemFontOfSize:_fontSize];
        _fontName = [uiFont.fontName copy];
    }

    - (id)initWithFrame:(CGRect)frame {
        self = [super initWithFrame:frame];
        if (self) {
            [self commonInit];
        }
        return self;
    }

    - (id)initWithCoder:(NSCoder *)aDecoder {
        self = [super initWithCoder:aDecoder];
        if (self) {
            [self commonInit];
        }
        return self;
    }

    - (void)setFontName:(NSString *)fontName {
        _fontName = [fontName copy];
        [self setNeedsDisplay];
    }

    - (void)setFontSize:(CGFloat)fontSize {
        _fontSize = fontSize;
        [self setNeedsDisplay];
    }

    - (void)setPath:(UIBezierPath *)path {
        _path = [path copy];
        [self setNeedsDisplay];
    }

    - (void)setText:(NSString *)text {
        _text = [text copy];
        [self setNeedsDisplay];
    }

    - (void)setTextColor:(UIColor *)textColor {
        _textColor = textColor;
        [self setNeedsDisplay];
    }

    - (void)setTextAlignment:(UITextAlignment)textAlignment {
        _textAlignment = textAlignment;
        [self setNeedsDisplay];
    }

    - (void)setShapeColor:(UIColor *)shapeColor {
        _shapeColor = shapeColor;
        [self setNeedsDisplay];
    }

    - (void)drawRect:(CGRect)rect
    {
        if (!_path)
            return;
        
        if (_shapeColor) {
            [_shapeColor setFill];
            [_path fill];
        }
        
        if (!_text || !_textColor || !_fontName || _fontSize <= 0)
            return;
        
        CTTextAlignment textAlignment = NO ? 0
        : _textAlignment == UITextAlignmentCenter ? kCTCenterTextAlignment
        : _textAlignment == UITextAlignmentRight ? kCTRightTextAlignment
        : kCTLeftTextAlignment;
        CTParagraphStyleSetting paragraphStyleSettings[] = {
            {
                .spec = kCTParagraphStyleSpecifierAlignment,
                .valueSize = sizeof textAlignment,
                .value = &textAlignment
            }
        };
        CTParagraphStyleRef style = CTParagraphStyleCreate(paragraphStyleSettings, sizeof paragraphStyleSettings / sizeof *paragraphStyleSettings);
        
        CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)_fontName, _fontSize, NULL);
        
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    (__bridge id)font, kCTFontAttributeName,
                                    _textColor.CGColor, kCTForegroundColorAttributeName,
                                    style, kCTParagraphStyleAttributeName,
                                    nil];
        CFRelease(font);
        CFRelease(style);
        
        CFAttributedStringRef trib = CFAttributedStringCreate(NULL, (__bridge CFStringRef)_text, (__bridge CFDictionaryRef)attributes);
        CTFramesetterRef setter = CTFramesetterCreateWithAttributedString(trib);
        CFRelease(trib);

        // Core Text lays out text using the default Core Graphics coordinate system, with the origin at the lower left.  We need to compensate for that, both when laying out the text and when drawing it.
        CGAffineTransform textMatrix = CGAffineTransformIdentity;
        textMatrix = CGAffineTransformTranslate(textMatrix, 0, self.bounds.size.height);
        textMatrix = CGAffineTransformScale(textMatrix, 1, -1);

        CGPathRef flippedPath = CGPathCreateCopyByTransformingPath(_path.CGPath, &textMatrix);
        CTFrameRef frame = CTFramesetterCreateFrame(setter, CFRangeMake(0, 0), flippedPath, NULL);
        CFRelease(flippedPath);
        CFRelease(setter);
        
        CGContextRef gc = UIGraphicsGetCurrentContext();
        CGContextSaveGState(gc); {
            CGContextConcatCTM(gc, textMatrix);
            CTFrameDraw(frame, gc);
        } CGContextRestoreGState(gc);
        CFRelease(frame);
    }

    @end
