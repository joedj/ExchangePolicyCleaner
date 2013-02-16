What is it?
-----------

ExchangePolicyCleaner is an iOS tweak that ignores Microsoft Exchange ActiveSync policies.

http://moreinfo.thebigboss.org/moreinfo/depiction.php?file=exchangepolicycleanerDp

<a href="https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=U7EU2XR2U2JMQ&lc=US&item_name=joedj&item_number=ExchangePolicyCleaner&currency_code=USD&bn=PP%2dDonationsBF%3abtn_donate_SM%2egif%3aNonHosted">
  <img src="https://www.paypalobjects.com/en_US/i/btn/btn_donate_SM.gif" alt="Donate with PayPal">
</a>

How do I build it?
------------------

ExchangePolicyCleaner uses the [Theos](https://github.com/DHowett/theos) Makefile system:

```sh
git clone git://github.com/joedj/ExchangePolicyCleaner.git
cd ExchangePolicyCleaner
ln -s $THEOS theos
THEOS_DEVICE_IP=1.2.3.4 make package install
```

Gotchas
-------
* Changes will not take effect until you refresh your EAS policy, e.g. by disabling then re-enabling your Exchange account.  You can also do this using cycript:

```js
#!/usr/bin/env cycript -p dataaccessd

(function() {
    for each (var a in DAAccountManager.sharedInstance.accounts) {
        if ([a.policyManager respondsToSelector:@selector(requestPolicyUpdate)]) {
            [a.policyManager requestPolicyUpdate];
        }
    }
})()
```


But I'd rather use cycript
--------------------------

Instead of using this MobileSubstrate tweak, you can apply an ephemeral hook to -[ASWBXMLPolicy _cleanUpPolicyData:] using cycript:

```js
#!/usr/bin/env cycript -p dataaccessd

if (typeof(original_ASWBXMLPolicy_cleanUpPolicyData) == 'undefined') {
    original_ASWBXMLPolicy_cleanUpPolicyData = ASWBXMLPolicy.messages['_cleanUpPolicyData:'];
}

ASWBXMLPolicy.messages['_cleanUpPolicyData:'] = function(policy) {
    [policy removeAllObjects];
    original_ASWBXMLPolicy_cleanUpPolicyData.call(this, policy);
}
```


What does an Exchange ActiveSync policy look like?
--------------------------------------------------

Here is an example policy as passed to the -[ASWBXMLPolicy _cleanUpPolicyData:] method:

```objc
{
    ASPolicyType = ASWBXMLPolicyType;
    AllowBluetooth = 2;
    AllowBrowser = 1;
    AllowCamera = 1;
    AllowConsumerEmail = 1;
    AllowDesktopSync = 1;
    AllowHTMLEmail = 1;
    AllowInternetSharing = 1;
    AllowIrDA = 1;
    AllowPOPIMAPEmail = 1;
    AllowRemoteDesktop = 1;
    AllowSMIMEEncryptionAlgorithmNegotiation = 2;
    AllowSMIMESoftCerts = 1;
    AllowSimpleDevicePassword = 1;
    AllowStorageCard = 1;
    AllowTextMessaging = 1;
    AllowUnsignedApplications = 1;
    AllowUnsignedInstallationPackages = 1;
    AllowWiFi = 1;
    AlphanumericPasswordEnabled = 0;
    ApprovedApplicationList = ();
    AttachmentsEnabled = 1;
    DeviceEncryptionEnabled = 1;
    DevicePasswordEnabled = 1;
    DevicePasswordExpiration = "";
    DevicePasswordHistory = 0;
    MaxAttachmentSize = "";
    MaxCalendarAgeFilter = 0;
    MaxDevicePasswordFailedAttempts = 16;
    MaxEmailAgeFilter = 0;
    MaxEmailBodyTruncationSize = "-1";
    MaxInactivityTimeDeviceLock = 900;
    MinDevicePasswordComplexCharacters = 3;
    MinDevicePasswordLength = 4;
    PasswordRecoveryEnabled = 0;
    RequireDeviceEncryption = 1;
    RequireEncryptedSMIMEMessages = 0;
    RequireEncryptionSMIMEAlgorithm = 0;
    RequireManualSyncWhenRoaming = 0;
    RequireSignedSMIMEAlgorithm = 0;
    RequireSingedSMIMEMessages = 0;
    UnapprovedInROMAppliationList = ();
}
```
