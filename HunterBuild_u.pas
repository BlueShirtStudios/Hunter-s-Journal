unit HunterBuild_u;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, Data.DB, Datasnap.DBClient, math, FMX.Dialogs, dmHunterJournal_u ;

type
  THunterBuild = Class
  private
  //Character Details
  fBuildID : integer;
  fName : string;
  fGender : string;
  fLevel : integer;
  fBloodEchoes : integer;
  fInsight : integer;
  fUserID : integer;
  //Build Details
  fVitality : integer;
  fEndurance : integer;
  fStrength : integer;
  fSkill : integer;
  fBloodtinge : integer;
  fArcane : integer;
  fL1Weapon : string;
  fL2Weapon : string;
  fR1Weapon : string;
  fR2Weapon : string;

  public
  //create class
  constructor CreateHunterBuild;
  //build details procedures
  procedure SearchForUser( UserID : integer);
  procedure setCharDetails;
  procedure setCharBuild;
  procedure UpdateBuild( iLevel,iVital, iEndurance, iStrength, iSkill, iBloodtinge, iArcane : integer);
  procedure LoadWeapons;
  //preset build procedure
  procedure StrengthBuild(iLevel : integer);
  procedure SkillBuild( iLevel : integer);
  procedure BloodtingeBuild( iLevel : integer);
  procedure ArcaneBuild( iLevel : integer);
  //set attribute procedures
  procedure setUserID ( UserID : integer);
  procedure setBuildID ( BuildID : integer);
  procedure setName ( sName : string );
  procedure setGender ( sGender : string );
  procedure setLevel ( iLevel : integer);
  procedure setBloodEchoes ( iBloodEchoes : integer);
  procedure setInsight ( iInsight : integer);
  procedure setVitality ( iVital : integer );
  procedure setEndurance ( iEnder : integer);
  procedure setStrength ( iStreng : integer );
  procedure setSkill ( iSkill : integer );
  procedure setBloodtinge ( iBloodTinge : integer );
  procedure setArcane ( iArcane : integer );
  procedure setL1W ( L1W : string);
  procedure setL2W ( L2W : string);
  procedure setR1W ( R1W : string);
  procedure setR2W ( R2W : string);
  //get attribute functions
  function getName : string;
  function getUserID (iUserID : integer) : integer;
  function getBuildID (iBuildID : integer ) : integer;
  function getGender : string;
  function getLevel : integer;
  function getBloodEchoes  : integer;
  function getInsight : integer;
  function getVitality : integer;
  function getEndurance : integer;
  function getStrength : integer;
  function getSkill  : integer;
  function getBloodtinge : integer;
  function getArcane : integer;
  function getL1W : string;
  function getL2W : string;
  function getR1W : string;
  function getR2W : string;
  //valdation functions
  function DetermineChangesValid( iLevel, iVital, iEndurance, iStrength, iSkill, iBloodtinge, iArcane : integer) : boolean;

end;


implementation

{ THunterBuild }


function THunterBuild.DetermineChangesValid( iLevel, iVital, iEndurance, iStrength, iSkill, iBloodtinge, iArcane : integer): boolean;
begin
  if iLevel = (iVital + iEndurance + iStrength + iSkill + iBloodtinge + iArcane) then
    begin
      //Build is valid
      Result := True;
    end
  else Result := false;
end;

function THunterBuild.getArcane: integer;
begin
  Result := fArcane;
end;

function THunterBuild.getBloodEchoes: integer;
begin
  Result := fBloodEchoes;
end;

function THunterBuild.getBloodtinge : integer;
begin
  Result :=  fBloodtinge;
end;

function THunterBuild.getBuildID(iBuildID : integer) : integer;
begin
  Result := fBuildID;
end;

function THunterBuild.getEndurance : integer;
begin
  Result := fEndurance;
end;

function THunterBuild.getGender: string;
begin
  Result := fGender;
end;

function THunterBuild.getInsight: integer;
begin
  Result := fInsight;
end;

function THunterBuild.getL1W: string;
begin
  Result := fL1Weapon;
end;

function THunterBuild.getL2W: string;
begin
  Result := fL2Weapon;
end;

function THunterBuild.getLevel: integer;
begin
  Result := fLevel;
end;

function THunterBuild.getName: string;
begin
  Result := fName;
end;

function THunterBuild.getR1W: string;
begin
  Result := fR1Weapon;
end;

function THunterBuild.getR2W: string;
begin
  Result := fR2Weapon;
end;

function THunterBuild.getSkill : integer;
begin
  Result := fSkill;
end;

function THunterBuild.getStrength: integer;
begin
  Result := fStrength;
end;

function THunterBuild.getUserID(iUserID: integer): integer;
begin
  Result := fUserID;
end;

function THunterBuild.getVitality: integer;
begin
  Result := fVitality;
end;

procedure THunterBuild.LoadWeapons;
  var bFound : boolean;
  iL1W, iL2W, iR1W, iR2W : integer;
