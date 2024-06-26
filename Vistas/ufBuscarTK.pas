unit ufBuscarTK;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,udTicket,uUtils,UdmFacturador,Xml.XMLDoc, Xml.XMLIntf;

type
  TfBuscarTK = class(TForm)
    Label1: TLabel;
    eNroTK: TEdit;
    BitBtn1: TBitBtn;
    combotipo: TComboBox;
    Label2: TLabel;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure eNroTKKeyPress(Sender: TObject; var Key: Char);
  private
    ticket:TTicket;
    procedure iniciarComboTipoComprobante;
    procedure ObtenerTipoComprobante(const XML: string);
    { Private declarations }
  public
    { Public declarations }
    rutaTicket:string;
    archivo:string;
    TipoComprobante: string;
    procedure setTicket(unTicket:TTicket);
  end;

var
  fBuscarTK: TfBuscarTK;

implementation

{$R *.dfm}

procedure TfBuscarTK.BitBtn1Click(Sender: TObject);
var
  nroTicket:string;
begin
 archivo:= ticket.fiscla_pv+(tUtils.rightpad(eNroTK.Text, '0', 8));
 rutaTicket:=  ticket.errores + archivo+'.xml';
 if not FileExists(rutaTicket) then
 begin
    ShowMessage('El numero de ticket no existe');
    rutaTicket:='';
    exit;
 end;
 ObtenerTipoComprobante('');





 ModalResult := mrOk;
end;

procedure TfBuscarTK.eNroTKKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
     BitBtn1.Click;
  if key = #27 then
  begin
     rutaTicket:= '';
     ModalResult := mrOk;
  end;
end;

procedure TfBuscarTK.FormShow(Sender: TObject);
begin
  eNroTK.SetFocus;
  dmFacturador.AbrirConexion;
  iniciarComboTipoComprobante;

end;

procedure TfBuscarTK.ObtenerTipoComprobante(const XML: string);
var
  XMLDocument: IXMLDocument;

begin
  XMLDocument := TXMLDocument.Create(nil);
  try
    XMLDocument.LoadFromFile(rutaTicket);

    // Encuentra el elemento tipo_comprobante y obt�n su valor
    TipoComprobante := XMLDocument.DocumentElement.ChildNodes['Encabezado'].ChildNodes['tipo_comprobante'].Text;

  finally
    XMLDocument := nil;
  end;
end;



procedure TfBuscarTK.setTicket(unTicket: TTicket);
begin
  ticket:= unTicket;
end;

procedure TfBuscarTK.iniciarComboTipoComprobante;
begin
  dmFacturador.qcomprobante.Close;
  dmFacturador.qcomprobante.SQL.Clear;
  dmFacturador.qcomprobante.SQL.Append('select TIP_COMPROBANTE, TIP_IMPRE from vtmatipcomprob where tip_comprobante like :LETRA  AND MAR_TIPOPROCESO=''F'' order by 1 desc');
  dmFacturador.qcomprobante.ParamByName('LETRA').AsString := '%' + dmFacturador.getPuntoVenta + '%';
  dmFacturador.qcomprobante.Open;
  dmFacturador.qcomprobante.First;
  while not dmFacturador.qcomprobante.Eof do
  begin
    combotipo.Items.Add(dmFacturador.qcomprobante.Fields[0].Text);
    dmFacturador.qcomprobante.Next;
  end;
  combotipo.ItemIndex := 0;
end;

end.
