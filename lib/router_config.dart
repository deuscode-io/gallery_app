import 'package:gallery_app/features/detail/detail_page.dart';
import 'package:gallery_app/features/gallery/gallery_page.dart';
import 'package:go_router/go_router.dart';

final routerConfig = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const GalleryPage(),
    ),
    GoRoute(
      path: '/details',
      builder: (context, state) => DetailPage(
        imageUrl: state.extra as String,
      ),
    ),
  ],
);
