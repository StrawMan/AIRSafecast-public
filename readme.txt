AIRSafecast for Android, public branch.
Built with Adobe AIR/AS3.

Mobile application for displaying radiation data (primarily Japan) 
as collected and provided by Safecast (http://safecast.org).

Employs the Safecast api at api.safecast.org in order to display radiation data.

Please note that this is not an "officially supported/endorsed Safecast application".

Recent debug build(s) contain a captive runtime, per default changes to AIR 3.7+, hence the increased file size. 
This is offset by the advantage of not having to download the shared runtime prior to application installation. 
I also provide a build compiled against the shared runtime, which is significantly smaller, 
but requires that one already have the AIR runtime library installed on their phone.

These builds can be obtained from my working(and more frequently updated) BitBucket repository:

https://bitbucket.org/StrawMan/airsafecast-public