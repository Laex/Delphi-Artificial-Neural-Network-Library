program XorConsole;

{$APPTYPE CONSOLE}
{$POINTERMATH ON}

uses
  SysUtils,
  delphi_fann in '..\..\source\delphi_fann.pas';

var
  ann: PFann;
  inputs: array [0 .. 1] of fann_type;
  calc_out: PFann_Type_array;
  i, j: integer;
  train_data: PFann_Train_Data;

begin
  try
    ann := fann_create_standard(3, 2, 3, 1);

    train_data := fann_read_train_from_file('..\datasets\xor.data');

    fann_set_activation_steepness_hidden(ann, 0.5);
    fann_set_activation_steepness_output(ann, 0.5);

    fann_set_activation_function_hidden(ann, FANN_SIGMOID);
    fann_set_activation_function_output(ann, FANN_SIGMOID);

    fann_set_train_stop_function(ann, FANN_STOPFUNC_BIT);
    fann_set_bit_fail_limit(ann, 0.001);

    fann_init_weights(ann, train_data);

    fann_train_on_data(ann, train_data, 500000, 1000, 0.001);

    for i := 0 to 1 do
      for j := 0 to 1 do
      begin
        inputs[0] := i;
        inputs[1] := j;

        calc_out := fann_run(ann, @inputs[0]);
        writeln(Format('%f Xor %f = %f', [inputs[0], inputs[1], calc_out[0]]));

      end;

    readln;

    fann_destroy(ann);
  except
    on E: Exception do
    begin
      writeln(E.ClassName, ': ', E.Message);
      readln;
    end;
  end;

end.
