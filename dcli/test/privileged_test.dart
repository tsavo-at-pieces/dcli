/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */


import 'package:dcli/dcli.dart';
import 'package:test/test.dart';

void main() {
  /// This test need to be run under sudo
  test(
    'isPrivligedUser',
    () {
      expect(Shell.current.isPrivilegedUser, isTrue);
      Shell.current.releasePrivileges();
      expect(Shell.current.isPrivilegedUser, isFalse);
      Shell.current.restorePrivileges();
      expect(Shell.current.isPrivilegedUser, isTrue);
    },
    skip: true,
    tags: [
      'privileged',
    ],
  );

  /// we touch all of the dart files but don't change their ownership.
  // find('*.dart', root: '.').forEach((file) {
  //   print('touching $file');
  //   copy(file, '$file.bak', overwrite: true);
  // });

  // if (exists('/tmp/test')) {
  //   deleteDir('/tmp/test');
  // }
  // createDir('/tmp/test');
  // // do something terrible by temporary regaining the privileges.
  // withPrivileges(() {
  //   print('copy stuff I should not.');
  //   copyTree('/etc/', '/tmp/test');
  // });
}

void privileged({required bool enabled}) {
  /// how do I changed from root back to the normal user.
  if (enabled) {
    print('Enabled root priviliges');
  } else {
    print('Disabled root priviliges');
  }
}

void withPrivileges(void Function() action) {
  privileged(enabled: true);
  action();
  privileged(enabled: false);
}
