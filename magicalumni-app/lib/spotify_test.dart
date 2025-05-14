
// import 'package:flutter/material.dart';
// import 'package:spotify_sdk/spotify_sdk.dart';

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;
//   bool _connected = false;
//   bool _isPlaying = false;

//   final String _clientId = '817d7cfb8d0a44daa72faf677dc96e7c';
//   final String _redirectUri = 'spotify.test://callback';
//   final String _episodeUri = 'spotify:episode:2X40qI5Tw7JkXljpUl3QZC'; // Replace with your own

//  Future<void> connectToSpotify() async {
//     try {
//       bool result = await SpotifySdk.connectToSpotifyRemote(
//         clientId: _clientId,
//         redirectUrl: _redirectUri,
//       );
//       setState(() {
//         _connected = result;
//       });
//       print('✅ Connected to Spotify');
//     } catch (e) {
//       print('❌ Could not connect: $e');
//     }
//   }
//   Future<void> playPodcast() async {
//     try {
//       await SpotifySdk.play(spotifyUri: _episodeUri);
//       setState(() {
//         _isPlaying = true;
//       });
//     } catch (e) {
//       print('❌ Could not play: $e');
//     }
//   }

//   Future<void> pausePodcast() async {
//     try {
//       await SpotifySdk.pause();
//       setState(() {
//         _isPlaying = false;
//       });
//     } catch (e) {
//       print('❌ Could not pause: $e');
//     }
//   }

//   Widget _buildControlButtons() {
//     if (!_connected) {
//       return ElevatedButton(
//         onPressed: connectToSpotify,
//         child: Text("Connect to Spotify"),
//       );
//     }

//     return Column(
//       children: [
//         ElevatedButton(
//           onPressed: _isPlaying ? pausePodcast : playPodcast,
//           child: Text(_isPlaying ? "Pause" : "Play Podcast"),
//         ),
//         SizedBox(height: 10),
//         Text(
//           "Playing Episode:\n$_episodeUri",
//           textAlign: TextAlign.center,
//         ),
//       ],
//     );
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         // TRY THIS: Try changing the color here to a specific color (to
//         // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
//         // change color while the other colors stay the same.
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: _buildControlButtons(),
//        // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
