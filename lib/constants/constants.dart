import 'package:converse/pages/feed/feed_screen.dart';
import 'package:converse/pages/post/screens/add_post_screen.dart';

class Constants {
  static const avatarDefault =
      "https://cdn.pixabay.com/photo/2018/11/13/22/01/avatar-3814081_1280.png";
  static const bannerDefault =
      "https://cdn.pixabay.com/photo/2016/10/04/17/12/banner-1714906_1280.jpg";
  static const displayPicDefault =
      "https://cdn.pixabay.com/photo/2017/07/18/23/40/group-2517459_1280.png";

  static const tabWidgets = [
    FeedScreen(),
    AddPostScreen(),
  ];

  static const awardsPath = 'assets/images/pngs/awards';

  static const awards = {
    'awesomeAns': '${Constants.awardsPath}/awesomeanswer.png',
    'gold': '${Constants.awardsPath}/gold.png',
    'platinum': '${Constants.awardsPath}/platinum.png',
    'helpful': '${Constants.awardsPath}/helpful.png',
    'plusone': '${Constants.awardsPath}/plusone.png',
    'rocket': '${Constants.awardsPath}/rocket.png',
    'thankyou': '${Constants.awardsPath}/thankyou.png',
    'til': '${Constants.awardsPath}/til.png',
  };
}
