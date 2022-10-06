import 'package:eliana/bloc/app_bloc_observer.dart';
import 'package:eliana/bloc/ex_sound_counter_bloc/ex_sound_counter_bloc.dart';
import 'package:eliana/bloc/ex_sound_player_bloc/ex_sound_player_bloc.dart';
import 'package:eliana/bloc/ex_sounds_bloc/ex_sounds_bloc.dart';
import 'package:eliana/bloc/recorded_sound_player_bloc/recorded_sound_player_bloc.dart';
import 'package:eliana/bloc/sound_recorder_bloc/sound_recorder_bloc.dart';
import 'package:eliana/bloc/sound_uploader_bloc/sound_uploader_bloc.dart';
import 'package:eliana/bloc/user_detail_bloc/user_detail_bloc.dart';
import 'package:eliana/shared/constants.dart';
import 'package:eliana/screens/authenticate/authenticate.dart';
import 'package:eliana/screens/wrapper.dart';
import 'package:eliana/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_language_fonts/google_language_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'models/app_user.dart';
import 'firebase_options.dart';

// ...

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  initialization();

  Bloc.observer = AppBlocObserver();
  runApp(MyApp());
}

void initialization() async {
  // This is where you can initialize the resources needed by your app while
  // the splash screen is displayed.  Remove the following example because
  // delaying the user experience is a bad design practice!
  // ignore_for_file: avoid_print
  print('ready in 3...');
  await Future.delayed(const Duration(seconds: 1));
  print('ready in 2...');
  await Future.delayed(const Duration(seconds: 1));
  print('ready in 1...');
  await Future.delayed(const Duration(seconds: 1));
  print('go!');
  await Permission.microphone.request();
  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final userDetailBloc = BlocProvider<UserDetailBloc>(
      create: (context) => UserDetailBloc(),
    );
    final exSoundsBloc = BlocProvider<ExSoundsBloc>(
      create: (context) => ExSoundsBloc(),
    );
    final exSoundCounter = BlocProvider<ExSoundCounterBloc>(
      create: (context) => ExSoundCounterBloc(),
    );
    final soundUploader = BlocProvider<SoundUploaderBloc>(
      create: (context) => SoundUploaderBloc(),
    );
    final exSoundPlayer = BlocProvider<ExSoundPlayerBloc>(
      create: (context) => ExSoundPlayerBloc(),
    );
    final recordedSoundPlayer = BlocProvider<RecordedSoundPlayerBloc>(
      create: (context) => RecordedSoundPlayerBloc(),
    );
    final soundRecorder = BlocProvider<SoundRecorderBloc>(
      create: (context) => SoundRecorderBloc(),
    );

    return MultiBlocProvider(
      providers: [
        userDetailBloc,
        exSoundsBloc,
        exSoundCounter,
        soundUploader,
        exSoundPlayer,
        recordedSoundPlayer,
        soundRecorder,
      ],
      child: StreamProvider<AppUser?>.value(
        initialData: null,
        value: AuthService().user,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            // hide bg color
            scaffoldBackgroundColor: Colors.transparent,
            // set text style
            textTheme: ThaiFonts.promptTextTheme(
              Theme.of(context).textTheme.apply(
                    displayColor: black,
                    bodyColor: black,
                  ),
            ),
          ),
          home: const Wrapper(),
          routes: {
            "/sign_in": (context) => Authenticate(showSignIn: true),
            "/regiter": (context) => Authenticate(showSignIn: false),
          },
        ),
      ),
    );
  }
}
