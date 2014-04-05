unit UBackDataComboListViewFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  UDataComboListViewFrame, FMX.ListView.Types, FMX.ListView, UDataListView,
  FMX.ListBox, UDataComboBox;

type
  TBackDataComboListViewFrame = class(TDataComboListViewFrame)
    TopBackButton: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  BackDataComboListViewFrame: TBackDataComboListViewFrame;

implementation

{$R *.fmx}

end.