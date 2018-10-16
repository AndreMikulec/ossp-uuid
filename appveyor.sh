#!/bin/sh

set -x
## Permission to use, copy, modify, and distribute this software for
## any purpose with or without fee is hereby granted, provided that
## the above copyright notice and this permission notice appear in all
## copies.
## 
## THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESSED OR IMPLIED
## WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
## MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
## IN NO EVENT SHALL THE AUTHORS AND COPYRIGHT HOLDERS AND THEIR
## CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
## SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
## LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
## USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
## ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
## OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
## OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
## SUCH DAMAGE.
## 
## HOME AND DOCUMENTATION
## 
## The documentation and latest release can be found on
## 
## http://www.ossp.org/pkg/lib/uuid/
## ftp://ftp.ossp.org/pkg/lib/uuid/

# so garantee that it has it ( may be redundant ? )
export PATH=.:/usr/local/bin:/mingw/bin:/bin:/c/Windows/system32:/c/Windows:/c/Windows/System32/Wbem:/c/Windows/System32/WindowsPowerShell/v1.0/:$PATH

# garantee that I have the MinGW that I want
mount --replace c:/mingw-w64/x86_64-6.3.0-posix-seh-rt_v5-rev1/mingw64 /mingw

which gcc
gcc --version

echo $PWD
export

# important
cd $APPVEYOR_BUILD_FOLDER

# patching

patch -p1 < ${PWD}/patches/uuid-devel-1.6.2-41.fc29.aarch64/uuid-1.6.2-41.fc29.src/uuid-1.6.1-ossp.patch
# extra space to garantee first patch


patch -p1 < ${PWD}/patches/uuid-devel-1.6.2-41.fc29.aarch64/uuid-1.6.2-41.fc29.src/uuid-1.6.1-mkdir.patch


patch -p1 < ${PWD}/patches/uuid-devel-1.6.2-41.fc29.aarch64/uuid-1.6.2-41.fc29.src/uuid-1.6.2-php54.patch


patch -p1 < ${PWD}/patches/uuid-devel-1.6.2-41.fc29.aarch64/uuid-1.6.2-41.fc29.src/uuid-1.6.2-hwaddr.patch


patch -p1 < ${PWD}/patches/uuid-devel-1.6.2-41.fc29.aarch64/uuid-1.6.2-41.fc29.src/uuid-1.6.2-nostrip.patch


patch -p1 < ${PWD}/patches/uuid-devel-1.6.2-41.fc29.aarch64/uuid-1.6.2-41.fc29.src/uuid-1.6.2-manfix.patch


patch -p1 < ${PWD}/patches/uuid-devel-1.6.2-41.fc29.aarch64/uuid-1.6.2-41.fc29.src/uuid-aarch64.patch

# 64 bit

${PWD}/configure --build=x86_64-w64-mingw32 --prefix=$PWD/dist --enable-shared --enable-static

# choose (currently) building with the chosen MinGW-w64

make LDFLAGS=-shared
make install
gcc -shared -o ossp-uuid.dll .libs/*.o -fpic  -Wl,--no-undefined -Wl,--enable-auto-import -Wl,--enable-runtime-pseudo-reloc
pexports ossp-uuid.dll > ossp-uuid.def
dlltool --dllname ossp-uuid.dll --def ossp-uuid.def --output-lib libossp-uuid.dll.a 
cp -p ossp-uuid.dll      $PWD/dist/bin
cp -p ossp-uuid.def      $PWD/dist/bin
cp -p libossp-uuid.dll.a $PWD/dist/lib

# rename
mv    $PWD/dist $PWD/x64

make distclean

# 32 bit

${PWD}/configure --build=i686-w64-mingw32 --prefix=$PWD/dist --enable-shared --enable-static

# choose (currently) building with the chosen MinGW-w64

make LDFLAGS=-shared
make install
gcc -shared -o ossp-uuid.dll .libs/*.o -fpic  -Wl,--no-undefined -Wl,--enable-auto-import -Wl,--enable-runtime-pseudo-reloc
pexports ossp-uuid.dll > ossp-uuid.def
dlltool --dllname ossp-uuid.dll --def ossp-uuid.def --output-lib libossp-uuid.dll.a 
cp -p ossp-uuid.dll      $PWD/dist/bin
cp -p ossp-uuid.def      $PWD/dist/bin
cp -p libossp-uuid.dll.a $PWD/dist/lib

# rename
mv    $PWD/dist $PWD/i686

# create
mkdir            $PWD/dist

# copy into
mv    $PWD/x64   $PWD/dist
mv    $PWD/i686  $PWD/dist

set +x
exit
