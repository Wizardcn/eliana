import 'package:eliana/bloc/ex_sound_counter_bloc/ex_sound_counter_bloc.dart';
import 'package:eliana/bloc/ex_sound_player_bloc/ex_sound_player_bloc.dart';
import 'package:eliana/bloc/ex_sounds_bloc/ex_sounds_bloc.dart';
import 'package:eliana/bloc/recorded_sound_player_bloc/recorded_sound_player_bloc.dart';

import 'package:eliana/bloc/sound_recorder_bloc/sound_recorder_bloc.dart';
import 'package:eliana/bloc/sound_uploader_bloc/sound_uploader_bloc.dart';
import 'package:eliana/bloc/user_detail_bloc/user_detail_bloc.dart';
import 'package:eliana/models/app_user.dart';
import 'package:eliana/screens/authenticate/sign_in.dart';
import 'package:eliana/services/auth.dart';
import 'package:eliana/shared/constants.dart';
import 'package:eliana/shared/user_loading.dart';
import 'package:flutter/material.dart';
import 'package:eliana/shared/custom_icon.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';

import 'package:provider/provider.dart';

const theSource = AudioSource.microphone;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // auth service
  final AuthService _auth = AuthService();
  late AppUser user;

  @override
  void initState() {
    BlocProvider.of<ExSoundPlayerBloc>(context).add(OpenExPlayerEvent());
    BlocProvider.of<RecordedSoundPlayerBloc>(context)
        .add(OpenRecordedPlayerEvent());
    BlocProvider.of<SoundRecorderBloc>(context).add(OpenRecorderEvent());
    super.initState();
  }

  // ------------ Main Widget ---------------

  Widget logoutButton() {
    return Column(
      children: [
        TextButton(
          onPressed: logoutDialog,
          style: TextButton.styleFrom(
            primary: grey,
            shape: const CircleBorder(),
            backgroundColor: blue,
          ),
          child: Icon(
            Icons.keyboard_backspace_rounded,
            size: 50,
            color: white,
            semanticLabel: "ออกจากระบบ",
          ),
        ),
        const Text(
          'ออกจากระบบ',
        ),
      ],
    );
  }

  Widget userAvatar() {
    return BlocBuilder<UserDetailBloc, UserDetailState>(
      builder: ((context, state) {
        if (state is UserDetailLoading || state is UserDetailInitial) {
          return UserLoading();
        }
        if (state is UserDetailFinished) {
          return Column(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(state.user.profilePicUrl),
                radius: 40,
              ),
              Text(
                '${state.user.username}',
              )
            ],
          );
        } else {
          return Column();
        }
      }),
    );
  }

  Widget nextButton() {
    return BlocBuilder<ExSoundsBloc, ExSoundsState>(
      builder: (context, state) {
        if (state is ExSoundsFinished) {
          return Column(
            children: [
              TextButton(
                onPressed: () {
                  BlocProvider.of<ExSoundCounterBloc>(context).add(
                      NextButtonIsPressed(maxIndex: state.ex_sounds.length));
                  BlocProvider.of<SoundRecorderBloc>(context)
                      .add(ResetRecorderEvent());
                  final snackBar =
                      SnackBar(content: const Text('ข้ามเสียงเสร็จสิ้น'));

                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                style: TextButton.styleFrom(
                  primary: grey,
                  shape: const CircleBorder(),
                  backgroundColor: blue,
                ),
                child: Icon(
                  Icons.redo_rounded,
                  size: 50,
                  color: white,
                  semanticLabel: "ข้ามไปเสียงอื่น",
                ),
              ),
              const Text(
                'ข้าม',
              ),
            ],
          );
        } else {
          return Column(
            children: [
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  primary: grey,
                  shape: const CircleBorder(),
                  backgroundColor: blue,
                ),
                child: Icon(
                  Icons.redo_rounded,
                  size: 50,
                  color: white,
                  semanticLabel: "ข้ามไปเสียงอื่น",
                ),
              ),
              const Text(
                'ข้าม',
              ),
            ],
          );
        }
      },
    );
  }

  Widget playExSoundWidget() {
    return BlocBuilder<ExSoundsBloc, ExSoundsState>(builder: ((context, state) {
      if (state is ExSoundsInitial || state is ExSoundsLoading) {
        return SpinKitChasingDots(
          color: Colors.blue,
          size: 50.0,
        );
      }
      if (state is ExSoundsFinished) {
        return Column(
          children: [
            OutlinedButton(
              onPressed: () async {
                int index =
                    BlocProvider.of<ExSoundCounterBloc>(context).state.index;

                BlocProvider.of<ExSoundPlayerBloc>(context).add(
                    StartExPlayerIsPressed(
                        state.ex_sounds[index].toJson()["played_sound_url"]));

                BlocProvider.of<SoundRecorderBloc>(context)
                    .add(UserPressedExButtonEvent());
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: blue,
                primary: grey,
                shape: const CircleBorder(),
                side: BorderSide(
                  width: 10,
                  color: blue,
                ),
              ),
              child: BlocBuilder<ExSoundPlayerBloc, ExSoundPlayerState>(
                  builder: (context, exSoundPlayerState) {
                if (exSoundPlayerState is ExSoundPlayerIsPlaying) {
                  return headphoneWithSoundIcon;
                } else {
                  return Semantics(
                    child: headphoneIcon,
                    label: "กดเพื่อฟังเสียงตัวอย่าง",
                  );
                }
              }),
            ),
            BlocBuilder<ExSoundCounterBloc, ExSoundCounterState>(
              builder: (context, counterState) {
                return Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    'ฟังเสียงตัวอย่างที่ ${counterState.index + 1}',
                  ),
                );
              },
            ),
          ],
        );
      } else {
        return OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            backgroundColor: grey,
            primary: white,
            shape: const CircleBorder(),
            side: BorderSide(
              width: 10,
              color: blue,
            ),
          ),
          child: BlocBuilder<ExSoundPlayerBloc, ExSoundPlayerState>(
              builder: (context, exSoundPlayerState) {
            if (exSoundPlayerState is ExSoundPlayerIsPlaying) {
              return headphoneWithSoundIcon;
            } else {
              return Semantics(
                child: headphoneIcon,
                label: "กดเพื่อฟังเสียงตัวอย่าง",
              );
            }
          }),
        );
      }
    }));
  }

  Widget playRecordedSound() {
    return BlocBuilder<SoundRecorderBloc, SoundRecorderState>(
        builder: ((context, recorderState) {
      if (recorderState is SoundRecorderFinished) {
        return BlocBuilder<RecordedSoundPlayerBloc, RecordedSoundPlayerState>(
          builder: ((context, recordedSoundPlayerState) {
            if (recordedSoundPlayerState is RecordedSoundPlayerIsPlaying) {
              return Column(
                children: [
                  TextButton(
                    onPressed: () {
                      BlocProvider.of<RecordedSoundPlayerBloc>(context)
                          .add(StopRecordedPlayerIsPressed());
                    },
                    style: TextButton.styleFrom(
                      primary: grey,
                      shape: const CircleBorder(),
                    ),
                    child: Icon(
                      Icons.pause_rounded,
                      size: 60,
                      color: blue,
                      semanticLabel: "กดเพื่อหยุด",
                    ),
                  ),
                  Text('กำลังเล่นเสียง'),
                ],
              );
            } else {
              return Column(
                children: [
                  TextButton(
                    onPressed: () {
                      BlocProvider.of<RecordedSoundPlayerBloc>(context).add(
                          StartRecordedPlayerIsPressed(recorderState.filename));
                    },
                    style: TextButton.styleFrom(
                      primary: grey,
                      shape: const CircleBorder(),
                    ),
                    child: Icon(
                      Icons.play_arrow_rounded,
                      size: 60,
                      color: blue,
                      semanticLabel: "กดเพื่อเล่นเสียงที่อัดไว้",
                    ),
                  ),
                  Text('กดเพื่อเล่นเสียง'),
                ],
              );
            }
          }),
        );
      } else {
        return Column(
          children: [
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                primary: grey,
                shape: const CircleBorder(),
              ),
              child: Icon(
                Icons.play_arrow_rounded,
                size: 60,
                color: grey,
                semanticLabel: "กดเพื่อเล่นเสียงที่อัดไว้",
              ),
            ),
            Text('กดเพื่อเล่นเสียง'),
          ],
        );
      }
    }));
  }

  Widget recordSoundButton() {
    return BlocBuilder<SoundRecorderBloc, SoundRecorderState>(
        builder: (context, recorderState) {
      if (recorderState is SoundRecorderIsRecording) {
        return Column(
          children: [
            TextButton(
              onPressed: () {
                if (BlocProvider.of<ExSoundPlayerBloc>(context).state
                    is ExSoundPlayerIsPlaying) {
                  return null;
                } else {
                  BlocProvider.of<SoundRecorderBloc>(context)
                      .add(StopRecorderIsPressed());
                }
              },
              style: TextButton.styleFrom(
                primary: grey,
                shape: const CircleBorder(),
              ),
              child: Icon(
                Icons.stop,
                size: 100,
                color: blue,
                semanticLabel: "",
              ),
            ),
            const SizedBox(
              width: 100,
            ),
            Text('กำลังอัดเสียง'),
          ],
        );
      } else if (recorderState is SoundRecorderReady ||
          recorderState is SoundRecorderFinished) {
        return Column(
          children: [
            TextButton(
              onPressed: () {
                if (BlocProvider.of<ExSoundPlayerBloc>(context).state
                    is ExSoundPlayerIsPlaying) {
                  return null;
                } else {
                  BlocProvider.of<SoundRecorderBloc>(context)
                      .add(StartRecorderIsPressed());
                }
              },
              style: TextButton.styleFrom(
                primary: grey,
                shape: const CircleBorder(),
              ),
              child: Icon(
                CustomIcon.mic,
                size: 100,
                color: blue,
                semanticLabel: "กดเพื่อเริ่มอัดเสียง",
              ),
            ),
            const SizedBox(
              width: 100,
            ),
            Text('กดเพื่ออัดเสียง'),
          ],
        );
      } else {
        return Column(
          children: [
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                primary: grey,
                shape: const CircleBorder(),
              ),
              child: Icon(
                CustomIcon.mic,
                size: 100,
                color: grey,
                semanticLabel: "กดเพื่อเริ่มอัดเสียง",
              ),
            ),
            const SizedBox(
              width: 100,
            ),
            Text('กดเพื่ออัดเสียง'),
          ],
        );
      }
    });
  }

  Widget uploadAndNextButton() {
    return BlocBuilder<ExSoundsBloc, ExSoundsState>(
      builder: (context, state) {
        if (state is ExSoundsFinished) {
          return Column(
            children: [
              BlocBuilder<SoundRecorderBloc, SoundRecorderState>(
                  builder: (context, recorderState) {
                if (recorderState is SoundRecorderFinished) {
                  return TextButton(
                    onPressed: () {
                      int index = BlocProvider.of<ExSoundCounterBloc>(context)
                          .state
                          .index;
                      String playedSoundId =
                          state.ex_sounds[index].toJson()["played_sound_id"];
                      BlocProvider.of<SoundUploaderBloc>(context).add(
                        SoundUploaderPressed(
                            uid: user.uid,
                            playedSoundId: playedSoundId,
                            fileName: recorderState.filename),
                      );

                      BlocProvider.of<SoundRecorderBloc>(context)
                          .add(ResetRecorderEvent());
                    },
                    style: TextButton.styleFrom(
                      primary: grey,
                      shape: const CircleBorder(),
                    ),
                    child: Icon(
                      Icons.skip_next_rounded,
                      size: 60,
                      color: blue,
                      semanticLabel: "ส่งไฟล์เสียง และไปเสียงต่อไป",
                    ),
                  );
                } else {
                  return TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      primary: grey,
                      shape: const CircleBorder(),
                    ),
                    child: Icon(
                      Icons.skip_next_rounded,
                      size: 60,
                      color: grey,
                      semanticLabel: "ส่งไฟล์เสียง และไปเสียงต่อไป",
                    ),
                  );
                }
              }),
              const Text(
                'เสียงต่อไป',
              ),
              BlocListener<SoundUploaderBloc, SoundUploaderState>(
                listener: (context, uploaderState) {
                  if (uploaderState is SoundUploadAccepted) {
                    final snackBar =
                        SnackBar(content: const Text('ส่งไฟล์เสียงเรียบร้อย'));

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    BlocProvider.of<ExSoundCounterBloc>(context).add(
                        UploadAndNextButtonIsPressed(
                            maxIndex: state.ex_sounds.length));
                  }
                },
                child: Container(height: 0),
              )
            ],
          );
        } else {
          return Column(
            children: [
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  primary: grey,
                  shape: const CircleBorder(),
                ),
                child: Icon(
                  Icons.skip_next_rounded,
                  size: 60,
                  color: grey,
                  semanticLabel: "ส่งไฟล์เสียง และไปเสียงต่อไป",
                ),
              ),
              const Text(
                'เสียงต่อไป',
              ),
            ],
          );
        }
      },
    );
  }

  // -----------------------------------

  // -------------- logout dialogue -----------
  Widget sureButton() {
    return TextButton(
        onPressed: () async {
          await _auth.signOut();

          MaterialPageRoute materialPageRoute =
              MaterialPageRoute(builder: (BuildContext context) => SignIn());
          Navigator.of(context).pushAndRemoveUntil(
              materialPageRoute, (Route<dynamic> route) => false);
        },
        child: const Text("ใช่"));
  }

  Widget notSureButton() {
    return TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text("ไม่ใช่"));
  }

  void logoutDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const ListTile(
              leading: Icon(
                Icons.add_alert,
                color: Colors.red,
                size: 48.0,
              ),
              title: Text(
                "คุณยืนยันที่จะออกจากระบบไหม",
                style: TextStyle(color: Colors.red),
              ),
            ),
            actions: [
              sureButton(),
              notSureButton(),
            ],
          );
        });
  }
  // ---------------------------------------

  @override
  Widget build(BuildContext context) {
    user = Provider.of<AppUser>(context);
    BlocProvider.of<ExSoundsBloc>(context).add(HomeIsOpenedEvent());
    BlocProvider.of<UserDetailBloc>(context).add(AuthenticatedEvent(user.uid));

    return Container(
      decoration: const BoxDecoration(
        // display background image
        image: DecorationImage(
          image: AssetImage("assets/bg/home-bg.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  logoutButton(),
                  userAvatar(),
                  nextButton(),
                ],
              ),
              playExSoundWidget(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  playRecordedSound(),
                  recordSoundButton(),
                  uploadAndNextButton(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
