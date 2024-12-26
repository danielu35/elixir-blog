defmodule Blog.Category do
  use Ecto.Schema
  import Ecto.Changeset

  schema "categories" do
    field :active, :boolean, default: false
    field :name, :string
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name, :active])
    |> validate_required([:name, :active])
  end
end
