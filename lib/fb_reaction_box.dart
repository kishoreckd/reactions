import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';

class FbReactionBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'FB REACTION',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: FbReaction(),
    );
  }
}

class FbReaction extends StatefulWidget {
  @override
  createState() => FbReactionState();
}

class FbReactionState extends State<FbReaction> with TickerProviderStateMixin {
  late AudioPlayer audioPlayer;

  int durationAnimationBox = 500;
  int durationAnimationBtnLongPress = 150;
  int durationAnimationBtnShortPress = 500;
  int durationAnimationIconWhenDrag = 150;
  int durationAnimationIconWhenRelease = 1000;

  // For long press btn
  late AnimationController animControlBtnLongPress, animControlBox;
  late Animation zoomIconLikeInBtn, tiltIconLikeInBtn, zoomTextLikeInBtn;
  late Animation fadeInBox;
  late Animation moveRightGroupIcon;
  late Animation pushIconLikeUp,
      pushIconClapUp,
      pushIconLoveUp,
      pushIconSupportUp,
      pushIconInsightfulUp,
      pushIconFunnyUp;
  late Animation zoomIconLike,
      zoomIconClap,
      zoomIconLove,
      zoomIconSupport,
      zoomIconInsightful,
      zoomIconFunny;

  // For short press btn
  late AnimationController animControlBtnShortPress;
  late Animation zoomIconLikeInBtn2, tiltIconLikeInBtn2;

  // For zoom icon when drag
  late AnimationController animControlIconWhenDrag;
  late AnimationController animControlIconWhenDragInside;
  late AnimationController animControlIconWhenDragOutside;
  late AnimationController animControlBoxWhenDragOutside;
  late Animation zoomIconChosen, zoomIconNotChosen;
  late Animation zoomIconWhenDragOutside;
  late Animation zoomIconWhenDragInside;
  late Animation zoomBoxWhenDragOutside;
  late Animation zoomBoxIcon;

  // For jump icon when release
  late AnimationController animControlIconWhenRelease;
  late Animation zoomIconWhenRelease, moveUpIconWhenRelease;
  late Animation moveLeftIconLikeWhenRelease,
      moveLeftIconClapWhenRelease,
      moveLeftIconLoveWhenRelease,
      moveLeftIconSupportWhenRelease,
      moveLeftIconsInsightfulWhenRelease,
      moveLeftIconFunnyWhenRelease;

  Duration durationLongPress = Duration(milliseconds: 250);
  late Timer holdTimer;
  bool isLongPress = false;
  bool isLiked = false;

  // 0 = nothing, 1 = like, 2 = clap, 3 = Love, 4 = support, 5 = insightflu, 6 = funny
  int whichIconUserChoose = 0;

  // 0 = nothing, 1 = like, 2 = clap, 3 = Love, 4 = support, 5 = insightful, 6 = funny
  int currentIconFocus = 0;
  int previousIconFocus = 0;
  bool isDragging = false;
  bool isDraggingOutside = false;
  bool isJustDragInside = true;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();

    // Button Like
    initAnimationBtnLike();

    // Box and Icons
    initAnimationBoxAndIcons();

    // Icon when drag
    initAnimationIconWhenDrag();

    // Icon when drag outside
    initAnimationIconWhenDragOutside();

    // Box when drag outside
    initAnimationBoxWhenDragOutside();

    // Icon when first drag
    initAnimationIconWhenDragInside();

