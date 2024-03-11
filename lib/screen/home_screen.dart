import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sosmedic/data/api_service.dart';
import 'package:sosmedic/provider/story_provider.dart';
import 'package:sosmedic/utils/auth_preference.dart';
import 'package:sosmedic/utils/result_state.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  final Function() onLogout;
  const HomeScreen({super.key, required this.onLogout});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              var authProf = AuthPreference();
              await authProf.setUserToken("");
              widget.onLogout();
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: ChangeNotifierProvider<StoryProvider>(
        create: (context) => StoryProvider(ApiService()),
        child: Consumer<StoryProvider>(
          builder: (context, provider, child) {
            switch (provider.stateGetStories) {
              case ResultState.loading:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case ResultState.hasData:
                return RefreshIndicator(
                  child: ListView.builder(
                    itemCount: provider.storiesData.length,
                    itemBuilder: (context, index) {
                      var story = provider.storiesData[index];
                      print("story : $story");
                      String formattedDate =
                          DateFormat('dd-MM-yy').format(story.createdAt);
                      return Card(
                        elevation: 3,
                        margin: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Image Section
                            Container(
                              height: 300, // adjust height as needed
                              width: double.infinity,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(story.photoUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            // User Section
                            ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(story.photoUrl),
                              ),
                              title: Text(
                                story.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(formattedDate),
                              // or any other relevant information
                              trailing: IconButton(
                                icon: Icon(Icons.more_vert),
                                onPressed: () {
                                  // Add your action when the menu icon is pressed
                                },
                              ),
                            ),
                            // Caption Section
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Text(
                                story.description,
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            // Like and Comment Section
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.location_on),
                                      SizedBox(width: 4),
                                      Text("Long:"),
                                      SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          story.lon != null
                                              ? story.lon.toString()
                                              : "0",
                                          overflow: TextOverflow
                                              .ellipsis, // Handles overflow by showing ellipsis
                                        ),
                                      ),
                                      SizedBox(
                                          width:
                                              24), // Adjust as needed for spacing
                                      Text("Lat:"),
                                      SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          story.lat != null
                                              ? story.lat.toString()
                                              : "0",
                                          overflow: TextOverflow
                                              .ellipsis, // Handles overflow by showing ellipsis
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                  onRefresh: () => provider.allStories(),
                );
              case ResultState.error:
                Fluttertoast.showToast(msg: provider.messageGetStories);
                return Container(); // or any error UI widget
              default:
                return Container(); // Handle other states if needed
            }
          },
        ),
      ),
      floatingActionButton:
          OutlinedButton(onPressed: () {}, child: const Text("Add Story")),
    );
  }
}
