unit HunterJournalMain_u;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.Memo.Types, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo,
  FMX.StdCtrls, FMX.Objects, FMX.Styles.Objects, HunterBuild_u, FMX.Edit,
  FMX.EditBox, FMX.SpinBox, FMX.ListBox, FMX.Menus, FMX.ExtCtrls, FMX.ComboEdit,
  System.ImageList, FMX.ImgList, FMX.Ani, FMX.Colors, FMX.DateTimeCtrls;

type
  TfrmJournalMain = class(TForm)
    tbcMain: TTabControl;
    tbiJournal: TTabItem;
    pnlBackground1: TPanel;
    memEntry: TMemo;
    pnlEntryOptions: TPanel;
    btnSaveEntry: TCornerButton;
    btnLoadEntry: TCornerButton;
    btnEntryLog: TCornerButton;
    btnDeleteEntry: TCornerButton;
    tbiBuild: TTabItem;
    pnlBackground2: TPanel;
    pnlCharDetails: TPanel;
    pnlBuildDetails: TPanel;
    lblCharName: TLabel;
    lblGender: TLabel;
    lblLevel: TLabel;
    lblBloodEchoes: TLabel;
    lblInsight: TLabel;
    lblCharStrength: TLabel;
    lblCharSkill: TLabel;
    lblCharBloodtinge: TLabel;
    lblCharArcane: TLabel;
    lblStrength: TLabel;
    lblSkill: TLabel;
    lblBloodtinge: TLabel;
    lblArcane: TLabel;
    lblVitality: TLabel;
    lblEndurance: TLabel;
    lblCharVital: TLabel;
    lblCharEnder: TLabel;
    lblLeftWeapon: TLabel;
    lblRightWeapon: TLabel;
    lblLWeapon: TLabel;
    lblRWeapon: TLabel;
    btnChangeLeft: TCornerButton;
    btnRWChange: TCornerButton;
    tbiChangeBuild: TTabItem;
    pnlBackGround3: TPanel;
    Panel1: TPanel;
    spbBloodtinge: TSpinBox;
    lblChangeStreng: TLabel;
    lblChangeSkill: TLabel;
    lblChangeBlood: TLabel;
    lblChangeArcane: TLabel;
    lblChangeVital: TLabel;
    lblEnder: TLabel;
    spbVital: TSpinBox;
    spbEnder: TSpinBox;
    spbStrength: TSpinBox;
    spbSkill: TSpinBox;
    spbArcane: TSpinBox;
    pnlChangeBuildSettings: TPanel;
    btnSaveBuildChanges: TCornerButton;
    btnPresetBuild: TCornerButton;
    cmbBuildPreset: TComboBox;
    tbiAccount: TTabItem;
    pnlBackground4: TPanel;
    Panel2: TPanel;
    lblAccount: TLabel;
    edtUserName: TEdit;
    edtPassword: TEdit;
    dedtBirth: TDateEdit;
    lblUsername: TLabel;
    lblPassword: TLabel;
    lblBirthDay: TLabel;
    lblAge: TLabel;
    spbAge: TSpinBox;
    btnAccount: TCornerButton;
    tbiAchievement: TTabItem;
    pnlBackGround5: TPanel;
    lblBosses: TLabel;
    CheckBox1: TCheckBox;
    ImageList1: TImageList;
    Image1: TImage;
    procedure btnSaveEntryClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnLoadEntryClick(Sender: TObject);
    procedure btnEntryLogClick(Sender: TObject);
    procedure btnDeleteEntryClick(Sender: TObject);
    procedure tbiBuildClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnChangeLeftClick(Sender: TObject);
    procedure btnRWChangeClick(Sender: TObject);
    procedure tbiChangeBuildClick(Sender: TObject);
    procedure btnSaveBuildChangesClick(Sender: TObject);
    procedure cmbBuildPresetChange(Sender: TObject);
    procedure btnPresetBuildClick(Sender: TObject);
    procedure btnAccountClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure GetJournalID;
    function ValidateLetters(sLine : string) : boolean;
    function ValidateNumbers(sLine : string) : boolean;
    function ValidateSpecialChar(sLine : string ) : boolean;
    function DetermineEntryID : integer;
    function DetermineUserID : integer;
  end;

