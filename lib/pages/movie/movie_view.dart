import 'package:carousel_slider/carousel_slider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:novel/pages/movie/movie_model.dart';
import 'package:novel/pages/movie_search/searchBarDelegate.dart';
import 'package:novel/router/app_pages.dart';
import 'package:novel/utils/screen_device.dart';

import 'movie_controller.dart';

class MoviePage extends GetView<MovieController> {
  MoviePage({Key? key}) : super(key: key);
  double? bodyImageWidth = .0;
  double aspect = .4;

  @override
  Widget build(BuildContext context) {
    bodyImageWidth = getDeviceWidth(context) / 4;

    return Obx(() => controller.initOk.isTrue
        ? Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text("Movie"),
              actions: [
                IconButton(
                    onPressed: () {
                      showSearch(
                          context: context, delegate: searchBarDelegate());
                    },
                    icon: Icon(Icons.search)),
                SizedBox(
                  width: 3,
                )
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: 50,
                ),
                child: Column(
                  children: [_buildHead()]..addAll(_buildBody()),
                ),
              ),
            ),
          )
        : Container());
  }

  Widget _buildHead() {
    return CarouselSlider(
      items: controller.models[0].map((e) => headerImageItem(e)).toList(),
      options: CarouselOptions(
        aspectRatio: 2.0,
        enlargeCenterPage: true,
        enableInfiniteScroll: true,
        initialPage: 0,
        autoPlay: true,
      ),
    );
  }

  List<Widget> _buildBody() {
    List<Widget> bodies = [];
    List<String> tags = ["每日更新", "最新美剧", "科幻", "恐怖", "喜剧", "剧情"];
    List<String> keys = [
      "last-update",
      "all_mj",
      "kehuanpian",
      "kongbupian",
      "xijupian",
      "juqingpian"
    ];
    Iterable<List<MovieModel>> skip = controller.models.skip(1);
    for (var i = 0; i < skip.length; i++) {
      var value = skip.elementAt(i);

      bodies.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                tags[i],
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              Spacer(),
              // TextButton(onPressed: () {}, child: Text("see more"))
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            height: 200 * aspect,
            child: ListView.builder(
              shrinkWrap: true,
              itemBuilder: (c, i) {
                var e = value[i];
                return headerImageItem(e, width: 150);
              },
              itemCount: value.length,
              scrollDirection: Axis.horizontal,
            ),
          ),
          SizedBox(
            height: 15,
          ),
        ],
      ));
    }

    return bodies;
  }

  Widget headerImageItem(MovieModel movieModel, {double width = 1000.0}) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.Movie + AppRoutes.MovieDetail,
            arguments: {"key": movieModel.id, "name": movieModel.name ?? ""});
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            child: Stack(
              children: <Widget>[
                ExtendedImage.network(
                  movieModel.cover ?? "",
                  width: width,
                  fit: BoxFit.fitWidth,
                  height: width * aspect,
                ),
                Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(200, 0, 0, 0),
                          Color.fromARGB(0, 0, 0, 0)
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    child: Text(
                      ' ${movieModel.name ?? ""}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
