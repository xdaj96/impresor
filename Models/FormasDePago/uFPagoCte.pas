unit uFPagoCte;

interface
  uses uBaseFormaPago;
  type
  TFPagoCTE = class(TBaseFormaPago)
  private
 
    fCodCtaCte: string;
    fCodSubCta: string;
    fImpCtaCte: Double;
    fImpSubCtaCte: Double;
  public
    
    property CodCtaCte: string read fCodCtaCte write fCodCtaCte;
    property CodSubCta: string read fCodSubCta write fCodSubCta;
    property ImpCtaCte: Double read fImpCtaCte write fImpCtaCte;
    property ImpSubCtaCte: Double read fImpSubCtaCte write fImpSubCtaCte;
  end;
implementation

end.