var
  frmJournalMain: TfrmJournalMain;
  iUserID, iJournalID, iEntryID: integer;
  objHunterBuild : THunterBuild;
  bLeftWeapon, bRightWeapon, bCreateAcc : boolean;

implementation

uses
  dmHunterJournal_u;

{$R *.fmx}

procedure TfrmJournalMain.btnAccountClick(Sender: TObject);
  var sUsername, sPassword, sDOB, sDate :string;
  iAge, iEstimatedAge : integer;
begin
  //Validation of input
  //Username
  sUsername := edtUsername.Text;
  if sUsername = '' then exit;

  //Password
  sPassword := edtPassword.Text;
  if sPassword = '' then exit;

  //DOB and Age
  sDOB := dedtBirth.Text;
  iAge := trunc(spbAge.Value);
  iEstimatedAge := strtoint(copy(datetostr(date()),1,4)) - strtoint(copy(sDOB ,1, 4));
  if iEstimatedAge < iAge then
    begin
      //Chech via day if it is valid
      if strtoint(copy(datetostr(date()),9,2)) < strtoint(copy(sDOB ,9, 2)) then
        begin
          MessageDlg('Your age is incorrect.', TMsgDlgType.mtError, [TMsgDlgBtn.mbOk], 0);
          Exit;
        end;

    end;

  //If Add Account
  if bCreateAcc = true then
    begin
      with dmHunter.tblUser do
        begin
          Open;
          Insert;
          FieldbyName('UserID').AsInteger := DetermineUserID;
          FieldbyName('Username').AsString := sUsername;
          FieldbyName('UserPassword').AsString := sPassword;
          FieldbyName('DateOfBirth').AsDateTime := strtodate(sDOB);
          FieldbyName('Age').AsInteger := iAge;
          Post;
          Close;
          MessageDlg('Your account has been created.', TMsgDlgType.mtInformation, [TMsgDlgBtn.mbOk], 0);
        end;

    end
  else //IF Change Details
    begin
      with dmHunter.tblUser do
        begin
          Open;
          Edit;
          FieldbyName('UserID').AsInteger := DetermineUserID;
          FieldbyName('Username').AsString := sUsername;
          FieldbyName('UserPassword').AsString := sPassword;
          FieldbyName('DateOfBirth').AsDateTime := strtodate(sDOB);
          FieldbyName('Age').AsInteger := iAge;
          Post;
          Close;
          MessageDlg('Your account details has been changed.', TMsgDlgType.mtInformation, [TMsgDlgBtn.mbOk], 0);
        end;
    end;

end;

procedure TfrmJournalMain.btnChangeLeftClick(Sender: TObject);
begin
  if bLeftWeapon = true then
    begin
      lblLeftWeapon.Text := 'Left Weapon 2';
      lblLWeapon.Text := objHunterBuild.getL2W;
      bLeftWeapon := false;
    end
  else if bLeftWeapon = false then
    begin
      lblLeftWeapon.Text := 'Left Weapon 1';
      lblLWeapon.Text := objHunterBuild.getL1W;
      bLeftWeapon := true;
    end;

end;

procedure TfrmJournalMain.btnDeleteEntryClick(Sender: TObject);
  var bFound : boolean;
  sSearchdate : string;
