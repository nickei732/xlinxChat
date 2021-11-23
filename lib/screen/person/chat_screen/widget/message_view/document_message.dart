import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:open_file/open_file.dart';
import 'package:XLINXCHAT/model/message_model.dart';
import 'package:XLINXCHAT/utils/app.dart';
import 'package:XLINXCHAT/utils/color_res.dart';
import 'package:XLINXCHAT/utils/styles.dart';

class DocumentMessage extends StatefulWidget {
  final MessageModel message;
  final Function(String, String) downloadDocument;
  final bool sender;
  final bool selectionMode;

  DocumentMessage(
    this.message,
    this.downloadDocument,
    this.sender,
    this.selectionMode,
  );

  @override
  _DocumentMessageState createState() => _DocumentMessageState();
}

class _DocumentMessageState extends State<DocumentMessage> {
  AudioPlayer advancedPlayer = new AudioPlayer();
  bool isPlaying = false;
  bool isFirstTimePlay = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment:
          widget.sender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        widget.sender
            ? Container()
            : Row(
                children: [
                  /*   CircleAvatar(
              radius: 15.0,
              backgroundImage: NetworkImage(widget.message.senderImage),
              backgroundColor: Colors.transparent,
            ),*/
                  /*   Container(
              constraints: BoxConstraints(
                maxWidth: Get.width / 3,
                minWidth: Get.width / 4,
              ),
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Text(
                widget.message.senderName ?? "Unknown",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle(
                  color: ColorRes.black,
                  weight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),*/
                ],
              ),
        Container(
          margin: EdgeInsets.only(
            left: widget.sender ? 10 : 0,
            right: widget.sender ? 0 : 10,
            bottom: 10,
          ),
          height: 70,
          child: FutureBuilder<FullMetadata>(
            future: storageService.getData(widget.message.content),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                FullMetadata document = snapshot.data;
                return Column(
                  children: <Widget>[
                    Expanded(
                      child: FutureBuilder<bool>(
                        future: widget.sender
                            ? checkForSenderExist(
                                document.name, widget.message.type)
                            : checkForExist(document.name, widget.message.type),
                        builder: (_, snapshot) {
                          if (snapshot.hasData) {
                            return InkWell(
                              onTap: widget.selectionMode
                                  ? null
                                  : () async {
                                      if (snapshot.data) {
                                        String filePath;
                                        if (widget.sender) {
                                          filePath = await getUploadPath(
                                              document.name,
                                              widget.message.type);
                                        } else {
                                          filePath = await getDownloadPath(
                                              document.name,
                                              widget.message.type);
                                        }
                                        if (filePath != null) {
                                          if (widget.message.type ==
                                              'Recording') {
                                            AudioCache audioCache =
                                                new AudioCache();

                                            advancedPlayer.play(filePath);
                                            setState(() {
                                              isPlaying = true;
                                            });
                                          } else {
                                            OpenResult openRes =
                                                await OpenFile.open(filePath);
                                            if (openRes.type !=
                                                ResultType.done) {
                                              showErrorToast(openRes.message,
                                                  title: "Opps!");
                                            }
                                          }
                                        }
                                      } else {
                                        setState(() {
                                          widget.message.isDownloading = true;
                                        });
                                        await widget.downloadDocument.call(
                                            widget.message.content,
                                            widget.sender
                                                ? await getUploadPath(
                                                    document.name,
                                                    widget.message.type,
                                                  )
                                                : await getDownloadPath(
                                                    document.name,
                                                    widget.message.type,
                                                  ));
                                        setState(() {
                                          widget.message.isDownloading = false;
                                        });
                                      }
                                    },
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Color(0xff0D9FCC),
                                      Color(0xff15255D)
                                    ],
                                  ),
                                  borderRadius: BorderRadius.only(bottomLeft:Radius.circular(8.0),topLeft: Radius.circular(8.0),topRight:  Radius.circular(8.0)),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            document.name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: AppTextStyle(
                                              fontSize: 14,
                                              color: ColorRes.black,
                                            ),
                                          ),
                                        ),
                                        snapshot.data
                                            ? widget.message.type == 'Recording'
                                                ? GestureDetector(
                                                    onTap: () async {
                                                      print("onTap");
                                                      if (isPlaying) {
                                                        print("pause");
                                                        advancedPlayer.pause();
                                                        setState(() {
                                                          isPlaying = false;
                                                        });
                                                      } else {
                                                        print("resume");
                                                        if (!isFirstTimePlay) {
                                                          String filePath;
                                                          if (widget.sender) {
                                                            filePath =
                                                                await getUploadPath(
                                                                    document.name,
                                                                    widget.message
                                                                        .type);
                                                          } else {
                                                            filePath =
                                                                await getDownloadPath(
                                                                    document.name,
                                                                    widget.message
                                                                        .type);
                                                          }
                                                          advancedPlayer
                                                              .play(filePath);
                                                          setState(() {
                                                            isPlaying = true;
                                                            isFirstTimePlay = true;
                                                          });
                                                        } else {
                                                          advancedPlayer.resume();
                                                          setState(() {
                                                            isPlaying = true;
                                                          });
                                                        }
                                                      }
                                                    },
                                                    child: Container(
                                                      height: 30.0,
                                                      width: 30.0,
                                                      child: Icon(
                                                        !isPlaying
                                                            ? Icons.play_arrow
                                                            : Icons.pause,
                                                        size: 25.h,
                                                      ),
                                                    ),
                                                  )
                                                : Container()
                                            : widget.message.isDownloading
                                                ? Container(
                                                    height: 25.h,
                                                    width: 25.h,
                                                    child:
                                                        CircularProgressIndicator(),
                                                  )
                                                : Icon(
                                                    Icons.download_rounded,
                                                    size: 25.h,
                                                  ),

                                      ],
                                    ),
                                    SizedBox(height: size.height*0.015,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${typeEmoji(widget.message.type)} ${convertSize(document.size)}",
                                          style: AppTextStyle(
                                            color: ColorRes.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          hFormat(DateTime.fromMillisecondsSinceEpoch(
                                              widget.message.sendTime)),
                                          style: AppTextStyle(
                                            color: ColorRes.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return SizedBox(height: 30);
                          }
                        },
                      ),
                    ),
                  ],
                );
              } else {
                return SizedBox(height: 30);
              }
            },
          ),
          width: 220.h,
        ),
      ],
    );
  }

  // ignore: missing_return
  String typeEmoji(String type) {
    switch (type) {
      case "photo":
        return "📷";
        break;
      case "document":
        return "📄";
        break;
      case "music":
        return "🎵";
        break;
      case "Recording":
        return "🎵";
        break;
      case "video":
        return "🎥";
        break;
    }
  }
}
