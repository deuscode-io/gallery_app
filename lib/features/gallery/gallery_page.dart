import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gallery_app/features/widgets/metric_groups.dart';
import 'package:gallery_app/features/widgets/search_field.dart';
import 'package:go_router/go_router.dart';

const _minimumDefaultGridItemSize = 120.0;
const _bottomBarHeight = 36.0;

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  late ({
    int crossAxisCount,
    double size,
    double childAspectRatio
  }) _gridViewSizeRecord;

  @override
  Widget build(BuildContext context) {
    _gridViewSizeRecord = _measure();
    return Scaffold(
      backgroundColor: const Color(0xFFE1DFDF),
      body: Scrollbar(
        child: CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            SliverAppBar(
              floating: true,
              title: SearchField(
                onSearch: (text) {
                  print('Search $text');
                },
              ),
            ),
            AppGridView(
              crossAxisCount: _gridViewSizeRecord.crossAxisCount,
              size: _gridViewSizeRecord.size,
              childAspectRatio: _gridViewSizeRecord.childAspectRatio,
            ),
          ],
        ),
      ),
    );
  }

  ({int crossAxisCount, double size, double childAspectRatio}) _measure() {
    final screenWidth = MediaQuery.of(context).size.width;
    final count = (screenWidth / _minimumDefaultGridItemSize).floor();
    final crossAxisCount = count > 0 ? count : 1;
    final size = (screenWidth / crossAxisCount).floorToDouble();
    final fullSize = size + _bottomBarHeight;
    final childAspectRatio = double.parse(
      (size / fullSize).toString().substring(0, 5),
    );

    return (
      crossAxisCount: crossAxisCount,
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
  });

  final int crossAxisCount;
  final double size;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    final photos = List.generate(50, (index) => index);
    const url =
        'https://pixabay.com/get/gbe906b42ebbb0c324cbf9d1e6071c79da05b40e3497ae258156360f6dfaad9c3ffe09f412faa63628d1e94bbfacf96e23557cbec815c4a1500ec5f9dfefdd5ea_1280.jpg';

    return SliverGrid.builder(
      itemCount: photos.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        mainAxisSpacing: 1,
        crossAxisSpacing: 1,
      ),
      itemBuilder: (context, index) {
        return Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: _bottomBarHeight),
              child: InkWell(
                child: AspectRatio(
                  aspectRatio: 1 / 1,
                  child: Hero(
                    tag: url,
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      placeholder: (_, __) {
                        return Container(
                          color: Colors.black12,
                          child: const Center(
                            child: Icon(Icons.cloud_download_outlined),
                          ),
                        );
                      },
                      errorWidget: (_, __, ___) {
                        return Container(
                          color: Colors.black12,
                          child: const Center(
                            child: Icon(Icons.cloud_off),
                          ),
                        );
                      },
                      imageUrl: url,
                    ),
                  ),
                ),
                onTap: () {
                  context.push('/details', extra: url);
                  print('photo tap');
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: size - 1),
              padding: const EdgeInsets.symmetric(horizontal: 2),
              height: _bottomBarHeight,
              color: Colors.red,
              child: MetricGroups(
                likesValue: 19,
                viewsValue: 5,
                onLikesTap: () {},
                onViewsTap: () {},
              ),
            )
          ],
        );
      },
    );
  }
}
