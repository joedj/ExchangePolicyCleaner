%group DAEAS
%hook ASWBXMLPolicy
-(void)_cleanUpPolicyData:(NSMutableDictionary *)policy {
    if ([policy respondsToSelector:@selector(removeAllObjects)]) {
        NSLog(@"ExchangePolicyCleaner is taking out the trash: %@", policy);
        [policy removeAllObjects];
    }
    %orig;
}
%end
%end

%hook NSBundle
- (BOOL)load {
    BOOL success = %orig;
    if (success && (
            [self.bundleIdentifier isEqualToString:@"com.apple.DAEAS"] ||    // iOS 5/6/7/8
            [self.bundleIdentifier isEqualToString:@"com.yourcompany.DAEAS"] // iOS 4
    )) {
        static dispatch_once_t once;
        dispatch_once(&once, ^{
            %init(DAEAS);
        });
    }
    return success;
}
%end

%ctor {
    %init;
}
