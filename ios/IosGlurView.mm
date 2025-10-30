#import "IosGlurView.h"

#import <react/renderer/components/IosGlurViewSpec/ComponentDescriptors.h>
#import <react/renderer/components/IosGlurViewSpec/EventEmitters.h>
#import <react/renderer/components/IosGlurViewSpec/Props.h>
#import <react/renderer/components/IosGlurViewSpec/RCTComponentViewHelpers.h>

#import "RCTFabricComponentsPlugins.h"

@class GlurHostingView;

using namespace facebook::react;

@interface IosGlurView () <RCTIosGlurViewViewProtocol>

@end

@implementation IosGlurView {
    UIVisualEffectView * _blurView;
    UIView * _glurView; // created dynamically if GlurHostingView exists
}

+ (ComponentDescriptorProvider)componentDescriptorProvider
{
    return concreteComponentDescriptorProvider<IosGlurViewComponentDescriptor>();
}

- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    static const auto defaultProps = std::make_shared<const IosGlurViewProps>();
    _props = defaultProps;

    _blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    _blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _blurView.frame = self.bounds;

    self.contentView = _blurView;
  }

  return self;
}

- (void)updateProps:(Props::Shared const &)props oldProps:(Props::Shared const &)oldProps
{
    const auto &oldViewProps = *std::static_pointer_cast<IosGlurViewProps const>(_props);
    const auto &newViewProps = *std::static_pointer_cast<IosGlurViewProps const>(props);

    // Switch between Glur and system blur when 'useGlur' toggles
    if (oldViewProps.useGlur != newViewProps.useGlur) {
        if (newViewProps.useGlur) {
            [self ensureGlurView];
        } else {
            [self ensureBlurView];
            // Keep whatever effect was set in init (UIBlurEffectStyleLight)
        }
    }

    // Apply Glur parameters when using Glur and when any changes
    if (newViewProps.useGlur) {
        bool radiusChanged = oldViewProps.glurRadius != newViewProps.glurRadius;
        bool offsetChanged = oldViewProps.glurOffset != newViewProps.glurOffset;
        bool interpChanged = oldViewProps.glurInterpolation != newViewProps.glurInterpolation;
        bool noiseChanged = oldViewProps.glurNoise != newViewProps.glurNoise;
        bool drawChanged = oldViewProps.glurDrawingGroup != newViewProps.glurDrawingGroup;
        bool dirChanged = oldViewProps.glurDirection != newViewProps.glurDirection;
        bool imageChanged = oldViewProps.imageUri != newViewProps.imageUri;
        if (radiusChanged || offsetChanged || interpChanged || noiseChanged || drawChanged || dirChanged || imageChanged || (oldViewProps.useGlur != newViewProps.useGlur)) {
            [self ensureGlurView];
            [_glurView setValue:@((double)newViewProps.glurRadius) forKey:@"radius"];
            [_glurView setValue:@((double)newViewProps.glurOffset) forKey:@"offset"];
            [_glurView setValue:@((double)newViewProps.glurInterpolation) forKey:@"interpolation"];
            [_glurView setValue:@((double)newViewProps.glurNoise) forKey:@"noise"];
            [_glurView setValue:@((BOOL)newViewProps.glurDrawingGroup) forKey:@"drawingGroup"];
            NSString * dirStr = [[NSString alloc] initWithUTF8String:toString(newViewProps.glurDirection).c_str()];
            NSString * lower = [dirStr lowercaseString];
            NSInteger d = 1;
            if ([lower isEqualToString:@"up"]) d = 0;
            else if ([lower isEqualToString:@"down"]) d = 1;
            else if ([lower isEqualToString:@"left"]) d = 2;
            else if ([lower isEqualToString:@"right"]) d = 3;
            [_glurView setValue:@(d) forKey:@"directionRaw"];
            if (newViewProps.imageUri.size() > 0) {
                NSString * uri = [[NSString alloc] initWithUTF8String:newViewProps.imageUri.c_str()];
                [_glurView setValue:uri forKey:@"imageUri"];
            } else {
                [_glurView setValue:nil forKey:@"imageUri"];
            }
        }
    }

    if (oldViewProps.tintOpacity != newViewProps.tintOpacity) {
        if (self.contentView != nil) {
            self.contentView.alpha = (CGFloat)newViewProps.tintOpacity;
        }
    }

    [super updateProps:props oldProps:oldProps];
}

