# Keep Google API client classes
-keep class com.google.api.client.** { *; }
-dontwarn com.google.api.client.**

# Keep Tink classes
-keep class com.google.crypto.tink.** { *; }
-dontwarn com.google.crypto.tink.**

# Keep javax.annotation classes
-keep class javax.annotation.** { *; }
-dontwarn javax.annotation.**

# Keep error-prone annotations
-keep class com.google.errorprone.annotations.** { *; }

# Retain attributes related to annotations
-keepattributes *Annotation*