begin
  //Search for the build's weapons
  bFound := false;
  with dmHunter.tblBuild do
    begin
      Open;
      First;
      while not eof and bFound = false do
        begin
          if fBuildID = FieldbyName('BuildID').asInteger then
            begin
              bFound := true;
              iL1W := FieldbyName('L1Weapon').AsInteger;
              iL2W := FieldbyName('L2Weapon').AsInteger;
              iR1W := FieldbyName('R1Weapon').AsInteger;
              iR2W := FieldbyName('R2Weapon').AsInteger;
            end;//if BuildID =

        end;//while nor eof + false

    end; //with tblBuild

  //Get weapon names
  with dmHunter.tblWeapons do
    begin
      Open;
      First;
      bFound := false;
      //L1Weapon
      while not eof and bFound = false do
        begin
          if iL1W = FieldbyName('WeaponID').asInteger then
            begin
              bFound := true;
              setL1W(FieldbyName('Weapon').asString);
            end
          else Next;
        end; //if L1W

      //L2Weapon
      First;
      bFound := false;
      while not eof and bFound = false do
        begin
          if iL2W = FieldbyName('WeaponID').asInteger then
            begin
              bFound := true;
              setL2W(FieldbyName('Weapon').asString);
            end
          else Next;
        end; //if L2W

      //R1Weapon
      First;
      bFound := false;
      while not eof and bFound = false do
        begin
          if iR1W = FieldbyName('WeaponID').asInteger then
            begin
              bFound := true;
              setR1W(FieldbyName('Weapon').asString);
            end
          else Next;
        end; //if R1W

      //R2Weapon
      First;
      bFound := false;
      while not eof and bFound = false do
        begin
          if iR2W = FieldbyName('WeaponID').asInteger then
            begin
              bFound := true;
              setR2W(FieldbyName('Weapon').asString);
            end
          else Next;
        end; //if R2W

    end;//with tblWeapons

end;

procedure THunterBuild.SearchForUser(UserID: integer);
  var bFound : boolean;
begin
  //Intailize
  bFound := false;

  //Loop through DB
  with dmHunter.tblBuild do
    begin
      Open;
      First;
      while not eof and bFound = false do
        begin
          if UserID = FieldbyName('UserID').asInteger then
            begin
              bFound := true;
              setUserID(UserID);
              setBuildID(FieldbyName('BuildID').asInteger);
            end//if UserID =
          else Next;
        end;// while eof + = false
      Close;
    end;//with tblBuild
end;

procedure THunterBuild.setArcane(iArcane: integer);
begin
  fArcane := iArcane;
end;

procedure THunterBuild.setBloodEchoes(iBloodEchoes: integer);
begin
  fBloodEchoes := iBloodEchoes;
end;

procedure THunterBuild.setBloodtinge(iBloodTinge: integer);
begin
  fBloodtinge := iBloodtinge;
end;

procedure THunterBuild.setBuildID(BuildID: integer);
begin
  fBuildID := BuildID;
end;

procedure THunterBuild.setCharBuild;
  var bFound : boolean;
begin
  //Intailize
  bFound := false;

  //Loop through DB
  with dmHunter.tblBuild do
    begin
      Open;
      First;
      while not eof and bFound = false do
        begin
          if fBuildID = FieldbyName('BuildID').asInteger then
            begin
              bFound := true;
              setVitality(FieldbyName('Vitality').asInteger);
              setEndurance(FieldbyName('Endurance').AsInteger);
              setStrength(FieldbyName('Strength').AsInteger);
              setSkill(FieldbyName('Skill').asInteger);
              setBloodtinge(FieldbyName('Bloodtinge').asInteger);
              setArcane(FieldbyName('Arcane').asInteger);
            end//if BuildID =
          else Next;
        end;// while eof + = false
      Close;
    end;//with tblBuild
end;

procedure THunterBuild.setCharDetails;
  var bFound : boolean;
begin
  //Intailize
  bFound := false;

  //Loop through DB
  with dmHunter.tblBuild do
    begin
      Open;
      First;
      while not eof and bFound = false do
        begin
          if fBuildID = FieldbyName('BuildID').asInteger then
            begin
              bFound := true;
              setName(FieldbyName('Name').asString);
              setGender(FieldbyName('Gender').asString);
              setLevel(FieldbyName('Level').asInteger);
              setInsight(FieldbyName('Insight').asInteger);
            end;//if BuildID =

        end;// while eof + = false
      Close;
    end;//with tblBuild
end;

procedure THunterBuild.setEndurance(iEnder: integer);
begin
  fEndurance := iEnder;
end;

procedure THunterBuild.setGender(sGender: string);
begin
  fGender := sGender;
end;

procedure THunterBuild.setInsight(iInsight: integer);
begin
  fInsight := iInsight;
end;

procedure THunterBuild.setL1W(L1W: string);
begin
  fL1Weapon := L1W;
end;

procedure THunterBuild.setL2W(L2W: string);
begin
  fL2Weapon := L2W;
end;

procedure THunterBuild.setLevel(iLevel: integer);
begin
  fLevel := iLevel;
end;

procedure THunterBuild.setName(sName: string);
begin
  fName := sName;
