#!/bin/bash

# --- Helper Functions ---

# Function to print colored messages
print_message() {
    local color=$1
    local message=$2
    case $color in
        "green") echo -e "\033[0;32m${message}\033[0m" ;;
        "red") echo -e "\033[0;31m${message}\033[0m" ;;
        "yellow") echo -e "\033[0;33m${message}\033[0m" ;;
        *) echo "${message}" ;;
    esac
}

# --- iOS Functions ---

run_ios_flow() {
    print_message "yellow" "Starting iOS flow..."
    local booted_simulators
    booted_simulators=$(xcrun simctl list devices booted)

    if [[ ! $(echo "${booted_simulators}" | grep -v "unavailable") =~ com\.apple\.CoreSimulator\.SimDeviceType ]]; then
        print_message "yellow" "No booted simulators found. Starting a new one..."
        local simulator_udid
        simulator_udid=$(xcrun simctl list devices | grep 'iPhone' | head -n 1 | awk -F'[()]' '{print $2}')
        if [ -z "${simulator_udid}" ]; then
            print_message "red" "No iOS simulators found. Please install one via Xcode."
            exit 1
        fi
        print_message "green" "Starting simulator with UDID: ${simulator_udid}"
        xcrun simctl boot "${simulator_udid}"
        open -a Simulator
        # Wait for the simulator to be fully booted
        sleep 15
    else
        print_message "green" "Found a booted simulator."
    fi

    print_message "yellow" "Cleaning the project..."
    flutter clean

    print_message "yellow" "Building the app for iOS simulator..."
    flutter build ios --simulator

    print_message "yellow" "Running the app on the iOS simulator..."
    flutter run
}

# --- Android Functions ---

connect_android_device_usb() {
    print_message "yellow" "Attempting to connect to a USB device..."
    # Most modern systems will detect USB devices automatically.
    # This is a placeholder for any specific USB connection logic if needed.
    print_message "green" "Please ensure your device is connected via USB and has USB debugging enabled."
    sleep 5
    if ! adb devices | grep -q "device$"; then
        print_message "red" "No USB device detected. Please check the connection and permissions."
        exit 1
    fi
}

connect_android_device_tcp() {
    print_message "yellow" "Starting TCP/IP connection..."
    read -p "Enter host IP: " host
    read -p "Enter port for pairing: " pair_port
    read -p "Enter pairing code: " pair_code
    read -p "Enter port for connecting: " connect_port

    adb pair "${host}:${pair_port}" "${pair_code}"
    adb connect "${host}:${connect_port}"
}

run_android_flow() {
    print_message "yellow" "Starting Android flow..."
    if ! adb devices | grep -q "device$"; then
        print_message "yellow" "No connected Android devices found."
        read -p "Connect via (usb/tcp)? " connection_method
        if [ "${connection_method}" == "usb" ]; then
            connect_android_device_usb
        elif [ "${connection_method}" == "tcp" ]; then
            connect_android_device_tcp
        else
            print_message "red" "Invalid connection method."
            exit 1
        fi
    else
        print_message "green" "Found a connected Android device."
    fi

    print_message "yellow" "Cleaning the project..."
    flutter clean

    print_message "yellow" "Building the app for Android..."
    flutter build apk

    print_message "yellow" "Running the app on the Android device..."
    flutter run
}

# --- Main Logic ---

main() {
    print_message "yellow" "Starting the build and test pipeline..."
    read -p "Select build target (ios/android/both): " build_target

    case $build_target in
        "ios")
            run_ios_flow
            ;;
        "android")
            run_android_flow
            ;;
        "both")
            print_message "yellow" "Building for both platforms. Which one to test?"
            read -p "Select test platform (ios/android): " test_platform
            if [ "${test_platform}" == "ios" ]; then
                run_ios_flow
            elif [ "${test_platform}" == "android" ]; then
                run_android_flow
            else
                print_message "red" "Invalid test platform."
                exit 1
            fi
            ;;
        *)
            print_message "red" "Invalid build target."
            exit 1
            ;;
    esac

    print_message "green" "Pipeline finished."
}

main
