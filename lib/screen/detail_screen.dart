import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sosmedic/data/api_service.dart';
import 'package:sosmedic/provider/detail_story_provider.dart';
import 'package:sosmedic/utils/result_state.dart';

class DetailScreen extends StatelessWidget {
  final String idstory;
  const DetailScreen({super.key, required this.idstory});

  @override
  Widget build(BuildContext context) {
    print("idStory : $idstory");
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   final restoDetailProvider =
    //       Provider.of<DetailStoryProvider>(context, listen: false);
    //   restoDetailProvider.getDetailStory(idstory);
    // });
    return Scaffold(
      appBar: AppBar(title: const Text("detail Screens")),
      body: ChangeNotifierProvider<DetailStoryProvider>(
        create: (context) => DetailStoryProvider(idstory, ApiService()),
        child:
            Consumer<DetailStoryProvider>(builder: (context, provider, child) {
          switch (provider.state) {
            case ResultState.loading:
              return const Center(child: CircularProgressIndicator());
            case ResultState.hasData:
              return Column(
                children: [
                  // Image.network(
                  //   "${provider.detailStory.photoUrl}",
                  // )
                  Center(child: Text(provider.detailStory.name!))
                ],
              );
            case ResultState.error:
              Fluttertoast.showToast(msg: provider.messageResponse);
              return Container();
            default:
              return Container();
          }
        }),
      ),
    );
  }
}