begin
  //Get the Date
  sSearchDate := inputbox('Load Entry',' What is the date of the searched entry ','');

  //Validation of the date
  //Year
  if strtoint(copy(sSearchDate,1,4)) > strtoint(copy(datetostr(date()),1,4)) then
    begin
      MessageDlg('Date is invalid.', TMsgDlgType.mtError, [TMsgDlgBtn.mbOk], 0);
      exit;
    end;
  //Month
   if strtoint(copy(sSearchDate,6,2)) > 12 then
    begin
      MessageDlg('Date is invalid.', TMsgDlgType.mtError, [TMsgDlgBtn.mbOk], 0);
      exit;
    end;
   //Day
   if frac(strtoint(copy(sSearchDate,6,2))/2) = 0 then
    begin
      if strtoint(copy(sSearchDate,9,2)) > 30 then
        begin
          if strtoint(copy(sSearchDate,6,2)) = 8 then
            begin
              if strtoint(copy(sSearchDate,9,2)) > 31 then
                begin
                  MessageDlg('Date is invalid.', TMsgDlgType.mtError, [TMsgDlgBtn.mbOk], 0);
                  exit;
                end;

            end//if August
          else
            begin
              MessageDlg('Date is invalid.', TMsgDlgType.mtError, [TMsgDlgBtn.mbOk], 0);
              exit;
            end;//if any other 30 day month

        end;//if day > 30

    end //if month has 30 days
   else
   if frac(strtoint(copy(sSearchDate,6,2))/2) > 0 then
    begin
      if strtoint(copy(sSearchDate,9,2)) > 31 then
        begin
          MessageDlg('Date is invalid.', TMsgDlgType.mtError, [TMsgDlgBtn.mbOk], 0);
          exit;
        end;
    end;//if month has 31 days

    //Look for entry in tblEntry
  with dmHunter.tblEntry do
    begin
      Open;
      GetJournalID;
      Filtered := false;
      Filter := 'JournalID = ' + quotedstr(inttostr(iJournalID));
      Filtered := true;
      First;
      while not eof and bFound = false do
        begin
          if FieldbyName('DateOfEntry').AsString = sSearchDate then
            begin
              bFound := true;
              if MessageDlg('Entry not found. Please try a diffrent date..', TMsgDlgType.mtInformation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo ], 0) = mrYes  then
                begin
                  Delete;
                  MessageDlg('Entry was deleted', TMsgDlgType.mtInformation, [TMsgDlgBtn.mbOk], 0);
                end;

            end//if date =
          else Next;

        end;// while not eof
        if bFound = false then MessageDlg('Entry not found. Please try a diffrent date.', TMsgDlgType.mtInformation, [TMsgDlgBtn.mbOk], 0);

    end;//with tblEntry
end;

procedure TfrmJournalMain.btnEntryLogClick(Sender: TObject);
  var iRecord : integer;
begin
  //Intialize
  iRecord := 0;

  //Loop through tblEntry + display dates of all entries made form the most recent ones
  with dmHunter.tblEntry do
    begin
      Open;
      GetJournalID;
      Filtered := false;
      Filter := 'JournalID = ' + quotedstr(inttostr(iJournalID));
      Filtered := true;
      Last;
      iRecord := RecordCount;
      while iRecord > 0  do
        begin
          iRecord := iRecord -1;
          memEntry.Lines.Add(FieldbyName('DateOfEntry').AsString);
          Prior;
        end;

    end;//with tblEntry

end;

procedure TfrmJournalMain.btnLoadEntryClick(Sender: TObject);
  var sSearchDate, s : string;
  bFound : boolean;
