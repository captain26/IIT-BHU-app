import 'dart:io';
import 'package:flutter/material.dart';
import 'package:iit_app/external_libraries/spin_kit.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:iit_app/model/colorConstants.dart';
import 'package:iit_app/pages/club/clubPage.dart';
import 'package:iit_app/ui/club_council_common/description.dart';
import 'package:iit_app/ui/separator.dart';
import 'package:iit_app/ui/text_style.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:iit_app/pages/account/accountPage.dart';

class ClubAndCouncilWidgets {
  static Widget getPanelBackground(
    BuildContext context,
    File largeLogoFile, {
    bool isCouncil = false,
    BuiltCouncilPost councilDetail,
    bool isClub = false,
    BuiltClubPost clubDetail,
  }) {
    assert((isCouncil == true && isClub == false) || (isCouncil == false && isClub == true));

    final bottom = MediaQuery.of(context).viewInsets.bottom;
    dynamic _data = isCouncil ? councilDetail : clubDetail;

    final _secy = isCouncil ? councilDetail?.gensec : clubDetail?.secy;
    final _jointSecy = isCouncil ? councilDetail?.joint_gensec : clubDetail?.joint_secy;

    return Container(
      color: ColorConstants.workshopContainerBackground,
      height: MediaQuery.of(context).size.height * 0.90,
      child: _data == null
          ? Container(
              height: MediaQuery.of(context).size.height * 3 / 4,
              child: Center(
                child: LoadingCircle,
              ),
            )
          : ListView(
              shrinkWrap: true,
              children: [
                Stack(
                  children: [
                    Container(
                      child: largeLogoFile == null
                          ? Image.network(_data.large_image_url, fit: BoxFit.cover, height: 300.0)
                          : Image.file(largeLogoFile, fit: BoxFit.cover, height: 300.0),
                      constraints: BoxConstraints.expand(height: 295.0),
                    ),
                    ClubAndCouncilWidgets.getGradient(),
                    Container(
                      padding: EdgeInsets.fromLTRB(0.0, 72.0, 0.0, 0.0),
                      child: ClubAndCouncilWidgets.getTitleCard(
                          title: _data.name,
                          id: _data.id,
                          imageUrl: _data.large_image_url,
                          isCouncil: isCouncil,
                          context: context),
                    ),
                    ClubAndCouncilWidgets.getToolbar(context),
                  ],
                ),
                SizedBox(height: 8.0),
                Padding(
                  padding: EdgeInsets.only(bottom: bottom),
                  child: Description(map: _data, isCouncil: isCouncil, isClub: isClub),
                ),
                SizedBox(height: 15.0),
                ClubAndCouncilWidgets.getSecies(context, secy: _secy, jointSecy: _jointSecy),
                _data == null ? Container() : ClubAndCouncilWidgets.getSocialLinks(_data),
                SizedBox(height: 2 * ClubAndCouncilWidgets.getMinPanelHeight(context)),
              ],
            ),
    );
  }

  static double getMinPanelHeight(context) {
    return MediaQuery.of(context).size.height / 10;
  }

  static double getMaxPanelHeight(context) {
    return MediaQuery.of(context).size.height / 1.1;
  }

