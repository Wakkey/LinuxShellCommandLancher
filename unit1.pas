unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Process;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    ListBox1: TListBox;
    Panel1: TPanel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
  private
    { private declarations }
    password:string;
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

function pross(command,pas:string):boolean;
var
  sv: TProcess;
  ps:string;
begin
    sv := TProcess.Create(nil);
    ps := pas;

    sv.Executable:= '/bin/sh';
    sv.Parameters.Add('-c');
    sv.Parameters.Add('echo ' +ps+ ' | sudo -S ' + command );
    sv.Execute;
    sv.Free;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  pross(form1.Edit1.Text, password);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if -1 = form1.ListBox1.Items.IndexOf(form1.Edit1.Text) then
    form1.ListBox1.Items.Add(form1.Edit1.Text);
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: boolean);
var
  st:Tstringlist;
begin
  st := TStringList.Create;
  st.Clear;
  try
    st.Text := form1.ListBox1.Items.Text;
    st.SaveToFile(extractfilepath(Paramstr(0)) + 'CommandList.txt');
  except

  end;
  st.Free;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  st:Tstringlist;
begin
  password := inputbox('Input Password', 'Please type Password', '');
  st := TStringList.Create;
  st.Clear;
  try
    st.LoadFromFile(extractfilepath(Paramstr(0)) + 'CommandList.txt');
    form1.ListBox1.Items.Text:= st.Text;
  except

  end;
  st.Free;
end;

procedure TForm1.ListBox1Click(Sender: TObject);
begin
  if form1.ListBox1.Items.Count > 0 then
    form1.Edit1.Text:= form1.ListBox1.Items[form1.ListBox1.ItemIndex];
end;

procedure TForm1.ListBox1DblClick(Sender: TObject);
begin
  Button1Click(Sender);
end;

end.

