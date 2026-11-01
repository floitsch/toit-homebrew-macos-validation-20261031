class Toit < Formula
  desc "High-level programming language and SDK"
  homepage "https://toitlang.org/"
  url "https://github.com/toitlang/toit/releases/download/v2.0.0/toit-v2.0.0-with-submodules.tar.gz"
  sha256 "9851b8230031503a737b20c75113546598ae69d89a5ea45b0a084764309a8798"
  license all_of: ["LGPL-2.1-only", "MIT"]
  head "https://github.com/toitlang/toit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "cmake" => :build

  uses_from_macos "zlib"

  patch :DATA

  deny_network_access!

  def install
    # Toit requires its bundled Mbed TLS configuration and allocation-failure
    # patches for garbage collection and retrying TLS operations.
    # Configure directly so Homebrew controls the architecture and compiler flags.
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DBUILD_TESTING=OFF"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_equal "v#{version}", shell_output("#{bin}/toit version").strip

    (testpath/"hello.toit").write <<~TOIT
      main:
        print "Hello, world!"
    TOIT

    assert_equal "Hello, world!\n", shell_output("#{bin}/toit run hello.toit")
    system bin/"toit", "compile", "-o", "hello", "hello.toit"
    assert_equal "Hello, world!\n", shell_output("./hello")
  end
end

__END__
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -147,6 +147,7 @@
 set_source_files_properties(utils.cc PROPERTIES COMPILE_FLAGS "-DTOIT_MODEL=\"\\\"${TOIT_MODEL}\\\"\" -DVM_GIT_INFO=\"\\\"${VM_GIT_INFO}\\\"\" -DVM_GIT_VERSION=\"\\\"${TOIT_GIT_VERSION}\\\"\"")
 
 set(GEN_DIR "${PROJECT_BINARY_DIR}/generated")
+file(MAKE_DIRECTORY "${GEN_DIR}")
 
 set(EMBEDDED_TOIT_PROGRAMS toit toit_run run_image)
 
@@ -489,6 +490,17 @@
 
   endforeach()
 
+  # Share generation across the executable targets that embed this snapshot.
+  # Makefile generators otherwise duplicate the custom command in each target.
+  add_custom_target(generate_toit_run_snapshot
+    DEPENDS "${EMBEDDED_PROGRAM_SNAPSHOT_CC_toit_run}"
+  )
+  add_dependencies(toit generate_toit_run_snapshot)
+  add_dependencies(toit.run generate_toit_run_snapshot)
+  foreach(VESSEL_SIZE ${VESSEL_SIZES})
+    add_dependencies(vessel${VESSEL_SIZE} generate_toit_run_snapshot)
+  endforeach()
+
   if (DEFINED USE_LWIP)
     include_directories(toit.run PRIVATE ${LWIP_INCLUDE_DIRS})
     target_compile_options(toit.run PRIVATE ${LWIP_COMPILER_FLAGS})
