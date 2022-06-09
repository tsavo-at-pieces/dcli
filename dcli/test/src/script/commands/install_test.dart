/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */


import 'package:dcli/dcli.dart' hide equals;
import 'package:dcli/src/script/commands/install.dart';
import 'package:dcli_core/dcli_core.dart' as core;
import 'package:test/test.dart';

import '../../util/test_scope.dart';

void main() {
  group(
    'Install DCli',
    () {
      test(
        'warmup install',
        () {
          withTestScope((testDir) {
            expect(!core.Settings().isWindows || Shell.current.isPrivilegedUser,
                isTrue);
            //TestFileSystem(useCommonPath: false).withinZone((fs) {

            try {
              InstallCommand().run([], []);
            } on DCliException catch (e) {
              print(e);
            }

            checkInstallStructure(testDir);

            // Now install over existing
            try {
              Shell.current.install();
            } on DCliException catch (e) {
              print(e);
            }

            checkInstallStructure(testDir);
          });
        },
        tags: ['privileged'],
      );

      test('set env PATH Linux', () {
        withTestScope((testDir) {
          final export = 'export PATH=\$PATH:${Settings().pathToDCliBin}';

          final profilePath = join(HOME, '.profile');
          if (exists(profilePath)) {
            final exportLines = read(profilePath).toList()
              ..retainWhere((line) => line.startsWith('export'));
            expect(exportLines, contains(export));
          }
        });
        // });
      });

      test('With Lib', () {});
    },
    skip: false,
  );

  test('initTemplates', () {
    InstallCommand().initTemplates();
  });
}

void checkInstallStructure(String home) {
  expect(exists(truepath(home, '.dcli')), equals(true));
  expect(
      exists(truepath(home, '.dcli', 'template', 'project', 'custom')), isTrue);
  expect(exists(truepath(home, '.dcli', 'template', 'project')), isTrue);

  checkProjectStructure(home, 'simple');
  checkProjectStructure(home, 'cmd_args');
  checkProjectStructure(home, 'find');
  checkProjectStructure(home, 'simple');

  checkScriptStructure(home);
}

void checkScriptStructure(String home) {
  expect(exists(truepath(home, '.dcli', 'template', 'script')), equals(true));
  expect(exists(truepath(home, '.dcli', 'template', 'script', 'custom')),
      equals(true));
  expect(exists(truepath(home, '.dcli', 'template', 'script', 'simple')),
      equals(true));
  expect(
      exists(truepath(
          home, '.dcli', 'template', 'script', 'analysis_options.yaml')),
      equals(true));
  expect(exists(truepath(home, '.dcli', 'template', 'script', 'pubspec.lock')),
      equals(true));
  expect(exists(truepath(home, '.dcli', 'template', 'script', 'pubspec.yaml')),
      equals(true));
}

void checkProjectStructure(String home, String projectName) {
  final projectPath =
      truepath(home, '.dcli', 'template', 'project', projectName);
  expect(exists(projectPath), equals(true));

  final templates =
      find('*', includeHidden: true, workingDirectory: projectPath).toList();

  expect(
    templates,
    unorderedEquals(
      <String>[
        truepath(projectPath, 'CHANGELOG.md'),
        truepath(projectPath, 'pubspec.lock'),
        truepath(projectPath, 'analysis_options.yaml'),
        truepath(projectPath, 'README.md'),
        truepath(projectPath, 'pubspec.yaml'),
        truepath(projectPath, 'bin', 'main.dart'),
      ],
    ),
  );
}
