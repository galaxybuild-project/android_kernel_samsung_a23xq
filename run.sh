 	CLANG_VERSION=14 && echo "CLANG_VERSION=$CLANG_VERSION"
       export CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE_O3=y
        export PATH=$(pwd)/toolchain/clang-`echo $CLANG_VERSION`/bin:$PATH
        export CROSS_COMPILE=$(pwd)/toolchain/google/bin/aarch64-linux-android-
        export CLANG_TRIPLE=aarch64-linux-gnu-
        export KBUILD_BUILD_USER="mind"
        export KBUILD_BUILD_HOST="galaxybuild"
        export BUILD_START=`date`
        export IS_CI=true
        export DEFCONFIG="wonderful_defconfig"
        export DEVICE="a23xq"
        export DEVICE_ID="A23 5G"
        export LLVM=1
        export LLVM_IAS=1
        
        bash $(pwd)/build.sh kernel --jobs $(nproc --all) `echo $DEFCONFIG`
        
        echo ""
        echo "===================================================="
        strings out/arch/arm64/boot/Image | grep "Linux version"
        echo "===================================================="

        mv out/.config out/build_config.txt
        gitsha1=$(git rev-parse --short HEAD)
        buildDetails="`make kernelversion`-`echo $DEVICE`_`echo $gitsha1`-`date +'%Y%m%d%H%M%S'`" && echo "buildDetails=$buildDetails"
