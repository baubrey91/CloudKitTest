

#import "BadgeView.h"

@implementation BadgeView

- (void)setBadges:(NSArray *)badgeImages {
  for (UIView* v in self.subviews) {
    [v removeFromSuperview];
  }
  
  for (UIImage* image in badgeImages) {
    UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
    [self addSubview: imageView];
  }
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  static CGSize badgeSize = {32., 45.};
  static CGFloat distance = 0.;
  
  CGRect f = CGRectMake(self.frame.size.width - badgeSize.width, 0, badgeSize.width, badgeSize.height);
  
  for (UIView* v in self.subviews) {
    v.frame = f;
    f.origin.x -= f.size.width + distance;
  }
}

- (void)prepareForInterfaceBuilder {
  [self setBadges: @[[UIImage imageNamed: @"man"], [UIImage imageNamed: @"woman"]]];
}

@end
