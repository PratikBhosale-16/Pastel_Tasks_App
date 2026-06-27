allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

// ---------------------------------------------------------------------------
// Workaround: isar_flutter_libs 3.1.0+1 does not declare an Android namespace.
// AGP 8.0+ requires every library module to declare a namespace in build.gradle.
// This project uses AGP 9.0.1 (the official Flutter 3.44.4 template default).
//
// Root cause: isar_flutter_libs 3.1.0+1 was published before the AGP 8.0
// namespace requirement existed. No stable Isar 4.x release is available on
// pub.dev as of Flutter 3.44.4. isar_flutter_libs cannot be removed — it
// contains the native Isar Core binaries required for Android at runtime.
//
// Fix: inject the correct namespace at configuration time using
// pluginManager.withPlugin — the officially recommended Gradle 9 approach
// (preferred over afterEvaluate: configuration-time, deterministic,
// Configuration Cache compatible).
//
// The namespace value "dev.isar.isar_flutter_libs" is taken directly from
// the package attribute declared in isar_flutter_libs-3.1.0+1/pubspec.yaml.
//
// Remove this block once Isar publishes a stable release that declares its
// own namespace in its Android build.gradle.
// ---------------------------------------------------------------------------
subprojects {
    if (name == "isar_flutter_libs") {
        pluginManager.withPlugin("com.android.library") {
            extensions.configure<com.android.build.gradle.LibraryExtension>("android") {
                if (namespace == null) {
                    namespace = "dev.isar.isar_flutter_libs"
                }
            }
        }
        afterEvaluate {
            extensions.configure<com.android.build.gradle.LibraryExtension>("android") {
                compileSdk = 34
            }
        }
    }
}
