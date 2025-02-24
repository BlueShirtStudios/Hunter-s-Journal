unit HunterLogin_u;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.Edit, FMX.StdCtrls, dmHunterJournal_u ,HunterJournalMain_u;

type
  TfrmHunterLogin = class(TForm)
    edtPassword: TEdit;
    PassEdtBtn: TPasswordEditButton;
    edtUsername: TEdit;
    btnLogin: TCornerButton;
    procedure btnLoginClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmHunterLogin: TfrmHunterLogin;

implementation

{$R *.fmx}

procedure TfrmHunterLogin.btnLoginClick(Sender: TObject);
  var sSQL, sUsername, sPassword : string;
  bFound : boolean;
begin
  //Username
  sUsername := edtUsername.text;
  if sUsername = '' then
    begin
      MessageDlg('Please enter your username.', TMsgDlgType.mtInformation, [TMsgDlgBtn.mbOk], 0);
      exit;
    end;

  //Password
  sPassword := edtPassword.text;
  if sPassword = '' then
    begin
      MessageDlg('Please enter your password.', TMsgDlgType.mtInformation, [TMsgDlgBtn.mbOk], 0);
      exit;
    end;

  //Look for User
  bFound := false;
  with dmHunter.tblUser do
    begin
      Open;
      while not eof and bFound = false do
        begin
          if (sUsername = Fieldbyname('Username').AsString) and (sPassword = Fieldbyname('UserPassword').AsString) then
            begin
              bFound := true;
              iUserID := FieldbyName('UserID').AsInteger;
            end//if =
          else Next;
        end;// not eof
       Close;
    end;//with tblUser

  //Grant access to hometab
  if bFound = true then
    begin
      MessageDlg('Welcome Hunter.', TMsgDlgType.mtInformation, [TMsgDlgBtn.mbOk], 0);
      frmjournalMain.Visible := true;
      frmJournalMAin.ClientHeight := 480;  //shitty solution much
      frmJournalMain.ClientWidth := 255;
      frmHunterLogin.Close;
    end
  else MessageDlg('Username or password in not correct.', TMsgDlgType.mtError, [TMsgDlgBtn.mbOk], 0);
end;

end.
