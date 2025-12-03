class HomeResponse {
  final Header header;
  final ContinueWatching continueWatching;
  final YogaCategories yogaCategories;
  final PopularVideos popularVideos;

  HomeResponse({
    required this.header,
    required this.continueWatching,
    required this.yogaCategories,
    required this.popularVideos,
  });

  factory HomeResponse.fromJson(Map<String, dynamic> json) {
    return HomeResponse(
      header: Header.fromJson(json['header']),
      continueWatching: ContinueWatching.fromJson(json['continueWatching']),
      yogaCategories: YogaCategories.fromJson(json['yogaCategories']),
      popularVideos: PopularVideos.fromJson(json['popularVideos']),
    );
  }
}

class Header {
  final String greeting;
  final int notificationCount;
  final String searchPlaceholder;
  final bool shareEnabled;

  Header({
    required this.greeting,
    required this.notificationCount,
    required this.searchPlaceholder,
    required this.shareEnabled,
  });

  factory Header.fromJson(Map<String, dynamic> json) {
    return Header(
      greeting: json['greeting'] ?? '',
      notificationCount: json['notificationCount'] ?? 0,
      searchPlaceholder: json['searchPlaceholder'] ?? 'Search',
      shareEnabled: json['shareEnabled'] ?? false,
    );
  }
}

class ContinueWatching {
  final ContinueWatchingItem current;
  final ContinueWatchingItem next;
  final String viewAllLink;

  ContinueWatching({
    required this.current,
    required this.next,
    required this.viewAllLink,
  });

  factory ContinueWatching.fromJson(Map<String, dynamic> json) {
    return ContinueWatching(
      current: ContinueWatchingItem.fromJson(json['current']),
      next: ContinueWatchingItem.fromJson(json['next']),
      viewAllLink: json['viewAllLink'] ?? '',
    );
  }
}

class ContinueWatchingItem {
  final String id;
  final String title;
  final List<String> tags;
  final String imageUrl;

  ContinueWatchingItem({
    required this.id,
    required this.title,
    required this.tags,
    required this.imageUrl,
  });

  factory ContinueWatchingItem.fromJson(Map<String, dynamic> json) {
    return ContinueWatchingItem(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}

class YogaCategories {
  final List<YogaCategory> list;
  final String viewAllLink;

  YogaCategories({
    required this.list,
    required this.viewAllLink,
  });

  factory YogaCategories.fromJson(Map<String, dynamic> json) {
    return YogaCategories(
      list: (json['list'] as List<dynamic>?)
          ?.map((item) => YogaCategory.fromJson(item))
          .toList() ??
          [],
      viewAllLink: json['viewAllLink'] ?? '',
    );
  }
}

class YogaCategory {
  final String id;
  final String name;
  final int workouts;
  final String iconUrl;

  YogaCategory({
    required this.id,
    required this.name,
    required this.workouts,
    required this.iconUrl,
  });

  factory YogaCategory.fromJson(Map<String, dynamic> json) {
    return YogaCategory(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      workouts: json['workouts'] ?? 0,
      iconUrl: json['iconUrl'] ?? '',
    );
  }
}

class PopularVideos {
  final List<PopularVideo> list;
  final String seeAllLink;

  PopularVideos({
    required this.list,
    required this.seeAllLink,
  });

  factory PopularVideos.fromJson(Map<String, dynamic> json) {
    return PopularVideos(
      list: (json['list'] as List<dynamic>?)
          ?.map((item) => PopularVideo.fromJson(item))
          .toList() ??
          [],
      seeAllLink: json['seeAllLink'] ?? '',
    );
  }
}

class PopularVideo {
  final String id;
  final String title;
  final VideoStats stats;
  final String details;
  final String thumbnailUrl;

  PopularVideo({
    required this.id,
    required this.title,
    required this.stats,
    required this.details,
    required this.thumbnailUrl,
  });

  factory PopularVideo.fromJson(Map<String, dynamic> json) {
    return PopularVideo(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      stats: VideoStats.fromJson(json['stats']),
      details: json['details'] ?? '',
      thumbnailUrl: json['thumbnailUrl'] ?? '',
    );
  }
}

class VideoStats {
  final int kcal;
  final int durationMin;

  VideoStats({
    required this.kcal,
    required this.durationMin,
  });

  factory VideoStats.fromJson(Map<String, dynamic> json) {
    return VideoStats(
      kcal: json['kcal'] ?? 0,
      durationMin: json['durationMin'] ?? 0,
    );
  }
}