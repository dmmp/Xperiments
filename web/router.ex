defmodule Xperiments.Router do
  use Xperiments.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :browser do
    plug :accepts, ["html"]
  end

  scope "/api/v1", Xperiments do
    pipe_through :api

    resources "/applications", ApplicationController, only: [:index], param: :name do
      resources "/experiments", ExperimentController, except: [:delete, :new] do
        put "/state", ExperimentController, :change_state, as: :state
        get "/exclusions", ExperimentController, :exclusions, as: :exclusions
      end
    end
  end

  scope "/", Xperiments do
    pipe_through :browser

    forward "/", HomeController, :index
  end
end
