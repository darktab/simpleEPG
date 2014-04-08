unit UMainTabbedForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  UMainForm, FMX.TabControl, FMX.Layouts, FMX.Memo, FMX.ListView.Types,
  FMX.ListView, Data.DB, FMX.ListBox, UDataComboListViewFrame,
  UBackDataComboListViewFrame, System.Actions, FMX.ActnList, FireDAC.UI.Intf,
  FireDAC.FMXUI.Wait, FireDAC.Stan.Intf, FireDAC.Comp.UI, UDataListView;

type
  TMainTabbedForm = class(TMainForm)
    MainTabControl: TTabControl;
    TabItem1: TTabItem;
    TextEPGTabItem: TTabItem;
    TimersTabItem: TTabItem;
    TabItem4: TTabItem;
    DataComboListViewFrameChannelList: TDataComboListViewFrame;
    TextEPGTabControl: TTabControl;
    TextEPGMasterTabItem: TTabItem;
    TextEPGDetailTabItem: TTabItem;
    TextEPGBackDataComboListViewFrame: TBackDataComboListViewFrame;
    TextEPGActionList: TActionList;
    ToDetailChangeTabAction: TChangeTabAction;
    ToMasterChangeTabAction: TChangeTabAction;
    TextEPGInfoTabItem: TTabItem;
    TextEPGInfoToolBar: TToolBar;
    TextEPGBackButton: TButton;
    TextEPGTitleLabel: TLabel;
    ToInfoChangeTabAction: TChangeTabAction;
    TextEPGInfoLabel: TLabel;
    TextEPGInfoMemo: TMemo;
    TextEPGInfoRecordButton: TButton;
    TextEPGDateTimeLabel: TLabel;
    TimersTopToolBar: TToolBar;
    Label1: TLabel;
    TimersDataListView: TDataListView;
    procedure FormShow(Sender: TObject);
    procedure ComboBoxServiceListChange(Sender: TObject);
    procedure DataComboListViewFrameChannelListDataListViewItemClick
      (const Sender: TObject; const AItem: TListViewItem);
    procedure TextEPGBackDataComboListViewFrameDataListViewItemClick
      (const Sender: TObject; const AItem: TListViewItem);
    procedure TextEPGInfoRecordButtonClick(Sender: TObject);
    procedure TimersDataListViewDeletingItem(Sender: TObject; AIndex: Integer;
      var ACanDelete: Boolean);

  private
    procedure initTimerDataListView;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainTabbedForm: TMainTabbedForm;

implementation

uses
  UMainDataModule;

{$R *.fmx}

procedure TMainTabbedForm.ComboBoxServiceListChange(Sender: TObject);
begin
  inherited;
  // initChannelListView();
end;

procedure TMainTabbedForm.FormShow(Sender: TObject);
var
  lDefaultServiceReference: string;
begin
  inherited;

  // initialisation des channels
  self.DataComboListViewFrameChannelList.init
    (MainDataModule.DreamFDMemTableServiceList, 'servicename',
    MainDataModule.DreamRESTRequestServiceList,
    MainDataModule.DreamRESTResponseDataSetAdapterServiceList,
    MainDataModule.DreamFDMemTableChannelList, 'servicename',
    MainDataModule.DreamRESTRequestChannelList,
    MainDataModule.DreamRESTResponseDataSetAdapterChannelList,
    'servicereference');

  // initialisation des timers
  initTimerDataListView;
end;

procedure TMainTabbedForm.TextEPGBackDataComboListViewFrameDataListViewItemClick
  (const Sender: TObject; const AItem: TListViewItem);
begin
  inherited;
  TextEPGBackDataComboListViewFrame.DataListViewItemClick(Sender, AItem);
  TextEPGTitleLabel.Text := MainDataModule.DreamFDMemTableTextEPG.FieldByName
    ('sname').AsString;
  TextEPGInfoLabel.Text := MainDataModule.DreamFDMemTableTextEPG.FieldByName
    ('title').AsString;
  TextEPGDateTimeLabel.Text := MainDataModule.DreamFDMemTableTextEPG.FieldByName
    ('date').AsString + ': ' + MainDataModule.DreamFDMemTableTextEPG.FieldByName
    ('begin').AsString + ' - ' + MainDataModule.DreamFDMemTableTextEPG.
    FieldByName('end').AsString;;
  TextEPGInfoMemo.Text := MainDataModule.DreamFDMemTableTextEPG.FieldByName
    ('longdesc').AsString;
  ToInfoChangeTabAction.ExecuteTarget(self);
