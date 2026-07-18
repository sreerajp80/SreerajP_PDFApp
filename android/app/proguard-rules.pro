# ProGuard / R8 rules for the release builds of the application.
# For more details, see https://developer.android.com/studio/build/shrink-code

# PDFBox-Android rules (prevent stripping and obfuscation since it uses reflection internally)
-keep class com.tom_roush.pdfbox.** { *; }
-dontwarn com.tom_roush.pdfbox.**

# Suppress missing optional Gemalto JP2 decoder/encoder classes warnings
-dontwarn com.gemalto.jp2.**

# Bouncy Castle rules (if needed, suppress warnings about optional libraries)
-dontwarn org.bouncycastle.jsse.**
-dontwarn org.bouncycastle.est.**
-dontwarn org.bouncycastle.cert.cmp.**
-dontwarn org.bouncycastle.cert.crmf.**
