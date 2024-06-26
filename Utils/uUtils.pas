unit uUtils;
interface

  uses sysutils;

  type TFechaUtils = class
    public
    class function EstaFechaDentroDelRango(fecha_desde:string; fecha_hasta: string): Boolean;

  end;

  type TUtils = class
    public
    class function LeftPad(S: string; Ch: Char; Len: Integer): string;
    class function RightPad(S: string; Ch: Char; Len: Integer): string;
    class function CadLongitudFija(cadena : string; longitud : Integer; posicionIzquierda : boolean; valorRelleno : string) : string;
    class function esNumerico(cadena:string): Boolean;
    class function esCampoVacio(const Campo: string): Boolean;
    class function contienePalabra(palabra:string;texto:string):boolean;
  end;



implementation

class function TUtils.esCampoVacio(const Campo: string): Boolean;
begin
  // Utiliza la funci�n Trim para eliminar espacios en blanco al inicio y al final
  // de la cadena, y luego verifica si la cadena resultante est� vac�a.
  Result := Trim(Campo) = '';
end;


class function TUtils.contienePalabra(palabra:string;texto:string): Boolean;
begin
  Result := Pos(palabra,texto) > 0;
end;


class function TUtils.LeftPad(S: string; Ch: Char; Len: Integer): string;
var
  RestLen: Integer;
begin
  Result  := S;
  RestLen := Len - Length(s);
  if RestLen < 1 then Exit;
  Result := S + StringOfChar(Ch, RestLen);
end;

class function TUtils.RightPad(S: string; Ch: Char; Len: Integer): string;
var
  RestLen: Integer;
begin
  Result  := S;
  RestLen := Len - Length(s);
  if RestLen < 1 then Exit;
  Result := StringOfChar(Ch, RestLen) + S;
end;

class function TUtils.cadLongitudFija (cadena : string; longitud : Integer; posicionIzquierda : boolean; valorRelleno : string) : string;
var
  i: integer;
begin
  if length(cadena) > longitud then
    cadena := copy(cadena, 1, longitud)
  else
  begin
    for i := 1 to longitud - Length(cadena) do
      if posicionIzquierda then
        cadena := valorRelleno + cadena
      else
        cadena := cadena + valorRelleno;
  end;
  Result := cadena;
end;

   class function TUtils.esNumerico(cadena: string):boolean;
    var
    num:double;
    begin
      try
        // Intenta convertir el string en un n�mero de punto flotante
        num := StrToFloat(cadena);
        esNumerico := True;
      except
        // Si la conversi�n falla, el string no es num�rico
        esNumerico := False;
      end;
    end;

    {
      Descripci�n: Esta funci�n verifica si una fecha est� dentro de un rango espec�fico.
      @param fecha_desde: La fecha de inicio del rango en formato string.
      @param fecha_hasta: La fecha de fin del rango en formato string.
      @return True si la fecha actual est� dentro del rango, False en caso contrario.
    }
    class function TFechaUtils.EstaFechaDentroDelRango(fecha_desde:string; fecha_hasta: string): Boolean;
    begin
      Result := (Now > StrToDateTime(fecha_desde)) and (Now < StrToDateTime(fecha_hasta));
    end;





end.