end;

// ------------------------
// Schedule a recording
// ------------------------
procedure TMainTabbedForm.TextEPGInfoRecordButtonClick(Sender: TObject);
begin
  inherited;
  MainDataModule.DreamRESTRequestAddTimer.Params[0].Value :=
    MainDataModule.DreamFDMemTableTextEPG.FieldByName('sref').AsString;
  MainDataModule.DreamRESTRequestAddTimer.Params[1].Value :=
    MainDataModule.DreamFDMemTableTextEPG.FieldByName('id').AsString;

  MainDataModule.DreamRESTRequestAddTimer.Execute;
  if MainDataModule.DreamRESTResponseAddTimer.StatusCode = 200 then
  begin
    ShowMessage('Timer successfully scheduled!');
    initTimerDataListView;
  end
  else
  begin
    MessageDlg('The following error occurred: ' +
      MainDataModule.DreamRESTResponseAddTimer.StatusText,
      System.UITypes.TMsgDlgType.mtError, [System.UITypes.TMsgDlgBtn.mbOK], 0);
  end;

end;

// ------------------------
// delete a timer
// ------------------------
procedure TMainTabbedForm.TimersDataListViewDeletingItem(Sender: TObject;
  AIndex: Integer; var ACanDelete: Boolean);
begin
  inherited;
  MainDataModule.DreamRESTRequestDeleteTimer.Params[0].Value :=
    MainDataModule.DreamFDMemTableTimerList.FieldByName('serviceref').AsString;
  MainDataModule.DreamRESTRequestDeleteTimer.Params[1].Value :=
    MainDataModule.DreamFDMemTableTimerList.FieldByName('begin').AsString;
  MainDataModule.DreamRESTRequestDeleteTimer.Params[2].Value :=
    MainDataModule.DreamFDMemTableTimerList.FieldByName('end').AsString;
  MainDataModule.DreamRESTRequestDeleteTimer.Execute;

  if MainDataModule.DreamRESTResponseDeleteTimer.StatusCode = 200 then
  begin
    ShowMessage('Timer successfully deleted!');
    ACanDelete := true;
  end
  else
  begin
    MessageDlg('The following error occurred: ' +
      MainDataModule.DreamRESTResponseAddTimer.StatusText,
      System.UITypes.TMsgDlgType.mtError, [System.UITypes.TMsgDlgBtn.mbOK], 0);
    ACanDelete := false;
  end;
end;

procedure TMainTabbedForm.initTimerDataListView;
var
  lTimersDetailStringlist: TStringList;
begin
  // initialisation des timers
  MainDataModule.DreamRESTRequestTimerList.Execute;
  TimersDataListView.DataSet := MainDataModule.DreamFDMemTableTimerList;
  TimersDataListView.DataFieldName := 'name';
  lTimersDetailStringlist := TStringList.Create;
  lTimersDetailStringlist.Add('servicename');
  lTimersDetailStringlist.Add('realbegin');
  try
    TimersDataListView.init(lTimersDetailStringlist);
  except
  end;
  FreeAndNil(lTimersDetailStringlist);
end;

procedure TMainTabbedForm.DataComboListViewFrameChannelListDataListViewItemClick
  (const Sender: TObject; const AItem: TListViewItem);
var
  lDetailStringList: TStringList;
begin
  inherited;
  ToDetailChangeTabAction.ExecuteTarget(self);

  lDetailStringList := TStringList.Create;

  lDetailStringList.Add('date');
  lDetailStringList.Add('begin');
  lDetailStringList.Add('end');

  self.TextEPGBackDataComboListViewFrame.init
    (MainDataModule.DreamFDMemTableChannelList, 'servicename',
    MainDataModule.DreamRESTRequestChannelList,
    MainDataModule.DreamRESTResponseDataSetAdapterChannelList,
    MainDataModule.DreamFDMemTableTextEPG, 'title', lDetailStringList,
    MainDataModule.DreamRESTRequestTextEPG,
    MainDataModule.DreamRESTResponseDataSetAdapterTextEPG, 'servicereference');

  FreeAndNil(lDetailStringList);

end;

end.
