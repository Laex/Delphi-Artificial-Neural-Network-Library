program TensorFlowTest;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  tensorflow in '..\source\tensorflow.pas';

Var
  V: pTFChar;
  s: pTF_Status;

begin
  try
    V := TF_Version();
    Writeln(string(V));

    s := TF_NewStatus();
    Assert(TF_GetCode(s) = TF_OK);
    Assert(TF_Message(s) = '');
    TF_SetStatus(s, TF_CANCELLED, 'cancel');
    Assert(TF_GetCode(s) = TF_CANCELLED);
    Assert(TF_Message(s) = 'cancel');
    TF_DeleteStatus(s);

    Readln;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end.
