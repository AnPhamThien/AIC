import 'package:flutter/material.dart';
import '../../data_local/markup_model.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    List<User> searchedUser =
        User.getSearchedUser(); //TODO mốt chuyển vào controller nè
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          fit: StackFit.loose,
          children: [
            FloatingSearchBar(
              margins: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              backgroundColor: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(25),
              elevation: 0,
              hint: 'Search...', //TODO nhét từ vừa search vào đây
              physics: const BouncingScrollPhysics(),
              openAxisAlignment: 0.0,
              debounceDelay: const Duration(milliseconds: 500),
              onQueryChanged: (query) {
                // Call your model, bloc, controller here.
              },
              leadingActions: const [
                FloatingSearchBarAction(
                  showIfClosed: true,
                  child: Icon(Icons.search_rounded),
                ),
              ],
              automaticallyImplyBackButton: false,
              transition: CircularFloatingSearchBarTransition(),
              actions: [
                FloatingSearchBarAction.searchToClear(
                  showIfClosed: false,
                ),
              ],
              isScrollControlled: true,
              builder: (context, transition) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.white,
                  ),
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: searchedUser
                        .length, //TODO: độ dài list user đã từng search ở đây
                    itemBuilder: (_, index) {
                      final User user =
                          searchedUser[index]; //TODO: moi user ra ở đây
                      return getUserItem(user);
                    },
                  ),
                );
              },
              //lịch sử search
              body: Padding(
                padding: const EdgeInsets.only(top: 60),
                child: ListView.builder(
                  itemCount: searchedUser
                      .length, //TODO: độ dài list user đã từng search ở đây
                  itemBuilder: (_, index) {
                    final User user =
                        searchedUser[index]; //TODO: moi user ra ở đây
                    return getUserItem(user);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ListTile getUserItem(User user) {
    return ListTile(
      contentPadding: const EdgeInsets.fromLTRB(20, 13, 10, 0),
      leading: Container(
        width: 55,
        height: 55,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black54),
          shape: BoxShape.circle,
        ),
        child: CircleAvatar(
          child: ClipOval(
            child: Image(
              image: AssetImage(user.img),
              height: 55,
              width: 55,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      title: Text(
        user.userName,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(user.userRealName),

      ///options
      trailing: IconButton(
        splashRadius: 30,
        onPressed: () {
          //TODO xóa user khi nhấn vào button này
        },
        icon: const Icon(
          Icons.clear_rounded,
          color: Colors.grey,
          size: 20,
        ),
      ),
    );
  }
}