begin
  //Intailize
  bFound := false;

  //Get the Date
  sSearchDate := inputbox('Load Entry',' What is the date of the searched entry ','');

  //Validation of the date
  //Year
  if strtoint(copy(sSearchDate,1,4)) > strtoint(copy(datetostr(date()),1,4)) then
    begin
      MessageDlg('Date is invalid.', TMsgDlgType.mtError, [TMsgDlgBtn.mbOk], 0);
      exit;
    end;
  //Month
   if strtoint(copy(sSearchDate,6,2)) > 12 then
    begin
      MessageDlg('Date is invalid.', TMsgDlgType.mtError, [TMsgDlgBtn.mbOk], 0);
      exit;
    end;
   //Day
   if frac(strtoint(copy(sSearchDate,6,2))/2) = 0 then
    begin
      if strtoint(copy(sSearchDate,9,2)) > 30 then
        begin
          if strtoint(copy(sSearchDate,6,2)) = 8 then
            begin
              if strtoint(copy(sSearchDate,9,2)) > 31 then
                begin
                  MessageDlg('Date is invalid.', TMsgDlgType.mtError, [TMsgDlgBtn.mbOk], 0);
                  exit;
                end;

            end//if August
          else
            begin
              MessageDlg('Date is invalid.', TMsgDlgType.mtError, [TMsgDlgBtn.mbOk], 0);
              exit;
            end;//if any other 30 day month

        end;//if day > 30

    end //if month has 30 days
   else
   if frac(strtoint(copy(sSearchDate,6,2))/2) > 0 then
    begin
      if strtoint(copy(sSearchDate,9,2)) > 31 then
        begin
          MessageDlg('Date is invalid.', TMsgDlgType.mtError, [TMsgDlgBtn.mbOk], 0);
          exit;
        end;
    end;//if month has 31 days

  //Look for entry in tblEntry
  with dmHunter.tblEntry do
    begin
      Open;
      GetJournalID;
      Filtered := false;
      Filter := 'JournalID = ' + quotedstr(inttostr(iJournalID));
      Filtered := true;
      First;
      while not eof and bFound = false do
        begin
          s := FieldbyName('DateOfEntry').AsString;
          if FieldbyName('DateOfEntry').AsString = sSearchDate then
            begin
              bFound := true;
              memEntry.Lines.Add(FieldbyName('DateOfEntry').AsString);
              memEntry.Lines.AddStrings(Fieldbyname('EntryDetails').AsWideString);
            end
          else Next;
        end;// if Date =
        if bFound = false then MessageDlg('Entry not found. Please try a diffrent date.', TMsgDlgType.mtInformation, [TMsgDlgBtn.mbOk], 0);

    end;//with tblEntry

end;

procedure TfrmJournalMain.btnPresetBuildClick(Sender: TObject);
begin
  cmbBuildPreset.Visible := true;
end;

procedure TfrmJournalMain.btnRWChangeClick(Sender: TObject);
begin
  if bRightWeapon = true then
    begin
      lblRightWeapon.Text := 'Right Weapon 2';
      lblRWeapon.Text := objHunterBuild.getR2W;
      bRightWeapon := false;
    end
  else if bRightWeapon = false then
    begin
      lblRightWeapon.Text := 'Right Weapon 1';
      lblRWeapon.Text := objHunterBuild.getR2W;
      bRightWeapon := true;
    end;
end;

procedure TfrmJournalMain.btnSaveBuildChangesClick(Sender: TObject);
  var iLevel, iVital, iEnder, iStreng, iSkill, iBlood, iArcane : integer;
begin
  //Get values
  iLevel := objHunterBuild.getLevel;
  iVital := trunc(spbvital.Value);
  iEnder := trunc(spbEnder.Value);
  iStreng := trunc(spbStrength.Value);
  iSkill := trunc(spbSkill.Value);
  iBlood := trunc(spbBloodtinge.Value);
  iArcane := trunc(spbArcane.Value);

  //Confirm from user
  iLevel := iVital +iEnder + iStreng + iSkill + iBlood + iArcane;
  if MessageDlg('So your new level is ' + inttostr(iLevel) + '?', TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0) = mrYes then
    begin
      if objHunterBuild.DetermineChangesValid(iLevel, iVital, iEnder, iStreng, iSkill, iBlood, iArcane) = false then
        begin
          MessageDlg('Changes were not saved', TMsgDlgType.mtInformation, [TMsgDlgBtn.mbOk], 0);
          exit;
        end// if result = false
      else
        begin
          objHunterBuild.UpdateBuild(iLevel, iVital, iEnder, iStreng, iSkill, iBlood, iArcane);
        end;// result = true

    end; //if mrYes


