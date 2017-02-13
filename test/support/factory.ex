defmodule Xperiments.Factory do
  use ExMachina.Ecto, repo: Xperiments.Repo
  use Timex

  def user_factory do
    %Xperiments.User{
      name: sequence("Lev"),
      email: sequence(:email, &"lev.tolstoy#{&1}@wetransfer.com")
    }
  end

  def application_factory do
    %Xperiments.Application{
      name: sequence("frontend")
    }
  end

  def experiment_factory do
    %Xperiments.Experiment{
      name: sequence("Experiment"),
      description: "Change some text",
      start_date: Timex.now |> Timex.shift(hours: 3),
      end_date: Timex.shift(Timex.now(), days: 3),
      max_users: 100,
      application: build(:application),
      variants: [variant(100)]
    }
  end

  def experiment_with_balanced_variants do
    app = insert(:application, name: "test_app")
    build(:experiment, state: "running", application: app) |> with_balanced_variants |> insert
  end


  def variant(allocation \\ 100) do
    payload = Enum.reduce(0..1000, "", fn _, acc -> acc <> "dummy" end)
    %{
      name: sequence("Variant"),
      allocation: allocation,
      description: "bla bla",
      payload: payload,
      control_group: false
    }
  end

  def with_balanced_variants(exp) do
    variants = [
      variant(30),
      variant(20),
      variant(50)
    ]
    %{ exp | variants: variants }
  end

end