end;

procedure THunterBuild.setR1W(R1W: string);
begin
  fR1Weapon := R1W;
end;

procedure THunterBuild.setR2W(R2W: string);
begin
  fR2Weapon := R2W;
end;

procedure THunterBuild.setSkill(iSkill: integer);
begin
  fSkill := iSkill;
end;

procedure THunterBuild.setStrength(iStreng: integer);
begin
  fStrength := iStreng;
end;

procedure THunterBuild.setUserID(UserID: integer);
begin
  fUserID := UserID;
end;

procedure THunterBuild.setVitality(iVital: integer);
begin
  fVitality := iVital;
end;

procedure THunterBuild.SkillBuild(iLevel: integer);
  var iStreng, iEnder, iVital, iSkill, iBlood, iArcane : integer;
begin
  //"Determine" Base stats of build from level
  iVital := floor(iLevel * 0.25);
  iEnder := floor(iLevel * 0.20);
  iStreng := floor(iLevel * 0.10);
  iSkill := floor(iLevel * 0.35);
  iBlood := floor(iLevel * 0.05);
  iArcane := floor(iLevel * 0.06);

  //Give attributes values
  setVitality(iVital);
  setEndurance(iEnder);
  setStrength(iStreng);
  setSkill(iSkill);
  setBloodtinge(iBlood);
  setArcane(iArcane);
end;

procedure THunterBuild.StrengthBuild(iLevel: integer);
  var iStreng, iEnder, iVital, iSkill, iBlood, iArcane : integer;
begin
  //"Determine" Base stats of build from level
  iVital := floor(iLevel * 0.25);
  iEnder := floor(iLevel * 0.20);
  iStreng := floor(iLevel * 0.35);
  iSkill := floor(iLevel * 0.10);
  iBlood := floor(iLevel * 0.05);
  iArcane := floor(iLevel * 0.06);

  //Give attributes values
  setVitality(iVital);
  setEndurance(iEnder);
  setStrength(iStreng);
  setSkill(iSkill);
  setBloodtinge(iBlood);
  setArcane(iArcane);

end;

procedure THunterBuild.UpdateBuild( iLevel, iVital, iEndurance, iStrength, iSkill, iBloodtinge, iArcane : integer);
  var bFound : boolean;
begin
  //Intailize
  bFound := false;

  //Loop through DB
  with dmHunter.tblBuild do
    begin
      Open;
      First;
      while not eof and bFound = false do
        begin
          if fBuildID = FieldbyName('BuildID').asInteger then
            begin
              bFound := true;
              Edit;
              FieldbyName('Vitality').asInteger := iVital;
              FieldbyName('Endurance').asInteger := iEndurance;
              FieldbyName('Strength').asInteger := iStrength;
              FieldbyName('Skill').asInteger := iSkill;
              FieldbyName('Bloodtinge').asInteger := iBloodtinge;
              FieldbyName('Arcane').asInteger := iArcane;
              Post;
              MessageDlg('Changes has been saved.', TMsgDlgType.mtInformation, [TMsgDlgBtn.mbOk], 0);
            end//if BuildID =
          else Next;
        end;// while eof + = false
      Close;
    end;//with tblBuild
end;

procedure THunterBuild.ArcaneBuild(iLevel: integer);
  var iStreng, iEnder, iVital, iSkill, iBlood, iArcane : integer;
begin
  //"Determine" Base stats of build from level
  iVital := floor(iLevel * 0.25);
  iEnder := floor(iLevel * 0.20);
  iStreng := floor(iLevel * 0.05);
  iSkill := floor(iLevel * 0.35);
  iBlood := floor(iLevel * 0.06);
  iArcane := floor(iLevel * 0.35);

  //Give attributes values
  setVitality(iVital);
  setEndurance(iEnder);
  setStrength(iStreng);
  setSkill(iSkill);
  setBloodtinge(iBlood);
  setArcane(iArcane);
end;

procedure THunterBuild.BloodtingeBuild(iLevel: integer);
  var iStreng, iEnder, iVital, iSkill, iBlood, iArcane : integer;
begin
  //"Determine" Base stats of build from level
  iVital := floor(iLevel * 0.25);
  iEnder := floor(iLevel * 0.20);
  iStreng := floor(iLevel * 0.05);
  iSkill := floor(iLevel * 0.10);
  iBlood := floor(iLevel * 0.35);
  iArcane := floor(iLevel * 0.06);

  //Give attributes values
  setVitality(iVital);
  setEndurance(iEnder);
  setStrength(iStreng);
  setSkill(iSkill);
  setBloodtinge(iBlood);
  setArcane(iArcane);
end;

constructor THunterBuild.CreateHunterBuild;
begin
  fName := '';
  fGender := 'N';
  fUserID := 0;
  fBuildID := 0;
  fLevel := 0;
  fBloodEchoes := 0;
  fInsight := 0;
  fVitality := 0;
  fEndurance := 0;
  fStrength := 0;
  fSkill := 0;
  fBloodtinge := 0;
  fArcane := 0;

end;

end.
