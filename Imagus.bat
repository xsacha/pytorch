echo on
setlocal
for /f "usebackq delims=" %%i in (`"%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"  -latest -property installationPath`) do (
      call "%%i\VC\Auxiliary\Build\vcvarsall.bat" amd64
)


SET GENERATOR="Visual Studio 16 2019"
SET "CMAKEFLAGS=-DCMAKE_BUILD_TYPE=Release"
mkdir build

set TORCH_CUDA_ARCH_LIST=5.0;6.0;6.1;7.0;7.5;8.6
set TORCH_NVCC_FLAGS=-Xfatbin -compress-all
set "CUDA_PATH=C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v11.2"
set "CMAKE_INCLUDE_PATH=%~dp0\mkl\include;C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v11.2\include"
set "LIB=%~dp0\mkl\lib;C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v11.2\lib\x64;%LIB%"
set "USE_DISTRIBUTED=0"
set "BUILD_TEST=0"
set "BUILD_SHARED_LIBS=1"
set "CAFFE2_USE_MSVC_STATIC_RUNTIME=0"
set "MSVC_Z7_OVERRIDE=1"
set "ONNX_ML=0"
set "BUILD_CAFFE2_OPS=0"
set "USE_XNNPACK=0"
set "USE_QNNPACK=0"
set "USE_NNPACK=0"
set "BUILD_CAFFE2=0"
::set "USE_CUDA_STATIC_LINK=1"
::set "ATEN_STATIC_CUDA=1"
::set "USE_STATIC_CUDNN=1"
set "USE_FBGEMM=0"
set "CMAKE_BUILD_TYPE=RelWithDebInfo"


echo generating
::cmake -T host=x64 -G%GENERATOR% -A x64 -B%BUILDDIR% -H%~dp0 %CMAKEFLAGS%
pushd build
python ../tools/build_libtorch.py
popd
echo building
::cmake --build %BUILDDIR% --config Release -j 16