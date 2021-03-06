defmodule Xperiments.Experiments.RuleTest do
  use Xperiments.ModelCase
  alias Xperiments.Experiments.Rule

  @valid_attrs %{"parameter" => "lang", "type" => "string", "operator" => "==", "value" => "eu"}

  test "changest with valid attributes" do
    changeset = Rule.changeset(%Rule{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changest with invalid attributes" do
    changeset = Rule.changeset(%Rule{}, %{})
    refute changeset.valid?
  end

  test "validation of types and opertators" do
    changeset = Rule.changeset(%Rule{}, %{@valid_attrs | "operator" => "!"})
    refute changeset.valid?
    changeset = Rule.changeset(%Rule{}, %{@valid_attrs | "type" => "bad_type"})
    refute changeset.valid?
  end

  test "validate operators for string type" do
    chset = Rule.changeset(%Rule{}, %{@valid_attrs | "operator" => ">="})
    refute chset.valid?
    assert hd(chset.errors) == {:type, {"string types must have only '==' and '!=' operators", []}}
  end
  test "validate operators for boolean types" do
    chset = Rule.changeset(%Rule{}, %{@valid_attrs | "type" => "boolean", "operator" => "!="})
    refute chset.valid?
    assert hd(chset.errors) == {:type, {"boolean type must have only '==' operator and value must be 'true' or 'false'", []}}
  end

  test "validation of operators for RegEx type" do
    chset = Rule.changeset(%Rule{}, %{@valid_attrs | "type" => "regex", "operator" => "!="})
    refute chset.valid?
    assert hd(chset.errors) == {:type, {"regex types must have only '=~' operator", []}}
  end

  test "downcase of a parameter when saving" do
    chset = Rule.changeset(%Rule{}, %{@valid_attrs | "parameter" => "Lang"})
    assert chset.valid?
    assert chset.changes[:parameter] == "lang"
  end

  test "validation for value if type set to 'number'" do
    chset = Rule.changeset(%Rule{}, %{@valid_attrs | "type" => "number", "value" => "str"})
    refute chset.valid?
  end

  test "validaiton for valuer as a number" do
    chset = Rule.changeset(%Rule{}, %{@valid_attrs | "type" => "number", "value" => 3})
    assert chset.valid?
    # chset = Rule.changeset(%Rule{}, %{@valid_attrs | type: "number"})
    # refute chset.valid?
  end
end
