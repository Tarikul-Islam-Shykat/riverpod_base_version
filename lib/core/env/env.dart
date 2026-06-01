import 'package:envied/envied.dart';
part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'BASE_URL')
  static const String baseUrl = _Env.baseUrl;
}

/*
create a  file naming .env in the root of the project and add the following content:
BASE_URL=https://jalmas-test-generator-backed.vercel.app/api/v1

thenn run the following command in the terminal:
dart run build_runner build --delete-conflicting-outputs
*/
