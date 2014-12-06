require 'formula'

class Glslang < Formula
  homepage 'https://www.khronos.org/opengles/sdk/tools/Reference-Compiler/'
  head 'https://cvs.khronos.org/svn/repos/ogl/trunk/ecosystem/public/sdk/tools/glslang', :using => :svn

  depends_on 'cmake' => :build

  def patch_makefile
    # My attempt at an inline patch failed due to Windows line endings.
    inreplace 'CMakeLists.txt',
      'set(CMAKE_INSTALL_PREFIX "install" CACHE STRING "prefix" FORCE)',
      ''
  end

  def install
    patch_makefile
    system "cmake", ".", *std_cmake_args
    system "make install"
  end

  test do
    system "#{bin}/glslangValidator", "-v"
  end
end
