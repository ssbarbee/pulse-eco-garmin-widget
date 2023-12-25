# Garmin Widget for Pulse.eco - Skopje Pollution Level

## Introduction
This project develops a Garmin Widget that integrates with the pulse.eco REST API to provide real-time pollution levels in Skopje. Pulse.eco is a crowdsourcing platform for environmental data like air pollution, humidity, temperature, and noise.

## Features
- Real-time pollution level data in Skopje.
- Data on air quality, temperature, and noise levels.
- User-friendly visual representation on Garmin devices.

## Getting Started
Ensure you have a Garmin device compatible with Garmin Connect IQ.

### Prerequisites
- Garmin Connect IQ compatible device.
- Garmin Connect IQ SDK.

### Installation
1. Clone this repository.
2. Open with Garmin Connect IQ SDK.
3. Build and run on your Garmin device.

## Usage
- Fetches pollution data for Skopje from the pulse.eco REST API.
- Displays air quality index, temperature, and noise levels.

## Contributing
Contributions are welcome. Please see CONTRIBUTING.md for our code of conduct and submission process.

## License
Licensed under the MIT License - see LICENSE file for details.

## Acknowledgments
- Pulse.eco team for the REST API and environmental data.
- Garmin Connect IQ platform for enabling widget development.

## Testing build locally

* Requires Visual Studio Code

The Monkey C extension provides a wizard to help developers side load an application. The wizard will create an executable (PRG) of the selected project. Here’s how to use it:

Plug your device into your computer
Use **Ctrl + Shift + P** (**Command + Shift + P** on the Mac) to summon the command palette
In the command palette type “Build for Device” and select **Monkey C: Build for Device**
Select the product you wish to build for. If you are unable to choose a device for which to build (the menu appears empty), it means that there are no valid devices configured for your project. See Editing the Supported Products for instructions.
Choose a directory for the output and click Select Folder
In your file manager, go to the directory selected in step 4
Copy the generated PRG files to your device’s **GARMIN/APPS** directory