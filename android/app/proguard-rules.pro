# Keep ExoPlayer (mandatory for just_audio)
-keep class com.google.android.exoplayer2.** { *; }
-dontwarn com.google.android.exoplayer2.**

# Keep AndroidX Media3 (used by just_audio new versions)
-keep class androidx.media3.** { *; }
-dontwarn androidx.media3.**

# Keep just_audio platform code
-keep class com.ryanheise.just_audio.** { *; }
-dontwarn com.ryanheise.just_audio.**

# Keep Firebase (URL handling)
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**
