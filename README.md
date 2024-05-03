Project Overview
MovieGenApp is an iOS application crafted with Swift, tailored to enhance movie discovery by generating personalized movie suggestions. Users select their preferred movie genre, leading to a curated list of films. Each selection offers comprehensive details about the film, including streaming platforms, release year, promotional artwork, and a synopsis, providing a holistic view of the movie.

Requirements
Xcode: Version 12.0 or higher
Swift: Version 5.0 or higher
Platform: macOS (required for Xcode)
Dependencies
The project leverages multiple third-party libraries, which are integral to its functionality. Ensure these dependencies are correctly installed and updated:

absl: 1.2024011601
AppAuth: 1.7.4
AppCheck: 10.18.2
Firebase: 10.24.0
GoogleAppMeasurement: 10.24.0
GoogleDataTransport: 9.4.0
GoogleSignIn: 7.1.0
GoogleUtilities: 7.13.1
gRPC: 1.62.2
GTMAppAuth: 4.1.1
GTMSessionFetcher: 3.3.2
InteropForGoogle: 100.0.0
leveldb: 1.22.5
nanopb: 2.30910.0
Promises: 2.4.0
SwiftProtobuf: 1.26.0
Installation
To set up the project environment, please follow these steps:

Clone the repository:
Obtain the project by cloning the repository to your local machine.
Open the project in Xcode:
Launch Xcode and navigate to 'File' > 'Open', then select the cloned project directory.
Install Dependencies:
For CocoaPods: Run pod install in the project directory.
For Carthage: Execute carthage update.
Running the Project
Execute the following steps to run the MovieGenApp on a simulator or physical device:

Select your target device from the top device toolbar in Xcode.
Initiate the build and run process by pressing Cmd + R or clicking the 'Run' button in Xcode.
Additional Information
Info.plist: This file contains crucial configuration settings for the application, such as bundle identifier and permissions. Review and customize as necessary.
Asset Catalog: Contains all graphical assets in Assets.xcassets, designed for universal usability across all device types.
Project Files
ContentView.swift: Manages the main view interface of the application.
MovieGenApp.swift: Contains the entry point of the application and manages the app lifecycle.
Info.plist: Key configuration file for application settings.

Team Members

Badr Qattan
Albert Zhang
Dana Alzahed
Roaa Alghazi
