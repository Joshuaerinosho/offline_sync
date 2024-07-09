import 'package:mockito/annotations.dart';
import 'package:sqflite/sqflite.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

@GenerateMocks([Database, Connectivity])
@GenerateNiceMocks([MockSpec<SharedPreferences>()])
void main() {}
