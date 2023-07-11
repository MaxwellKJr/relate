# Relate (Group 5)

### Group Members
- Maxwell Kapezi (BED/COM/46/18)
- Emmanuel William (BSC/COM/08/18)
- Elizabeth Kapusa (BSC/COM/01/18)
- Fred Likaka (BED/COM/15/18)
- Comfort Chikapa (BED/COM/24/17)

## Overview
* * *
Relate is a Social Mental Health App platform designed to provide a safe space, support and assistance to individuals struggling with Depression or addiction. 

The app allows users to create an account as either a regular user or a professional therapist or psychologist. It offers various features such as posting, relating to other users' posts, reporting offensive content, joining and leaving community groups, accessing a list of professionals, finding wellness centres, and starting a self-recovery journey plan.

Relate is a social app for depressed and addicts built with Flutter

## Running The App
* * *
Before we begin, we have provided two ways to run the app:
1. [APK Download Link](https://github.com/MaxwellKJr/relate/releases/download/v0.2.0-alpha/relate-alpha-build.apk)
2. [Android Simulator](https://appetize.io/app/aaaqagqvle4wyjzxg2kxslhjpe)

### Method 1: APK
An apk that can be downloaded and installed on android phones starting from version 5.1 to Android 13. Here is the [APK Download Link](https://github.com/MaxwellKJr/relate/releases/download/v0.2.0-alpha/relate-alpha-build.apk)

OR

### Method 2: Online Android Simulator
You can also access the app through an online emulator here: [Start Android Simulator](https://appetize.io/app/aaaqagqvle4wyjzxg2kxslhjpe)

## Getting Started
* * *
Here is the folder structure for the app

relate
    ├── android
    ├── assets
    ├── lib
		├── components
    	├── constants
		├── models
    	├── screens
		├── services
    	├── view_models
    ├── pubspec.yaml
    └── README.md
	
The Assets folder contains all the images and icons that were used in the app

The lib folder contains majority of the code that was used in the app such as components and screens.

Initially, we planned on using the MVVM design pattern just as the `view_models` folder shows but we later on changed to MVC since most members on team seemed to be comfortable with that.

The **Models** folder is where our models, Our **Controllers** are in the Services Folder and the **Views** are in the individual screens.
