#!/bin/sh
# PoC
while true
do
    echo
    echo "===== MENU ====="
    echo "1) Setup Environment"
    echo "2) Merging SM8150 and OnePlus defconfig"
    echo "3) Make nconfig"
    echo "4) Make Image.gz"
    echo "5) Make Modules"
    echo "6) Make All"
    echo "7) Exit"
    echo "================"
    printf "Choose an option (1-7): "

    read choice

    case "$choice" in
        1)
            printf "\n\nDownloading clang-r563880c to toolchains folder\n\n"
            wget -O clang-r563880c.tar.gz "https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive/f8439f0628d799092dd07df440a6334cab28939c/clang-r563880c.tar.gz"
            echo "Extracting toolchain\n"
            mkdir -p toolchains
            tar -xvf clang-r563880c.tar.gz -C toolchains
            printf "\n\nAdd toolchain binary to PATH\n\n"
            cd toolchains/bin || exit 1
            export PATH=$(pwd):$PATH
            cd ../../
            ;;
        2)
            printf "\n\nMerging SM8150 and OnePlus defconfig\n\n"
            KCONFIG_CONFIG=out/.config scripts/kconfig/merge_config.sh -m -r arch/arm64/configs/vendor/sm8150-perf_defconfig arch/arm64/configs/vendor/oplus.config
            ;;
        3)
            printf "\n\nMake nconfig...\n\n"
            make -j $(nproc --all) ARCH=arm64 O=out CROSS_COMPILE=aarch64-linux-gnu- CROSS_COMPILE_32=arm-linux-gnueabi- LLVM=1 LLVM_IAS=1 AS=llvm-as DTC_EXT=$(pwd)/dtc nconfig
            ;;
        4)
            printf "\n\nMake Image.gz...\n\n"
            make -j $(nproc --all) ARCH=arm64 O=out CROSS_COMPILE=aarch64-linux-gnu- CROSS_COMPILE_32=arm-linux-gnueabi- LLVM=1 LLVM_IAS=1 AS=llvm-as DTC_EXT=$(pwd)/dtc Image.gz
            ;;
        5)
            printf "\n\nMake Modules...\n\n"
            make -j $(nproc --all) ARCH=arm64 O=out CROSS_COMPILE=aarch64-linux-gnu- CROSS_COMPILE_32=arm-linux-gnueabi- LLVM=1 LLVM_IAS=1 AS=llvm-as DTC_EXT=$(pwd)/dtc Modules
            ;;
        6)
            printf "\n\nMake all...\n\n"
            make -j $(nproc --all) ARCH=arm64 O=out CROSS_COMPILE=aarch64-linux-gnu- CROSS_COMPILE_32=arm-linux-gnueabi- LLVM=1 LLVM_IAS=1 AS=llvm-as DTC_EXT=$(pwd)/dtc all
            ;;
        7)
            echo "Goodbye!"
            exit 0
            ;;
        *)
            echo "Invalid option."
            ;;
    esac

    echo
    printf "Press Enter to return to the menu..."
    read dummy
done