end;

procedure TfrmJournalMain.btnSaveEntryClick(Sender: TObject);
  var sEntry : Widestring;
  bEntryMade : boolean;
begin
  //Intailize
  sEntry := '';
  bEntryMade := false;

  //Get the needed info
  iEntryID := DetermineEntryID;
  GetJournalID;

  //Check if entry is already made for the day
  with dmHunter.tblEntry do
    begin
      Open;
      Filtered := false;
      Filter := 'JournalID = ' + quotedstr(inttostr(iJournalID));
      Filtered := true;
      First;
      while not eof and bEntryMade do
        begin
          if FieldbyName('DateOfEntry').AsDateTime = Date() then
            begin
              bEntryMade := true;
            end
          else Next;
        end;// if Date =
      if bEntryMade = false then
        begin
          MessageDlg('You already made an entry for today good hunter.', TMsgDlgType.mtError, [TMsgDlgBtn.mbOk], 0);
          Filtered := false;
          Close;
          Exit;
        end// entry = false
      else
        begin
          Filtered := false;
          Close;
        end;  //entry = true

    end;//tblEntry

  //Get Entry Details
  sEntry := memEntry.Lines.GetText;
  if sEntry = '' then
    begin
      MessageDlg('An empty entry cannot be saved.', TMsgDlgType.mtInformation, [TMsgDlgBtn.mbOk], 0);
      exit;
    end;

  //Load to database with needed info
  With dmHunter.tblEntry do
    begin
      Open;
      Insert;
      Fieldbyname('EntryID').AsInteger := iEntryID;
      FieldbyName('EntryDetails').AsWideString := sEntry;
      Fieldbyname('DateOfEntry').AsDateTime := date();
      Fieldbyname('JournalID').AsInteger := iJournalID;
      Post;
      Close;
    end;//with tblEntry

  //Reply to user
  MessageDlg('Your entry was saved.', TMsgDlgType.mtInformation, [TMsgDlgBtn.mbOk], 0);

end;

procedure TfrmJournalMain.cmbBuildPresetChange(Sender: TObject);
  var iLevel : integer;
begin
  iLevel := objHunterBuild.getLevel;
  case cmbBuildPreset.ItemIndex of
    0 :objHunterBuild.StrengthBuild(iLevel);
    1 :objHunterBuild.SKillBuild(iLevel);
    2 :objHunterBuild.BloodtingeBuild(iLevel);
    3 :objHunterBuild.ArcaneBuild(iLevel);
  end;

  //Load build values to spinbox
  spbVital.Value := objHunterBuild.getVitality;
  spbEnder.Value := objHunterBuild.getEndurance;
  spbStrength.Value := objHunterBuild.getStrength;
  spbSkill.Value := objHunterBuild.getSkill;
  spbBloodtinge.Value := objHunterBuild.getBloodtinge;
  spbArcane.Value := objHunterBuild.getArcane;
end;

function TfrmJournalMain.DetermineEntryID: integer;
begin
  with dmHunter.tblEntry do
    begin
      Open;
      Result := Recordcount + 1;
      Close;
    end;//with tblEntry
end;

function TfrmJournalMain.DetermineUserID: integer;
begin
  with dmHunter.tblUser do
    begin
      Open;
      First;
      Result := RecordCount + 1;
      Close;
    end;
end;

procedure TfrmJournalMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  objHunterBuild.Free;
end;

procedure TfrmJournalMain.FormShow(Sender: TObject);
begin
  //Intialize Global VAR
  iUserID := 0;
  iJournalID := 0;
  iEntryID := 0;
  bLeftWeapon := true;
  bRightWeapon := true;
  bCreateAcc := false;

  //Shitty fix for display issue at start
  frmJournalMAin.ClientHeight := 1;  //shitty solution much
  frmJournalMain.ClientWidth := 1;
