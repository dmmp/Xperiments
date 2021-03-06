defmodule XperimentsWeb.AssignerView do
  use XperimentsWeb, :view

  def render("experiments.json", %{experiments: experiments}) do
    experiments
  end

  def render("example.json", %{experiment: exp, variant: var}) do
    %{assign:
      [%{
          id: exp.id,
          name: exp.name,
          start_date: exp.start_date,
          end_date: exp.end_date,
          state: exp.state,
          variant: var
        }],
      unassign: []
      }
  end

end
