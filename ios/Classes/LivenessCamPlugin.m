#import "LivenessCamPlugin.h"
#if __has_include(<liveness_cam/liveness_cam-Swift.h>)
#import <liveness_cam/liveness_cam-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "liveness_cam-Swift.h"
#endif

@implementation LivenessCamPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftLivenessCamPlugin registerWithRegistrar:registrar];
}
@end
