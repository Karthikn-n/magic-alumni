// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedNavigatorGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter/foundation.dart' as _i10;
import 'package:flutter/material.dart' as _i9;
import 'package:flutter/material.dart';
import 'package:magic_alumni/model/news_model.dart' as _i11;
import 'package:magic_alumni/ui/views/app-view/app_view.dart' as _i3;
import 'package:magic_alumni/ui/views/events/create-event/create_event_view.dart'
    as _i5;
import 'package:magic_alumni/ui/views/events/event_detail.dart' as _i7;
import 'package:magic_alumni/ui/views/jobs/create-job/create_job_view.dart'
    as _i6;
import 'package:magic_alumni/ui/views/login/login_view.dart' as _i4;
import 'package:magic_alumni/ui/views/news/news_detail_view.dart' as _i8;
import 'package:magic_alumni/ui/views/signup/signup_view.dart' as _i2;
import 'package:stacked/stacked.dart' as _i1;
import 'package:stacked_services/stacked_services.dart' as _i12;

class Routes {
  static const signupView = '/signup-view';

  static const appView = '/app-view';

  static const loginView = '/';

  static const createEventView = '/create-event-view';

  static const createJobView = '/create-job-view';

  static const eventsDetailView = '/events-detail-view';

  static const newsDetailView = '/news-detail-view';

  static const all = <String>{
    signupView,
    appView,
    loginView,
    createEventView,
    createJobView,
    eventsDetailView,
    newsDetailView,
  };
}

class StackedRouter extends _i1.RouterBase {
  final _routes = <_i1.RouteDef>[
    _i1.RouteDef(
      Routes.signupView,
      page: _i2.SignupView,
    ),
    _i1.RouteDef(
      Routes.appView,
      page: _i3.AppView,
    ),
    _i1.RouteDef(
      Routes.loginView,
      page: _i4.LoginView,
    ),
    _i1.RouteDef(
      Routes.createEventView,
      page: _i5.CreateEventView,
    ),
    _i1.RouteDef(
      Routes.createJobView,
      page: _i6.CreateJobView,
    ),
    _i1.RouteDef(
      Routes.eventsDetailView,
      page: _i7.EventsDetailView,
    ),
    _i1.RouteDef(
      Routes.newsDetailView,
      page: _i8.NewsDetailView,
    ),
  ];

  final _pagesMap = <Type, _i1.StackedRouteFactory>{
    _i2.SignupView: (data) {
      return _i9.MaterialPageRoute<dynamic>(
        builder: (context) => const _i2.SignupView(),
        settings: data,
      );
    },
    _i3.AppView: (data) {
      return _i9.MaterialPageRoute<dynamic>(
        builder: (context) => const _i3.AppView(),
        settings: data,
      );
    },
    _i4.LoginView: (data) {
      return _i9.MaterialPageRoute<dynamic>(
        builder: (context) => const _i4.LoginView(),
        settings: data,
      );
    },
    _i5.CreateEventView: (data) {
      return _i9.MaterialPageRoute<dynamic>(
        builder: (context) => const _i5.CreateEventView(),
        settings: data,
      );
    },
    _i6.CreateJobView: (data) {
      return _i9.MaterialPageRoute<dynamic>(
        builder: (context) => const _i6.CreateJobView(),
        settings: data,
      );
    },
    _i7.EventsDetailView: (data) {
      return _i9.MaterialPageRoute<dynamic>(
        builder: (context) => const _i7.EventsDetailView(),
        settings: data,
      );
    },
    _i8.NewsDetailView: (data) {
      final args = data.getArgs<NewsDetailViewArguments>(nullOk: false);
      return _i9.MaterialPageRoute<dynamic>(
        builder: (context) => _i8.NewsDetailView(
            key: args.key, news: args.news, index: args.index),
        settings: data,
      );
    },
  };

  @override
  List<_i1.RouteDef> get routes => _routes;

  @override
  Map<Type, _i1.StackedRouteFactory> get pagesMap => _pagesMap;
}

class NewsDetailViewArguments {
  const NewsDetailViewArguments({
    this.key,
    required this.news,
    required this.index,
  });

  final _i10.Key? key;

  final _i11.NewsModel news;

  final int index;

  @override
  String toString() {
    return '{"key": "$key", "news": "$news", "index": "$index"}';
  }

  @override
  bool operator ==(covariant NewsDetailViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.news == news && other.index == index;
  }

  @override
  int get hashCode {
    return key.hashCode ^ news.hashCode ^ index.hashCode;
  }
}

extension NavigatorStateExtension on _i12.NavigationService {
  Future<dynamic> navigateToSignupView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.signupView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToAppView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.appView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToLoginView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.loginView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToCreateEventView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.createEventView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToCreateJobView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.createJobView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToEventsDetailView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.eventsDetailView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToNewsDetailView({
    _i10.Key? key,
    required _i11.NewsModel news,
    required int index,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.newsDetailView,
        arguments: NewsDetailViewArguments(key: key, news: news, index: index),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithSignupView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.signupView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithAppView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.appView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithLoginView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.loginView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithCreateEventView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.createEventView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithCreateJobView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.createJobView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithEventsDetailView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.eventsDetailView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithNewsDetailView({
    _i10.Key? key,
    required _i11.NewsModel news,
    required int index,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.newsDetailView,
        arguments: NewsDetailViewArguments(key: key, news: news, index: index),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }
}
