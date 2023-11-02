unit UFormaDePago;

interface
uses udTicket,sysUtils;
type
  TFormaDePago = class
  private
    fimp_efectivo: string;
    fimp_tarjeta: string;
    fimp_cc: string;
    fimp_os: string;
    fimp_co1: string;
    fimp_co2: string;
    fimp_ch: string;

    procedure SetImpEfectivo(const Value: string);
    procedure SetImpTarjeta(const Value: string);
    procedure SetImpCC(const Value: string);
    procedure SetImpOS(const Value: string);
    procedure SetImpCO1(const Value: string);
    procedure SetImpCO2(const Value: string);
    procedure SetImpCheque(const Value: string);


  public
    constructor Create;

    property ImpEfectivo: string read fimp_efectivo write SetImpEfectivo;
    property ImpTarjeta: string read fimp_tarjeta write SetImpTarjeta;
    property ImpCC: string read fimp_cc write SetImpCC;
    property ImpOS: string read fimp_os write SetImpOS;
    property ImpCO1: string read fimp_co1 write SetImpCO1;
    property ImpCO2: string read fimp_co2 write SetImpCO2;
    property ImpCheque: string read fimp_ch write SetImpCheque;
    procedure cargarFormaPago(ticket:TTicket);
    function calcularTotalPorAfiliado():Double;
    function PagaConEfectivo:boolean;
    function pagaConTarjeta:boolean;
    function pagaConCC:boolean;
    function pagaConOS:boolean;
    function pagaConCO1:boolean;
    function pagaConCO2:boolean;
    function pagaConCheque:boolean;

  end;

implementation

constructor TFormaDePago.Create;
begin
  fimp_efectivo := '0';
  fimp_tarjeta := '0';
  fimp_cc := '0';
  fimp_os := '0';
  fimp_co1 := '0';
  fimp_co2 := '0';
  fimp_ch := '0';
end;


procedure TFormaDePago.cargarFormaPago(ticket:TTicket);
begin
  impEfectivo:=floattostr(ticket.efectivo);
  impTarjeta:=floattostr(ticket.tarjeta);
  impCC:=floattostr(ticket.ctacte);
  impOS:=floattostr(ticket.importecargoos);
  impCO1:=floattostr(ticket.importecargoco1);
  impCO2:=floattostr(ticket.importecargoco2);
  impCheque:=floattostr(ticket.cheque);
end;

function TFormaDePago.calcularTotalPorAfiliado():double;
begin
  Result:= strtofloat(impEfectivo)+ strtofloat(impTarjeta)+ strtofloat(impCC) +strtofloat(impCheque);

end;

function TFormaDePago.PagaConEfectivo:boolean;
begin
  Result:= impEfectivo <> '0';
end;




function TFormaDePago.pagaConTarjeta:boolean;
begin
  Result:= impTarjeta <> '0';
end;


function TFormaDePago.pagaConCC:boolean;
begin
  Result:= fimp_cc <> '0';
end;


function TFormaDePago.pagaConOS:boolean;
begin
  Result:= fimp_os <> '0';
end;

function TFormaDePago.pagaConCO1:boolean;
begin
  Result:= fimp_CO1 <> '0';
end;


function TFormaDePago.pagaConCO2:boolean;
begin
  Result:= fimp_CO1 <> '0';
end;

function TFormaDePago.pagaConCheque:boolean;
begin
  Result:= fimp_ch <> '0';
end;


{Getters Y Setters}

procedure TFormaDePago.SetImpEfectivo(const Value: string);
begin
  if Value <>'' then
    fimp_efectivo := Value
  else
    fimp_efectivo := '0';
end;

procedure TFormaDePago.SetImpTarjeta(const Value: string);
begin
  if Value <>'' then
    fimp_tarjeta := Value
  else
    fimp_tarjeta := '0';
end;

procedure TFormaDePago.SetImpCC(const Value: string);
begin
  if Value <>'' then
    fimp_cc := Value
  else
    fimp_cc := '0';
end;

procedure TFormaDePago.SetImpOS(const Value: string);
begin
  if Value <>'' then
    fimp_os := Value
  else
    fimp_os := '0';
end;

procedure TFormaDePago.SetImpCO1(const Value: string);
begin
  if Value <>'' then
    fimp_co1 := Value
  else
    fimp_co1 := '0';
end;

procedure TFormaDePago.SetImpCO2(const Value: string);
begin
  if Value <>'' then
    fimp_co2 := Value
  else
    fimp_co2 := '0';
end;

procedure TFormaDePago.SetImpCheque(const Value: string);
begin
  if Value <>'' then
    fimp_ch := Value
  else
    fimp_ch := '0';
end;

end.
