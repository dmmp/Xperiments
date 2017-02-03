defmodule Xperiments.ExperimentTest do
  use Xperiments.ModelCase
  use Timex

  import Xperiments.Factory
  alias Xperiments.{Experiment, Application}

  def build_date(shift_days) do
    Timex.now()
    |> Timex.shift(days: shift_days)
    |> Timex.format!("{ISO:Extended:Z}")
  end

  setup_all do
    [
      valid_attrs: %{description: "some content",
                     end_date: build_date(3),
                     sampling_rate: 100,
                     max_users: 42,
                     name: "some content",
                     start_date: build_date(1)},
      experiment:  %Experiment{application: %Application{}}
    ]
  end

  test "changeset with valid attributes", context do
    changeset = Experiment.changeset(context[:experiment], context[:valid_attrs])
    assert changeset.valid?
  end

  test "changeset with invalid attributes", context do
    changeset = Experiment.changeset(context[:experiment], %{})
    refute changeset.valid?
  end

  test "number validation when a field can be set or not", context do
    changeset = Experiment.changeset(context[:experiment], %{context[:valid_attrs] | max_users: 0})
    refute changeset.valid?
    assert changeset.errors == [max_users: {"must be greater than %{number}", [validation: :number, number: 0]}]
  end

  test "validate embedded fields: variants and rules", context do
    variants = [
      %{name: "var a", allocation: 1, description: "nothing", payload: "test"}
    ]
    rules = [
      %{parameter: "lang", type: "string", operator: "==", value: "ru"}
    ]
    changeset = Experiment.changeset_update(context[:experiment],
      Map.merge(context[:valid_attrs], %{variants: variants, rules: rules}))
    assert changeset.valid?

    changeset = Experiment.changeset_update(context[:experiment], context[:valid_attrs])
    refute changeset.valid?
  end

  test "changeset with a start date greater than an end date", context do
    attrs = %{context[:valid_attrs] | end_date: build_date(-1)}
    changeset = Experiment.changeset(context[:experiment], attrs)
    refute changeset.valid?
  end

  test "changeset with a date in the past", context do
    attrs = %{context[:valid_attrs] | start_date: build_date(-1)}
    changeset = Experiment.changeset(context[:experiment], attrs)
    refute changeset.valid?
  end

  test "states changes" do
    experiment = insert(:experiment)
    assert experiment.state == "draft"
    assert Experiment.can_run?(experiment) == true
    assert Experiment.can_terminate?(experiment) == false

    updated_exp = Experiment.run(experiment)
    |> Xperiments.Repo.update!
    assert updated_exp.state == "running"

    invalid_changeset = Experiment.run(updated_exp)
    refute invalid_changeset.valid?
  end
end
