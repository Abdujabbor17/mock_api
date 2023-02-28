import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mock_api/service/user_service.dart';
import 'package:mock_api/view/widgets/addItem.dart';
import 'package:mock_api/view/widgets/user_item.dart';

import '../service/utils_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        actions: [
          IconButton(onPressed: () async {
            await showDialog(
              context: context,
              builder: (BuildContext context) {
                return MyDialog();
              },
            );
            setState(() {});

          },

              icon: const Icon(Icons.add))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder(
          future: UserService.getUsers(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return userItem(context, snapshot.data![index],
                    delete: (){
                      _deleteUser(snapshot.data![index].id);
                    }

                    );
                  });
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text('No data'),
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  void _deleteUser(String id) async {
    bool result =
        await UserService.deleteUser(id);
    if (result) {
      setState(() {});
      Utils.snackBarSuccess(
          'Deleted successfully', context);
    } else {
      Utils.snackBarError('Someting is wrong', context);
    }
  }

}
