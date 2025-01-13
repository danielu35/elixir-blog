defmodule Blog.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :catagory_id, :id
    field :active, :boolean, default: false
    field :title, :string
    field :summery, :string
    field :content, :string
    belongs_to :user, Blog.Accounts.User
    belongs_to :category, Blog.Category

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :summery, :active, :user_id, :category_id])
    |> validate_required([:title, :summery, :active, :user_id, :category_id])
  end
end
