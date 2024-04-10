# Creator Dashboard for Flutter

## Overview

The Creator Dashboard is a Flutter application designed for content creators to monitor and visualize their social media performance metrics. It integrates with the YouTube API to fetch real-time data about creators and their posts. The app features a dynamic color scheme that updates based on the creator's profile picture, provides a search functionality for fetching specific creator's information, and displays the latest posts with engaging animations.

## Features

- **Dynamic Color Scheme**: Utilizes `PaletteGenerator` to dynamically adjust the app's color scheme based on the creator's profile picture.
- **Real-time Data Fetching**: Integrates with the YouTube API through `YoutubeApiService` to fetch the latest information about creators and their posts.
- **Animated Widgets**: Uses `Lottie` for loading animations and custom animations for creator and post cards (`CreatorCardAnimated`, `PostCardAnimated`).
- **Interactive Charts**: Visualizes viewership data with interactive charts (`ViewersChart1`, `ViewersChart2`, `ViewersChart3`) displaying views, likes, and comments over time.

## Getting Started

### Prerequisites

- Flutter installed on your system.
- An active YouTube API key to fetch data.

### Installation

1. Clone the repository to your local machine.
2. Inside the project directory, run `flutter pub get` to install dependencies.
3. Create a `.env` file at the root of your project and add your YouTube API key as `YOUTUBE_API_KEY=your_api_key_here`.
4. Run the app on your device or emulator using `flutter run`.

### Usage

- Launch the app, and you will be greeted with a search bar.
- Enter a YouTube channel name to fetch and display information about the creator and their latest posts.
- Interact with the animated cards and charts to get insights into the creator's performance.

## Widgets and Services

- **Widgets**: `CreatorCard`, `SearchBar`, `ViewChart`, `PostCard`.
- **Services**: `YoutubeApiService` for fetching data from YouTube.

## Dependencies

- `flutter`: SDK for building natively compiled applications.
- `palette_generator`: For generating color schemes based on images.
- `lottie`: For displaying animations from Lottie files.

## Contributions

Contributions are welcome. Please open an issue first to discuss what you would like to change or add.

## License

[MIT License](LICENSE) - see the LICENSE file for details.
