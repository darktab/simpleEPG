unit UMultiEPGFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMXTee.Chart, FMXTee.Series.Gantt, FMXTee.Procs, FMXTee.Series, FMX.Gestures;

type
  TMultiEPGFrame = class(TFrame)
    MultiEPGTopToolBar: TToolBar;
    MultiEPGTopLabel: TLabel;
    PanningGestureManager: TGestureManager;
    procedure FrameGesture(Sender: TObject; const EventInfo: TGestureEventInfo;
      var Handled: Boolean);
    procedure FrameMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure FrameMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);

  private
    { Private declarations }
    fChart: TChart;
    fGanttSeries1: TGanttSeries;
    fGanttSeries2: TGanttSeries;
    fLineSeries: TLineSeries;
    fLastPosition: TPointF;
  public
    { Public declarations }
    procedure init;
    Constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.fmx}

constructor TMultiEPGFrame.Create(AOwner: TComponent);
begin
  // Execute the parent (TObject) constructor first
  inherited; // Call the parent Create method

end;

procedure TMultiEPGFrame.FrameGesture(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
var
  lGlobalWidth: Double;
  lLocalWidth: Double;
  lGlobalHeight: Double;
  lLocalHeight: Double;
begin
  { if EventInfo.GestureID = igiPan then
    begin

    lGlobalWidth := fChart.BottomAxis.IAxisSize;
    lGlobalHeight := fChart.LeftAxis.IAxisSize;

    lLocalWidth := fChart.BottomAxis.Maximum - fChart.BottomAxis.Minimum;
    lLocalHeight := fChart.LeftAxis.Maximum - fChart.LeftAxis.Minimum;

    fChart.BottomAxis.Scroll(((fLastPosition.X - EventInfo.Location.X) /
    lGlobalWidth) * lLocalWidth, True);

    fChart.LeftAxis.Scroll(((fLastPosition.Y - EventInfo.Location.Y) /
    lGlobalHeight) * lLocalHeight, True);

    fLastPosition := EventInfo.Location;
    end; }
end;

procedure TMultiEPGFrame.FrameMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  fLastPosition.X := X;
  fLastPosition.Y := Y;
end;

procedure TMultiEPGFrame.FrameMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  fLastPosition.X := X;
  fLastPosition.Y := Y;
end;

procedure TMultiEPGFrame.init;
begin
  fChart := TChart.Create(self);
  fChart.Parent := self;
  fChart.Align := TAlignLayout.Client;

  fChart.View3D := False;
  fChart.BottomAxis.Visible := True;
  fChart.BottomAxis.OtherSide := True;
  // fChart.TopAxis.
  // fChart.TopAxis.Visible := true;
  fChart.Frame.Visible := False;
  fChart.Width := self.Width;
  fChart.Height := self.Height;
  fChart.MarginRight := 0;
  fChart.MarginBottom := 0;

  fChart.Legend.Visible := False;
  fChart.Border.Visible := False;

  fChart.Color := TAlphaColorRec.White;

  fChart.LeftAxis.Inverted := True;
  fChart.LeftAxis.TickOnLabelsOnly := True;

  fChart.LeftAxis.Automatic := False;
  fChart.LeftAxis.Minimum := -0.5;
  fChart.LeftAxis.Maximum := 5;

  fChart.BottomAxis.Automatic := False;
  fChart.BottomAxis.Minimum := 0;
  fChart.BottomAxis.Maximum := 50;

  fChart.AllowZoom := False;
  // fChart.Panning.Active := True;
  fChart.AllowPanning := TPanningMode.pmBoth;
  fChart.ScrollMouseButton := TMouseButton.mbLeft;

  fGanttSeries1 := TGanttSeries.Create(self);
  fGanttSeries2 := TGanttSeries.Create(self);
  fLineSeries := TLineSeries.Create(self);

  fGanttSeries1.AddGanttColor(0, 0, 0, 'TF1 HD', TAlphaColorRec.Honeydew);
  fGanttSeries1.AddGanttColor(0, 0, 1, 'RTL HD', TAlphaColorRec.Honeydew);
  fGanttSeries1.AddGanttColor(0, 0, 2, 'VOX', TAlphaColorRec.Honeydew);
  fGanttSeries1.AddGanttColor(0, 0, 3, 'M6 HD', TAlphaColorRec.Honeydew);
  fGanttSeries1.AddGanttColor(0, 0, 4, 'W9', TAlphaColorRec.Honeydew);
  fGanttSeries1.AddGanttColor(0, 0, 5, 'France 2', TAlphaColorRec.Honeydew);
  fGanttSeries1.AddGanttColor(0, 0, 6, 'Plug TV', TAlphaColorRec.Honeydew);

  fGanttSeries2.AddGanttColor(0, 20, 0, 'test', TAlphaColorRec.Beige);
  fGanttSeries2.AddGanttColor(20, 30, 0, 'blim', TAlphaColorRec.Honeydew);
  fGanttSeries2.AddGanttColor(30, 60, 0, 'blim', TAlphaColorRec.Honeydew);

  fGanttSeries2.AddGanttColor(0, 10, 1, 'blam', TAlphaColorRec.Beige);
  fGanttSeries2.AddGanttColor(10, 30, 1, 'blom', TAlphaColorRec.Honeydew);
  fGanttSeries2.AddGanttColor(30, 70, 1, 'blom', TAlphaColorRec.Honeydew);

  fGanttSeries2.AddGanttColor(0, 20, 2, 'test', TAlphaColorRec.Beige);
  fGanttSeries2.AddGanttColor(20, 30, 2, 'blim', TAlphaColorRec.Honeydew);
  fGanttSeries2.AddGanttColor(30, 60, 2, 'blim', TAlphaColorRec.Honeydew);

  fGanttSeries2.AddGanttColor(0, 20, 3, 'test', TAlphaColorRec.Beige);
  fGanttSeries2.AddGanttColor(20, 30, 3, 'blim', TAlphaColorRec.Honeydew);
  fGanttSeries2.AddGanttColor(30, 60, 3, 'blim', TAlphaColorRec.Honeydew);

  fGanttSeries2.AddGanttColor(0, 10, 4, 'blam', TAlphaColorRec.Beige);
  fGanttSeries2.AddGanttColor(10, 30, 4, 'blom', TAlphaColorRec.Honeydew);
  fGanttSeries2.AddGanttColor(30, 70, 4, 'blom', TAlphaColorRec.Honeydew);

  fGanttSeries2.AddGanttColor(0, 20, 5, 'test', TAlphaColorRec.Beige);
  fGanttSeries2.AddGanttColor(20, 30, 5, 'blim', TAlphaColorRec.Honeydew);
  fGanttSeries2.AddGanttColor(30, 60, 5, 'blim', TAlphaColorRec.Honeydew);

  fGanttSeries2.AddGanttColor(0, 20, 6, 'test', TAlphaColorRec.Beige);
  fGanttSeries2.AddGanttColor(20, 30, 6, 'blim', TAlphaColorRec.Honeydew);
  fGanttSeries2.AddGanttColor(30, 60, 6, 'blim', TAlphaColorRec.Honeydew);

  // fLineSeries.AddX(5, '', TAlphaColorRec.Darksalmon);
  // fLineSeries.AddX(5, '', TAlphaColorRec.Darksalmon);
  fLineSeries.AddXY(5, fChart.LeftAxis.Minimum, '', TAlphaColorRec.Darksalmon);
  fLineSeries.AddXY(5, fChart.LeftAxis.Maximum + 0.5, '',
    TAlphaColorRec.Darksalmon);
  fLineSeries.LinePen.Width := 2;

  fGanttSeries1.Pointer.VertSize := 20;
  fGanttSeries2.Pointer.VertSize := 20;
  fChart.AddSeries(fGanttSeries1);
  fChart.AddSeries(fGanttSeries2);
  fChart.AddSeries(fLineSeries);



  // fChart.BottomAxis.Minimum := 0;
  // fChart.BottomAxis.Maximum := 10;
  // fChart.LeftAxis.Minimum := 0;
  // fChart.LeftAxis.Maximum := 2;

  // fGanttSeries1.Transparency := 50;
  // fGanttSeries2.Transparency := 50;

  // fGanttSeries1.Marks.Visible := True;
  // fGanttSeries1.Marks.Transparent := True;
  fGanttSeries2.Marks.Visible := True;
  fGanttSeries2.Marks.Transparent := True;
  fGanttSeries2.Marks.Clip := True;

end;

end.
