# defmodule Blog.Category do
#   use Ecto.Schema
#   import Ecto.Changeset

#   schema "categories" do
#     field :active, :boolean, default: false
#     field :name, :string
#     belongs_to :user, Blog.User
#     has_many :posts, Blog.Post

#     timestamps(type: :utc_datetime)
#   end

#   @doc false
#   def changeset(category, attrs) do
#     category
#     |> cast(attrs, [:name, :active, :user_id])
#     |> validate_required([:name, :active, :user_id])
#   end
# end
defmodule Blog.Catalog.Category do
  use Ecto.Schema
  import Ecto.Changeset

  schema "categories" do
    field :active, :boolean, default: false
    field :name, :string
    field :description, :string
    belongs_to :user, Blog.User
    has_many :posts, Blog.Catalog.Post

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name, :description, :active])
    |> validate_required([:name])
  end
end
