# Unofficial formula to work around official Homebrew removing support for
# anything other than Lua 5.2. Grr.

require "formula"

class LuarocksLuajit < Formula
  homepage "http://luarocks.org"
  url "http://luarocks.org/releases/luarocks-2.2.0.tar.gz"
  sha1 "e2de00f070d66880f3766173019c53a23229193d"
  revision 1

  head "https://github.com/keplerproject/luarocks.git"

  option "with-lua51",  "Use Lua 5.1 instead of LuaJIT"

  if build.with? "lua51"
    depends_on "lua51"
  else
    depends_on "luajit"
  end

  def install
    # Install to the Cellar, but direct modules to HOMEBREW_PREFIX
    args = ["--prefix=#{prefix}",
            "--rocks-tree=#{HOMEBREW_PREFIX}",
            "--sysconfdir=#{etc}/luarocks"]

    if build.with? "lua51"
      lua51_prefix = Formula["lua51"].opt_prefix

      args << "--with-lua=#{lua51_prefix}"
      args << "--with-lua-include=#{lua51_prefix}/include/lua-5.1"
      args << "--lua-version=5.1"
      args << "--lua-suffix=5.1"

    else
      luajit_prefix = Formula["luajit"].opt_prefix

      args << "--with-lua=#{luajit_prefix}"
      args << "--lua-version=5.1"
      args << "--lua-suffix=jit"
      args << "--with-lua-include=#{luajit_prefix}/include/luajit-2.0"
    end

    system "./configure", *args
    system "make", "build"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    Rocks install to: #{HOMEBREW_PREFIX}/lib/luarocks/rocks

    You may need to run `luarocks install` inside the Homebrew build
    environment for rocks to successfully build. To do this, first run `brew sh`.
    EOS
  end

  test do
    system "#{bin}/luarocks", "install", "say"
  end
end
