# defmodule Blog.Post do
#   use Ecto.Schema
#   import Ecto.Changeset

#   schema "posts" do
#     field :catagory_id, :id
#     field :active, :boolean, default: false
#     field :title, :string
#     field :summary, :string
#     field :content, :string
#     belongs_to :user, Blog.Accounts.User
#     belongs_to :category, Blog.Category

#     timestamps(type: :utc_datetime)
#   end

#   @doc false
#   def changeset(post, attrs) do
#     post
#     |> cast(attrs, [:title, :summary, :content, :active, :user_id, :category_id])
#     |> validate_required([:title, :summary, :content, :active, :user_id, :category_id])
#     |> validate_length(:title, min: 3, max: 100)
#   end
# end
defmodule Blog.Catalog.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :title, :string
    field :summary, :string
    field :content, :string
    field :active, :boolean, default: false
    field :image, :string
    belongs_to :user, Blog.Accounts.User
    belongs_to :category, Blog.Catalog.Category

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :summary, :content, :active, :user_id, :category_id, :image])
    |> validate_required([:title, :summary, :content, :active, :user_id, :category_id, :image])
    |> validate_length(:title, min: 3, max: 100)
  end
end
