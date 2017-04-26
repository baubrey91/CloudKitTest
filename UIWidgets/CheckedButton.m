
#import "CheckedButton.h"

@interface CheckedButton ()
@property (strong, nonatomic) UIImage* checkedImage;
@property (strong, nonatomic) UIImage* unCheckedImage;
@end

@implementation CheckedButton

- (void)commonInit {
  NSBundle* thisBundle = [NSBundle bundleForClass: [self class]];
  _checkedImage = [UIImage imageNamed: @"Checked" inBundle: thisBundle compatibleWithTraitCollection: nil];
  _unCheckedImage = [UIImage imageNamed: @"Unchecked" inBundle: thisBundle compatibleWithTraitCollection: nil];

  [self setImage: _unCheckedImage forState: UIControlStateNormal];
  [self addTarget: self action: @selector(tapped:) forControlEvents: UIControlEventTouchUpInside];
}

- (instancetype)initWithFrame: (CGRect)frame {
  self = [super initWithFrame: frame];
  if (self) {
    [self commonInit];
  }
  return self;
}

- (id)initWithCoder: (NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self commonInit];
  }
  return self;
}

- (void) tapped: (CheckedButton*)button {
  self.checked = !self.checked;
  [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)setChecked: (BOOL)checked {
  _checked = checked;
  [self setImage: _checked ? _checkedImage: _unCheckedImage forState: UIControlStateNormal];
}

@end