    // Icon when release
    initAnimationIconWhenRelease();
  }

  initAnimationBtnLike() {
    // long press
    animControlBtnLongPress = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: durationAnimationBtnLongPress));
    zoomIconLikeInBtn =
        Tween(begin: 1.0, end: 0.85).animate(animControlBtnLongPress);
    tiltIconLikeInBtn =
        Tween(begin: 0.0, end: 0.2).animate(animControlBtnLongPress);
    zoomTextLikeInBtn =
        Tween(begin: 1.0, end: 0.85).animate(animControlBtnLongPress);

    zoomIconLikeInBtn.addListener(() {
      setState(() {});
    });
    tiltIconLikeInBtn.addListener(() {
      setState(() {});
    });
    zoomTextLikeInBtn.addListener(() {
      setState(() {});
    });

    // short press
    animControlBtnShortPress = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: durationAnimationBtnShortPress));
    zoomIconLikeInBtn2 =
        Tween(begin: 1.0, end: 0.2).animate(animControlBtnShortPress);
    tiltIconLikeInBtn2 =
        Tween(begin: 0.0, end: 0.8).animate(animControlBtnShortPress);

    zoomIconLikeInBtn2.addListener(() {
      setState(() {});
    });
    tiltIconLikeInBtn2.addListener(() {
      setState(() {});
    });
  }

  initAnimationBoxAndIcons() {
    animControlBox = AnimationController(
        vsync: this, duration: Duration(milliseconds: durationAnimationBox));

    // General
    moveRightGroupIcon = Tween(begin: 0.0, end: 10.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.0, 1.0)),
    );
    moveRightGroupIcon.addListener(() {
      setState(() {});
    });

    // Box
    fadeInBox = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.7, 1.0)),
    );
    fadeInBox.addListener(() {
      setState(() {});
    });

    // Icons
    pushIconLikeUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.0, 0.5)),
    );
    zoomIconLike = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.0, 0.5)),
    );

    pushIconClapUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.1, 0.6)),
    );
    zoomIconClap = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.1, 0.6)),
    );

    pushIconLoveUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.2, 0.7)),
    );
    zoomIconLove = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.2, 0.7)),
    );

    pushIconSupportUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.3, 0.8)),
    );
    zoomIconSupport = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.3, 0.8)),
    );

    pushIconInsightfulUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.4, 0.9)),
    );
    zoomIconInsightful = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.4, 0.9)),
    );

    pushIconFunnyUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.5, 1.0)),
    );
    zoomIconFunny = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.5, 1.0)),
    );

    pushIconLikeUp.addListener(() {
      setState(() {});
    });
    zoomIconLike.addListener(() {
      setState(() {});
    });
    pushIconClapUp.addListener(() {
      setState(() {});
    });
    zoomIconClap.addListener(() {
      setState(() {});
    });
    pushIconLoveUp.addListener(() {
      setState(() {});
    });
    zoomIconLove.addListener(() {
      setState(() {});
    });
    pushIconSupportUp.addListener(() {
      setState(() {});
    });
    zoomIconSupport.addListener(() {
      setState(() {});
    });
    pushIconInsightfulUp.addListener(() {
      setState(() {});
    });
    zoomIconInsightful.addListener(() {
      setState(() {});
    });
    pushIconFunnyUp.addListener(() {
      setState(() {});
    });
    zoomIconFunny.addListener(() {
      setState(() {});
    });
  }

  initAnimationIconWhenDrag() {
    animControlIconWhenDrag = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: durationAnimationIconWhenDrag));

    zoomIconChosen =
        Tween(begin: 1.0, end: 1.8).animate(animControlIconWhenDrag);
    zoomIconNotChosen =
        Tween(begin: 1.0, end: 0.8).animate(animControlIconWhenDrag);
    zoomBoxIcon =
        Tween(begin: 50.0, end: 40.0).animate(animControlIconWhenDrag);

    zoomIconChosen.addListener(() {
      setState(() {});
    });
    zoomIconNotChosen.addListener(() {
      setState(() {});
    });
    zoomBoxIcon.addListener(() {
      setState(() {});
    });
  }

  initAnimationIconWhenDragOutside() {
    animControlIconWhenDragOutside = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: durationAnimationIconWhenDrag));
    zoomIconWhenDragOutside =
        Tween(begin: 0.8, end: 1.0).animate(animControlIconWhenDragOutside);
    zoomIconWhenDragOutside.addListener(() {
      setState(() {});
    });
  }

  initAnimationBoxWhenDragOutside() {
    animControlBoxWhenDragOutside = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: durationAnimationIconWhenDrag));
    zoomBoxWhenDragOutside =
        Tween(begin: 40.0, end: 50.0).animate(animControlBoxWhenDragOutside);
    zoomBoxWhenDragOutside.addListener(() {
      setState(() {});
    });
  }

  initAnimationIconWhenDragInside() {
    animControlIconWhenDragInside = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: durationAnimationIconWhenDrag));
    zoomIconWhenDragInside =
        Tween(begin: 1.0, end: 0.8).animate(animControlIconWhenDragInside);
    zoomIconWhenDragInside.addListener(() {
      setState(() {});
    });
    animControlIconWhenDragInside.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        isJustDragInside = false;
      }
    });
  }

  initAnimationIconWhenRelease() {
    animControlIconWhenRelease = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: durationAnimationIconWhenRelease));

    zoomIconWhenRelease = Tween(begin: 1.8, end: 0.0).animate(CurvedAnimation(
        parent: animControlIconWhenRelease, curve: Curves.decelerate));

    moveUpIconWhenRelease = Tween(begin: 180.0, end: 0.0).animate(
        CurvedAnimation(
            parent: animControlIconWhenRelease, curve: Curves.decelerate));

    moveLeftIconLikeWhenRelease = Tween(begin: 20.0, end: 10.0).animate(
        CurvedAnimation(
            parent: animControlIconWhenRelease, curve: Curves.decelerate));
    moveLeftIconClapWhenRelease = Tween(begin: 68.0, end: 10.0).animate(
        CurvedAnimation(
            parent: animControlIconWhenRelease, curve: Curves.decelerate));
    moveLeftIconLoveWhenRelease = Tween(begin: 116.0, end: 10.0).animate(
        CurvedAnimation(
            parent: animControlIconWhenRelease, curve: Curves.decelerate));
    moveLeftIconSupportWhenRelease = Tween(begin: 164.0, end: 10.0).animate(
        CurvedAnimation(
            parent: animControlIconWhenRelease, curve: Curves.decelerate));
    moveLeftIconsInsightfulWhenRelease = Tween(begin: 212.0, end: 10.0).animate(
        CurvedAnimation(
            parent: animControlIconWhenRelease, curve: Curves.decelerate));
    moveLeftIconFunnyWhenRelease = Tween(begin: 260.0, end: 10.0).animate(
        CurvedAnimation(
            parent: animControlIconWhenRelease, curve: Curves.decelerate));

    zoomIconWhenRelease.addListener(() {
      setState(() {});
    });
    moveUpIconWhenRelease.addListener(() {
      setState(() {});
    });

    moveLeftIconLikeWhenRelease.addListener(() {
      setState(() {});
    });
    moveLeftIconClapWhenRelease.addListener(() {
      setState(() {});
    });
    moveLeftIconLoveWhenRelease.addListener(() {
      setState(() {});
    });
    moveLeftIconSupportWhenRelease.addListener(() {
      setState(() {});
    });
    moveLeftIconsInsightfulWhenRelease.addListener(() {
      setState(() {});
    });
    moveLeftIconFunnyWhenRelease.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    animControlBtnLongPress.dispose();
    animControlBox.dispose();
    animControlIconWhenDrag.dispose();
    animControlIconWhenDragInside.dispose();
    animControlIconWhenDragOutside.dispose();
    animControlBoxWhenDragOutside.dispose();
    animControlIconWhenRelease.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
        children: <Widget>[
          // Just a top space
          Container(
            width: double.infinity,
            height: 100.0,
          ),

          // main content
          Container(
            child: Stack(
              children: <Widget>[
                // Box and icons
                Stack(
                  children: <Widget>[
                    // Box
                    renderBox(),

                    // Icons
                    renderIcons(),
                  ],
                  alignment: Alignment.bottomCenter,
                ),

                // Button like
                renderBtnLike(),

                // Icon like
                whichIconUserChoose == 1 && !isDragging
                    ? Container(
                        child: Transform.scale(
                          child: Image.asset(
                            'images/post_reaction/like.png',
                            width: 40.0,
                            height: 40.0,
                          ),
                          scale: this.zoomIconWhenRelease.value,
                        ),
                        margin: EdgeInsets.only(
                          top: processTopPosition(
                              this.moveUpIconWhenRelease.value),
                          left: this.moveLeftIconLikeWhenRelease.value,
                        ),
                      )
                    : Container(),

                // Icon clap
                whichIconUserChoose == 2 && !isDragging
                    ? Container(
                        child: Transform.scale(
                          child: Image.asset(
                            'images/post_reaction/clap.png',
                            width: 40.0,
                            height: 40.0,
                          ),
                          scale: this.zoomIconWhenRelease.value,
                        ),
                        margin: EdgeInsets.only(
                          top: processTopPosition(
                              this.moveUpIconWhenRelease.value),
                          left: this.moveLeftIconClapWhenRelease.value,
                        ),
                      )
                    : Container(),

                // Icon Love
                whichIconUserChoose == 3 && !isDragging
                    ? Container(
                        child: Transform.scale(
                          child: Image.asset(
                            'images/post_reaction/love.png',
                            width: 40.0,
                            height: 40.0,
                          ),
                          scale: this.zoomIconWhenRelease.value,
                        ),
                        margin: EdgeInsets.only(
                          top: processTopPosition(
                              this.moveUpIconWhenRelease.value),
                          left: this.moveLeftIconLoveWhenRelease.value,
                        ),
                      )
                    : Container(),

                // Icon support
                whichIconUserChoose == 4 && !isDragging
                    ? Container(
                        child: Transform.scale(
                          child: Image.asset(
                            'images/post_reaction/support.png',
                            width: 40.0,
                            height: 40.0,
                          ),
                          scale: this.zoomIconWhenRelease.value,
                        ),
                        margin: EdgeInsets.only(
                          top: processTopPosition(
                              this.moveUpIconWhenRelease.value),
                          left: this.moveLeftIconSupportWhenRelease.value,
                        ),
                      )
                    : Container(),

                // Icon insightful
                whichIconUserChoose == 5 && !isDragging
                    ? Container(
                        child: Transform.scale(
                          child: Image.asset(
                            'images/post_reaction/idea.png',
                            width: 40.0,
                            height: 40.0,
                          ),
                          scale: this.zoomIconWhenRelease.value,
                        ),
                        margin: EdgeInsets.only(
                          top: processTopPosition(
                              this.moveUpIconWhenRelease.value),
                          left: this.moveLeftIconsInsightfulWhenRelease.value,
                        ),
                      )
                    : Container(),

                // Icon funny
                whichIconUserChoose == 6 && !isDragging
                    ? Container(
                        child: Transform.scale(
                          child: Image.asset(
                            'images/post_reaction/smile.png',
                            width: 40.0,
                            height: 40.0,
                          ),
                          scale: this.zoomIconWhenRelease.value,
                        ),
                        margin: EdgeInsets.only(
                          top: processTopPosition(
                              this.moveUpIconWhenRelease.value),
                          left: this.moveLeftIconFunnyWhenRelease.value,
                        ),
                      )
                    : Container(),
              ],
            ),
            margin: EdgeInsets.only(left: 20.0, right: 20.0),
            // Area of the content can drag
            // decoration:  BoxDecoration(border: Border.all(color: Colors.grey)),
            width: double.infinity,
            height: 350.0,
          ),
        ],
      ),
      onHorizontalDragEnd: onHorizontalDragEndBoxIcon,
      onHorizontalDragUpdate: onHorizontalDragUpdateBoxIcon,
    );
  }

  Widget renderBox() {
    return Opacity(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.0),
          border: Border.all(color: Colors.grey.shade300, width: 0.3),
          boxShadow: [
            BoxShadow(
                color: Colors.grey,
                blurRadius: 5.0,
                // LTRB
                offset: Offset.lerp(Offset(0.0, 0.0), Offset(0.0, 0.5), 10.0)!),
          ],
        ),
        width: 300.0,
        height: isDragging
            ? (previousIconFocus == 0 ? this.zoomBoxIcon.value : 40.0)
            : isDraggingOutside
                ? this.zoomBoxWhenDragOutside.value
                : 50.0,
        margin: EdgeInsets.only(bottom: 130.0, left: 10.0),
      ),
      opacity: this.fadeInBox.value,
    );
  }

  Widget renderIcons() {
    return Container(
      child: Row(
        children: <Widget>[
          // icon like
          Transform.scale(
            child: Container(
              child: Column(
                children: <Widget>[
                  currentIconFocus == 1
                      ? Container(
                          child: Text(
                            'Like',
                            style:
                                TextStyle(fontSize: 8.0, color: Colors.white),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.black.withOpacity(0.3),
                          ),
                          padding: EdgeInsets.only(
                              left: 7.0, right: 7.0, top: 2.0, bottom: 2.0),
                          margin: EdgeInsets.only(bottom: 8.0),
                        )
                      : Container(),
                  Image.asset(
                    'images/post_reaction/like.png',
                    width: 40.0,
                    height: 40.0,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
              margin: EdgeInsets.only(bottom: pushIconLikeUp.value),
              width: 40.0,
              height: currentIconFocus == 1 ? 70.0 : 40.0,
            ),
            scale: isDragging
                ? (currentIconFocus == 1
                    ? this.zoomIconChosen.value
                    : (previousIconFocus == 1
                        ? this.zoomIconNotChosen.value
                        : isJustDragInside
                            ? this.zoomIconWhenDragInside.value
                            : 0.8))
                : isDraggingOutside
                    ? this.zoomIconWhenDragOutside.value
                    : this.zoomIconLike.value,
          ),

          // icon love
          Transform.scale(
            child: Container(
              child: Column(
                children: <Widget>[
                  currentIconFocus == 2
                      ? Container(
                          child: Text(
                            'Celebrate',
                            style:
                                TextStyle(fontSize: 8.0, color: Colors.white),
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.black.withOpacity(0.3)),
                          padding: EdgeInsets.only(
                              left: 7.0, right: 7.0, top: 2.0, bottom: 2.0),
                          margin: EdgeInsets.only(bottom: 8.0),
                        )
                      : Container(),
                  Image.asset(
                    'images/post_reaction/clap.png',
                    width: 40.0,
                    height: 40.0,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
              margin: EdgeInsets.only(bottom: pushIconClapUp.value),
              width: 60.0,
              height: currentIconFocus == 2 ? 70.0 : 40.0,
            ),
            scale: isDragging
                ? (currentIconFocus == 2
                    ? this.zoomIconChosen.value
                    : (previousIconFocus == 2
                        ? this.zoomIconNotChosen.value
                        : isJustDragInside
                            ? this.zoomIconWhenDragInside.value
                            : 0.8))
                : isDraggingOutside
                    ? this.zoomIconWhenDragOutside.value
                    : this.zoomIconClap.value,
          ),

          // icon Love
          Transform.scale(
            child: Container(
              child: Column(
                children: <Widget>[
                  currentIconFocus == 3
                      ? Container(
                          child: Text(
                            'Love',
                            style:
                                TextStyle(fontSize: 8.0, color: Colors.white),
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.black.withOpacity(0.3)),
                          padding: EdgeInsets.only(
                              left: 7.0, right: 7.0, top: 2.0, bottom: 2.0),
                          margin: EdgeInsets.only(bottom: 8.0),
                        )
                      : Container(),
                  Image.asset(
                    'images/post_reaction/love.png',
                    width: 40.0,
                    height: 40.0,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
              margin: EdgeInsets.only(bottom: pushIconLoveUp.value),
              width: 40.0,
              height: currentIconFocus == 3 ? 70.0 : 40.0,
            ),
            scale: isDragging
                ? (currentIconFocus == 3
                    ? this.zoomIconChosen.value
                    : (previousIconFocus == 3
                        ? this.zoomIconNotChosen.value
                        : isJustDragInside
                            ? this.zoomIconWhenDragInside.value
                            : 0.8))
                : isDraggingOutside
                    ? this.zoomIconWhenDragOutside.value
                    : this.zoomIconLove.value,
          ),

          // icon support
          Transform.scale(
            child: Container(
              child: Column(
                children: <Widget>[
                  currentIconFocus == 4
                      ? Container(
                          child: Text(
                            'Support',
                            style:
                                TextStyle(fontSize: 8.0, color: Colors.white),
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.black.withOpacity(0.3)),
                          padding: EdgeInsets.only(
                              left: 7.0, right: 7.0, top: 2.0, bottom: 2.0),
                          margin: EdgeInsets.only(bottom: 8.0),
                        )
                      : Container(),
                  Image.asset(
                    'images/post_reaction/support.png',
                    width: 40.0,
                    height: 40.0,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
              margin: EdgeInsets.only(bottom: pushIconSupportUp.value),
              width: 60.0,
              height: currentIconFocus == 4 ? 70.0 : 40.0,
            ),
            scale: isDragging
                ? (currentIconFocus == 4
                    ? this.zoomIconChosen.value
                    : (previousIconFocus == 4
                        ? this.zoomIconNotChosen.value
                        : isJustDragInside
                            ? this.zoomIconWhenDragInside.value
                            : 0.8))
                : isDraggingOutside
                    ? this.zoomIconWhenDragOutside.value
                    : this.zoomIconSupport.value,
          ),

          // icon insightful
          Transform.scale(
            child: Container(
              child: Column(
                children: <Widget>[
                  currentIconFocus == 5
                      ? Container(
                          child: Text(
                            'InsightFul',
                            style:
                                TextStyle(fontSize: 8.0, color: Colors.white),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.black.withOpacity(0.3),
                          ),
                          padding: EdgeInsets.only(
                              left: 7.0, right: 7.0, top: 2.0, bottom: 2.0),
                          margin: EdgeInsets.only(bottom: 8.0),
                        )
                      : Container(),
                  Image.asset(
                    'images/post_reaction/idea.png',
                    width: 40.0,
                    height: 40.0,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
              margin: EdgeInsets.only(bottom: pushIconInsightfulUp.value),
              width: 60.0,
              height: currentIconFocus == 5 ? 70.0 : 40.0,
            ),
            scale: isDragging
                ? (currentIconFocus == 5
                    ? this.zoomIconChosen.value
                    : (previousIconFocus == 5
                        ? this.zoomIconNotChosen.value
                        : isJustDragInside
                            ? this.zoomIconWhenDragInside.value
                            : 0.8))
                : isDraggingOutside
                    ? this.zoomIconWhenDragOutside.value
                    : this.zoomIconInsightful.value,
          ),

          // icon funny
          Transform.scale(
            child: Container(
              child: Column(
                children: <Widget>[
                  currentIconFocus == 6
                      ? Container(
                          child: Text(
                            'Funny',
                            style:
                                TextStyle(fontSize: 8.0, color: Colors.white),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.black.withOpacity(0.3),
                          ),
                          padding: EdgeInsets.only(
                              left: 7.0, right: 7.0, top: 2.0, bottom: 2.0),
                          margin: EdgeInsets.only(bottom: 8.0),
                        )
                      : Container(),
                  Image.asset(
                    'images/post_reaction/smile.png',
                    width: 40.0,
                    height: 40.0,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
              margin: EdgeInsets.only(bottom: pushIconFunnyUp.value),
              width: 40.0,
              height: currentIconFocus == 6 ? 70.0 : 40.0,
            ),
            scale: isDragging
                ? (currentIconFocus == 6
                    ? this.zoomIconChosen.value
                    : (previousIconFocus == 6
                        ? this.zoomIconNotChosen.value
                        : isJustDragInside
                            ? this.zoomIconWhenDragInside.value
                            : 0.8))
                : isDraggingOutside
                    ? this.zoomIconWhenDragOutside.value
                    : this.zoomIconFunny.value,
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
      ),
      width: 300.0,
      height: 250.0,
      margin: EdgeInsets.only(left: this.moveRightGroupIcon.value, top: 50.0),
    );
  }

  Widget renderBtnLike() {
    return Container(
      child: GestureDetector(
        onTapDown: onTapDownBtn,
        onTapUp: onTapUpBtn,
        onTap: onTapBtn,
        child: Container(
          child: Row(
            children: <Widget>[
              // Icon like
              Transform.scale(
                child: Transform.rotate(
                  child: Image.asset(
                    getImageIconBtn(),
                    width: 25.0,
                    height: 25.0,
                    fit: BoxFit.contain,
                    // color: Colors.black,
                  ),
                  angle: !isLongPress
                      ? handleOutputRangeTiltIconLike(tiltIconLikeInBtn2.value)
                      : tiltIconLikeInBtn.value,
                ),
                scale: !isLongPress
                    ? handleOutputRangeZoomInIconLike(zoomIconLikeInBtn2.value)
                    : zoomIconLikeInBtn.value,
              ),

              // Text like
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          padding: EdgeInsets.all(10.0),
          color: Colors.transparent,
        ),
      ),
      width: 100.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: Colors.white,
        border: Border.all(color: Colors.black),
      ),
      margin: EdgeInsets.only(top: 190.0),
    );
  }

  String getImageIconBtn() {
    if (!isLongPress && isLiked) {
      return 'images/post_reaction/like.png';
    } else if (!isDragging) {
      switch (whichIconUserChoose) {
        case 0:
          return 'images/post_reaction/false.png';
        case 1:
          return 'images/post_reaction/like.png';
        case 2:
          return 'images/post_reaction/clap.png';
        case 3:
          return 'images/post_reaction/love.png';
        case 4:
          return 'images/post_reaction/support.png';
        case 5:
          return 'images/post_reaction/idea.png';
        case 6:
          return 'images/post_reaction/smile.png';
        default:
          return 'images/post_reaction/like.png';
      }
    } else {
      return 'images/post_reaction/like.png';
    }
  }

  // Color? getTintColorIconBtn() {
  //   if (!isLongPress && isLiked) {
  //     return Color(0xff3b5998);
  //   } else if (!isDragging && whichIconUserChoose != 0) {
  //     return null;
  //   } else {
  //     return Colors.grey;
  //   }
  // }

  double processTopPosition(double value) {
    // margin top 100 -> 40 -> 160 (value from 180 -> 0)
    if (value >= 120.0) {
      return value - 80.0;
    } else {
      return 160.0 - value;
    }
  }

  // Color getColorBorderBtn() {
  //   if ((!isLongPress && isLiked)) {
  //     return Color(0xff3b5998);
  //   } else if (!isDragging) {
  //     switch (whichIconUserChoose) {
  //       case 1:
  //         return Color(0xff3b5998);
  //       case 2:
  //         return Color(0xffED5167);
  //       case 3:
  //       case 4:
  //       case 5:
  //         return Color(0xffFFD96A);
  //       case 6:
  //         return Color(0xffF6876B);
  //       default:
  //         return Colors.grey;
  //     }
  //   } else {
  //     return Colors.grey.shade400;
  //   }
  // }

  void onHorizontalDragEndBoxIcon(DragEndDetails dragEndDetail) {
    isDragging = false;
    isDraggingOutside = false;
    isJustDragInside = true;
    previousIconFocus = 0;
    currentIconFocus = 0;

    onTapUpBtn(null);
  }

  void onHorizontalDragUpdateBoxIcon(DragUpdateDetails dragUpdateDetail) {
    // return if the drag is drag without press button
    if (!isLongPress) return;

    // the margin top the box is 150
    // and plus the height of toolbar and the status bar
    // so the range we check is about 200 -> 500

    if (dragUpdateDetail.globalPosition.dy >= 200 &&
        dragUpdateDetail.globalPosition.dy <= 500) {
      isDragging = true;
      isDraggingOutside = false;

      if (isJustDragInside && !animControlIconWhenDragInside.isAnimating) {
        animControlIconWhenDragInside.reset();
        animControlIconWhenDragInside.forward();
      }

      if (dragUpdateDetail.globalPosition.dx >= 20 &&
          dragUpdateDetail.globalPosition.dx < 83) {
        if (currentIconFocus != 1) {
          handleWhenDragBetweenIcon(1);
        }
      } else if (dragUpdateDetail.globalPosition.dx >= 83 &&
          dragUpdateDetail.globalPosition.dx < 126) {
        if (currentIconFocus != 2) {
          handleWhenDragBetweenIcon(2);
        }
      } else if (dragUpdateDetail.globalPosition.dx >= 126 &&
          dragUpdateDetail.globalPosition.dx < 180) {
        if (currentIconFocus != 3) {
          handleWhenDragBetweenIcon(3);
        }
      } else if (dragUpdateDetail.globalPosition.dx >= 180 &&
          dragUpdateDetail.globalPosition.dx < 233) {
        if (currentIconFocus != 4) {
          handleWhenDragBetweenIcon(4);
        }
      } else if (dragUpdateDetail.globalPosition.dx >= 233 &&
          dragUpdateDetail.globalPosition.dx < 286) {
        if (currentIconFocus != 5) {
          handleWhenDragBetweenIcon(5);
        }
      } else if (dragUpdateDetail.globalPosition.dx >= 286 &&
          dragUpdateDetail.globalPosition.dx < 340) {
        if (currentIconFocus != 6) {
          handleWhenDragBetweenIcon(6);
        }
      }
    } else {
      whichIconUserChoose = 0;
      previousIconFocus = 0;
      currentIconFocus = 0;
      isJustDragInside = true;

      if (isDragging && !isDraggingOutside) {
        isDragging = false;
        isDraggingOutside = true;
        animControlIconWhenDragOutside.reset();
        animControlIconWhenDragOutside.forward();
        animControlBoxWhenDragOutside.reset();
        animControlBoxWhenDragOutside.forward();
      }
    }
  }

  void handleWhenDragBetweenIcon(int currentIcon) {
    playSound('icon_focus.mp3');
    whichIconUserChoose = currentIcon;
    previousIconFocus = currentIconFocus;
    currentIconFocus = currentIcon;
    animControlIconWhenDrag.reset();
    animControlIconWhenDrag.forward();
  }

  void onTapDownBtn(TapDownDetails tapDownDetail) {
    holdTimer = Timer(durationLongPress, showBox);
  }

  void onTapUpBtn(TapUpDetails? tapUpDetail) {
    if (isLongPress) {
      if (whichIconUserChoose == 0) {
        playSound('box_down.mp3');
      } else {
        playSound('icon_choose.mp3');
      }
    }

    Timer(Duration(milliseconds: durationAnimationBox), () {
      isLongPress = false;
    });

    holdTimer.cancel();

    animControlBtnLongPress.reverse();

    setReverseValue();
    animControlBox.reverse();

    animControlIconWhenRelease.reset();
    animControlIconWhenRelease.forward();
  }

  // when user short press the button
  void onTapBtn() {
    if (!isLongPress) {
      if (whichIconUserChoose == 0) {
        isLiked = !isLiked;
      } else {
        whichIconUserChoose = 0;
      }
      if (isLiked) {
        playSound('short_press_like.mp3');
        animControlBtnShortPress.forward();
      } else {
        animControlBtnShortPress.reverse();
      }
    }
  }

  double handleOutputRangeZoomInIconLike(double value) {
    if (value >= 0.8) {
      return value;
    } else if (value >= 0.4) {
      return 1.6 - value;
    } else {
      return 0.8 + value;
    }
  }

  double handleOutputRangeTiltIconLike(double value) {
    if (value <= 0.2) {
      return value;
    } else if (value <= 0.6) {
      return 0.4 - value;
    } else {
      return -(0.8 - value);
    }
  }

  void showBox() {
    playSound('box_up.mp3');
    isLongPress = true;

    animControlBtnLongPress.forward();

    setForwardValue();
    animControlBox.forward();
  }

  // We need to set the value for reverse because if not
  // the Funny-icon will be pulled down first, not the like-icon
  void setReverseValue() {
    // Icons
    pushIconLikeUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.5, 1.0)),
    );
    zoomIconLike = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.5, 1.0)),
    );

    pushIconClapUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.4, 0.9)),
    );
    zoomIconClap = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.4, 0.9)),
    );

    pushIconLoveUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.3, 0.8)),
    );
    zoomIconLove = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.3, 0.8)),
    );

    pushIconSupportUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.2, 0.7)),
    );
    zoomIconSupport = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.2, 0.7)),
    );

    pushIconInsightfulUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.1, 0.6)),
    );
    zoomIconInsightful = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.1, 0.6)),
    );

    pushIconFunnyUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.0, 0.5)),
    );
    zoomIconFunny = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.0, 0.5)),
    );
  }

  // When set the reverse value, we need set value to normal for the forward
  void setForwardValue() {
    // Icons
    pushIconLikeUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.0, 0.5)),
    );
    zoomIconLike = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.0, 0.5)),
    );

    pushIconClapUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.1, 0.6)),
    );
    zoomIconClap = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.1, 0.6)),
    );

    pushIconLoveUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.2, 0.7)),
    );
    zoomIconLove = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.2, 0.7)),
    );

    pushIconSupportUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.3, 0.8)),
    );
    zoomIconSupport = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.3, 0.8)),
    );

    pushIconInsightfulUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.4, 0.9)),
    );
    zoomIconInsightful = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.4, 0.9)),
    );

    pushIconFunnyUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.5, 1.0)),
    );
    zoomIconFunny = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.5, 1.0)),
    );
  }

  Future playSound(String nameSound) async {
    // Sometimes multiple sound will play the same time, so we'll stop all before play the newest
    await audioPlayer.stop();
    final file = File('${(await getTemporaryDirectory()).path}/$nameSound');
    await file.writeAsBytes((await loadAsset(nameSound)).buffer.asUint8List());
    await audioPlayer.play(file.path, isLocal: true);
  }

  Future loadAsset(String nameSound) async {
    return await rootBundle.load('sounds/$nameSound');
  }
}