  static Container getSocialLinks(map) {
    _launchURL(String url) {
      print('URL: ${url}');
      launch(url);
    }

    Column _buildButtonColumn(IconData icon, String label, String url,
        {Color color = Colors.white}) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              icon: Icon(
                icon,
                color: color,
                size: 25.0,
              ),
              onPressed: () => _launchURL(url)),
          /*Container(
            margin: const EdgeInsets.only(top: 8),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: color,
              ),
            ),
          ),*/
        ],
      );
    }

    return Container(
      height: 100,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      /*decoration: BoxDecoration(
          color: Color(0xFF736AB7),
          borderRadius: BorderRadius.all(Radius.circular(10))),*/
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          map.youtube_url == null || map.youtube_url.length == 0
              ? Container()
              : _buildButtonColumn(FontAwesomeIcons.youtube, 'YouTube', map.youtube_url),
          map.website_url == null || map.website_url.length == 0
              ? Container()
              : _buildButtonColumn(Icons.web, 'Website', map.website_url),
          map.linkedin_url == null || map.linkedin_url.length == 0
              ? Container()
              : _buildButtonColumn(FontAwesomeIcons.linkedin, 'LinkedIn', map.linkedin_url),
          map.instagram_url == null || map.instagram_url.length == 0
              ? Container()
              : _buildButtonColumn(FontAwesomeIcons.instagram, 'Instagram', map.instagram_url),
          map.facebook_url == null || map.facebook_url.length == 0
              ? Container()
              : _buildButtonColumn(FontAwesomeIcons.facebook, 'Facebook', map.facebook_url),
          map.twitter_url == null || map.twitter_url.length == 0
              ? Container()
              : _buildButtonColumn(FontAwesomeIcons.twitter, 'Twitter', map.twitter_url),
        ],
      ),
    );
  }

  static Container getSecies(BuildContext context, {secy, jointSecy}) {
    return Container(
      margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: ColorConstants.porHolderBackground,
      ),
      child: Column(
        children: [
          Center(child: Text('Secys:', style: Style.headingStyle)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              jointSecy.length > 0
                  ? ClubAndCouncilWidgets.getPosHolder(
                      context: context,
                      imageUrl: jointSecy[0].photo_url,
                      desg: 'Joint-Secy',
                      name: jointSecy[0].name,
                      email: jointSecy[0].email,
                      phone: jointSecy[0].phone_number,
                    )
                  : SizedBox(width: 1),
              secy == null
                  ? SizedBox(width: 1)
                  : ClubAndCouncilWidgets.getPosHolder(
                      context: context,
                      imageUrl: secy.photo_url,
                      desg: 'Secy',
                      name: secy.name,
                      email: secy.email,
                      phone: secy.phone_number,
                    ),
              jointSecy.length > 1
                  ? ClubAndCouncilWidgets.getPosHolder(
                      context: context,
                      imageUrl: jointSecy[1].photo_url,
                      desg: 'Joint Secy',
                      name: jointSecy[1].name,
                      email: jointSecy[1].email,
                      phone: jointSecy[1].phone_number,
                    )
                  : SizedBox(width: 1),
            ],
          ),
          SizedBox(height: 15.0),
        ],
      ),
    );
  }

  static Container getToolbar(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Row(
          children: <Widget>[
            BackButton(
                color: Colors.lightGreen,
                onPressed: () => {
                      print(AccountPage.flag),
                      if (AccountPage.flag == "Account")
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) => AccountPage()))
                      else
                        Navigator.pop(context),
                    }),
          ],
        ));
  }

  static Container getGradient() {
    return Container(
      margin: EdgeInsets.only(top: 190.0),
      height: 110.0,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            ColorConstants.workshopContainerBackground.withAlpha(0),
            ColorConstants.workshopContainerBackground
          ],
          stops: [0.0, 0.9],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(0.0, 1.0),
        ),
      ),
    );
  }

  static Widget getPosHolder(
      {String desg = '',
      BuildContext context,
      String name,
      String imageUrl,
      String email,
      String phone}) {
    return GestureDetector(
      onTap: () {
        detailsDialog(
          context: context,
          name: name,
          imageUrl: imageUrl,
          email: email,
          phone: phone,
        );
      },
      child: Column(
        children: <Widget>[
          SizedBox(height: 4.0),
          Center(
            child: CircleAvatar(
              backgroundImage:
                  imageUrl == null ? AssetImage('assets/iitbhu.jpeg') : NetworkImage(imageUrl),
              radius: 30.0,
              backgroundColor: Colors.transparent,
            ),
          ),
          Container(
            child: Text(
              name,
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
            width: 100,
          ),
          desg == '' ? SizedBox(height: 1.0) : Text(desg, textAlign: TextAlign.center),
          SizedBox(height: 4.0),
        ],
      ),
    );
  }

  static Widget getTitleCard(
      {BuildContext context,
      String title,
      String subtitle,
      int id,
      String imageUrl,
      bool isCouncil,
      horizontal = false,
      ClubListPost club,
      String clubTypeForHero = 'default'}) {
    final File clubLogoFile = AppConstants.getImageFile(isSmall: true, id: id, isClub: true);

    if (clubLogoFile == null) {
      AppConstants.writeImageFileIntoDisk(isClub: true, isSmall: true, id: id, url: imageUrl);
    }
    final File _largeLogofile =
        AppConstants.getImageFile(isCouncil: isCouncil, isClub: !isCouncil, isSmall: false, id: id);

    final clubThumbnail = Container(
      margin: EdgeInsets.symmetric(vertical: 16.0),
      alignment: horizontal ? FractionalOffset.centerLeft : FractionalOffset.center,
      child: Hero(
        tag: "club-hero-$id-$clubTypeForHero",
        child: Container(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image(
              fit: BoxFit.contain,
              image: imageUrl == null
                  ? AssetImage('assets/iitbhu.jpeg')
                  : _largeLogofile == null
                      ? NetworkImage(imageUrl)
                      : FileImage(_largeLogofile),
            ),
          ),
          height: horizontal ? 50 : 82,
          width: horizontal ? 50 : 82,
        ),
      ),
    );

    final councilThumbnail = Container(
      margin: EdgeInsets.symmetric(vertical: 16.0),
      alignment: FractionalOffset.center,
      child: Container(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image(
            fit: BoxFit.contain,
            image: imageUrl == null
                ? AssetImage('assets/iitbhu.jpeg')
                : _largeLogofile == null
                    ? NetworkImage(imageUrl)
                    : FileImage(_largeLogofile),
          ),
        ),
        height: 92.0,
        width: 92.0,
      ),
    );

    final clubCardContent = Container(
      margin: EdgeInsets.only(left: horizontal ? 40.0 : 10.0, right: 10.0),
      constraints: BoxConstraints.expand(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: horizontal ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: <Widget>[
          horizontal ? Container() : SizedBox(height: 4.0),
          Text(title, style: Style.titleTextStyle),
          Container(height: horizontal ? 4 : 10),
          subtitle == null ? Container() : Text(subtitle, style: Style.commonTextStyle),
          horizontal ? Container() : Separator(),
        ],
      ),
    );

    final clubCard = Container(
      child: clubCardContent,
      height: horizontal ? 75.0 : 154.0,
      margin: horizontal ? EdgeInsets.only(left: 30.0) : EdgeInsets.only(top: 72.0),
      decoration: BoxDecoration(
        color: ColorConstants.workshopCardContainer,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            offset: Offset(0.0, 10.0),
          ),
        ],
      ),
    );

    return GestureDetector(
        onTap: horizontal
            ? () => Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => ClubPage(club: club, editMode: true),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
                        FadeTransition(opacity: animation, child: child),
                  ),
                )
            : null,
        child: Container(
          margin: const EdgeInsets.symmetric(
            vertical: 1.0,
            horizontal: 15.0,
          ),
          child: Stack(
            children: <Widget>[
              clubCard,
              isCouncil == true ? councilThumbnail : clubThumbnail,
            ],
          ),
        ));
  }

  static Future detailsDialog(
          {BuildContext context, String name, String imageUrl, String email, String phone}) =>
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          final dialogColor = Color(0xFFAFAFAF);
          Container details = Container(
            child: Stack(
              children: [
                Container(
                  constraints: BoxConstraints.expand(),
                  margin: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
                  padding: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
                  decoration: BoxDecoration(
                    color: Color(0xFF004681),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10.0,
                        offset: Offset(0.0, 10.0),
                      ),
                    ],
                  ),
                  child: ListView(
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        name ?? 'No Name Available',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      ListTile(
                        onTap: () {
                          if (email != null) launch("mailto:$email");
                        },
                        leading: Icon(
                          Icons.email,
                          color: dialogColor,
                        ),
                        title: Text(
                          email ?? 'No Email Available',
                          style: TextStyle(
                            color: dialogColor,
                          ),
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          if (phone != null) launch("tel:$phone");
                        },
                        leading: Icon(
                          Icons.phone,
                          color: dialogColor,
                        ),
                        title: Text(
                          phone ?? 'No Phone Available',
                          style: TextStyle(
                            color: dialogColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  /*decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 20.0,
                        offset:   Offset(0.0, -10.0),
                      ),
                    ],
                  ),*/
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 35.0,
                    backgroundImage: NetworkImage(imageUrl),
                  ),
                ),
              ],
            ),
          );
          Container outerBox = Container(
            child: details,
            height: 270.0,
            color: Colors.transparent,
            margin: EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
          );

          return Dialog(
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: outerBox,
          );
        },
      );

  static Column getHeader(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Color(0xff00c6ff),
            borderRadius: BorderRadius.circular(2.0),
          ),
          margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width / 2 - 12.0, 10.0, 0.0, 0.0),
          height: 4.0,
          width: 24.0,
          //color:   Color(0xff00c6ff)
        ),
      ],
    );
  }
}
