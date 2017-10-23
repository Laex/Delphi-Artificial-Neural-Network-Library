program cascade_train;

{$APPTYPE CONSOLE}
{$POINTERMATH ON}

uses
  SysUtils,
  delphi_fann in '..\..\source\delphi_fann.pas';

var
  ann: pfann;
  train_data, test_data: pfann_train_data;
  desired_error: float = 0.0;
  max_neurons: Cardinal = 30;
  neurons_between_reports: Cardinal = 1;
  bit_fail_train, bit_fail_test: Cardinal;
  mse_train, mse_test: float;
  i: Cardinal;
  output: pfann_type_array;
  steepness: fann_type;
  multi: Integer = 0;
  activation: Integer;
  training_algorithm: Integer = FANN_TRAIN_RPROP;

begin
  try

    WriteLn('Reading data.');

    train_data := fann_read_train_from_file('..\..\datasets\parity8.train');
    test_data := fann_read_train_from_file('..\..\datasets\parity8.test');

    fann_scale_train_data(train_data, -1, 1);
    fann_scale_train_data(test_data, -1, 1);

    WriteLn('Creating network.');

    ann := fann_create_shortcut(2, fann_num_input_train_data(train_data), fann_num_output_train_data(train_data));

    fann_set_training_algorithm(ann, training_algorithm);
    fann_set_activation_function_hidden(ann, FANN_SIGMOID_SYMMETRIC);
    fann_set_activation_function_output(ann, FANN_LINEAR);
    fann_set_train_error_function(ann, FANN_ERRORFUNC_LINEAR);

    if (multi = 0) then
    begin
      (* steepness := 0.5; *)
      steepness := 1;
      fann_set_cascade_activation_steepnesses(ann, @steepness, 1);
      (* activation := FANN_SIN_SYMMETRIC; *)
      activation := FANN_SIGMOID_SYMMETRIC;

      fann_set_cascade_activation_functions(ann, @activation, 1);
      fann_set_cascade_num_candidate_groups(ann, 8);
    end;

    if (training_algorithm <> FANN_TRAIN_QUICKPROP) then
    begin
      fann_set_learning_rate(ann, 0.35);
      fann_randomize_weights(ann, -2.0, 2.0);
    end;

    fann_set_bit_fail_limit(ann, 0.9);
    fann_set_train_stop_function(ann, FANN_STOPFUNC_BIT);
    fann_print_parameters(ann);

    fann_save(ann, '..\..\result\cascade_train2.net');

    WriteLn('Training network.');

    fann_cascadetrain_on_data(ann, train_data, max_neurons, neurons_between_reports, desired_error);

    fann_print_connections(ann);

    mse_train := fann_test_data(ann, train_data);
    bit_fail_train := fann_get_bit_fail(ann);
    mse_test := fann_test_data(ann, test_data);
    bit_fail_test := fann_get_bit_fail(ann);

    WriteLn(#13#10, Format('Train error: %f, Train bit-fail: %d, Test error: %f, Test bit-fail: %d', [mse_train, bit_fail_train, mse_test,
      bit_fail_test]), #13#10);

    for i := 0 to train_data^.num_data-1 do
    begin
      output := fann_run(ann, train_data^.input[i]);
      if ((train_data^.output[i][0] >= 0) and (output[0] <= 0)) or ((train_data^.output[i][0] <= 0) and (output[0] >= 0)) then
        WriteLn(Format('ERROR: %f does not match %f', [train_data^.output[i][0], output[0]]));
    end;

    WriteLn('Saving network.');

    fann_save(ann, '..\..\result\cascade_train.net');

    WriteLn('Cleaning up.');
    fann_destroy_train(train_data);
    fann_destroy_train(test_data);
    fann_destroy(ann);
    Readln;
  except
    on E: Exception do
    begin
      WriteLn(E.ClassName, ': ', E.Message);
      readln;
    end;
  end;

end.
