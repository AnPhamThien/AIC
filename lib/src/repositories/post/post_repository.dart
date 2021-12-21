import 'dart:developer';

import 'package:imagecaptioning/src/model/post/data.dart';
import 'package:imagecaptioning/src/model/post/post_list_respone.dart';

import '../data_repository.dart';

abstract class PostBehavior {
  Future<Data?> getPost(int postPerPerson, int limitDay);
}

class PostRepository extends PostBehavior {
  final DataRepository _dataRepository = DataRepository();

  @override
  Future<Data?> getPost(int postPerPerson, int limitDay) async {
    try {
      final PostListRespone respone =
          await _dataRepository.getPost(postPerPerson, limitDay);
      final Data? data = respone.data;
      print('object');
      return data;
    } catch (e) {
      //return null;
      log(e.toString());
    }
  }
}
