{$IFNDEF MSDOS}
{$I DEFINES.INC}
{$ENDIF}

{

Copyright 2007 Jakob Dangarden

 This file is part of Usurper.

    Usurper is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    Usurper is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Usurper; if not, write to the Free Software
    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
}


unit Drinking; {Usurper - Drinking Competition}

interface

procedure Drinking_Competition;

implementation

uses
  Init, Cms, Jakob,
  News, Various, Online,
  Various3, Mail, File_Io;

const maxopp = 9; {opponents in drinking competiton}
  doinghere  = 'drinking beer at Bobs';
var
  Count, togo: integer;

  losers_out, playerr, exit_ok: boolean;

  pvalue:      longint;

  cvalue:      array [1..maxopp] of longint;
  cname:       array [1..maxopp] of string[50];
  male:        array [1..maxopp] of boolean;
  pl0:         ^UserRec;
  pl:          array [1..maxopp] of ^Userrec;

procedure Dispose_Vars;
var i: byte;
begin
  dispose(pl0);
  for i := 1 to maxopp do
    dispose(pl[i]);
end;

function Experience_Reward(var pl: userrec; round: integer): longint;
var xp: longint;
begin
  xp := pl.level * 700;

  {return result}
  experience_reward := xp;

end;

procedure Drunk_Comment(sober: longint);
begin

  if pvalue < 1 then
  begin
    exit;
  end;

  if sober < 1 then
    d(12, ' *Blind drunk, out of competition*');

  case sober of
    1: d(global_talkcol, 'Burp. WhheramIi?3$�???');
    2..4: d(global_talkcol, 'Hihiii! I can see that everybody has a twin!');
    5..8: d(global_talkcol, 'Gosh! That floor IS REALLY moving!');
    9..12: d(global_talkcol, 'Stand still you rats! Why is the room spinning!?');
    13..15: d(global_talkcol, 'I''m a little dizzy, thats all!');
    16..18: d(global_talkcol, 'That beer hasn''t got to me yet!');
    19..24: d(global_talkcol, 'I''m fine, but where is the bathroom please!');
    25..30: d(global_talkcol, 'And a happy new year to ya all! (burp..)');
    31..35: d(global_talkcol, 'Gimme another one Bartender!');
    36..40: d(global_talkcol, 'Ha! I''m unbeatable!');
    41..50: d(global_talkcol, 'Sober as a rock...');
    51..55: d(global_talkcol, 'A clear and steady mind...');
    56..60: d(global_talkcol, 'Refill please!!"');
    61..2000: d(global_talkcol, 'This is boriiiing... (yawn)');
  end;

end; {drunk_comment *end*}

procedure Rank_Players;
var
  gap, k, j, xx: integer;
  yy: string[50];
  i:  integer;
begin
  gap := maxopp div 2;
  while gap > 0 do
  begin
    for i := (gap + 1) to maxopp do
    begin
      j := i - gap;
      while (j > 0) do
      begin
        k := j + gap;
        if cvalue[j] >= cvalue[k] then
        begin
          j := 0;
        end else
        begin
          xx := cvalue[j];
          yy := cname[j];
          cvalue[j] := cvalue[k];
          cname[j] := cname[k];
          cvalue[k] := xx;
          cname[k] := yy;
          j := j - gap;
        end;
      end;
    end;
    gap := gap div 2;
  end;

end; {rank_players *end*}

procedure Glugg;
var counter: integer;
begin

  counter := 0;
  repeat
    counter := counter + 1;
    sd(config.textcolor, 'Glugg...');
    delay2(200);
  until counter > 2;
  d(config.textcolor, '!');

end; {glugg *end*}

