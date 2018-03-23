<?php
/**
 * Created by IntelliJ IDEA.
 * User: e074820
 * Date: 17/03/2018
 * Time: 21:04
 */

namespace BHAA\core;

class Connections {
    const EVENT_TO_RACE = 'event_to_race';
    const LEAGUE_TO_EVENT = 'league_to_event';
    const HOUSE_TO_RUNNER = 'house_to_runner';
    const SECTORTEAM_TO_RUNNER = 'sectorteam_to_runner';
    const TEAM_CONTACT = 'team_contact';
    // indicates a runner who will get 10 league points for organsing a race
    const RACE_ORGANISER = 'race_organiser';
    // indicates a team that 6 leagues points for organising an event
    const TEAM_POINTS = 'team_points';
}