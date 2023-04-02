import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';

class SignUpViewModel extends AsyncNotifier<void> {
  late final AuthenticationRepository _authRepo;
  @override
  FutureOr<void> build() {
    _authRepo = ref.read(authRepo);
  }

  Future<void> signUp() async {
    // 사람들에게 로딩중인 것을 알려주기 위해 추가
    state = const AsyncValue.loading();
    final form = ref.read(signUpForm);

    // await _authRepo.signUp(form["email"], form["password"]);
    // signUp이 완료되면, 로딩중인 것을 종료시킴
    // 아무것도 expose하지 않으므로 null을 넣음
    // state = const AsyncValue.data(null);

    // 위 코드 대신 아래와 같이 작성할 수 있다.
    state = await AsyncValue.guard(
      () async => await _authRepo.signUp(
        form["email"],
        form["password"],
      ),
    );
  }
}

// StateProvider는 바깥에서 수정할 수 있는 value를 노출하게 해줌
final signUpForm = StateProvider((ref) => {});

final signUpProvider = AsyncNotifierProvider<SignUpViewModel, void>(
  () => SignUpViewModel(),
);