Class<RCTComponentViewProtocol> IosGlurViewCls(void)
{
    return IosGlurView.class;
}

- (UIBlurEffectStyle)uiBlurEffectStyleFromString:(NSString *)style
{
    static NSDictionary<NSString *, NSNumber *> *mapping;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mapping = @{
            @"extraLight": @(UIBlurEffectStyleExtraLight),
            @"light": @(UIBlurEffectStyleLight),
            @"dark": @(UIBlurEffectStyleDark),
#if defined(__IPHONE_10_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0)
            @"regular": @(UIBlurEffectStyleRegular),
            @"prominent": @(UIBlurEffectStyleProminent),
#endif
#if defined(__IPHONE_13_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
            @"systemUltraThinMaterial": @(UIBlurEffectStyleSystemUltraThinMaterial),
            @"systemThinMaterial": @(UIBlurEffectStyleSystemThinMaterial),
            @"systemMaterial": @(UIBlurEffectStyleSystemMaterial),
            @"systemThickMaterial": @(UIBlurEffectStyleSystemThickMaterial),
            @"systemChromeMaterial": @(UIBlurEffectStyleSystemChromeMaterial),
#endif
        };
    });

    NSNumber *value = mapping[style] ?: mapping[@"light"];
    return (UIBlurEffectStyle)value.integerValue;
}

- (void)ensureBlurView
{
    if (self.contentView != _blurView) {
        _blurView.frame = self.bounds;
        self.contentView = _blurView;
    }
}

- (void)ensureGlurView
{
    if (_glurView == nil) {
        Class glurClass = NSClassFromString(@"GlurHostingView");
        if (glurClass != Nil) {
            _glurView = [[glurClass alloc] initWithFrame:self.bounds];
            _glurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        } else {
            return; // Glur not available
        }
    }
    if (self.contentView != _glurView) {
        _glurView.frame = self.bounds;
        self.contentView = _glurView;
    }
}

- (void)applyGlurFromStyleString:(NSString *)styleStr
{
    // Expected format: glur(radius=8,offset=0.3,interpolation=0.4,direction=down,noise=0.1,drawingGroup=true)
    NSRange start = [styleStr rangeOfString:@"("];
    NSRange end = [styleStr rangeOfString:@")" options:NSBackwardsSearch];
    if (start.location == NSNotFound || end.location == NSNotFound || end.location <= start.location) {
        return;
    }
    NSString * params = [styleStr substringWithRange:NSMakeRange(start.location + 1, end.location - start.location - 1)];
    NSArray<NSString *> * pairs = [params componentsSeparatedByString:@","];
    for (NSString *pair in pairs) {
        NSArray<NSString *> * kv = [pair componentsSeparatedByString:@"="];
        if (kv.count != 2) { continue; }
        NSString * key = [kv[0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString * val = [kv[1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([key isEqualToString:@"radius"]) {
            [_glurView setValue:@([val doubleValue]) forKey:@"radius"];
        } else if ([key isEqualToString:@"offset"]) {
            [_glurView setValue:@([val doubleValue]) forKey:@"offset"];
        } else if ([key isEqualToString:@"interpolation"]) {
            [_glurView setValue:@([val doubleValue]) forKey:@"interpolation"];
        } else if ([key isEqualToString:@"noise"]) {
            [_glurView setValue:@([val doubleValue]) forKey:@"noise"];
        } else if ([key isEqualToString:@"drawingGroup"]) {
            NSString * lower = [val lowercaseString];
            BOOL dg = [lower isEqualToString:@"true"] || [lower isEqualToString:@"1"];
            [_glurView setValue:@(dg) forKey:@"drawingGroup"];
        } else if ([key isEqualToString:@"direction"]) {
            NSInteger d = 1; // default down
            NSString * lower = [val lowercaseString];
            if ([lower isEqualToString:@"up"]) d = 0;
            else if ([lower isEqualToString:@"down"]) d = 1;
            else if ([lower isEqualToString:@"left"]) d = 2;
            else if ([lower isEqualToString:@"right"]) d = 3;
            [_glurView setValue:@(d) forKey:@"directionRaw"];
        }
    }
}

@end