procedure Howdy_Message(nr: byte);
var s: s70;
begin
  s := pl[nr]^.name2;

  case random(5) of
    0: begin
      sd(global_plycol, s);
      d(config.textcolor, ' accepts your challenge, and says :');
      case random(20) of
        0: d(global_talkcol, '   I need to show you who''s the master!');
        1: d(global_talkcol, '   I''m in!!');
        2: d(global_talkcol, '   I''m ready! I can''t see any competition here though...');
        3: d(global_talkcol, '   I feel sorry for you, ' + player.name2 + '!');
        4: d(global_talkcol, '   Are you ready to lose, ' + player.name2 + '!? Haha!');
        5: d(global_talkcol, '   My luck has never failed me so far...');
        6: d(global_talkcol, '   I have some experience from competitions like this!');
        7: d(global_talkcol, '   Make room for me you cry-babies!');
        8: d(global_talkcol, '   I can''t lose!');
        9: d(global_talkcol, '   I need to show you who''s the master!');
        10: d(global_talkcol, '   I will show you...');
        11: d(global_talkcol, '   I present to you : MYSELF!');
        12: d(global_talkcol, '   Hi ' + player.name2 + '!');
        13: d(global_talkcol, '   Are we feeling lucky today punks?');
        14: d(global_talkcol, '   Is the Beer on your tab, ' + player.name2 + '?');
        15: d(global_talkcol, '   I''m competing with a bunch of nobodies!');
        16: d(global_talkcol, '   Hello friends and foes!');
        17: d(global_talkcol, '   You are looking at the current Beer-Champion!');
        18: d(global_talkcol, '   Tam..Tadam..Tadaaa...');
        19: d(global_talkcol, '  You might win this, ' + player.name2 + '!');
      end;
    end;
    1: begin
      sd(global_plycol, s);
      d(config.textcolor, ' sits down without saying a word....');
    end;
    2: begin
      sd(global_plycol, s);
      d(config.textcolor, ' sits down and stares at you....');
    end;
    3: begin
      sd(global_plycol, s);
      d(config.textcolor, ' sits down and glares intensively at you....');
    end;
    4: begin
      sd(global_plycol, s);
      d(config.textcolor, ' sits down and mutters something you can''t hear.');
    end;

  end; {case .end.}

end;   {howdy_message *end*}


function Name_Comparison: boolean;
begin
  Name_comparison := False;

  if (pl[1]^.name2 = pl0^.name2) or
    (pl[2]^.name2 = pl0^.name2) or
    (pl[3]^.name2 = pl0^.name2) or
    (pl[4]^.name2 = pl0^.name2) or
    (pl[5]^.name2 = pl0^.name2) or
    (pl[6]^.name2 = pl0^.name2) or
    (pl[7]^.name2 = pl0^.name2) or
    (pl[8]^.name2 = pl0^.name2) or
    (pl[9]^.name2 = pl0^.name2) then
    name_comparison := True;

end; {name_comparison *end*}

procedure StoppaIn;
var p: byte;
begin

  p := 0;
  if pl[1]^.name2 = '' then
  begin
    p := 1;
  end else
  if pl[2]^.name2 = '' then
  begin
    p := 2;
  end else
  if pl[3]^.name2 = '' then
  begin
    p := 3;
  end else
  if pl[4]^.name2 = '' then
  begin
    p := 4;
  end else
  if pl[5]^.name2 = '' then
  begin
    p := 5;
  end else
  if pl[6]^.name2 = '' then
  begin
    p := 6;
  end else
  if pl[7]^.name2 = '' then
  begin
    p := 7;
  end else
  if pl[8]^.name2 = '' then
  begin
    p := 8;
  end else
  begin
    p := 9;
  end;

  if p > 0 then
  begin
    if add_shadow(SAdd, pl0^, player.name2, doinghere, 0) = True then
    begin
      pl[p]^ := pl0^;
    end;
  end;

end; {stoppaIn *end*}

procedure Get_Random_Opponent(var range1, range2: integer);
var i: integer;
begin

  case random(2) of
    0: begin
      i := random(range1);
      Inc(i);
      load_character(pl0^, 1, i);
      if (pl0^.name2 <> player.name2) and
        (pl0^.deleted = False) and
        (pl0^.location <> Offloc_Prison) and
        (pl0^.allowed = True) and
        (pl0^.hps > 0) and
        (is_online(pl0^.name2, online_player) = False) then
      begin

        if name_comparison = False then
        begin
          StoppaIn;
          togo := togo - 1;
        end;

      end;
    end;
    1: begin
      i := random(range2);
      Inc(i);
      load_character(pl0^, 2, i);
      if (pl0^.name2 <> player.name2) and
        (pl0^.deleted = False) and
        (pl0^.location <> Offloc_Prison) and
        (pl0^.allowed = True) and
        (pl0^.hps > 0) and
        (is_online(pl0^.name2, online_player) = False) then
      begin

        if name_comparison = False then
        begin
          StoppaIn;
          togo := togo - 1;
        end;

      end;
    end;

  end; {case .end.}