end;

procedure TfrmJournalMain.GetJournalID;
  var bFound : boolean;
begin
  bFound := false;
  With dmHunter.tblJournal do
    begin
      //Search for Journal
      Open;
      while not eof and bFound = false do
        begin
          if iUserID = FieldByName('UserID').asInteger then
            begin
              bFound := true;
              iJournalID := FieldByName('JournalID').asInteger
            end//if UserID=
          else Next;

        end;//while not eof
      Close;
    end;//with tblJournal
end;

procedure TfrmJournalMain.tbiBuildClick(Sender: TObject);
begin
  //Create objHunterBuild
  objHunterBuild := THunterBuild.CreateHunterBuild;

  //Use objHunterBuild

  //Build Details
  objHunterBuild.SearchForUser(iUserID);
  objHunterBuild.setCharDetails;
  objHunterBuild.setCharBuild;
  objHunterBuild.LoadWeapons;

  //Dislplay appropriately - The character details
  lblCharName.Text := objHunterBuild.getName;
  if objHunterBuild.getGender = 'M' then lblGender.Text := 'Male' else lblGender.Text := 'Female';
  lblLevel.Text := inttostr(objHunterBuild.getLevel);
  lblBloodEchoes.Text := inttostr(objHunterBuild.getBloodEchoes);
  lblInsight.Text := inttostr(objHunterBuild.getInsight);

  //- Build Details
  lblCharVital.Text := inttostr(objHunterBuild.getVitality);
  lblCharEnder.text := inttostr(objHunterBuild.getEndurance);
  lblCharStrength.Text := inttostr(objHunterBuild.getStrength);
  lblCharSkill.Text := inttostr(objHunterBuild.getSkill);
  lblCharBloodtinge.Text := inttostr(objHunterBuild.getBloodtinge);
  lblCharArcane.Text := inttostr(objHunterBuild.getArcane);
  lblLeftWeapon.Text := objHunterBuild.getL1W;
  lblRightWeapon.Text := objHunterBuild.getR1W;
end;

procedure TfrmJournalMain.tbiChangeBuildClick(Sender: TObject);
begin
  //Load build values to spinbox
  spbVital.Value := objHunterBuild.getVitality;
  spbEnder.Value := objHunterBuild.getEndurance;
  spbStrength.Value := objHunterBuild.getStrength;
  spbSkill.Value := objHunterBuild.getSkill;
  spbBloodtinge.Value := objHunterBuild.getBloodtinge;
  spbArcane.Value := objHunterBuild.getArcane;

end;

function TfrmJournalMain.ValidateLetters(sLine : string): boolean;
  var l, i, iLetter : integer;
begin
  for l := 1 to Length(sLine) do
    begin
      for i  := 1 to Length(sLine) do
        begin
          if sLine[l] in ['A'..'Z'] then inc(iLetter) else
            if sLine[l] in ['a'..'z'] then inc(iLetter);
        end;
    end;
  if iLetter >=1 then result := true else result := false;

end;

function TfrmJournalMain.ValidateNumbers(sLine: string): boolean;
  var l, i, iNumber : integer;
begin
  for l := 1 to Length(sLine) do
    begin
      for i  := 1 to Length(sLine) do
        begin
          if sLine[l] in ['0'..'9'] then inc(iNumber);
        end;
    end;
  if iNumber >=1 then result := true else result := false;
end;

function TfrmJournalMain.ValidateSpecialChar(sLine: string): boolean;
  const SpecialChar : string = '!@#$%^&*()_-+={[}]:;"<,>.?/~`';
   var l, i, iSpecChar : integer;
begin
  for l := 1 to Length(sLine) do
    begin
      for i  := 1 to Length(sLine) do
        begin
          if sLine[l] = SpecialChar[i] then inc(iSpecChar);
        end;
    end;
  if iSpecChar >=1 then result := true else result := false;
end;

end.
