defmodule Blog.Category do
  use Ecto.Schema
  import Ecto.Changeset

  schema "categories" do
    field :active, :boolean, default: false
    field :name, :string
    belongs_to :user, Blog.User
    has_many :posts, Blog.Post

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name, :active, :user_id])
    |> validate_required([:name, :active, :user_id])
  end
end
