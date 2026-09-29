# Keep Gson generic type information
-keepattributes Signature
-keepattributes *Annotation*

# Keep Gson TypeToken
-keep class com.google.gson.reflect.TypeToken { *; }
-keep class * extends com.google.gson.reflect.TypeToken { *; }