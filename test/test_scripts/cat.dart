#! /usr/bin/env dshell

import 'package:dshell/dshell.dart';

/// Used by unit tests as a cross platform version of cat
void main(List<String> args) {
  for (var arg in args) {
    if (!exists(arg)) {
      print('cat: $arg: No such file or directory');
    } else {
      cat(arg);
    }
  }
}
