library hop_runner;

import 'package:bot/hop.dart';
import 'package:bot/hop_tasks.dart';

void main() {
  
  addTask('docs', createDartDocTask(['lib/generator.dart'], linkApi: true));
  
  // deprecated:
  // runHopCore();
}