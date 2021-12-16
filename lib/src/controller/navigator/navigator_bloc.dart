import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavigatorBloc extends Bloc<NavigateToPageEvent, dynamic> {
  final GlobalKey<NavigatorState> navigatorKey;

  NavigatorBloc(this.navigatorKey) : super(0) {
    on<NavigateToPageEvent>(_onNavigate);
  }

  void _onNavigate(NavigateToPageEvent event, Emitter emit) async {
    navigatorKey.currentState!.pushNamed(event.route);
  }
}

class NavigateToPageEvent {
  String route;
  NavigateToPageEvent(this.route);
}