end;   {get_random_opponent *end*}

procedure Drinking_Competition;
var
  ch:         char;
  done, found, go_ahead, finito: boolean;
  favvis, s, s2: s70;
  round:      word;
  i, xp, player_gone: longint;
  strength, range1, range2: integer;

  drink:      string[12]; {name of competition drink}
  e:          string[5];
  j, k, size: word;
  x:          byte;

  winner:     s30;

begin

  {get Losers gonna get kicked out from .CFG}
  losers_out := False;
  s := cfg_string(85);
  if upcasestr(s) = 'NO' then
    losers_out := True;

  {Init pointer vars}
  new(pl0);
  for i := 1 to maxopp do
  begin
    new(pl[i]);
    pl[i]^.name2 := '';
    cvalue[i] := 0;
    cname[i] := '';
    male[i] := True;
  end;

  {update player location}
  onliner.location := onloc_bobdrink;
  onliner.doing := location_desc(onliner.location);
  add_onliner(OUpdateLocation, Onliner);

  range1 := fs(FsPlayer);
  range2 := fs(FsNpc);

  togo := maxopp;

  if range1 + range2 < maxopp then
    togo := range1 + range2;
  if togo < 1 then
  begin
    d(12, 'Too few opponents in the Bar!');
    crlf;
    pause;

    dispose_vars;
    exit;
  end;

  {if there are less than MAXOPP players accessible in the game then we exit}
  round := 0;
  for i := 1 to fs(FsPlayer) do
  begin
    load_character(pl0^, 1, i);
    if (pl0^.name2 <> player.name2) and
      (pl0^.name2 <> global_delname2) and
      (pl0^.deleted = False) and
      (pl0^.location <> offloc_prison) and
      (pl0^.allowed = True) and
      (pl0^.hps > 0) and
      (is_online(pl0^.name2, online_player) = False) then
    begin
      Inc(round);
      if round >= maxopp then
        break;
    end;
  end;

  for i := 1 to fs(FsNpc) do
  begin
    load_character(pl0^, 2, i);
    if (pl0^.name2 <> player.name2) and
      (pl0^.name2 <> global_delname2) and
      (pl0^.deleted = False) and
      (pl0^.location <> offloc_prison) and
      (pl0^.allowed = True) and
      (pl0^.hps > 0) and
      (is_online(pl0^.name2, online_player) = False) then
    begin
      Inc(round);
      if round >= maxopp then
        break;
    end;
  end;

  if round < maxopp then
  begin
    d(12, 'Sorry! There are not enough opponents available right now.');
    dispose_vars;
    exit;
  end;


  {intro text}
  clearscreen;
  crlf;
  crlf;
  d(config.textcolor, 'You jump up on the Bardisk!');
  d(global_talkcol, ' Come on you lazy boozers! I challenge you for a drinking contest!');
  crlf;
  sd(config.textcolor, 'There is a sudden silence in the room...');
  delay2(700);
  sd(config.textcolor, '...');
  delay2(700);
  crlf;
  d(config.textcolor, 'Then you notice how a rowdy bunch of characters make their way');
  d(config.textcolor, 'toward you...');

  round := 0;
  repeat
    get_random_opponent(range1, range2);
    Inc(round);
  until (togo < 1) or (round > 200);

  if round > 200 then
  begin
    d(12, 'Sorry! There are not enough opponents available right now.');
    dispose_vars;
    exit;
  end;

  crlf;
  if pl[1]^.name2 <> '' then
    Howdy_Message(1);
  if pl[2]^.name2 <> '' then
    Howdy_Message(2);
  if pl[3]^.name2 <> '' then
    Howdy_Message(3);
  if pl[4]^.name2 <> '' then
    Howdy_Message(4);
  if pl[5]^.name2 <> '' then
    Howdy_Message(5);
  if pl[6]^.name2 <> '' then
    Howdy_Message(6);
  if pl[7]^.name2 <> '' then
    Howdy_Message(7);
  if pl[8]^.name2 <> '' then
    Howdy_Message(8);
  if pl[9]^.name2 <> '' then
    Howdy_Message(9);

  {let user swap oppponents}
  crlf;
  if confirm('Would you like to invite somebody else', 'N') = True then
  begin
    done := False;
    repeat
      d(11, 'Replace who :');
      for i := 1 to maxopp do
      begin
        sd(config.textcolor, commastr(i) + '. ');
        d(global_plycol, pl[i]^.name2);
      end;
      d(config.textcolor, '0. Done');

      {get user input}
      sd(config.textcolor, ':');
      x := get_number(0, maxopp);

      if x = 0 then
      begin
        done := True;
      end else
      begin
        sd(config.textcolor, 'Replace ');
        sd(global_plycol, pl[x]^.name2);
        d(config.textcolor, ' with...');
        sd(config.textcolor, ':');
        s := get_string(30);

        found := False;
        finito := False;
        for i := 1 to 2 do
        begin

          case i of
            1: size := fs(fsplayer);
            2: size := fs(fsnpc);
          end;

          if (found) or (finito) then
            break;

          for j := 1 to Size do
          begin
            load_character(pl0^, i, j);

            if found then
              break;

            if (findsub(s, pl0^.name2)) and
              (pl0^.name2 <> player.name2) and
              (pl0^.name2 <> global_delname2) and
              (pl0^.hps > 0) and
              (pl0^.location <> offloc_prison) and
              (pl0^.allowed = True) and
              (pl0^.deleted = False) then
            begin

              sd(global_plycol, pl0^.name2 + ' ');

              {king?}
              if pl0^.king then
              begin
                if pl0^.sex = 1 then
                  e := 'King'
                else e := 'Queen';
                sd(14, ' (The ' + e + ') ');
              end;

              if confirm('', 'N') = True then
              begin
                {already invited?}
                go_ahead := True;
                for k := 1 to maxopp do
                begin
                  if pl[k]^.name2 = pl0^.name2 then
                  begin
                    sd(global_plycol, pl0^.name2);
                    d(config.textcolor, ' is already in the competition (stupid).');
                    go_ahead := False;
                  end;
                end;

                {already online?}
                if (go_ahead) and (is_online(pl0^.name2, online_player)) then
                begin
                  sd(global_plycol, pl0^.name2);
                  d(config.textcolor, ' is busy right now.');
                  go_ahead := False;
                end;

                if go_ahead then
                begin

                  {add shadow}
                  if add_shadow(SAdd, pl0^, player.name2, doinghere, 0) = False then
                  begin
                    {unable to add pl0}
                    d(global_plycol, pl0^.name2 + config.textcol1 + ' has entered ' + sex3[pl0^.sex] + ' the Realm!');
                    pause;

                  end else
                  begin

                    {remove old shadow}
                    add_shadow(SRemove, pl[x]^, '', 'going to sleep...', 0);

                    {replace opponent}
                    pl[x]^ := pl0^;

                    found := True;

                    d(15, 'Ok.');
                  end;

                end;

              end else
              begin
                if confirm('Continue search', 'Y') = False then
                begin
                  finito := True;
                  break;
                end;
              end;
            end;
          end; {for j .end.}

        end;   {for i .end.}
      end;

    until done;

  end; {pick new opponent .end.}

  crlf;
  d(5, 'Choose Competition Drink');
  menu('(A)le');
  menu('(S)tout');
  menu('(B)obs Bomber   *Rocket fuel*');
  sd(config.textcolor, ':');

  repeat
    ch := upcase(getchar);
  until ch in ['A', 'S', 'B'];

  case ch of
    'A': begin
      drink := 'Ale';
      d(15, drink + '!');
      strength := 2;
    end;
    'S': begin
      drink := 'Stout';
      d(15, drink + '!');
      strength := 3;
    end;
    'B': begin
      drink := 'Bobs Bomber';
      d(15, drink + '!');
      strength := 6;
    end;
  end;
  crlf;

  case ch of
    'A': begin
      case random(5) of
        0: d(config.textcolor, '"That was a wimpy choice!", you hear someone shout from the back.');
        1: d(config.textcolor, 'There is a buzz of disappointment in the room...');
        2: d(config.textcolor, '"Scared of the stronger stuff, ' + player.name2 + '?", someone shouts from the back.');
        3: d(config.textcolor, 'There is a buzz of expectancy in the bar...');
        4: d(config.textcolor, 'There is a buzz of discontent among the competitors...');
      end;
    end;
    'S': begin
      d(config.textcolor, 'Your choice seem to have made everybody content...');
    end;
    'B': begin
      d(config.textcolor, 'There is a buzz of wonder in the crowded bar...');
    end;
  end;

  pause;

  for i := 1 to maxopp do
  begin
    if pl[i]^.name2 <> '' then
    begin
      if pl[i]^.sex = 2 then
        male[i] := False;
      cname[i] := pl[i]^.name2;
      cvalue[i] := (pl[i]^.stamina + pl[i]^.strength + pl[i]^.charisma + 10) div 10;
    end;
  end; {for i:= .end.}

  round := 0;
  pvalue := (player.stamina + player.strength + player.charisma + 10) div 10;

  if pvalue > 100 then
    pvalue := 100;
  for i := 1 to maxopp do
  begin
    if cvalue[i] > 100 then
      cvalue[i] := 100;
  end;

  crlf;
  rank_players;
  sd(5, 'Favourite in this contest is ');
  if pvalue > cvalue[1] then
  begin
    favvis := player.name2;
  end else
  begin
    favvis := cname[1];
  end;

  d(global_plycol, favvis + '! ');
  pause;

  {'slurred speech of a drunk!';}

  exit_ok := False;
  playerr := True;
  player_gone := 0;
  repeat
    Inc(round);
    if pvalue > 0 then
    begin
      player_gone := player_gone + 1;
    end;

    crlf;
    crlf;

    if pvalue > 0 then
    begin
      d(5, 'Beer Round # ' + commastr(round));
      crlf;
      sd(3, 'You');
      sd(config.textcolor, ' take your Beer...');
      glugg;
      pvalue := pvalue - random(23 + strength);
      if pvalue < 1 then
      begin
        crlf;
        playerr := False;
        d(config.textcolor, 'The room is spinning!');
        d(config.textcolor, 'You hear evil laughter as you');
        d(config.textcolor, 'stagger around the room... finally falling');
        d(config.textcolor, 'heavily to the floor!');
        d(config.textcolor, 'You didn''t make it, you drunken rat!');
        crlf;
        crlf;
        if losers_out = True then
        begin
          {player.allowed:=false;}
          player.hps := 0;
          Reduce_Player_Resurrections(player, True);
        end;

        pause;
      end;
    end;

    for i := 1 to maxopp do
    begin
      if (cname[i] <> '') and (cvalue[i] > 0) then
      begin

        cvalue[i] := cvalue[i] - random(23 + strength);

        if (pvalue > 0) then
        begin
          sd(global_plycol, cname[i]);

          if male[i] then
          begin
            sd(config.textcolor, ' takes his Beer...');
          end else
          begin
            sd(config.textcolor, ' takes her Beer...');
          end;
          glugg;

          if cvalue[i] < 1 then
          begin
            sd(global_plycol, cname[i]);
            d(config.textcolor, ' starts to reel round in a daze!');
            d(config.textcolor, 'Everybody laughs heartily as ' + cname[i]);
            d(config.textcolor, 'staggers a few steps and then falls heavily');
            d(config.textcolor, 'to the floor!');
            d(config.textcolor, 'Another one bites the dust!');
            crlf;
            pause;
          end;
        end;
      end;
    end;

    if pvalue > 0 then
    begin
      pause; crlf;
      d(5, 'Round Soberness Evaluation :');
      crlf;
      sd(config.textcolor, 'You - ');
      drunk_comment(pvalue);

      for i := 1 to maxopp do
      begin
        if cname[i] <> '' then
        begin
          sd(global_plycol, cname[i]);
          sd(config.textcolor, ' - ');
          drunk_comment(cvalue[i]);
        end;
      end;
    end;

    if pvalue > 0 then
    begin
      crlf;
      pause;
    end;

    exit_ok := True;
    Count := 0;
    for i := 1 to maxopp do
    begin
      if (cname[i] <> '') and (cvalue[i] > 0) then
        Count := Count + 1;
    end;
    if pvalue > 0 then
      Count := Count + 1;
    if Count > 1 then
      exit_ok := False;

  until exit_ok;


  {Write to Newsfile}

  newsy(False,
    'Beer Contest!',
    ' ' + uplc + player.name2 + config.textcol1 + ' challenged a rowdy group for a competition.',
    ' ' + uplc + favvis + config.textcol1 + ' was the Big Favourite!',
    '',
    '',
    '',
    '',
    '',
    '',
    '');

  found := False;
  for i := 1 to maxopp do
  begin
    if (cname[i] <> '') and (cvalue[i] > 0) then
    begin
      newsy(False,
        ' ' + uplc + cname[i] + config.textcol1 + ' - reeled drunkenly down the road as a WINNER!',
        ' (it took ' + commastr(round) + ' rounds for ' + uplc + cname[i] + config.textcol1 +
        ' to finish off the competition)',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '');
      found := True;
      break;
    end;
  end;

  s2 := '';
  if not found then
  begin
    s2 := '(No winner was found)';
  end;

  if pvalue < 1 then
  begin
    newsy(False,
      ' Poor ' + ulred + player.name2 + config.textcol1 + '....turned Blind Drunk after ' +
      commastr(player_gone) + ' rounds of Beer!',
      s2,
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '');
  end else
  begin
    newsy(False,
      ' ' + uplc + player.name2 + config.textcol1 + ' - reeled drunkenly down the road as a WINNER!',
      ' (it took ' + commastr(round) + ' rounds for ' + uplc + player.name2 + config.textcol1 +
      ' to finish off the competition)',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '');

  end;

  newsy(True,
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '');

  {who won?}
  winner := '';
  for i := 1 to maxopp do
  begin
    if (cname[i] <> '') and (cvalue[i] > 0) then
    begin
      winner := cname[i];
      break;
    end;
  end;

  {post mail to human competitors}
  for i := 1 to maxopp do
  begin
    if pl[i]^.ai = 'H' then
    begin

      if pl[i]^.name2 = winner then
      begin

        {exp reward}
        xp := experience_reward(pl[i]^, round);
        pl[i]^.exp := pl[i]^.exp + xp;

        {save user}
        user_save(pl[i]^);

        post(MailSend,
          pl[i]^.name2,
          pl[i]^.ai,
          False,
          mailrequest_nothing,
          '',
          umailheadc + 'Beer Drinking Competition' + config.textcol1,
          mkstring(25, underscore),
          'You were invited by ' + uplc + player.name2 + config.textcol1 + ' to drink beer (' +
          ulred + drink + config.textcol1 + ').',
          'You ' + uyellow + 'WON' + config.textcol1 + '! It took you ' + commastr(round) +
          ' rounds to finish off the competition.',
          'You earned ' + uwhite + commastr(xp) + config.textcol1 + ' experience points!',
          '',
          '',
          '',
          '',
          '',
          '',
          '',
          '',
          '',
          '');

      end else
      begin {loser}
        s2 := winner;
        if s2 = '' then
        begin
          s2 := player.name2;
          if pvalue < 1 then
            s2 := '(No winner was found)';
        end;

        post(MailSend,
          pl[i]^.name2,
          pl[i]^.ai,
          False,
          mailrequest_nothing,
          '',
          umailheadc + 'Beer Drinking Competition' + config.textcol1,
          mkstring(25, underscore),
          'You were invited by ' + uplc + player.name2 + config.textcol1 + ' to drink beer (' +
          ulred + drink + config.textcol1 + ').',
          'You ' + ulred + 'lost' + config.textcol1 + '. You lasted a few rounds.',
          'Winner was ' + uplc + s2 + config.textcol1 + '.',
          '',
          '',
          '',
          '',
          '',
          '',
          '',
          '',
          '',
          '');

      end;

    end;

    {remove shadow player}
    add_shadow(SRemove, pl[i]^, '', 'going to sleep...', 0);

  end;


  if pvalue < 1 then
  begin
    crlf;
    d(config.textcolor, 'You are out of the competition! (with a nice hangover)');
    d(config.textcolor, 'Be better prepared next time!');
    d(config.textcolor, 'Darkness...');
    pause;

    dispose_vars;

    normal_exit;
  end;

  crlf;
  d(14, 'Congratulations!');
  d(config.textcolor, 'You managed to stay sober longer than the rest of the players!');
  d(config.textcolor, 'Three cheers for the Beer Champion!');
  sd(14, '....Horray!');
  delay2(500);
  sd(14, '....Horray!');
  delay2(500);
  sd(14, '....Horray!');
  delay2(500);
  crlf;

  {experience reward}
  xp := experience_reward(player, round);

  player.exp := player.exp + xp;

  sd(config.textcolor, 'You receive ');
  sd(14, commastr(xp));
  d(config.textcolor, ' Experience points!');
  crlf;
  pause;

  dispose_vars;

end; {Drinking_Competition *end*}

end. {Unit Drinking .end.}
