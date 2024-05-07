import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery_app/DI/injector.dart';
import 'package:gallery_app/features/gallery/data/models/media_hit.dart';
import 'package:gallery_app/features/gallery/presentation/blocs/media_bloc.dart';
import 'package:gallery_app/features/gallery/presentation/blocs/media_event.dart';
import 'package:gallery_app/features/gallery/presentation/blocs/media_state.dart';
import 'package:gallery_app/features/gallery/presentation/widgets/app_network_image.dart';
import 'package:gallery_app/features/gallery/presentation/widgets/metric_groups.dart';
import 'package:gallery_app/features/gallery/presentation/widgets/search_field.dart';
import 'package:go_router/go_router.dart';

const _minimumDefaultGridItemSize = 120.0;
const _bottomBarHeight = 36.0;

typedef GridViewSize = ({
  int crossAxisCount,
  int perPage,
  double size,
  double childAspectRatio
});

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  late GridViewSize _gridViewSize;
  late ScrollController _scrollController;
  late MediaBloc _mediaBloc;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent) {
        _mediaBloc.add(ReachScrollEnd());
      }
    });
    _mediaBloc = Injector.get();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _gridViewSize = _measure();
    return Scaffold(
      backgroundColor: const Color(0xFFE1DFDF),
      body: BlocProvider<MediaBloc>(
        create: (_) {
          _mediaBloc.add(
            OpenPage(
              perPage: _gridViewSize.perPage,
              query: '',
            ),
          );

          return _mediaBloc;
        },
        child: BlocBuilder<MediaBloc, MediaState>(
          builder: (context, state) {
            return Scrollbar(
              controller: _scrollController,
              child: CustomScrollView(
                controller: _scrollController,
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                slivers: [
                  SliverAppBar(
                    floating: true,
                    title: SearchField(
                      onSearch: (text) => _mediaBloc.add(NewQuery(text)),
                    ),
                  ),
                  if (state.exception != null)
                    LoadedFailure(
                      onPressed: () => _mediaBloc.add(ReloadButtonPressed()),
                    ),
                  if (state.loading && state.media.isEmpty)
                    const InitialLoading(),
                  if (!state.loading && state.media.isEmpty)
                    const LoadedEmpty(),
                  AppGridView(
                    crossAxisCount: _gridViewSize.crossAxisCount,
                    size: _gridViewSize.size,
                    childAspectRatio: _gridViewSize.childAspectRatio,
                    media: [
                      ...state.media,
                      if (state.loading) MediaLoading(),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  GridViewSize _measure() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    var crossAxisCount = (screenWidth / _minimumDefaultGridItemSize).floor();
    if (crossAxisCount == 0) crossAxisCount = 1;

    var mainAxisCount =
        (screenHeight / (_minimumDefaultGridItemSize + _bottomBarHeight))
            .floor();
    if (mainAxisCount == 0) mainAxisCount = 1;

    final perPage =
        min(crossAxisCount * mainAxisCount + crossAxisCount * 2, 200);

    final size = (screenWidth / crossAxisCount).floorToDouble();
    final fullSize = size + _bottomBarHeight;
    final childAspectRatio = double.parse(
      (size / fullSize).toString().substring(0, 5),
    );

    return (
      crossAxisCount: crossAxisCount,
      perPage: perPage,
      size: size,
      childAspectRatio: childAspectRatio,
    );
  }
}

class AppGridView extends StatelessWidget {
  const AppGridView({
    super.key,
    required this.crossAxisCount,
    required this.size,
    required this.childAspectRatio,
    required this.media,
  });

  final int crossAxisCount;
  final double size;
  final double childAspectRatio;
  final List<MediaContent> media;

  @override
  Widget build(BuildContext context) {
    return SliverGrid.builder(
      itemCount: media.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        mainAxisSpacing: 1,
        crossAxisSpacing: 1,
      ),
      itemBuilder: (context, index) {
        final mediaContent = media[index];

        if (mediaContent is MediaHit) {
          return Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: _bottomBarHeight),
                child: InkWell(
                  child: AspectRatio(
                    aspectRatio: 1 / 1,
                    child: Hero(
                      tag: mediaContent.largeImageURL,
                      child: AppNetworkImage(
                        url: mediaContent.previewURL,
                      ),
                    ),
                  ),
                  onTap: () {
                    context.push(
                      '/details',
                      extra: mediaContent.largeImageURL,
                    );
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: size - 1),
                padding: const EdgeInsets.symmetric(horizontal: 2),
                height: _bottomBarHeight,
                child: MetricGroups(
                  likesValue: mediaContent.likes,
                  viewsValue: mediaContent.views,
                  onLikesTap: () {},
                  onViewsTap: () {},
                ),
              )
            ],
          );
        }

        return const Center(child: CupertinoActivityIndicator());
      },
    );
  }
}

class InitialLoading extends StatelessWidget {
  const InitialLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverFillRemaining(
      child: Center(
        child: CupertinoActivityIndicator(
          radius: 20,
        ),
      ),
    );
  }
}

class LoadedEmpty extends StatelessWidget {
  const LoadedEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Center(
        child: Text(
          'Nothing found',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}

class LoadedFailure extends StatelessWidget {
  const LoadedFailure({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Center(
        child: ElevatedButton(
          onPressed: onPressed,
          child: Text(
            'Reload content',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
      ),
    );
  }
}
