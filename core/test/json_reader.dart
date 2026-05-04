import 'dart:io';

String readJson(String name) {
  var dir = Directory.current.path;
  if (dir.endsWith('/core') || dir.endsWith('/movie') || dir.endsWith('/tv')) {
    dir = dir.replaceAll(RegExp(r'\/(core|movie|tv)$'), '');
  }
  return File('$dir/core/test/dummy_data/$name').readAsStringSync();
}
