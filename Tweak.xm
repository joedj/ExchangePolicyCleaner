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
    static BOOL loaded = NO;
    BOOL result = %orig;
    if (!loaded && result && (
            [self.bundleIdentifier isEqualToString:@"com.apple.DAEAS"] ||    // iOS 5
            [self.bundleIdentifier isEqualToString:@"com.yourcompany.DAEAS"] // iOS 4
    )) {
        loaded = YES;
        %init(DAEAS);
    }
    return result;
}
%end

%ctor {
    %init;
}
