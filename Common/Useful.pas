unit Useful;

interface

uses
  System.Classes, System.Hash, System.NetEncoding, System.SysUtils;

function XORSimple(const S, Key: string): string;
function RemoveBase64Padding(const ABase64: string): string;
function RestoreBase64Padding(const ABase64: string): string;

function EncodeStrBase64(AString: string): string;
function DecodeStrBase64(AString: string): string;

function EncryptString(const AText, AKey: string): string;
function DecryptString(const AText, AKey: string): string;
function EncryptPassword(const AText: string): string;
function DecryptPassword(const AText: string): string;

const
  Password_Default_XOR = 'AAssGHff67h7jjJHPP';

implementation

function XORSimple(const S, Key: string): string;
var
  I, KLen: Integer;
begin
  Result      := S;
  KLen        := Length(Key);
  for I       := 1 to Length(S) do
    Result[I] := Char(Byte(S[I]) xor Byte(Key[(I - 1) mod KLen + 1]));
end;

function RemoveBase64Padding(const ABase64: string): string;
var
  I: Integer;
begin
  Result := ABase64;
  I      := Length(Result);
  while (I > 0) and (Result[I] = '=') do
    Dec(I);
  Result := Copy(Result, 1, I);
end;

function RestoreBase64Padding(const ABase64: string): string;
var
  PadCount: Integer;
begin
  Result   := ABase64;
  PadCount := 4 - (Length(Result) mod 4);
  if PadCount < 4 then
    Result := Result + StringOfChar('=', PadCount);

end;

function EncodeStrBase64(AString: string): string;
begin
  Result := TNetEncoding.Base64.Encode(AString);
end;

function DecodeStrBase64(AString: string): string;
begin
  Result := TNetEncoding.Base64.Decode(AString);
end;

function EncryptString(const AText, AKey: string): string;
begin
  Result := XORSimple(AText, AKey);
  Result := EncodeStrBase64(Result);

  Result := RemoveBase64Padding(Result);
end;

function DecryptString(const AText, AKey: string): string;
begin
  Result := AText;

  Result := RestoreBase64Padding(Result);

  Result := DecodeStrBase64(Result);
  Result := XORSimple(Result, AKey);
end;

function EncryptPassword(const AText: string): string;
begin
  Result := EncryptString(AText, Password_Default_XOR);
end;

function DecryptPassword(const AText: string): string;
begin
  Result := DecryptString(AText, Password_Default_XOR);
end;

end.
