#!/usr/bin/env bash

if [[ "$TRAVIS_BRANCH" != "master" ]]; then
  echo "We're not on the master branch."
  # analyze current branch and react accordingly
  exit 0
fi

echo 'FTP_USER     '$1
echo 'FTP_PASSWORD '$2
echo 'FTP_SITE     '$3
echo 'FTP_PATH     '$4
echo ftp://$1:$2@$3/$4
curl --ftp-create-dirs -u "$1:$2" -T README.md                                                  ftp://$3/$4/README.md
curl --ftp-create-dirs -u "$1:$2" -T src/admin/css/bhaa_wordpress_plugin-admin.css              ftp://$3/$4/src/admin/css/bhaa_wordpress_plugin-admin.css
curl --ftp-create-dirs -u "$1:$2" -T src/admin/js/bhaa_wordpress_plugin-admin.js                ftp://$3/$4/src/admin/js/bhaa_wordpress_plugin-admin.js
curl --ftp-create-dirs -u "$1:$2" -T src/admin/partials/bhaa_admin_main.php                     ftp://$3/$4/src/admin/partials/bhaa_admin_main.php
curl --ftp-create-dirs -u "$1:$2" -T src/admin/partials/bhaa_admin_raceresult.php               ftp://$3/$4/src/admin/partials/bhaa_admin_raceresult.php
curl --ftp-create-dirs -u "$1:$2" -T src/admin/partials/bhaa_admin_runner.php                   ftp://$3/$4/src/admin/partials/bhaa_admin_runner.php
curl --ftp-create-dirs -u "$1:$2" -T src/admin/partials/bhaa_admin_runners.php                  ftp://$3/$4/src/admin/partials/bhaa_admin_runners.php
curl --ftp-create-dirs -u "$1:$2" -T src/admin/AbstractAdminController.php                      ftp://$3/$4/src/admin/AbstractAdminController.php
curl --ftp-create-dirs -u "$1:$2" -T src/admin/AdminController.php                              ftp://$3/$4/src/admin/AdminController.php
curl --ftp-create-dirs -u "$1:$2" -T src/admin/LeagueAdminController.php                        ftp://$3/$4/src/admin/LeagueAdminController.php
curl --ftp-create-dirs -u "$1:$2" -T src/admin/RaceAdminController.php                          ftp://$3/$4/src/admin/RaceAdminController.php
curl --ftp-create-dirs -u "$1:$2" -T src/admin/RunnerAdminController.php                        ftp://$3/$4/src/admin/RunnerAdminController.php
curl --ftp-create-dirs -u "$1:$2" -T src/admin/WPFlashMessages.php                              ftp://$3/$4/src/admin/WPFlashMessages.php
curl --ftp-create-dirs -u "$1:$2" -T src/core/cpt/partials/house/house.php                      ftp://$3/$4/src/core/cpt/partials/house/house.php
curl --ftp-create-dirs -u "$1:$2" -T src/core/cpt/partials/league/single-league-division.php    ftp://$3/$4/src/core/cpt/partials/league/single-league-division.php
curl --ftp-create-dirs -u "$1:$2" -T src/core/cpt/partials/league/single-league-individual.php  ftp://$3/$4/src/core/cpt/partials/league/single-league-individual.php
curl --ftp-create-dirs -u "$1:$2" -T src/core/cpt/partials/league/single-league-team.php        ftp://$3/$4/src/core/cpt/partials/league/single-league-team.php
curl --ftp-create-dirs -u "$1:$2" -T src/core/cpt/partials/race/edit_results.php                ftp://$3/$4/src/core/cpt/partials/race/edit_results.php
curl --ftp-create-dirs -u "$1:$2" -T src/core/cpt/partials/race/race.php                        ftp://$3/$4/src/core/cpt/partials/race/race.php
curl --ftp-create-dirs -u "$1:$2" -T src/core/cpt/EventCPT.php                                  ftp://$3/$4/src/core/cpt/EventCPT.php
curl --ftp-create-dirs -u "$1:$2" -T src/core/cpt/HouseCPT.php                                  ftp://$3/$4/src/core/cpt/HouseCPT.php
curl --ftp-create-dirs -u "$1:$2" -T src/core/cpt/LeagueCPT.php                                 ftp://$3/$4/src/core/cpt/LeagueCPT.php
curl --ftp-create-dirs -u "$1:$2" -T src/core/cpt/RaceCPT.php                                   ftp://$3/$4/src/core/cpt/RaceCPT.php
curl --ftp-create-dirs -u "$1:$2" -T src/core/league/mustache/partials/summary_row.tpl          ftp://$3/$4/src/core/league/mustache/partials/summary_row.tpl
curl --ftp-create-dirs -u "$1:$2" -T src/core/league/mustache/partials/summary_row_detailed.tpl ftp://$3/$4/src/core/league/mustache/partials/summary_row_detailed.tpl
curl --ftp-create-dirs -u "$1:$2" -T src/core/league/mustache/division-detailed.tpl             ftp://$3/$4/src/core/league/mustache/division-detailed.tpl
curl --ftp-create-dirs -u "$1:$2" -T src/core/league/mustache/division-summary.tpl              ftp://$3/$4/src/core/league/mustache/division-summary.tpl
curl --ftp-create-dirs -u "$1:$2" -T src/core/league/AbstractLeague.php                         ftp://$3/$4/src/core/league/AbstractLeague.php
curl --ftp-create-dirs -u "$1:$2" -T src/core/league/IndividualLeague.php                       ftp://$3/$4/src/core/league/IndividualLeague.php
curl --ftp-create-dirs -u "$1:$2" -T src/core/league/LeagueShortcode.php                        ftp://$3/$4/src/core/league/LeagueShortcode.php
curl --ftp-create-dirs -u "$1:$2" -T src/core/league/LeagueSummary.php                          ftp://$3/$4/src/core/league/LeagueSummary.php
curl --ftp-create-dirs -u "$1:$2" -T src/core/league/TeamLeague.php                             ftp://$3/$4/src/core/league/TeamLeague.php
curl --ftp-create-dirs -u "$1:$2" -T src/core/house/House.php                                   ftp://$3/$4/src/core/house/House.php
curl --ftp-create-dirs -u "$1:$2" -T src/core/race/mustache/edit.race.results.individual.tpl    ftp://$3/$4/src/core/race/mustache/edit.race.results.individual.tpl
curl --ftp-create-dirs -u "$1:$2" -T src/core/race/mustache/race.results.individual.tpl         ftp://$3/$4/src/core/race/mustache/race.results.individual.tpl
curl --ftp-create-dirs -u "$1:$2" -T src/core/race/partials/list.race.results.php               ftp://$3/$4/src/core/race/partials/list.race.results.php
curl --ftp-create-dirs -u "$1:$2" -T src/core/race/Race.php                                     ftp://$3/$4/src/core/race/Race.php
curl --ftp-create-dirs -u "$1:$2" -T src/core/race/RaceResult.php                               ftp://$3/$4/src/core/race/RaceResult.php
curl --ftp-create-dirs -u "$1:$2" -T src/core/race/TeamResult.php                               ftp://$3/$4/src/core/race/TeamResult.php
curl --ftp-create-dirs -u "$1:$2" -T src/core/race/RaceResultShortcode.php                      ftp://$3/$4/src/core/race/RaceResultShortcode.php
curl --ftp-create-dirs -u "$1:$2" -T src/core/runner/mustache/runner.race.results.tpl           ftp://$3/$4/src/core/runner/mustache/runner.race.results.tpl
curl --ftp-create-dirs -u "$1:$2" -T src/core/runner/Runner.php                                 ftp://$3/$4/src/core/runner/Runner.php
curl --ftp-create-dirs -u "$1:$2" -T src/core/runner/RunnerManager.php                          ftp://$3/$4/src/core/runner/RunnerManager.php
curl --ftp-create-dirs -u "$1:$2" -T src/core/runner/RunnerShortcode.php                        ftp://$3/$4/src/core/runner/RunnerShortcode.php
curl --ftp-create-dirs -u "$1:$2" -T src/core/Connections.php                                   ftp://$3/$4/src/core/Connections.php
curl --ftp-create-dirs -u "$1:$2" -T src/core/Mustache.php                                      ftp://$3/$4/src/core/Mustache.php
curl --ftp-create-dirs -u "$1:$2" -T src/front/css/bhaa_wordpress_plugin-public.css             ftp://$3/$4/src/front/css/bhaa_wordpress_plugin-public.css
curl --ftp-create-dirs -u "$1:$2" -T src/front/js/bhaa_wordpress_plugin-public.js               ftp://$3/$4/src/front/js/bhaa_wordpress_plugin-public.js
curl --ftp-create-dirs -u "$1:$2" -T src/front/img/bhaa_logo_transparent.png                    ftp://$3/$4/src/front/img/bhaa_logo_transparent.png
curl --ftp-create-dirs -u "$1:$2" -T src/front/partials/bhaa_wordpress_plugin-display.php       ftp://$3/$4/src/front/partials/bhaa_wordpress_plugin-display.php
curl --ftp-create-dirs -u "$1:$2" -T src/front/Controller.php                                   ftp://$3/$4/src/front/Controller.php
curl --ftp-create-dirs -u "$1:$2" -T src/utils/Activator.php                                    ftp://$3/$4/src/utils/Activator.php
curl --ftp-create-dirs -u "$1:$2" -T src/utils/Deactivator.php                                  ftp://$3/$4/src/utils/Deactivator.php
curl --ftp-create-dirs -u "$1:$2" -T src/utils/Internationalization.php                         ftp://$3/$4/src/utils/Internationalization.php
curl --ftp-create-dirs -u "$1:$2" -T src/utils/Loadable.php                                     ftp://$3/$4/src/utils/Loadable.php
curl --ftp-create-dirs -u "$1:$2" -T src/utils/Loader.php                                       ftp://$3/$4/src/utils/Loader.php
curl --ftp-create-dirs -u "$1:$2" -T bhaa_wordpress_plugin.php                                  ftp://$3/$4/bhaa_wordpress_plugin.php
curl --ftp-create-dirs -u "$1:$2" -T src/Main.php                                               ftp://$3/$4/src/Main.php
curl --ftp-create-dirs -u "$1:$2" -T CHANGEME.md                                                ftp://$3/$4/CHANGEME.md
curl --list-only -u "$1:$2" ftp://$3/$4/