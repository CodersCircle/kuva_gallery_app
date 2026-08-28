allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// AGP 9+ requires namespace on all Android library modules; patch legacy plugins.
subprojects {
    afterEvaluate {
        extensions.findByType(com.android.build.gradle.LibraryExtension::class.java)?.apply {
            if (namespace.isNullOrBlank()) {
                namespace = when (project.name) {
                    "isar_flutter_libs" -> "dev.isar.isar_flutter_libs"
                    "workmanager" -> "dev.fluttercommunity.workmanager"
                    else -> "com.kuva.${project.name.replace('-', '.')}"
                }
            }
            if (project.name == "isar_flutter_libs" ||
                project.name == "flutter_volume_controller") {
                compileSdk = 36
            }
        }
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
